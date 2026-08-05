import { useMemo, useState } from 'react';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Input,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

type LoadoutItem = {
  name: string;
  path: string;
  icon_class_name: string;
  isDonatorItem: boolean;
  icon?: string | null;
  icon_state?: string | null;
  unavailable?: boolean;
  unavailableReason?: string;
  requiredTier?: number;
  triumphCost?: number;
  colorable?: boolean;
};

type SelectedLoadoutItem = {
  name: string;
  colorChannels?: Record<string, string>;
  colors?: Record<string, string>;
  colorLabels?: Record<string, string>;
};

type LoadoutCatalogData = {
  categories?: Record<string, Record<string, LoadoutItem>>;
  isDonator?: boolean | number;
  donatTier?: number;
  triumphDiscount?: number;
  maxLoadoutSlots?: number;
};

type LoadoutStateData = {
  selectedLoadoutItems?: string[];
  selectedLoadoutDetails?: SelectedLoadoutItem[];
  triumphDiscountUsed?: number;
  curLoadoutSlots?: number;
};

type Data = {
  loadout_catalog?: LoadoutCatalogData;
  loadout_state?: LoadoutStateData;
};

const cardStyle = {
  border: '1px solid rgba(255,255,255,0.12)',
};

const LoadoutTierLink = (props: { tier: number; text: string }) => (
  <Button
    tooltip={props.text}
    tooltipPosition="bottom"
    style={{
      minWidth: 0,
      width: 'auto',
      height: 'auto',
      padding: 0,
      border: 'none',
      boxShadow: 'none',
      background: 'none',
      lineHeight: 'inherit',
      verticalAlign: 'baseline',
      color: '#facc15',
      fontWeight: 'bold',
      cursor: 'help',
    }}
  >
    {props.tier}
  </Button>
);

export const LoadoutPanel = () => {
  const { data, act } = useBackend<Data>();
  const [selectedCategory, setSelectedCategory] = useState('');
  const [searchQuery, setSearchQuery] = useState('');
  const [confirmReset, setConfirmReset] = useState(false);

  const catalog = data.loadout_catalog;
  const state = data.loadout_state;
  const selectedItems = state?.selectedLoadoutItems || [];
  const selectedDetails = state?.selectedLoadoutDetails || selectedItems.map((name) => ({ name }));
  const selectedSet = useMemo(() => new Set(selectedItems), [selectedItems]);
  const categoriesArray = useMemo(
    () => Object.entries(catalog?.categories || {}).map(([name, items]) => ({ name, items })),
    [catalog?.categories],
  );
  const activeCategory = categoriesArray.some((category) => category.name === selectedCategory)
    ? selectedCategory
    : (categoriesArray[0]?.name || '');
  const activeItems = categoriesArray.find((category) => category.name === activeCategory)?.items || {};
  const normalizedSearch = searchQuery.trim().toLowerCase();
  const filteredItems = Object.values(activeItems).filter((item) => (
    !normalizedSearch || (item?.name?.toLowerCase() || '').includes(normalizedSearch)
  ));
  const currentSlots = state?.curLoadoutSlots || 0;
  const maxSlots = catalog?.maxLoadoutSlots || 0;
  const slotRatio = maxSlots > 0 ? currentSlots / maxSlots : 0;
  const triumphDiscount = catalog?.triumphDiscount || 0;
  const triumphDiscountUsed = state?.triumphDiscountUsed || 0;
  const hasDonatorTriumphDiscount = !!catalog?.isDonator && triumphDiscount > 0;

  const handleReset = () => {
    if (!confirmReset) {
      setConfirmReset(true);
      window.setTimeout(() => setConfirmReset(false), 5000);
      return;
    }
    act('loadout_clear');
    setConfirmReset(false);
  };

  return (
    <Box style={{ position: 'relative', height: '100%', minHeight: 0, minWidth: 0 }}>
      <Stack fill style={{ minWidth: 0 }}>
      <Stack.Item basis="224px" shrink={0}>
        <Section
          title="Лодаут"
          fill
          scrollable
          buttons={(
            <Button
              compact
              icon="question"
              tooltip={`Выберите предметы для вашего персонажа.
Забрать их можно через контекстное меню статуи или дерева.
Donator kit — это рескины: используйте зелье на соответствующем предмете.
Также некоторые вещи можно перекрашивать, нажав на кнопку с палитрой в списке выбранных предметов.`}
              tooltipPosition="bottom"
            />
          )}
        >
          <Button fluid icon="heart" onClick={() => act('loadout_boosty')}>
            Поддержать сервер
          </Button>
          <Box mt={0.65} mb={0.7} color="label" textAlign="center" style={{ lineHeight: 1.3 }}>
            Бонусы уровней{' '}
            <LoadoutTierLink tier={1} text="Т1 — 7 слотов вещей, 3 скидочных триумфа, 40 слотов персонажей и вещи своего тира." />
            ,{' '}
            <LoadoutTierLink tier={2} text="Т2 — 11 слотов вещей, 5 скидочных триумфов, 60 слотов персонажей, цвет в Discord, боевая музыка и вещи своего тира." />
            ,{' '}
            <LoadoutTierLink tier={3} text="Т3 — 17 слотов вещей, 7 скидочных триумфов, 80 слотов персонажей и повышенный приоритет раз в два раунда для ролей с более чем двумя слотами." />
            ,{' '}
            <LoadoutTierLink tier={4} text="Т4 — 21 слот вещей, 10 скидочных триумфов, 100 слотов персонажей и повышенный приоритет без задержки Т3." />
            ,{' '}
            <LoadoutTierLink tier={5} text="Т5 — 27 слотов вещей, 15 скидочных триумфов, 120 слотов персонажей и повышенный приоритет без ограничений." />
          </Box>

          <Stack align="center" mb={0.35}>
            <Stack.Item grow>
              <Box bold>Слоты предметов</Box>
            </Stack.Item>
            <Stack.Item>{currentSlots} / {maxSlots}</Stack.Item>
          </Stack>
          <ProgressBar
            ranges={{
              bad: [0.75, Infinity],
              average: [0.25, 0.75],
              good: [-Infinity, 0.25],
            }}
            value={slotRatio}
          />

          {hasDonatorTriumphDiscount ? (
            <Box mt={0.7} p={0.55} style={{ ...cardStyle, color: '#facc15' }}>
              ★ Скидочные триумфы: {triumphDiscountUsed} / {triumphDiscount}
            </Box>
          ) : null}

          <Box mt={0.85} mb={0.45} bold textAlign="center">
            Выбранные предметы
          </Box>
          {selectedDetails.length ? selectedDetails.map((item) => (
            <Box key={item.name} mb={0.35} p={0.35} style={cardStyle}>
              <Stack align="start">
                <Stack.Item grow style={{ minWidth: 0 }}>
                  <Box
                    title={item.name}
                    style={{
                      minWidth: 0,
                      lineHeight: 1.2,
                      whiteSpace: 'normal',
                      overflowWrap: 'anywhere',
                      wordBreak: 'break-word',
                    }}
                  >
                    {item.name}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    compact
                    color="danger"
                    icon="times"
                    tooltip="Убрать"
                    onClick={() => act('loadout_remove', { item: item.name })}
                  />
                </Stack.Item>
              </Stack>
              {Object.keys(item.colorChannels || {}).length ? (
                <Stack align="center" mt={0.3}>
                  <Stack.Item grow>
                    <Box color="label">Цвета</Box>
                  </Stack.Item>
                  {Object.entries(item.colorChannels || {}).map(([channel, label]) => {
                    const color = item.colors?.[channel];
                    const colorLabel = item.colorLabels?.[channel];
                    return (
                      <Stack.Item key={`${item.name}-${channel}`}>
                        <Button
                          compact
                          icon="palette"
                          tooltip={`${label}: ${colorLabel || color || 'исходный цвет'}`}
                          onClick={() => act('loadout_pick_color', {
                            item: item.name,
                            channel,
                          })}
                          style={{
                            minWidth: '26px',
                            width: '26px',
                            height: '26px',
                            padding: 0,
                            borderRadius: '4px',
                            border: `2px solid ${color || 'rgba(255,255,255,0.28)'}`,
                            background: 'rgba(255,255,255,0.04)',
                            color: color || '#d8d8d8',
                            textShadow: color
                              ? '0 0 2px #000, 0 0 4px #000'
                              : undefined,
                            boxShadow: color
                              ? `0 0 6px ${color}`
                              : undefined,
                          }}
                        />
                      </Stack.Item>
                    );
                  })}
                  {Object.keys(item.colorLabels || {}).length ? (
                    <Stack.Item>
                      <Button
                        compact
                        icon="undo"
                        tooltip="Сбросить все цвета вещи"
                        onClick={() => act('loadout_clear_colors', { item: item.name })}
                      />
                    </Stack.Item>
                  ) : null}
                </Stack>
              ) : null}
            </Box>
          )) : (
            <Box color="label" textAlign="center">Пока ничего не выбрано.</Box>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item grow basis={0} style={{ minWidth: 0, maxWidth: '100%', overflow: 'hidden' }}>
        <Section
          title="Предметы"
          fill
          style={{ minWidth: 0, maxWidth: '100%', overflow: 'hidden' }}
        >
          <Box
            style={{
              display: 'grid',
              gridTemplateRows: 'auto auto minmax(0, 1fr)',
              width: '100%',
              maxWidth: '100%',
              height: '100%',
              minHeight: 0,
              minWidth: 0,
              overflow: 'hidden',
            }}
          >
            <Box style={{ minWidth: 0, maxWidth: '100%', overflow: 'hidden' }}>
              <Box
                onWheel={(event) => {
                  const target = event.currentTarget;
                  if (target.scrollWidth <= target.clientWidth) {
                    return;
                  }
                  target.scrollLeft += event.deltaY || event.deltaX;
                  event.preventDefault();
                }}
                style={{
                  overflowX: 'auto',
                  overflowY: 'hidden',
                  minWidth: 0,
                  maxWidth: '100%',
                  width: '100%',
                  paddingBottom: '6px',
                  overscrollBehaviorX: 'contain',
                  scrollbarGutter: 'stable',
                  scrollbarWidth: 'thin',
                }}
              >
                <Tabs
                  style={{
                    display: 'inline-flex',
                    flexWrap: 'nowrap',
                    width: 'max-content',
                    minWidth: 'max-content',
                  }}
                >
                  {categoriesArray.map((category) => (
                    <Tabs.Tab
                      key={category.name}
                      selected={category.name === activeCategory}
                      onClick={() => setSelectedCategory(category.name)}
                      style={{ flex: '0 0 auto', whiteSpace: 'nowrap' }}
                    >
                      {category.name}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              </Box>
            </Box>
            <Box style={{ minWidth: 0, maxWidth: '100%', marginTop: '4px', overflow: 'hidden' }}>
              <Box
                style={{
                  display: 'grid',
                  gridTemplateColumns: 'minmax(0, 1fr) max-content',
                  alignItems: 'center',
                  gap: '6px',
                  width: '100%',
                  maxWidth: '100%',
                  minWidth: 0,
                  overflow: 'hidden',
                }}
              >
                <Box
                  style={{
                    minWidth: 0,
                    maxWidth: '100%',
                    overflow: 'hidden',
                  }}
                >
                  <Input
                    fluid
                    placeholder="Поиск предметов..."
                    value={searchQuery}
                    onChange={setSearchQuery}
                    style={{
                      display: 'block',
                      minWidth: 0,
                      width: '100%',
                      maxWidth: '100%',
                    }}
                  />
                </Box>
                <Button
                  color={confirmReset ? 'good' : 'danger'}
                  onClick={handleReset}
                  style={{
                    minWidth: 'max-content',
                    maxWidth: '100%',
                    whiteSpace: 'nowrap',
                  }}
                >
                  {confirmReset ? 'Точно?' : 'Сбросить всё'}
                </Button>
              </Box>
            </Box>
            <Box
              style={{
                position: 'relative',
                minHeight: 0,
                minWidth: 0,
                maxWidth: '100%',
                width: '100%',
                marginTop: '4px',
                overflow: 'hidden',
              }}
            >
              <Box
                style={{
                  position: 'absolute',
                  inset: 0,
                  paddingRight: '2px',
                  overflowY: 'auto',
                  overflowX: 'hidden',
                  scrollbarGutter: 'stable',
                  overscrollBehaviorY: 'contain',
                }}
              >
              {filteredItems.length ? (
                <Box
                  style={{
                    display: 'grid',
                    width: '100%',
                    maxWidth: '100%',
                    minWidth: 0,
                    gridTemplateColumns: 'repeat(auto-fit, 104px)',
                    gridAutoRows: '112px',
                    justifyContent: 'start',
                    gap: '8px',
                    alignContent: 'start',
                    overflow: 'hidden',
                  }}
                >
                  {filteredItems.map((item, index) => {
                    const itemName = item?.name || item?.path || `loadout-${index}`;
                    const selected = selectedSet.has(item?.name);
                    const borderColor = item?.unavailable ? '#a77a18' : (selected ? '#a71818' : '#24a718');
                    return (
                      <Button
                        key={itemName}
                        style={{
                          position: 'relative',
                          width: '104px',
                          minWidth: '104px',
                          maxWidth: '104px',
                          height: '112px',
                          minHeight: '112px',
                          maxHeight: '112px',
                          padding: '6px',
                          overflow: 'hidden',
                          backgroundColor: '#141414',
                          border: `2px solid ${borderColor}`,
                          borderRadius: '8px',
                        }}
                        tooltip={(
                          <Box>
                            <Box bold>{item?.name || 'Без названия'}</Box>
                            {item?.unavailable ? (
                              <Box mt={0.4}>
                                {item?.requiredTier
                                  ? `Требуется уровень мецената: ${item.requiredTier}.`
                                  : item?.unavailableReason || 'Недоступно.'}
                              </Box>
                            ) : null}
                            {item?.triumphCost ? <Box mt={0.4}>{item.triumphCost} триумфов</Box> : null}
                          </Box>
                        )}
                        onClick={() => {
                          if (selected) {
                            act('loadout_remove', { item: item?.name || item?.path });
                          } else {
                            act('loadout_add', { item: item?.name || item?.path });
                          }
                        }}
                      >
                        <Box
                          className={item.icon_class_name}
                          style={{
                            position: 'absolute',
                            left: '50%',
                            top: '47%',
                            transform: 'translate(-50%, -50%) scale(0.67)',
                            transformOrigin: 'center',
                          }}
                        />
                        {item?.isDonatorItem ? (
                          <Box
                            style={{
                              position: 'absolute',
                              left: 3,
                              right: 3,
                              bottom: 3,
                              fontSize: '11px',
                              fontWeight: 'bold',
                              color: '#c084fc',
                              textAlign: 'center',
                              textShadow: '1px 1px 3px rgba(0,0,0,0.85)',
                            }}
                          >
                            Тир {item.requiredTier && item.requiredTier > 0 ? item.requiredTier : 1}
                          </Box>
                        ) : item?.triumphCost ? (
                          <Box
                            style={{
                              position: 'absolute',
                              left: 3,
                              right: 3,
                              bottom: 3,
                              fontSize: '11px',
                              fontWeight: 'bold',
                              color: '#d4af37',
                              textAlign: 'center',
                              textShadow: '1px 1px 3px rgba(0,0,0,0.85)',
                            }}
                          >
                            {item.triumphCost} триумфов
                          </Box>
                        ) : null}
                      </Button>
                    );
                  })}
                </Box>
              ) : (
                <Box color="label" textAlign="center" mt={2}>
                  В этой категории ничего не найдено.
                </Box>
              )}
              </Box>
            </Box>
          </Box>
        </Section>
      </Stack.Item>
      </Stack>
    </Box>
  );
};
