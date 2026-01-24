import { Box, Button, ProgressBar, Section, Slider, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
type ArtilleryData = {
  elevation: number;
  azimuth: number;
  elevation_min: number;
  elevation_max: number;
  area_name: string;
  charge_level: number;
  charge_max: number;
  velocity: number;
  range: number;
};

export const Artillery = () => {
  const { data, act } = useBackend<ArtilleryData>();

  const circleSize = 150;
  const arrowLength = 60;

  return (
    <Window title="Мортира" width={500} height={650}>
      <Window.Content>
        <Stack vertical fill>

          <Stack fill justify="space-around">

            <Box
              style={{
                width: `${circleSize}px`,
                height: `${circleSize}px`,
                border: '1px solid gray',
                borderRadius: '50%',
                position: 'relative',
              }}
            >

              <Box
                style={{
                  width: '4px',
                  height: `${arrowLength}px`,
                  background: 'red',
                  position: 'absolute',
                  left: '50%',
                  top: '50%',
                  transformOrigin: 'bottom center',
                  transform: `translateX(-50%) translateY(-100%) rotate(${-data.elevation + 90}deg)`,
                  transition: 'transform 0.2s',
                }}
              />
            </Box>


            <Box
              style={{
                width: `${circleSize}px`,
                height: `${circleSize}px`,
                border: '1px solid gray',
                borderRadius: '50%',
                position: 'relative',
              }}
            >

              <Box
                style={{
                  width: '4px',
                  height: `${arrowLength}px`,
                  background: 'red',
                  position: 'absolute',
                  left: '50%',
                  top: '50%',
                  transformOrigin: 'bottom center',
                  transform: `translateX(-50%) translateY(-100%) rotate(${data.azimuth}deg)`,
                  transition: 'transform 0.2s',
                }}
              />
            </Box>
          </Stack>


          <Stack justify="space-around" mt={2}>
              <Stack vertical width="45%">
                <Box textAlign="center">
                  Возвышение: {data.elevation}°
                </Box>
                <Slider
                  minValue={data.elevation_min}
                  maxValue={data.elevation_max}
                  step={0.25}
                  value={data.elevation}
                  format={(v) => `${v}°`}
                  onChange={(_, v) => {
                    act('set_elevation', { value: v });
                  }}
                />
              </Stack>

              <Stack vertical width="45%">
                <Box textAlign="center">
                  Азимут: {data.azimuth}°
                </Box>
                <Slider
                  minValue={0}
                  maxValue={360}
                  step={0.25}
                  value={data.azimuth}
                  format={(v) => `${v}°`}
                  onChange={(_, v) => {
                    act('set_azimuth', { value: v });
                  }}
                />
              </Stack>
          </Stack>

          <Stack vertical justify="space-around" mt={2}>
            <Box textAlign="center">
                Заряд: {data.charge_level}/{data.charge_max}
            </Box>
            
            <ProgressBar
              ranges={{
                good: [0.75, Infinity],
                average: [0.25, 0.75],
                bad: [-Infinity, 0.25],
              }}
              value={(data.charge_level / data.charge_max) || 0}
              />
          </Stack>

          <Stack justify="space-around" mt={2}>
            <Box textAlign="center">
              Я попаду примерно в: {data.area_name}
            </Box>
          </Stack>

          <Stack justify="space-around" mt={2}>
            <Box textAlign="center">
              Расстояние: {data.range}
            </Box>
          </Stack>


          <Button fluid style={{ marginTop: '10px' }} onClick={() => act('fire')}>
            Огонь!
          </Button>

          <Button fluid style={{ marginTop: '10px' }} onClick={() => act('disasseble')}>
            Разобрать пушку(ВНИМАНИЕ СТВОЛ БУДЕТ ИСПОРЧЕН)
          </Button>

          <Button fluid style={{ marginTop: '10px' }} onClick={() => act('decrease_charge')}>
            Убавить пороха
          </Button>

          <Button fluid style={{ marginTop: '10px' }} onClick={() => act('eject_ammo')}>
            Вытащить снаряд
          </Button>
        </Stack>
      </Window.Content>
    </Window>
  );
};
