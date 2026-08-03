import { useEffect, useMemo, useState } from 'react';
import { Box, Button, DmIcon, Section, Stack } from 'tgui-core/components';

import type { Data } from '../types';
import { cardStyle } from '../components/shared';

export const MarkingsTab = (props: {
  data: Data;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
    const [activeZone, setActiveZone] = useState<string>('');

  const zones = useMemo(
    () => props.data.body_markings || [],
    [props.data.body_markings],
  );

  const activeCatalog = useMemo(
    () => (props.data.body_marking_catalog || []).find((entry) => entry.zone === activeZone),
    [props.data.body_marking_catalog, activeZone],
  );

  useEffect(() => {
    if (!activeZone && zones.length) {
      setActiveZone(zones[0].zone);
    }
    if (activeZone && !zones.find((zone) => zone.zone === activeZone) && zones.length) {
      setActiveZone(zones[0].zone);
    }
  }, [activeZone, zones]);

  return (
    <Stack fill>
      <Stack.Item basis="48%">
        <Section title="Зоны" fill scrollable>
          {zones.length ? zones.map((zone) => (
            <Box key={zone.zone} mb={0.5} p={0.6} style={cardStyle}>
              <Stack align="center" mb={0.4}>
                <Stack.Item grow>
                  <Box bold>{zone.label}</Box>
                  <Box color="label">{zone.count ? `${zone.count} выбрано` : 'Пусто'}</Box>
                </Stack.Item>
                <Stack.Item>
                  <Button compact onClick={() => setActiveZone(zone.zone)}>Добавить</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button compact disabled={!zone.count} onClick={() => props.act('clear_body_marking_zone', { zone: zone.zone })}>Очистить</Button>
                </Stack.Item>
              </Stack>
              {zone.names.length ? zone.names.map((name) => (
                <Box key={`${zone.zone}-${name}`} mb={0.3} p={0.35} style={cardStyle}>
                  <Stack align="center">
                    <Stack.Item grow>{name}</Stack.Item>
                    <Stack.Item>
                      <Button compact onClick={() => props.act('remove_body_marking', { zone: zone.zone, name })}>Убрать</Button>
                    </Stack.Item>
                  </Stack>
                </Box>
              )) : (
                <Box color="label">На этой зоне ничего нет.</Box>
              )}
            </Box>
          )) : (
            <Box color="label">Маркинги не найдены.</Box>
          )}
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title={activeCatalog ? `Добавить: ${activeCatalog.label}` : 'Добавление'} fill scrollable>
          {!activeCatalog ? (
            <Box color="label">Выбери зону слева, чтобы добавить маркинг.</Box>
          ) : activeCatalog.options?.length ? (
            <Box style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: '8px' }}>
              {activeCatalog.options.map((option) => (
                <Button
                  key={`${activeCatalog.zone}-${option.name}`}
                  textAlign="left"
                  style={{ minHeight: '54px' }}
                  onClick={() => props.act('add_body_marking', { zone: activeCatalog.zone, name: option.name })}
                >
                  <Stack align="center">
                    {option.icon_class_name ? (
                      <Stack.Item basis="42px" shrink={0}>
                        <Box className={option.icon_class_name} />
                      </Stack.Item>
                    ) : option.icon ? (
                      <Stack.Item basis="42px" shrink={0}>
                        <DmIcon icon={option.icon} icon_state={option.icon_state || ''} width="40px" height="40px" />
                      </Stack.Item>
                    ) : null}
                    <Stack.Item grow>{option.name}</Stack.Item>
                  </Stack>
                </Button>
              ))}
            </Box>
          ) : (
            <Box color="label">Для этой зоны список маркингов не найден.</Box>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
