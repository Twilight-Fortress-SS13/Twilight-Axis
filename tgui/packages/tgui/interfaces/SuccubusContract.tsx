import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

type IdName = {
  id: string;
  name: string;
  desc?: string;
  category?: string;
  slot_group?: string;
  cost?: number;
  is_combat?: boolean;
  is_weapon?: boolean;
  tier?: number;
};

type ClauseEntry = {
  id?: string;
  index?: number;
  type?: string;
  name: string;
  desc?: string;
  summary?: string;
  power?: number;
  hidden?: boolean;
  revealed?: boolean;
};

type ContractCatalog = {
  bonus_types?: IdName[];
  curse_types?: IdName[];
  stats?: IdName[];
  skills?: IdName[];
  item_types?: IdName[];
  custom_item_templates?: IdName[];
  custom_item_enchantments?: IdName[];
  triggers?: IdName[];
  flaws?: IdName[];
};

type Data = {
  title?: string;
  role?: 'contractor' | 'succubus' | 'viewer';
  phase?:
    | 'contractor_boons'
    | 'succubus_gift_boons'
    | 'succubus_curses'
    | 'contractor_signature'
    | 'summary'
    | 'locked';
  status?: string;
  gift_contract?: boolean;
  succubus_name?: string;
  contractor_name?: string;
  can_accept?: boolean;
  can_refuse?: boolean;
  read_chance?: number;
  curse_read_success?: boolean;
  bonus_power?: number;
  curse_power?: number;
  required_curse_power?: number;
  lux_power?: number;
  devotion?: number;
  max_devotion?: number;
  level?: number;
  level_name?: string;
  bonuses?: ClauseEntry[];
  curses?: ClauseEntry[];
  visible_curses?: ClauseEntry[];
  catalog?: ContractCatalog;
  error?: string;
  notice?: string;
};

type BackendAct = (action: string, payload?: Record<string, unknown>) => void;

type Draft = Record<string, unknown>;

const defaultBonuses: IdName[] = [
  { id: 'information', name: 'Information', desc: 'Find a person, creature, or object.' },
  { id: 'body_change', name: 'Body Change', desc: 'Temporary mirror-like body editing.' },
  { id: 'orgasm', name: 'Orgasm', desc: 'Complete after chosen climaxes.' },
  { id: 'item', name: 'Item', desc: 'Gold coins or prepared potion bases.' },
  { id: 'custom_item', name: 'Thing', desc: 'A selected TAT item with contract enchantments.' },
  { id: 'skill', name: 'Training', desc: 'Raise a skill.' },
  { id: 'stat', name: 'Empowerment', desc: 'Raise a stat.' },
];

const defaultCurses: IdName[] = [
  { id: 'effect', name: 'Trigger: Submission' },
  { id: 'arousal', name: 'Trigger: Arousal' },
  { id: 'orgasm', name: 'Trigger: Pleasure Shock' },
  { id: 'stat_loss', name: 'Trigger: Stat Adjustment' },
  { id: 'skill_loss', name: 'Trigger: Skill Adjustment' },
  { id: 'body_change', name: 'Body Mark' },
  { id: 'emotion', name: 'Trigger: Emotion' },
  { id: 'flaw', name: 'Trigger: Vice' },
];

const defaultStats: IdName[] = [
  { id: 'str', name: 'Strength' },
  { id: 'per', name: 'Perception' },
  { id: 'int', name: 'Intelligence' },
  { id: 'con', name: 'Constitution' },
  { id: 'end', name: 'Endurance' },
  { id: 'spd', name: 'Speed' },
  { id: 'wil', name: 'Willpower' },
  { id: 'lck', name: 'Luck' },
];

const defaultTriggers: IdName[] = [
  { id: 'attack', name: 'Attack' },
  { id: 'sex_process', name: 'Sex Process' },
  { id: 'climax', name: 'Climax' },
  { id: 'phrase', name: 'Phrase' },
  { id: 'eat', name: 'Eating' },
  { id: 'sleep', name: 'Sleeping' },
  { id: 'fulfillment', name: 'Contract Fulfillment' },
];

const defaultItemTypes: IdName[] = [
  { id: 'gold_coin', name: 'Gold coin' },
  { id: 'strpot', name: 'Strength Potion' },
  { id: 'perpot', name: 'Perception Potion' },
  { id: 'intpot', name: 'Intelligence Potion' },
  { id: 'conpot', name: 'Constitution Potion' },
  { id: 'endpot', name: 'Willpower Potion' },
  { id: 'spdpot', name: 'Speed Potion' },
  { id: 'lucpot', name: 'Luck Potion' },
  { id: 'antidote', name: 'Poison Antidote' },
  { id: 'rotcure', name: 'Rotcure Potion' },
  { id: 'random_spell_scroll', name: 'Random enchantment scroll', desc: 'Random spell-granting scroll. Expensive request.' },
];

const defaultEnchantments: IdName[] = [
  { id: 'none', name: 'No enchantment' },
  { id: 'random', name: 'Random enchantment' },
];

const phaseTitles: Record<string, string> = {
  contractor_boons: 'Choose desire',
  succubus_gift_boons: 'Shape gift',
  succubus_curses: 'Write price',
  contractor_signature: 'Read and sign',
  summary: 'Bound contract',
  locked: 'Waiting',
};

const byId = (list: IdName[], id: string) => list.find((entry) => entry.id === id);
const names = (list: IdName[]) => list.map((entry) => entry.name);
const idByName = (list: IdName[], name: string) => list.find((entry) => entry.name === name)?.id || list[0]?.id || '';
const nameById = (list: IdName[], id: string) => byId(list, id)?.name || id;
const percent = (value?: number) => Math.round(value || 0);
const prettyStatus = (status?: string) => String(status || 'draft').replace(/_/g, ' ');
const clauseKey = (entry: ClauseEntry, index: number) => entry.id || `${entry.type || 'clause'}_${entry.index ?? index}`;

export const SuccubusContract = () => {
  const { act, data } = useBackend<Data>();
  const phase = data.phase || 'locked';
  const gift = !!data.gift_contract;
  const bonusPower = data.bonus_power || 0;
  const cursePower = data.curse_power || 0;
  const remaining = Math.max(0, bonusPower - cursePower);
  const over = Math.max(0, cursePower - bonusPower);
  const luxRebate = Math.floor(remaining / 5);
  const [hovered, setHovered] = useState<ClauseEntry | null>(null);

  return (
    <Window width={1040} height={880} title={data.title || (gift ? 'Succubus Gift' : 'Infernal Contract')}>
      <Window.Content scrollable>
        <Stack vertical>
          <HeroHeader data={data} phase={phase} />
          {!!data.error && <NoticeBox color="bad">{data.error}</NoticeBox>}
          {!!data.notice && <NoticeBox>{data.notice}</NoticeBox>}
          <Stack wrap align="stretch">
            <Stack.Item grow basis="64%" style={{ minWidth: '560px' }}>
              <PowerBoard bonusPower={bonusPower} cursePower={cursePower} remaining={remaining} over={over} luxPower={data.lux_power || 0} luxRebate={luxRebate} />
            </Stack.Item>
            <Stack.Item grow basis="32%" style={{ minWidth: '300px' }}>
              <SoulBoard data={data} />
            </Stack.Item>
          </Stack>
          <FlowTabs phase={phase} gift={gift} />
          {(phase === 'contractor_boons' || phase === 'succubus_gift_boons') && <BoonBuilder gift={gift} data={data} act={act} setHovered={setHovered} />}
          {phase === 'succubus_curses' && <CurseBuilder data={data} ready={over <= 0} act={act} setHovered={setHovered} />}
          {phase === 'contractor_signature' && <SignaturePanel data={data} act={act} setHovered={setHovered} />}
          {(phase === 'summary' || phase === 'locked') && <SummaryPanel data={data} setHovered={setHovered} />}
        </Stack>
        <HoverCard entry={hovered} />
      </Window.Content>
    </Window>
  );
};

const HeroHeader = ({ data, phase }: { data: Data; phase: string }) => (
  <Section>
    <Box style={{ padding: '12px', borderRadius: '10px', border: '1px solid rgba(255,255,255,0.08)', background: 'linear-gradient(135deg, rgba(139,0,60,0.35), rgba(20,10,28,0.86))' }}>
      <Stack align="center" justify="space-between">
        <Stack.Item grow>
          <Box style={{ fontSize: '24px', fontWeight: 800, color: '#f3c0d6', letterSpacing: '0.5px' }}>{data.gift_contract ? 'Gift-Contract' : 'Infernal Contract'}</Box>
          <Box mt={0.4} style={{ opacity: 0.88 }}>{data.succubus_name || 'Unknown succubus'} ⇄ {data.contractor_name || 'Unknown contractor'}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box px={1.25} py={0.7} style={{ borderRadius: '999px', background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.12)', fontWeight: 700, textTransform: 'capitalize' }}>{phaseTitles[phase] || prettyStatus(data.status)}</Box>
        </Stack.Item>
      </Stack>
    </Box>
  </Section>
);

const SoulBoard = ({ data }: { data: Data }) => {
  const devotion = data.devotion || 0;
  const maxDevotion = data.max_devotion || 200;
  const pct = Math.max(0, Math.min(100, Math.round((devotion / Math.max(1, maxDevotion)) * 100)));
  return (
    <Section title="Succubus Core" fill>
      <LabeledList>
        <LabeledList.Item label="Level">{data.level_name || data.level || 0}</LabeledList.Item>
        <LabeledList.Item label="Devotion">{devotion} / {maxDevotion}</LabeledList.Item>
        <LabeledList.Item label="Status">{prettyStatus(data.status)}</LabeledList.Item>
      </LabeledList>
      <Box mt={1} style={{ height: '12px', borderRadius: '999px', background: 'rgba(255,255,255,0.08)', overflow: 'hidden' }}>
        <Box style={{ width: `${pct}%`, height: '100%', background: 'linear-gradient(90deg, #8b003c, #f0c35a)' }} />
      </Box>
    </Section>
  );
};

const PowerBoard = ({ bonusPower, cursePower, remaining, over, luxPower, luxRebate }: { bonusPower: number; cursePower: number; remaining: number; over: number; luxPower: number; luxRebate: number }) => {
  const pct = Math.max(0, Math.min(100, Math.round((cursePower / Math.max(1, bonusPower)) * 100)));
  return (
    <Section title="Contract Economy" fill>
      <Stack align="center">
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="Seal cost">100 Lux</LabeledList.Item>
            <LabeledList.Item label="Available Lux">{luxPower}</LabeledList.Item>
            <LabeledList.Item label="Boon budget">{bonusPower}</LabeledList.Item>
            <LabeledList.Item label="Written price">{cursePower}</LabeledList.Item>
            <LabeledList.Item label="Unspent → Lux">{remaining} power → {luxRebate} Lux</LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item width="290px">
          <Box style={{ height: '18px', borderRadius: '999px', background: 'rgba(255,255,255,0.08)', overflow: 'hidden' }}>
            <Box style={{ width: `${pct}%`, height: '100%', background: over > 0 ? 'linear-gradient(90deg, #a33, #f0c35a)' : 'linear-gradient(90deg, #6f1d57, #f0c35a)' }} />
          </Box>
          <Box mt={0.75} textAlign="center" color={over > 0 ? 'bad' : 'good'} bold>{over > 0 ? `Over budget by ${over}` : 'Succubus may leave budget unspent'}</Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FlowTabs = ({ phase, gift }: { phase: string; gift: boolean }) => (
  <Section title="Flow">
    <Tabs fluid>
      <Tabs.Tab selected={phase === 'contractor_boons' || phase === 'succubus_gift_boons'}>{gift ? 'Gift' : 'Desire'}</Tabs.Tab>
      <Tabs.Tab selected={phase === 'succubus_curses'}>Price</Tabs.Tab>
      <Tabs.Tab selected={phase === 'contractor_signature'}>Signature</Tabs.Tab>
      <Tabs.Tab selected={phase === 'summary'}>Aftermath</Tabs.Tab>
    </Tabs>
  </Section>
);

const BoonBuilder = ({ gift, data, act, setHovered }: { gift: boolean; data: Data; act: BackendAct; setHovered: (entry: ClauseEntry | null) => void }) => {
  const catalog = data.catalog || {};
  const bonusTypes = catalog.bonus_types?.length ? catalog.bonus_types : defaultBonuses;
  const [type, setType] = useState(bonusTypes[0]?.id || 'information');
  const [draft, setDraft] = useState<Draft>({});
  const selected = byId(bonusTypes, type) || bonusTypes[0];
  const add = () => {
    const payload: Draft = { type, ...draft };

    if (type === 'custom_item') {
      const templates = catalog.custom_item_templates || [];
      const enchantments = catalog.custom_item_enchantments || [];

      if (!payload.item_template && templates[0]?.id) {
        payload.item_template = templates[0].id;
      }

      if (!payload.enchantment_spell_path && enchantments[0]?.id) {
        payload.enchantment_spell_path = enchantments[0].id;
      }
    }

    act('add_bonus', payload);
    setDraft({});
  };
  return (
    <Stack align="stretch" wrap>
      <Stack.Item grow basis="40%" style={{ minWidth: '360px' }}><ClauseShelf title="Written Boons" entries={data.bonuses || []} editable onRemove={(id, index) => act('remove_bonus', { id, index })} setHovered={setHovered} /></Stack.Item>
      <Stack.Item grow basis="56%" style={{ minWidth: '520px' }}>
        <Section title={gift ? 'Prepare a Boon' : 'Choose a Desire'} buttons={<Button color="bad" onClick={() => act('cancel_contract')}>Cancel</Button>}>
          <Stack vertical>
            <CardGrid entries={bonusTypes} selected={type} onSelect={(id) => { setType(id); setDraft({}); }} />
            <Divider />
            <Box bold style={{ color: '#f0c35a' }}>{selected?.name}</Box>
            {!!selected?.desc && <Box style={{ opacity: 0.85 }}>{selected.desc}</Box>}
            <BonusFields type={type} draft={draft} setDraft={setDraft} catalog={catalog} />
            <Stack><Stack.Item><Button color="good" icon="plus" onClick={add}>Add Boon</Button></Stack.Item><Stack.Item grow /><Stack.Item><Button color="average" icon="arrow-right" disabled={!data.bonuses?.length} onClick={() => act('submit_bonuses')}>{gift ? 'Write Price' : 'Send Request'}</Button></Stack.Item></Stack>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const CurseBuilder = ({ data, ready, act, setHovered }: { data: Data; ready: boolean; act: BackendAct; setHovered: (entry: ClauseEntry | null) => void }) => {
  const catalog = data.catalog || {};
  const curseTypes = catalog.curse_types?.length ? catalog.curse_types : defaultCurses;
  const [type, setType] = useState(curseTypes[0]?.id || 'effect');
  const [draft, setDraft] = useState<Draft>({});
  const selected = byId(curseTypes, type) || curseTypes[0];
  const add = () => { act('add_curse', { type, ...draft }); setDraft({}); };
  return (
    <Stack align="stretch" wrap>
      <Stack.Item grow basis="40%" style={{ minWidth: '360px' }}>
        <Stack vertical>
          <ClauseShelf title="Promised Boons" entries={data.bonuses || []} setHovered={setHovered} />
          <ClauseShelf title="Written Price" entries={data.curses || []} editable onRemove={(id, index) => act('remove_curse', { id, index })} setHovered={setHovered} />
        </Stack>
      </Stack.Item>
      <Stack.Item grow basis="56%" style={{ minWidth: '520px' }}>
        <Section title="Write the Price" buttons={<Button color="bad" onClick={() => act('cancel_contract')}>Cancel</Button>}>
          <Stack vertical>
            <CardGrid entries={curseTypes} selected={type} onSelect={(id) => { setType(id); setDraft({}); }} />
            <Divider />
            <Box bold style={{ color: '#f0c35a' }}>{selected?.name}</Box>
            {!!selected?.desc && <Box style={{ opacity: 0.85 }}>{selected.desc}</Box>}
            <CurseFields type={type} draft={draft} setDraft={setDraft} catalog={catalog} />
            <Stack><Stack.Item><Button color="good" icon="plus" onClick={add}>Add Clause</Button></Stack.Item><Stack.Item grow /><Stack.Item><Button color="average" icon="file-signature" disabled={!ready} onClick={() => act('submit_curses')}>Send Terms</Button></Stack.Item></Stack>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const SignaturePanel = ({ data, act, setHovered }: { data: Data; act: BackendAct; setHovered: (entry: ClauseEntry | null) => void }) => {
  const visibleCurses = data.visible_curses || data.curses || [];
  const gift = !!data.gift_contract;
  return (
    <Stack align="stretch" wrap>
      <Stack.Item grow basis="48%" style={{ minWidth: '380px' }}><ClauseShelf title="Promised Boons" entries={data.bonuses || []} setHovered={setHovered} /></Stack.Item>
      <Stack.Item grow basis="48%" style={{ minWidth: '380px' }}><ClauseShelf title={gift || data.curse_read_success ? 'Visible Price' : 'Clauses'} entries={visibleCurses} obscureHidden={!gift && !data.curse_read_success} setHovered={setHovered} /></Stack.Item>
      <Stack.Item grow basis="100%">
        <Section title={gift ? 'Accept the Gift?' : 'Sign the Contract?'}>
          <NoticeBox>{gift ? 'The gift has no refusal penalty.' : `Reading chance: ${percent(data.read_chance)}%. Hidden clauses may be unreadable.`}</NoticeBox>
          <Stack mt={1}><Stack.Item grow><Button fluid color="good" icon="check" disabled={!data.can_accept && data.can_accept !== undefined} onClick={() => act('accept_contract')}>Accept</Button></Stack.Item><Stack.Item grow><Button fluid color="bad" icon="times" disabled={!data.can_refuse && data.can_refuse !== undefined} onClick={() => act('refuse_contract')}>Refuse</Button></Stack.Item></Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const SummaryPanel = ({ data, setHovered }: { data: Data; setHovered: (entry: ClauseEntry | null) => void }) => (
  <Stack align="stretch" wrap>
    <Stack.Item grow basis="48%" style={{ minWidth: '380px' }}><ClauseShelf title="Boons" entries={data.bonuses || []} setHovered={setHovered} /></Stack.Item>
    <Stack.Item grow basis="48%" style={{ minWidth: '380px' }}><ClauseShelf title="Clauses" entries={data.curses || []} setHovered={setHovered} /></Stack.Item>
  </Stack>
);

const ClauseShelf = ({
  title,
  entries,
  editable,
  obscureHidden,
  onRemove,
  setHovered,
}: {
  title: string;
  entries: ClauseEntry[];
  editable?: boolean;
  obscureHidden?: boolean;
  onRemove?: (id: string | undefined, index: number) => void;
  setHovered: (entry: ClauseEntry | null) => void;
}) => {
  return (
    <Section title={title} fill>
      {!entries.length ? (
        <NoticeBox>No entries yet.</NoticeBox>
      ) : (
        <Stack vertical>
          {entries.map((entry, index) => {
            const hidden = !!entry.hidden && obscureHidden && !entry.revealed;
            return (
              <Stack.Item key={clauseKey(entry, index)}>
                <div
                  onMouseEnter={() =>
                    setHovered(
                      hidden
                        ? {
                            name: 'Hidden clause',
                            summary:
                              'The infernal script twists beyond your understanding.',
                          }
                        : entry
                    )
                  }
                  onMouseLeave={() => setHovered(null)}
                  style={{
                    padding: '9px 10px',
                    borderRadius: '8px',
                    background: hidden
                      ? 'rgba(80,45,90,0.16)'
                      : 'rgba(255,255,255,0.035)',
                    border: '1px solid rgba(255,255,255,0.08)',
                  }}
                >
                  <Stack align="center">
                    <Stack.Item grow>
                      <Box
                        bold
                        style={{
                          color: hidden ? '#d4a7ff' : '#f0c35a',
                        }}
                      >
                        {hidden ? 'Hidden clause' : entry.name}
                      </Box>
                      <Box style={{ opacity: 0.78 }}>
                        {hidden
                          ? 'Unreadable infernal script.'
                          : entry.summary || entry.desc || ''}
                      </Box>
                    </Stack.Item>
                    <Stack.Item width="56px" textAlign="right">
                      <Box bold color={entry.power ? 'good' : 'label'}>
                        {entry.power || 0}
                      </Box>
                    </Stack.Item>
                    {editable && (
                      <Stack.Item>
                        <Button
                          icon="trash"
                          color="bad"
                          onClick={() =>
                            onRemove?.(entry.id, entry.index ?? index)
                          }
                        />
                      </Stack.Item>
                    )}
                  </Stack>
                </div>
              </Stack.Item>
            );
          })}
        </Stack>
      )}
    </Section>
  );
};

const CardGrid = ({ entries, selected, onSelect }: { entries: IdName[]; selected: string; onSelect: (id: string) => void }) => {
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(132px, 1fr))',
        gap: '8px',
      }}
    >
      {entries.map((entry) => (
        <div
          key={entry.id}
          onClick={() => onSelect(entry.id)}
          style={{
            minHeight: '68px',
            padding: '9px',
            borderRadius: '9px',
            background:
              selected === entry.id
                ? 'rgba(240,195,90,0.18)'
                : 'rgba(255,255,255,0.035)',
            border:
              selected === entry.id
                ? '1px solid rgba(240,195,90,0.75)'
                : '1px solid rgba(255,255,255,0.08)',
            cursor: 'pointer',
            userSelect: 'none',
          }}
        >
          <Box bold>{entry.name}</Box>
          {!!entry.desc && (
            <Box mt={0.4} style={{ opacity: 0.68, fontSize: '11px', lineHeight: 1.25 }}>
              {entry.desc}
            </Box>
          )}
        </div>
      ))}
    </div>
  );
};

const BonusFields = ({ type, draft, setDraft, catalog }: { type: string; draft: Draft; setDraft: (draft: Draft) => void; catalog: ContractCatalog }) => {
  const patch = (key: string, value: unknown) => setDraft({ ...draft, [key]: value });
  if (type === 'information') return <LabeledList><LabeledList.Item label="Target"><Input fluid value={String(draft.target_name || '')} onChange={(value) => patch('target_name', value)} /></LabeledList.Item></LabeledList>;
  if (type === 'body_change') return <NumberField label="Mirror minutes" value={Number(draft.duration_minutes || 5)} min={1} max={60} onChange={(value) => patch('duration_minutes', value)} />;
  if (type === 'orgasm') return <LabeledList><LabeledList.Item label="Source"><Dropdown width="180px" selected={String(draft.source_type || 'any')} options={['any', 'penis', 'vagina', 'mouth', 'anus', 'breasts']} onSelected={(value) => patch('source_type', value)} /></LabeledList.Item><LabeledList.Item label="Count"><NumberInput value={Number(draft.count || 1)} minValue={1} maxValue={10} step={1} onChange={(value) => patch('count', value)} /></LabeledList.Item></LabeledList>;
  if (type === 'item') {
    const items = catalog.item_types?.length ? catalog.item_types : defaultItemTypes;
    const current = String(draft.item_kind || items[0]?.id || 'gold_coin');
    return <LabeledList><LabeledList.Item label="Item"><Dropdown width="260px" selected={nameById(items, current)} options={names(items)} onSelected={(name) => patch('item_kind', idByName(items, String(name)))} /></LabeledList.Item><LabeledList.Item label="Amount"><NumberInput value={Number(draft.amount || 1)} minValue={1} maxValue={50} step={1} onChange={(value) => patch('amount', value)} /></LabeledList.Item></LabeledList>;
  }
  if (type === 'stat') return <StatSkillFields mode="stat" list={catalog.stats?.length ? catalog.stats : defaultStats} draft={draft} patch={patch} />;
  if (type === 'skill') return <StatSkillFields mode="skill" list={catalog.skills || []} draft={draft} patch={patch} />;
  if (type === 'custom_item') return <CustomItemFields draft={draft} patch={patch} catalog={catalog} />;
  return <Box color="label">No extra settings.</Box>;
};

const CurseFields = ({ type, draft, setDraft, catalog }: { type: string; draft: Draft; setDraft: (draft: Draft) => void; catalog: ContractCatalog }) => {
  const patch = (key: string, value: unknown) => setDraft({ ...draft, [key]: value });
  if (type === 'body_change') {
    return <NoticeBox>Body Mark applies once when the contract is fulfilled. It does not need a trigger.</NoticeBox>;
  }
  if (type === 'arousal') {
    return (
      <TriggeredFields
        draft={draft}
        patch={patch}
        catalog={catalog}
        showSource
        extra={<LabeledList.Item label="Arousal chunks (+/-)"><NumberInput value={Number(draft.chunks || 1)} minValue={-20} maxValue={20} step={1} onChange={(value) => patch('chunks', value)} /></LabeledList.Item>}
      />
    );
  }
  if (type === 'effect') {
    return (
      <TriggeredFields
        draft={draft}
        patch={patch}
        catalog={catalog}
        showSource
        extra={<LabeledList.Item label="Submission chunks (+/-)"><NumberInput value={Number(draft.chunks || 1)} minValue={-20} maxValue={20} step={1} onChange={(value) => patch('chunks', value)} /></LabeledList.Item>}
      />
    );
  }
  if (type === 'orgasm') {
    return (
      <TriggeredFields
        draft={draft}
        patch={patch}
        catalog={catalog}
        showSource
        extra={<LabeledList.Item label="Intensity"><NumberInput value={Number(draft.count || 1)} minValue={1} maxValue={10} step={1} onChange={(value) => patch('count', value)} /></LabeledList.Item>}
      />
    );
  }
  if (type === 'stat_loss') {
    return <TriggeredFields draft={draft} patch={patch} catalog={catalog} showSource extra={<StatSkillFields mode="stat" list={catalog.stats?.length ? catalog.stats : defaultStats} draft={draft} patch={patch} bare allowNegative />} />;
  }
  if (type === 'skill_loss') {
    return <TriggeredFields draft={draft} patch={patch} catalog={catalog} showSource extra={<StatSkillFields mode="skill" list={catalog.skills || []} draft={draft} patch={patch} bare allowNegative />} />;
  }
  if (type === 'emotion') {
    return <TriggeredFields draft={draft} patch={patch} catalog={catalog} showSource extra={<LabeledList.Item label="Emotion"><Input fluid value={String(draft.emotion_text || 'longing')} onChange={(value) => patch('emotion_text', value)} /></LabeledList.Item>} />;
  }
  if (type === 'flaw') {
    const flaws = catalog.flaws || [];
    const current = String(draft.flaw_type || flaws[0]?.id || '');
    return (
      <TriggeredFields
        draft={draft}
        patch={patch}
        catalog={catalog}
        showSource
        extra={
          flaws.length ? (
            <LabeledList.Item label="Vice">
              <Dropdown
                width="320px"
                selected={nameById(flaws, current)}
                options={names(flaws)}
                onSelected={(name) => patch('flaw_type', idByName(flaws, String(name)))}
              />
            </LabeledList.Item>
          ) : (
            <LabeledList.Item label="Vice">
              <NoticeBox color="bad">No flaw catalog was sent by backend.</NoticeBox>
            </LabeledList.Item>
          )
        }
      />
    );
  }
  return <Box color="label">No extra settings.</Box>;
};

const TriggeredFields = ({ draft, patch, catalog, extra, showSource }: { draft: Draft; patch: (key: string, value: unknown) => void; catalog: ContractCatalog; extra?: React.ReactNode; showSource?: boolean }) => {
  const triggers = catalog.triggers?.length ? catalog.triggers : defaultTriggers;
  const current = String(draft.trigger_key || triggers[0]?.id || 'sex_process');
  return (
    <LabeledList>
      <LabeledList.Item label="Trigger">
        <Dropdown width="260px" selected={nameById(triggers, current)} options={names(triggers)} onSelected={(name) => patch('trigger_key', idByName(triggers, String(name)))} />
      </LabeledList.Item>
      {current === 'attack' && (
        <LabeledList.Item label="Attack chance">
          <NumberInput value={Number(draft.trigger_chance || 100)} minValue={5} maxValue={100} step={5} onChange={(value) => patch('trigger_chance', value)} />
        </LabeledList.Item>
      )}
      {current === 'phrase' && (
        <LabeledList.Item label="Phrase">
          <Input fluid value={String(draft.required_phrase || '')} onChange={(value) => patch('required_phrase', value)} />
        </LabeledList.Item>
      )}
      {current === 'climax' && showSource && (
        <LabeledList.Item label="Climax source">
          <Dropdown width="180px" selected={String(draft.source_type || 'any')} options={['any', 'penis', 'vagina', 'mouth', 'anus', 'breasts']} onSelected={(value) => patch('source_type', value)} />
        </LabeledList.Item>
      )}
      {current === 'fulfillment' && <LabeledList.Item label="Price modifier">Half price</LabeledList.Item>}
      {extra}
    </LabeledList>
  );
};

const StatSkillFields = ({ mode, list, draft, patch, bare, allowNegative }: { mode: 'stat' | 'skill'; list: IdName[]; draft: Draft; patch: (key: string, value: unknown) => void; bare?: boolean; allowNegative?: boolean }) => {
  const key = mode === 'stat' ? 'stat_key' : 'skill_key';
  const current = String(draft[key] || list[0]?.id || '');
  if (!list.length) return <NoticeBox color="bad">No {mode} catalog was sent by backend.</NoticeBox>;
  const targetRow = <LabeledList.Item key="target" label={mode === 'stat' ? 'Stat' : 'Skill'}><Dropdown width="280px" selected={nameById(list, current)} options={names(list)} onSelected={(name) => patch(key, idByName(list, String(name)))} /></LabeledList.Item>;
  const amountRow = <LabeledList.Item key="amount" label="Amount"><NumberInput value={Number(draft.amount || (allowNegative ? -1 : 1))} minValue={allowNegative ? -10 : 1} maxValue={10} step={1} onChange={(value) => patch('amount', value)} /></LabeledList.Item>;
  if (bare) return [targetRow, amountRow];
  return <LabeledList>{targetRow}{amountRow}</LabeledList>;
};

const NumberField = ({ label, value, min, max, onChange }: { label: string; value: number; min: number; max: number; onChange: (value: number) => void }) => <LabeledList><LabeledList.Item label={label}><NumberInput value={value} minValue={min} maxValue={max} step={1} onChange={onChange} /></LabeledList.Item></LabeledList>;

const CustomItemFields = ({ draft, patch, catalog }: { draft: Draft; patch: (key: string, value: unknown) => void; catalog: ContractCatalog }) => {
  const templates = catalog.custom_item_templates || [];
  const enchantments = catalog.custom_item_enchantments?.length ? catalog.custom_item_enchantments : defaultEnchantments;
  const stats = catalog.stats?.length ? catalog.stats : defaultStats;
  const selectedTemplate = String(draft.item_template || templates[0]?.id || '');
  const selectedEntry = byId(templates, selectedTemplate) || templates[0];
  const selectedEnchant = String(draft.enchantment_spell_path || enchantments[0]?.id || 'none');
  const selectedEnchantEntry = byId(enchantments, selectedEnchant);
  const isWeapon = !!selectedEntry?.is_weapon;

  useEffect(() => {
    if (!draft.item_template && templates[0]?.id) {
      patch('item_template', templates[0].id);
    }
  }, [draft.item_template, templates]);

  if (!templates.length) {
    return <NoticeBox color="bad">No TAT item catalog was sent by backend.</NoticeBox>;
  }

  return (
    <Stack vertical>
      <LabeledList>
        <LabeledList.Item label="Item">
          <Dropdown
            width="480px"
            selected={nameById(templates, selectedTemplate)}
            options={names(templates)}
            onSelected={(name) => {
              const nextId = idByName(templates, String(name));
              patch('item_template', nextId);
            }}
          />
        </LabeledList.Item>

        <LabeledList.Item label="Item class">
          {selectedEntry?.is_weapon ? 'Weapon' : 'Worn item'} · {selectedEntry?.slot_group || 'slot unknown'}
        </LabeledList.Item>


        <LabeledList.Item label="Color">
          <Input
            value={String(draft.color || '#8B003C')}
            onChange={(value) => patch('color', value)}
          />
        </LabeledList.Item>

        {isWeapon && (
          <LabeledList.Item label="Force bonus">
            <NumberInput
              value={Number(draft.force_bonus || 0)}
              minValue={0}
              maxValue={10}
              step={1}
              onChange={(value) => patch('force_bonus', value)}
            />
          </LabeledList.Item>
        )}

        {isWeapon && (
          <LabeledList.Item label="Defense bonus">
            <NumberInput
              value={Number(draft.defense_bonus || 0)}
              minValue={0}
              maxValue={10}
              step={1}
              onChange={(value) => patch('defense_bonus', value)}
            />
          </LabeledList.Item>
        )}

        <LabeledList.Item label="Passive stat">
          <Dropdown
            width="220px"
            selected={nameById(stats, String(draft.passive_stat_key || stats[0]?.id || ''))}
            options={names(stats)}
            onSelected={(name) => patch('passive_stat_key', idByName(stats, String(name)))}
          />
        </LabeledList.Item>

        <LabeledList.Item label="Passive amount">
          <NumberInput
            value={Number(draft.passive_stat_bonus || 0)}
            minValue={0}
            maxValue={10}
            step={1}
            onChange={(value) => patch('passive_stat_bonus', value)}
          />
        </LabeledList.Item>

        <LabeledList.Item label="Magic enchantment">
          <Dropdown
            width="420px"
            selected={nameById(enchantments, selectedEnchant)}
            options={names(enchantments)}
            onSelected={(name) => patch('enchantment_spell_path', idByName(enchantments, String(name)))}
          />
        </LabeledList.Item>

        {!!selectedEnchantEntry?.tier && (
          <LabeledList.Item label="Enchant tier">
            {selectedEnchantEntry.tier}
          </LabeledList.Item>
        )}
      </LabeledList>

      <NoticeBox>
        The contract creates exactly one selected item. Weapon force/defense fields are shown only for weapon classes. Higher-tier magic_item enchantments increase boon power.
      </NoticeBox>
    </Stack>
  );
};

const HoverCard = ({ entry }: { entry: ClauseEntry | null }) => {
  if (!entry) return null;
  return <Box style={{ position: 'fixed', left: '50%', top: '72px', transform: 'translateX(-50%)', width: '680px', maxWidth: 'calc(100vw - 48px)', padding: '10px 12px', borderRadius: '9px', background: 'rgba(10, 12, 22, 0.97)', border: '1px solid rgba(255,255,255,0.1)', boxShadow: '0 8px 20px rgba(0,0,0,0.45)', zIndex: 1000, pointerEvents: 'none' }}><Stack><Stack.Item grow><Box bold style={{ color: '#f0c35a', fontSize: '15px' }}>{entry.name}</Box><Box mt={0.5} style={{ opacity: 0.88 }}>{entry.summary || entry.desc || 'No description.'}</Box></Stack.Item><Stack.Item width="100px" textAlign="right"><Box color="good" bold>{entry.power || 0} power</Box></Stack.Item></Stack></Box>;
};

export default SuccubusContract;
