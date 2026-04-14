import { useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

type StatEntry = {
  name: string;
  cost: number;
  base: number;
  min: number;
  max: number;
};

type SkillEntry = {
  name: string;
  desc?: string;
  level: number;
  cap: number;
  next_cost: number;
  is_combat: boolean;
};

type TraitEntry = {
  name: string;
  cost: number;
  category: string;
  category_name: string;
  selected: boolean;
  desc?: string;
};

type ItemEntry = {
  name: string;
  cost: number;
  category?: string;
  unlock_type?: string;
  unlock_key?: string;
  slot_group?: string | null;
  amount: number;
  unlocked: boolean;
};

type LoadoutEntry = {
  name: string;
  cost: number;
  category?: string;
  slot_group?: string | null;
  amount: number;
  equip: number;
  bag: number;
};

type Data = {
  stats: Record<string, number>;
  skills: Record<string, SkillEntry>;
  traits: string[];
  trait_entries?: Record<string, TraitEntry>;
  items: Record<string, ItemEntry>;
  loadout: Record<string, LoadoutEntry>;

  available_stats: Record<string, StatEntry>;
  available_skills: Record<string, SkillEntry>;
  available_traits: Record<string, TraitEntry>;
  available_items: Record<string, ItemEntry>;

  points_stats: number;
  points_stats_remaining: number;
  points_skills: number;
  points_skills_remaining: number;
  points_traits: number;
  points_traits_remaining: number;
  points_items: number;
  points_items_remaining: number;

  can_save: boolean;
  dirty: boolean;
};

type TabKey = 'stats' | 'skills' | 'traits' | 'items' | 'loadout';

type NumericRowProps = {
  title: string;
  value: number;
  onAdd: () => void;
  onRemove: () => void;
  disabledAdd?: boolean;
  disabledRemove?: boolean;
  extra?: React.ReactNode;
};

const normalizeSearch = (value: unknown): string =>
  String(value ?? '')
    .toLowerCase()
    .trim();

const matchesSearch = (search: string, ...parts: Array<unknown>): boolean => {
  if (!search) {
    return true;
  }

  const normalized = normalizeSearch(search);
  return parts.some((part) => normalizeSearch(part).includes(normalized));
};

const NumericRow = ({
  title,
  value,
  onAdd,
  onRemove,
  disabledAdd,
  disabledRemove,
  extra,
}: NumericRowProps) => {
  return (
    <Stack
      align="center"
      justify="space-between"
      style={{
        padding: '6px 0',
        borderBottom: '1px solid rgba(255,255,255,0.06)',
      }}>
      <Stack.Item grow>
        <Box bold>{title}</Box>
        {!!extra && (
          <Box mt={0.5} style={{ opacity: 0.85 }}>
            {extra}
          </Box>
        )}
      </Stack.Item>

      <Stack.Item>
        <Stack align="center">
          <Stack.Item>
            <Button compact onClick={onAdd} disabled={disabledAdd}>
              +
            </Button>
          </Stack.Item>

          <Stack.Item>
            <Box width="34px" textAlign="center" bold>
              {value}
            </Box>
          </Stack.Item>

          <Stack.Item>
            <Button compact onClick={onRemove} disabled={disabledRemove}>
              -
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const PointsPanel = ({ data }: { data: Data }) => {
  return (
    <Section title="Points">
      <Stack>
        <Stack.Item grow>
          <Box>
            Stats: {data.points_stats_remaining} / {data.points_stats}
          </Box>
        </Stack.Item>
        <Stack.Item grow>
          <Box>
            Skills: {data.points_skills_remaining} / {data.points_skills}
          </Box>
        </Stack.Item>
      </Stack>

      <Stack mt={1}>
        <Stack.Item grow>
          <Box>
            Traits: {data.points_traits_remaining} / {data.points_traits}
          </Box>
        </Stack.Item>
        <Stack.Item grow>
          <Box>
            Items: {data.points_items_remaining} / {data.points_items}
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const StatsTab = ({
  data,
  act,
  search,
}: {
  data: Data;
  act: (action: string, payload?: object) => void;
  search: string;
}) => {
  const rows = useMemo(() => {
    return Object.entries(data.available_stats || {}).filter(([statId, entry]) =>
      matchesSearch(search, entry.name, statId)
    );
  }, [data.available_stats, search]);

  return (
    <Section title="Stats">
      {!rows.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {rows.map(([statId, entry]) => {
            const value = data.stats?.[statId] ?? entry.base;

            return (
              <NumericRow
                key={statId}
                title={entry.name || statId}
                value={value}
                onAdd={() => act('add_stat', { id: statId, amount: 1 })}
                onRemove={() => act('remove_stat', { id: statId, amount: 1 })}
                disabledAdd={value >= entry.max}
                disabledRemove={value <= entry.min}
                extra={
                  <Box>
                    Base: {entry.base} | Min: {entry.min} | Max: {entry.max} |
                    {' '}Cost per step: {entry.cost}
                  </Box>
                }
              />
            );
          })}
        </Stack>
      )}
    </Section>
  );
};

const SkillsTab = ({
  data,
  act,
  search,
}: {
  data: Data;
  act: Function;
  search: string;
}) => {
  const rows = useMemo(() => {
    return Object.entries(data.available_skills || {})
      .filter(([skillPath, entry]) =>
        matchesSearch(
          search,
          skillPath,
          entry.name,
          entry.desc,
          entry.is_combat ? 'combat' : 'non-combat'
        )
      )
      .sort((a, b) => {
        const aCombat = a[1].is_combat ? 0 : 1;
        const bCombat = b[1].is_combat ? 0 : 1;

        if (aCombat !== bCombat) {
          return aCombat - bCombat;
        }

        return (a[1].name || a[0]).localeCompare(b[1].name || b[0]);
      });
  }, [data.available_skills, search]);

  return (
    <Section title="Skills">
      {!rows.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {rows.map(([skillPath, entry]) => (
            <NumericRow
              key={skillPath}
              title={entry.name || skillPath}
              value={entry.level || 0}
              onAdd={() => act('add_skill', { path: skillPath, amount: 1 })}
              onRemove={() => act('remove_skill', { path: skillPath, amount: 1 })}
              disabledAdd={(entry.level || 0) >= (entry.cap || 0)}
              disabledRemove={(entry.level || 0) <= 0}
              extra={
                <>
                  <Box>
                    {entry.is_combat ? 'Combat' : 'Non-combat'}
                    {' | '}Cap: {entry.cap}
                    {' | '}Next cost: {entry.next_cost}
                  </Box>
                  {!!entry.desc && (
                    <Box mt={0.5}>
                      {entry.desc}
                    </Box>
                  )}
                </>
              }
            />
          ))}
        </Stack>
      )}
    </Section>
  );
};

const TraitPill = ({
  title,
  cost,
  desc,
  selected,
  onClick,
}: {
  title: string;
  cost: number;
  desc?: string;
  selected?: boolean;
  onClick: () => void;
}) => {
  return (
    <Box>
      <Button
        selected={selected}
        color={selected ? 'good' : undefined}
        tooltip={desc || undefined}
        onClick={onClick}>
        {title} ({cost})
      </Button>
    </Box>
  );
};

const TraitsTab = ({
  data,
  act,
  search,
}: {
  data: Data;
  act: Function;
  search: string;
}) => {
  const traitEntries = data.available_traits || {};

  const grouped = useMemo(() => {
    const groups: Record<
      string,
      {
        categoryName: string;
        available: Array<[string, TraitEntry]>;
        selected: Array<[string, TraitEntry]>;
      }
    > = {};

    Object.entries(traitEntries)
      .filter(([traitId, entry]) =>
        matchesSearch(
          search,
          traitId,
          entry.name,
          entry.desc,
          entry.category,
          entry.category_name
        )
      )
      .forEach(([traitId, entry]) => {
        const category = entry.category || 'other';
        const categoryName = entry.category_name || 'Other';

        if (!groups[category]) {
          groups[category] = {
            categoryName,
            available: [],
            selected: [],
          };
        }

        if (entry.selected) {
          groups[category].selected.push([traitId, entry]);
        } else {
          groups[category].available.push([traitId, entry]);
        }
      });

    Object.values(groups).forEach((group) => {
      group.available.sort((a, b) =>
        (a[1].name || a[0]).localeCompare(b[1].name || b[0])
      );
      group.selected.sort((a, b) =>
        (a[1].name || a[0]).localeCompare(b[1].name || b[0])
      );
    });

    return Object.entries(groups).sort((a, b) =>
      a[1].categoryName.localeCompare(b[1].categoryName)
    );
  }, [traitEntries, search]);

  return (
    <Section title="Traits">
      {!grouped.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {grouped.map(([categoryKey, group]) => (
            <Box
              key={categoryKey}
              mb={2}
              style={{
                borderBottom: '1px solid rgba(255,255,255,0.08)',
                paddingBottom: '10px',
              }}>
              <Box
                bold
                mb={1}
                style={{
                  fontSize: '18px',
                  letterSpacing: '1px',
                }}>
                {group.categoryName}
              </Box>

              <Box bold mb={0.5}>
                Pool
              </Box>

              {group.available.length ? (
                <Stack wrap>
                  {group.available.map(([traitId, entry]) => (
                    <Stack.Item key={traitId}>
                      <TraitPill
                        title={entry.name || traitId}
                        cost={entry.cost || 0}
                        desc={entry.desc}
                        onClick={() => act('add_trait', { id: traitId })}
                      />
                    </Stack.Item>
                  ))}
                </Stack>
              ) : (
                <NoticeBox>No available traits in this group.</NoticeBox>
              )}

              <Box bold mt={1} mb={0.5}>
                Selected
              </Box>

              {group.selected.length ? (
                <Stack wrap>
                  {group.selected.map(([traitId, entry]) => (
                    <Stack.Item key={traitId}>
                      <TraitPill
                        title={entry.name || traitId}
                        cost={entry.cost || 0}
                        desc={entry.desc}
                        selected
                        onClick={() => act('remove_trait', { id: traitId })}
                      />
                    </Stack.Item>
                  ))}
                </Stack>
              ) : (
                <NoticeBox>No selected traits in this group.</NoticeBox>
              )}
            </Box>
          ))}
        </Stack>
      )}
    </Section>
  );
};

const ItemsTab = ({
  data,
  act,
  search,
}: {
  data: Data;
  act: Function;
  search: string;
}) => {
  const rows = useMemo(() => {
    return Object.entries(data.available_items || {})
      .filter(([itemPath, entry]) =>
        matchesSearch(
          search,
          itemPath,
          entry.name,
          entry.category,
          entry.slot_group,
          entry.unlock_type,
          entry.unlock_key
        )
      )
      .sort((a, b) =>
        (a[1].name || a[0]).localeCompare(b[1].name || b[0])
      );
  }, [data.available_items, search]);

  return (
    <Section title="Items">
      {!rows.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {rows.map(([itemPath, entry]) => (
            <NumericRow
              key={itemPath}
              title={entry.name || itemPath}
              value={entry.amount || 0}
              onAdd={() => act('add_item', { path: itemPath, amount: 1 })}
              onRemove={() => act('remove_item', { path: itemPath, amount: 1 })}
              disabledAdd={!entry.unlocked}
              disabledRemove={(entry.amount || 0) <= 0}
              extra={
                <Box>
                  {entry.category ? `Category: ${entry.category}` : 'Category: unknown'}
                  {entry.slot_group ? ` | Slot group: ${entry.slot_group}` : ''}
                  {' | '}Cost: {entry.cost}
                  {' | '}{entry.unlocked ? 'Unlocked' : 'Locked'}
                </Box>
              }
            />
          ))}
        </Stack>
      )}
    </Section>
  );
};

const LoadoutTab = ({
  data,
  act,
  search,
}: {
  data: Data;
  act: Function;
  search: string;
}) => {
  const rows = useMemo(() => {
    return Object.entries(data.loadout || {})
      .filter(([itemPath, entry]) =>
        matchesSearch(
          search,
          itemPath,
          entry.name,
          entry.category,
          entry.slot_group
        )
      )
      .sort((a, b) =>
        (a[1].name || a[0]).localeCompare(b[1].name || b[0])
      );
  }, [data.loadout, search]);

  return (
    <Section title="Loadout">
      {!rows.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {rows.map(([itemPath, entry]) => {
            const amount = entry.amount || 0;
            const bag = Math.max(0, Math.min(entry.bag || 0, amount));
            const statusText = bag > 0 ? `Bag (${bag})` : 'Character';

            return (
              <Stack
                key={itemPath}
                align="center"
                style={{
                  padding: '8px 0',
                  borderBottom: '1px solid rgba(255,255,255,0.06)',
                }}>
                <Stack.Item grow basis={0}>
                  <Box bold>{entry.name || itemPath}</Box>
                  <Box mt={0.5} style={{ opacity: 0.85 }}>
                    Total: {amount}
                    {entry.slot_group ? ` | Slot: ${entry.slot_group}` : ''}
                    {entry.category ? ` | Category: ${entry.category}` : ''}
                  </Box>
                </Stack.Item>

                <Stack.Item width="40px">
                  <Box textAlign="center" bold>
                    {amount}
                  </Box>
                </Stack.Item>

                <Stack.Item width="120px">
                  <Button
                    fluid
                    disabled
                    color={bag > 0 ? 'average' : 'good'}>
                    {statusText}
                  </Button>
                </Stack.Item>

                <Stack.Item>
                  <Button
                    compact
                    onClick={() => act('move_item_to_bag', { path: itemPath, amount: 1 })}
                    disabled={bag >= amount}>
                    +
                  </Button>
                </Stack.Item>

                <Stack.Item>
                  <Button
                    compact
                    onClick={() => act('move_item_to_equip', { path: itemPath, amount: 1 })}
                    disabled={bag <= 0}>
                    -
                  </Button>
                </Stack.Item>
              </Stack>
            );
          })}
        </Stack>
      )}
    </Section>
  );
};

export const TATBuild = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('stats');
  const [search, setSearch] = useState('');

  return (
    <Window title="TAT Build" width={860} height={780}>
      <Window.Content scrollable>
        <Stack vertical>
          <PointsPanel data={data} />

          <Section title="Search">
            <Stack align="center">
              <Stack.Item grow>
                <Input
                  fluid
                  placeholder={`Search in ${tab}...`}
                  value={search}
                  onChange={(value) => setSearch(String(value))}
                />
              </Stack.Item>

              <Stack.Item>
                <Button
                  disabled={!search}
                  onClick={() => setSearch('')}>
                  Clear
                </Button>
              </Stack.Item>
            </Stack>
          </Section>

          {data.dirty ? (
            <NoticeBox>
              Build has unsaved changes.
            </NoticeBox>
          ) : (
            <NoticeBox>
              Build is saved.
            </NoticeBox>
          )}

          {!data.can_save && (
            <NoticeBox>
              Current build is invalid or exceeds available points.
            </NoticeBox>
          )}

          <Section>
            <Tabs fluid>
              <Tabs.Tab
                selected={tab === 'stats'}
                onClick={() => setTab('stats')}>
                Stats
              </Tabs.Tab>
              <Tabs.Tab
                selected={tab === 'skills'}
                onClick={() => setTab('skills')}>
                Skills
              </Tabs.Tab>
              <Tabs.Tab
                selected={tab === 'traits'}
                onClick={() => setTab('traits')}>
                Traits
              </Tabs.Tab>
              <Tabs.Tab
                selected={tab === 'items'}
                onClick={() => setTab('items')}>
                Items
              </Tabs.Tab>
              <Tabs.Tab
                selected={tab === 'loadout'}
                onClick={() => setTab('loadout')}>
                Loadout
              </Tabs.Tab>
            </Tabs>
          </Section>

          {tab === 'stats' && <StatsTab data={data} act={act} search={search} />}
          {tab === 'skills' && <SkillsTab data={data} act={act} search={search} />}
          {tab === 'traits' && <TraitsTab data={data} act={act} search={search} />}
          {tab === 'items' && <ItemsTab data={data} act={act} search={search} />}
          {tab === 'loadout' && <LoadoutTab data={data} act={act} search={search} />}

          <Section>
            <Stack justify="space-between" wrap>
              <Stack.Item>
                <Stack wrap>
                  <Stack.Item>
                    <Button onClick={() => act('reset_stats')}>
                      Reset Stats
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => act('reset_skills')}>
                      Reset Skills
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => act('reset_traits')}>
                      Reset Traits
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => act('reset_items')}>
                      Reset Items
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>

              <Stack.Item>
                <Stack>
                  <Stack.Item>
                    <Button color="average" onClick={() => act('reset_all')}>
                      Reset All
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color="good"
                      disabled={!data.can_save}
                      onClick={() => act('save')}>
                      Save
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export default TATBuild;
