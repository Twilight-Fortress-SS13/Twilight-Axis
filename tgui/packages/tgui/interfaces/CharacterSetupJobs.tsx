
import { type ReactNode, useEffect, useMemo, useState } from 'react';
import { Box, Button, Icon, Input, Section, Stack, Tooltip } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type JobEntry = {
  id: string;
  name: string;
  female_name?: string;
  current_pref?: 'never' | 'low' | 'medium' | 'high' | 'boost' | string;
  next_pref_level?: number;
  previous_pref_level?: number;
  disabled_reason?: string | null;
  priority_disabled_reason?: string | null;
  assigned_slot?: string;
  separator_before?: boolean;
  tutorial?: string;
  slots?: number;
  round_contrib_points?: number;
  min_pq?: number | null;
  max_pq?: number | null;
  has_details?: boolean;
  tooltip?: string;
  has_subclasses?: boolean;
  subclass_preference?: string | null;
  subclass_strict?: boolean;
};

type JobStateEntry = {
  id: string;
  current_pref?: JobEntry['current_pref'];
  next_pref_level?: number;
  previous_pref_level?: number;
  disabled_reason?: string | null;
  priority_disabled_reason?: string | null;
  assigned_slot?: string;
  subclass_preference?: string | null;
  subclass_strict?: boolean;
};

type JobSlotChoice = {
  id: string;
  label: string;
  current: boolean;
};

type StatRow = {
  name: string;
  value: string;
  positive?: boolean;
};

type TraitRow = {
  name: string;
  description?: string;
};

type JobSubclassDetail = {
  id: string;
  name: string;
  description?: string;
  stat_bonuses?: StatRow[];
  stat_limits?: StatRow[];
  traits?: TraitRow[];
  notable_skills?: string[];
  virtues?: string[];
  stashed_items?: string[];
  languages?: string[];
  mage_aspects?: string[];
  extra_context?: string[];
};

type JobDetail = {
  title: string;
  description?: string;
  class_stats?: StatRow[];
  class_stat_limits?: StatRow[];
  class_traits?: TraitRow[];
  note?: string;
  subclasses?: JobSubclassDetail[];
};

type Data = {
  job_entries?: JobEntry[];
  job_catalog?: JobEntry[];
  job_state?: JobStateEntry[];
  use_female_job_titles?: boolean;
  job_slot_target?: string | null;
  job_slot_choices?: JobSlotChoice[];
  current_joblessrole?: string;
  active_job_detail?: JobDetail | null;
  job_player_quality?: number | null;
};

const cardStyle = {
  border: '1px solid rgba(255,255,255,0.12)',
};

const selectedCardStyle = {
  border: '1px solid rgba(255,255,255,0.32)',
  boxShadow: 'inset 0 0 0 1px rgba(255,255,255,0.08)',
};

const stripSimpleHtml = (value?: string | null) => {
  if (!value) {
    return '';
  }
  return value
    .replace(/<br\s*\/?>(?!$)/gi, '\n')
    .replace(/<\/?span[^>]*>/gi, '')
    .replace(/<[^>]+>/g, '')
    .replace(/&nbsp;/gi, ' ')
    .trim();
};

const modalBackdrop = {
  position: 'absolute' as const,
  inset: '0',
  background: 'rgba(0, 0, 0, 0.82)',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  zIndex: 30,
};

const ModalShell = (props: {
  title: string;
  width?: string;
  onClose: () => void;
  children: ReactNode;
}) => (
  <Box style={modalBackdrop}>
    <Box
      p={0.75}
      style={{
        width: props.width || '760px',
        maxWidth: 'calc(100% - 24px)',
        maxHeight: 'calc(100% - 24px)',
        overflowY: 'auto',
        background: '#120a0a',
        border: '1px solid rgba(255,255,255,0.18)',
        boxShadow: '0 8px 28px rgba(0,0,0,0.65)',
      }}
    >
      <Stack align="center" mb={0.65}>
        <Stack.Item grow>
          <Box bold>{props.title}</Box>
        </Stack.Item>
        <Stack.Item>
          <Button compact icon="times" onClick={props.onClose} />
        </Stack.Item>
      </Stack>
      {props.children}
    </Box>
  </Box>
);

const fillForPref = (pref?: string) => {
  switch (pref) {
    case 'boost':
      return '#73549a';
    case 'high':
      return '#4d8758';
    case 'medium':
      return '#8a713c';
    case 'low':
      return '#7e4848';
    case 'never':
    default:
      return '#4b3a3a';
  }
};

const priorityLabel = (pref?: string) => {
  switch (pref) {
    case 'boost':
      return 'Высокий+';
    case 'high':
      return 'Высокий';
    case 'medium':
      return 'Средний';
    case 'low':
      return 'Низкий';
    case 'never':
    default:
      return 'Выкл.';
  }
};

const normalizeSlotLabel = (label?: string) => {
  if (!label) {
    return 'A';
  }
  if (label === 'Активный слот' || label === 'Active' || label === 'Актив.' || label === '[Active slot]') {
    return 'A';
  }
  const slotMatch = label.match(/(?:Слот|Slot)\s*(\d+)/i);
  if (slotMatch?.[1]) {
    return slotMatch[1];
  }
  return label;
};

const buildJobGroups = (entries: JobEntry[]) => {
  const groups: JobEntry[][] = [];
  let current: JobEntry[] = [];

  entries.forEach((entry) => {
    if (entry.separator_before && current.length) {
      groups.push(current);
      current = [];
    }
    current.push(entry);
  });

  if (current.length) {
    groups.push(current);
  }

  return groups;
};

const JobPriorityControl = (props: {
  entry: JobEntry;
  onIncrease: (level: number) => void;
  onDecrease: (level: number) => void;
}) => {
  const lockedReason = props.entry.disabled_reason || props.entry.priority_disabled_reason;

  return (
    <Button
      compact
      icon={lockedReason ? 'lock' : undefined}
      tooltip={lockedReason
        ? 'Несовместимо из-за неправильной веры, расы или возраста'
        : 'ЛКМ — повысить приоритет, ПКМ — понизить'}
      tooltipPosition="bottom"
      disabled={!!lockedReason || props.entry.next_pref_level === undefined}
      onClick={() => (
        props.entry.next_pref_level !== undefined
        && props.onIncrease(props.entry.next_pref_level)
      )}
      onContextMenu={(event) => {
        event.preventDefault();
        if (!lockedReason && props.entry.previous_pref_level !== undefined) {
          props.onDecrease(props.entry.previous_pref_level);
        }
      }}
      style={{
        width: '68px',
        minWidth: '68px',
        maxWidth: '68px',
        minHeight: '30px',
        height: '30px',
        padding: lockedReason ? '0' : '0 3px',
        fontSize: lockedReason ? '16px' : '13px',
        lineHeight: 1,
        whiteSpace: 'nowrap',
        display: 'inline-flex',
        alignItems: 'center',
        justifyContent: 'center',
        verticalAlign: 'top',
        margin: '0',
        background: lockedReason ? 'rgba(126,72,72,0.48)' : fillForPref(props.entry.current_pref),
        border: '1px solid rgba(255,255,255,0.16)',
      }}
    >
      {lockedReason ? null : priorityLabel(props.entry.current_pref)}
    </Button>
  );
};

const JobCompactButton = (props: {
  icon: string;
  label?: string;
  title?: string;
  selected?: boolean;
  disabled?: boolean;
  width?: string;
  onClick: () => void;
}) => (
  <Button
    compact
    icon={props.icon}
    selected={props.selected}
    disabled={props.disabled}
    tooltip={props.title}
    tooltipPosition="bottom"
    onClick={props.onClick}
    style={{
      width: props.width || '24px',
      minWidth: props.width || '24px',
      maxWidth: props.width || '24px',
      height: '30px',
      minHeight: '30px',
      padding: '0 3px',
      fontSize: '13px',
      lineHeight: 1,
      textAlign: 'center',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      verticalAlign: 'top',
      margin: '0',
    }}
  >
    {props.label}
  </Button>
);

const JobRow = (props: {
  entry: JobEntry;
  selected?: boolean;
  act: (action: string, params?: Record<string, unknown>) => void;
  onOpenDetails: () => void;
  onOpenSlot: () => void;
  playerQuality?: number | null;
}) => {
  const entry = props.entry;
  const description = stripSimpleHtml(entry.tooltip || 'Нет описания.');
  const unavailableReason = entry.disabled_reason || entry.priority_disabled_reason;
  const pqRequirement = [
    entry.min_pq !== null
      && entry.min_pq !== undefined
      && props.playerQuality !== null
      && props.playerQuality !== undefined
      && props.playerQuality < entry.min_pq
      ? `Min PQ: ${entry.min_pq}`
      : null,
    entry.max_pq !== null
      && entry.max_pq !== undefined
      && props.playerQuality !== null
      && props.playerQuality !== undefined
      && props.playerQuality > entry.max_pq
      ? `Max PQ: ${entry.max_pq}`
      : null,
  ].filter(Boolean).join(' • ');
  const subclassTooltip = entry.subclass_preference
    ? `Подкласс: ${entry.subclass_preference}\n${
      entry.subclass_strict
        ? 'Если недоступен — перейти к другой роли'
        : 'Если недоступен — разрешить другой подкласс'
    }`
    : 'Выбрать предпочитаемый подкласс';

  return (
    <Box
      px={0.35}
      py={0.2}
      style={{
        display: 'grid',
        gridTemplateColumns: 'minmax(0, 150px) 68px 40px 30px',
        gap: '2px',
        alignItems: 'center',
        justifyContent: 'start',
        minWidth: 0,
        minHeight: pqRequirement ? '48px' : '38px',
        border: props.selected
          ? '1px solid rgba(255,255,255,0.34)'
          : '1px solid rgba(255,255,255,0.12)',
        boxShadow: props.selected ? 'inset 0 0 0 1px rgba(255,255,255,0.08)' : undefined,
        background: props.selected ? 'rgba(255,255,255,0.06)' : 'rgba(255,255,255,0.02)',
      }}
    >
      <Tooltip
        content={(
          <Box style={{ whiteSpace: 'pre-wrap', maxWidth: '380px', lineHeight: 1.2 }}>
            <Box bold mb={0.25}>{entry.name}</Box>
            {unavailableReason ? (
              <Box color="bad" mb={0.3}>{unavailableReason}</Box>
            ) : null}
            {description}
          </Box>
        )}
        position="bottom-start"
      >
        <Box
          onClick={entry.has_details ? props.onOpenDetails : undefined}
          style={{
            minWidth: 0,
            paddingRight: '0px',
            fontSize: '15px',
            fontWeight: 700,
            lineHeight: 1.1,
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            whiteSpace: 'nowrap',
            cursor: entry.has_details ? 'pointer' : 'default',
          }}
        >
          <Box>{entry.name}</Box>
          {pqRequirement ? (
            <Box color="average" style={{ fontSize: '12px', fontWeight: 500, lineHeight: 1.1 }}>
              {pqRequirement}
            </Box>
          ) : null}
        </Box>
      </Tooltip>

      <JobPriorityControl
        entry={entry}
        onIncrease={(level) => props.act('link', { preference: 'job', task: 'setJobLevel', text: entry.id, level })}
        onDecrease={(level) => props.act('link', { preference: 'job', task: 'setJobLevel', text: entry.id, level })}
      />
      <JobCompactButton
        icon="user"
        label={normalizeSlotLabel(entry.assigned_slot)}
        title={`Персонаж для роли: ${entry.assigned_slot || 'Активный слот'}`}
        disabled={!!entry.disabled_reason}
        width="40px"
        onClick={props.onOpenSlot}
      />
      <JobCompactButton
        icon="star"
        title={subclassTooltip}
        selected={!!entry.subclass_preference}
        disabled={!!entry.disabled_reason || !entry.has_subclasses}
        onClick={() => props.act('link', { preference: 'job', task: 'set_job_subclass', text: entry.id })}
      />
    </Box>
  );
};

const JobSlotModal = (props: {
  jobTitle?: string | null;
  choices: JobSlotChoice[];
  onSelect: (slot: string) => void;
  onClose: () => void;
}) => (
  <ModalShell title={`Персонаж для роли: ${props.jobTitle || 'Роль'}`} width="680px" onClose={props.onClose}>
    {props.choices.map((choice) => (
      <Box key={choice.id} mb={0.5} p={0.75} style={choice.current ? selectedCardStyle : cardStyle}>
        <Stack align="center">
          <Stack.Item grow>
            <Box bold>{choice.label}</Box>
          </Stack.Item>
          <Stack.Item>
            <Button onClick={() => props.onSelect(choice.id)}>
              {choice.current ? 'Используется сейчас' : choice.id === 'default' ? 'Сделать активным слотом' : 'Выбрать'}
            </Button>
          </Stack.Item>
        </Stack>
      </Box>
    ))}
  </ModalShell>
);

const SectionTitle = (props: { children: ReactNode }) => (
  <Box mt={0.75} mb={0.35} bold color="label">
    {props.children}
  </Box>
);

const StatList = (props: { rows?: StatRow[] }) => {
  if (!props.rows?.length) {
    return null;
  }
  return (
    <Box>
      {props.rows.map((row) => (
        <Box key={`${row.name}-${row.value}`} style={{ lineHeight: 1.15 }}>
          {row.name}: <Box inline bold color={row.positive === false ? 'bad' : row.positive ? 'good' : undefined}>{row.value}</Box>
        </Box>
      ))}
    </Box>
  );
};

const TraitList = (props: { rows?: TraitRow[] }) => {
  if (!props.rows?.length) {
    return null;
  }
  return (
    <Box>
      {props.rows.map((row) => (
        <Box key={row.name} mb={0.3} p={0.4} style={cardStyle}>
          <Box bold>{row.name}</Box>
          {row.description ? <Box mt={0.2} color="label" style={{ whiteSpace: 'pre-wrap', lineHeight: 1.15 }}>{stripSimpleHtml(row.description)}</Box> : null}
        </Box>
      ))}
    </Box>
  );
};

const StringList = (props: { items?: string[] }) => {
  if (!props.items?.length) {
    return null;
  }
  return (
    <Box>
      {props.items.map((item, index) => (
        <Box key={`${item}-${index}`} style={{ lineHeight: 1.15 }}>
          • {stripSimpleHtml(item)}
        </Box>
      ))}
    </Box>
  );
};

const JobDetailsPanel = (props: {
  detail: JobDetail;
  onClose: () => void;
}) => {
  const [expanded, setExpanded] = useState<Record<string, boolean>>({});

  useEffect(() => {
    setExpanded({});
  }, [props.detail.title]);

  const toggle = (id: string) => setExpanded((old) => ({ ...old, [id]: !old[id] }));

  return (
    <Section
      fill
      scrollable
      title={props.detail.title || 'Информация о роли'}
      buttons={<Button compact icon="times" tooltip="Закрыть подробности" onClick={props.onClose} />}
    >
      {props.detail.description ? (
        <Box mb={0.5} color="label" style={{ whiteSpace: 'pre-wrap', lineHeight: 1.2 }}>
          {stripSimpleHtml(props.detail.description)}
        </Box>
      ) : null}

      {props.detail.class_stats?.length ? (
        <>
          <SectionTitle>Статы</SectionTitle>
          <StatList rows={props.detail.class_stats} />
        </>
      ) : null}
      {props.detail.class_stat_limits?.length ? (
        <>
          <SectionTitle>Пределы статов</SectionTitle>
          <StatList rows={props.detail.class_stat_limits} />
        </>
      ) : null}
      {props.detail.class_traits?.length ? (
        <>
          <SectionTitle>Черты класса</SectionTitle>
          <TraitList rows={props.detail.class_traits} />
        </>
      ) : null}

      {props.detail.subclasses?.length ? (
        <>
          <SectionTitle>Подклассы</SectionTitle>
          {props.detail.subclasses.map((subclass) => {
            const isOpen = !!expanded[subclass.id];
            return (
              <Box key={subclass.id} mb={0.45} style={cardStyle}>
                <Button
                  fluid
                  textAlign="left"
                  icon={isOpen ? 'chevron-down' : 'chevron-right'}
                  onClick={() => toggle(subclass.id)}
                  style={{ minHeight: '30px' }}
                >
                  {subclass.name}
                </Button>
                {isOpen ? (
                  <Box p={0.55}>
                    {subclass.description ? (
                      <Box mb={0.45} color="label" style={{ whiteSpace: 'pre-wrap', lineHeight: 1.2 }}>
                        {stripSimpleHtml(subclass.description)}
                      </Box>
                    ) : null}
                    {subclass.stat_bonuses?.length ? (
                      <>
                        <SectionTitle>Бонусы статов</SectionTitle>
                        <StatList rows={subclass.stat_bonuses} />
                      </>
                    ) : null}
                    {subclass.stat_limits?.length ? (
                      <>
                        <SectionTitle>Пределы статов</SectionTitle>
                        <StatList rows={subclass.stat_limits} />
                      </>
                    ) : null}
                    {subclass.traits?.length ? (
                      <>
                        <SectionTitle>Черты</SectionTitle>
                        <TraitList rows={subclass.traits} />
                      </>
                    ) : null}
                    {subclass.notable_skills?.length ? (
                      <>
                        <SectionTitle>Заметные навыки</SectionTitle>
                        <StringList items={subclass.notable_skills} />
                      </>
                    ) : null}
                    {subclass.virtues?.length ? (
                      <>
                        <SectionTitle>Добродетели</SectionTitle>
                        <StringList items={subclass.virtues} />
                      </>
                    ) : null}
                    {subclass.stashed_items?.length ? (
                      <>
                        <SectionTitle>Тайники</SectionTitle>
                        <StringList items={subclass.stashed_items} />
                      </>
                    ) : null}
                    {subclass.languages?.length ? (
                      <>
                        <SectionTitle>Языки</SectionTitle>
                        <StringList items={subclass.languages} />
                      </>
                    ) : null}
                    {subclass.mage_aspects?.length ? (
                      <>
                        <SectionTitle>Аспекты магии</SectionTitle>
                        <StringList items={subclass.mage_aspects} />
                      </>
                    ) : null}
                    {subclass.extra_context?.length ? (
                      <>
                        <SectionTitle>Дополнительно</SectionTitle>
                        <StringList items={subclass.extra_context} />
                      </>
                    ) : null}
                  </Box>
                ) : null}
              </Box>
            );
          })}
        </>
      ) : null}

      {props.detail.note ? (
        <Box mt={0.75} color="label" style={{ whiteSpace: 'pre-wrap', lineHeight: 1.15 }}>
          {props.detail.note}
        </Box>
      ) : null}
    </Section>
  );
};

export const CharacterSetupJobsContent = () => {
  const { act, data } = useBackend<Data>();
  const [slotOpen, setSlotOpen] = useState(false);
  const [search, setSearch] = useState('');
  const [selectedJobId, setSelectedJobId] = useState<string | null>(null);
  const entries = useMemo(() => {
    const catalog = data.job_catalog?.length ? data.job_catalog : data.job_entries || [];
    const stateById = new Map((data.job_state || []).map((entry) => [entry.id, entry]));
    return catalog.map((catalogEntry) => {
      const stateEntry = stateById.get(catalogEntry.id);
      return {
        ...catalogEntry,
        ...stateEntry,
        name: data.use_female_job_titles
          ? catalogEntry.female_name || catalogEntry.name
          : catalogEntry.name,
      };
    });
  }, [
    data.job_catalog,
    data.job_entries,
    data.job_state,
    data.use_female_job_titles,
  ]);
  const query = search.trim().toLowerCase();
  const groups = useMemo(() => {
    return buildJobGroups(entries)
      .map((group) => group.filter((entry) => {
        if (!query) {
          return true;
        }
        const searchable = [
          entry.name,
          entry.id,
          entry.tooltip,
          entry.assigned_slot,
          entry.subclass_preference,
          entry.disabled_reason,
          entry.priority_disabled_reason,
        ]
          .filter(Boolean)
          .join(' ')
          .toLowerCase();
        return searchable.includes(query);
      }))
      .filter((group) => group.length);
  }, [entries, query]);

  const closeDetails = () => {
    setSelectedJobId(null);
    act('close_job_details');
  };

  return (
    <Box style={{ position: 'relative', height: '100%', fontSize: '15px' }}>
      {slotOpen ? (
        <JobSlotModal
          jobTitle={data.job_slot_target}
          choices={data.job_slot_choices || []}
          onSelect={(slot) => {
            act('assign_job_slot', { slot });
            setSlotOpen(false);
          }}
          onClose={() => setSlotOpen(false)}
        />
      ) : null}

      <Stack vertical fill>
        <Stack.Item>
          <Box
            mb={0.5}
            style={{
              display: 'grid',
              gridTemplateColumns: '1fr minmax(260px, 360px) 1fr',
              alignItems: 'center',
              gap: '6px',
            }}
          >
            <Box />
            <Box>
              <Input
                fluid
                placeholder="Поиск класса..."
                value={search}
                onChange={setSearch}
              />
            </Box>
            <Box
              style={{
                display: 'grid',
                gridAutoFlow: 'column',
                gridAutoColumns: 'max-content',
                alignItems: 'stretch',
                justifyContent: 'end',
                gap: '5px',
                minWidth: 0,
                height: '24px',
              }}
            >
              <Button
                compact
                onClick={() => act('link', { preference: 'job', task: 'nojob' })}
                style={{
                  height: '24px',
                  minHeight: '24px',
                  maxHeight: '24px',
                  margin: '0',
                  padding: '0 8px',
                  lineHeight: 1,
                  verticalAlign: 'top',
                }}
              >
                <Box
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    height: '22px',
                    lineHeight: 1,
                  }}
                >
                  Если роль недоступна: {data.current_joblessrole || 'Return to Lobby'}
                </Box>
              </Button>
              <Button
                compact
                tooltip="ЛКМ по приоритету повышает его, ПКМ понижает. Кнопка с человеком выбирает персонажа для роли, звезда — предпочитаемый подкласс. Нажмите на название класса, чтобы открыть подробности."
                tooltipPosition="bottom"
                style={{
                  width: '24px',
                  minWidth: '24px',
                  maxWidth: '24px',
                  height: '24px',
                  minHeight: '24px',
                  maxHeight: '24px',
                  margin: '0',
                  padding: '0',
                  lineHeight: 1,
                  verticalAlign: 'top',
                }}
              >
                <Box
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    height: '22px',
                    lineHeight: 1,
                  }}
                >
                  <Icon name="question-circle" />
                </Box>
              </Button>
              <Button
                compact
                onClick={() => act('link', { preference: 'job', task: 'reset' })}
                style={{
                  height: '24px',
                  minHeight: '24px',
                  maxHeight: '24px',
                  margin: '0',
                  padding: '0 8px',
                  lineHeight: 1,
                  verticalAlign: 'top',
                }}
              >
                <Box
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    gap: '4px',
                    height: '22px',
                    lineHeight: 1,
                  }}
                >
                  <Icon name="undo" />
                  <span>Сброс</span>
                </Box>
              </Button>
            </Box>
          </Box>
        </Stack.Item>
        <Stack.Item grow>
          <Stack fill>
            <Stack.Item grow>
              <Section fill scrollable>
                {groups.length ? groups.map((group, groupIndex) => (
                  <Box
                    key={`${group[0].id}-${groupIndex}`}
                    pt={groupIndex ? 0.85 : 0}
                    mt={groupIndex ? 0.85 : 0}
                    style={groupIndex ? { borderTop: '2px solid rgba(255,255,255,0.38)' } : undefined}
                  >
                    <Box
                      style={{
                        display: 'flex',
                        flexWrap: 'wrap',
                        gap: '4px',
                        alignItems: 'flex-start',
                      }}
                    >
                      {group.map((entry) => (
                        <JobRow
                          key={entry.id}
                          entry={entry}
                          selected={selectedJobId === entry.id}
                          act={act}
                          onOpenDetails={() => {
                            setSelectedJobId(entry.id);
                            act('open_job_details', { job: entry.id });
                          }}
                          onOpenSlot={() => {
                            act('open_job_slot', { job: entry.id });
                            setSlotOpen(true);
                          }}
                          playerQuality={data.job_player_quality}
                        />
                      ))}
                    </Box>
                  </Box>
                )) : (
                  <Box color="label" textAlign="center" mt={2}>
                    Классы по запросу не найдены.
                  </Box>
                )}
              </Section>
            </Stack.Item>
            {data.active_job_detail ? (
              <Stack.Item basis="370px" shrink={0}>
                <JobDetailsPanel detail={data.active_job_detail} onClose={closeDetails} />
              </Stack.Item>
            ) : null}
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const CharacterSetupJobs = () => (
  <Window title="Выбор класса" width={1280} height={600}>
    <Window.Content scrollable={false} onMouseDown={(event) => event.stopPropagation()}>
      <CharacterSetupJobsContent />
    </Window.Content>
  </Window>
);
