import { useEffect, useMemo, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type BooleanLike = boolean | number;

type RoleEntry = {
  name: string;
  display_name: string;
};

type RoleGroup = {
  name: string;
  roles: RoleEntry[];
};

type BanForm = {
  player_key?: string;
  player_ip?: string;
  player_cid?: string;
  key_enabled: BooleanLike;
  ip_enabled: BooleanLike;
  cid_enabled: BooleanLike;
  use_last_connection: BooleanLike;
  applies_to_admins: BooleanLike;
  permanent: BooleanLike;
  duration: string | number;
  interval: string;
  reason?: string;
  role?: string;
};

type SearchForm = {
  player_key?: string;
  admin_key?: string;
  player_ip?: string;
  player_cid?: string;
  active_only: BooleanLike;
};

type BanResult = {
  id: number;
  ban_datetime: string;
  ban_round_id: string | number;
  role: string;
  expiration_time?: string;
  duration: string;
  expired: BooleanLike;
  applies_to_admins: BooleanLike;
  reason: string;
  player_key?: string;
  player_ip?: string;
  player_cid?: string;
  target: string;
  admin_key: string;
  has_edits: BooleanLike;
  unban_datetime?: string;
  unban_key?: string;
  unban_round_id?: string | number;
  active: BooleanLike;
};

type Data = {
  mode: 'ban' | 'unban';
  form_revision: number;
  is_editing: BooleanLike;
  ban_form: BanForm;
  role_groups: RoleGroup[];
  banned_roles: string[];
  search: SearchForm;
  has_search: BooleanLike;
  total_bans: number;
  results: BanResult[];
};

const intervals = [
  ['SECOND', 'seconds'],
  ['MINUTE', 'minutes'],
  ['HOUR', 'hours'],
  ['DAY', 'days'],
  ['WEEK', 'weeks'],
  ['MONTH', 'months'],
  ['YEAR', 'years'],
];

const roleGroupColors: Record<
  string,
  { backgroundColor: string; color: string }
> = {
  'Ducal Family': {
    backgroundColor: '#aa83b9',
    color: '#443a39',
  },
  Courtiers: {
    backgroundColor: '#81adc8',
    color: '#443a39',
  },
  Retinue: {
    backgroundColor: '#223273',
    color: '#443a39',
  },
  Garrison: {
    backgroundColor: '#b18484',
    color: '#443a39',
  },
  Church: {
    backgroundColor: '#c0ba8d',
    color: '#443a39',
  },
  Inquisition: {
    backgroundColor: '#cc4242',
    color: '#443a39',
  },
  Wanderers: {
    backgroundColor: '#819e82',
    color: '#443a39',
  },
  Abstract: {
    backgroundColor: '#374048',
    color: '#ffffff',
  },
  Peasants: {
    backgroundColor: '#b09262',
    color: '#443a39',
  },
  Sidefolk: {
    backgroundColor: '#65b2b5',
    color: '#443a39',
  },
  Burghers: {
    backgroundColor: '#c86e3a',
    color: '#443a39',
  },
  ATC: {
    backgroundColor: '#c86e3a',
    color: '#443a39',
  },
  'Ghost and Other Roles': {
    backgroundColor: '#2e0073',
    color: '#ffffff',
  },
  'Antagonist Positions': {
    backgroundColor: '#361f1f',
    color: '#ffffff',
  },
};

const selectStyle = {
  width: '100%',
  minHeight: '24px',
  color: 'inherit',
  background: 'rgba(0, 0, 0, 0.35)',
  border: '1px solid rgba(255, 255, 255, 0.18)',
  borderRadius: '2px',
};

const centeredButtonStyle = {
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  textAlign: 'center',
} as const;

const compactToggleButtonStyle = {
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  width: 'auto',
  minWidth: 0,
  textAlign: 'center',
} as const;

export const AdminBanPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    mode,
    form_revision,
    is_editing,
    ban_form,
    role_groups = [],
    banned_roles = [],
    search,
    has_search,
    total_bans,
    results = [],
  } = data;

  const [playerKey, setPlayerKey] = useState('');
  const [playerIp, setPlayerIp] = useState('');
  const [playerCid, setPlayerCid] = useState('');
  const [keyEnabled, setKeyEnabled] = useState(true);
  const [ipEnabled, setIpEnabled] = useState(false);
  const [cidEnabled, setCidEnabled] = useState(true);
  const [useLastConnection, setUseLastConnection] = useState(true);
  const [appliesToAdmins, setAppliesToAdmins] = useState(false);
  const [permanent, setPermanent] = useState(false);
  const [duration, setDuration] = useState('1440');
  const [interval, setInterval] = useState('MINUTE');
  const [reason, setReason] = useState('');
  const [severity, setSeverity] = useState('none');
  const [banType, setBanType] = useState<'server' | 'role'>('role');
  const [selectedRoles, setSelectedRoles] = useState<string[]>([]);
  const [mirrorEdit, setMirrorEdit] = useState(false);

  const [searchPlayerKey, setSearchPlayerKey] = useState(
    search?.player_key || '',
  );
  const [searchAdminKey, setSearchAdminKey] = useState(
    search?.admin_key || '',
  );
  const [searchPlayerIp, setSearchPlayerIp] = useState(
    search?.player_ip || '',
  );
  const [searchPlayerCid, setSearchPlayerCid] = useState(
    search?.player_cid || '',
  );
  const [activeOnly, setActiveOnly] = useState(!!search?.active_only);
  const [selectedBanIds, setSelectedBanIds] = useState<number[]>([]);

  useEffect(() => {
    setPlayerKey(ban_form?.player_key || '');
    setPlayerIp(ban_form?.player_ip || '');
    setPlayerCid(ban_form?.player_cid || '');
    setKeyEnabled(is_editing ? !!ban_form?.key_enabled : true);
    setIpEnabled(is_editing ? !!ban_form?.ip_enabled : false);
    setCidEnabled(is_editing ? !!ban_form?.cid_enabled : true);
    setUseLastConnection(
      is_editing ? !!ban_form?.use_last_connection : true,
    );
    setAppliesToAdmins(!!ban_form?.applies_to_admins);
    setPermanent(!!ban_form?.permanent);
    setDuration(String(ban_form?.duration ?? 1440));
    setInterval(ban_form?.interval || 'MINUTE');
    setReason(ban_form?.reason || '');
    setBanType(ban_form?.role === 'Server' ? 'server' : 'role');
    setSelectedRoles(
      ban_form?.role && ban_form.role !== 'Server' ? [ban_form.role] : [],
    );
    setMirrorEdit(false);
  }, [form_revision, is_editing]);

  useEffect(() => {
    setSelectedBanIds([]);
  }, [results.map((result) => result.id).join(',')]);

  const activeResultIds = useMemo(
    () => results.filter((result) => !!result.active).map((result) => result.id),
    [results],
  );

  const toggleRole = (role: string) => {
    setSelectedRoles((current) =>
      current.includes(role)
        ? current.filter((entry) => entry !== role)
        : [...current, role],
    );
  };

  const toggleResult = (banId: number) => {
    setSelectedBanIds((current) =>
      current.includes(banId)
        ? current.filter((entry) => entry !== banId)
        : [...current, banId],
    );
  };

  const submitBan = () => {
    act('submit_ban', {
      player_key: playerKey,
      player_ip: playerIp,
      player_cid: playerCid,
      key_enabled: keyEnabled,
      ip_enabled: ipEnabled,
      cid_enabled: cidEnabled,
      use_last_connection: useLastConnection,
      applies_to_admins: appliesToAdmins,
      permanent,
      duration,
      interval,
      reason,
      severity,
      ban_type: banType,
      roles: selectedRoles,
      mirror_edit: mirrorEdit,
    });
  };

  const searchUnbans = () => {
    act('search_unbans', {
      player_key: searchPlayerKey,
      admin_key: searchAdminKey,
      player_ip: searchPlayerIp,
      player_cid: searchPlayerCid,
      active_only: activeOnly,
    });
  };

  return (
    <Window title="Admin Ban Panel" width={1050} height={760}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            icon="gavel"
            selected={mode === 'ban'}
            onClick={() => act('set_mode', { mode: 'ban' })}
          >
            Ban
          </Tabs.Tab>
          <Tabs.Tab
            icon="unlock"
            selected={mode === 'unban'}
            onClick={() => act('set_mode', { mode: 'unban' })}
          >
            Unban
          </Tabs.Tab>
        </Tabs>

        {mode === 'ban' && (
          <Stack vertical>
            {!!is_editing && (
              <Stack.Item>
                <NoticeBox info>
                  Editing role ban: {ban_form.role || 'Unknown'}
                  <Button
                    ml={1}
                    icon="times"
                    onClick={() => act('cancel_edit')}
                  >
                    Cancel
                  </Button>
                </NoticeBox>
              </Stack.Item>
            )}

            <Stack.Item>
              <Section title="Player">
                <Stack vertical>
                  <Stack.Item>
                    <Stack align="center">
                      <Stack.Item>
                        <Button
                          icon={keyEnabled ? 'check-square' : 'square'}
                          selected={keyEnabled}
                          color={keyEnabled ? 'good' : undefined}
                          style={compactToggleButtonStyle}
                          onClick={() => setKeyEnabled(!keyEnabled)}
                        >
                          Ckey
                        </Button>
                      </Stack.Item>
                      <Stack.Item basis="360px">
                        <Input
                          fluid
                          disabled={!keyEnabled}
                          value={playerKey}
                          onChange={setPlayerKey}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon={cidEnabled ? 'check-square' : 'square'}
                          selected={cidEnabled}
                          color={cidEnabled ? 'good' : undefined}
                          style={compactToggleButtonStyle}
                          onClick={() => setCidEnabled(!cidEnabled)}
                        >
                          CID
                        </Button>
                      </Stack.Item>
                      <Stack.Item basis="260px">
                        <Input
                          fluid
                          disabled={!cidEnabled || useLastConnection}
                          value={playerCid}
                          onChange={setPlayerCid}
                        />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  <Stack.Item>
                    <Stack align="center">
                      <Stack.Item>
                        <Button
                          icon={ipEnabled ? 'check-square' : 'square'}
                          selected={ipEnabled}
                          color={ipEnabled ? 'good' : undefined}
                          style={compactToggleButtonStyle}
                          onClick={() => setIpEnabled(!ipEnabled)}
                        >
                          IP
                        </Button>
                      </Stack.Item>
                      <Stack.Item basis="260px">
                        <Input
                          fluid
                          disabled={!ipEnabled || useLastConnection}
                          value={playerIp}
                          onChange={setPlayerIp}
                        />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  <Stack.Item>
                    <Stack align="center">
                      <Stack.Item grow>
                        <Stack align="center">
                          <Stack.Item>
                            <Button
                              icon={
                                useLastConnection ? 'check-square' : 'square'
                              }
                              selected={useLastConnection}
                              color={useLastConnection ? 'good' : undefined}
                              style={compactToggleButtonStyle}
                              onClick={() =>
                                setUseLastConnection(!useLastConnection)
                              }
                            >
                              Use IP and CID from the last connection
                            </Button>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              icon={
                                appliesToAdmins ? 'check-square' : 'square'
                              }
                              selected={appliesToAdmins}
                              color={appliesToAdmins ? 'good' : undefined}
                              style={compactToggleButtonStyle}
                              onClick={() =>
                                setAppliesToAdmins(!appliesToAdmins)
                              }
                            >
                              Applies to administrators
                            </Button>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          color="good"
                          style={{
                            minWidth: '150px',
                            minHeight: '36px',
                            padding: 0,
                            position: 'relative',
                            fontSize: '16px',
                            fontWeight: 700,
                          }}
                          onClick={submitBan}
                        >
                          <Box
                            style={{
                              position: 'absolute',
                              top: 0,
                              right: 0,
                              bottom: 0,
                              left: 0,
                              display: 'flex',
                              alignItems: 'center',
                              justifyContent: 'center',
                              gap: '6px',
                              textAlign: 'center',
                            }}
                          >
                            <Icon name={is_editing ? 'save' : 'gavel'} />
                            <span>
                              {is_editing ? 'Save changes' : 'Submit'}
                            </span>
                          </Box>
                        </Button>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>

            <Stack.Item>
              <Stack>
                <Stack.Item grow>
                  <Section title="Duration type">
                    <Button
                      selected={permanent}
                      onClick={() => setPermanent(true)}
                    >
                      Permanent
                    </Button>
                    <Button
                      selected={!permanent}
                      onClick={() => setPermanent(false)}
                    >
                      Temporary
                    </Button>
                    {!permanent && (
                      <Stack mt={1}>
                        <Stack.Item grow>
                          <Input
                            fluid
                            value={duration}
                            onChange={setDuration}
                          />
                        </Stack.Item>
                        <Stack.Item basis="130px">
                          <select
                            value={interval}
                            style={selectStyle}
                            onChange={(event) => setInterval(event.target.value)}
                          >
                            {intervals.map(([value, label]) => (
                              <option key={value} value={value}>
                                {label}
                              </option>
                            ))}
                          </select>
                        </Stack.Item>
                      </Stack>
                    )}
                  </Section>
                </Stack.Item>

                {!is_editing && (
                  <Stack.Item grow>
                    <Section title="Ban type">
                      <Button
                        selected={banType === 'server'}
                        onClick={() => setBanType('server')}
                      >
                        Server
                      </Button>
                      <Button
                        selected={banType === 'role'}
                        onClick={() => setBanType('role')}
                      >
                        Roles
                      </Button>
                    </Section>
                  </Stack.Item>
                )}

                {!is_editing && (
                  <Stack.Item grow>
                    <Section title="Severity">
                      {[
                        ['none', 'None'],
                        ['minor', 'Minor'],
                        ['medium', 'Medium'],
                        ['high', 'High'],
                      ].map(([value, label]) => (
                        <Button
                          key={value}
                          selected={severity === value}
                          onClick={() => setSeverity(value)}
                        >
                          {label}
                        </Button>
                      ))}
                    </Section>
                  </Stack.Item>
                )}
              </Stack>
            </Stack.Item>

            <Stack.Item>
              <Section title="Reason">
                <textarea
                  value={reason}
                  onChange={(event) => setReason(event.target.value)}
                  style={{
                    width: '100%',
                    minHeight: '90px',
                    resize: 'vertical',
                    color: 'inherit',
                    background: 'rgba(0, 0, 0, 0.35)',
                    border: '1px solid rgba(255, 255, 255, 0.18)',
                  }}
                />
                {!!is_editing && (
                  <Box mt={1}>
                    <Button
                      icon={mirrorEdit ? 'check-square' : 'square'}
                      selected={mirrorEdit}
                      color={mirrorEdit ? 'good' : undefined}
                      style={centeredButtonStyle}
                      onClick={() => setMirrorEdit(!mirrorEdit)}
                    >
                      Apply changes to all matching bans
                    </Button>
                  </Box>
                )}
              </Section>
            </Stack.Item>

            {!is_editing && banType === 'role' && (
              <Stack.Item>
                <Section
                  title={`Roles (${selectedRoles.length} selected)`}
                  buttons={
                    <Button
                      icon="times"
                      disabled={!selectedRoles.length}
                      onClick={() => setSelectedRoles([])}
                    >
                      Clear
                    </Button>
                  }
                >
                  <Box
                    style={{
                      display: 'grid',
                      gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
                      gap: '8px',
                      alignItems: 'start',
                    }}
                  >
                    {role_groups.map((group) => {
                      const groupRoles = group.roles.map((role) => role.name);
                      const allSelected = groupRoles.every((role) =>
                        selectedRoles.includes(role),
                      );
                      const groupColor = roleGroupColors[group.name];
                      return (
                        <Box key={group.name}>
                          <Box
                            style={{
                              backgroundColor:
                                groupColor?.backgroundColor ??
                                'rgba(255, 255, 255, 0.08)',
                              color: groupColor?.color ?? 'inherit',
                              padding: '6px 8px',
                              borderRadius: '2px 2px 0 0',
                            }}
                          >
                            <Stack align="center">
                              <Stack.Item grow>
                                <Box bold>{group.name}</Box>
                              </Stack.Item>
                              <Stack.Item>
                                <Button
                                  selected={allSelected}
                                  color={allSelected ? 'good' : undefined}
                                  onClick={() =>
                                    setSelectedRoles((current) =>
                                      allSelected
                                        ? current.filter(
                                            (role) =>
                                              !groupRoles.includes(role),
                                          )
                                        : Array.from(
                                            new Set([
                                              ...current,
                                              ...groupRoles,
                                            ]),
                                          ),
                                    )
                                  }
                                >
                                  {allSelected
                                    ? 'Deselect group'
                                    : 'Select group'}
                                </Button>
                              </Stack.Item>
                            </Stack>
                          </Box>
                          <Section>
                            {group.roles.map((role) => {
                              const selected = selectedRoles.includes(
                                role.name,
                              );
                              const alreadyBanned = banned_roles.includes(
                                role.name,
                              );
                              const color = selected
                                ? 'good'
                                : alreadyBanned
                                  ? 'average'
                                  : undefined;
                              return (
                                <Button
                                  key={role.name}
                                  selected={selected}
                                  color={color}
                                  style={
                                    selected
                                      ? {
                                          backgroundColor: '#2e7d32',
                                          borderColor: '#66bb6a',
                                          color: '#ffffff',
                                        }
                                      : undefined
                                  }
                                  tooltip={
                                    alreadyBanned
                                      ? 'The player already has an active ban for this role'
                                      : undefined
                                  }
                                  onClick={() => toggleRole(role.name)}
                                >
                                  {role.display_name}
                                </Button>
                              );
                            })}
                          </Section>
                        </Box>
                      );
                    })}
                  </Box>
                </Section>
              </Stack.Item>
            )}

          </Stack>
        )}

        {mode === 'unban' && (
          <Stack vertical>
            <Stack.Item>
              <Section title="Ban search">
                <Stack>
                  <Stack.Item grow>
                    <Box mb={0.5}>Ckey</Box>
                    <Input
                      fluid
                      value={searchPlayerKey}
                      onChange={setSearchPlayerKey}
                      onEnter={searchUnbans}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box mb={0.5}>Administrator key</Box>
                    <Input
                      fluid
                      value={searchAdminKey}
                      onChange={setSearchAdminKey}
                      onEnter={searchUnbans}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box mb={0.5}>IP</Box>
                    <Input
                      fluid
                      value={searchPlayerIp}
                      onChange={setSearchPlayerIp}
                      onEnter={searchUnbans}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box mb={0.5}>CID</Box>
                    <Input
                      fluid
                      value={searchPlayerCid}
                      onChange={setSearchPlayerCid}
                      onEnter={searchUnbans}
                    />
                  </Stack.Item>
                </Stack>
                <Box mt={1}>
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        icon="search"
                        color="good"
                        onClick={searchUnbans}
                      >
                        Search
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon={activeOnly ? 'check-square' : 'square'}
                        selected={activeOnly}
                        color={activeOnly ? 'good' : undefined}
                        style={compactToggleButtonStyle}
                        onClick={() => setActiveOnly(!activeOnly)}
                      >
                        Active only
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Box>
              </Section>
            </Stack.Item>

            {!has_search && (
              <Stack.Item>
                <NoticeBox>Specify at least one search parameter.</NoticeBox>
              </Stack.Item>
            )}

            {!!has_search && (
              <Stack.Item>
                <Section
                  title={`Results: ${total_bans}`}
                  buttons={
                    <>
                      <Button
                        disabled={!activeResultIds.length}
                        onClick={() => setSelectedBanIds(activeResultIds)}
                      >
                        Select all active
                      </Button>
                      <Button
                        disabled={!selectedBanIds.length}
                        onClick={() => setSelectedBanIds([])}
                      >
                        Clear
                      </Button>
                      <Button
                        color="good"
                        icon="unlock"
                        disabled={!selectedBanIds.length}
                        onClick={() =>
                          act('bulk_unban', { ban_ids: selectedBanIds })
                        }
                      >
                        Unban selected ({selectedBanIds.length})
                      </Button>
                    </>
                  }
                >
                  {!results.length && <NoticeBox>No bans found.</NoticeBox>}
                  {results.map((result) => {
                    const selected = selectedBanIds.includes(result.id);
                    return (
                      <Section
                        key={result.id}
                        title={`${result.target} — ${
                          result.role === 'Server' ? 'Server ban' : result.role
                        }`}
                        buttons={
                          <>
                            {!!result.active && (
                              <Button
                                icon={selected ? 'check-square' : 'square'}
                                selected={selected}
                                color={selected ? 'good' : undefined}
                                style={centeredButtonStyle}
                                onClick={() => toggleResult(result.id)}
                              >
                                Select
                              </Button>
                            )}
                            {!!result.active && (
                              <Button
                                icon="edit"
                                onClick={() =>
                                  act('edit_ban', { ban_id: result.id })
                                }
                              >
                                Edit
                              </Button>
                            )}
                            {!!result.has_edits && (
                              <Button
                                icon="history"
                                onClick={() =>
                                  act('edit_log', { ban_id: result.id })
                                }
                              >
                                History
                              </Button>
                            )}
                          </>
                        }
                      >
                        <Stack>
                          <Stack.Item grow>
                            <Box>
                              <b>Administrator:</b> {result.admin_key}
                            </Box>
                            <Box>
                              <b>Date:</b> {result.ban_datetime}, round #
                              {result.ban_round_id}
                            </Box>
                            <Box>
                              <b>Duration:</b> {result.duration}
                              {result.expiration_time
                                ? `, until ${result.expiration_time}`
                                : ''}
                            </Box>
                            {!!result.applies_to_admins && (
                              <Box color="bad" bold>
                                Applies to administrators
                              </Box>
                            )}
                          </Stack.Item>
                          <Stack.Item grow>
                            <Box>
                              <b>Reason:</b> {result.reason}
                            </Box>
                            {!result.active && (
                              <Box color={result.unban_datetime ? 'good' : 'average'}>
                                {result.unban_datetime
                                  ? `Unbanned by ${result.unban_key} — ${result.unban_datetime}, round #${result.unban_round_id}`
                                  : 'Expired'}
                              </Box>
                            )}
                          </Stack.Item>
                        </Stack>
                      </Section>
                    );
                  })}
                </Section>
              </Stack.Item>
            )}

          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};
