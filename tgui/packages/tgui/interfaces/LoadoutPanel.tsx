import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Box,
  ProgressBar,
  Stack,
  Tabs,
  Input,
} from 'tgui-core/components';

interface Data {
  categories: Record<string, Record<string, Item>>;
  isDonator: boolean | number;
  selectedLoadoutItems: string[];
  donatTier: number;
  triumphDiscount: number;
  triumphDiscountUsed: number;
  curLoadoutSlots: number;
  maxLoadoutSlots: number;
}

interface Item {
  name: string;
  path: string;
  icon_class_name: string;
  isDonatorItem: boolean;
  icon: string;
  icon_state: string;
  unavailable?: boolean;
  unavailableReason?: string;
  requiredTier?: number;
  triumphCost?: number;
}

export const LoadoutPanel = () => {
  const { data, act } = useBackend<Data>();
  const [tabIndex, setTabIndex] = useState(0);
  const [searchQuery, setSearchQuery] = useState('');
  const [confirmReset, setConfirmReset] = useState(false);

  const selectedSet = new Set(data.selectedLoadoutItems ?? []);

  const categoriesArray = Object.entries(data.categories ?? {}).map(
    ([name, items]) => ({
      name,
      items,
    })
  );

  const filteredItems = Object.values(categoriesArray[tabIndex]?.items || {}).filter(
    (item) => (item?.name?.toLowerCase() || '').includes(searchQuery.toLowerCase())
  );

  const handleResetClick = () => {
    if (confirmReset) {
      act('clear', {});
      setTimeout(() => setConfirmReset(false), 100);
    } else {
      setConfirmReset(true);
      setTimeout(() => setConfirmReset(false), 5000);
    }
  };

  const slotRatio =
    data.maxLoadoutSlots > 0
      ? data.curLoadoutSlots / data.maxLoadoutSlots
      : 0;

  const hasDonatorTriumphDiscount =
    !!data.isDonator && data.triumphDiscount > 0;

  return (
    <Window
      title="Лодаут"
      buttons={
        <Button
          tooltip={`Выберите предметы для вашего персонажа.
Вы их сможете забрать, когда нажмете правой кнопкой мыши по статуе или дереву.
Рескины на оружие (Donator kit) являются просто рескинами, чтобы его получить используйте зелье на соответствующем предмете.`}
          tooltipPosition="bottom"
          style={{
            position: 'fixed',
            top: '9px',
            left: '92px',
            zIndex: 103,
            minWidth: '0',
            width: '16px',
            height: '16px',
            padding: '0',
            border: 'none',
            boxShadow: 'none',
            background: 'none',
            textAlign: 'center',
            lineHeight: '16px',
            fontSize: '13px',
            fontWeight: 'bold',
            color: '#d7b6b6',
            textShadow: '0 0 4px rgba(255,255,255,0.35)',
            cursor: 'help',
          }}
        >
          ?
        </Button>
      }
      width={1200}
      height={700}
    >
      <Window.Content>
        <Stack fill>
          <Stack.Item width="300px">
            <Stack vertical textAlign="justify">
              <Stack.Item style={{ textAlign: 'center' }}>
                <Button onClick={() => act('boosty')}>
                  <h3>Поддержать сервер</h3>
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Box
                  mt={1}
                  style={{
                    fontSize: '13px',
                    lineHeight: 1.35,
                    textAlign: 'center',
                    color: '#d7b6b6',
                  }}
                >
                  Для меценатов в зависимости от уровня подписки(
                  <Button
                    tooltip="Т1 - дает 7 слотов вещей, 3 скидочных триумфа, 40 слотов персонажей и вещи своего тира."
                    tooltipPosition="bottom"
                    style={{
                      minWidth: '0',
                      width: 'auto',
                      height: 'auto',
                      padding: '0',
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
                    1
                  </Button>
                  ,{' '}
                  <Button
                    tooltip="Т2 - дает 11 слотов вещей, 5 скидочных триумфа, 60 слотов персонажей, возможность поменять цвет в дискорде, кастомную боевую музыку и вещи своего тира."
                    tooltipPosition="bottom"
                    style={{
                      minWidth: '0',
                      width: 'auto',
                      height: 'auto',
                      padding: '0',
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
                    2
                  </Button>
                  ,{' '}
                  <Button
                    tooltip="Т3 - дает 17 слотов вещей, 7 скидочных триумфа, 80 слотов персонажей, возможность поменять цвет в дискорде, кастомную боевую музыку и вещи своего тира. Также дается возможность раз в 2 раунда с повышенным приоритетом зайти за роль, имеющую более 2 слотов."
                    tooltipPosition="bottom"
                    style={{
                      minWidth: '0',
                      width: 'auto',
                      height: 'auto',
                      padding: '0',
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
                    3
                  </Button>
                  ,{' '}
                  <Button
                    tooltip="Т4 - дает 21 слотов вещей, 10 скидочных триумфа, 100 слотов персонажей, возможность поменять цвет в дискорде, кастомную боевую музыку и вещи своего тира. Также дается возможность с повышенным приоритетом зайти за роль, имеющую более 2 слотов, в отличии от Т3 без КД в 2 раунда."
                    tooltipPosition="bottom"
                    style={{
                      minWidth: '0',
                      width: 'auto',
                      height: 'auto',
                      padding: '0',
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
                    4
                  </Button>
                  ,{' '}
                  <Button
                    tooltip="Т5 - дает 27 слотов вещей, 15 скидочных триумфа, 120 слотов персонажей, возможность поменять цвет в дискорде, кастомную боевую музыку и вещи своего тира. Также дается возможность зайти за любую роль с повышенным приоритетом, в отличии от Т3 и Т4 каких-либо ограничений нет."
                    tooltipPosition="bottom"
                    style={{
                      minWidth: '0',
                      width: 'auto',
                      height: 'auto',
                      padding: '0',
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
                    5
                  </Button>
                  ) открываются различные бонусы в лодауте и не только. Лишь за
                  счет поддержки сервер существует.
                </Box>
              </Stack.Item>
              <br />
              <Stack.Item>
                {data.curLoadoutSlots} / {data.maxLoadoutSlots}
              </Stack.Item>
              <Stack.Item>
                <ProgressBar
                  ranges={{
                    bad: [0.75, Infinity],
                    average: [0.25, 0.75],
                    good: [-Infinity, 0.25],
                  }}
                  value={slotRatio}
                  width="300px"
                />
              </Stack.Item>

              {hasDonatorTriumphDiscount ? (
                <Stack.Item>
                  <Box
                    style={{
                      display: 'inline-block',
                      padding: '8px 14px',
                      borderRadius: '8px',
                      backgroundColor: 'rgba(212, 175, 55, 0.14)',
                      border: '1px solid rgba(212, 175, 55, 0.55)',
                      color: '#facc15',
                      fontWeight: 'bold',
                      textShadow: '1px 1px 3px rgba(0,0,0,0.75)',
                    }}
                  >
                    ★ Скидочные триумфы: занято {data.triumphDiscountUsed} из{' '}
                    {data.triumphDiscount}
                  </Box>
                </Stack.Item>
              ) : null}
              <Stack.Item>
                <Box
                  mt={2}
                  style={{
                    minHeight: '200px',
                    maxHeight: '260px',
                    overflowY: 'auto',
                    overflowX: 'hidden',
                    padding: '8px',
                    border: '1px solid rgba(120, 150, 190, 0.65)',
                    borderRadius: '6px',
                    backgroundColor: 'rgba(0, 0, 0, 0.14)',
                  }}
                >
                  <Box
                    mb={1}
                    textAlign="center"
                    style={{
                      fontSize: '16px',
                      fontWeight: 'bold',
                      textShadow: '1px 1px 3px rgba(0,0,0,0.8)',
                    }}
                  >
                    Выбранные предметы:
                  </Box>

                  {(data.selectedLoadoutItems ?? []).length ? (
                    (data.selectedLoadoutItems ?? []).map((item) => (
                      <Box
                        key={item}
                        mb={1}
                        style={{
                          display: 'flex',
                          justifyContent: 'space-between',
                          alignItems: 'center',
                          gap: '6px',
                        }}
                      >
                        <div
                          title={item}
                          style={{
                            overflow: 'hidden',
                            textOverflow: 'ellipsis',
                            whiteSpace: 'nowrap',
                          }}
                        >
                          {item}
                        </div>
                        <Button
                          color="danger"
                          onClick={() => act('remove', { item })}
                        >
                          Удалить
                        </Button>
                      </Box>
                    ))
                  ) : (
                    <Box color="label" textAlign="center">
                      Пока ничего не выбрано.
                    </Box>
                  )}
                </Box>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item width="100%">
            <Stack vertical fill>
              <Stack.Item>
                <Tabs>
                  {categoriesArray.map((cat, i) => (
                    <Tabs.Tab
                      key={cat.name}
                      selected={i === tabIndex}
                      onClick={() => setTabIndex(i)}
                      style={{
                        flex: 1,
                        backgroundColor: i === tabIndex ? '#444' : '#222',
                        color: 'white',
                      }}
                    >
                      {cat.name}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              </Stack.Item>
              <Stack.Item
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  marginTop: '10px',
                }}
              >
                <Input
                  placeholder="Поиск предметов..."
                  value={searchQuery}
                  onChange={setSearchQuery}
                  width="300px"
                />
                <Button
                  onClick={handleResetClick}
                  style={{ marginTop: '10px' }}
                  color={confirmReset ? 'good' : 'danger'}
                >
                  <span style={{ color: 'white' }}>
                    {confirmReset ? 'Точно?' : 'Сбросить все'}
                  </span>
                </Button>
              </Stack.Item>
              <Stack.Item
                style={{
                  overflowY: 'auto',
                  overflowX: 'hidden',
                }}
              >
                <div
                  style={{
                    display: 'grid',
                    gridTemplateColumns: 'repeat(auto-fill, minmax(96px, 1fr))',
                    gap: '8px',
                  }}
                >
                  {filteredItems.map((item, index) => (
                    <div
                      key={item?.name || item?.path || index}
                      style={{
                        display: 'flex',
                        alignItems: 'center',
                        minHeight: '64px',
                        borderRadius: '4px',
                      }}
                    >
                      <Box
                        style={{
                          display: 'flex',
                          flexDirection: 'column',
                          alignItems: 'center',
                          justifyContent: 'center',
                          minWidth: '96px',
                          flexShrink: 0,
                        }}
                      >
                        <Button
                          style={{
                            backgroundColor: '#141414',
                            padding: '16px',
                            width: '96px',
                            height: '96px',
                            border: '2x solid red',
                            borderColor: `${item?.unavailable ? '#a77a18' : (selectedSet.has(item?.name)? '#a71818' : '#24a718')}`,
                            borderRadius: '8px',
                          }}
                          tooltip={
                            item?.unavailable ? (
                              <Box>
                                <Box>{item?.name || 'Без названия'}</Box>
                                <Box mt={0.5}>
                                  {item?.requiredTier
                                    ? `Требуется уровень мецената: ${item.requiredTier}.`
                                    : item?.unavailableReason || 'Недоступно.'}
                                </Box>
                              </Box>
                            ) : (
                              item?.name || 'Без названия'
                            )
                          }
                          onClick={() => {
                            if (selectedSet.has(item?.name)) {
                              act('remove', { item: item?.name || item?.path });
                            } else {
                              act('add', { item: item?.name || item?.path });
                            }
                          }}
                        >
                          <Box
                            inline
                            verticalAlign="middle"
                            className={item.icon_class_name}
                            style={{
                              transform: 'scale(0.67) translate(-51px, -50px)',
                            }}
                          >
                            {item?.triumphCost ? (
                              <Box
                                style={{
                                  width: '100%',
                                  marginTop: '96px',
                                  fontSize: '20px',
                                  fontWeight: 'bold',
                                  color: '#d4af37',
                                  outlineColor: 'black',
                                  textAlign: 'center',
                                  textShadow: '1px 1px 3px rgba(0,0,0,0.75)',
                                  lineHeight: 1.2,
                                }}
                              >
                                {item.triumphCost} триумфов
                              </Box>
                            ) : null}

                            {item?.isDonatorItem ? (
                              <Box
                                style={{
                                  width: '100%',
                                  marginTop: '96px',
                                  fontSize: '20px',
                                  fontWeight: 'bold',
                                  color: '#c084fc',
                                  outlineColor: 'black',
                                  textAlign: 'center',
                                  textShadow: '1px 1px 3px rgba(0,0,0,0.75)',
                                  lineHeight: 1.2,
                                }}
                              >
                                Донат тир {item.requiredTier && item.requiredTier > 0 ? item.requiredTier : 1}
                              </Box>
                            ) : null}
                          </Box>
                        </Button>
                      </Box>
                    </div>
                  ))}
                </div>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
