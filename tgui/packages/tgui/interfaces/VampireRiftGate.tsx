import { Box, Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type RiftAmulet = {
  ref: string;
  name: string;
  area: string;
  uses: number;
  isTwilight: boolean;
};

type RiftGateData = {
  isVampire: boolean;
  vitaeCost: number;
  hasVitae: boolean;
  sendingActive: boolean;
  amulets: RiftAmulet[];
};

const formatVitae = (value: number) => Math.round(value || 0).toLocaleString('ru-RU');

export const VampireRiftGate = () => {
  const { act, data } = useBackend<RiftGateData>();
  const {
    isVampire = false,
    vitaeCost = 1000,
    hasVitae = false,
    sendingActive = false,
    amulets = [],
  } = data;

  return (
    <Window title="Врата разлома" width={430} height={360} theme="dark">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow>
                  <Box bold fontSize={1.2}>
                    ВРАТА РАЗЛОМА
                  </Box>
                  <Box color="label">Цена: {formatVitae(vitaeCost)} витэ</Box>
                </Stack.Item>
                <Stack.Item>
                  <Box color={sendingActive ? 'bad' : 'good'}>
                    {sendingActive ? 'ОТПРАВКА АКТИВНА' : 'СПИТ'}
                  </Box>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <Section title="Якоря" fill scrollable>
              {!isVampire ? (
                <EmptyState text="Только вампиры могут пробудить Врата разлома." />
              ) : amulets.length ? (
                amulets.map((amulet) => (
                  <Box
                    key={amulet.ref}
                    mb={1}
                    p={1}
                    style={{
                      border: '1px solid #55242a',
                      borderRadius: '6px',
                      background: 'rgba(30, 8, 12, 0.78)',
                    }}
                  >
                    <Stack align="center">
                      <Stack.Item grow basis={0}>
                        <Box bold>{amulet.name}</Box>
                        <Box color="label">{amulet.area}</Box>
                        <Box color={amulet.isTwilight ? 'good' : 'average'}>
                          {amulet.isTwilight ? 'Сумеречный якорь' : 'Старый якорь'} -{' '}
                          зарядов: {amulet.uses}
                        </Box>
                      </Stack.Item>
                      <Stack.Item width="92px">
                        <Button
                          fluid
                          icon="reply"
                          disabled={!hasVitae}
                          onClick={() => act('open_return', { amulet_ref: amulet.ref })}
                        >
                          НАЗАД
                        </Button>
                        <Button
                          fluid
                          mt={0.5}
                          icon="share"
                          disabled={!hasVitae || sendingActive}
                          onClick={() => act('open_sending', { amulet_ref: amulet.ref })}
                        >
                          ТУДА
                        </Button>
                      </Stack.Item>
                    </Stack>
                  </Box>
                ))
              ) : (
                <EmptyState text="Нет привязанных амулетов разлома." />
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const EmptyState = ({ text }: { text: string }) => (
  <Box
    italic
    textAlign="center"
    color="label"
    p={2}
    style={{
      border: '1px dashed #55242a',
      borderRadius: '6px',
      background: 'rgba(18, 8, 10, 0.55)',
    }}
  >
    {text}
  </Box>
);
