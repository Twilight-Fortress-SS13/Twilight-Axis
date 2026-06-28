import { Box, Button, ProgressBar, Stack, Slider } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { NanoMap } from '../components/NanoMap';

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
  map_data?: string[][][];
  expert_map_data?: string[][][];
  expert_mode?: boolean;
  map_levels?: number[];
  mapZLevel?: number;
};

export const Artillery = () => {
  const { data, act } = useBackend<ArtilleryData>();

  const circleSize = 150;
  const arrowLength = 60;

  if (data.expert_mode) {
    return (
      <Window title="Мортира (Экспертный Режим)" width={800} height={700}>
        <Window.Content>
          <Stack vertical fill>
            <Stack fill>
              <Stack.Item style={{ border: '2px solid gray', backgroundColor: 'black', padding: 0 }}>
                <Box
                  style={{
                    display: 'grid',
                    gridTemplateColumns: 'repeat(31, 16px)',
                    gridTemplateRows: 'repeat(31, 16px)',
                    gap: '0px',
                  }}
                >
                  {data.expert_map_data?.map((row, y) =>
                    row.map((tile_icons, x) => (
                      <Box
                        key={`${x}-${y}`}
                        style={{
                          width: '16px',
                          height: '16px',
                          position: 'relative',
                          cursor: 'pointer',
                        }}
                        onClick={() => act('set_expert_target_tile', { dx: x - 15, dy: 15 - y })}
                      >
                        {tile_icons.map((b64, idx) => {
                          if (!b64) return null;
                          return (
                            <img
                              key={idx}
                              src={`data:image/png;base64,${b64}`}
                              style={{
                                position: 'absolute',
                                width: '16px',
                                height: '16px',
                                imageRendering: 'pixelated',
                              }}
                            />
                          );
                        })}
                        {x === 15 && y === 15 ? (
                          <Box
                            style={{
                              position: 'absolute',
                              width: '16px',
                              height: '16px',
                              border: '1px solid red',
                              boxSizing: 'border-box'
                            }}
                          />
                        ) : null}
                      </Box>
                    ))
                  )}
                </Box>
              </Stack.Item>

              <Stack.Item grow>
                <Stack vertical justify="center" align="center" fill>
                  <Box mb={2}>Z-Level:</Box>
                  <Stack mb={2} wrap>
                    {data.map_levels?.map((lvl) => (
                      <Button
                        key={lvl}
                        selected={data.mapZLevel === lvl}
                        onClick={() => act('setZLevel', { mapZLevel: lvl })}
                      >
                        {lvl}
                      </Button>
                    ))}
                  </Stack>
                  <Box mt={2} mb={1}>Навигация</Box>
                  <Button icon="arrow-up" onClick={() => act('pan_map', { dy: 5 })} />
                  <Stack>
                    <Button icon="arrow-left" onClick={() => act('pan_map', { dx: -5 })} />
                    <Button icon="circle" onClick={() => act('pan_map', { dx: 0, dy: 0 })} tooltip="Центр" />
                    <Button icon="arrow-right" onClick={() => act('pan_map', { dx: 5 })} />
                  </Stack>
                  <Button icon="arrow-down" onClick={() => act('pan_map', { dy: -5 })} />
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
  }

  return (
    <Window title="Мортира" width={720} height={650}>
      <Window.Content>
        <Stack vertical fill>
          <Stack fill justify="space-around" align="center">
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

            <Box
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(13, 16px)',
                gridTemplateRows: 'repeat(13, 16px)',
                gap: '0px',
                border: '2px solid gray',
                backgroundColor: 'black'
              }}
            >
              {data.map_data?.map((row, y) =>
                row.map((tile_icons, x) => (
                  <Box
                    key={`${x}-${y}`}
                    style={{
                      width: '16px',
                      height: '16px',
                      position: 'relative',
                      cursor: 'pointer',
                    }}
                    onClick={() => act('set_target_tile', { dx: x - 6, dy: 6 - y })}
                  >
                    {tile_icons.map((b64, idx) => {
                      if (!b64) return null;
                      return (
                        <img
                          key={idx}
                          src={`data:image/png;base64,${b64}`}
                          style={{
                            position: 'absolute',
                            width: '16px',
                            height: '16px',
                            imageRendering: 'pixelated',
                          }}
                        />
                      );
                    })}
                    {x === 6 && y === 6 ? (
                      <Box
                        style={{
                          position: 'absolute',
                          width: '16px',
                          height: '16px',
                          border: '1px solid red',
                          boxSizing: 'border-box'
                        }}
                      />
                    ) : null}
                  </Box>
                ))
              )}
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
