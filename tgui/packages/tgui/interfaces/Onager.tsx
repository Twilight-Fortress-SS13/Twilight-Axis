import { useBackend } from '../backend';
import { Box, Button, Section, Slider, Stack } from 'tgui-core/components';
import { Window } from '../layouts';

type OnagerData = {
  ready: boolean;
  loaded: boolean;
  launched: boolean;
  
  direction: string;
  target_distance: number;
  min_distance: number;
  max_distance: number;
};

export const Onager = (props, context) => {
  const { act, data } = useBackend<OnagerData>(context);
  
  if (!data) {
    return (
      <Window title="Onager" width={400} height={350}>
        <Window.Content>Loading...</Window.Content>
      </Window>
    );
  }

  const {
    ready,
    loaded,
    direction,
    target_distance,
    min_distance,
    max_distance,
  } = data;

  // Стили для квадратных кнопок
  const squareBtnStyle = {
    width: '32px',
    height: '32px',
    padding: '0',
    textAlign: 'center',
    lineHeight: '30px', // Центровка иконки по вертикали
  };

  return (
    <Window
      title="Onager"
      width={400}
      height={380} // Чуть уменьшил высоту, так как убрали ХП
      theme="necro"
    >
      <Window.Content>
        <Stack vertical fill>
          
          {/* СТАТУС */}
          <Section title="Status">
            <Stack fill justify="space-around">
              <Box textAlign="center">
                <Box color="label" mb={0.5}>Mechanism</Box>
                <Box color={ready ? 'good' : 'orange'} bold>
                  {ready ? 'Tensioned' : 'Slack'}
                </Box>
              </Box>
              
              <Box textAlign="center">
                <Box color="label" mb={0.5}>Payload</Box>
                <Box color={loaded ? 'good' : 'grey'} bold>
                  {loaded ? 'Loaded' : 'Empty'}
                </Box>
              </Box>
            </Stack>
          </Section>

          {/* НАВЕДЕНИЕ */}
          <Section title="Targeting">
            <Stack fill>
              
              {/* Левая часть: Кнопки направления */}
              <Stack.Item width="40%">
                <Box textAlign="center" mb={1} color="label" fontSize="0.9em">
                  Direction
                </Box>
                <Stack justify="center" align="center">
                  <Button
                    icon="arrow-left"
                    selected={direction === 'WEST'}
                    style={squareBtnStyle}
                    onClick={() => act('set_dir', { dir: 'WEST' })}
                  />
                  <Stack vertical mx={0.5}>
                    <Button
                      icon="arrow-up"
                      selected={direction === 'NORTH'}
                      style={squareBtnStyle}
                      onClick={() => act('set_dir', { dir: 'NORTH' })}
                      mb={0.5}
                    />
                    <Button
                      icon="arrow-down"
                      selected={direction === 'SOUTH'}
                      style={squareBtnStyle}
                      onClick={() => act('set_dir', { dir: 'SOUTH' })}
                    />
                  </Stack>
                  <Button
                    icon="arrow-right"
                    selected={direction === 'EAST'}
                    style={squareBtnStyle}
                    onClick={() => act('set_dir', { dir: 'EAST' })}
                  />
                </Stack>
              </Stack.Item>

              {/* Правая часть: Дистанция */}
              <Stack.Item grow={1} ml={2}>
                <Stack vertical height="100%" justify="center">
                  <Box mb={1} textAlign="center">
                    Distance: <Box inline bold color="white" fontSize="1.1em">{target_distance}</Box>
                  </Box>
                  <Slider
                    value={target_distance}
                    minValue={min_distance}
                    maxValue={max_distance}
                    step={1}
                    fill // Растягивает слайдер на всю ширину
                    onChange={(e, value) => act('set_distance', { dist: value })}
                  />
                  <Box mt={0.5} textAlign="center" color="label" fontSize="0.8em">
                    ({min_distance} - {max_distance} tiles)
                  </Box>
                </Stack>
              </Stack.Item>

            </Stack>
          </Section>

          {/* ДЕЙСТВИЯ */}
          <Section>
            <Stack justify="space-between">
              
              <Box width="65%">
                {/* Если не готов - показываем кнопку взвода */}
                {!ready ? (
                  <Button
                    icon="cog"
                    content="Crank Mechanism"
                    color="orange"
                    fluid
                    style={{ height: '28px', lineHeight: '26px' }}
                    onClick={() => act('crank')}
                  />
                ) : (
                  // Если готов - показываем огонь
                  <Button
                    icon="bomb"
                    content="FIRE!"
                    color="red"
                    fluid
                    style={{ height: '28px', lineHeight: '26px' }}
                    disabled={!loaded}
                    onClick={() => act('fire')}
                  />
                )}
              </Box>

              <Box width="30%">
                <Button
                  icon="box"
                  content="Pack"
                  fluid
                  style={{ height: '28px', lineHeight: '26px' }}
                  onClick={() => act('pack')}
                />
              </Box>

            </Stack>
          </Section>

        </Stack>
      </Window.Content>
    </Window>
  );
};
