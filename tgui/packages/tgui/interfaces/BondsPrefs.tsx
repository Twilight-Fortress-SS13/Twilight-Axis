import { Box, Button, NoticeBox, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type FlavorEntry = {
  key: string;
  label: string;
  enabled: boolean;
};

type Data = {
  seedCount: number;
  maxSeeds: number;
  flavors: FlavorEntry[];
  locked: boolean;
};

export const BondsPrefs = () => {
  const { act, data } = useBackend<Data>();
  const { seedCount = 0, maxSeeds = 3, flavors = [], locked } = data;
  const counts = Array.from({ length: maxSeeds + 1 }, (_, index) => index);
  const anyFlavor = !flavors.some((flavor) => flavor.enabled);

  return (
    <Window title="Настройки связей" width={520} height={460}>
      <Window.Content style={{ backgroundImage: 'none' }}>
        <Stack vertical fill>
          {!!locked && (
            <Stack.Item>
              <NoticeBox info>
                Настройки на этот раунд уже зафиксированы. Изменения вступят в
                силу со следующего раунда.
              </NoticeBox>
            </Stack.Item>
          )}
          <Stack.Item>
            <Section title="Сколько знакомств на старте">
              <Stack>
                {counts.map((value) => (
                  <Stack.Item key={value}>
                    <Button
                      selected={seedCount === value}
                      onClick={() => act('set_seed_count', { value })}
                    >
                      {value}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
              <Box mt={1} opacity={0.7}>
                Система подберёт вам столько уже знакомых людей, отдавая
                предпочтение тем, кто близок по роду занятий.
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section title="Какие истории вам подходят">
              <Stack vertical>
                {flavors.map((flavor) => (
                  <Stack.Item key={flavor.key}>
                    <Button
                      fluid
                      selected={flavor.enabled}
                      onClick={() => act('toggle_flavor', { key: flavor.key })}
                    >
                      {flavor.label}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
              {!!anyFlavor && (
                <Box mt={1} opacity={0.7}>
                  Ничего не выбрано — подойдёт любая история.
                </Box>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
