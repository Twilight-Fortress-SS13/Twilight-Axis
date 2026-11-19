import { useMemo, useState } from 'react';
import {
  Box,
  Button,
  Input,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Prayer = {
  id: number;
  ckey: string;
  name: string;
  patron: string;
  kind: string;
  message: string;
  time: string;
  processed: boolean;
  processed_by: string;
  processed_at: string;
  target_exists: boolean;
  target_located: boolean;
  online: boolean;
};

type Data = {
  prayers: Prayer[];
  pending: number;
};

type Filter = 'all' | 'pending' | 'processed';

const tableBorder = '1px solid rgba(214, 163, 163, 0.28)';
const rowBorder = '1px solid rgba(214, 163, 163, 0.18)';
const cellPadding = '5px 7px';
const compactButtonStyle = {
  minWidth: '34px',
  height: '24px',
  padding: '0 6px',
  lineHeight: 1,
};

export const PrayerJournal = () => {
  const { act, data } = useBackend<Data>();
  const { prayers = [], pending = 0 } = data;
  const [filter, setFilter] = useState<Filter>('pending');
  const [query, setQuery] = useState('');

  const visible = useMemo(() => {
    const search = query.toLowerCase().trim();
    return prayers
      .filter((prayer) => {
        if (filter === 'pending' && prayer.processed) return false;
        if (filter === 'processed' && !prayer.processed) return false;
        if (!search) return true;
        return [
          prayer.name,
          prayer.ckey,
          prayer.patron,
          prayer.kind,
          prayer.message,
        ]
          .join(' ')
          .toLowerCase()
          .includes(search);
      })
      .sort((a, b) => b.id - a.id);
  }, [prayers, filter, query]);

  const actionButton = (
    prayer: Prayer,
    action: string,
    label: string,
    disabled = false,
  ) => (
    <Button
      key={action}
      disabled={disabled}
      onClick={() => act(action, { id: prayer.id })}
      style={compactButtonStyle}
    >
      {label}
    </Button>
  );

  return (
    <Window width={620} height={420} title="Prayer Journal">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Stack align="center" wrap>
                <Stack.Item grow>
                  <Input
                    fluid
                    placeholder="Search prayer text, player, ckey or patron..."
                    value={query}
                    onChange={setQuery}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => setFilter('pending')} color={filter === 'pending' ? 'good' : undefined} style={{ height: '28px' }}>
                    Pending ({pending})
                  </Button>
                  <Button onClick={() => setFilter('processed')} color={filter === 'processed' ? 'good' : undefined} style={{ height: '28px' }}>
                    Processed ({prayers.length - pending})
                  </Button>
                  <Button onClick={() => setFilter('all')} color={filter === 'all' ? 'good' : undefined} style={{ height: '28px' }}>
                    All ({prayers.length})
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="sync" onClick={() => act('refresh')} style={{ height: '28px' }}>
                    Refresh
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable title={`Prayers (${visible.length})`}>
              {!visible.length ? (
                <Box textAlign="center" mt={4}>
                  No matching prayers in this round.
                </Box>
              ) : (
                <Table style={{ width: '100%', borderCollapse: 'collapse', border: tableBorder, fontSize: '13px' }}>
                  <Table.Row
                    header
                    style={{
                      backgroundColor: 'rgba(255, 255, 255, 0.04)',
                      borderBottom: tableBorder,
                    }}
                  >
                    <Table.Cell collapsing style={{ padding: cellPadding, borderRight: tableBorder, textAlign: 'center' }}>
                      Done
                    </Table.Cell>
                    <Table.Cell collapsing style={{ padding: cellPadding, borderRight: tableBorder }}>
                      Time / #
                    </Table.Cell>
                    <Table.Cell style={{ padding: cellPadding, borderRight: tableBorder }}>
                      Player / Patron
                    </Table.Cell>
                    <Table.Cell style={{ padding: cellPadding, borderRight: tableBorder }}>
                      Prayer
                    </Table.Cell>
                    <Table.Cell collapsing style={{ padding: cellPadding }}>
                      Admin actions
                    </Table.Cell>
                  </Table.Row>
                  {visible.map((prayer) => (
                    <Table.Row
                      key={prayer.id}
                      className="candystripe"
                      style={{ borderBottom: rowBorder, verticalAlign: 'top' }}
                    >
                      <Table.Cell
                        collapsing
                        style={{
                          padding: '4px 6px',
                          borderRight: rowBorder,
                          textAlign: 'center',
                          verticalAlign: 'middle',
                        }}
                      >
                        <Box
                          style={{
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            minHeight: '100%',
                          }}
                        >
                          <Button
                            icon={prayer.processed ? 'check-square' : 'square'}
                            color={prayer.processed ? 'good' : undefined}
                            onClick={() => act('toggle-processed', { id: prayer.id })}
                            tooltip={prayer.processed ? `Handled by ${prayer.processed_by} at ${prayer.processed_at}` : 'Mark as handled for all admins'}
                            style={compactButtonStyle}
                          />
                        </Box>
                      </Table.Cell>
                      <Table.Cell collapsing style={{ padding: cellPadding, borderRight: rowBorder, whiteSpace: 'nowrap' }}>
                        <Box>{prayer.time}</Box>
                        <Box color="label" style={{ fontSize: '11px' }}>#{prayer.id}</Box>
                      </Table.Cell>
                      <Table.Cell style={{ padding: cellPadding, borderRight: rowBorder, lineHeight: 1.2, minWidth: '220px' }}>
                        <Box bold>{prayer.name}</Box>
                        <Box color="label" style={{ fontSize: '11px' }}>{prayer.ckey || 'No ckey'}</Box>
                        <Box>{prayer.patron}</Box>
                        <Box color="label" style={{ fontSize: '11px' }}>{prayer.kind}</Box>
                        {!!prayer.processed && (
                          <Box color="good" style={{ fontSize: '11px', marginTop: '2px' }}>
                            Handled: {prayer.processed_by}
                            {!!prayer.processed_at && ` (${prayer.processed_at})`}
                          </Box>
                        )}
                      </Table.Cell>
                      <Table.Cell style={{ padding: cellPadding, borderRight: rowBorder, lineHeight: 1.25 }}>
                        <Box style={{ whiteSpace: 'pre-wrap', overflowWrap: 'anywhere' }}>
                          {prayer.message}
                        </Box>
                      </Table.Cell>
                      <Table.Cell collapsing style={{ padding: '4px 6px', minWidth: '92px' }}>
                        <Stack wrap g={0.35}>
                          <Stack.Item>{actionButton(prayer, 'view-variables', 'VV', !prayer.target_exists)}</Stack.Item>
                          <Stack.Item>{actionButton(prayer, 'player-panel', 'PP', !prayer.target_exists)}</Stack.Item>
                          <Stack.Item>{actionButton(prayer, 'private-message', 'PM', !prayer.online)}</Stack.Item>
                          <Stack.Item>{actionButton(prayer, 'jump', 'JMP', !prayer.target_located)}</Stack.Item>
                          <Stack.Item>{actionButton(prayer, 'follow', 'FLW', !prayer.target_exists)}</Stack.Item>
                        </Stack>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
