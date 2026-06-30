import { Box, Button, ProgressBar, Stack, Slider, ByondUi, Icon } from 'tgui-core/components';
import { useBackend } from '../backend';
import { useEffect } from 'react';
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
  map_ref?: string;
  expert_mode?: boolean;
  can_expert_mode?: boolean;
};

export const Artillery = () => {
  const { data, act } = useBackend<ArtilleryData>();

  const circleSize = 150;
  const arrowLength = 60;

  useEffect(() => {
    let count = 0;
    const interval = setInterval(() => {
      window.dispatchEvent(new Event('resize'));
      count++;
      if (count > 20) clearInterval(interval);
    }, 100);
    return () => clearInterval(interval);
  }, [data.map_ref]);

  if (data.expert_mode) {
    return (
      <Window title="Мортира (Экспертный Режим)" width={745} height={810} theme="parchment-leatherbound">
        <Window.Content>
          <Stack vertical fill>
            <Stack fill>
              <Stack.Item style={{ border: '4px solid #3e2723', backgroundColor: '#d2b48c', padding: 0, backgroundImage: 'repeating-linear-gradient(0deg, transparent, transparent 15px, rgba(139,69,19,0.2) 16px), repeating-linear-gradient(90deg, transparent, transparent 15px, rgba(139,69,19,0.2) 16px)', boxShadow: 'inset 0 0 20px rgba(0,0,0,0.5)' }}>
                <Box style={{ width: '496px', height: '496px', position: 'relative' }}>
                  <ByondUi
                    params={{
                      id: data.map_ref,
                      type: 'map',
                      'icon-size': 16,
                      border: 'none',
                    }}
                    style={{
                      width: '100%',
                      height: '100%',
                    }}
                  />
                </Box>
              </Stack.Item>

              <Stack.Item grow>
                <Stack vertical justify="center" align="center" fill>
                  <Box mt={2} mb={1}>Навигация</Box>
                  <Button icon="arrow-up" onClick={() => act('pan_map', { dy: 5 })} />
                  <Stack>
                    <Button icon="arrow-left" onClick={() => act('pan_map', { dx: -5 })} />
                    <Button icon="arrow-right" onClick={() => act('pan_map', { dx: 5 })} />
                  </Stack>
                  <Button icon="arrow-down" onClick={() => act('pan_map', { dy: -5 })} />
                  <Box mt={2}>
                    <Button fluid textAlign="center" style={{ backgroundColor: '#800000', color: 'white', border: '1px solid #3e2723' }} onClick={() => act('target_center')}>
                      Навестись
                    </Button>
                  </Box>
                </Stack>
              </Stack.Item>
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
                Ожидаемая дистанция: {data.range} | Точка: {data.area_name}
              </Box>
            </Stack>

            <Stack vertical mt={2} mb={2}>
              <Button fluid textAlign="center" style={{ marginBottom: '10px', height: '40px', fontSize: '18px', backgroundColor: '#800000', color: 'white', border: '2px solid #3e2723' }} onClick={() => act('fire')}>
                ВЫСТРЕЛИТЬ
              </Button>
              <Stack>
                <Stack.Item grow={1} basis={0}>
                  <Button fluid style={{ marginBottom: '10px', height: '30px' }} onClick={() => act('eject_ammo')}>
                    Вытащить снаряд
                  </Button>
                  <Button fluid style={{ height: '30px' }} onClick={() => act('decrease_charge')}>
                    Убавить пороха
                  </Button>
                </Stack.Item>
                <Stack.Item grow={1} basis={0}>
                  <Button fluid style={{ marginBottom: '10px', height: '30px' }} onClick={() => act('disasseble')}>
                    Разобрать пушку(ВНИМАНИЕ СТВОЛ БУДЕТ ИСПОРЧЕН)
                  </Button>
                  <Button fluid style={{ height: '30px' }} onClick={() => act('toggle_expert_mode')}>
                    Выйти из экспертного режима
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack>
          </Stack>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window title="Мортира" width={725} height={860} theme="parchment-leatherbound">
      <Window.Content>
        <Stack vertical fill>
          <Stack fill justify="space-around" align="center">
            <Box
              style={{
                width: `${circleSize}px`,
                height: `${circleSize}px`,
                border: '6px solid #b5a642', // Brass border
                borderRadius: '50%',
                position: 'relative',
                backgroundColor: '#2a211c', // Parchment color inside
                boxShadow: 'inset 0 0 10px rgba(0,0,0,0.8), 0 0 5px rgba(0,0,0,0.5)',
              }}
            >
              <Box
                style={{
                  width: '4px',
                  height: `${arrowLength}px`,
                  background: '#8b7355',
                  position: 'absolute',
                  left: '50%',
                  top: '50%',
                  transformOrigin: 'bottom center',
                  transform: `translateX(-50%) translateY(-100%) rotate(${-data.elevation + 90}deg)`,
                  transition: 'transform 0.2s',
                  boxShadow: '1px 1px 2px rgba(0,0,0,0.5)',
                }}
              />
            </Box>

            <Box
              style={{
                width: `${circleSize}px`,
                height: `${circleSize}px`,
                border: '6px solid #b5a642', // Brass border
                borderRadius: '50%',
                position: 'relative',
                backgroundColor: '#2a211c', // Parchment color inside
                boxShadow: 'inset 0 0 10px rgba(0,0,0,0.8), 0 0 5px rgba(0,0,0,0.5)',
              }}
            >
              <Box
                style={{
                  width: '4px',
                  height: `${arrowLength}px`,
                  background: '#8b7355',
                  position: 'absolute',
                  left: '50%',
                  top: '50%',
                  transformOrigin: 'bottom center',
                  transform: `translateX(-50%) translateY(-100%) rotate(${data.azimuth}deg)`,
                  transition: 'transform 0.2s',
                  boxShadow: '1px 1px 2px rgba(0,0,0,0.5)',
                }}
              />
            </Box>

            <Box
              style={{
                position: 'relative',
                width: '416px',
                height: '416px',
                boxSizing: 'content-box',
                border: '8px solid #3e2723',
                borderRadius: '2px',
                boxShadow: '0 0 10px rgba(0,0,0,0.5)',
                overflow: 'hidden',
              }}>
              <ByondUi
                params={{
                  id: data.map_ref,
                  type: 'map',
                  'icon-size': 32,
                  border: 'none',
                }}
                style={{
                  width: '100%',
                  height: '100%',
                  filter: 'sepia(0.6) contrast(1.1) brightness(0.9)',
                }}
              />
              <Box
                style={{
                  position: 'absolute',
                  top: 0,
                  left: 0,
                  width: '100%',
                  height: '100%',
                  backgroundColor: '#704214',
                  opacity: 0.25,
                  pointerEvents: 'none',
                  mixBlendMode: 'color',
                }}
              />
              <Icon
                name="crosshairs"
                style={{
                  position: 'absolute',
                  top: '50%',
                  left: '50%',
                  transform: 'translate(-50%, -50%)',
                  fontSize: '32px',
                  color: 'rgba(255, 0, 0, 0.6)',
                  pointerEvents: 'none',
                  textShadow: '0 0 2px black',
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

          <Stack vertical mt={2} mb={2}>
            <Button fluid textAlign="center" style={{ marginBottom: '10px', height: '40px', fontSize: '18px', backgroundColor: '#800000', color: 'white', border: '2px solid #3e2723' }} onClick={() => act('fire')}>
              ВЫСТРЕЛИТЬ
            </Button>
            <Stack>
              <Stack.Item grow={1} basis={0}>
                <Button fluid style={{ marginBottom: '10px', height: '30px' }} onClick={() => act('eject_ammo')}>
                  Вытащить снаряд
                </Button>
                <Button fluid style={{ height: '30px' }} onClick={() => act('decrease_charge')}>
                  Убавить пороха
                </Button>
              </Stack.Item>
              <Stack.Item grow={1} basis={0}>
                <Button fluid style={{ marginBottom: '10px', height: '30px' }} onClick={() => act('disasseble')}>
                  Разобрать пушку(ВНИМАНИЕ СТВОЛ БУДЕТ ИСПОРЧЕН)
                </Button>
                {!!data.can_expert_mode && (
                  <Button fluid style={{ height: '30px' }} onClick={() => act('toggle_expert_mode')}>
                    Включить экспертный режим
                  </Button>
                )}
              </Stack.Item>
            </Stack>
          </Stack>
        </Stack>
      </Window.Content>
    </Window>
  );
};
