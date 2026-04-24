import { useState } from 'react';
import {
  Box,
  Button,
  Section,
  Stack,
  Table,
  ProgressBar,
  Tabs,
  Icon,
  Tooltip,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Slot = {
  name: string;
  ref: string | null;
  smell: string | null;
  image: string | null;
};

type Ingredient = {
  name: string;
  ref: string;
  smell: string;
  image: string;
};

type Link = [number, number];

type Recipe = {
  name: string;
  found: BooleanLike;
  is_hint: BooleanLike;
  type: 'infusion' | 'grid';
  reqs?: {
    strong: (string | null)[];
    medium: (string | null)[];
    light: (string | null)[];
  };
  grid_icons?: (string | null)[];
  result_img?: string;
};
type CraftRecipe = {
  name: string;
  ref: string;
};

type ReagentInfo = {
  name: string;
  volume: number;
  color: string;
};

type ReagentEntry = {
  name: string;
  id: string;
  vol: number;
};

type BeakerData = {
  name: string;
  cur: number;
  max: number;
  contents: ReagentEntry[];
};

type Data = {
  upgrade_lvl: number;
  next_upgrade_req: string;
  water_level: number;
  max_water: number;
  reagents: ReagentInfo[];
  total_volume: number;
  max_volume: number;
  slots: Slot[];
  links: Link[];
  knowledge: Recipe[];
  craft_recipes: CraftRecipe[];
  crafting_grid: { ref: string | null, image: string | null }[];
  craft_result: { name: string, image: string } | null;
  available_ingredients: Ingredient[];
  available_all_items: Ingredient[];
  beaker1: BeakerData | null;
  beaker2: BeakerData | null;
  cauldron_reagents: ReagentEntry[];
  pill_mix: { name: string; vol: number; id: string }[];
  pill_mix_total: number;
  flour_count: number;
  p_stone: { charges: number; max: number; owner: string } | null;
  transmute_item: { name: string; image: string } | null;
  transmute_recipes: { 
    name: string; 
    cost: number; 
    ref: string;
    icon: string; 
    category: string
  }[];
};

export const AlchemyWorkbench = (props) => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState(data.upgrade_lvl < 3 ? 'crafting' : 'workstation');

  const isMaxLevel = data.upgrade_lvl >= 4;

  return (
    <Window title="Великая Алхимическая Лаборатория" width={680} height={600}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs>
              {data.upgrade_lvl >= 4 && (
                <Tabs.Tab selected={tab === 'transmutation'} onClick={() => setTab('transmutation')}>Трансмутация</Tabs.Tab>
              )}
              {data.upgrade_lvl >= 3 && (
                <Tabs.Tab selected={tab === 'workstation'} onClick={() => setTab('workstation')}>Инфузия</Tabs.Tab>
              )}
              {data.upgrade_lvl >= 2 && (
                <Tabs.Tab selected={tab === 'lab'} onClick={() => setTab('lab')}>Лаборатория</Tabs.Tab>
              )}
              
              
              <Tabs.Tab selected={tab === 'crafting'} onClick={() => setTab('crafting')}>Создание</Tabs.Tab>
              <Tabs.Tab selected={tab === 'grimoire'} onClick={() => setTab('grimoire')}>Гримуар</Tabs.Tab>
              
              <Tooltip content={data.next_upgrade_req} position="bottom">
                <Tabs.Tab 
                  selected={false} 
                  color={isMaxLevel ? "transparent" : "yellow"} 
                  textColor={isMaxLevel ? "gray" : "white"} 
                  onClick={() => {
                    if (!isMaxLevel) act('upgrade');
                  }}
                >
                  <Icon name="arrow-up" mr={1} />
                  {isMaxLevel ? "Макс. Уровень" : `Улучшить (Ур. ${data.upgrade_lvl})`}
                </Tabs.Tab>
              </Tooltip>

            </Tabs>
          </Stack.Item>

          <Stack.Item>
            <Button fluid icon="briefcase" onClick={() => act('open_inventory')}>ОТКРЫТЬ СКЛАД СТОЛА</Button>
          </Stack.Item>

          <Stack.Item grow>
            {tab === 'workstation' && <WorkstationTab />}
            {tab === 'crafting' && <CraftingTab />}
            {tab === 'grimoire' && <GrimoireTab />}
            {tab === 'transmutation' && <TransmutationTab />}
            {tab === 'lab' && <LaboratoryTab />}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const WorkstationTab = () => {
  const { act, data } = useBackend<Data>();
  const [selectedSlot, setSelectedSlot] = useState<number | null>(null);
  const [assigningToSlot, setAssigningToSlot] = useState<number | null>(null);

  const centers = { 
    1: { x: 25, y: 16 }, 2: { x: 75, y: 16 }, 
    3: { x: 25, y: 50 }, 4: { x: 75, y: 50 }, 
    5: { x: 25, y: 84 }, 6: { x: 75, y: 84 } 
  };


  const handleSlotClick = (num: number, isEmpty: boolean) => {
    if (isEmpty) {
      setAssigningToSlot(num);
      setSelectedSlot(null);
    } else {
      if (selectedSlot === null) {
        setSelectedSlot(num);
      } else if (selectedSlot === num) {
        setSelectedSlot(null);
      } else {
        act('link', { from: selectedSlot, to: num });
        setSelectedSlot(null);
      }
    }
  };

  return (
    <Stack fill>
      <Stack.Item grow>
        <Section 
          title="Матрица Инфузии" 
          fill 
          buttons={
            <Button icon="trash" color="transparent" onClick={() => act('clear_links')}>
              Разорвать связи
            </Button>
          }
        >
          <Box position="relative" width="100%" height="320px" style={{ backgroundColor: 'rgba(0,0,0,0.2)', border: '1px solid #333' }}>
            
            <svg style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%', pointerEvents: 'none' }}>
              {data.links?.map((link, i) => {
                const [a, b] = link;
                const posA = centers[a];
                const posB = centers[b];
                return (
                  <line 
                    key={i} 
                    x1={`${posA.x}%`} y1={`${posA.y}%`} 
                    x2={`${posB.x}%`} y2={`${posB.y}%`} 
                    stroke="#00ffcc" 
                    strokeWidth="4" 
                    strokeDasharray="5, 5"
                    style={{ filter: 'drop-shadow(0px 0px 4px #00ffcc)' }}
                  />
                );
              })}
            </svg>

            {data.slots.map((slot, index) => {
              const num = index + 1;
              const pos = centers[num];
              const isEmpty = !slot.ref;
              const isSelected = selectedSlot === num;
              
              return (
                <Box 
                  key={index} 
                  position="absolute" 
                  style={{ 
                    top: `calc(${pos.y}% - 35px)`, 
                    left: `calc(${pos.x}% - 80px)`, 
                    width: '160px', 
                    height: '70px', 
                    border: isSelected ? '2px solid #00ffcc' : '1px solid gray', 
                    backgroundColor: isEmpty ? 'transparent' : 'rgba(0, 100, 50, 0.4)', 
                    cursor: 'pointer',
                    boxShadow: isSelected ? '0 0 10px #00ffcc' : 'none',
                    transition: 'all 0.2s ease-in-out'
                  }} 
                  onClick={() => handleSlotClick(num, isEmpty)}
                >
                  {!isEmpty && (
                    <Button
                      icon="eject"
                      color="transparent"
                      tooltip="Убрать на склад"
                      style={{ position: 'absolute', top: '-10px', right: '-10px', backgroundColor: '#333', borderRadius: '50%' }}
                      onClick={(e) => {
                        e.stopPropagation();
                        act('eject', { slot: num });
                        if (isSelected) setSelectedSlot(null);
                      }}
                    />
                  )}

                  <Stack fill align="center" p={1}>
                    {slot.image ? <img src={slot.image} style={{ width: '32px', height: '32px', imageRendering: 'pixelated' }} /> : <Icon name="plus" color="gray" />}
                    <Stack.Item grow ml={1}>
                      <Box bold>{slot.name || "Пусто"}</Box>
                      <Box fontSize="0.8em" italic color={slot.smell ? "teal" : "gray"}>
                        {slot.smell || "Нет запаха"}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Box>
              );
            })}
          </Box>

          <Box mt={2} p={1} style={{ backgroundColor: 'rgba(0,0,0,0.3)', border: '1px solid #444', borderRadius: '4px' }}>
            <Stack align="center" justify="space-between" mb={1}>
              <Stack.Item bold>Содержимое котла:</Stack.Item>
              <Stack.Item fontSize="0.9em" color="gray">На 1 варку нужно 90 u воды</Stack.Item>
            </Stack>
            
            <ProgressBar
              value={data.total_volume}
              minValue={0}
              maxValue={data.max_volume}
              color={data.reagents?.length > 0 ? data.reagents[0].color : 'blue'}
            >
              {data.total_volume} / {data.max_volume} u
            </ProgressBar>
            
            <Box mt={1} fontSize="0.9em">
              {!data.reagents || data.reagents.length === 0 ? (
                <Box color="gray" italic>Котел пуст</Box>
              ) : (
                <Stack fill wrap>
                  {data.reagents.map((r, i) => (
                    <Stack.Item key={i} mr={2}>
                      <Icon name="circle" style={{ color: r.color }} mr={1} />
                      {r.name}: {r.volume} u
                    </Stack.Item>
                  ))}
                </Stack>
              )}
            </Box>
          </Box>

          <Button 
            fluid 
            mt={2} 
            lineHeight={2} 
            fontSize="16px"
            bold
            color="good" 
            onClick={() => act('mix')}
          >
            ЗАПУСТИТЬ ТРАНСМУТАЦИЮ
          </Button>
        </Section>
      </Stack.Item>

      {assigningToSlot !== null && (
        <Stack.Item width="220px" ml={1}>
          <Section 
            title={`В слот ${assigningToSlot}`} 
            fill 
            scrollable
            buttons={<Button icon="times" color="transparent" onClick={() => setAssigningToSlot(null)} />}
          >
            {data.available_ingredients.length === 0 ? (
              <Box color="gray" italic p={1}>Склад лаборатории пуст. Положите ингредиенты в стол.</Box>
            ) : (
              data.available_ingredients.map((ing, i) => (
                <Button key={i} fluid mb={1} onClick={() => { act('assign_slot', { slot: assigningToSlot, item_ref: ing.ref }); setAssigningToSlot(null); }}>
                  <Stack align="center">
                    {ing.image && <img src={ing.image} style={{ width: '24px', height: '24px', marginRight: '4px', imageRendering: 'pixelated' }} />}
                    <Box>{ing.name}</Box>
                  </Stack>
                </Button>
              ))
            )}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};

const CraftingTab = () => {
  const { act, data } = useBackend<Data>();
  const [assigning, setAssigning] = useState<number | null>(null);

  return (
    <Section title="Алхимическая Кузня" fill>
      <Stack align="center" justify="center">
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 48px)', gap: '2px' }}>
          {data.crafting_grid.map((slot, i) => (
            <div key={i} style={{ width: 48, height: 48, border: '1px solid gray', cursor: 'pointer' }} onClick={() => slot.ref ? act('clear_craft', { slot: i + 1 }) : setAssigning(i + 1)}>
              {slot.image && <img src={slot.image} style={{ width: 48, height: 48 }} />}
            </div>
          ))}
        </div>
        <Icon name="arrow-right" size={4} mx={2} />
        <div style={{ width: 64, height: 64, border: '2px solid white' }} onClick={() => act('do_grid_craft')}>
          {data.craft_result && <img src={data.craft_result.image} style={{ width: 64, height: 64 }} />}
        </div>
      </Stack>
      
      {assigning && (
        <Section title={`Выбор компонента ${assigning}`} mt={2}>
          {data.available_all_items.map((item, i) => (
            <Button key={i} fluid onClick={() => { act('assign_craft', { slot: assigning, item_ref: item.ref }); setAssigning(null); }}>
              {item.name}
            </Button>
          ))}
        </Section>
      )}
    </Section>
  );
};


const RequirementBox = ({ tier, smell }: { tier: string, smell: string | null }) => {
  if (!smell) return null;

  const count = tier === 'strong' ? 3 : tier === 'medium' ? 2 : 1;
  const isUnknown = smell === "???";
  
  const color = isUnknown ? "gray" : tier === 'strong' ? "#e74c3c" : tier === 'medium' ? "#f1c40f" : "#3498db";

  return (
    <Box p={0.5} mr={1} style={{ border: `1px solid ${color}`, borderRadius: '4px', backgroundColor: 'rgba(0,0,0,0.5)' }}>
      <Stack align="center">
        <Box bold mr={1} color="white">{count}x</Box>
        <Icon name={isUnknown ? "question-circle" : "leaf"} color={color} mr={1} />
        <Box color={isUnknown ? "gray" : "white"} italic={isUnknown}>
          {isUnknown ? "Неизвестно" : smell}
        </Box>
      </Stack>
    </Box>
  );
};

const InfusionRequirements = ({ reqs }: { reqs: any }) => {
  const elements: React.ReactNode[] = [];

  ['strong', 'medium', 'light'].forEach((tier) => {
    if (reqs[tier] && reqs[tier].length > 0) {
      reqs[tier].forEach((smell) => {
        if (elements.length > 0) {
          elements.push(<Box key={`plus-${elements.length}`} mx={0.5} color="gray" bold>+</Box>);
        }
        elements.push(<RequirementBox key={`${tier}-${smell}-${elements.length}`} tier={tier} smell={smell} />);
      });
    }
  });

  return <Stack align="center">{elements}</Stack>;
};

const GridPreview = ({ icons }: { icons: (string | null)[] }) => (
  <Box style={{ 
    display: 'grid', 
    gridTemplateColumns: 'repeat(3, 36px)',
    gap: '3px', 
    backgroundColor: 'rgba(0,0,0,0.6)', 
    padding: '6px',
    border: '2px solid #555',
    borderRadius: '4px',
    boxShadow: 'inset 0 0 10px rgba(0,0,0,0.5)'
  }}>
    {icons.map((icon, i) => (
      <Box key={i} style={{ 
        width: '36px', 
        height: '36px', 
        border: '1px solid #444',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: icon ? 'rgba(255,255,255,0.03)' : 'transparent'
      }}>
        {icon && (
          <img 
            src={icon} 
            style={{ 
              width: '32px',
              height: '32px', 
              imageRendering: 'pixelated' 
            }} 
          />
        )}
      </Box>
    ))}
  </Box>
);

const TransmutationTab = () => {
  const { act, data } = useBackend<Data>();
  const [selecting, setSelecting] = useState(false);

  const isCritical = data.p_stone ? data.p_stone.charges < 20 : false;

  return (
    <Section title="Трансмутация" fill scrollable>
      <Stack vertical fill>
        <Stack.Item>
          {data.p_stone ? (
            <Box 
              p={1} 
              style={{ 
                border: isCritical ? '2px solid #ff0000' : '1px solid gold', 
                borderRadius: '4px', 
                backgroundColor: isCritical ? 'rgba(255, 0, 0, 0.1)' : 'rgba(255, 215, 0, 0.1)',
                boxShadow: isCritical ? '0 0 10px rgba(255, 0, 0, 0.5)' : 'none'
              }}
            >
              <Stack align="center">
                <Icon 
                  name="gem" 
                  color={isCritical ? "red" : "gold"} 
                  size={2} 
                  mr={1} 
                  style={{ animation: isCritical ? 'blink 1s infinite' : 'none' }}
                />
                <Stack.Item grow>
                  <Box bold color={isCritical ? "red" : "gold"} fontSize="1.1em">
                    {isCritical ? "КАМЕНЬ ИСТОЩЕН" : "ФИЛОСОФСКИЙ КАМЕНЬ"}
                  </Box>
                  <ProgressBar 
                    value={data.p_stone.charges} 
                    maxValue={data.p_stone.max} 
                    color={isCritical ? "danger" : "red"} 
                    mt={0.5} 
                  />
                  <Stack justify="space-between" mt={0.5}>
                    <Box fontSize="0.9em">Зарядов: {Math.round(data.p_stone.charges)} / {data.p_stone.max}</Box>
                    <Box fontSize="0.9em">Душа: {data.p_stone.owner}</Box>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Box>
          ) : (
            <Box 
              p={2} 
              textAlign="center" 
              color="gray" 
              style={{ fontStyle: 'italic', border: '1px dashed gray', borderRadius: '4px' }}
            >
              Положите привязанный Философский Камень в склад стола для активации...
            </Box>
          )}
        </Stack.Item>

        <Stack.Item mt={2} mb={2}>
          <Stack align="center" justify="center">
            <Box 
              onClick={() => data.transmute_item ? act('transmute_eject') : setSelecting(true)}
              style={{ 
                width: '80px', height: '80px', border: '2px dashed gold', 
                display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
                backgroundColor: 'rgba(255, 255, 255, 0.05)', borderRadius: '8px',
                boxShadow: data.transmute_item ? '0 0 15px rgba(255, 215, 0, 0.3)' : 'none'
              }}
            >
              {data.transmute_item ? (
                <img src={data.transmute_item.image} style={{ width: '64px', imageRendering: 'pixelated' }} />
              ) : (
                <Icon name="plus" size={3} color="gray" />
              )}
            </Box>
            
            <Icon name="arrow-right" size={3} mx={4} color="gold" />
            
            <Box style={{ 
              width: '80px', height: '80px', border: '2px solid #555', 
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              backgroundColor: 'rgba(0,0,0,0.4)', borderRadius: '8px'
            }}>
              <Icon name="question" size={3} color="gray" opacity={0.3} />
            </Box>
          </Stack>
        </Stack.Item>

        <Stack.Item grow>
          {data.transmute_recipes?.length > 0 ? (
            data.transmute_recipes.map((recipe, i) => {

              const isLethal = data.p_stone && data.p_stone.charges < recipe.cost;
              
              return (
                <Button 
                  key={i} 
                  fluid 
                  mb={1} 
                  color={isLethal ? "danger" : "gold"}
                  disabled={!data.p_stone} 
                  onClick={() => act('do_transmute', { recipe_ref: recipe.ref })}
                  style={{ height: '42px' }}
                >
                  <Stack align="center">
                    <Stack.Item mr={1}>
                      <img src={recipe.icon} style={{ width: '32px', height: '32px', imageRendering: 'pixelated' }} />
                    </Stack.Item>
                    <Stack.Item grow textAlign="left">
                      <Box bold fontSize="1.1em">
                        {recipe.name}
                        {isLethal && (
                          <Box inline ml={1} color="red" fontSize="0.8em" style={{ textShadow: '0 0 5px black' }}>
                            [СМЕРТЕЛЬНО]
                          </Box>
                        )}
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Box bold color={isLethal ? "red" : "yellow"} fontSize="1.1em">
                        <Icon name="bolt" mr={0.5} /> {recipe.cost}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Button>
              );
            })
          ) : (
            <Box 
              textAlign="center" 
              color="gray" 
              mt={2} 
              style={{ fontStyle: 'italic' }}
            >
              {data.transmute_item 
                ? "Нет доступных трансмутаций для этой материи." 
                : "Положите базовый материал (слиток, ткань, кожу) в слот."}
            </Box>
          )}
        </Stack.Item>
      </Stack>

      {selecting && (
        <Box 
          style={{ 
            position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, 
            backgroundColor: 'rgba(0,0,0,0.95)', zIndex: 100, padding: '15px',
            border: '2px solid gold', borderRadius: '4px'
          }}
        >
          <Section 
            title="Выберите материал" 
            fill 
            scrollable 
            buttons={<Button icon="times" color="transparent" onClick={() => setSelecting(false)} />}
          >
            {data.available_all_items.length > 0 ? (
              data.available_all_items.map((item, i) => (
                <Button 
                  key={i} 
                  fluid 
                  mb={1} 
                  onClick={() => { act('transmute_assign', { item_ref: item.ref }); setSelecting(false); }}
                >
                  <Stack align="center">
                    <img src={item.image} style={{ width: '24px', height: '24px', marginRight: '8px' }} />
                    <Box>{item.name}</Box>
                  </Stack>
                </Button>
              ))
            ) : (
              <Box italic color="gray" textAlign="center">Склад стола пуст...</Box>
            )}
          </Section>
        </Box>
      )}

      <style>{`
        @keyframes blink {
          0% { opacity: 1; }
          50% { opacity: 0.3; }
          100% { opacity: 1; }
        }
      `}</style>
    </Section>
  );
};

const LaboratoryTab = () => {
  const { act, data } = useBackend<Data>();
  

  const [selectingBeaker, setSelectingBeaker] = useState<string | null>(null);
  const [transferMenu, setTransferMenu] = useState<{ 
    slot: string, 
    mode: 'to_cauldron' | 'from_cauldron' | 'to_pills' 
  } | null>(null);
  const [pillDrainMenu, setPillDrainMenu] = useState(false);


  const BeakerSlot = ({ num, beaker }: { num: string, beaker: BeakerData | null }) => (
    <Box p={1} style={{ border: '1px solid #555', backgroundColor: 'rgba(0,0,0,0.3)', borderRadius: '4px' }}>
      <Stack align="center">
        <Stack.Item>
          <Box 
            style={{ 
              width: '64px', height: '64px', border: '1px solid gold', 
              textAlign: 'center', position: 'relative', backgroundColor: 'rgba(0,0,0,0.2)' 
            }}
          >
            {!beaker ? (
              <Box 
                onClick={() => setSelectingBeaker(num)} 
                style={{ width: '100%', height: '100%', cursor: 'pointer', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}
              >
                <Icon name="plus" size={2} color="gray" />
                <Box fontSize="0.7em" color="gray">Вставить</Box>
              </Box>
            ) : (
              <Box style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
                <Icon name="flask" size={2} color="blue" />
                <Box fontSize="0.6em" bold color="white" style={{ overflow: 'hidden', whiteSpace: 'nowrap', padding: '0 2px' }}>
                  {beaker.name}
                </Box>
                <Button
                  icon="times"
                  color="transparent"
                  style={{ position: 'absolute', top: 0, right: 0 }}
                  onClick={() => act('lab_eject_beaker', { slot: num })}
                />
              </Box>
            )}
          </Box>
        </Stack.Item>

        <Stack.Item grow ml={1}>
          {beaker ? (
            <Box>
              <Box bold fontSize="0.9em" color="blue">{beaker.cur} / {beaker.max} u</Box>
              <Stack mt={0.5}>
                <Stack.Item grow>
                  <Button fluid color="good" onClick={() => setTransferMenu({ slot: num, mode: 'to_cauldron' })}>В Котел</Button>
                </Stack.Item>
                <Stack.Item grow ml={0.5}>
                  <Button fluid color="average" onClick={() => setTransferMenu({ slot: num, mode: 'from_cauldron' })}>Из Котла</Button>
                </Stack.Item>
              </Stack>
              <Button fluid mt={0.5} color="warning" onClick={() => setTransferMenu({ slot: num, mode: 'to_pills' })}>В пыль</Button>
            </Box>
          ) : (
            <Box color="gray" style={{ fontStyle: 'italic', fontSize: '0.8em' }}>Слот {num} пуст</Box>
          )}
        </Stack.Item>
      </Stack>
    </Box>
  );

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="Манипуляция емкостями">
          <Stack fill>
            <Stack.Item grow><BeakerSlot num="1" beaker={data.beaker1} /></Stack.Item>
            <Stack.Item grow ml={1}><BeakerSlot num="2" beaker={data.beaker2} /></Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        <Section title="Алхимическая пыль" fill>
          <Stack fill align="center">
            <Stack.Item>
              <Box textAlign="center" p={1} style={{ border: '1px solid #444', width: '80px', backgroundColor: 'rgba(0,0,0,0.2)' }}>
                 <Icon name="wind" size={2} color="silver" />
                 <Box bold fontSize="0.9em">Основа</Box>
                 <Box fontSize="1.5em" color="silver" bold>{data.flour_count}</Box>
                 <Box fontSize="0.7em" color="gray">(на складе)</Box>
              </Box>
            </Stack.Item>
            
            <Stack.Item grow ml={2}>
               <Stack justify="space-between" mb={0.5}>
                 <Box bold color="teal">Буфер смеси: {data.pill_mix_total} u</Box>
                 <Button 
                    icon="reply-all" 
                    color="transparent" 
                    disabled={data.pill_mix_total <= 0}
                    onClick={() => setPillDrainMenu(true)}
                  >
                    Слить смесь
                  </Button>
               </Stack>
               
               <Box height="80px" style={{ border: '1px solid #333', padding: '4px', fontSize: '0.9em', overflowY: 'auto', backgroundColor: 'rgba(0,0,0,0.4)' }}>
                  {data.pill_mix?.map((r, i) => (
                    <div key={i} style={{ borderBottom: '1px solid #222' }}>
                      <span style={{ color: '#ccc' }}>• {r.name}:</span> <b style={{ color: '#00ffcc' }}>{r.vol}u</b>
                    </div>
                  ))}
                  {(!data.pill_mix || data.pill_mix.length === 0) && (
                    <Box color="gray" style={{ fontStyle: 'italic' }} textAlign="center" mt={2}>Буфер пуст</Box>
                  )}
               </Box>
               
               <Button 
                fluid mt={1} color="silver" icon="spray-can-sparkles" bold
                disabled={data.flour_count <= 0 || data.pill_mix_total < 15} 
                onClick={() => act('make_pills')}
               >
                 ИЗГОТОВИТЬ ПЫЛЬ (15u)
               </Button>
               <Box fontSize="0.8em" color="gray" style={{ fontStyle: 'italic' }} mt={0.5}>
                 Порошок скрывает реагенты при подмешивании в еду.
               </Box>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      {pillDrainMenu && (
        <Box style={{ position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, backgroundColor: 'rgba(0,0,0,0.95)', zIndex: 120, padding: '20px' }}>
          <Section 
            title="Куда вернуть реагенты из буфера?" 
            fill scrollable
            buttons={<Button icon="times" color="transparent" onClick={() => setPillDrainMenu(false)} />}
          >
            {data.pill_mix?.map((r, i) => (
              <Stack key={i} mb={1} align="center" style={{ borderBottom: '1px solid #333', paddingBottom: '4px' }}>
                <Stack.Item grow>
                   <Box bold fontSize="1.1em">{r.name}</Box>
                   <Box fontSize="0.8em" color="gray">Доступно: {r.vol}u</Box>
                </Stack.Item>
                <Stack.Item>
                   <Box mb={0.5} textAlign="right">
                     <Box inline mr={1} fontSize="0.8em" color="gray">В Котел:</Box>
                     <Button onClick={() => { act('pill_to_cauldron', { reagent: r.id, amount: 5 }); setPillDrainMenu(false); }}>5</Button>
                     <Button ml={0.5} onClick={() => { act('pill_to_cauldron', { reagent: r.id, amount: 15 }); setPillDrainMenu(false); }}>15</Button>
                     <Button ml={0.5} color="good" onClick={() => { act('pill_to_cauldron', { reagent: r.id, amount: r.vol }); setPillDrainMenu(false); }}>Всё</Button>
                   </Box>
                   <Box textAlign="right">
                     <Box inline mr={1} fontSize="0.8em" color="gray">В Слот:</Box>
                     <Button disabled={!data.beaker1} onClick={() => { act('pill_to_beaker', { slot: "1", reagent: r.id, amount: r.vol }); setPillDrainMenu(false); }}>S1</Button>
                     <Button ml={0.5} disabled={!data.beaker2} onClick={() => { act('pill_to_beaker', { slot: "2", reagent: r.id, amount: r.vol }); setPillDrainMenu(false); }}>S2</Button>
                   </Box>
                </Stack.Item>
              </Stack>
            ))}
          </Section>
        </Box>
      )}

      {transferMenu && (
        <Box style={{ position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, backgroundColor: 'rgba(0,0,0,0.95)', zIndex: 110, padding: '20px' }}>
          <Section 
            title="Выберите реагент и объем переноса" 
            fill scrollable
            buttons={<Button icon="times" color="transparent" onClick={() => setTransferMenu(null)} />}
          >
            {(transferMenu.mode === 'from_cauldron' 
              ? data.cauldron_reagents 
              : (transferMenu.slot === "1" ? data.beaker1?.contents : data.beaker2?.contents)
            )?.map((r, i) => (
              <Stack key={i} mb={1} align="center" style={{ borderBottom: '1px solid #333', paddingBottom: '4px' }}>
                <Stack.Item grow>
                  <Box bold fontSize="1.1em">{r.name}</Box>
                  <Box fontSize="0.8em" color="gray">Доступно: {r.vol}u</Box>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => { 
                    const action = transferMenu.mode === 'to_cauldron' ? 'pour_to_cauldron' : (transferMenu.mode === 'from_cauldron' ? 'fill_from_cauldron' : 'add_to_pill_mix');
                    act(action, { slot: transferMenu.slot, reagent: r.id, amount: 5 }); 
                    setTransferMenu(null); 
                  }}>5</Button>
                  <Button ml={0.5} onClick={() => { 
                    const action = transferMenu.mode === 'to_cauldron' ? 'pour_to_cauldron' : (transferMenu.mode === 'from_cauldron' ? 'fill_from_cauldron' : 'add_to_pill_mix');
                    act(action, { slot: transferMenu.slot, reagent: r.id, amount: 10 }); 
                    setTransferMenu(null); 
                  }}>10</Button>
                  <Button ml={0.5} onClick={() => { 
                    const action = transferMenu.mode === 'to_cauldron' ? 'pour_to_cauldron' : (transferMenu.mode === 'from_cauldron' ? 'fill_from_cauldron' : 'add_to_pill_mix');
                    act(action, { slot: transferMenu.slot, reagent: r.id, amount: 15 }); 
                    setTransferMenu(null); 
                  }}>15</Button>
                  <Button ml={0.5} color="good" onClick={() => { 
                    const action = transferMenu.mode === 'to_cauldron' ? 'pour_to_cauldron' : (transferMenu.mode === 'from_cauldron' ? 'fill_from_cauldron' : 'add_to_pill_mix');
                    act(action, { slot: transferMenu.slot, reagent: r.id, amount: r.vol }); 
                    setTransferMenu(null); 
                  }}>Всё</Button>
                </Stack.Item>
              </Stack>
            ))}
          </Section>
        </Box>
      )}

      {selectingBeaker && (
        <Box style={{ position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, backgroundColor: 'rgba(0,0,0,0.9)', zIndex: 100, padding: '20px' }}>
          <Section 
            title={`Выберите емкость для слота ${selectingBeaker}`} 
            fill scrollable 
            buttons={<Button icon="times" color="transparent" onClick={() => setSelectingBeaker(null)} />}
          >
            {data.available_all_items.length > 0 ? (
              data.available_all_items.map((item, i) => (
                <Button 
                  key={i} fluid mb={1} 
                  onClick={() => { act('lab_assign_beaker', { slot: selectingBeaker, item_ref: item.ref }); setSelectingBeaker(null); }}
                >
                  <Stack align="center">
                    <img src={item.image} style={{ width: '24px', height: '24px', marginRight: '8px', imageRendering: 'pixelated' }} />
                    <Box>{item.name}</Box>
                  </Stack>
                </Button>
              ))
            ) : (
              <Box color="gray" style={{ fontStyle: 'italic' }} textAlign="center" mt={2}>
                В инвентаре стола нет подходящих емкостей.
              </Box>
            )}
          </Section>
        </Box>
      )}
    </Stack>
  );
};

const GrimoireTab = () => {
  const { data } = useBackend<Data>();
  const [subTab, setSubTab] = useState<'potions' | 'crafting'>('potions');
  const knowledge = data.knowledge || [];

  const filteredKnowledge = knowledge.filter(r => 
    subTab === 'potions' ? r.type === 'infusion' : r.type === 'grid'
  );

  return (
    <Section 
      fill 
      scrollable 
      title="Древние Знания"
      buttons={
        <Tabs>
          <Tabs.Tab selected={subTab === 'potions'} onClick={() => setSubTab('potions')}>Зелья</Tabs.Tab>
          <Tabs.Tab selected={subTab === 'crafting'} onClick={() => setSubTab('crafting')}>Инструменты</Tabs.Tab>
        </Tabs>
      }
    >
      <Stack vertical fill scrollable>
        {filteredKnowledge.length === 0 && (
          <Box italic color="gray" textAlign="center" mt={5}>Записи пустуют...</Box>
        )}
        
        {filteredKnowledge.map((recipe, index) => {
          const isGrid = recipe.type === 'grid';
          const isInfusion = recipe.type === 'infusion';
          const isDiscovered = !!recipe.found;
          const isHint = !!recipe.is_hint;
          
          return (
            <Stack.Item key={index}>
              <Box 
                p={1} 
                mb={1} 
                style={{ 
                  border: `1px solid ${isGrid ? '#444' : (isDiscovered ? '#2ecc71' : '#f1c40f')}`, 
                  backgroundColor: 'rgba(0,0,0,0.3)',
                  borderRadius: '4px'
                }}
              >
                <Stack align="center" justify="space-between">
                  <Stack.Item>
                    <Stack align="center">
                      <Box mr={1.5}>
                        {recipe.result_img ? (
                          <img src={recipe.result_img} style={{ width: '32px', height: '32px' }} />
                        ) : (
                          <Icon 
                            name={isHint ? "search" : "flask"} 
                            size={1.5} 
                            color={isDiscovered ? "good" : "average"} 
                          />
                        )}
                      </Box>
                      <Box>
                        <Box bold fontSize="1.2em" color="white" style={{ fontFamily: 'Georgia, serif' }}>
                          {recipe.name}
                        </Box>
                      </Box>
                    </Stack>
                  </Stack.Item>

                  <Stack.Item>
                    <Stack align="center">
                      {isInfusion && <InfusionRequirements reqs={recipe.reqs} />}
                      {isGrid && <GridPreview icons={recipe.grid_icons || []} />}
                      
                      {isInfusion && (
                        <Box ml={2} bold fontSize="0.9em" color={isDiscovered ? "good" : "average"} style={{ textTransform: 'uppercase' }}>
                          {isDiscovered ? "ИЗУЧЕНО" : "ЗАЦЕПКА"}
                        </Box>
                      )}
                    </Stack>
                  </Stack.Item>
                </Stack>
              </Box>
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
};
