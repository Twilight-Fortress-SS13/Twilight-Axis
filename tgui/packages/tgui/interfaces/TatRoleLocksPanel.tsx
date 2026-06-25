import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

const ROLE_HINTS: Record<string, string> = {
  towner: 'Local / Resident / Towner Pliant bucket',
  trader: 'Default trader-ish TAT bucket',
  adventurer: 'Outlander / Wanted / Adventurer bucket',
};

const INTERVAL_OPTIONS = [
  'MINUTE',
  'HOUR',
  'DAY',
  'WEEK',
  'MONTH',
  'YEAR',
];

const SEVERITY_OPTIONS = [
  'None',
  'Minor',
  'Medium',
  'High',
];

type PlayerRow = {
  key: string;
  ckey: string;
  mob_name: string;
  selected: boolean;
};

type RoleRow = {
  id: string;
  name: string;
  locked: boolean;
  state: string;
  reason: string;
  locked_by: string;
  locked_at: string;
  expires: string;
  ban_id: string;
};

type Data = {
  players: PlayerRow[];
  selected_ckey: string;
  filter: string;
  default_reason: string;
  duration: number;
  interval: string;
  permanent: boolean;
  severity: string;
  applies_to_admins: boolean;
  roles: RoleRow[];
};

export const TatRoleLocksPanel = () => {
  const { act, data } = useBackend<Data>();
  const {
    players = [],
    selected_ckey,
    filter = '',
    default_reason = '',
    duration = 10080,
    interval = 'MINUTE',
    permanent = false,
    severity = 'Medium',
    applies_to_admins = false,
    roles = [],
  } = data;

  return (
    <Window width={820} height={580} title="TAT Role Locks">
      <Window.Content scrollable>
        <Stack fill>
          <Stack.Item width="32%">
            <Section title="Players">
              <Input
                fluid
                placeholder="Filter online players"
                value={filter}
                onChange={(value) => act('set_filter', { filter: value })}
              />
              <Table mt={1}>
                {players.map((player) => (
                  <Table.Row key={player.ckey}>
                    <Table.Cell>
                      <Button
                        fluid
                        selected={player.selected}
                        onClick={() =>
                          act('select_player', { ckey: player.ckey })
                        }>
                        {player.key || player.ckey}
                      </Button>
                      <Box color="label" fontSize="11px">
                        {player.mob_name}
                      </Box>
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section title="Target">
              <LabeledList>
                <LabeledList.Item label="Manual ckey">
                  <Input
                    fluid
                    placeholder="ckey"
                    value={selected_ckey || ''}
                    onChange={(value) =>
                      act('set_manual_ckey', { ckey: value })
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>

            <Section title="New lock settings">
              <LabeledList>
                <LabeledList.Item label="Reason">
                  <Input
                    fluid
                    value={default_reason}
                    onChange={(value) =>
                      act('set_default_reason', { reason: value })
                    }
                  />
                </LabeledList.Item>

                <LabeledList.Item label="Duration">
                  <Stack align="center">
                    <Stack.Item>
                      <Button.Checkbox
                        checked={permanent}
                        onClick={() =>
                          act('set_permanent', { permanent: !permanent })
                        }>
                        Permanent
                      </Button.Checkbox>
                    </Stack.Item>

                    <Stack.Item>
                      <NumberInput
                        width="80px"
                        minValue={1}
                        maxValue={999999}
                        step={1}
                        value={duration}
                        disabled={permanent}
                        onChange={(value) =>
                          act('set_duration', { duration: value })
                        }
                      />
                    </Stack.Item>

                    <Stack.Item>
                      <Dropdown
                        width="110px"
                        options={INTERVAL_OPTIONS}
                        selected={interval}
                        disabled={permanent}
                        onSelected={(value) =>
                          act('set_interval', { interval: value })
                        }
                      />
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>

                <LabeledList.Item label="Severity">
                  <Dropdown
                    width="120px"
                    options={SEVERITY_OPTIONS}
                    selected={severity}
                    onSelected={(value) =>
                      act('set_severity', { severity: value })
                    }
                  />
                </LabeledList.Item>

                <LabeledList.Item label="Admins">
                  <Button.Checkbox
                    checked={applies_to_admins}
                    onClick={() =>
                      act('set_applies_to_admins', {
                        applies_to_admins: !applies_to_admins,
                      })
                    }>
                    Applies to admins
                  </Button.Checkbox>
                </LabeledList.Item>
              </LabeledList>
            </Section>

            <Section
              title={`Role locks${selected_ckey ? ` for ${selected_ckey}` : ''}`}>
              <Table mt={1}>
                <Table.Row header>
                  <Table.Cell>Role</Table.Cell>
                  <Table.Cell>Status</Table.Cell>
                  <Table.Cell>Reason / metadata</Table.Cell>
                  <Table.Cell collapsing>Action</Table.Cell>
                </Table.Row>

                {roles.map((role) => (
                  <Table.Row key={role.id}>
                    <Table.Cell>
                      <b>{role.name}</b>
                      <Box color="label" fontSize="11px">
                        {ROLE_HINTS[role.id] || ''}
                      </Box>
                    </Table.Cell>

                    <Table.Cell color={role.locked ? 'bad' : 'good'}>
                      {role.state}
                    </Table.Cell>

                    <Table.Cell>
                      {role.locked ? (
                        <>
                          <Box>{role.reason || 'No reason'}</Box>
                          <Box color="label" fontSize="11px">
                            {role.locked_by ? `by ${role.locked_by}` : ''}{' '}
                            {role.locked_at || ''}
                          </Box>
                          <Box color="label" fontSize="11px">
                            {role.expires || 'Permanent'}
                          </Box>
                        </>
                      ) : (
                        <Box color="label">Open</Box>
                      )}
                    </Table.Cell>

                    <Table.Cell collapsing>
                      <Button
                        color={role.locked ? 'good' : 'bad'}
                        disabled={!selected_ckey}
                        onClick={() =>
                          act('toggle_role', {
                            ckey: selected_ckey,
                            bucket: role.id,
                            reason: default_reason,
                          })
                        }>
                        {role.locked ? 'Unlock' : 'Lock'}
                      </Button>
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
