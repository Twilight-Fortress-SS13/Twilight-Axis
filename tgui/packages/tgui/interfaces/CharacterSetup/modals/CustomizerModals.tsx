import { useEffect, useMemo, useState } from 'react';
import { Box, Button, DmIcon, Input, Section, Stack } from 'tgui-core/components';

import type { ActiveCustomizer, CustomizerOption, Data } from '../types';
import {
  CompactRow,
  ModalShell,
  cardStyle,
  selectedCardStyle,
  swatch,
} from '../components/shared';

const OptionTile = (props: {
  option: CustomizerOption;
  selected: boolean;
  showImage: boolean;
  onClick: () => void;
}) => (
  <Box
    p={0.45}
    style={{
      ...(props.selected ? selectedCardStyle : cardStyle),
      cursor: 'pointer',
      minHeight: props.showImage ? '156px' : '44px',
      background: 'rgba(255,255,255,0.04)',
    }}
    onClick={props.onClick}
  >
    {props.showImage ? (
      <>
        <Box
          style={{
            height: '108px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            background: 'rgba(0,0,0,0.3)',
            marginBottom: '6px',
          }}
        >
          {props.option.icon_class_name ? (
            <Box className={props.option.icon_class_name} />
          ) : props.option.icon ? (
            <DmIcon
              icon={props.option.icon}
              icon_state={props.option.icon_state || ''}
              width="96px"
              height="96px"
            />
          ) : (
            <Box color="label">Нет</Box>
          )}
        </Box>
        <Box textAlign="center" style={{ lineHeight: 1.08, overflowWrap: 'anywhere', fontSize: '14px' }}>
          {props.option.name}
        </Box>
      </>
    ) : (
      <Box>{props.option.name}</Box>
    )}
  </Box>
);

const HairControlButton = (props: {
  label: string;
  value?: string | null;
  color?: string | null;
  onClick: () => void;
}) => (
  <Button compact onClick={props.onClick} style={{ minWidth: '112px' }}>
    <Box inline mr={0.35}>{props.label}</Box>
    <Box inline bold>{props.value || 'Нет'}{swatch(props.color)}</Box>
  </Button>
);

export const HairPopup = (props: {
  active: ActiveCustomizer | null;
  options: CustomizerOption[];
  act: (action: string, payload?: Record<string, unknown>) => void;
  onClose: () => void;
}) => {
  const [search, setSearch] = useState('');

  useEffect(() => {
    setSearch('');
  }, [props.active?.id]);

  const filteredOptions = useMemo(() => {
    const needle = search.trim().toLowerCase();
    if (!needle) {
      return props.options;
    }
    return props.options.filter((option) => option.name.toLowerCase().includes(needle));
  }, [props.options, search]);

  if (!props.active) {
    return (
      <Box
        p={0.8}
        style={{
          position: 'absolute',
          top: '34px',
          right: '8px',
          width: '430px',
          maxWidth: 'calc(100% - 16px)',
          boxSizing: 'border-box',
          zIndex: 24,
          border: '1px solid rgba(255,255,255,0.22)',
          background: 'rgba(0,0,0,0.97)',
          boxShadow: '0 10px 30px rgba(0,0,0,0.65)',
        }}
      >
        <Stack align="center">
          <Stack.Item grow>
            <Box color="label">Загрузка списка волос...</Box>
          </Stack.Item>
          <Stack.Item>
            <Button compact tooltip="Закрыть" onClick={props.onClose}>
              ×
            </Button>
          </Stack.Item>
        </Stack>
      </Box>
    );
  }

  const active = props.active;

  return (
    <Box
      p={0.8}
      style={{
        position: 'absolute',
        top: '34px',
        right: '8px',
        bottom: '34px',
        width: '430px',
        maxWidth: 'calc(100% - 16px)',
        boxSizing: 'border-box',
        zIndex: 24,
        display: 'flex',
        flexDirection: 'column',
        minHeight: 0,
        overflow: 'hidden',
        border: '1px solid rgba(255,255,255,0.22)',
        background: 'rgba(0,0,0,0.97)',
        boxShadow: '0 10px 30px rgba(0,0,0,0.65)',
      }}
    >
      <Stack mb={0.5} align="center">
        <Stack.Item grow>
          <Box bold>{active.name}</Box>
        </Stack.Item>
        {active.allows_disabling ? (
          <Stack.Item>
            <Button compact onClick={() => props.act('toggle_customizer', { customizer: active.id })}>
              {active.disabled ? 'Включить' : 'Выключить'}
            </Button>
          </Stack.Item>
        ) : null}
        <Stack.Item>
          <Button compact tooltip="Закрыть" onClick={props.onClose}>
            ×
          </Button>
        </Stack.Item>
      </Stack>

      {active.can_change_choice && active.choice_groups?.length ? (
        <Box mb={0.5} style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
          {active.choice_groups.map((group) => (
            <Button
              key={group.id}
              compact
              selected={group.current}
              onClick={() => props.act('set_customizer_choice', { customizer: active.id, choice: group.id })}
            >
              {group.name}
            </Button>
          ))}
        </Box>
      ) : null}

      <Box mb={0.5} style={{ display: 'flex', flexWrap: 'wrap', gap: '5px' }}>
        <HairControlButton label="Основа" value={active.hair_color} color={active.hair_color} onClick={() => props.act('set_hair_color', { customizer: active.id })} />
        <HairControlButton label="Градиент" value={active.natural_gradient} onClick={() => props.act('set_natural_gradient', { customizer: active.id })} />
        <HairControlButton label="Цвет градиента" value={active.natural_color} color={active.natural_color} onClick={() => props.act('set_natural_color', { customizer: active.id })} />
        <HairControlButton label="Градиент краски" value={active.dye_gradient} onClick={() => props.act('set_dye_gradient', { customizer: active.id })} />
        <HairControlButton label="Цвет краски" value={active.dye_color} color={active.dye_color} onClick={() => props.act('set_dye_color', { customizer: active.id })} />
      </Box>

      {active.custom_hair_available ? (
        <Box mb={0.5} style={{ display: 'flex', flexWrap: 'wrap', gap: '5px' }}>
          <Button
            compact
            icon="paint-brush"
            onClick={() => props.act('open_custom_hair_editor', { customizer: active.id })}
          >
            Кастомизировать
          </Button>
          {active.custom_hair_applied ? (
            <Button
              compact
              icon="eraser"
              color="danger"
              onClick={() => props.act('clear_custom_hair', { customizer: active.id })}
            >
              Очистить кастомизацию
            </Button>
          ) : null}
        </Box>
      ) : null}

      <Input
        fluid
        mb={0.5}
        placeholder="Поиск причёски..."
        value={search}
        onChange={setSearch}
      />

      <Box
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(4, minmax(0, 1fr))',
          gap: '6px',
          flex: '1 1 auto',
          minHeight: 0,
          overflowY: 'auto',
          overflowX: 'hidden',
          paddingRight: '4px',
        }}
      >
        {filteredOptions.map((option) => (
          <Button
            key={option.id}
            selected={option.id === active.selected_accessory_id}
            tooltip={option.name}
            onClick={() => props.act('set_customizer_accessory', { customizer: active.id, accessory: option.id })}
            style={{
              minWidth: 0,
              height: '88px',
              padding: '4px',
              overflow: 'hidden',
            }}
          >
            <Box
              style={{
                height: '64px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              {option.icon_class_name ? (
                <Box className={option.icon_class_name} />
              ) : option.icon ? (
                <DmIcon icon={option.icon} icon_state={option.icon_state || ''} width="64px" height="64px" />
              ) : (
                <Box color="label">Нет</Box>
              )}
            </Box>
            <Box
              mt={0.1}
              style={{
                fontSize: '11px',
                lineHeight: 1.05,
                overflow: 'hidden',
                textOverflow: 'ellipsis',
                whiteSpace: 'nowrap',
              }}
            >
              {option.name}
            </Box>
          </Button>
        ))}
      </Box>

      {!filteredOptions.length ? (
        <Box color="label" textAlign="center" py={1}>
          Ничего не найдено
        </Box>
      ) : null}
    </Box>
  );
};

export const FeatureModal = (props: {
  data: Data;
  active: ActiveCustomizer | null;
  act: (action: string, payload?: Record<string, unknown>) => void;
  onClose: () => void;
}) => {
  const active = props.active;
  const [search, setSearch] = useState(active?.search_query || '');

  useEffect(() => {
    setSearch(active?.search_query || '');
  }, [active?.id, active?.search_query]);

  useEffect(() => {
    if (!active || active.group === 'simple') {
      return;
    }
    const timeout = setTimeout(() => {
      if (search !== (active.search_query || '')) {
        props.act('set_customizer_filter', { value: search });
      }
    }, 250);
    return () => clearTimeout(timeout);
  }, [search, active?.id, active?.search_query, active?.group, props]);

  if (!active) {
    return (
      <ModalShell title="Особенность" width="420px" onClose={props.onClose}>
        <Box color="label">Загрузка настройки...</Box>
      </ModalShell>
    );
  }

  const isSimple = active.group === 'simple';
  const modalWidth = isSimple ? '760px' : '820px';

  return (
    <ModalShell title={active.name} width={modalWidth} onClose={props.onClose}>
      <Box mb={0.6} p={0.6} style={cardStyle}>
        <Box color="label">Текущий вариант</Box>
        <Box bold>{active.current_accessory_name || 'Нет'}</Box>
      </Box>

      {active.can_change_choice && active.choice_groups?.length ? (
        <Box mb={0.6} p={0.5} style={cardStyle}>
          {active.choice_groups.map((group) => (
            <Button
              key={group.id}
              mr={0.4}
              mb={0.4}
              selected={group.current}
              onClick={() => props.act('set_customizer_choice', { customizer: active.id, choice: group.id })}
            >
              {group.name}
            </Button>
          ))}
        </Box>
      ) : null}

      {isSimple ? (
        <>
          <Stack mb={0.6} align="center">
            <Stack.Item grow>
              <select
                value={active.selected_accessory_id || ''}
                onChange={(event) => props.act('set_customizer_accessory', { customizer: active.id, accessory: event.currentTarget.value })}
                style={{
                  width: '100%',
                  height: '34px',
                  background: 'rgba(255,255,255,0.06)',
                  color: 'white',
                  border: '1px solid rgba(255,255,255,0.18)',
                  padding: '4px 8px',
                }}
              >
                {active.options.map((option) => (
                  <option key={option.id} value={option.id}>
                    {option.name}
                  </option>
                ))}
              </select>
            </Stack.Item>
            {active.allows_disabling ? (
              <Stack.Item>
                <Button onClick={() => props.act('toggle_customizer', { customizer: active.id })}>
                  {active.disabled ? 'Включить' : 'Выключить'}
                </Button>
              </Stack.Item>
            ) : null}
          </Stack>

          {active.allows_accessory_color_customization && active.accessory_color_labels?.length ? (
            <Box mb={0.6}>
              {active.accessory_color_labels.map((label, index) => (
                <CompactRow
                  key={`${label}-${index}`}
                  label={label}
                  value={active.accessory_color_values?.[index] || 'Нет'}
                  colorPreview={active.accessory_color_values?.[index]}
                  onClick={() => props.act('edit_accessory_color', { customizer: active.id, index: index + 1 })}
                />
              ))}
            </Box>
          ) : null}

          <Section title="Все варианты" fill scrollable>
            <Box style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: '8px' }}>
              {active.options.map((option) => (
                <Button
                  key={option.id}
                  selected={option.id === active.selected_accessory_id}
                  textAlign="left"
                  style={{ minHeight: '34px' }}
                  onClick={() => props.act('set_customizer_accessory', { customizer: active.id, accessory: option.id })}
                >
                  {option.name}
                </Button>
              ))}
            </Box>
          </Section>
        </>
      ) : (
        <>
          <Stack mb={0.6} align="center">
            <Stack.Item grow>
              <Input
                fluid
                placeholder="Поиск..."
                value={search}
                onChange={setSearch}
              />
            </Stack.Item>
            {active.allows_disabling ? (
              <Stack.Item>
                <Button onClick={() => props.act('toggle_customizer', { customizer: active.id })}>
                  {active.disabled ? 'Включить' : 'Выключить'}
                </Button>
              </Stack.Item>
            ) : null}
            <Stack.Item>
              <Button onClick={() => props.act('reset_customizer_colors', { customizer: active.id })}>Сброс</Button>
            </Stack.Item>
          </Stack>

          {active.is_hair ? (
            <Box mb={0.6} p={0.5} style={cardStyle}>
              <Box color="label" mb={0.4}>Цвет и градиенты</Box>
              <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
                <HairControlButton label="Основа" value={active.hair_color} color={active.hair_color} onClick={() => props.act('set_hair_color', { customizer: active.id })} />
                <HairControlButton label="Градиент" value={active.natural_gradient} onClick={() => props.act('set_natural_gradient', { customizer: active.id })} />
                <HairControlButton label="Цвет градиента" value={active.natural_color} color={active.natural_color} onClick={() => props.act('set_natural_color', { customizer: active.id })} />
                <HairControlButton label="Градиент краски" value={active.dye_gradient} onClick={() => props.act('set_dye_gradient', { customizer: active.id })} />
                <HairControlButton label="Цвет краски" value={active.dye_color} color={active.dye_color} onClick={() => props.act('set_dye_color', { customizer: active.id })} />
              </Box>
              {active.custom_hair_available ? (
                <Box mt={0.5} style={{ display: 'flex', flexWrap: 'wrap', gap: '5px' }}>
                  <Button
                    compact
                    icon="paint-brush"
                    onClick={() => props.act('open_custom_hair_editor', { customizer: active.id })}
                  >
                    Кастомизировать
                  </Button>
                  {active.custom_hair_applied ? (
                    <Button
                      compact
                      icon="eraser"
                      color="danger"
                      onClick={() => props.act('clear_custom_hair', { customizer: active.id })}
                    >
                      Очистить кастомизацию
                    </Button>
                  ) : null}
                </Box>
              ) : null}
            </Box>
          ) : null}

          {active.allows_accessory_color_customization && active.accessory_color_labels?.length ? (
            <Box mb={0.6}>
              {active.accessory_color_labels.map((label, index) => (
                <CompactRow
                  key={`${label}-${index}`}
                  label={label}
                  value={active.accessory_color_values?.[index] || 'Нет'}
                  colorPreview={active.accessory_color_values?.[index]}
                  onClick={() => props.act('edit_accessory_color', { customizer: active.id, index: index + 1 })}
                />
              ))}
            </Box>
          ) : null}

          {(() => {
            const pageSize = active.window_size || Math.max(active.options.length, 1);
            const totalPages = Math.max(1, Math.ceil((active.total_filtered || 0) / pageSize));
            const currentPage = Math.max(1, Math.ceil(((active.window_start || 1) - 1) / pageSize) + 1);
            const prevStart = Math.max(1, (active.window_start || 1) - pageSize);
            const nextStart = Math.min(
              Math.max(1, (active.total_filtered || 1) - pageSize + 1),
              (active.window_start || 1) + pageSize,
            );

            return (
              <>
                {totalPages > 1 ? (
                  <Stack mb={0.5} align="center">
                    <Stack.Item>
                      <Button
                        disabled={currentPage <= 1}
                        onClick={() => props.act('set_customizer_window', { start: prevStart })}
                      >
                        ←
                      </Button>
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box textAlign="center">Страница {currentPage} / {totalPages}</Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        disabled={currentPage >= totalPages}
                        onClick={() => props.act('set_customizer_window', { start: nextStart })}
                      >
                        →
                      </Button>
                    </Stack.Item>
                  </Stack>
                ) : null}

                <Box
                  style={{
                    display: 'grid',
                    gridTemplateColumns: 'repeat(4, minmax(0, 1fr))',
                    gap: '8px',
                    maxHeight: '560px',
                    overflowY: 'auto',
                  }}
                >
                  {active.options.map((option) => (
                    <OptionTile
                      key={option.id}
                      option={option}
                      selected={option.id === active.selected_accessory_id}
                      showImage
                      onClick={() => props.act('set_customizer_accessory', { customizer: active.id, accessory: option.id })}
                    />
                  ))}
                </Box>
              </>
            );
          })()}
        </>
      )}
    </ModalShell>
  );
};
