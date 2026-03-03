import { useEffect, useMemo, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Input, Modal, Section, Stack } from 'tgui-core/components';

export type PartnerEntry = {
  ref: string;
  name: string;
};

type KinkEntry = {
  type: string;
  name: string;
  description?: string;
  category?: string;
  intensity?: number;
  pref: number; // -1..1
  partner_pref?: number | null;
  partner_pref_known?: boolean;
};

type ActionFilterEntry = {
  type: string;
  name?: string;
  count?: number;
  free?: number;
  total?: number;
};

type UiActionEntry = {
  id: string;
  name: string;
  can: boolean;
  reason?: string | null;
  tags?: string[] | null;
  is_custom?: boolean;
};

type UiActiveLinkEntry = {
  id: string;
  name?: string;

  actor_org?: string | null;
  target_org?: string | null;

  speed?: number;
  force?: number;

  finish_mode?: 'until_stop' | 'until_climax' | string;
};

type ActionsTabPayload = {
  actor_nodes?: ActionFilterEntry[];
  partner_nodes?: ActionFilterEntry[];

  selected_actor_node?: string | null;
  selected_partner_node?: string | null;

  actions?: UiActionEntry[];
  active_links?: UiActiveLinkEntry[];
  base_speed?: number;
  base_force?: number;
  show_knot_toggle?: boolean;
  show_penis_panel?: boolean;
  do_knot_action?: boolean;
  has_knotted_penis?: boolean;
  can_knot_now?: boolean;

  climax_mode?: 'outside' | 'inside' | string | null;
  climax_modes?: { id: string; name: string }[];
};

type LiquidBlock = {
  has?: boolean;
  volume?: number;
};

type StatusLinkRow = {
  id: string;
  mode: 'passive' | 'active';
  action_name?: string;
  other_organ?: string | null;
};

type StatusToggles = {
  has_overflow?: boolean;
  overflow?: boolean;

  has_erect?: boolean;
  erect_mode?: 'auto' | 'none' | 'partial' | 'hard' | null;
};

type StatusEntry = {
  id: string;
  type?: string;
  name?: string;

  sensitivity?: number;
  pain?: number;

  busy?: boolean;

  storage?: LiquidBlock;
  producing?: LiquidBlock;

  links?: StatusLinkRow[];
  toggles?: StatusToggles;
};

type EditorOption = { value: any; name: string };
type EditorFieldType = 'text' | 'multiline' | 'number' | 'bool' | 'enum' | 'string_list';

type EditorField = {
  id: string;
  label: string;
  type: EditorFieldType;
  section?: string;
  desc?: string;
  min?: number;
  max?: number;
  step?: number;
  options?: EditorOption[];
  placeholder?: string;
  max_len?: number;
  value?: any;
};

type EditorTemplateEntry = {
  type: string;
  name: string;
  // fields здесь больше не обязательны и UI их не читает
  fields?: EditorField[] | any;
};

type EditorCustomAction = {
  id: string;
  name: string;
  // fields здесь больше не обязательны и UI их не читает
  fields?: EditorField[] | any;
};

// ВАЖНО: выбранное действие, которое backend возвращает полностью
type EditorSelectedPayload = {
  mode: 'template' | 'custom';
  key: string; // template.type или custom.id
  name?: string;
  fields?: EditorField[] | any;
};

export type SexSessionData = {
  actor_name: string;
  partners?: PartnerEntry[];
  current_partner_ref?: string | null;
  actor_arousal?: number;
  partner_arousal?: number | null;
  partner_arousal_hidden?: boolean;
  frozen?: boolean;
  yield_to_partner?: boolean;
  allow_user_moan?: boolean;
  hidden_mode?: boolean;
  active_tab?: string;

  tabs?: {
    actions?: ActionsTabPayload;
    kinks?: { entries?: KinkEntry[] };
    status?: { entries?: StatusEntry[]; arousal?: number; arousal_data?: ArousalPayload | null };
    editor?: {
      templates?: EditorTemplateEntry[];
      custom_actions?: EditorCustomAction[];
      selected?: EditorSelectedPayload | null;
    };
  };
};

const BaseTuningPanel: React.FC<{
  baseSpeed: number;
  baseForce: number;
  onSetSpeed: (v: number) => void;
  onSetForce: (v: number) => void;
}> = ({ baseSpeed, baseForce, onSetSpeed, onSetForce }) => {
  const clamp14 = (v: any) => {
    const n = Number(v);
    if (!Number.isFinite(n)) return 2;
    return Math.max(1, Math.min(4, Math.round(n)));
  };

  const sp = clamp14(baseSpeed);
  const fo = clamp14(baseForce);
  const spIdx = sp - 1;
  const foIdx = fo - 1;

  return (
    <Section title="Базовые настройки новых действий" style={{ paddingTop: 6, paddingBottom: 6 }}>
      <Stack align="center" justify="space-between">
        {/* LEFT SIDE: label -> control */}
        <Stack.Item grow>
          <Stack align="center">
            <Stack.Item>
              <Box
                color="label"
                style={{ fontSize: 10, textTransform: 'uppercase', whiteSpace: 'nowrap' }}
              >
                Скорость
              </Box>
            </Stack.Item>

            <Stack.Item ml={1}>
              <Stack align="center">
                <Stack.Item>
                  <Button
                    inline
                    compact
                    onClick={() => onSetSpeed(sp - 1)}
                    style={{ padding: '1px 6px' }}
                  >
                    {'<'}
                  </Button>
                </Stack.Item>

                <Stack.Item>
                  <Box
                    as="span"
                    bold
                    style={{
                      color: speedColors?.[spIdx],
                      display: 'inline-block',
                      minWidth: 92,
                      textAlign: 'center',
                      fontSize: 11,
                      whiteSpace: 'nowrap',
                    }}
                  >
                    {speedNames[spIdx]}
                  </Box>
                </Stack.Item>

                <Stack.Item>
                  <Button
                    inline
                    compact
                    onClick={() => onSetSpeed(sp + 1)}
                    style={{ padding: '1px 6px' }}
                  >
                    {'>'}
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>

        {/* RIGHT SIDE: control -> label */}
        <Stack.Item>
          <Stack align="center" justify="end">
            <Stack.Item>
              <Stack align="center">
                <Stack.Item>
                  <Button
                    inline
                    compact
                    onClick={() => onSetForce(fo - 1)}
                    style={{ padding: '1px 6px' }}
                  >
                    {'<'}
                  </Button>
                </Stack.Item>

                <Stack.Item>
                  <Box
                    as="span"
                    bold
                    style={{
                      color: forceColors?.[foIdx],
                      display: 'inline-block',
                      minWidth: 82,
                      textAlign: 'center',
                      fontSize: 11,
                      whiteSpace: 'nowrap',
                    }}
                  >
                    {forceNames[foIdx]}
                  </Box>
                </Stack.Item>

                <Stack.Item>
                  <Button
                    inline
                    compact
                    onClick={() => onSetForce(fo + 1)}
                    style={{ padding: '1px 6px' }}
                  >
                    {'>'}
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>

            <Stack.Item ml={1}>
              <Box
                color="label"
                style={{ fontSize: 10, textTransform: 'uppercase', whiteSpace: 'nowrap' }}
              >
                Сила
              </Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const clamp01 = (v: number) => Math.max(0, Math.min(100, v || 0));
const safeString = (v: any) => (v === undefined || v === null ? '' : String(v));

const Pill: React.FC<{
  selected?: boolean;
  disabled?: boolean;
  onClick?: () => void;
  children?: React.ReactNode;
  tooltip?: string;
}> = ({ selected, disabled, onClick, children, tooltip }) => (
  <Button
    inline
    compact
    disabled={disabled}
    color="transparent"
    selected={!!selected}
    onClick={onClick}
    tooltip={tooltip}
    style={{
      borderRadius: 9999,
      padding: '1px 8px',
      margin: 1,
      background: selected ? 'var(--button-background-selected)' : 'rgba(255,255,255,0.05)',
      border: selected ? '1px solid var(--button-border-color)' : '1px solid rgba(255,255,255,0.14)',
      boxShadow: selected ? '0 0 5px var(--button-background-selected)' : 'none',
      whiteSpace: 'nowrap',
      lineHeight: 1.1,
    }}
  >
    {children}
  </Button>
);

const BarRow: React.FC<{
  label: string;
  valuePercent: number;
  clickable?: boolean;
  onClick?: () => void;
}> = ({ label, valuePercent, clickable, onClick }) => {
  const clamped = clamp01(valuePercent);
  const pct = Math.round(clamped);

  const bar = (
    <Box
      style={{
        position: 'relative',
        height: 20,
        width: '100%',
        border: '1px solid rgba(255,255,255,0.28)',
        borderRadius: 6,
        overflow: 'hidden',
        background: 'rgba(0, 0, 0, 0.60)',
      }}
    >
      <Box
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          height: '100%',
          width: `${clamped}%`,
          background: 'var(--color-border)',
          opacity: 0.95,
          transition: 'width 0.15s linear',
          pointerEvents: 'none',
        }}
      />
      <Box
        style={{
          position: 'relative',
          zIndex: 1,
          height: '100%',
          width: '100%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          padding: '0 6px',
          fontSize: 10,
          color: '#ffffff',
          textShadow: '0 0 3px #000',
        }}
      >
        <span>{label}</span>
        <span>{pct}%</span>
      </Box>
    </Box>
  );

  if (clickable && onClick) {
    return (
      <Button inline color="transparent" onClick={onClick} style={{ width: '100%', padding: 0 }}>
        {bar}
      </Button>
    );
  }

  return bar;
};

const PartnerNameTop: React.FC<{
  partners: PartnerEntry[];
  currentRef?: string | null;
  onChange: (ref: string) => void;
}> = ({ partners, currentRef, onChange }) => {
  const [open, setOpen] = useState(false);
  const current = useMemo(
    () => partners.find((p) => p.ref === currentRef) || partners[0] || null,
    [partners, currentRef]
  );

  if (!partners.length) {
    return (
      <Box textAlign="center" color="label" style={{ padding: 0, margin: 0 }}>
        —
      </Box>
    );
  }

  return (
    <Box style={{ padding: 0, margin: 0 }}>
      <Box textAlign="center">
        <Button
          inline
          compact
          selected={open}
          onClick={() => setOpen((p) => !p)}
          style={{ padding: '1px 8px', lineHeight: 1.1 }}
        >
          {current?.name || '—'}
        </Button>
      </Box>
      {open && partners.length > 1 && (
        <Box mt={0.25}>
          <Stack justify="center" wrap>
            {partners.map((p) => (
              <Stack.Item key={p.ref} style={{ margin: 0 }}>
                <Button
                  inline
                  compact
                  selected={p.ref === current?.ref}
                  onClick={() => {
                    onChange(p.ref);
                    setOpen(false);
                  }}
                  style={{ padding: '1px 8px', margin: 1, lineHeight: 1.1 }}
                >
                  {p.name}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Box>
      )}
    </Box>
  );
};

const ControlRow: React.FC<{ act: (verb: string, args?: any) => void }> = ({ act }) => {
  return (
    <Box style={{ padding: 0, marginTop: 2 }}>
      <Stack justify="center" wrap>
        <Stack.Item style={{ margin: 1 }}>
          <Button
            compact
            onClick={() => act('change_direction')}
            style={{ padding: '2px 8px' }}
          >
            ПЕРЕВЕРНУТЬСЯ
          </Button>
        </Stack.Item>
        <Stack.Item style={{ margin: 1 }}>
          <Button
            compact
            color="bad"
            onClick={() => act('full_stop')}
            style={{ padding: '2px 8px' }}
          >
            ОСТАНОВИТЬСЯ
          </Button>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const TabsRow: React.FC<{ active: string; onSet: (tab: string) => void }> = ({ active, onSet }) => {
  const tabs = [
    { id: 'actions', name: 'ДЕЙСТВИЯ' },
    { id: 'status', name: 'СТАТУС' },
    { id: 'kinks', name: 'ФЕТИШИ' },
    { id: 'editor', name: 'РЕДАКТОР' },
  ];
  return (
    <Box style={{ padding: 0, marginTop: 2 }}>
      <Stack justify="center" wrap>
        {tabs.map((t) => (
          <Stack.Item key={t.id} style={{ margin: 1 }}>
            <Button compact selected={active === t.id} onClick={() => onSet(t.id)} style={{ padding: '2px 8px' }}>
              {t.name}
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </Box>
  );
};

type ArousalPayload = {
  arousal?: number;
  frozen?: boolean;
  last_increase?: number;
  arousal_multiplier?: number;
  is_spent?: boolean;
  charge?: number;
  charge_max?: number;
  charge_for_climax?: number;
  charge_pct?: number;
  charge_need_pct?: number;
  sp?: number;
  sp_max?: number;
  sp_buff_tier?: number;
  sp_tier_text?: string;
  overload_points?: number;
  overload_max?: number;
  nympho_hunger?: number;
};

const NodeButton: React.FC<{
  entry: ActionFilterEntry;
  selected?: boolean;
  onClick: () => void;
}> = ({ entry, selected, onClick }) => {
  const name = entry.name || entry.type;
  const free = Number.isFinite(entry.free as any) ? Number(entry.free) : undefined;
  const total = Number.isFinite(entry.total as any) ? Number(entry.total) : undefined;
  const count = Number.isFinite(entry.count as any) ? Number(entry.count) : undefined;
  const isBusy = total !== undefined && free !== undefined ? free <= 0 : count !== undefined ? count <= 0 : false;
  const badge =
    total !== undefined && free !== undefined
      ? `${Math.max(0, free)}/${Math.max(0, total)}`
      : count !== undefined
        ? `${count}`
        : '';
  return (
    <Button
      fluid
      compact
      selected={!!selected}
      disabled={isBusy}
      onClick={onClick}
      tooltip={badge ? `${name} (${badge})` : name}
      style={{
        padding: '4px 6px',
        textAlign: 'center',
        justifyContent: 'center',
        whiteSpace: 'normal',
        wordBreak: 'break-word',
        border: selected ? '1px solid var(--button-border-color)' : '1px solid rgba(255,255,255,0.14)',
        background: selected ? 'var(--button-background-selected)' : 'rgba(255,255,255,0.04)',
      }}
    >
      <Box>
        {name}
        {!!badge && (
          <Box as="span" ml={0.5} color="label" style={{ fontSize: 10 }}>
            {badge}
          </Box>
        )}
        {isBusy ? (
          <Box as="span" ml={0.5} color="bad" style={{ fontSize: 10 }}>
            ●
          </Box>
        ) : null}
      </Box>
    </Button>
  );
};

const NodeList: React.FC<{
  title: string;
  nodes: ActionFilterEntry[];
  selectedId?: string | null;
  onSelect: (id: string) => void;
}> = ({ title, nodes, selectedId, onSelect }) => (
  <Section title={title} fill>
    <Stack vertical>
      {nodes.length ? (
        nodes.map((n) => (
          <Stack.Item key={n.type}>
            <NodeButton entry={n} selected={selectedId === n.type} onClick={() => onSelect(n.type)} />
          </Stack.Item>
        ))
      ) : (
        <Box color="label" textAlign="center">
          —
        </Box>
      )}
    </Stack>
  </Section>
);

const ActionsListOldLike: React.FC<{
  actorSelected?: string | null;
  partnerSelected?: string | null;
  actions: UiActionEntry[];
  onClickAction: (id: string) => void;
}> = ({ actorSelected, partnerSelected, actions, onClickAction }) => {
  const [singleColumn, setSingleColumn] = useState(false);
  useEffect(() => {
    const handleResize = () => {
      if (typeof window === 'undefined') return;
      setSingleColumn(window.innerWidth < 500);
    };
    handleResize();
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);
  const leftColumn = actions.filter((_, i) => i % 2 === 0);
  const rightColumn = actions.filter((_, i) => i % 2 === 1);
  const renderBtn = (a: UiActionEntry) => {
    const isAvailable = !!a.can;
    const reason = safeString(a.reason || '');
    return (
      <Button
        key={a.id}
        fluid
        compact
        color="transparent"
        disabled={!isAvailable}
        onClick={() => onClickAction(a.id)}
        tooltip={!isAvailable && reason ? reason : undefined}
        style={{
          padding: '4px 6px',
          justifyContent: 'center',
          textAlign: 'center',
          whiteSpace: 'normal',
          wordBreak: 'break-word',
          lineHeight: 1.25,
          border: 'none',
          borderRadius: 4,
          background: isAvailable ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.28)',
          boxShadow: 'none',
          color: isAvailable ? 'var(--color-text)' : 'var(--color-label)',
        }}
      >
        {a.name}
      </Button>
    );
  };
  return (
    <Section title="Действия" fill scrollable>
      {!actions.length ? (
        <Box color="label" textAlign="center" style={{ padding: 6 }}>
          Нет доступных действий.
        </Box>
      ) : singleColumn ? (
        <Stack vertical>
          {actions.map((a) => (
            <Stack.Item key={a.id}>{renderBtn(a)}</Stack.Item>
          ))}
        </Stack>
      ) : (
        <Stack>
          <Stack.Item basis="50%" style={{ paddingRight: 2 }}>
            <Stack vertical>
              {leftColumn.map((a) => (
                <Stack.Item key={a.id}>{renderBtn(a)}</Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
          <Stack.Item basis="50%" style={{ paddingLeft: 2 }}>
            <Stack vertical>
              {rightColumn.map((a) => (
                <Stack.Item key={a.id}>{renderBtn(a)}</Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
        </Stack>
      )}
    </Section>
  );
};

const speedNames = ['Медленно', 'Средне', 'Быстро', 'Неистово'];
const forceNames = ['Нежно', 'Уверенно', 'Сильно', 'Жестко'];
const speedColors = ['#a798a2ff', '#e67ec0ff', '#f05ee1', '#f54689ff'];
const forceColors = ['#a798a2ff', '#e67ec0ff', '#f05ee1', '#f54689ff'];

const ActiveLinksPanel: React.FC<{
  links: UiActiveLinkEntry[];
  onSetSpeed: (linkId: string, value: number) => void;
  onSetForce: (linkId: string, value: number) => void;
  onToggleFinish: (linkId: string, nextToClimax: boolean) => void;
  onStop: (linkId: string) => void;
}> = ({ links, onSetSpeed, onSetForce, onToggleFinish, onStop }) => {
  if (!links.length) return null;

  const clamp14 = (v: any) => {
    const n = Number(v);
    if (!Number.isFinite(n)) return 1;
    return Math.max(1, Math.min(4, Math.round(n)));
  };

  return (
    <Section title="Активные связки">
      <Stack vertical>
        {links.map((l) => {
          const sp = clamp14(l.speed);
          const fo = clamp14(l.force);
          const spIdx = sp - 1;
          const foIdx = fo - 1;

          const finishMode = String(l.finish_mode || 'until_stop');
          const doUntilClimax = finishMode === 'until_climax';

          const initOrg = l.actor_org || '—';
          const tgtOrg = l.target_org || '—';

          return (
            <Box
              key={l.id}
              style={{
                border: '1px solid rgba(255,255,255,0.12)',
                borderRadius: 6,
                padding: 6,
                background: 'rgba(0,0,0,0.25)',
                marginBottom: 6,
              }}
            >
              {/* TOP ROW: speed | name (stop) | force */}
              <Stack align="center" justify="space-between">
                {/* SPEED */}
                <Stack.Item basis="34%" style={{ textAlign: 'left' }}>
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        inline
                        compact
                        onClick={() => onSetSpeed(l.id, sp - 1)}
                        style={{ padding: '1px 6px' }}
                      >
                        {'<'}
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Box
                        as="span"
                        bold
                        style={{
                          color: speedColors[spIdx],
                          display: 'inline-block',
                          minWidth: 92,
                          textAlign: 'center',
                          fontSize: 11,
                        }}
                      >
                        {speedNames[spIdx]}
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        inline
                        compact
                        onClick={() => onSetSpeed(l.id, sp + 1)}
                        style={{ padding: '1px 6px' }}
                      >
                        {'>'}
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                {/* NAME (click = stop) */}
                <Stack.Item grow>
                  <Box textAlign="center">
                    <Button
                      inline
                      compact
                      color="transparent"
                      selected
                      onClick={() => onStop(l.id)}
                      tooltip="Остановить связку"
                      style={{ padding: '1px 10px', lineHeight: 1.1 }}
                    >
                      {l.name || 'ДЕЙСТВИЕ'}
                    </Button>
                  </Box>
                </Stack.Item>

                <Stack.Item basis="34%" style={{ textAlign: 'right' }}>
                  <Stack align="center" justify="end">
                    <Stack.Item>
                      <Button
                        inline
                        compact
                        onClick={() => onSetForce(l.id, fo - 1)}
                        style={{ padding: '1px 6px' }}
                      >
                        {'<'}
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Box
                        as="span"
                        bold
                        style={{
                          color: forceColors[foIdx],
                          display: 'inline-block',
                          minWidth: 82,
                          textAlign: 'center',
                          fontSize: 11,
                        }}
                      >
                        {forceNames[foIdx]}
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        inline
                        compact
                        onClick={() => onSetForce(l.id, fo + 1)}
                        style={{ padding: '1px 6px' }}
                      >
                        {'>'}
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>

              {/* BOTTOM ROW: init organ | finish status | target organ */}
              <Box mt={0.5}>
                <Stack align="center" justify="space-between">
                  <Stack.Item basis="34%">
                    <Box bold style={{ fontSize: 11 }}>
                      {initOrg}
                    </Box>
                  </Stack.Item>

                  <Stack.Item grow>
                    <Box textAlign="center">
                      <Pill
                        onClick={() => onToggleFinish(l.id, !doUntilClimax)}
                        tooltip="Переключить режим завершения"
                      >
                        {doUntilClimax ? 'ДО КЛИМАКСА' : 'ПОКА НЕ ОСТАНОВЛЮСЬ'}
                      </Pill>
                    </Box>
                  </Stack.Item>

                  <Stack.Item basis="34%" style={{ textAlign: 'right' }}>
                    <Box bold style={{ fontSize: 11 }}>
                      {tgtOrg}
                    </Box>
                  </Stack.Item>
                </Stack>
              </Box>
            </Box>
          );
        })}
      </Stack>
    </Section>
  );
};

const isPenisNodeId = (id?: string | null) => {
  const s = String(id || '').toLowerCase();
  if (!s) return false;
  return (
    s.includes('genital_p') ||
    s.includes('penis') ||
    s.includes('phall') ||
    s.includes('dick') ||
    s.includes('cock') ||
    s.includes('/penis')
  );
};

const PenisTuningPanel: React.FC<{
  enabled: boolean;
  showKnotToggle: boolean;
  doKnotAction: boolean;
  canKnot: boolean;
  climaxMode: string;
  climaxModes?: { id: string; name: string }[];
  onToggleKnot: () => void;
  onSetClimaxMode: (mode: string) => void;
}> = ({ enabled, showKnotToggle, doKnotAction, canKnot, climaxMode, climaxModes, onToggleKnot, onSetClimaxMode }) => {
  if (!enabled) return null;
  const modes = climaxModes && climaxModes.length
    ? climaxModes
    : [{ id: 'outside', name: 'НАРУЖУ' }, { id: 'inside', name: 'ВНУТРЬ' }];
  return (
    <Section title="Настройки члена" style={{ paddingTop: 6, paddingBottom: 6 }}>
      <Stack justify="space-between" align="center" wrap>
        {showKnotToggle ? (
          <Stack.Item>
            <Box color="label" style={{ fontSize: 10, textTransform: 'uppercase' }} mb={0.25}>
              Узел
            </Box>
            <Stack>
              <Stack.Item>
                <Pill disabled={!canKnot} selected={!!doKnotAction} onClick={canKnot ? onToggleKnot : undefined}>
                  {doKnotAction ? 'ДО УЗЛА' : 'БЕЗ УЗЛА'}
                </Pill>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ) : (
          <Stack.Item />
        )}
        <Stack.Item>
          <Box color="label" style={{ fontSize: 10, textTransform: 'uppercase' }} mb={0.25} textAlign="right">
            Куда кончить
          </Box>
          <Stack justify="end" wrap>
            {modes.map((m) => (
              <Stack.Item key={m.id} style={{ margin: 1 }}>
                <Pill selected={String(climaxMode || '') === String(m.id)} onClick={() => onSetClimaxMode(m.id)}>
                  {m.name}
                </Pill>
              </Stack.Item>
            ))}
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const ActionsBottomSearch: React.FC<{
  searchText: string;
  onSearchChange: (value: string) => void;
}> = ({ searchText, onSearchChange }) => {
  return (
    <Section title="Фильтр" style={{ paddingTop: 6, paddingBottom: 6 }}>
      <Input
        fluid
        placeholder="Поиск взаимодействия..."
        value={searchText}
        onChange={(value) => onSearchChange(value)}
      />
    </Section>
  );
};

const ActionsTab: React.FC<{
  payload?: ActionsTabPayload;
  act: (verb: string, args?: any) => void;
}> = ({ payload, act }) => {
  const actorNodes = payload?.actor_nodes ?? [];
  const partnerNodes = payload?.partner_nodes ?? [];
  const selectedActorNode = payload?.selected_actor_node ?? null;
  const selectedPartnerNode = payload?.selected_partner_node ?? null;
  const allActions = payload?.actions ?? [];
  const links = payload?.active_links ?? [];
  const baseSpeed = Number(payload?.base_speed ?? 2);
  const baseForce = Number(payload?.base_force ?? 2);
  const [searchText, setSearchText] = useState('');
  const filteredActions = useMemo(() => {
    const q = searchText.trim().toLowerCase();
    return allActions
      .filter((a) => {
        if (q && !a.name.toLowerCase().includes(q)) return false;
        return true;
      })
      .sort((a, b) => {
        if (a.can !== b.can) return a.can ? -1 : 1;
        return a.name.localeCompare(b.name);
      });
  }, [allActions, searchText]);
  const penisEnabled = !!payload?.show_penis_panel;
  const canKnot = !!payload?.can_knot_now;
  const [knotLocal, setKnotLocal] = useState<boolean>(!!payload?.do_knot_action);
  const [climaxModeLocal, setClimaxModeLocal] = useState<string>(String(payload?.climax_mode || 'outside'));
  useEffect(() => {
    if (typeof payload?.do_knot_action === 'boolean') setKnotLocal(!!payload.do_knot_action);
    if (payload?.climax_mode) setClimaxModeLocal(String(payload.climax_mode));
  }, [payload?.do_knot_action, payload?.climax_mode]);
  const onToggleKnot = () => {
    const next = !knotLocal;
    setKnotLocal(next);
    act('toggle_knot', { value: next });
  };
  const onSetClimaxMode = (mode: string) => {
    setClimaxModeLocal(mode);
    act('set_climax_mode', { mode });
  };
  return (
    <Stack vertical fill>
      <Section fill>
        <Stack fill align="stretch">
          <Stack.Item basis="18%" style={{ paddingRight: 4 }}>
            <NodeList
              title="Я"
              nodes={actorNodes}
              selectedId={selectedActorNode}
              onSelect={(id) =>
                act('select_node', {
                  side: 'actor',
                  id: selectedActorNode === id ? null : id,
                })
              }
            />
          </Stack.Item>
          <Stack.Item grow>
            <Stack vertical fill>
              <Stack.Item grow>
                <ActionsListOldLike
                  actorSelected={selectedActorNode}
                  partnerSelected={selectedPartnerNode}
                  actions={filteredActions}
                  onClickAction={(id) => act('start_action', { type: id })}
                />
              </Stack.Item>
              <Stack.Item>
                <ActionsBottomSearch searchText={searchText} onSearchChange={setSearchText} />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item basis="18%" style={{ paddingLeft: 4 }}>
            <NodeList
              title="Партнёр"
              nodes={partnerNodes}
              selectedId={selectedPartnerNode}
              onSelect={(id) =>
                act('select_node', {
                  side: 'partner',
                  id: selectedPartnerNode === id ? null : id,
                })
              }
            />
          </Stack.Item>
        </Stack>
      </Section>
      <BaseTuningPanel
        baseSpeed={baseSpeed}
        baseForce={baseForce}
        onSetSpeed={(v) => act('set_base_speed', { value: v })}
        onSetForce={(v) => act('set_base_force', { value: v })}
      />
      <PenisTuningPanel
        enabled={!!penisEnabled}
        showKnotToggle={!!payload?.show_knot_toggle}
        doKnotAction={!!knotLocal}
        canKnot={!!canKnot}
        climaxMode={climaxModeLocal}
        climaxModes={payload?.climax_modes}
        onToggleKnot={onToggleKnot}
        onSetClimaxMode={onSetClimaxMode}
      />
      <ActiveLinksPanel
        links={links}
        onSetSpeed={(linkId, value) => act('set_link_speed', { link_id: linkId, value })}
        onSetForce={(linkId, value) => act('set_link_force', { link_id: linkId, value })}
        onToggleFinish={(linkId, nextToClimax) =>
          act('set_link_finish_mode', { link_id: linkId, mode: nextToClimax ? 'until_climax' : 'until_stop' })
        }
        onStop={(linkId) => act('stop_link', { link_id: linkId })}
      />
    </Stack>
  );
};

const prefText = (v?: number | null) => {
  if (v === undefined || v === null) return '—';
  if (v <= -1) return 'Не нравится';
  if (v >= 1) return 'Нравится';
  return 'Нейтрально';
};

const nextPref = (v: number) => {
  if (v <= -1) return 0;
  if (v === 0) return 1;
  return -1;
};

const KinkMiniCard: React.FC<{
  kink: KinkEntry;
  myValue: number;
  onCycle: () => void;
}> = ({ kink, myValue, onCycle }) => {
  const partnerKnown = kink.partner_pref_known && kink.partner_pref !== null && kink.partner_pref !== undefined;
  const partnerText = partnerKnown ? prefText(kink.partner_pref) : '—';

  const myTone = myValue <= -1 ? 'bad' : myValue >= 1 ? 'good' : 'label';
  const partnerTone = !partnerKnown
    ? 'label'
    : (kink.partner_pref as number) <= -1
      ? 'bad'
      : (kink.partner_pref as number) >= 1
        ? 'good'
        : 'label';
  return (
    <Box
      style={{
        border: '1px solid rgba(255,255,255,0.12)',
        borderRadius: 6,
        padding: 6,
        background: 'rgba(0,0,0,0.25)',
        marginBottom: 6,
      }}
    >
      <Stack justify="space-between" align="center">
        <Stack.Item grow>
          <Button
            fluid
            compact
            color="transparent"
            onClick={onCycle}
            style={{
              padding: '2px 6px',
              textAlign: 'left',
              justifyContent: 'flex-start',
              whiteSpace: 'normal',
              wordBreak: 'break-word',
              border: '1px solid rgba(255,255,255,0.12)',
              borderRadius: 6,
              background: 'rgba(255,255,255,0.03)',
            }}
            tooltip={kink.description ? kink.description : undefined}
          >
            <Box>
              <Box as="span" bold>
                {kink.name}
              </Box>{' '}
              <Box as="span" color={myTone} style={{ fontSize: 11 }}>
                ({prefText(myValue)})
              </Box>
            </Box>
          </Button>
        </Stack.Item>
        <Stack.Item ml={1} shrink>
          <Box
            style={{
              padding: '2px 8px',
              borderRadius: 9999,
              border: '1px solid rgba(255,255,255,0.16)',
              background: 'rgba(255,255,255,0.04)',
              fontSize: 10,
              lineHeight: 1.2,
              whiteSpace: 'nowrap',
              maxWidth: 150,
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              textAlign: 'right',
            }}
            color={partnerTone}
          >
            {partnerText}
          </Box>
        </Stack.Item>
      </Stack>
      {!!kink.description && (
        <Box mt={0.5} color="label" style={{ fontSize: 11, lineHeight: 1.25 }}>
          {kink.description}
        </Box>
      )}
    </Box>
  );
};

const fmt1 = (v?: number) => {
  const n = Number(v);
  if (!Number.isFinite(n)) return '0.0';
  return n.toFixed(1);
};

const summedFill = (storage?: LiquidBlock, producing?: LiquidBlock) => {
  const sv = Number(storage?.volume ?? 0);
  const pv = Number(producing?.volume ?? 0);
  const total = (Number.isFinite(sv) ? sv : 0) + (Number.isFinite(pv) ? pv : 0);
  return total;
};

const StatusOrganCard: React.FC<{
  entry: StatusEntry;
  onEditSensitivity: (organId: string, current: number) => void;
  onToggleOverflow: (organId: string) => void;
  onSetErectMode?: (organId: string, mode: 'auto' | 'none' | 'partial' | 'hard') => void;
}> = ({ entry, onEditSensitivity, onToggleOverflow, onSetErectMode }) => {
  const name = entry.name || entry.type || 'Орган';
  const sens = Number(entry.sensitivity ?? 0);
  const pain = Number(entry.pain ?? 0);
  const toggles = entry.toggles || {};
  const hasOverflow = !!toggles.has_overflow;
  const overflow = !!toggles.overflow;
  const hasErect = !!toggles.has_erect;
  const erectMode = (toggles.erect_mode || 'auto') as 'auto' | 'none' | 'partial' | 'hard';
  const links = entry.links ?? [];
  const passive = links.filter((l) => l.mode === 'passive');
  const active = links.filter((l) => l.mode === 'active');
  const fillTotal = summedFill(entry.storage, entry.producing);
  return (
    <Box
      style={{
        border: '1px solid rgba(255,255,255,0.12)',
        borderRadius: 6,
        padding: 6,
        background: 'rgba(0,0,0,0.25)',
        marginBottom: 6,
      }}
    >
      <Stack justify="space-between" align="center">
        <Stack.Item grow>
          <Box bold style={{ fontSize: 12 }}>
            {name}
          </Box>
        </Stack.Item>
        {entry.busy ? (
          <Stack.Item shrink>
            <Box color="bad" style={{ fontSize: 10 }}>
              ● активен
            </Box>
          </Stack.Item>
        ) : null}
      </Stack>
      <Stack mt={0.5} justify="space-between" align="center" wrap>
        <Stack.Item>
          <Button
            inline
            compact
            color="transparent"
            onClick={() => onEditSensitivity(entry.id, sens)}
            style={{ padding: '2px 6px' }}
          >
            Чувств.:{' '}
            <Box as="span" color="good" bold>
              {fmt1(sens)}
            </Box>
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Box style={{ fontSize: 11 }}>
            <Box as="span" color="bad">
              Боль:{' '}
            </Box>
            <Box as="span" color="bad" bold>
              {fmt1(pain)}
            </Box>
          </Box>
        </Stack.Item>
        {hasOverflow ? (
          <Stack.Item>
            <Pill selected={overflow} onClick={() => onToggleOverflow(entry.id)}>
              ПЕРЕПОЛН.
            </Pill>
          </Stack.Item>
        ) : null}
      </Stack>
      {hasErect && onSetErectMode && (
        <Box mt={0.5}>
          <Box color="label" style={{ fontSize: 10, textTransform: 'uppercase' }} mb={0.25}>
            Возбуждение
          </Box>
          <Stack wrap>
            <Stack.Item>
              <Pill selected={erectMode === 'auto'} onClick={() => onSetErectMode(entry.id, 'auto')}>
                АВТО
              </Pill>
            </Stack.Item>
            <Stack.Item>
              <Pill selected={erectMode === 'none'} onClick={() => onSetErectMode(entry.id, 'none')}>
                МЯГКИЙ
              </Pill>
            </Stack.Item>
            <Stack.Item>
              <Pill selected={erectMode === 'partial'} onClick={() => onSetErectMode(entry.id, 'partial')}>
                ВОЗБУЖДЕН
              </Pill>
            </Stack.Item>
            <Stack.Item>
              <Pill selected={erectMode === 'hard'} onClick={() => onSetErectMode(entry.id, 'hard')}>
                КРЕПКИЙ
              </Pill>
            </Stack.Item>
          </Stack>
        </Box>
      )}
      {fillTotal > 0 && (
        <Box mt={0.5} style={{ fontSize: 11 }}>
          <Box as="span" color="label">
            Наполненность:{' '}
          </Box>
          <Box as="span" bold>
            {Math.round(fillTotal)}
          </Box>
        </Box>
      )}
      {(passive.length > 0 || active.length > 0) && (
        <Box mt={0.75} style={{ fontSize: 11 }}>
          {passive.length > 0 && (
            <Box>
              <Box color="label" style={{ fontSize: 10, textTransform: 'uppercase' }}>
                Воздействия на орган
              </Box>
              {passive.map((l) => (
                <Box key={l.id} mt={0.25}>
                  <Box as="span" color="label">
                    •{' '}
                  </Box>
                  {l.action_name || '—'}{' '}
                  <Box as="span" color="label">
                    {l.other_organ ? `(${l.other_organ})` : ''}
                  </Box>
                </Box>
              ))}
            </Box>
          )}
          {active.length > 0 && (
            <Box mt={0.5}>
              <Box color="label" style={{ fontSize: 10, textTransform: 'uppercase' }}>
                Орган воздействует
              </Box>
              {active.map((l) => (
                <Box key={l.id} mt={0.25}>
                  <Box as="span" color="label">
                    •{' '}
                  </Box>
                  {l.action_name || '—'}{' '}
                  <Box as="span" color="label">
                    {l.other_organ ? `(${l.other_organ})` : ''}
                  </Box>
                </Box>
              ))}
            </Box>
          )}
        </Box>
      )}
    </Box>
  );
};

const ArousalPanel: React.FC<{
  data?: ArousalPayload | null;
}> = ({ data }) => {
  if (!data) return null;
  const charge = Math.round(Number(data.charge ?? 0));
  const chargeMax = Math.round(Number(data.charge_max ?? 0));
  const charge_for_climax = Math.round(Number(data.charge_for_climax ?? 0));
  const spTierText = String((data as any).sp_tier_text ?? '').trim();
  const op = Number(data.overload_points ?? 0);
  const overloadActive = !!(data as any).overload_active || op > 0;
  return (
    <Stack vertical>
      <Stack.Item>
        <Box style={{ fontSize: 11 }}>
          Заряд: <Box as="span" bold>{charge}</Box>/{chargeMax} ({charge_for_climax} для оргазма)
        </Box>
        <Box style={{ fontSize: 11 }}>
          Самочувствие:{' '}
          <Box as="span" bold>
            {spTierText || 'нормально'}
          </Box>
          {overloadActive && (
            <Box color="bad" bold style={{ fontSize: 11 }}>
              СВЕРХ-СТИМУЛЯЦИЯ
            </Box>
          )}
        </Box>
      </Stack.Item>
    </Stack>
  );
};

const StatusTab: React.FC<{
  entries: StatusEntry[];
  onEditSensitivity: (organId: string, current: number) => void;
  onToggleOverflow: (organId: string) => void;
  onSetErectMode?: (organId: string, mode: 'auto' | 'none' | 'partial' | 'hard') => void;
}> = ({ entries, onEditSensitivity, onToggleOverflow, onSetErectMode }) => {
  if (!entries.length) {
    return (
      <Section title="Статус">
        <Box color="label" textAlign="center">
          Пусто (entries не пришли)
        </Box>
      </Section>
    );
  }
  return (
    <Section title="Статус">
      {entries.map((e) => (
        <StatusOrganCard
          key={e.id}
          entry={e}
          onEditSensitivity={onEditSensitivity}
          onToggleOverflow={onToggleOverflow}
          onSetErectMode={onSetErectMode}
        />
      ))}
    </Section>
  );
};

const normalizeFields = (fields: any): EditorField[] => {
  if (!fields) return [];
  if (Array.isArray(fields)) {
    return fields
      .map((f) => ({
        id: safeString(f?.id),
        label: safeString(f?.label ?? f?.name ?? f?.id),
        type: (f?.type ?? 'text') as EditorFieldType,
        section: safeString(f?.section ?? ''),
        desc: safeString(f?.desc ?? f?.description ?? ''),
        min: f?.min,
        max: f?.max,
        step: f?.step,
        options: Array.isArray(f?.options) ? f.options : undefined,
        placeholder: safeString(f?.placeholder ?? ''),
        max_len: f?.max_len,
        value: f?.value,
      }))
      .filter((f) => !!f.id);
  }
  if (typeof fields === 'object') {
    return Object.keys(fields).map((k) => ({
      id: k,
      label: k,
      type:
        Array.isArray(fields[k])
          ? 'string_list'
          : typeof fields[k] === 'number'
            ? 'number'
            : typeof fields[k] === 'boolean'
              ? 'bool'
              : 'text',
      section: 'Параметры',
      value: fields[k],
    }));
  }
  return [];
};

const groupBySection = (fields: EditorField[]) => {
  const map: Record<string, EditorField[]> = {};
  for (const f of fields) {
    const sec = f.section || 'Параметры';
    if (!map[sec]) map[sec] = [];
    map[sec].push(f);
  }
  return Object.entries(map).sort((a, b) => a[0].localeCompare(b[0]));
};

const ListEditor: React.FC<{
  value: string[];
  placeholder?: string;
  maxLen?: number;
  onChange: (next: string[]) => void;
}> = ({ value, placeholder, maxLen, onChange }) => {
  const [draft, setDraft] = useState('');
  const add = () => {
    const s = draft.trim();
    if (!s) return;
    const next = [...value, s];
    if (maxLen && next.length > maxLen) return;
    onChange(next);
    setDraft('');
  };
  const removeAt = (i: number) => {
    const next = value.slice();
    next.splice(i, 1);
    onChange(next);
  };
  return (
    <Box>
      <Stack wrap>
        {value.map((t, i) => (
          <Stack.Item key={`${t}_${i}`} style={{ margin: 1 }}>
            <Pill onClick={() => removeAt(i)}>{t} ✕</Pill>
          </Stack.Item>
        ))}
      </Stack>
      <Stack mt={0.5} align="center">
        <Stack.Item grow>
          <Input fluid value={draft} placeholder={placeholder || 'добавить...'} onChange={(v) => setDraft(v)} onEnter={add} />
        </Stack.Item>
        <Stack.Item shrink>
          <Button compact onClick={add}>
            +
          </Button>
        </Stack.Item>
      </Stack>
      {maxLen ? (
        <Box mt={0.25} color="label" style={{ fontSize: 10 }}>
          {value.length}/{maxLen}
        </Box>
      ) : null}
    </Box>
  );
};

const FieldControl: React.FC<{
  f: EditorField;
  onChange: (id: string, value: any) => void;
}> = ({ f, onChange }) => {
  const t = (f.type || 'text') as EditorFieldType;
  if (t === 'bool') {
    const v = !!f.value;
    return (
      <Stack justify="space-between" align="center" mb={0.5}>
        <Stack.Item grow>
          <Box bold style={{ fontSize: 11 }}>
            {f.label}
          </Box>
          {!!f.desc && (
            <Box color="label" style={{ fontSize: 10 }}>
              {f.desc}
            </Box>
          )}
        </Stack.Item>
        <Stack.Item shrink>
          <Pill selected={v} onClick={() => onChange(f.id, !v)}>
            {v ? 'ВКЛ' : 'ВЫКЛ'}
          </Pill>
        </Stack.Item>
      </Stack>
    );
  }
  if (t === 'enum' && f.options?.length) {
    const cur = String(f.value ?? '');
    return (
      <Box mb={0.75}>
        <Box bold style={{ fontSize: 11, marginBottom: 4 }}>
          {f.label}
        </Box>
        <Stack wrap>
          {f.options.map((o) => {
            const ov = String(o.value);
            return (
              <Stack.Item key={`${f.id}_${ov}`} style={{ margin: 1 }}>
                <Pill selected={cur === ov} onClick={() => onChange(f.id, o.value)}>
                  {o.name}
                </Pill>
              </Stack.Item>
            );
          })}
        </Stack>
        {!!f.desc && (
          <Box mt={0.25} color="label" style={{ fontSize: 10 }}>
            {f.desc}
          </Box>
        )}
      </Box>
    );
  }
  if (t === 'string_list') {
    const arr = Array.isArray(f.value) ? f.value.map((x) => String(x)) : [];
    return (
      <Box mb={0.75}>
        <Box bold style={{ fontSize: 11, marginBottom: 4 }}>
          {f.label}
        </Box>
        <ListEditor value={arr} placeholder={f.placeholder || 'tag'} maxLen={f.max_len} onChange={(next) => onChange(f.id, next)} />
        {!!f.desc && (
          <Box mt={0.25} color="label" style={{ fontSize: 10 }}>
            {f.desc}
          </Box>
        )}
      </Box>
    );
  }
  if (t === 'number') {
    return (
      <Box mb={0.75}>
        <Box bold style={{ fontSize: 11, marginBottom: 4 }}>
          {f.label}
        </Box>
        <Input
          fluid
          value={String(f.value ?? '')}
          onChange={(v) => {
            const n = Number(v);
            onChange(f.id, Number.isFinite(n) ? n : v);
          }}
        />
        {(Number.isFinite(f.min as any) || Number.isFinite(f.max as any)) && (
          <Box mt={0.25} color="label" style={{ fontSize: 10 }}>
            {Number.isFinite(f.min as any) ? `min ${f.min}` : ''}{' '}
            {Number.isFinite(f.min as any) && Number.isFinite(f.max as any) ? '•' : ''}{' '}
            {Number.isFinite(f.max as any) ? `max ${f.max}` : ''}
          </Box>
        )}
        {!!f.desc && (
          <Box mt={0.25} color="label" style={{ fontSize: 10 }}>
            {f.desc}
          </Box>
        )}
      </Box>
    );
  }
  if (t === 'multiline') {
    return (
      <Box mb={0.75}>
        <Box bold style={{ fontSize: 11, marginBottom: 4 }}>
          {f.label}
        </Box>
        <Input fluid value={String(f.value ?? '')} onChange={(v) => onChange(f.id, v)} />
        {!!f.desc && (
          <Box mt={0.25} color="label" style={{ fontSize: 10 }}>
            {f.desc}
          </Box>
        )}
      </Box>
    );
  }
  return (
    <Box mb={0.75}>
      <Box bold style={{ fontSize: 11, marginBottom: 4 }}>
        {f.label}
      </Box>
      <Input fluid value={String(f.value ?? '')} onChange={(v) => onChange(f.id, v)} />
      {!!f.desc && (
        <Box mt={0.25} color="label" style={{ fontSize: 10 }}>
          {f.desc}
        </Box>
      )}
    </Box>
  );
};

const EditorTab: React.FC<{
  templates: EditorTemplateEntry[];
  customActions: EditorCustomAction[];
  selected?: EditorSelectedPayload | null;

  act: (verb: string, args?: any) => void;

  onCreate: (params: any) => void;
  onUpdate: (params: any) => void;
  onDelete: (id: string) => void;
}> = ({ templates, customActions, selected, act, onCreate, onUpdate, onDelete }) => {
  const [isDirty, setIsDirty] = useState(false);
  const [rawMode, setRawMode] = useState(false);
  const [rawText, setRawText] = useState('');

  // Локальная форма — всегда гидрится из backend.selected,
  // но только если пользователь не "грязный" (не редактит сейчас)
  const [formFields, setFormFields] = useState<EditorField[]>([]);

  const selectedMode = selected?.mode ?? null;
  const selectedKey = selected?.key ?? null;

  // "источник" формы — строго selected (полный), не списки
  const source = useMemo(() => {
    if (!selectedMode || !selectedKey) return null;
    return {
      name: safeString(selected?.name ?? ''),
      fields: (selected as any)?.fields,
      mode: selectedMode,
      key: selectedKey,
    };
  }, [selectedMode, selectedKey, selected?.name, (selected as any)?.fields]);

  const selectionKey = selectedMode && selectedKey ? `${selectedMode}:${selectedKey}` : 'none';
  const lastSelectionKey = useRef<string>('none');

  const getFieldValue = (id: string) => {
    const f = formFields.find((x) => x.id === id);
    return f?.value;
  };

  const setFieldValue = (id: string, value: any) => {
    setIsDirty(true);
    setFormFields((prev) => prev.map((f) => (f.id === id ? { ...f, value } : f)));
  };

  const hydrateFromSelected = () => {
    if (!source) {
      setFormFields([]);
      setRawMode(false);
      setRawText('');
      return;
    }

    const nf = normalizeFields(source.fields);
    const nameFromSource = safeString(source.name);

    const hasName = nf.some((f) => f.id === 'name');
    const fieldsWithName = hasName
      ? nf
      : [
          {
            id: 'name',
            label: 'Название',
            type: 'text',
            section: 'ОСНОВНОЕ',
            value: nameFromSource,
          } as EditorField,
          ...nf,
        ];

    for (const f of fieldsWithName) {
      if (f.id === 'name') {
        const cur = safeString(f.value);
        if (!cur && nameFromSource) f.value = nameFromSource;
      }
    }

    setFormFields(fieldsWithName.map((f) => ({ ...f })));
    setRawMode(false);
    setRawText('');
  };

  // При смене выбранного в backend — гидрим форму, но НЕ перетираем локальные правки.
  useEffect(() => {
    if (selectionKey === lastSelectionKey.current) return;
    lastSelectionKey.current = selectionKey;

    setIsDirty(false);
    hydrateFromSelected();
  }, [selectionKey]);

  // Если backend прислал апдейт выбранного, а мы не dirty — тоже гидрим
  useEffect(() => {
    if (!source) return;
    if (isDirty) return;
    // если не менялся selectionKey — но поля обновились, мы всё равно можем перезалить.
    hydrateFromSelected();
  }, [source?.name, (source as any)?.fields]);

  const payloadFields = () => formFields.map((f) => ({ id: f.id, value: f.value }));

  const exportRaw = () => {
    try {
      return JSON.stringify(payloadFields(), null, 2);
    } catch {
      return '[]';
    }
  };

  const nameValue = safeString(getFieldValue('name'));
  const canCreate = selectedMode === 'template';
  const canSave = selectedMode === 'custom';
  const canDelete = selectedMode === 'custom';

  const commitCreate = () => {
    if (selectedMode !== 'template' || !selectedKey) return;

    let fields: any = payloadFields();
    if (rawMode) {
      try {
        fields = JSON.parse(rawText);
      } catch {
        // ignore
      }
    }

    const nameVal = safeString(getFieldValue('name'));
    if (!Array.isArray(fields) || !fields.some((x) => x?.id === 'name')) {
      fields = [{ id: 'name', value: nameVal || 'Custom action' }, ...(Array.isArray(fields) ? fields : [])];
    }

    setIsDirty(false);
    onCreate({
      type: selectedKey, // template.type
      name: nameVal,
      fields,
    });
  };

  const commitSave = () => {
    if (selectedMode !== 'custom' || !selectedKey) return;

    let fields: any = payloadFields();
    if (rawMode) {
      try {
        fields = JSON.parse(rawText);
      } catch {
        // ignore
      }
    }

    const nameVal = safeString(getFieldValue('name'));
    setIsDirty(false);
    onUpdate({
      id: selectedKey, // custom.id
      name: nameVal,
      fields,
    });
  };

  return (
    <Section title="Редактор действий" fill>
      <Stack fill>
        <Stack.Item basis="32%">
          <Section title="Шаблоны">
            {!templates.length ? (
              <Box color="label">Нет доступных шаблонов.</Box>
            ) : (
              <Stack vertical>
                {templates.map((t) => {
                  const isSelected = selectedMode === 'template' && selectedKey === t.type;
                  return (
                    <Stack.Item key={t.type}>
                      <Button
                        fluid
                        compact
                        selected={isSelected}
                        onClick={() => {
                          setIsDirty(false);
                          // ✅ просим backend выбрать и вернуть полный payload в selected
                          act('editor_select_action', { mode: 'template', key: t.type });
                        }}
                      >
                        {t.name}
                      </Button>
                    </Stack.Item>
                  );
                })}
              </Stack>
            )}
          </Section>

          <Section title={`Мои кастомные (${customActions.length})`}>
            {!customActions.length ? (
              <Box color="label">Пока пусто.</Box>
            ) : (
              <Stack vertical>
                {customActions.map((c) => {
                  const isSelected = selectedMode === 'custom' && selectedKey === c.id;
                  return (
                    <Stack.Item key={c.id}>
                      <Button
                        fluid
                        compact
                        selected={isSelected}
                        onClick={() => {
                          setIsDirty(false);
                          // ✅ просим backend выбрать и вернуть полный payload в selected
                          act('editor_select_action', { mode: 'custom', key: c.id });
                        }}
                      >
                        {c.name}
                      </Button>
                    </Stack.Item>
                  );
                })}
              </Stack>
            )}
          </Section>
        </Stack.Item>

        <Stack.Item grow basis="68%">
          <Section title="Параметры" fill scrollable>
            {!source ? (
              <Box color="label">Выбери слева шаблон или своё действие.</Box>
            ) : (
              <>
                <Box mb={1}>
                  <Box color="label" style={{ fontSize: 10, textTransform: 'uppercase' }} mb={0.25}>
                    Основное
                  </Box>
                  <Box mb={0.25} bold style={{ fontSize: 11 }}>
                    Название
                  </Box>
                  <Input fluid value={nameValue} onChange={(v) => setFieldValue('name', v)} />
                </Box>

                <Box mb={1}>
                  <Stack justify="space-between" align="center">
                    <Stack.Item>
                      <Box color="label" style={{ fontSize: 10, textTransform: 'uppercase' }}>
                        Поля
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Pill
                        selected={rawMode}
                        onClick={() => {
                          setRawMode((p) => !p);
                          if (!rawMode) setRawText(exportRaw());
                        }}
                      >
                        RAW JSON
                      </Pill>
                    </Stack.Item>
                  </Stack>

                  {!rawMode ? (
                    formFields.length ? (
                      <Box mt={0.5}>
                        {groupBySection(formFields.filter((f) => f.id !== 'name')).map(([sec, fields]) => (
                          <Box key={sec} mb={1}>
                            <Box color="label" style={{ fontSize: 10, textTransform: 'uppercase' }} mb={0.25}>
                              {sec}
                            </Box>
                            {fields.map((f) => (
                              <FieldControl key={f.id} f={f} onChange={setFieldValue} />
                            ))}
                          </Box>
                        ))}
                      </Box>
                    ) : (
                      <Box mt={0.5} color="label">
                        Поля не пришли (или backend ещё не отдал выбранное действие полностью).
                      </Box>
                    )
                  ) : (
                    <Box mt={0.5}>
                      <Input
                        fluid
                        value={rawText}
                        onChange={(v) => {
                          setIsDirty(true);
                          setRawText(v);
                        }}
                      />
                      <Box mt={0.25} color="label" style={{ fontSize: 10 }}>
                        В RAW можно править payload полей. Если JSON сломан — уйдёт обычный вариант.
                      </Box>
                    </Box>
                  )}
                </Box>

                <Box mt={1} textAlign="right">
                  <Button disabled={!canCreate} onClick={commitCreate}>
                    СОЗДАТЬ КАСТОМ
                  </Button>{' '}
                  <Button disabled={!canSave} onClick={commitSave}>
                    СОХРАНИТЬ
                  </Button>{' '}
                  <Button
                    disabled={!canDelete || !selectedKey}
                    color="bad"
                    onClick={() => {
                      if (!selectedKey) return;
                      setIsDirty(false);
                      onDelete(selectedKey);
                    }}
                  >
                    УДАЛИТЬ
                  </Button>
                </Box>

                {isDirty && (
                  <Box mt={0.5} color="label" style={{ fontSize: 10 }}>
                    Локальные правки не будут перезатираться обновлениями UI до сохранения или смены выбора.
                  </Box>
                )}
              </>
            )}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

type EditContext = { kind: 'arousal' } | { kind: 'organ_sens'; organId: string };
export const EroticRolePlayPanel: React.FC = () => {
  const { act, data } = useBackend<SexSessionData>();
  const partners = data.partners ?? [];
  const showPartner = typeof data.partner_arousal === 'number' && !data.partner_arousal_hidden;
  const actorArousal = clamp01(data.actor_arousal ?? 0);
  const partnerArousal = clamp01(data.partner_arousal ?? 0);
  const [activeTab, setActiveTab] = useState<string>(data.active_tab || 'actions');
  useEffect(() => {
    if (data.active_tab && data.active_tab !== activeTab) setActiveTab(data.active_tab);
  }, [data.active_tab]);
  const kinkEntries = data.tabs?.kinks?.entries ?? [];
  const [kinkLocal, setKinkLocal] = useState<Record<string, number>>({});
  useEffect(() => {
    const next: Record<string, number> = {};
    for (const k of kinkEntries) next[k.type] = k.pref ?? 0;
    setKinkLocal((prev) => {
      if (Object.keys(prev).length) return prev;
      return next;
    });
  }, [kinkEntries]);
  const statusEntries = data.tabs?.status?.entries ?? [];
  const actionsPayload = data.tabs?.actions;
  const editorTemplates = data.tabs?.editor?.templates ?? [];
  const editorCustomActions = data.tabs?.editor?.custom_actions ?? [];
  const [editContext, setEditContext] = useState<EditContext | null>(null);
  const [editValue, setEditValue] = useState('');
  const openArousalEditor = () => {
    setEditValue(String(Math.round(actorArousal)));
    setEditContext({ kind: 'arousal' });
  };
  const openSensitivityEditor = (organId: string, current: number) => {
    setEditValue(String(current));
    setEditContext({ kind: 'organ_sens', organId });
  };
  const confirmEdit = () => {
    if (!editContext) return;
    const num = Number(editValue);
    if (!Number.isFinite(num)) {
      setEditContext(null);
      return;
    }
    if (editContext.kind === 'arousal') {
      act('set_arousal', { amount: Math.max(0, Math.min(100, Math.round(num))) });
    } else {
      act('set_organ_sensitivity', { organ_id: editContext.organId, value: num });
    }
    setEditContext(null);
  };
  const isArousing = !data.frozen;
  const isYielding = !!data.yield_to_partner;
  const isMoaning = !!data.allow_user_moan;
  const isHidden = !!data.hidden_mode;
  const [q, setQ] = useState('');
  const [cat, setCat] = useState<string>('ALL');
  const categories = useMemo(() => {
    const set = new Set<string>();
    for (const k of kinkEntries) if (k.category) set.add(k.category);
    return ['ALL', ...Array.from(set).sort((a, b) => a.localeCompare(b))];
  }, [kinkEntries]);
  const filteredKinks = useMemo(() => {
    const qq = q.trim().toLowerCase();
    return kinkEntries
      .filter((k) => {
        const kc = k.category || 'General';
        if (cat !== 'ALL' && kc !== cat) return false;
        if (!qq) return true;
        const hay = `${k.name} ${k.description || ''} ${kc}`.toLowerCase();
        return hay.includes(qq);
      })
      .sort((a, b) => {
        const ac = a.category || 'General';
        const bc = b.category || 'General';
        if (ac !== bc) return ac.localeCompare(bc);
        return a.name.localeCompare(b.name);
      });
  }, [kinkEntries, q, cat]);
  return (
    <Window title="Утолить Желания" width={520} height={740}>
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <PartnerNameTop
              partners={partners}
              currentRef={data.current_partner_ref}
              onChange={(ref) => act('set_partner', { ref })}
            />
          </Stack.Item>
          <Box style={{ padding: 0, marginTop: 2 }}>
            <Stack justify="center" wrap>
              <Stack.Item style={{ margin: 0 }}>
                <Pill selected={isArousing} onClick={() => act('freeze_arousal')}>
                  ВОЗБУЖДАТЬСЯ
                </Pill>
              </Stack.Item>
              <Stack.Item style={{ margin: 0 }}>
                <Pill selected={isYielding} onClick={() => act('yield')}>
                  ПОДДАВАТЬСЯ
                </Pill>
              </Stack.Item>
              <Stack.Item style={{ margin: 0 }}>
                <Pill selected={isMoaning} onClick={() => act('set_moaning')}>
                  СТОНАТЬ
                </Pill>
              </Stack.Item>
              <Stack.Item style={{ margin: 0 }}>
                <Pill selected={isHidden} onClick={() => act('toggle_hidden')}>
                  СКРЫТНО
                </Pill>
              </Stack.Item>
            </Stack>
          </Box>
          <Box style={{ padding: 0, marginTop: 2 }}>
            {showPartner ? (
              <Stack>
                <Stack.Item basis="50%" style={{ paddingRight: 2 }}>
                  <BarRow label="Я" valuePercent={actorArousal} clickable onClick={openArousalEditor} />
                </Stack.Item>
                <Stack.Item basis="50%" style={{ paddingLeft: 2 }}>
                  <BarRow label="Партнёр" valuePercent={partnerArousal} />
                </Stack.Item>
              </Stack>
            ) : (
              <BarRow label="Я" valuePercent={actorArousal} clickable onClick={openArousalEditor} />
            )}
          </Box>
          <Stack.Item>
            <ControlRow act={act} />
          </Stack.Item>
          <Stack.Item>
            <TabsRow
              active={activeTab}
              onSet={(tab) => {
                setActiveTab(tab);
                act('set_tab', { tab });
              }}
            />
          </Stack.Item>
          <Stack.Item>
            {activeTab === 'actions' ? (
              <ActionsTab payload={actionsPayload} act={act} />
            ) : activeTab === 'kinks' ? (
              <Stack vertical>
                <Stack.Item>
                  <Section title="Фетиши">
                    <Stack vertical>
                      <Stack.Item>
                        <Input fluid placeholder="Поиск по кинкам..." value={q} onChange={(v) => setQ(v)} />
                      </Stack.Item>
                      {categories.length > 1 && (
                        <Stack.Item mt={0.5}>
                          <Stack wrap>
                            {categories.map((c) => (
                              <Stack.Item key={c} style={{ margin: 1 }}>
                                <Pill selected={cat === c} onClick={() => setCat(c)}>
                                  {c}
                                </Pill>
                              </Stack.Item>
                            ))}
                          </Stack>
                        </Stack.Item>
                      )}
                    </Stack>
                  </Section>
                </Stack.Item>
                <Stack.Item grow>
                  <Section title={`Настройки (${filteredKinks.length}/${kinkEntries.length})`}>
                    {!kinkEntries.length ? (
                      <Box color="label" textAlign="center">
                        Пусто (entries не пришли)
                      </Box>
                    ) : !filteredKinks.length ? (
                      <Box color="label" textAlign="center">
                        Ничего не найдено по фильтрам.
                      </Box>
                    ) : (
                      filteredKinks.map((k) => {
                        const myVal = kinkLocal[k.type] ?? (k.pref ?? 0);
                        return (
                          <KinkMiniCard
                            key={k.type}
                            kink={k}
                            myValue={myVal}
                            onCycle={() => {
                              const nv = nextPref(myVal);
                              setKinkLocal((prev) => ({ ...prev, [k.type]: nv }));
                              act('set_kink_pref', { type: k.type, value: nv });
                            }}
                          />
                        );
                      })
                    )}
                  </Section>
                </Stack.Item>
              </Stack>
            ) : activeTab === 'status' ? (
              <Stack vertical>
                <Stack.Item>
                  <ArousalPanel
                    data={data.tabs?.status?.arousal_data}
                  />
                </Stack.Item>
                <Stack.Item>
                  <StatusTab
                    entries={statusEntries}
                    onEditSensitivity={openSensitivityEditor}
                    onToggleOverflow={(organId) => act('toggle_organ_overflow', { organ_id: organId })}
                    onSetErectMode={(organId, mode) => act('set_organ_erect', { organ_id: organId, mode })}
                  />
                </Stack.Item>
              </Stack>
            ) : activeTab === 'editor' ? (
              <EditorTab
                templates={editorTemplates}
                customActions={editorCustomActions}
                selected={data.tabs?.editor?.selected ?? null}
                act={act}
                onCreate={(params) => act('create_action', params)}
                onUpdate={(params) => act('update_action', params)}
                onDelete={(id) => act('delete_action', { id })}
              />
            ) : (
              <Box color="label" style={{ padding: 6 }}>
                Контент вкладки позже.
              </Box>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
      {editContext && (
        <Modal>
          <Section title={editContext.kind === 'arousal' ? 'Установить возбуждение (0–100)' : 'Чувствительность (например 0–2)'}>
            <Input autoFocus value={editValue} onChange={(v) => setEditValue(v)} />
            <Box mt={1} textAlign="right">
              <Button onClick={() => setEditContext(null)}>Отмена</Button>{' '}
              <Button onClick={confirmEdit}>OK</Button>
            </Box>
          </Section>
        </Modal>
      )}
    </Window>
  );
};

export default EroticRolePlayPanel;
