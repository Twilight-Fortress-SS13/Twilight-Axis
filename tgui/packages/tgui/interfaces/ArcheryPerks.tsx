import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Button, Section, Stack, Box, NoticeBox } from 'tgui-core/components';

const perks = [
  {
    id: 'doubleshot',
    name: 'Двойной выстрел',
    desc: 'Выпускает стрелу, а спустя 0.2 секунды автоматически достает вторую стрелу из колчана и запускает её вслед за первой.',
    color: 'red',
  },
  {
    id: 'longshot',
    name: 'Дальнобойный выстрел',
    desc: 'Тщательное прицеливание. Урон выстрела значительно возрастает в зависимости от расстояния до цели.',
    color: 'purple',
  },
  {
    id: 'backstep',
    name: 'Выстрел с отскоком',
    desc: 'Выстреливает в цель, одновременно совершая прыжок назад. После приземления скорость передвижения ненадолго увеличивается.',
    color: 'blue',
  },
];

interface Data {
  has_perk: boolean;
  selected_perk: string;
}

export const ArcheryPerks = (props) => {
  const { act, data } = useBackend<Data>();
  const { has_perk, selected_perk } = data;

  return (
    <Window title="Стиль стрельбы Эксперта" width={550} height={350}>
      <Window.Content>
        {has_perk && (
          <NoticeBox info>
            Вы уже выбрали свой путь мастерства. Изменить его нельзя.
          </NoticeBox>
        )}
        <Section fill scrollable title="Доступные стили">
          <Stack vertical fill>
            {perks.map((perk) => {
              const isSelected = selected_perk === perk.id;
              
              return (
                <Section key={perk.id}>
                  <Stack fill justify="space-between" align="center">
                    <Stack.Item grow>
                      <Box bold fontSize="14px" color={isSelected ? 'green' : perk.color}>
                        {perk.name}
                      </Box>
                      <Box color="label" mt={1}>
                        {perk.desc}
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        color={isSelected ? 'green' : perk.color}
                        disabled={has_perk}
                        onClick={() => act('select_perk', { perk_id: perk.id })}
                      >
                        {isSelected ? 'Выбрано' : 'Выбрать'}
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Section>
              );
            })}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
