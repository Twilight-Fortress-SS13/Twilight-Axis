import { useState } from 'react';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Amulet = {
  ref: string;
  name: string;
  area: string;
  uses: number;
};

type Data = {
  zones: string[];
  vitaeCost: number;
  sightCost: number;
  riftDuration: number;
  amulets: Amulet[];
  hasVitae: BooleanLike;
  riftZone: string | null;
  riftSecondsLeft: number;
};

const amuletCardStyle = {
  border: '1px solid #55242a',
  borderRadius: '6px',
  background: 'rgba(30, 8, 12, 0.78)',
};

const emptyStateStyle = {
  border: '1px dashed #55242a',
  borderRadius: '6px',
  background: 'rgba(18, 8, 10, 0.55)',
};

const formatVitae = (value: number) =>
  Math.round(value || 0).toLocaleString('ru-RU');

const formatDuration = (seconds: number) => {
  const total = Math.max(Math.round(seconds || 0), 0);
  const rest = `${total % 60}`.padStart(2, '0');
  return `${Math.floor(total / 60)}:${rest}`;
};

const toTitle = (name: string) =>
  name ? name.charAt(0).toUpperCase() + name.slice(1) : '';

const EmptyState = (props: { text: string }) => (
  <Box italic textAlign="center" color="label" p={2} style={emptyStateStyle}>
    {props.text}
  </Box>
);

const AmuletList = (props: {
  amulets: Amulet[];
  canOpen: boolean;
  onOpen: (ref: string) => void;
}) => {
  const { amulets, canOpen, onOpen } = props;

  return (
    <Section title="Якоря" fill scrollable>
      {amulets.map((amulet) => (
        <Box key={amulet.ref} mb={1} p={1} style={amuletCardStyle}>
          <Stack align="center">
            <Stack.Item grow basis={0}>
              <Box bold>{toTitle(amulet.name)}</Box>
              <Box color="label">{amulet.area}</Box>
              <Box color="average">Возвращений: {amulet.uses}</Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="eye"
                disabled={!canOpen}
                tooltip="Открыть разлом рядом с этим амулетом"
                onClick={() => onOpen(amulet.ref)}
              >
                Открыть рядом
              </Button>
            </Stack.Item>
          </Stack>
        </Box>
      ))}
      {!amulets.length && (
        <EmptyState text="Ни один амулет врат не отзывается. Его куют в багровом тигле." />
      )}
    </Section>
  );
};

const ZoneList = (props: {
  zones: string[];
  canOpen: boolean;
  onOpen: (zone: string) => void;
}) => {
  const { zones, canOpen, onOpen } = props;
  const [search, setSearch] = useState('');
  const query = search.trim().toLowerCase();
  const shown = query
    ? zones.filter((zone) => zone.toLowerCase().includes(query))
    : zones;

  return (
    <Section
      title="Зоны"
      fill
      scrollable
      buttons={
        <Input
          placeholder="Найти зону..."
          value={search}
          onChange={setSearch}
        />
      }
    >
      {shown.map((zone) => (
        <Button
          key={zone}
          fluid
          icon="eye"
          disabled={!canOpen}
          onClick={() => onOpen(zone)}
        >
          {toTitle(zone)}
        </Button>
      ))}
      {!shown.length && <EmptyState text="Такой зоны нет." />}
    </Section>
  );
};

export const VampireRiftGate = () => {
  const { act, data } = useBackend<Data>();
  const {
    zones = [],
    vitaeCost = 0,
    sightCost = 0,
    riftDuration = 0,
    amulets = [],
    riftZone,
    riftSecondsLeft = 0,
  } = data;
  const hasVitae = !!data.hasVitae;
  const riftOpen = !!riftZone;
  const canOpen = hasVitae && !riftOpen;
  const priceText = `Цена: ${formatVitae(vitaeCost)} витэ${hasVitae ? `, из них ${formatVitae(sightCost)} за взор` : ', не хватает'}`;

  return (
    <Window width={520} height={720} theme="dark">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow basis={0} overflow="hidden">
                  <Box bold fontSize={1.2}>
                    ВРАТА РАЗЛОМА
                  </Box>
                  <Box nowrap color={hasVitae || riftOpen ? 'label' : 'bad'}>
                    {riftOpen ? `Выход: ${toTitle(riftZone || '')}` : priceText}
                  </Box>
                </Stack.Item>
                <Stack.Item width="160px" textAlign="right">
                  <Box nowrap color={riftOpen ? 'bad' : 'good'}>
                    {riftOpen ? 'РАЗЛОМ ОТКРЫТ' : 'СПИТ'}
                  </Box>
                  <Box nowrap color="label">
                    {riftOpen
                      ? `Закроется через ${formatDuration(riftSecondsLeft)}`
                      : `Держится ${formatDuration(riftDuration)}`}
                  </Box>
                </Stack.Item>
              </Stack>
              <Box mt={1} italic color="label">
                Сначала в выбранное место войдёт мой взор, и я укажу точку.
                Плата за взор не возвращается. Назад проходит лишь носитель
                амулета врат и тот, кого он несёт на плече: одно возвращение за
                проход.
              </Box>
              <Button
                fluid
                mt={1}
                icon="times"
                color="bad"
                textAlign="center"
                disabled={!riftOpen}
                onClick={() => act('close_rift')}
              >
                Закрыть разлом
              </Button>
            </Section>
          </Stack.Item>
          <Stack.Item basis="170px">
            <AmuletList
              amulets={amulets}
              canOpen={canOpen}
              onOpen={(amulet) => act('open_amulet', { amulet })}
            />
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <ZoneList
              zones={zones}
              canOpen={canOpen}
              onOpen={(zone) => act('open_zone', { zone })}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
