import type { Dispatch, MutableRefObject, SetStateAction } from 'react';
import { memo, useEffect, useMemo, useRef, useState } from 'react';

import { Icon } from 'tgui-core/components';

import { backendSuspendStart, globalStore, useBackend } from '../backend';
import { Window } from '../layouts';

type FamilyType = 'none' | 'member';
type SpeciesMode = 'ANY' | 'SAME_TYPE' | 'SPECIFIC_TYPE';
type GenderPref = 'any' | 'same' | 'opposite';
type AnatomyPref = 0 | 1 | 2;
type PolygamyMode = 0 | 1 | 2 | 3;
type RelativeRole = 0 | 1 | 2 | 3 | 4 | 5;

type Option<T extends string | number> = {
  value: T;
  label: string;
  icon?: string;
};

type FamilySettingsData = {
  familyType?: FamilyType;
  genderPreference?: GenderPref;
  speciesPreferenceMode?: SpeciesMode;
  preferredSpeciesTypes?: string[];
  preferredSpeciesAnatomy?: AnatomyPref;
  favoriteName?: string;
  age?: string;
  polygamyMode?: PolygamyMode;
  desiredRelativeRole?: RelativeRole;
  allowLowStatusMarriage?: number;
  allowRelativesInFamily?: number;
  knowYourFate?: number;
  fatherName?: string;
  motherName?: string;
  fatherSpecies?: string;
  motherSpecies?: string;
  randomSiblings?: number;
  randomChildren?: number;
  isDonator?: number;
  maxRandomRelatives?: number;
};

type BackendData = {
  familySettings?: FamilySettingsData;
  availableSpecies?: string[];
};

type FamilyTypeCard = {
  value: FamilyType;
  title: string;
  desc: string;
  icon: string;
  tooltip?: string;
};

const FAMILY_TYPE_CARDS: FamilyTypeCard[] = [
  {
    value: 'none',
    title: 'Без семьи',
    desc: 'Одиночка',
    icon: 'ban',
    tooltip:
      'Персонаж не участвует в семейной системе. Никаких авто-матчей, родственников или уведомлений на этот раунд.',
  },
  {
    value: 'member',
    title: 'Участвовать в семье',
    desc: 'Система сначала присоединит к существующему дому, иначе создаст новый',
    icon: 'house-chimney-user',
    tooltip:
      'Система постарается мягко наполнить существующую семью — добавит вас как родственника или супруга по совместимости. Если подходящего дома нет, найдёт партнёра и поможет основать новый дом. Учитываются раса, пол, статус роли и ваше избранное имя.',
  },
];

const GENDER_OPTIONS: Option<GenderPref>[] = [
  { value: 'any', label: 'Любой пол' },
  { value: 'same', label: 'Тот же пол' },
  { value: 'opposite', label: 'Противоположный' },
];

const SPECIES_OPTIONS: Option<SpeciesMode>[] = [
  { value: 'ANY', label: 'Любые виды' },
  { value: 'SAME_TYPE', label: 'Тот же вид' },
  { value: 'SPECIFIC_TYPE', label: 'Определённые виды' },
];

const ANATOMY_OPTIONS: Option<AnatomyPref>[] = [
  { value: 0, label: 'Любая' },
  { value: 1, label: 'Мужская' },
  { value: 2, label: 'Женская' },
];

const POLYGAMY_OPTIONS: Option<PolygamyMode>[] = [
  { value: 0, label: 'Моногамия' },
  { value: 1, label: 'Несколько супругов' },
  { value: 2, label: 'Быть вторым супругом' },
  { value: 3, label: 'Обе опции' },
];

const RELATIVE_ROLE_OPTIONS: Option<RelativeRole>[] = [
  { value: 0, label: 'Автоопределение' },
  { value: 1, label: 'Брат / сестра' },
  { value: 2, label: 'Родитель' },
  { value: 3, label: 'Ребёнок' },
  { value: 4, label: 'Дядя / тётя' },
  { value: 5, label: 'Супруг' },
];

function findLabel<T extends string | number>(
  opts: Option<T>[],
  value: T | undefined,
): string {
  const opt = opts.find((o) => o.value === value);
  return opt ? opt.label : '';
}

type SelectFieldProps<T extends string | number> = {
  label: string;
  icon: string;
  value: T;
  options: Option<T>[];
  onChange: Dispatch<SetStateAction<T>>;
  disabled?: boolean;
};

function SelectField<T extends string | number>(props: SelectFieldProps<T>) {
  const { label, icon, value, options, onChange, disabled } = props;
  const [open, setOpen] = useState(false);
  const wrapRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    if (!open) return;
    const onDocClick = (e: MouseEvent) => {
      if (!wrapRef.current) return;
      if (!wrapRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', onDocClick);
    return () => document.removeEventListener('mousedown', onDocClick);
  }, [open]);

  const selectedLabel = findLabel(options, value);
  const cls =
    'FamilySettingsPanel__select' +
    (open ? ' FamilySettingsPanel__select--open' : '') +
    (disabled ? ' FamilySettingsPanel__select--disabled' : '');

  return (
    <div className="FamilySettingsPanel__field">
      <div className="FamilySettingsPanel__field-label">{label}</div>
      <div ref={wrapRef} className={cls}>
        <div
          className="FamilySettingsPanel__select-control"
          role="button"
          tabIndex={disabled ? -1 : 0}
          onClick={() => !disabled && setOpen((v) => !v)}>
          <span className="FamilySettingsPanel__field-icon">
            <Icon name={icon} />
          </span>
          <span className="FamilySettingsPanel__select-value">
            {selectedLabel}
          </span>
          <span className="FamilySettingsPanel__select-arrow">
            <Icon name={open ? 'chevron-up' : 'chevron-down'} />
          </span>
        </div>
        {open && !disabled && (
          <div className="FamilySettingsPanel__select-menu">
            {options.map((opt) => {
              const selected = opt.value === value;
              const optCls =
                'FamilySettingsPanel__select-option' +
                (selected ? ' FamilySettingsPanel__select-option--selected' : '');
              return (
                <div
                  key={String(opt.value)}
                  className={optCls}
                  onClick={() => {
                    onChange(opt.value);
                    setOpen(false);
                  }}>
                  {opt.label}
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}

type CheckboxRowProps = {
  icon: string;
  label: string;
  tooltip?: string;
  checked: boolean;
  onToggle: () => void;
};

const CheckboxRow = memo(function CheckboxRow(props: CheckboxRowProps) {
  const { icon, label, tooltip, checked, onToggle } = props;
  return (
    <div
      className="FamilySettingsPanel__checkbox-row"
      title={tooltip}
      onClick={onToggle}>
      <div className="FamilySettingsPanel__checkbox-icon">
        <Icon name={icon} />
      </div>
      <div className="FamilySettingsPanel__checkbox-label">{label}</div>
      <div
        className={`FamilySettingsPanel__checkbox-box${
          checked ? ' FamilySettingsPanel__checkbox-box--checked' : ''
        }`}>
        {checked && <Icon name="check" />}
      </div>
    </div>
  );
});

type ParentSpeciesFieldProps = {
  label: string;
  value: string;
  onChange: Dispatch<SetStateAction<string>>;
  availableSpecies: string[];
  open: boolean;
  setOpen: Dispatch<SetStateAction<boolean>>;
  pickerRef: MutableRefObject<HTMLDivElement | null>;
};

function ParentSpeciesField(props: ParentSpeciesFieldProps) {
  const { label, value, onChange, availableSpecies, open, setOpen, pickerRef } =
    props;
  const displayValue = value || 'Любая (как у потомка)';
  const cls =
    'FamilySettingsPanel__select' +
    (open ? ' FamilySettingsPanel__select--open' : '');
  return (
    <div ref={pickerRef} className="FamilySettingsPanel__field">
      <div className="FamilySettingsPanel__field-label">{label}</div>
      <div className={cls}>
        <div
          className="FamilySettingsPanel__select-control"
          role="button"
          tabIndex={0}
          onClick={() => setOpen((v) => !v)}>
          <span className="FamilySettingsPanel__field-icon">
            <Icon name="dna" />
          </span>
          <span className="FamilySettingsPanel__select-value">
            {displayValue}
          </span>
          <span className="FamilySettingsPanel__select-arrow">
            <Icon name={open ? 'chevron-up' : 'chevron-down'} />
          </span>
        </div>
        {open && (
          <div className="FamilySettingsPanel__select-menu">
            <div
              key="__any__"
              className={
                'FamilySettingsPanel__select-option' +
                (!value ? ' FamilySettingsPanel__select-option--selected' : '')
              }
              onClick={() => {
                onChange('');
                setOpen(false);
              }}>
              Любая (как у потомка)
            </div>
            {availableSpecies.map((sp) => {
              const selected = sp === value;
              const optCls =
                'FamilySettingsPanel__select-option' +
                (selected ? ' FamilySettingsPanel__select-option--selected' : '');
              return (
                <div
                  key={sp}
                  className={optCls}
                  onClick={() => {
                    onChange(sp);
                    setOpen(false);
                  }}>
                  {sp}
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}

type RelativeCounterProps = {
  label: string;
  icon: string;
  value: number;
  setValue: Dispatch<SetStateAction<number>>;
  max: number;
  disabled: boolean;
};

function RelativeCounter(props: RelativeCounterProps) {
  const { label, icon, value, setValue, max, disabled } = props;
  const clamped = Math.max(0, Math.min(max, value));
  const dec = () => !disabled && setValue(Math.max(0, clamped - 1));
  const inc = () => !disabled && setValue(Math.min(max, clamped + 1));
  return (
    <div className="FamilySettingsPanel__field">
      <div className="FamilySettingsPanel__field-label">{label}</div>
      <div
        className={
          'FamilySettingsPanel__counter' +
          (disabled ? ' FamilySettingsPanel__counter--disabled' : '')
        }>
        <span className="FamilySettingsPanel__field-icon">
          <Icon name={icon} />
        </span>
        <button
          type="button"
          className="FamilySettingsPanel__counter-btn"
          onClick={dec}
          disabled={disabled || clamped <= 0}>
          <Icon name="minus" />
        </button>
        <div className="FamilySettingsPanel__counter-value">{clamped}</div>
        <button
          type="button"
          className="FamilySettingsPanel__counter-btn"
          onClick={inc}
          disabled={disabled || clamped >= max}>
          <Icon name="plus" />
        </button>
      </div>
    </div>
  );
}

type DonatorRelativesSectionProps = {
  isDonator: boolean;
  maxValue: number;
  siblings: number;
  setSiblings: Dispatch<SetStateAction<number>>;
  childCount: number;
  setChildCount: Dispatch<SetStateAction<number>>;
};

function DonatorRelativesSection(props: DonatorRelativesSectionProps) {
  const {
    isDonator,
    maxValue,
    siblings,
    setSiblings,
    childCount,
    setChildCount,
  } = props;
  return (
    <div
      className="FamilySettingsPanel__donator-block"
      style={{ gridColumn: '1 / -1' }}>
      <div className="FamilySettingsPanel__donator-header">
        <span className="FamilySettingsPanel__donator-icon">
          <Icon name="crown" />
        </span>
        <span className="FamilySettingsPanel__donator-title">
          Случайные родственники (донат)
        </span>
        {!isDonator && (
          <span className="FamilySettingsPanel__donator-badge">
            <Icon name="lock" />
            <span>Доступно с 1-го уровня доната</span>
          </span>
        )}
      </div>
      {!isDonator && (
        <div
          className="FamilySettingsPanel__hint"
          style={{ gridColumn: 'unset' }}>
          Эта опция доступна донатерам 1-го уровня и выше. Поддержите проект
          через Boosty, чтобы открыть.
        </div>
      )}
      <div className="FamilySettingsPanel__donator-grid">
        <RelativeCounter
          label="Случайных братьев / сестёр"
          icon="people-group"
          value={siblings}
          setValue={setSiblings}
          max={maxValue}
          disabled={!isDonator}
        />
        <RelativeCounter
          label="Случайных детей"
          icon="baby"
          value={childCount}
          setValue={setChildCount}
          max={maxValue}
          disabled={!isDonator}
        />
      </div>
    </div>
  );
}

type FamilyTypeCardViewProps = {
  card: FamilyTypeCard;
  active: boolean;
  disabled: boolean;
  onClick: () => void;
};

const FamilyTypeCardView = memo(function FamilyTypeCardView(
  props: FamilyTypeCardViewProps,
) {
  const { card, active, disabled, onClick } = props;
  const cls = [
    'FamilySettingsPanel__card',
    `FamilySettingsPanel__card--${card.value}`,
    active ? 'FamilySettingsPanel__card--active' : '',
    disabled ? 'FamilySettingsPanel__card--disabled' : '',
  ]
    .filter(Boolean)
    .join(' ');
  return (
    <div
      className={cls}
      onClick={disabled ? undefined : onClick}
      title={card.tooltip}>
      <div className="FamilySettingsPanel__card-icon">
        <Icon name={card.icon} />
      </div>
      <div className="FamilySettingsPanel__card-body">
        <div className="FamilySettingsPanel__card-title">{card.title}</div>
        <div className="FamilySettingsPanel__card-desc">{card.desc}</div>
      </div>
    </div>
  );
});

const FAMILY_WINDOW_FULLSCREEN_SIZE = 10000;

function closeFamilyWindow() {
  if (globalStore) {
    globalStore.dispatch(backendSuspendStart());
  }
}

function fitFamilyWindowToScreen() {
  const pixelRatio = window.devicePixelRatio || 1;
  const screen = window.screen as Screen & {
    availLeft?: number;
    availTop?: number;
  };
  const screenX = Math.round((screen.availLeft || 0) * pixelRatio);
  const screenY = Math.round((screen.availTop || 0) * pixelRatio);
  const screenW = Math.round(screen.availWidth * pixelRatio);
  const screenH = Math.round(screen.availHeight * pixelRatio);

  Byond.winset(Byond.windowId, {
    pos: `${screenX},${screenY}`,
    size: `${screenW}x${screenH}`,
  });
}

export const FamilySettingsPanel = () => {
  const { act, data } = useBackend<BackendData>();

  const settings = data.familySettings;
  const availableSpecies = data.availableSpecies || [];
  const isAdult = settings?.age === 'Adult';

  const [familyType, setFamilyType] = useState<FamilyType>(
    () => settings?.familyType ?? 'none',
  );
  const [speciesPreferenceMode, setSpeciesPreferenceMode] = useState<SpeciesMode>(
    () => settings?.speciesPreferenceMode ?? 'ANY',
  );
  const [preferredSpeciesTypes, setPreferredSpeciesTypes] = useState<string[]>(
    () =>
      Array.isArray(settings?.preferredSpeciesTypes)
        ? (settings!.preferredSpeciesTypes as string[])
        : [],
  );
  const [preferredSpeciesAnatomy, setPreferredSpeciesAnatomy] =
    useState<AnatomyPref>(() => settings?.preferredSpeciesAnatomy ?? 0);
  const [genderPreference, setGenderPreference] = useState<GenderPref>(
    () => settings?.genderPreference ?? 'any',
  );
  const [favoriteName, setFavoriteName] = useState<string>(
    () => settings?.favoriteName ?? '',
  );
  const [polygamyMode, setPolygamyMode] = useState<PolygamyMode>(
    () => settings?.polygamyMode ?? 0,
  );
  const [desiredRelativeRole, setDesiredRelativeRole] = useState<RelativeRole>(
    () => settings?.desiredRelativeRole ?? 0,
  );
  const [allowLowStatusMarriage, setAllowLowStatusMarriage] = useState<number>(
    () => settings?.allowLowStatusMarriage ?? 0,
  );
  const [allowRelativesInFamily, setAllowRelativesInFamily] = useState<number>(
    () => settings?.allowRelativesInFamily ?? 1,
  );
  const [knowYourFate, setKnowYourFate] = useState<number>(
    () => settings?.knowYourFate ?? 0,
  );
  const [fatherName, setFatherName] = useState<string>(
    () => settings?.fatherName ?? '',
  );
  const [motherName, setMotherName] = useState<string>(
    () => settings?.motherName ?? '',
  );
  const [fatherSpecies, setFatherSpecies] = useState<string>(
    () => settings?.fatherSpecies ?? '',
  );
  const [motherSpecies, setMotherSpecies] = useState<string>(
    () => settings?.motherSpecies ?? '',
  );
  const [randomSiblings, setRandomSiblings] = useState<number>(
    () => settings?.randomSiblings ?? 0,
  );
  const [randomChildren, setRandomChildren] = useState<number>(
    () => settings?.randomChildren ?? 0,
  );
  const [speciesPickerOpen, setSpeciesPickerOpen] = useState(false);
  const [fatherSpeciesPickerOpen, setFatherSpeciesPickerOpen] =
    useState(false);
  const [motherSpeciesPickerOpen, setMotherSpeciesPickerOpen] =
    useState(false);
  const [activeTab, setActiveTab] = useState<'preferences' | 'parents'>(
    'preferences',
  );
  const speciesPickerRef = useRef<HTMLDivElement | null>(null);
  const fatherSpeciesPickerRef = useRef<HTMLDivElement | null>(null);
  const motherSpeciesPickerRef = useRef<HTMLDivElement | null>(null);
  const didInitFromBackendRef = useRef<boolean>(!!settings);
  const hasNpcParent =
    fatherName.trim().length > 0 || motherName.trim().length > 0;

  useEffect(() => {
    if (!speciesPickerOpen) return;
    const onDocClick = (e: MouseEvent) => {
      if (!speciesPickerRef.current) return;
      if (!speciesPickerRef.current.contains(e.target as Node)) {
        setSpeciesPickerOpen(false);
      }
    };
    document.addEventListener('mousedown', onDocClick);
    return () => document.removeEventListener('mousedown', onDocClick);
  }, [speciesPickerOpen]);

  useEffect(() => {
    if (!fatherSpeciesPickerOpen) return;
    const onDocClick = (e: MouseEvent) => {
      if (!fatherSpeciesPickerRef.current) return;
      if (!fatherSpeciesPickerRef.current.contains(e.target as Node)) {
        setFatherSpeciesPickerOpen(false);
      }
    };
    document.addEventListener('mousedown', onDocClick);
    return () => document.removeEventListener('mousedown', onDocClick);
  }, [fatherSpeciesPickerOpen]);

  useEffect(() => {
    if (!motherSpeciesPickerOpen) return;
    const onDocClick = (e: MouseEvent) => {
      if (!motherSpeciesPickerRef.current) return;
      if (!motherSpeciesPickerRef.current.contains(e.target as Node)) {
        setMotherSpeciesPickerOpen(false);
      }
    };
    document.addEventListener('mousedown', onDocClick);
    return () => document.removeEventListener('mousedown', onDocClick);
  }, [motherSpeciesPickerOpen]);

  useEffect(() => {
    if (!settings || didInitFromBackendRef.current) return;
    setFamilyType(settings.familyType ?? 'none');
    setSpeciesPreferenceMode(settings.speciesPreferenceMode ?? 'ANY');
    setPreferredSpeciesTypes(
      Array.isArray(settings.preferredSpeciesTypes)
        ? settings.preferredSpeciesTypes
        : [],
    );
    setPreferredSpeciesAnatomy(settings.preferredSpeciesAnatomy ?? 0);
    setGenderPreference(settings.genderPreference ?? 'any');
    setFavoriteName(settings.favoriteName ?? '');
    setPolygamyMode(settings.polygamyMode ?? 0);
    setDesiredRelativeRole(settings.desiredRelativeRole ?? 0);
    setAllowLowStatusMarriage(settings.allowLowStatusMarriage ?? 0);
    setAllowRelativesInFamily(settings.allowRelativesInFamily ?? 1);
    setKnowYourFate(settings.knowYourFate ?? 0);
    setFatherName(settings.fatherName ?? '');
    setMotherName(settings.motherName ?? '');
    setFatherSpecies(settings.fatherSpecies ?? '');
    setMotherSpecies(settings.motherSpecies ?? '');
    setRandomSiblings(settings.randomSiblings ?? 0);
    setRandomChildren(settings.randomChildren ?? 0);
    didInitFromBackendRef.current = true;
  }, [settings]);

  useEffect(() => {
    if (isAdult && desiredRelativeRole === 2) {
      setDesiredRelativeRole(0);
      return;
    }
    if (hasNpcParent && desiredRelativeRole === 3) {
      setDesiredRelativeRole(0);
    }
  }, [hasNpcParent, isAdult, desiredRelativeRole]);

  const toggleSpecies = (species: string) => {
    setPreferredSpeciesTypes((prev) =>
      prev.includes(species)
        ? prev.filter((s) => s !== species)
        : [...prev, species],
    );
  };

  const relativeRoleOptions = useMemo(() => {
    let options = RELATIVE_ROLE_OPTIONS;
    if (isAdult) {
      options = options.filter((o) => o.value !== 2);
    }
    if (hasNpcParent) {
      options = options.filter((o) => o.value !== 3);
    }
    return options;
  }, [hasNpcParent, isAdult]);

  const showPreferences = familyType !== 'none';
  const isMemberMode = familyType === 'member';
  const usesRelativeRole = isMemberMode;
  const allowPolygamy = isMemberMode;

  useEffect(() => {
    const timer = window.setTimeout(fitFamilyWindowToScreen, 0);
    return () => window.clearTimeout(timer);
  }, []);

  const handleResetToDefaults = () => {
    setFamilyType('none');
    setSpeciesPreferenceMode('ANY');
    setPreferredSpeciesTypes([]);
    setPreferredSpeciesAnatomy(0);
    setGenderPreference('any');
    setFavoriteName('');
    setPolygamyMode(0);
    setDesiredRelativeRole(0);
    setAllowLowStatusMarriage(0);
    setAllowRelativesInFamily(1);
    setKnowYourFate(0);
    setFatherName('');
    setMotherName('');
    setFatherSpecies('');
    setMotherSpecies('');
    setRandomSiblings(0);
    setRandomChildren(0);
  };

  const handleCancel = () => {
    if (!settings) return;
    setFamilyType(settings.familyType ?? 'none');
    setSpeciesPreferenceMode(settings.speciesPreferenceMode ?? 'ANY');
    setPreferredSpeciesTypes(
      Array.isArray(settings.preferredSpeciesTypes)
        ? [...settings.preferredSpeciesTypes]
        : [],
    );
    setPreferredSpeciesAnatomy(settings.preferredSpeciesAnatomy ?? 0);
    setGenderPreference(settings.genderPreference ?? 'any');
    setFavoriteName(settings.favoriteName ?? '');
    setPolygamyMode(settings.polygamyMode ?? 0);
    setDesiredRelativeRole(settings.desiredRelativeRole ?? 0);
    setAllowLowStatusMarriage(settings.allowLowStatusMarriage ?? 0);
    setAllowRelativesInFamily(settings.allowRelativesInFamily ?? 1);
    setKnowYourFate(settings.knowYourFate ?? 0);
    setFatherName(settings.fatherName ?? '');
    setMotherName(settings.motherName ?? '');
    setFatherSpecies(settings.fatherSpecies ?? '');
    setMotherSpecies(settings.motherSpecies ?? '');
    setRandomSiblings(settings.randomSiblings ?? 0);
    setRandomChildren(settings.randomChildren ?? 0);
  };

  const handleSave = () => {
    const savedDesiredRelativeRole =
      usesRelativeRole && !(hasNpcParent && desiredRelativeRole === 3)
        ? desiredRelativeRole
        : 0;
    act('save', {
      familyType,
      speciesPreferenceMode,
      preferredSpeciesTypes: [...preferredSpeciesTypes],
      preferredSpeciesAnatomy,
      genderPreference,
      favoriteName,
      polygamyMode,
      desiredRelativeRole: savedDesiredRelativeRole,
      allowLowStatusMarriage,
      allowRelativesInFamily,
      knowYourFate,
      fatherName,
      motherName,
      fatherSpecies,
      motherSpecies,
      randomSiblings,
      randomChildren,
    });
  };

  return (
    <Window
      title="Настройки семьи"
      width={FAMILY_WINDOW_FULLSCREEN_SIZE}
      height={FAMILY_WINDOW_FULLSCREEN_SIZE}
    >
      <Window.Content style={{ backgroundImage: 'none' }}>
        <div className="FamilySettingsPanel">
          <div className="FamilySettingsPanel__header">
            <div className="FamilySettingsPanel__header-left">
              <div className="FamilySettingsPanel__header-icon">
                <Icon name="house-chimney-user" />
              </div>
              <div className="FamilySettingsPanel__header-titles">
                <h2 className="FamilySettingsPanel__title">Настройки семьи</h2>
                <div className="FamilySettingsPanel__subtitle">
                  Выберите тип семьи и настройки предпочтений
                </div>
              </div>
            </div>
            <div
              className="FamilySettingsPanel__close"
              role="button"
              tabIndex={0}
              title="Закрыть"
              onClick={closeFamilyWindow}>
              <Icon name="xmark" />
            </div>
          </div>

          <div className="FamilySettingsPanel__body">
            {/* TOP PANE — TYPE CARDS (full width) */}
            <div className="FamilySettingsPanel__pane FamilySettingsPanel__pane-top">
              <h3 className="FamilySettingsPanel__pane-title">Тип семьи</h3>
              <div className="FamilySettingsPanel__type-grid">
                {FAMILY_TYPE_CARDS.map((card) => {
                  const disabled = false;
                  const active = card.value === familyType;
                  return (
                    <FamilyTypeCardView
                      key={card.value}
                      card={card}
                      active={active}
                      disabled={disabled}
                      onClick={() => setFamilyType(card.value)}
                    />
                  );
                })}
              </div>
            </div>

            {/* BOTTOM PANE — PREFERENCES + PARENTS TABS */}
            <div className="FamilySettingsPanel__pane FamilySettingsPanel__pane-bottom">
              <div className="FamilySettingsPanel__tabs">
                <button
                  type="button"
                  className={
                    'FamilySettingsPanel__tab' +
                    (activeTab === 'preferences'
                      ? ' FamilySettingsPanel__tab--active'
                      : '')
                  }
                  onClick={() => setActiveTab('preferences')}>
                  <span className="FamilySettingsPanel__pane-title-icon">
                    <Icon name="gear" />
                  </span>
                  <span>Предпочтения</span>
                </button>
                <button
                  type="button"
                  className={
                    'FamilySettingsPanel__tab' +
                    (activeTab === 'parents'
                      ? ' FamilySettingsPanel__tab--active'
                      : '')
                  }
                  onClick={() => setActiveTab('parents')}
                  title="NPC-родители появятся в семейном древе, если вы станете основателем нового дома.">
                  <span className="FamilySettingsPanel__pane-title-icon">
                    <Icon name="user-group" />
                  </span>
                  <span>Родители (NPC)</span>
                </button>
              </div>

              {!showPreferences && (
                <div
                  className="FamilySettingsPanel__hint"
                  style={{ gridColumn: 'unset' }}>
                  Персонаж не участвует в семейной системе. Выберите другой тип
                  семьи, чтобы открыть настройки.
                </div>
              )}

              {showPreferences && activeTab === 'preferences' && (
                <div className="FamilySettingsPanel__form">
                  <SelectField
                    label="Гендерные предпочтения"
                    icon="venus-mars"
                    value={genderPreference}
                    options={GENDER_OPTIONS}
                    onChange={setGenderPreference}
                  />

                  <SelectField
                    label="Режим вида/расы"
                    icon="paw"
                    value={speciesPreferenceMode}
                    options={SPECIES_OPTIONS}
                    onChange={setSpeciesPreferenceMode}
                  />

                  {/* Preferred species types chip field — only when SPECIFIC_TYPE */}
                  {speciesPreferenceMode === 'SPECIFIC_TYPE' ? (
                    <div
                      ref={speciesPickerRef}
                      className="FamilySettingsPanel__field FamilySettingsPanel__field--species">
                      <div className="FamilySettingsPanel__field-label">
                        Предпочтительные типы видов
                      </div>
                      <div className="FamilySettingsPanel__field-input">
                        <span className="FamilySettingsPanel__field-icon">
                          <Icon name="dna" />
                        </span>
                        <div
                          className="FamilySettingsPanel__chips"
                          onClick={() => setSpeciesPickerOpen((v) => !v)}>
                          {preferredSpeciesTypes.length === 0 ? (
                            <span className="FamilySettingsPanel__chip-placeholder">
                              Выберите виды...
                            </span>
                          ) : (
                            preferredSpeciesTypes.map((sp) => (
                              <span
                                className="FamilySettingsPanel__chip"
                                key={sp}>
                                {sp}
                                <span
                                  className="close-x"
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    toggleSpecies(sp);
                                  }}>
                                  <Icon name="xmark" />
                                </span>
                              </span>
                            ))
                          )}
                        </div>
                        <span className="FamilySettingsPanel__chips-arrow">
                          <Icon
                            name={
                              speciesPickerOpen ? 'chevron-up' : 'chevron-down'
                            }
                          />
                        </span>
                      </div>
                      {speciesPickerOpen && (
                        <div className="FamilySettingsPanel__species-picker">
                          {availableSpecies.map((sp) => {
                            const selected = preferredSpeciesTypes.includes(sp);
                            return (
                              <div
                                key={sp}
                                className={
                                  'FamilySettingsPanel__species-option' +
                                  (selected
                                    ? ' FamilySettingsPanel__species-option--selected'
                                    : '')
                                }
                                onClick={() => toggleSpecies(sp)}>
                                <Icon
                                  name={selected ? 'square-check' : 'square'}
                                />
                                <span>{sp}</span>
                              </div>
                            );
                          })}
                        </div>
                      )}
                    </div>
                  ) : (
                    <div className="FamilySettingsPanel__field">
                      <div className="FamilySettingsPanel__field-label">
                        Предпочтительные типы видов
                      </div>
                      <div
                        className="FamilySettingsPanel__field-input"
                        style={{ opacity: 0.5 }}>
                        <span className="FamilySettingsPanel__field-icon">
                          <Icon name="dna" />
                        </span>
                        <div
                          style={{
                            padding: '9px 34px 9px 38px',
                            color: '#5f6578',
                            fontSize: 13,
                          }}>
                          Включите режим «Определённые виды»
                        </div>
                      </div>
                    </div>
                  )}

                  <SelectField
                    label="Предпочтительная анатомия"
                    icon="person"
                    value={preferredSpeciesAnatomy}
                    options={ANATOMY_OPTIONS}
                    onChange={setPreferredSpeciesAnatomy}
                  />

                  <div className="FamilySettingsPanel__field">
                    <div className="FamilySettingsPanel__field-label">
                      Любимое имя (цель семьи)
                    </div>
                    <div
                      className="FamilySettingsPanel__field-input"
                      style={{ position: 'relative' }}>
                      <span className="FamilySettingsPanel__field-icon">
                        <Icon name="heart" />
                      </span>
                      <input
                        type="text"
                        placeholder="Введите имя..."
                        value={favoriteName}
                        onChange={(e) => setFavoriteName(e.target.value)}
                      />
                    </div>
                  </div>

                  <SelectField
                    label="Режим полигамии"
                    icon="heart-crack"
                    value={polygamyMode}
                    options={POLYGAMY_OPTIONS}
                    onChange={setPolygamyMode}
                    disabled={!allowPolygamy}
                  />

                  <SelectField
                    label="Желаемая роль родственника"
                    icon="user"
                    value={desiredRelativeRole}
                    options={relativeRoleOptions}
                    onChange={setDesiredRelativeRole}
                    disabled={!usesRelativeRole}
                  />

                  <div className="FamilySettingsPanel__field">
                    <div className="FamilySettingsPanel__field-label">
                      Дополнительные опции
                    </div>
                    <div className="FamilySettingsPanel__checkbox-group">
                      <CheckboxRow
                        icon="ring"
                        label="Разрешить браки с низким статусом"
                        tooltip="Низкий статус: бандиты, вретчи, банщики, бродяги, убийцы, лунатики, нищие и похожие роли."
                        checked={allowLowStatusMarriage === 1}
                        onToggle={() =>
                          setAllowLowStatusMarriage(
                            allowLowStatusMarriage === 1 ? 0 : 1,
                          )
                        }
                      />
                      <CheckboxRow
                        icon="people-roof"
                        label="Разрешить родственников в семье"
                        checked={allowRelativesInFamily === 1}
                        onToggle={() =>
                          setAllowRelativesInFamily(
                            allowRelativesInFamily === 1 ? 0 : 1,
                          )
                        }
                      />
                      <CheckboxRow
                        icon="eye"
                        label="Знать свою судьбу"
                        tooltip="Включено: при матче вы видите расу, пол и анатомию пары; нажав «Нет», вы лишь блокируете эту пару на раунд. Выключено: «Нет» автоматически выключит вас из семейной системы."
                        checked={knowYourFate === 1}
                        onToggle={() =>
                          setKnowYourFate(knowYourFate === 1 ? 0 : 1)
                        }
                      />
                    </div>
                  </div>
                </div>
              )}

              {showPreferences && activeTab === 'parents' && (
                <div className="FamilySettingsPanel__form">
                  <div
                    className="FamilySettingsPanel__hint"
                    style={{ gridColumn: '1 / -1' }}>
                    Эти NPC появятся в вашем семейном древе, если вы станете
                    основателем нового дома. Если указаны оба родителя — будет
                    случайно выбран только один. Если вы влились в чужой дом,
                    ваши NPC-родители НЕ появятся в нём.
                  </div>
                  <div className="FamilySettingsPanel__field">
                    <div className="FamilySettingsPanel__field-label">
                      Имя отца
                    </div>
                    <div
                      className="FamilySettingsPanel__field-input"
                      style={{ position: 'relative' }}>
                      <span className="FamilySettingsPanel__field-icon">
                        <Icon name="user" />
                      </span>
                      <input
                        type="text"
                        placeholder="Оставьте пустым, если не нужен..."
                        value={fatherName}
                        onChange={(e) => setFatherName(e.target.value)}
                      />
                    </div>
                  </div>
                  <ParentSpeciesField
                    label="Раса отца"
                    value={fatherSpecies}
                    onChange={setFatherSpecies}
                    availableSpecies={availableSpecies}
                    open={fatherSpeciesPickerOpen}
                    setOpen={setFatherSpeciesPickerOpen}
                    pickerRef={fatherSpeciesPickerRef}
                  />
                  <div className="FamilySettingsPanel__field">
                    <div className="FamilySettingsPanel__field-label">
                      Имя матери
                    </div>
                    <div
                      className="FamilySettingsPanel__field-input"
                      style={{ position: 'relative' }}>
                      <span className="FamilySettingsPanel__field-icon">
                        <Icon name="user" />
                      </span>
                      <input
                        type="text"
                        placeholder="Оставьте пустым, если не нужна..."
                        value={motherName}
                        onChange={(e) => setMotherName(e.target.value)}
                      />
                    </div>
                  </div>
                  <ParentSpeciesField
                    label="Раса матери"
                    value={motherSpecies}
                    onChange={setMotherSpecies}
                    availableSpecies={availableSpecies}
                    open={motherSpeciesPickerOpen}
                    setOpen={setMotherSpeciesPickerOpen}
                    pickerRef={motherSpeciesPickerRef}
                  />

                  <DonatorRelativesSection
                    isDonator={(settings?.isDonator ?? 0) === 1}
                    maxValue={settings?.maxRandomRelatives ?? 3}
                    siblings={randomSiblings}
                    setSiblings={setRandomSiblings}
                    childCount={randomChildren}
                    setChildCount={setRandomChildren}
                  />
                </div>
              )}
            </div>
          </div>

          <div className="FamilySettingsPanel__footer">
            <div className="FamilySettingsPanel__footer-left">
              <button
                type="button"
                className="FamilySettingsPanel__btn FamilySettingsPanel__btn--icon-only"
                title="Сбросить к значениям по умолчанию"
                onClick={handleResetToDefaults}>
                <Icon name="arrows-rotate" />
              </button>
            </div>
            <div className="FamilySettingsPanel__footer-right">
              <button
                type="button"
                className="FamilySettingsPanel__btn FamilySettingsPanel__btn--secondary"
                onClick={handleCancel}>
                <Icon name="xmark" />
                <span>Отмена</span>
              </button>
              <button
                type="button"
                className="FamilySettingsPanel__btn FamilySettingsPanel__btn--primary"
                onClick={handleSave}>
                <Icon name="floppy-disk" />
                <span>Сохранить</span>
              </button>
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
