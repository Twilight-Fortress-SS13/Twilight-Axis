// TA EDIT START
import { useEffect, useMemo, useRef, useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  Input,
  ProgressBar,
  Section,
  Stack,
  Table,
  Tabs,
  TextArea,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { processedText } from '../process';
import { sanitizeText } from '../sanitize';

type PreviewLayer = {
  icon: string;
  icon_state: string;
  color: string | null;
  channel: string;
};

type LoadoutItem = {
  name: string;
  label: string;
  desc: string;
  categories: string[];
  triumph_cost: number;
  donator_item: boolean;
  donator_tier: number;
  color_channels: Record<string, string>;
  preview_layers: PreviewLayer[] | null;
  requirements: string | null;
};

type SelectedItem = {
  name: string;
  colors: Record<string, string | null>;
  color_labels: Record<string, string | null>;
  custom_name: string | null;
  custom_desc: string | null;
};

type Data = {
  categories: string[];
  items: LoadoutItem[];
  selected: SelectedItem[];
  subscription_loaded: boolean | number;
  locks: Record<string, string>;
  max_slots: number;
  donator_tier: number;
  triumph_discount: number;
  total_triumph_cost: number;
  effective_triumph_cost: number;
  player_triumphs: number;
};

const ITEMS_PER_PAGE = 50;
const DONATOR_TIER_COLORS: Record<number, string> = {
  1: 'average',
  2: 'blue',
  3: 'purple',
  4: 'pink',
  5: 'red',
};

const tintKey = (color: string | null | undefined): string | null => {
  if (typeof color !== 'string') {
    return null;
  }
  let hex = color.replace(/^#/, '').toLowerCase();
  if (hex.length === 3 || hex.length === 4) {
    hex = hex.replace(/./g, '$&$&');
  }
  return /^[0-9a-f]{6}([0-9a-f]{2})?$/.test(hex) ? hex : null;
};

const layerColor = (layer: PreviewLayer, selected?: SelectedItem) =>
  selected?.colors[layer.channel] || layer.color;

const TintFilters = (props: { colors: string[] }) => (
  <svg width={0} height={0} style={{ position: 'absolute' }}>
    <defs>
      {props.colors.map((color) => {
        const [red, green, blue, alpha = 1] = (color.match(/../g) || []).map(
          (pair) => parseInt(pair, 16) / 255,
        );
        return (
          <filter
            key={color}
            id={`loadout-tint-${color}`}
            colorInterpolationFilters="sRGB"
          >
            <feColorMatrix
              type="matrix"
              values={`${red} 0 0 0 0 0 ${green} 0 0 0 0 0 ${blue} 0 0 0 0 0 ${alpha} 0`}
            />
          </filter>
        );
      })}
    </defs>
  </svg>
);

const ItemIcon = (props: { item: LoadoutItem; selected?: SelectedItem }) => (
  <Box position="relative" width="40px" height="40px" mr={1}>
    {!props.item.preview_layers?.length && <Box color="label">?</Box>}
    {props.item.preview_layers?.map((layer) => {
      const color = tintKey(layerColor(layer, props.selected));
      return (
        <DmIcon
          key={`${layer.icon}:${layer.icon_state}:${layer.channel}`}
          icon={layer.icon}
          icon_state={layer.icon_state}
          fallback={
            layer.channel === 'primary' ? <Box color="label">?</Box> : null
          }
          position="absolute"
          top={0}
          left={0}
          width="40px"
          height="40px"
          style={{
            objectFit: 'contain',
            filter: color ? `url(#loadout-tint-${color})` : undefined,
          }}
        />
      );
    })}
  </Box>
);

const escapeHtml = (value: string) =>
  value.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

const ItemEditor = (props: {
  item: LoadoutItem;
  selected: SelectedItem;
  previewText: boolean;
}) => {
  const { act } = useBackend<Data>();
  const { item, selected, previewText } = props;
  const [name, setName] = useState(selected.custom_name || '');
  const [description, setDescription] = useState(selected.custom_desc || '');
  const commit = (action: string, value: string) =>
    act(action, { name: item.name, value });

  return (
    <Table.Row>
      <Table.Cell colSpan={3}>
        <Section mb={0.5} ml={2}>
          <Stack wrap align="center" mb={1}>
            {Object.entries(item.color_channels).map(([channel, label]) => (
              <Stack.Item key={channel}>
                <Button
                  icon="palette"
                  tooltip={selected.color_labels[channel] || label}
                  onClick={() => act('set_color', { name: item.name, channel })}
                >
                  {selected.colors[channel] && (
                    <Box
                      inline
                      mr={0.5}
                      width="10px"
                      height="10px"
                      backgroundColor={selected.colors[channel] || undefined}
                    />
                  )}
                  {label}
                </Button>
              </Stack.Item>
            ))}
            {Object.keys(item.color_channels).length > 0 && (
              <Stack.Item>
                <Button
                  icon="undo"
                  onClick={() => act('clear_colors', { name: item.name })}
                >
                  Сбросить цвета
                </Button>
              </Stack.Item>
            )}
          </Stack>
          <Box color="label" mb={0.5}>
            Название — до 64 символов
          </Box>
          {previewText ? (
            <Box
              mb={1}
              dangerouslySetInnerHTML={processedText(escapeHtml(name))}
            />
          ) : (
            <Input
              fluid
              mb={1}
              value={name}
              maxLength={64}
              placeholder={item.label}
              onChange={setName}
              onEnter={(value) => commit('set_custom_name', value)}
              onBlur={(value) => commit('set_custom_name', value)}
            />
          )}
          <Box color="label" mb={0.5}>
            Описание — до 1024 символов
          </Box>
          {previewText ? (
            <Box
              minHeight="60px"
              dangerouslySetInnerHTML={processedText(escapeHtml(description))}
            />
          ) : (
            <TextArea
              fluid
              height="70px"
              value={description}
              maxLength={1024}
              placeholder="Описание предмета..."
              onChange={setDescription}
              onBlur={(value) => commit('set_custom_desc', value)}
              dontUseTabForIndent
            />
          )}
        </Section>
      </Table.Cell>
    </Table.Row>
  );
};

export const LoadoutMenu = () => {
  const { data, act } = useBackend<Data>();
  const [category, setCategory] = useState('Всё');
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(0);
  const [compact, setCompact] = useState(false);
  const [previewText, setPreviewText] = useState(false);
  const catalogRef = useRef<HTMLDivElement>(null);
  const items = data.items || [];
  const selected = data.selected || [];
  const locks = data.locks || {};
  const selectedByName = new Map(selected.map((item) => [item.name, item]));
  const query = search.trim().toLocaleLowerCase();
  const filteredItems = useMemo(
    () =>
      items
        .filter(
          (item) =>
            (query ||
              category === 'Всё' ||
              item.categories.includes(category)) &&
            (!query || item.label.toLocaleLowerCase().includes(query)),
        )
        .sort((first, second) => first.label.localeCompare(second.label)),
    [items, category, query],
  );
  const pageCount = Math.max(
    1,
    Math.ceil(filteredItems.length / ITEMS_PER_PAGE),
  );
  const currentPage = Math.min(page, pageCount - 1);
  useEffect(() => {
    if (catalogRef.current) {
      catalogRef.current.scrollTop = 0;
    }
  }, [currentPage, category, query]);

  const visibleItems = filteredItems.slice(
    currentPage * ITEMS_PER_PAGE,
    (currentPage + 1) * ITEMS_PER_PAGE,
  );
  const colors = compact
    ? []
    : Array.from(
        new Set(
          visibleItems.flatMap((item) =>
            (item.preview_layers || [])
              .map((layer) =>
                tintKey(layerColor(layer, selectedByName.get(item.name))),
              )
              .filter((color): color is string => color !== null),
          ),
        ),
      );
  const limit = data.max_slots || 0;
  const full = selected.length >= limit;

  return (
    <Window width={1000} height={760} title="Лодаут">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow>
                  <ProgressBar value={limit ? selected.length / limit : 0}>
                    {data.subscription_loaded
                      ? `Выбрано предметов: ${selected.length} / ${limit}`
                      : 'Загружаются данные подписки...'}
                  </ProgressBar>
                </Stack.Item>
                {!!data.donator_tier && (
                  <Stack.Item
                    color={DONATOR_TIER_COLORS[data.donator_tier] || 'label'}
                  >
                    Меценат: {data.donator_tier}
                  </Stack.Item>
                )}
                <Stack.Item>
                  <Button icon="heart" onClick={() => act('boosty')}>
                    Поддержать проект
                  </Button>
                </Stack.Item>
              </Stack>
              <Box color="label" mt={1}>
                Предметы выдаются через статую или дерево. Эликсиры меняют
                внешний вид подходящего снаряжения.
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Tabs fluid style={{ flexWrap: 'wrap' }}>
              {(data.categories || []).map((name) => (
                <Tabs.Tab
                  key={name}
                  selected={name === category}
                  onClick={() => {
                    setCategory(name);
                    setPage(0);
                  }}
                >
                  {name}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item>
            <Stack align="center">
              <Stack.Item grow>
                <Input
                  fluid
                  placeholder="Поиск по всем категориям..."
                  value={search}
                  onChange={(value) => {
                    setSearch(value);
                    setPage(0);
                  }}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="list"
                  selected={compact}
                  onClick={() => setCompact(!compact)}
                >
                  Компактно
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="eye"
                  selected={previewText}
                  onClick={() => setPreviewText(!previewText)}
                >
                  Просмотр текста
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button.Confirm
                  icon="trash"
                  color="bad"
                  disabled={!selected.length}
                  confirmContent="Очистить всё?"
                  onClick={() => act('clear_all')}
                >
                  Очистить
                </Button.Confirm>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack align="center">
              <Stack.Item grow color="label">
                Найдено предметов: {filteredItems.length}
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="chevron-left"
                  disabled={currentPage === 0}
                  onClick={() => setPage(currentPage - 1)}
                >
                  Назад
                </Button>
              </Stack.Item>
              <Stack.Item>
                {currentPage + 1} / {pageCount}
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="chevron-right"
                  disabled={currentPage === pageCount - 1}
                  onClick={() => setPage(currentPage + 1)}
                >
                  Далее
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable ref={catalogRef}>
              <TintFilters colors={colors} />
              {!filteredItems.length && (
                <Box color="label" textAlign="center" p={2}>
                  Предметы не найдены.
                </Box>
              )}
              <Table>
                <Table.Row header>
                  <Table.Cell>Предмет</Table.Cell>
                  <Table.Cell textAlign="center">Доступ</Table.Cell>
                  <Table.Cell textAlign="center">Триумфы</Table.Cell>
                </Table.Row>
                {visibleItems.flatMap((item) => {
                  const selection = selectedByName.get(item.name);
                  const lock = locks[item.name];
                  let accessColor = 'label';
                  if (lock) {
                    accessColor =
                      DONATOR_TIER_COLORS[item.donator_tier] || 'average';
                  }

                  return [
                    <Table.Row key={item.name}>
                      <Table.Cell py={0.5}>
                        <Stack align="center">
                          <Stack.Item>
                            <Button
                              selected={!!selection}
                              disabled={
                                !data.subscription_loaded ||
                                (!selection && (!!lock || full))
                              }
                              tooltip={
                                lock ||
                                (selection
                                  ? 'Убрать предмет'
                                  : 'Выбрать предмет')
                              }
                              onClick={() =>
                                act('toggle_item', { name: item.name })
                              }
                            >
                              {selection ? '✓' : '+'}
                            </Button>
                          </Stack.Item>
                          {!compact && (
                            <Stack.Item>
                              <ItemIcon item={item} selected={selection} />
                            </Stack.Item>
                          )}
                          <Stack.Item grow>
                            <Box bold={!!selection}>{item.label}</Box>
                            {!compact && (
                              <Box
                                color="label"
                                fontSize={0.9}
                                dangerouslySetInnerHTML={{
                                  __html: sanitizeText(item.desc),
                                }}
                              />
                            )}
                            {item.requirements && !compact && (
                              <Box color="label" fontSize={0.85} mt={0.3}>
                                Подходит для: {item.requirements}
                              </Box>
                            )}
                          </Stack.Item>
                        </Stack>
                      </Table.Cell>
                      <Table.Cell color={accessColor} textAlign="center">
                        {lock || '—'}
                      </Table.Cell>
                      <Table.Cell textAlign="center">
                        {item.triumph_cost || '—'}
                      </Table.Cell>
                    </Table.Row>,
                    selection && (
                      <ItemEditor
                        key={`${item.name}-editor`}
                        item={item}
                        selected={selection}
                        previewText={previewText}
                      />
                    ),
                  ];
                })}
              </Table>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow>
                  <Box>
                    Стоимость: {data.effective_triumph_cost || 0} триумфов
                    {' | '}На счету: {data.player_triumphs || 0}
                  </Box>
                  {!!data.triumph_discount && (
                    <Box color="gold" mt={0.3}>
                      Скидка:{' '}
                      {Math.min(data.total_triumph_cost, data.triumph_discount)}
                      {' / '}
                      {data.triumph_discount} триумфов
                    </Box>
                  )}
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('cancel')}>Отмена</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="good"
                    icon="check"
                    disabled={!data.subscription_loaded}
                    onClick={() => act('confirm')}
                  >
                    Сохранить
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
// TA EDIT END
