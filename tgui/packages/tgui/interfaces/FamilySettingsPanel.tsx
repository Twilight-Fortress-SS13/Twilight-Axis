import type { Dispatch, SetStateAction } from 'react';
import { memo, useEffect, useMemo, useRef, useState } from 'react';

import { Icon } from 'tgui-core/components';

import { backendSuspendStart, globalStore, useBackend } from '../backend';
import { Window } from '../layouts';

type FamilyType = 'none' | 'member' | 'couple';
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
};

const FAMILY_TYPE_CARDS: FamilyTypeCard[] = [
  {
    value: 'none',
    title: 'Без семьи',
    desc: 'Одиночка',
    icon: 'ban',
  },
  {
    value: 'member',
    title: 'Присоединиться к семье',
    desc: 'Выбрать роль в существующем доме',
    icon: 'user-group',
  },
  {
    value: 'couple',
    title: 'Создать семью',
    desc: 'Найти себе партнера для создания нового дома',
    icon: 'heart',
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
    <div className={cls} onClick={disabled ? undefined : onClick}>
      <div className="FamilySettingsPanel__card-icon">
        <Icon name={card.icon} />
      </div>
      <div className="FamilySettingsPanel__card-title">{card.title}</div>
      <div className="FamilySettingsPanel__card-desc">{card.desc}</div>
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
  const [speciesPickerOpen, setSpeciesPickerOpen] = useState(false);
  const speciesPickerRef = useRef<HTMLDivElement | null>(null);
  const didInitFromBackendRef = useRef<boolean>(!!settings);

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
    didInitFromBackendRef.current = true;
  }, [settings]);

  useEffect(() => {
    if (!isAdult) return;
    if (desiredRelativeRole === 2) setDesiredRelativeRole(0);
  }, [isAdult, desiredRelativeRole]);

  const toggleSpecies = (species: string) => {
    setPreferredSpeciesTypes((prev) =>
      prev.includes(species)
        ? prev.filter((s) => s !== species)
        : [...prev, species],
    );
  };

  const relativeRoleOptions = useMemo(
    () =>
      isAdult
        ? RELATIVE_ROLE_OPTIONS.filter((o) => o.value !== 2)
        : RELATIVE_ROLE_OPTIONS,
    [isAdult],
  );

  const showPreferences = familyType !== 'none';
  const isLeaderMode = familyType === 'couple';
  const isMemberMode = familyType === 'member';
  const usesRelativeRole = isLeaderMode || isMemberMode;

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
  };

  const handleSave = () => {
    act('save', {
      familyType,
      speciesPreferenceMode,
      preferredSpeciesTypes: [...preferredSpeciesTypes],
      preferredSpeciesAnatomy,
      genderPreference,
      favoriteName,
      polygamyMode,
      desiredRelativeRole: usesRelativeRole ? desiredRelativeRole : 0,
      allowLowStatusMarriage,
      allowRelativesInFamily,
    });
  };

  return (
    <Window
      title="Настройки семьи"
      width={FAMILY_WINDOW_FULLSCREEN_SIZE}
      height={FAMILY_WINDOW_FULLSCREEN_SIZE}
    >
      <Window.Content>
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
            {/* LEFT PANE — TYPE CARDS */}
            <div className="FamilySettingsPanel__pane FamilySettingsPanel__pane-left">
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

            {/* RIGHT PANE — PREFERENCES */}
            <div className="FamilySettingsPanel__pane FamilySettingsPanel__pane-right">
              <h3 className="FamilySettingsPanel__pane-title">
                <span className="FamilySettingsPanel__pane-title-icon">
                  <Icon name="gear" />
                </span>
                Предпочтения
              </h3>

              {!showPreferences && (
                <div
                  className="FamilySettingsPanel__hint"
                  style={{ gridColumn: 'unset' }}>
                  Персонаж не участвует в семейной системе. Выберите другой тип
                  семьи, чтобы открыть настройки предпочтений.
                </div>
              )}

              {showPreferences && (
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
                      Любимое имя (для супруга)
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
                    disabled={!isLeaderMode}
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
                    </div>
                  </div>
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
