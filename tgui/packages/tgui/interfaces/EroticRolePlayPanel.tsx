import { type CSSProperties, type ReactNode, useEffect, useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Divider,
  Input,
  Modal,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

export type OrgNode = {
  id: string;
  name: string;
  busy?: boolean;
  side?: 'actor' | 'partner';
  sensitivity?: number;
  pain?: number;
  fullness?: number;
  erect?: number;
  manual?: boolean;
};

export type SexAction = {
  type: string;
  name: string;
  tags?: string[];
};

export type PartnerEntry = {
  ref: string;
  name: string;
};

export type ActiveLink = {
  id: string;
  actor_organ_id: string;
  partner_organ_id: string;
  action_type: string;
  action_name: string;
  speed: number;
  force: number;
  do_until_finished?: boolean;
  sensitivity?: number;
  pain?: number;
};

export type SexCustomTemplate = {
  type: string;
  name: string;
  stamina_cost: number;
  affects_self_arousal: number;
  affects_arousal: number;
  affects_self_pain: number;
  affects_pain: number;
  can_knot?: boolean;
  climax_liquid_mode_active?: string;
  climax_liquid_mode_passive?: string;
  required_init?: string;
  required_target?: string;
  reserve_target_for_session?: boolean;
  base_kind?: 'self' | 'other';
  check_same_tile?: boolean;
  break_on_move?: boolean;

  actor_sex_hearts?: boolean;
  target_sex_hearts?: boolean;
  actor_suck_sound?: boolean;
  target_suck_sound?: boolean;
  actor_make_sound?: boolean;
  target_make_sound?: boolean;
  actor_make_fingering_sound?: boolean;
  target_make_fingering_sound?: boolean;
  actor_do_onomatopoeia?: boolean;
  target_do_onomatopoeia?: boolean;
  actor_do_thrust?: boolean;
  target_do_thrust?: boolean;

  message_on_start?: string;
  message_on_perform?: string;
  message_on_finish?: string;
  message_on_climax_actor?: string;
  message_on_climax_target?: string;
};

export type SexCustomAction = SexCustomTemplate & {};

export type KinkEntry = {
  type: string;
  name: string;
  description?: string;
  category?: string;
  intensity?: number;
  pref: number;
  partner_pref?: number | null;
  partner_pref_known?: boolean;
};

export type KinksPayload = {
  entries: KinkEntry[];
};

export type SexSessionData = {
  title: string;
  session_name?: string;

  actor_name: string;
  partner_name?: string;

  partners?: PartnerEntry[];
  current_partner_ref?: string | null;

  actor_organs?: OrgNode[];
  partner_organs?: OrgNode[];
  status_organs?: OrgNode[];
  selected_actor_organ?: string;
  selected_partner_organ?: string;

  speed: number;
  force: number;
  speed_names: string[];
  force_names: string[];

  actor_arousal?: number;
  partner_arousal?: number;
  partner_arousal_hidden?: boolean;

  frozen?: boolean;
  do_until_finished?: boolean;
  do_knot_action?: boolean;
  has_knotted_penis?: boolean;
  can_knot_now?: boolean;
  yield_to_partner?: boolean;
  allow_user_moan?: boolean;
  hidden_mode?: boolean;

  actions?: SexAction[];
  can_perform?: string[];
  available_tags?: string[];
  organ_filtered?: string[];

  current_action?: string;
  current_actions?: string[];

  active_links?: ActiveLink[];
  passive_links?: ActiveLink[];
  actor_charge?: number;
  actor_charge_max?: number;
  actor_charge_for_climax?: number;

  custom_templates?: SexCustomTemplate[];
  custom_actions?: SexCustomAction[];

  climax_modes?: { id: string; name: string }[];
  organ_type_options?: { id: string; name: string }[];

  kinks?: KinksPayload;
};

const fmt2 = (value?: number) =>
  value === undefined || value === null ? '0' : Number(value).toFixed(2);

const clampName = (name?: string, max = 10): string => {
  if (!name) return '';
  const s = String(name);
  if (s.length <= max) return s;
  if (max <= 1) return s.slice(0, max);
  return `${s.slice(0, max - 1)}…`;
};

const speedColors = ['#a798a2ff', '#e67ec0ff', '#f05ee1', '#f54689ff'];
const forceColors = ['#a798a2ff', '#e67ec0ff', '#f05ee1', '#f54689ff'];

const Pill: React.FC<{
  selected?: boolean;
  disabled?: boolean;
  onClick?: () => void;
  children?: ReactNode;
}> = ({ selected, disabled, onClick, children }) => {
  const isSelected = !!selected;

  const style: CSSProperties = {
    borderRadius: 9999,
    padding: '2px 10px',
    margin: 2,
    background: isSelected
      ? 'var(--button-background-selected)'
      : 'rgba(255,255,255,0.05)',
    color: isSelected ? 'var(--color-text)' : 'var(--color-label)',
    boxShadow: isSelected ? '0 0 6px var(--button-background-selected)' : 'none',
    border: isSelected
      ? '1px solid var(--button-border-color)'
      : '1px solid rgba(255,255,255,0.15)',
  };

  return (
    <Button
      inline
      compact
      disabled={disabled}
      selected={isSelected}
      color="transparent"
      style={style}
      onClick={onClick}
    >
      {children}
    </Button>
  );
};

const OrganList: React.FC<{
  title: string;
  organs: OrgNode[];
  selectedId?: string;
  onSelect: (id: string) => void;
}> = ({ title, organs, selectedId, onSelect }) => (
  <Section title={clampName(title)} fill>
    <Stack vertical>
      {organs.map((org) => {
        const isSelected = selectedId === org.id;
        const isBusy = !!org.busy;
        const baseColor = isBusy ? 'var(--color-bad)' : 'var(--color-text)';

        const style: CSSProperties = {
          border: isSelected
            ? '2px solid var(--color-border)'
            : '1px solid rgba(255,255,255,0.2)',
          boxShadow: isSelected ? '0 0 8px var(--button-background-selected)' : undefined,
          background: isSelected
            ? 'var(--button-background-selected)'
            : 'rgba(255,255,255,0.05)',
          color: baseColor,
          textAlign: 'center',
          justifyContent: 'center',
        };

        return (
          <Stack.Item key={org.id}>
            <Button
              fluid
              selected={isSelected}
              disabled={isBusy}
              style={style}
              onClick={() => onSelect(org.id)}
            >
              <Box as="span">
                {org.name}
                {isBusy ? (
                  <Box as="span" ml={1} color="bad">
                    ●
                  </Box>
                ) : null}
              </Box>
            </Button>
          </Stack.Item>
        );
      })}
    </Stack>
  </Section>
);

const PartnerSelector: React.FC<{
  actorName: string;
  partners: PartnerEntry[];
  currentRef?: string | null;
  onChange: (ref: string) => void;
}> = ({ actorName, partners, currentRef, onChange }) => {
  const [open, setOpen] = useState(false);

  const current = partners.find((p) => p.ref === currentRef) || partners[0] || null;

  return (
    <Section>
      <Box
        textAlign="center"
        bold
        style={{
          whiteSpace: 'normal',
          wordBreak: 'break-word',
        }}
      >
        {actorName || '—'}{' '}
        <Box as="span" color="label">
          {' ↔ '}
        </Box>
        <Button inline compact onClick={() => setOpen((prev) => !prev)} selected={open}>
          {current ? current.name : '—'}
        </Button>
      </Box>

      {open && partners.length > 1 && (
        <Box mt={1}>
          <Stack justify="center" wrap>
            {partners.map((p) => (
              <Stack.Item key={p.ref} style={{ margin: 2 }}>
                <Button
                  inline
                  compact
                  selected={current?.ref === p.ref}
                  onClick={() => {
                    onChange(p.ref);
                    setOpen(false);
                  }}
                >
                  {p.name}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Box>
      )}
    </Section>
  );
};

const BarRow: React.FC<{
  label: string;
  valuePercent: number;
  color?: string;
  clickable?: boolean;
  onClick?: () => void;
}> = ({ label, valuePercent, clickable, onClick }) => {
  let v = Number(valuePercent);
  if (!Number.isFinite(v)) v = 0;
  const clamped = Math.max(0, Math.min(100, v));
  const percentText = Math.round(clamped);

  const bar = (
    <Box
      style={{
        position: 'relative',
        height: 26,
        width: '100%',
        border: '1px solid rgba(255,255,255,0.35)',
        borderRadius: 6,
        overflow: 'hidden',
        background: 'rgba(0, 0, 0, 0.6)',
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
          fontSize: 11,
          color: '#ffffff',
          textShadow: '0 0 3px #000',
        }}
      >
        <span>{label}</span>
        <span>
          {percentText} / 100 ({percentText}%)
        </span>
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

const ArousalBars: React.FC<{
  actorName: string;
  partnerLabel: string;
  actorArousal: number;
  partnerArousal: number;
  showPartnerBar: boolean;
  onSetActor: () => void;
}> = ({ actorName, partnerLabel, actorArousal, partnerArousal, showPartnerBar, onSetActor }) => (
  <Section>
    <Stack vertical>
      <Stack.Item>
        <BarRow
          label="Я"
          valuePercent={actorArousal}
          color="var(--button-background-selected)"
          clickable
          onClick={onSetActor}
        />
      </Stack.Item>
      {showPartnerBar && (
        <Stack.Item mt={0.25}>
          <BarRow
            label="Партнёр"
            valuePercent={partnerArousal}
            color="var(--button-background)"
          />
        </Stack.Item>
      )}
    </Stack>
  </Section>
);

const getErectModeForOrg = (org: OrgNode | undefined): 'auto' | 'none' | 'partial' | 'hard' => {
  if (!org) return 'auto';
  if (!org.manual) return 'auto';
  const e = org.erect ?? 0;
  if (e >= 2) return 'hard';
  if (e === 1) return 'partial';
  return 'none';
};

const StatusPanel: React.FC<{
  data: SexSessionData;
  actorOrgans: OrgNode[];
  actorName: string;
  partnerLabel?: string;
  editable?: boolean;
  onEditOrgan: (id: string, field: 'sensitivity' | 'pain') => void;
  onSetErectState?: (id: string, state: 'auto' | 'none' | 'partial' | 'hard') => void;
  viewAs?: 'actor' | 'target';
}> = ({
  data,
  actorOrgans,
  actorName,
  partnerLabel,
  editable,
  onEditOrgan,
  onSetErectState,
  viewAs = 'target',
}) => {
  const allLinks = [...(data.active_links || []), ...(data.passive_links || [])];
  const canEdit = editable !== false;

  const speedName = (v: number) => {
    const idx = Math.max(1, Math.min(data.speed_names.length, v)) - 1;
    return data.speed_names[idx] || '?';
  };

  const forceName = (v: number) => {
    const idx = Math.max(1, Math.min(data.force_names.length, v)) - 1;
    return data.force_names[idx] || '?';
  };

  return (
    <Section title={`Состояние: ${actorName}`} fill scrollable>
      {actorOrgans.map((org) => {
        const affecting = allLinks.filter((l) => {
          if (viewAs === 'actor') return l.actor_organ_id === org.id;
          return l.partner_organ_id === org.id;
        });

        const sens = (org as any).sensitivity ?? 0;
        const pain = (org as any).pain ?? 0;
        const fullness = (org as any).fullness ?? 0;

        const isPenis = org.id === 'genital_p';
        const erectMode = isPenis ? getErectModeForOrg(org) : 'auto';

        return (
          <Box key={org.id} mb={1.5}>
            <Stack justify="space-between" align="center">
              <Stack.Item>
                <Box bold>{org ? org.name : '—'}</Box>
              </Stack.Item>
              <Stack.Item>
                <Stack align="center">
                  <Stack.Item style={{ marginRight: 8 }}>
                    <Button
                      inline
                      compact
                      color="transparent"
                      disabled={!canEdit}
                      onClick={canEdit ? () => onEditOrgan(org.id, 'sensitivity') : undefined}
                    >
                      Чувствительность:{' '}
                      <Box as="span" color="good">
                        {fmt2(sens)}
                      </Box>
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Box color="bad">Боль: {fmt2(pain)}</Box>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>

            {isPenis && onSetErectState && (
              <Box mt={0.25} ml={1}>
                <Box as="div" style={{ fontSize: 11 }} color="label">
                  Возбуждение:
                </Box>
                <Stack wrap align="center">
                  <Stack.Item>
                    <Pill selected={erectMode === 'auto'} onClick={() => onSetErectState(org.id, 'auto')}>
                      АВТО
                    </Pill>
                  </Stack.Item>
                  <Stack.Item>
                    <Pill selected={erectMode === 'none'} onClick={() => onSetErectState(org.id, 'none')}>
                      МЯГКИЙ
                    </Pill>
                  </Stack.Item>
                  <Stack.Item>
                    <Pill
                      selected={erectMode === 'partial'}
                      onClick={() => onSetErectState(org.id, 'partial')}
                    >
                      ВОЗБУЖДЕН
                    </Pill>
                  </Stack.Item>
                  <Stack.Item>
                    <Pill selected={erectMode === 'hard'} onClick={() => onSetErectState(org.id, 'hard')}>
                      КРЕПКИЙ
                    </Pill>
                  </Stack.Item>
                </Stack>
              </Box>
            )}

            {fullness > 0 && (
              <Box mt={0.25} textAlign="right" style={{ fontSize: 10 }} color="label">
                Заполненность: {Math.round(fullness)}%
              </Box>
            )}

            {affecting.length ? (
              <Stack vertical mt={0.5}>
                {affecting.map((l) => {
                  const whoLabel = partnerLabel || 'Партнёр';
                  return (
                    <Box key={l.id} ml={1}>
                      <Box as="span" color="label">
                        {whoLabel}:{' '}
                      </Box>
                      {l.action_name || '—'}{' '}
                      <Box as="span" color="label">
                        ({speedName(l.speed)}, {forceName(l.force)})
                      </Box>
                    </Box>
                  );
                })}
              </Stack>
            ) : (
              <Box ml={1} color="label">
                Нет активных воздействий.
              </Box>
            )}
          </Box>
        );
      })}
    </Section>
  );
};

const SensitivityInline: React.FC<{
  sensitivity?: number;
  disabled?: boolean;
  onEdit: () => void;
}> = ({ sensitivity, disabled, onEdit }) => (
  <Button inline compact color="transparent" disabled={disabled} onClick={onEdit}>
    ЧУВСТВИТЕЛЬН.: {disabled ? '—' : fmt2(sensitivity) ?? 0}
  </Button>
);

const ActiveLinksPanel: React.FC<{
  data: SexSessionData;
  actorOrgans: OrgNode[];
  partnerOrgans: OrgNode[];
  onSetSpeed: (id: string, value: number) => void;
  onSetForce: (id: string, value: number) => void;
  onToggleFinished: (id: string) => void;
  onStop: (id: string) => void;
  onEditSensitivity: (id: string) => void;
  hasKnottedPenis?: boolean;
  canKnotNow?: boolean;
  doKnotAction?: boolean;
  onToggleKnot?: () => void;
}> = ({
  data,
  actorOrgans,
  partnerOrgans,
  onSetSpeed,
  onSetForce,
  onToggleFinished,
  onStop,
  onEditSensitivity,
  hasKnottedPenis,
  canKnotNow,
  doKnotAction,
  onToggleKnot,
}) => {
  const links = data.active_links || [];
  if (!links.length) return null;

  const showKnotToggle = Boolean(hasKnottedPenis && canKnotNow && onToggleKnot);

  const getOrg = (id: string, list: OrgNode[]) => list.find((o) => o.id === id);

  return (
    <Stack vertical>
      {showKnotToggle && (
        <Box mb={0.5} textAlign="center">
          <Button inline compact selected={!!doKnotAction} onClick={onToggleKnot}>
            {doKnotAction ? 'ДО УЗЛА' : 'БЕЗ УЗЛА'}
          </Button>
        </Box>
      )}

      {links.map((link) => {
        const actorOrg = getOrg(link.actor_organ_id, actorOrgans);
        const partnerOrg = getOrg(link.partner_organ_id, partnerOrgans);
        const speedIdx = Math.max(1, Math.min(4, link.speed)) - 1;
        const forceIdx = Math.max(1, Math.min(4, link.force)) - 1;

        return (
          <Section
            key={link.id}
            style={{
              marginBottom: 1,
              paddingTop: 1,
              paddingBottom: 1,
            }}
          >
            <Stack align="center" justify="space-between">
              <Stack.Item shrink>
                <Box bold>{actorOrg ? actorOrg.name : '—'}</Box>
              </Stack.Item>

              <Stack.Item>
                <Button inline compact onClick={() => onSetSpeed(link.id, link.speed - 1)}>
                  {'<'}
                </Button>{' '}
                <Box
                  as="span"
                  bold
                  style={{
                    color: speedColors[speedIdx],
                    display: 'inline-block',
                    minWidth: 110,
                    textAlign: 'center',
                  }}
                >
                  {data.speed_names[speedIdx]}
                </Box>{' '}
                <Button inline compact onClick={() => onSetSpeed(link.id, link.speed + 1)}>
                  {'>'}
                </Button>
              </Stack.Item>

              <Stack.Item grow>
                <Box textAlign="center">
                  <Button inline compact color="transparent" selected onClick={() => onStop(link.id)}>
                    {link.action_name || 'ДЕЙСТВИЕ'}
                  </Button>
                </Box>
              </Stack.Item>

              <Stack.Item>
                <Button inline compact onClick={() => onSetForce(link.id, link.force - 1)}>
                  {'<'}
                </Button>{' '}
                <Box
                  as="span"
                  bold
                  style={{
                    color: forceColors[forceIdx],
                    display: 'inline-block',
                    minWidth: 90,
                    textAlign: 'center',
                  }}
                >
                  {data.force_names[forceIdx]}
                </Box>{' '}
                <Button inline compact onClick={() => onSetForce(link.id, link.force + 1)}>
                  {'>'}
                </Button>
              </Stack.Item>

              <Stack.Item shrink>
                <Box bold>{partnerOrg ? partnerOrg.name : '—'}</Box>
              </Stack.Item>
            </Stack>
            <Box mt={0.5} textAlign="center">
              <Stack justify="center" align="center">
                <Stack.Item style={{ marginInline: 12 }}>
                  <Button inline compact color="transparent" onClick={() => onToggleFinished(link.id)}>
                    {link.do_until_finished ? 'ДО ЗАВЕРШЕНИЯ' : 'ПОКА НЕ ОСТАНОВЛЮСЬ'}
                  </Button>
                </Stack.Item>

                <Stack.Item style={{ marginInline: 12 }}>
                  <SensitivityInline
                    sensitivity={link.sensitivity}
                    disabled={!partnerOrg}
                    onEdit={() => onEditSensitivity(link.id)}
                  />
                </Stack.Item>

                <Stack.Item style={{ marginInline: 12 }}>
                  <Button inline compact color="transparent" onClick={() => onStop(link.id)}>
                    ОСТАНОВИТЬСЯ
                  </Button>
                </Stack.Item>
              </Stack>
            </Box>
          </Section>
        );
      })}
    </Stack>
  );
};

const ActionsFilter: React.FC<{
  searchText: string;
  onSearchChange: (value: string) => void;
  availableTags: string[];
  activeTags: string[];
  onToggleTag: (tag: string) => void;
}> = ({ searchText, onSearchChange, availableTags, activeTags, onToggleTag }) => (
  <Section title="ДОСТУПНЫЕ ДЕЙСТВИЯ">
    <Input
      fluid
      placeholder="Поиск взаимодействия..."
      value={searchText}
      onChange={(value) => onSearchChange(value)}
    />
    {!!availableTags.length && (
      <Box mt={1}>
        <Stack wrap>
          {availableTags.map((tag) => (
            <Stack.Item key={tag}>
              <Pill selected={activeTags.includes(tag)} onClick={() => onToggleTag(tag)}>
                {tag}
              </Pill>
            </Stack.Item>
          ))}
        </Stack>
      </Box>
    )}
  </Section>
);

const ActionsList: React.FC<{
  actorSelected?: OrgNode;
  partnerSelected?: OrgNode;
  actions: SexAction[];
  currentActionTypes?: string[];
  canPerform: string[];
  onClickAction: (type: string) => void;
}> = ({ actorSelected, partnerSelected, actions, currentActionTypes, canPerform, onClickAction }) => {
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
  const activeSet = new Set(currentActionTypes ?? []);

  const renderButton = (action: SexAction) => {
    const isCurrent = activeSet.has(action.type);
    const isAvailable = canPerform.includes(action.type);

    const style: CSSProperties = {
      justifyContent: 'center',
      minWidth: 100,
      width: '100%',
      whiteSpace: 'normal',
      wordBreak: 'break-word',
      lineHeight: 1.5,
      background: isCurrent
        ? 'var(--button-background-selected)'
        : isAvailable
          ? 'var(--button-background)'
          : 'rgba(0, 0, 0, 0.3)',
      boxShadow: isCurrent ? '0 0 8px var(--button-background-selected)' : undefined,
      color: !isAvailable ? 'var(--color-label)' : 'var(--color-text)',
      textAlign: 'center',
    };

    return (
      <Button
        key={action.type}
        fluid
        color="transparent"
        selected={isCurrent}
        disabled={!isAvailable}
        onClick={() => onClickAction(action.type)}
        style={style}
      >
        {action.name}
      </Button>
    );
  };

  return (
    <Section fill scrollable>
      {!actorSelected || !partnerSelected ? (
        <NoticeBox info>Выберите по одному органу слева и справа, чтобы увидеть доступные действия.</NoticeBox>
      ) : singleColumn ? (
        <Stack fill>
          <Stack.Item basis="100%">
            <Stack vertical>
              {actions.map((action) => (
                <Stack.Item key={action.type}>{renderButton(action)}</Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
        </Stack>
      ) : (
        <Stack fill>
          <Stack.Item basis="50%">
            <Stack vertical>
              {leftColumn.map((action) => (
                <Stack.Item key={action.type}>{renderButton(action)}</Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
          <Stack.Item basis="50%">
            <Stack vertical>
              {rightColumn.map((action) => (
                <Stack.Item key={action.type}>{renderButton(action)}</Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
        </Stack>
      )}
    </Section>
  );
};

const BottomControls: React.FC<{
  yieldToPartner?: boolean;
  frozen?: boolean;
  suppressMoans?: boolean;
  hiddenMode?: boolean;
  onFlipPose: () => void;
  onStopAll: () => void;
  onToggleYield: () => void;
  onToggleFreeze: () => void;
  onToggleMoans: () => void;
  onToggleHiddenMode: () => void;
}> = ({
  yieldToPartner,
  frozen,
  suppressMoans,
  hiddenMode,
  onFlipPose,
  onStopAll,
  onToggleYield,
  onToggleFreeze,
  onToggleMoans,
  onToggleHiddenMode,
}) => (
  <Section>
    <Stack vertical align="center" justify="center">
      <Stack justify="center" wrap>
        <Stack.Item style={{ marginInline: 2, marginBlock: 1 }}>
          <Button onClick={onFlipPose}>ПЕРЕВЕРНУТЬСЯ</Button>
        </Stack.Item>
        <Stack.Item style={{ marginInline: 2, marginBlock: 1 }}>
          <Button onClick={onStopAll}>ОСТАНОВИТЬСЯ</Button>
        </Stack.Item>
      </Stack>

      <Stack justify="center" wrap>
        <Stack.Item style={{ marginInline: 2, marginBlock: 1 }}>
          <Pill selected={!!frozen} onClick={onToggleFreeze}>
            {frozen ? 'НЕ ВОЗБУЖДАЕТСЯ' : 'ВОЗБУЖДАЕТСЯ'}
          </Pill>
        </Stack.Item>
        <Stack.Item style={{ marginInline: 2, marginBlock: 1 }}>
          <Pill selected={!!yieldToPartner} onClick={onToggleYield}>
            {yieldToPartner ? 'ПОДДАЕТСЯ' : 'НЕ ПОДДАЕТСЯ'}
          </Pill>
        </Stack.Item>
        <Stack.Item style={{ marginInline: 2, marginBlock: 1 }}>
          <Pill selected={!!suppressMoans} onClick={onToggleMoans}>
            {suppressMoans ? 'НЕ СТОНЕТ' : 'СТОНЕТ'}
          </Pill>
        </Stack.Item>
        <Stack.Item style={{ marginInline: 2, marginBlock: 1 }}>
          <Pill selected={!!hiddenMode} onClick={onToggleHiddenMode}>
            {hiddenMode ? 'СКРЫТНО' : 'ОТКРЫТО'}
          </Pill>
        </Stack.Item>
      </Stack>
    </Stack>
  </Section>
);

type EditContext =
  | { kind: 'arousal_actor' }
  | { kind: 'link_sens'; id: string }
  | { kind: 'organ'; id: string; field: 'sensitivity' | 'pain' };

const prefText = (v?: number | null) => {
  if (v === undefined || v === null) return '—';
  if (v <= -1) return 'НЕ НРАВИТСЯ';
  if (v >= 1) return 'НРАВИТСЯ';
  return 'НЕЙТРАЛЬНО';
};

const prefColor = (v?: number | null) => {
  if (v === undefined || v === null) return 'label';
  if (v <= -1) return 'bad';
  if (v >= 1) return 'good';
  return 'label';
};

const KinkCard: React.FC<{
  kink: KinkEntry;
  onSet: (type: string, value: number) => void;
  partnerLabel?: string;
}> = ({ kink, onSet, partnerLabel }) => {
  const pref = kink.pref ?? 0;

  const badgeStyle: CSSProperties = {
    display: 'inline-block',
    padding: '2px 8px',
    borderRadius: 9999,
    border: '1px solid rgba(255,255,255,0.18)',
    background: 'rgba(255,255,255,0.04)',
    fontSize: 10,
    lineHeight: 1.2,
  };

  const pp = (kink as any).partner_pref;
  const known = pp !== null && pp !== undefined;

  return (
    <Section
      style={{ paddingTop: 4, paddingBottom: 4, marginBottom: 6 }}
      title={
        <Stack align="center" justify="space-between">
          <Stack.Item>
            <Box bold style={{ fontSize: 13, lineHeight: 1.2 }}>
              {kink.name}
            </Box>
          </Stack.Item>
        </Stack>
      }
    >
      <Stack align="center" justify="space-between" wrap>
        {/* LEFT: player settings */}
        <Stack.Item>
          <Box color="label" style={{ fontSize: 10, textTransform: 'uppercase' }} mb={0.25}>
            Мой выбор
          </Box>
          <Stack>
            <Stack.Item>
              <Pill selected={pref <= -1} onClick={() => onSet(kink.type, -1)}>
                Не нравится
              </Pill>
            </Stack.Item>
            <Stack.Item>
              <Pill selected={pref === 0} onClick={() => onSet(kink.type, 0)}>
                Нейтрально
              </Pill>
            </Stack.Item>
            <Stack.Item>
              <Pill selected={pref >= 1} onClick={() => onSet(kink.type, 1)}>
                Нравится
              </Pill>
            </Stack.Item>
          </Stack>
        </Stack.Item>

        {/* RIGHT: partner pref */}
        <Stack.Item>
          <Box color="label" style={{ fontSize: 10, textTransform: 'uppercase' }} mb={0.25} textAlign="right">
            {partnerLabel || 'Партнёр'}
          </Box>
          <Box textAlign="right" style={badgeStyle} color={known ? prefColor(pp) : 'label'}>
            {known ? prefText(pp) : '—'}
          </Box>
        </Stack.Item>
      </Stack>

      {!!kink.description && (
        <Box mt={0.5} color="label" style={{ fontSize: 12, lineHeight: 1.35 }}>
          {kink.description}
        </Box>
      )}
    </Section>
  );
};

const KinksTab: React.FC<{
  data: SexSessionData;
  act: (verb: string, args?: any) => void;
}> = ({ data, act }) => {
  const entries = data.kinks?.entries ?? [];

  const [q, setQ] = useState('');
  const [cat, setCat] = useState<string>('ALL');

  const categories = useMemo(() => {
    const set = new Set<string>();
    for (const k of entries) {
      if (k.category) set.add(k.category);
    }
    return ['ALL', ...Array.from(set).sort((a, b) => a.localeCompare(b))];
  }, [entries]);

  const filtered = useMemo(() => {
    const qq = q.trim().toLowerCase();
    return entries
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
  }, [entries, q, cat]);

  const onSet = (type: string, value: number) => {
    act('set_kink_pref', { type, value });
  };

  if (!entries.length) {
    return (
      <Section title="Фетиши" fill>
        <NoticeBox info>Фетиши не загрузились или список пуст.</NoticeBox>
      </Section>
    );
  }

  const partnerLabel = data.partner_name || 'Партнёр';

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="Фетиши">
          <Stack vertical>
            <Stack.Item>
              <Input
                fluid
                placeholder="Поиск по кинкам..."
                value={q}
                onChange={(v) => setQ(v)}
              />
            </Stack.Item>

            <Stack.Item mt={0.5}>
              <Stack wrap>
                {categories.map((c) => (
                  <Stack.Item key={c} style={{ margin: 2 }}>
                    <Pill selected={cat === c} onClick={() => setCat(c)}>
                      {c}
                    </Pill>
                  </Stack.Item>
                ))}
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        <Section fill scrollable title={`Настройки (${filtered.length}/${entries.length})`}>
          {filtered.length ? (
            filtered.map((k) => (
              <KinkCard key={k.type} kink={k} onSet={onSet} partnerLabel={partnerLabel} />
            ))
          ) : (
            <NoticeBox info>Ничего не найдено по фильтрам.</NoticeBox>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

type CustomActionsEditorProps = {
  data: SexSessionData;
  act: (verb: string, args?: any) => void;
};

const CustomActionsEditor: React.FC<CustomActionsEditorProps> = ({ data, act }) => {
  const templates = data.custom_templates ?? [];
  const customs = data.custom_actions ?? [];
  const climaxModes = data.climax_modes ?? [];
  const organTypeOptions = data.organ_type_options ?? [];

  const [selectedTemplate, setSelectedTemplate] = useState<string | null>(null);
  const [selectedCustom, setSelectedCustom] = useState<string | null>(null);

  const [form, setForm] = useState<Partial<SexCustomAction>>({});

  const applyTemplate = (tpl: SexCustomTemplate) => {
    setForm({ ...tpl });
  };

  const currentKind = (() => {
    let src: SexCustomTemplate | SexCustomAction | undefined;
    if (selectedCustom) src = customs.find((c) => c.type === selectedCustom);
    else if (selectedTemplate) src = templates.find((t) => t.type === selectedTemplate);
    return src?.base_kind;
  })();

  const currentKindLabel =
    currentKind === 'self' ? 'Действие для себя' : currentKind === 'other' ? 'Действие для партнёра' : null;

  const applyCustom = (ca: SexCustomAction) => {
    setForm({ ...ca });
  };

  const onSelectTemplate = (type: string) => {
    setSelectedTemplate(type);
    setSelectedCustom(null);
    const tpl = templates.find((t) => t.type === type);
    if (tpl) applyTemplate(tpl);
  };

  const onSelectCustom = (type: string) => {
    setSelectedCustom(type);
    setSelectedTemplate(null);
    const ca = customs.find((c) => c.type === type);
    if (ca) applyCustom(ca);
  };

  const updateField = (field: keyof SexCustomAction, value: any) => {
    setForm((prev) => ({ ...prev, [field]: value }));
  };

  const submitCreate = () => {
    if (!selectedTemplate) return;
    act('custom_create', {
      template_type: selectedTemplate,
      name: form.name,
      stamina_cost: form.stamina_cost,
      affects_self_arousal: form.affects_self_arousal,
      affects_arousal: form.affects_arousal,
      affects_self_pain: form.affects_self_pain,
      affects_pain: form.affects_pain,
      climax_liquid_mode_active: form.climax_liquid_mode_active,
      climax_liquid_mode_passive: form.climax_liquid_mode_passive,
      message_on_start: form.message_on_start,
      message_on_perform: form.message_on_perform,
      message_on_finish: form.message_on_finish,
      message_on_climax_actor: form.message_on_climax_actor,
      message_on_climax_target: form.message_on_climax_target,
      required_init: form.required_init,
      required_target: form.required_target,
      reserve_target_for_session: form.reserve_target_for_session,
      can_knot: form.can_knot,
      check_same_tile: form.check_same_tile,
      break_on_move: form.break_on_move,
      actor_sex_hearts: form.actor_sex_hearts,
      target_sex_hearts: form.target_sex_hearts,
      actor_suck_sound: form.actor_suck_sound,
      target_suck_sound: form.target_suck_sound,
      actor_make_sound: form.actor_make_sound,
      target_make_sound: form.target_make_sound,
      actor_make_fingering_sound: form.actor_make_fingering_sound,
      target_make_fingering_sound: form.target_make_fingering_sound,
      actor_do_onomatopoeia: form.actor_do_onomatopoeia,
      target_do_onomatopoeia: form.target_do_onomatopoeia,
      actor_do_thrust: form.actor_do_thrust,
      target_do_thrust: form.target_do_thrust,
    });
  };

  const submitUpdate = () => {
    if (!selectedCustom) return;
    act('custom_update', {
      type: selectedCustom,
      name: form.name,
      stamina_cost: form.stamina_cost,
      affects_self_arousal: form.affects_self_arousal,
      affects_arousal: form.affects_arousal,
      affects_self_pain: form.affects_self_pain,
      affects_pain: form.affects_pain,
      climax_liquid_mode_active: form.climax_liquid_mode_active,
      climax_liquid_mode_passive: form.climax_liquid_mode_passive,
      message_on_start: form.message_on_start,
      message_on_perform: form.message_on_perform,
      message_on_finish: form.message_on_finish,
      message_on_climax_actor: form.message_on_climax_actor,
      message_on_climax_target: form.message_on_climax_target,
      required_init: form.required_init,
      required_target: form.required_target,
      reserve_target_for_session: form.reserve_target_for_session,
      can_knot: form.can_knot,
      check_same_tile: form.check_same_tile,
      break_on_move: form.break_on_move,
      actor_sex_hearts: form.actor_sex_hearts,
      target_sex_hearts: form.target_sex_hearts,
      actor_suck_sound: form.actor_suck_sound,
      target_suck_sound: form.target_suck_sound,
      actor_make_sound: form.actor_make_sound,
      target_make_sound: form.target_make_sound,
      actor_make_fingering_sound: form.actor_make_fingering_sound,
      target_make_fingering_sound: form.target_make_fingering_sound,
      actor_do_onomatopoeia: form.actor_do_onomatopoeia,
      target_do_onomatopoeia: form.target_do_onomatopoeia,
      actor_do_thrust: form.actor_do_thrust,
      target_do_thrust: form.target_do_thrust,
    });
  };

  const submitDelete = () => {
    if (!selectedCustom) return;
    act('custom_delete', { type: selectedCustom });
  };

  const hasSource = !!(selectedTemplate || selectedCustom);

  return (
    <Section title="Редактор действий" fill scrollable>
      <Stack fill>
        <Stack.Item basis="30%">
          <Section title="Шаблоны">
            {templates.length === 0 ? (
              <Box color="label">Нет доступных шаблонов.</Box>
            ) : (
              <Stack vertical>
                {templates.map((tpl) => (
                  <Stack.Item key={tpl.type}>
                    <Button
                      fluid
                      compact
                      selected={selectedTemplate === tpl.type}
                      onClick={() => onSelectTemplate(tpl.type)}
                    >
                      {tpl.name}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
            )}
          </Section>

          <Section title="Мои кастомные">
            {customs.length === 0 ? (
              <Box color="label">Вы ещё не создали ни одного действия.</Box>
            ) : (
              <Stack vertical>
                {customs.map((ca) => (
                  <Stack.Item key={ca.type}>
                    <Button
                      fluid
                      compact
                      selected={selectedCustom === ca.type}
                      onClick={() => onSelectCustom(ca.type)}
                    >
                      {ca.name}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
            )}
          </Section>
        </Stack.Item>

        <Stack.Item grow basis="70%">
          <Section title="Параметры">
            {!hasSource ? (
              <NoticeBox info>
                Сначала выбери слева шаблон или одно из своих кастомных действий. После этого здесь появятся
                настраиваемые поля.
              </NoticeBox>
            ) : (
              <Stack vertical>
                {currentKindLabel && (
                  <Stack.Item>
                    <Box
                      mb={0.5}
                      textAlign="center"
                      color="label"
                      style={{ fontSize: 11, textTransform: 'uppercase' }}
                    >
                      {currentKindLabel}
                    </Box>
                  </Stack.Item>
                )}

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    Название действия
                  </Box>
                  <Input
                    fluid
                    value={form.name ?? ''}
                    placeholder="Например: Тереться щечкой"
                    onChange={(value) => updateField('name', value)}
                  />
                </Stack.Item>

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    Орган инициатора (откуда)
                  </Box>
                  <Stack wrap>
                    {organTypeOptions.map((opt) => (
                      <Stack.Item key={`init-${opt.id}`} style={{ margin: 2 }}>
                        <Pill
                          selected={form.required_init === opt.id}
                          onClick={() =>
                            updateField(
                              'required_init',
                              opt.id === form.required_init ? undefined : opt.id,
                            )
                          }
                        >
                          {opt.name}
                        </Pill>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    Орган партнёра (куда)
                  </Box>
                  <Stack wrap>
                    {organTypeOptions.map((opt) => (
                      <Stack.Item key={`tgt-${opt.id}`} style={{ margin: 2 }}>
                        <Pill
                          selected={form.required_target === opt.id}
                          onClick={() =>
                            updateField(
                              'required_target',
                              opt.id === form.required_target ? undefined : opt.id,
                            )
                          }
                        >
                          {opt.name}
                        </Pill>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                        Стоимость выносливости (0.1–5.0)
                      </Box>
                      <Input
                        fluid
                        value={String(form.stamina_cost ?? '')}
                        placeholder="По умолчанию как у шаблона"
                        onChange={(value) => updateField('stamina_cost', Number(value) || 0)}
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                        Свое возбуждение
                      </Box>
                      <Input
                        fluid
                        value={String(form.affects_self_arousal ?? '')}
                        placeholder="Сколько тебе добавит"
                        onChange={(value) => updateField('affects_self_arousal', Number(value) || 0)}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                        Возбуждение партнера
                      </Box>
                      <Input
                        fluid
                        placeholder="Возбуждение партнёра"
                        value={String(form.affects_arousal ?? '')}
                        onChange={(value) => updateField('affects_arousal', Number(value) || 0)}
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                        Своя боль
                      </Box>
                      <Input
                        fluid
                        placeholder="Боль себе"
                        value={String(form.affects_self_pain ?? '')}
                        onChange={(value) => updateField('affects_self_pain', Number(value) || 0)}
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                        Боль партнеру
                      </Box>
                      <Input
                        fluid
                        placeholder="Боль партнёру"
                        value={String(form.affects_pain ?? '')}
                        onChange={(value) => updateField('affects_pain', Number(value) || 0)}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    Режим климакса (куда летит жидкость) если оргазмирует актер
                  </Box>
                  <Stack wrap>
                    {climaxModes.map((m) => (
                      <Stack.Item key={m.id} style={{ margin: 2 }}>
                        <Pill
                          selected={form.climax_liquid_mode_active === m.id}
                          onClick={() => updateField('climax_liquid_mode_active', m.id)}
                        >
                          {m.name}
                        </Pill>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    Режим климакса (куда летит жидкость) если оргазмирует партнер
                  </Box>
                  <Stack wrap>
                    {climaxModes.map((m) => (
                      <Stack.Item key={m.id} style={{ margin: 2 }}>
                        <Pill
                          selected={form.climax_liquid_mode_passive === m.id}
                          onClick={() => updateField('climax_liquid_mode_passive', m.id)}
                        >
                          {m.name}
                        </Pill>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Box color="label">
                    Сообщения (можно использовать: {'{actor}'}, {'{partner}'}, {'{pose}'}, {'{force}'},{' '}
                    {'{speed}'}, {'{zone}'}, {'{knot}'}):
                  </Box>
                </Stack.Item>

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    На старте действия
                  </Box>
                  <Input
                    fluid
                    value={form.message_on_start ?? ''}
                    placeholder="Текст, который произойдёт при начале действия"
                    onChange={(value) => updateField('message_on_start', value)}
                  />
                </Stack.Item>

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    Во время действия
                  </Box>
                  <Input
                    fluid
                    value={form.message_on_perform ?? ''}
                    placeholder="Текст, который произойдёт при действии"
                    onChange={(value) => updateField('message_on_perform', value)}
                  />
                </Stack.Item>

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    На завершении действия
                  </Box>
                  <Input
                    fluid
                    value={form.message_on_finish ?? ''}
                    placeholder="Текст, который произойдёт при завершении действия"
                    onChange={(value) => updateField('message_on_finish', value)}
                  />
                </Stack.Item>

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    Оргазм актёра
                  </Box>
                  <Input
                    fluid
                    value={form.message_on_climax_actor ?? ''}
                    placeholder="Текст, который произойдёт при оргазме инициатора"
                    onChange={(value) => updateField('message_on_climax_actor', value)}
                  />
                </Stack.Item>

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    Оргазм партнёра
                  </Box>
                  <Input
                    fluid
                    value={form.message_on_climax_target ?? ''}
                    placeholder="Текст, который произойдёт при оргазме партнера"
                    onChange={(value) => updateField('message_on_climax_target', value)}
                  />
                </Stack.Item>

                <Stack.Item>
                  <Box mb={0.25} color="label" style={{ fontSize: 11 }}>
                    Особые эффекты:
                  </Box>
                  <Stack wrap>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill
                        selected={!!form.reserve_target_for_session}
                        onClick={() => updateField('reserve_target_for_session', !form.reserve_target_for_session)}
                      >
                        БЛОКИРУЕТ ОРГАН ЦЕЛИ
                      </Pill>
                    </Stack.Item>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.can_knot} onClick={() => updateField('can_knot', !form.can_knot)}>
                        ВОЗМОЖЕН УЗЕЛ (АКТЕР)
                      </Pill>
                    </Stack.Item>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.check_same_tile} onClick={() => updateField('check_same_tile', !form.check_same_tile)}>
                        ТОЛЬКО С ОДНОГО ТАЙЛА
                      </Pill>
                    </Stack.Item>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.break_on_move} onClick={() => updateField('break_on_move', !form.break_on_move)}>
                        ПРЕРЫВАЕТСЯ ПРИ ДВИЖЕНИИ
                      </Pill>
                    </Stack.Item>
                  </Stack>

                  <Box mt={0.5} mb={0.25} color="label" style={{ fontSize: 11 }}>
                    Визуал и звуки
                  </Box>
                  <Stack wrap>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.actor_sex_hearts} onClick={() => updateField('actor_sex_hearts', !form.actor_sex_hearts)}>
                        Pop-up Сердца (актер)
                      </Pill>
                    </Stack.Item>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.target_sex_hearts} onClick={() => updateField('target_sex_hearts', !form.target_sex_hearts)}>
                        Pop-up Сердца (партнёр)
                      </Pill>
                    </Stack.Item>
                  </Stack>

                  <Stack wrap>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.actor_suck_sound} onClick={() => updateField('actor_suck_sound', !form.actor_suck_sound)}>
                        Звук сосания (актер)
                      </Pill>
                    </Stack.Item>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.target_suck_sound} onClick={() => updateField('target_suck_sound', !form.target_suck_sound)}>
                        Звук сосания (партнёр)
                      </Pill>
                    </Stack.Item>
                  </Stack>

                  <Stack wrap>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.actor_make_sound} onClick={() => updateField('actor_make_sound', !form.actor_make_sound)}>
                        Звук стонов (актер)
                      </Pill>
                    </Stack.Item>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.target_make_sound} onClick={() => updateField('target_make_sound', !form.target_make_sound)}>
                        Звук стонов (партнёр)
                      </Pill>
                    </Stack.Item>
                  </Stack>

                  <Stack wrap>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill
                        selected={!!form.actor_make_fingering_sound}
                        onClick={() => updateField('actor_make_fingering_sound', !form.actor_make_fingering_sound)}
                      >
                        Звук хлюпов (актер)
                      </Pill>
                    </Stack.Item>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill
                        selected={!!form.target_make_fingering_sound}
                        onClick={() => updateField('target_make_fingering_sound', !form.target_make_fingering_sound)}
                      >
                        Звук хлюпов (партнёр)
                      </Pill>
                    </Stack.Item>
                  </Stack>

                  <Stack wrap>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill
                        selected={!!form.actor_do_onomatopoeia}
                        onClick={() => updateField('actor_do_onomatopoeia', !form.actor_do_onomatopoeia)}
                      >
                        Pop-up текст (актер)
                      </Pill>
                    </Stack.Item>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill
                        selected={!!form.target_do_onomatopoeia}
                        onClick={() => updateField('target_do_onomatopoeia', !form.target_do_onomatopoeia)}
                      >
                        Pop-up текст (партнёр)
                      </Pill>
                    </Stack.Item>
                  </Stack>

                  <Stack wrap>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.actor_do_thrust} onClick={() => updateField('actor_do_thrust', !form.actor_do_thrust)}>
                        Толчки куклы (актер)
                      </Pill>
                    </Stack.Item>
                    <Stack.Item style={{ margin: 2 }}>
                      <Pill selected={!!form.target_do_thrust} onClick={() => updateField('target_do_thrust', !form.target_do_thrust)}>
                        Толчки куклы (партнёр)
                      </Pill>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Box mt={1} textAlign="right">
                    <Button disabled={!selectedTemplate} onClick={submitCreate}>
                      СОЗДАТЬ КАСТОМ
                    </Button>{' '}
                    <Button disabled={!selectedCustom} onClick={submitUpdate}>
                      СОХРАНИТЬ ИЗМЕНЕНИЯ
                    </Button>{' '}
                    <Button disabled={!selectedCustom} color="bad" onClick={submitDelete}>
                      УДАЛИТЬ
                    </Button>
                  </Box>
                </Stack.Item>
              </Stack>
            )}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const EroticRolePlayPanel: React.FC = () => {
  const { act, data } = useBackend<SexSessionData>();

  const partners = data.partners ?? [];
  const actorOrgansBase = data.actor_organs ?? [];
  const partnerOrgans = data.partner_organs ?? [];
  const statusOrgans = data.status_organs ?? [];

  const actions = data.actions ?? [];
  const canPerform = data.can_perform ?? [];
  const availableTags = data.available_tags ?? [];
  const organFilteredTypes = data.organ_filtered ?? [];
  const actorCharge = data.actor_charge ?? 0;
  const actorCharge_max = data.actor_charge_max ?? 0;
  const actorCharge_for_climax = data.actor_charge_for_climax ?? 0;

  const [searchText, setSearchText] = useState('');
  const [activeTags, setActiveTags] = useState<string[]>([]);
  const [activeTab, setActiveTab] = useState<'status' | 'actions' | 'kinks' | 'editor'>('actions');

  const [editContext, setEditContext] = useState<EditContext | null>(null);
  const [editTitle, setEditTitle] = useState('');
  const [editValue, setEditValue] = useState('');

  const toggleTag = (tag: string) => {
    setActiveTags((prev) => (prev.includes(tag) ? prev.filter((t) => t !== tag) : [...prev, tag]));
  };

  const actorSelected = useMemo(
    () => actorOrgansBase.find((o) => o.id === data.selected_actor_organ),
    [actorOrgansBase, data.selected_actor_organ],
  );

  const partnerSelected = useMemo(
    () => partnerOrgans.find((o) => o.id === data.selected_partner_organ),
    [partnerOrgans, data.selected_partner_organ],
  );

  const currentPartner = useMemo(() => {
    if (!partners.length) return null;
    return partners.find((p) => p.ref === data.current_partner_ref) || partners[0];
  }, [partners, data.current_partner_ref]);

  const filteredActions = useMemo(() => {
    const q = searchText.trim().toLowerCase();

    return actions.filter((a) => {
      if (q && !a.name.toLowerCase().includes(q)) return false;

      if (activeTags.length && !(a.tags || []).some((t) => activeTags.includes(t))) return false;

      if (organFilteredTypes.length && !organFilteredTypes.includes(a.type)) return false;

      if (!actorSelected || !partnerSelected) return false;

      return true;
    });
  }, [actions, searchText, activeTags, organFilteredTypes, actorSelected, partnerSelected]);

  const onClickActionButton = (actionType: string) => {
    act('start_action', { action_type: actionType });
  };

  const actorArousalWidth = Math.max(0, Math.min(100, data.actor_arousal ?? 0));
  const partnerArousalWidth = Math.max(0, Math.min(100, data.partner_arousal ?? 0));

  const showPartnerBar = !!(typeof data.partner_arousal === 'number' && !data.partner_arousal_hidden);

  const openNumericModal = (ctx: EditContext, title: string, initial: number) => {
    setEditContext(ctx);
    setEditTitle(title);
    setEditValue(String(Math.round(initial)));
  };

  const handleNumericConfirm = () => {
    if (!editContext) return;
    const num = Number(editValue);
    if (Number.isNaN(num)) {
      setEditContext(null);
      return;
    }

    switch (editContext.kind) {
      case 'arousal_actor':
        act('set_arousal_value', { target: 'actor', amount: num });
        break;
      case 'link_sens':
        act('set_link_tuning', { id: editContext.id, field: 'sensitivity', value: num });
        break;
      case 'organ':
        act('set_organ_tuning', { id: editContext.id, field: editContext.field, value: num });
        break;
    }

    setEditContext(null);
  };

  const handleNumericCancel = () => {
    setEditContext(null);
  };

  const startEditArousalActor = () => {
    openNumericModal({ kind: 'arousal_actor' }, 'Возбуждение 0–100', data.actor_arousal ?? 0);
  };

  const editTuningForLink = (linkId: string) => {
    const link = (data.active_links || []).find((l) => l.id === linkId);
    openNumericModal({ kind: 'link_sens', id: linkId }, 'Чувствительность 0–2', link?.sensitivity ?? 0);
  };

  const editOrganField = (id: string, field: 'sensitivity' | 'pain') => {
    const org = statusOrgans.find((o) => o.id === id);
    const current = field === 'sensitivity' ? org?.sensitivity ?? 0 : org?.pain ?? 0;
    const title = field === 'sensitivity' ? 'Чувствительность 0–2' : 'Боль 0–2';
    openNumericModal({ kind: 'organ', id, field }, title, current);
  };

  return (
    <Window title="Утолить Желания" width={650} height={900}>
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              {!!partners.length && (
                <Box mt={0.5}>
                  <PartnerSelector
                    actorName={data.actor_name}
                    partners={partners}
                    currentRef={data.current_partner_ref}
                    onChange={(ref) => act('set_partner', { ref })}
                  />
                </Box>
              )}

              <ArousalBars
                actorName={data.actor_name}
                partnerLabel={currentPartner?.name || 'Партнёр'}
                actorArousal={actorArousalWidth}
                partnerArousal={partnerArousalWidth}
                showPartnerBar={showPartnerBar}
                onSetActor={startEditArousalActor}
              />

              <Box mt={0.5}>
                <Stack justify="center" wrap>
                  <Stack.Item style={{ marginInline: 4 }}>
                    <Button selected={activeTab === 'status'} onClick={() => setActiveTab('status')}>
                      СТАТУС
                    </Button>
                  </Stack.Item>
                  <Stack.Item style={{ marginInline: 4 }}>
                    <Button selected={activeTab === 'actions'} onClick={() => setActiveTab('actions')}>
                      ДЕЙСТВИЯ
                    </Button>
                  </Stack.Item>
                  <Stack.Item style={{ marginInline: 4 }}>
                    <Button selected={activeTab === 'kinks'} onClick={() => setActiveTab('kinks')}>
                      ФЕТИШИ
                    </Button>
                  </Stack.Item>
                  <Stack.Item style={{ marginInline: 4 }}>
                    <Button selected={activeTab === 'editor'} onClick={() => setActiveTab('editor')}>
                      РЕДАКТОР
                    </Button>
                  </Stack.Item>
                </Stack>
              </Box>
            </Section>
          </Stack.Item>

          {activeTab === 'status' && (
            <Stack.Item grow>
              <Stack.Item>
                <Section>
                  <Box textAlign="center" color="label">
                    Заряд: {Math.round(actorCharge)} ({actorCharge_for_climax} для оргазма, {actorCharge_max} максимум)
                  </Box>
                </Section>
              </Stack.Item>
              <StatusPanel
                data={data}
                actorOrgans={statusOrgans}
                actorName={data.actor_name}
                partnerLabel={currentPartner?.name}
                editable
                onEditOrgan={editOrganField}
                onSetErectState={(id, state) => act('toggle_erect', { id, state })}
              />
            </Stack.Item>
          )}

          {activeTab === 'actions' && (
            <>
              <Stack.Item style={{ marginTop: 4 }}>
                <BottomControls
                  yieldToPartner={data.yield_to_partner}
                  frozen={data.frozen}
                  suppressMoans={!data.allow_user_moan}
                  hiddenMode={data.hidden_mode}
                  onFlipPose={() => act('flip', { dir: 1 })}
                  onStopAll={() => act('stop_all')}
                  onToggleYield={() => act('quick', { op: 'yield' })}
                  onToggleFreeze={() => act('freeze_arousal')}
                  onToggleMoans={() => act('toggle_moan')}
                  onToggleHiddenMode={() => act('toggle_hidden')}
                />
              </Stack.Item>

              <Stack.Item style={{ marginTop: 4 }}>
                <Section>
                  <Stack fill align="stretch">
                    <Stack.Item basis="18%">
                      <OrganList
                        title="Я"
                        organs={actorOrgansBase}
                        selectedId={data.selected_actor_organ}
                        onSelect={(id) => act('select_organ', { side: 'actor', id })}
                      />
                    </Stack.Item>

                    <Stack.Item grow>
                      <Stack vertical fill>
                        <Stack.Item>
                          <ActionsFilter
                            searchText={searchText}
                            onSearchChange={setSearchText}
                            availableTags={availableTags}
                            activeTags={activeTags}
                            onToggleTag={toggleTag}
                          />
                        </Stack.Item>
                        <Stack.Item grow>
                          <ActionsList
                            actorSelected={actorSelected}
                            partnerSelected={partnerSelected}
                            actions={filteredActions}
                            currentActionTypes={data.current_actions ?? []}
                            canPerform={canPerform}
                            onClickAction={onClickActionButton}
                          />
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>

                    <Stack.Item basis="18%">
                      <OrganList
                        title={currentPartner ? 'Партнёр' : '—'}
                        organs={partnerOrgans}
                        selectedId={data.selected_partner_organ}
                        onSelect={(id) => act('select_organ', { side: 'partner', id })}
                      />
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>

              <Stack.Item style={{ marginTop: 4 }}>
                <ActiveLinksPanel
                  data={data}
                  actorOrgans={actorOrgansBase}
                  partnerOrgans={partnerOrgans}
                  onSetSpeed={(id, value) => act('set_link_speed', { id, value })}
                  onSetForce={(id, value) => act('set_link_force', { id, value })}
                  onToggleFinished={(id) => act('toggle_link_finished', { id })}
                  onStop={(id) => act('stop_link', { id })}
                  onEditSensitivity={editTuningForLink}
                  hasKnottedPenis={data.has_knotted_penis}
                  canKnotNow={data.can_knot_now}
                  doKnotAction={data.do_knot_action}
                  onToggleKnot={() => act('toggle_knot')}
                />
              </Stack.Item>
            </>
          )}

          {activeTab === 'kinks' && (
            <Stack.Item grow>
              <KinksTab data={data} act={act} />
            </Stack.Item>
          )}

          {activeTab === 'editor' && (
            <Stack.Item grow>
              <CustomActionsEditor data={data} act={act} />
            </Stack.Item>
          )}
        </Stack>

        <Divider />
      </Window.Content>

      {editContext && (
        <Modal>
          <Section title={editTitle}>
            <Input autoFocus value={editValue} onChange={(value) => setEditValue(value)} />
            <Box mt={1} textAlign="right">
              <Button onClick={handleNumericCancel}>Отмена</Button>{' '}
              <Button onClick={handleNumericConfirm}>OK</Button>
            </Box>
          </Section>
        </Modal>
      )}
    </Window>
  );
};

export default EroticRolePlayPanel;
