import type { ChangeEvent, CSSProperties, ReactNode } from 'react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

// ---------------------------------------------------------------------
// Colors come from the active theme's CSS custom properties (see
// _azure_base.scss) instead of being hardcoded, so this panel matches
// whatever theme the player has selected. Buttons/inputs use the
// theme's real .Button / .Input / .Section classes for the same reason.
// ---------------------------------------------------------------------
const VAR_TEXT = 'var(--color-text)';
const VAR_LABEL = 'var(--color-label)';
const VAR_ACCENT = 'var(--section-title-color)';
const VAR_BORDER = 'var(--color-border)';
const VAR_ACCENT_BRIGHT = 'var(--input-border-color-focus)';
const VAR_BASE_BG = 'var(--color-base)';

// ---------------------------------------------------------------------
// Types - mirrors what mirror_appearance_ui.dm sends via
// ui_data()/ui_static_data(). `data` can legitimately arrive without
// most of these keys for one tick right before the panel auto-closes
// (see check_still_valid() on the DM side), so the raw backend payload
// is typed as Partial<MirrorData> and narrowed after the guard in
// MirrorAppearance below.
// ---------------------------------------------------------------------
type StyleOption = {
  name: string;
  path: string;
  thumb?: string | null;
};

type ColorEntry = {
  index: number;
  label: string;
  value: string;
};

type OrganInfo = {
  present: boolean;
  style?: string;
  colors?: ColorEntry[];
};

type SizedOrganInfo = OrganInfo & {
  size: number;
};

type PenisInfo = SizedOrganInfo & {
  style_path: string;
};

type DescriptorCategory = {
  name: string;
  path: string;
  options: StyleOption[];
};

type MarkingInstance = {
  name: string;
  color: string;
  thumb?: string | null;
};

type MarkingZone = {
  zone: string;
  label: string;
};

type MirrorData = {
  closing: boolean;
  skin: {
    uses_tones: boolean;
    color1: string;
    color2: string;
    color3: string;
  };
  eye_color: string;
  heterochromia: boolean;
  second_eye_color: string;
  hair: {
    color: string;
    style: string;
    secondary_gradient: string;
    secondary_color: string;
    third_gradient: string;
    third_color: string;
  };
  facial_hair: {
    style: string;
    color: string;
  };
  accessory_style: string;
  accessory_colors: ColorEntry[];
  face_detail_style: string;
  face_detail_colors: ColorEntry[];
  ears: OrganInfo;
  horns: OrganInfo;
  wings: OrganInfo;
  tail: OrganInfo;
  snout: OrganInfo;
  fluff: OrganInfo;
  breasts: SizedOrganInfo;
  penis: PenisInfo;
  testicles: SizedOrganInfo;
  vagina: OrganInfo;
  descriptors: Record<string, string>;
  hairstyles: StyleOption[];
  facial_hairstyles: StyleOption[];
  accessory_styles: StyleOption[];
  face_detail_styles: StyleOption[];
  ears_styles: StyleOption[];
  horns_styles: StyleOption[];
  wings_styles: StyleOption[];
  tail_styles: StyleOption[];
  snout_styles: StyleOption[];
  fluff_styles: StyleOption[];
  breast_styles: StyleOption[];
  testicle_styles: StyleOption[];
  penis_styles: StyleOption[];
  vagina_styles: StyleOption[];
  hair_gradients: string[];
  descriptor_categories: DescriptorCategory[];
  markings: Record<string, MarkingInstance[]>;
  marking_candidates: Record<string, StyleOption[]>;
  marking_zone_list: MarkingZone[];
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;
type TabProps = { act: ActFn; data: MirrorData };

// Sizes beyond index 4 have no sprite for breasts (reported: "Пышная"
// and up just disappear) - capped here and in the DM-side clamp.
const BREAST_SIZE_LABELS = ['Плоская', 'Едва заметная', 'Маленькая', 'Умеренная', 'Большая', 'Пышная'];
const ORGAN_SIZE_LABELS = ['Маленький', 'Средний', 'Большой'];

const CREATURE_ORGANS: {
  key: 'ears' | 'horns' | 'tail' | 'wings' | 'snout' | 'fluff';
  label: string;
  action: string;
  optionsKey: keyof MirrorData;
}[] = [
  { key: 'ears', label: 'Уши', action: 'set_ears', optionsKey: 'ears_styles' },
  { key: 'horns', label: 'Рога', action: 'set_horns', optionsKey: 'horns_styles' },
  { key: 'tail', label: 'Хвост', action: 'set_tail', optionsKey: 'tail_styles' },
  { key: 'wings', label: 'Крылья', action: 'set_wings', optionsKey: 'wings_styles' },
  { key: 'snout', label: 'Морда', action: 'set_snout', optionsKey: 'snout_styles' },
  { key: 'fluff', label: 'Мех', action: 'set_fluff', optionsKey: 'fluff_styles' },
];

// Descriptor category names come from the game's own data (species
// descriptor_choice datums) as English strings. Translating the full,
// open-ended set of possible values isn't practical, but the visible
// category labels are a small, known set - translated here with an
// English fallback for anything not in the dictionary.
const DESCRIPTOR_LABELS: Record<string, string> = {
  'Physical Descriptor': 'Физическое описание',
  'Stature': 'Телосложение',
  'Height': 'Рост',
  'Body': 'Тело',
  'Face': 'Лицо',
  'Resting Expression': 'Выражение лица',
  'Skin': 'Кожа',
  'Voice': 'Голос',
  'Prominent #1': 'Особенность №1',
  'Prominent #2': 'Особенность №2',
  'Prominent #3': 'Особенность №3',
  'Prominent #4': 'Особенность №4',
};
const trDescriptor = (name: string) => DESCRIPTOR_LABELS[name] || name;

// Color-key names (e.g. "Member", "Skin" on a multi-color penis
// accessory) come from the game's own sprite_accessory data as English
// strings. Same approach as descriptor labels: translate the known
// ones, fall back to the original for anything not in the dictionary.
const COLOR_KEY_LABELS: Record<string, string> = {
  'Member': 'Член',
  'Skin': 'Кожа',
};
const trColorKey = (label: string) => COLOR_KEY_LABELS[label] || label;

// Hair gradient values come through as raw stringified typepaths (e.g.
// "/datum/hair_gradient/none") since the underlying value has to stay
// exactly as GLOB.hair_gradients expects it for validation - this is
// display-only, showing just the last path segment.
const trGradientName = (raw: string) => {
  const last = raw.split('/').pop() || raw;
  return last === 'none' ? 'Нет' : last;
};

// ---------------------------------------------------------------------
// Generic building blocks
// ---------------------------------------------------------------------

const rowStyle: CSSProperties = {
  display: 'flex',
  alignItems: 'center',
  gap: '6px',
  marginBottom: '4px',
};

const Panel = ({ title, children }: { title?: string; children: ReactNode }) => (
  <div className="Section" style={{ marginBottom: '8px' }}>
    {title && (
      <div className="Section__title">
        <div className="Section__titleText" style={{ textAlign: 'center' }}>
          {title}
        </div>
      </div>
    )}
    <div style={{ padding: '8px' }}>{children}</div>
  </div>
);

const btnClass = (selected: boolean) => `Button${selected ? ' Button--selected' : ''}`;

const SelectField = (props: {
  label: string;
  value: string;
  options: string[];
  onChange: (value: string) => void;
  renderOption?: (opt: string) => string;
}) => {
  const { label, value, options, onChange, renderOption } = props;
  return (
    <div style={rowStyle}>
      <div style={{ width: '9.5em', flexShrink: 0, fontSize: '12px', color: VAR_LABEL }}>
        {label}
      </div>
      <select
        className="Input"
        value={value}
        onChange={(e: ChangeEvent<HTMLSelectElement>) => onChange(e.target.value)}
        style={{ flex: 1, minWidth: 0, fontSize: '12px', padding: '3px 4px' }}>
        {options.map((opt) => (
          <option key={opt} value={opt}>
            {renderOption ? renderOption(opt) : opt}
          </option>
        ))}
      </select>
    </div>
  );
};

const PathDropdown = (props: {
  label: string;
  options?: StyleOption[];
  currentPath?: string;
  onSelect: (path: string) => void;
}) => {
  const { label, options = [], currentPath, onSelect } = props;
  const currentName = options.find((o) => o.path === currentPath)?.name ?? 'Нет';
  return (
    <SelectField
      label={label}
      value={currentName}
      options={options.map((o) => o.name)}
      onChange={(name) => {
        const match = options.find((o) => o.name === name);
        onSelect(match ? match.path : '');
      }}
    />
  );
};

const NameDropdown = (props: {
  label: string;
  options?: StyleOption[];
  currentName?: string;
  onSelect: (path: string) => void;
}) => {
  const { label, options = [], currentName, onSelect } = props;
  return (
    <SelectField
      label={label}
      value={currentName || 'Нет'}
      options={options.map((o) => o.name)}
      onChange={(name) => {
        const match = options.find((o) => o.name === name);
        onSelect(match ? match.path : '');
      }}
    />
  );
};

const SizeStepper = (props: {
  label: string;
  value: number;
  min?: number;
  labels: string[];
  onChange: (value: number) => void;
}) => {
  const { label, value, min = 0, labels, onChange } = props;
  const activeIndex = value - min;
  return (
    <div style={{ marginBottom: '10px' }}>
      <div style={{ fontSize: '12px', marginBottom: '6px', textAlign: 'center' }}>
        <span style={{ color: VAR_LABEL }}>{label}: </span>
        <b style={{ color: VAR_ACCENT, fontSize: '13px' }}>{labels[activeIndex]}</b>
      </div>
      <div style={{ display: 'flex', alignItems: 'center' }}>
        {labels.flatMap((lbl, i) => [
          i > 0 && (
            <div
              key={`line-${i}`}
              style={{
                flex: 1,
                height: '2px',
                background: i <= activeIndex ? VAR_ACCENT : VAR_BORDER,
              }}
            />
          ),
          <button
            key={`dot-${i}`}
            type="button"
            title={lbl}
            className="mirror-swatch"
            onClick={() => onChange(i + min)}
            style={{
              width: '18px',
              height: '18px',
              flexShrink: 0,
              borderRadius: '50%',
              border: `2px solid ${i <= activeIndex ? VAR_ACCENT : VAR_BORDER}`,
              background: i <= activeIndex ? VAR_ACCENT : 'transparent',
              boxShadow: i === activeIndex ? `0 0 6px ${VAR_ACCENT_BRIGHT}` : 'none',
              cursor: 'pointer',
              padding: 0,
            }}
          />,
        ])}
      </div>
    </div>
  );
};

// ---------------------------------------------------------------------
// Color field - no custom picker. Clicking the swatch opens the game's
// own native color_pick_sanitized() dialog (DM-side "pick_*" action);
// the optional "match" button applies a known color directly (e.g.
// "same as skin") without opening a dialog.
// ---------------------------------------------------------------------
const ColorField = (props: {
  label: string;
  value: string;
  act: ActFn;
  pickAction: string;
  pickParams: Record<string, unknown>;
  matchLabel?: string;
  matchAction?: string;
  matchParams?: Record<string, unknown>;
}) => {
  const { label, value, act, pickAction, pickParams, matchLabel, matchAction, matchParams } = props;
  return (
    <div style={rowStyle}>
      <div style={{ flex: 1, fontSize: '12px', color: VAR_LABEL }}>{label}</div>
      {matchAction && (
        <button
          type="button"
          title={matchLabel}
          onClick={() => act(matchAction, matchParams)}
          className={btnClass(false)}
          style={{ padding: '2px 6px', fontSize: '10px' }}>
          {matchLabel}
        </button>
      )}
      <button
        type="button"
        title="Выбрать цвет"
        className="mirror-swatch"
        onClick={() => act(pickAction, pickParams)}
        style={{
          width: '24px',
          height: '24px',
          borderRadius: '50%',
          border: `2px solid ${VAR_BORDER}`,
          backgroundColor: value || '#ffffff',
          boxShadow: `0 0 6px ${VAR_ACCENT_BRIGHT}`,
          cursor: 'pointer',
          padding: 0,
        }}
      />
    </div>
  );
};

// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
// Style picker: searchable thumbnail grid, matching the in-game
// "Волосы" picker's layout. Shared between hairstyles and facial hair.
// Thumbnails are cropped straight from each accessory's own icon_state
// (cheap, generated once server-side in ui_static_data).
// ---------------------------------------------------------------------
const StylePickerModal = ({
  options,
  onSelect,
  onClose,
  searchPlaceholder = 'Поиск причёски...',
}: {
  options: StyleOption[];
  onSelect: (path: string) => void;
  onClose: () => void;
  searchPlaceholder?: string;
}) => {
  const [search, setSearch] = useState('');
  const filtered = options.filter((o) =>
    o.name.toLowerCase().includes(search.toLowerCase()),
  );

  return (
    <>
      <div
        onClick={onClose}
        style={{ position: 'fixed', inset: 0, zIndex: 200, background: 'rgba(0,0,0,0.5)' }}
      />
      <div
        className="mirror-modal-pop"
        style={{
          position: 'fixed',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          zIndex: 201,
          width: '360px',
          maxHeight: '420px',
          display: 'flex',
          flexDirection: 'column',
          background: VAR_BASE_BG,
          border: `1px solid ${VAR_ACCENT}`,
          borderRadius: '8px',
          boxShadow: '0 8px 24px rgba(0,0,0,0.6)',
          padding: '8px',
        }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '6px', marginBottom: '8px' }}>
          <input
            type="text"
            className="Input"
            placeholder={searchPlaceholder}
            value={search}
            onChange={(e: ChangeEvent<HTMLInputElement>) => setSearch(e.target.value)}
            style={{ flex: 1, padding: '4px 6px', fontSize: '12px', textAlign: 'center' }}
          />
          <button
            type="button"
            title="Закрыть"
            onClick={onClose}
            style={{
              width: '22px',
              height: '22px',
              flexShrink: 0,
              borderRadius: '4px',
              border: `1px solid ${VAR_BORDER}`,
              background: 'rgba(255,255,255,0.05)',
              color: VAR_TEXT,
              cursor: 'pointer',
              fontSize: '13px',
              lineHeight: 1,
              padding: 0,
            }}>
            X
          </button>
        </div>
        <div
          style={{
            overflowY: 'auto',
            display: 'grid',
            gridTemplateColumns: 'repeat(4, 1fr)',
            gap: '6px',
          }}>
          {filtered.map((o) => (
            <div
              key={o.path}
              onClick={() => {
                onSelect(o.path);
                onClose();
              }}
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                padding: '4px',
                borderRadius: '6px',
                border: `1px solid ${VAR_BORDER}`,
                cursor: 'pointer',
                textAlign: 'center',
              }}>
              {o.thumb ? (
                <img
                  src={`data:image/png;base64,${o.thumb}`}
                  alt={o.name}
                  style={{
                    width: '40px',
                    height: '40px',
                    imageRendering: 'pixelated',
                    marginBottom: '4px',
                  }}
                />
              ) : (
                <div
                  style={{
                    width: '40px',
                    height: '40px',
                    marginBottom: '4px',
                    background: VAR_BORDER,
                    borderRadius: '4px',
                  }}
                />
              )}
              <div style={{ fontSize: '10px', color: VAR_TEXT, lineHeight: '1.2' }}>{o.name}</div>
            </div>
          ))}
        </div>
      </div>
    </>
  );
};

const StylePicker = (props: {
  label: string;
  options?: StyleOption[];
  currentPath?: string;
  onSelect: (path: string) => void;
}) => {
  const { label, options = [], currentPath, onSelect } = props;
  const [open, setOpen] = useState(false);
  const current = options.find((o) => o.path === currentPath);

  return (
    <div style={rowStyle}>
      <div style={{ width: '9.5em', flexShrink: 0, fontSize: '12px', color: VAR_LABEL }}>
        {label}
      </div>
      <button
        type="button"
        className={btnClass(false)}
        onClick={() => setOpen(true)}
        style={{ flex: 1, textAlign: 'left', display: 'flex', alignItems: 'center', gap: '6px' }}>
        {current?.thumb && (
          <img
            src={`data:image/png;base64,${current.thumb}`}
            alt=""
            style={{ width: '18px', height: '18px', imageRendering: 'pixelated' }}
          />
        )}
        {current?.name || 'Выбрать...'}
      </button>
      {open && (
        <StylePickerModal options={options} onSelect={onSelect} onClose={() => setOpen(false)} />
      )}
    </div>
  );
};

// ---------------------------------------------------------------------
// Organ color panel (creature features)
// ---------------------------------------------------------------------
const OrganColorPanel = (props: {
  act: ActFn;
  label: string;
  organKey: string;
  action: string;
  options?: StyleOption[];
  organData?: OrganInfo;
}) => {
  const { act, label, organKey, action, options, organData } = props;
  const present = !!organData?.present;
  return (
    <div
      style={{
        border: `1px solid ${VAR_BORDER}`,
        borderRadius: '6px',
        padding: '6px 8px',
        marginBottom: '6px',
      }}>
      <NameDropdown
        label={label}
        options={options}
        currentName={present ? organData?.style : 'Нет'}
        onSelect={(path) => act(action, { path })}
      />
      {present &&
        organData?.colors?.map((c) => (
          <ColorField
            key={c.index}
            label={trColorKey(c.label)}
            value={c.value}
            act={act}
            pickAction="pick_organ_color"
            pickParams={{ organ: organKey, index: c.index }}
          />
        ))}
    </div>
  );
};

const SectionHeader = ({ children }: { children: ReactNode }) => (
  <div
    style={{
      fontWeight: 'bold',
      fontSize: '13px',
      letterSpacing: '0.02em',
      color: VAR_ACCENT,
      marginBottom: '4px',
      marginTop: '4px',
    }}>
    {children}
  </div>
);

// ---------------------------------------------------------------------
// TABS
// ---------------------------------------------------------------------

const SkinEyesSection = ({ act, data }: TabProps) => (
  <Panel title="Кожа и глаза">
    <SectionHeader>Тон кожи</SectionHeader>
    <ColorField
      label="Основной"
      value={data.skin.color1}
      act={act}
      pickAction="pick_skin_color"
      pickParams={{ tier: 1 }}
    />
    <ColorField
      label="Дополнительный"
      value={data.skin.color2}
      act={act}
      pickAction="pick_skin_color"
      pickParams={{ tier: 2 }}
    />
    <ColorField
      label="Третичный"
      value={data.skin.color3}
      act={act}
      pickAction="pick_skin_color"
      pickParams={{ tier: 3 }}
    />
    <SectionHeader>Глаза</SectionHeader>
    <ColorField label="Цвет глаз" value={data.eye_color} act={act} pickAction="pick_eye_color" pickParams={{}} />
    <label style={{ ...rowStyle, cursor: 'pointer' }}>
      <input
        type="checkbox"
        checked={!!data.heterochromia}
        onChange={() => act('toggle_heterochromia')}
        style={{ marginRight: '6px' }}
      />
      <span style={{ fontSize: '12px', color: VAR_LABEL }}>Гетерохромия</span>
    </label>
    {!!data.heterochromia && (
      <ColorField
        label="Цвет второго глаза"
        value={data.second_eye_color}
        act={act}
        pickAction="pick_second_eye_color"
        pickParams={{}}
      />
    )}
  </Panel>
);

const TabHair = ({ act, data }: TabProps) => (
  <Panel title="Волосы">
    <SectionHeader>Причёска</SectionHeader>
    <StylePicker
      label="Стиль"
      options={data.hairstyles}
      currentPath={data.hair.style}
      onSelect={(path) => act('set_hairstyle', { path })}
    />
    <ColorField label="Основной цвет" value={data.hair.color} act={act} pickAction="pick_hair_color" pickParams={{}} />
    <SelectField
      label="Основной градиент"
      value={data.hair.secondary_gradient || data.hair_gradients[0]}
      options={data.hair_gradients}
      onChange={(style) => act('set_hair_gradient', { tier: 2, style })}
      renderOption={trGradientName}
    />
    <ColorField
      label="Цвет основного градиента"
      value={data.hair.secondary_color}
      act={act}
      pickAction="pick_hair_gradient_color"
      pickParams={{ tier: 2 }}
    />
    <SelectField
      label="Дополнительный градиент"
      value={data.hair.third_gradient || data.hair_gradients[0]}
      options={data.hair_gradients}
      onChange={(style) => act('set_hair_gradient', { tier: 3, style })}
      renderOption={trGradientName}
    />
    <ColorField
      label="Цвет дополнительного градиента"
      value={data.hair.third_color}
      act={act}
      pickAction="pick_hair_gradient_color"
      pickParams={{ tier: 3 }}
    />
    <SectionHeader>Борода/усы</SectionHeader>
    <StylePicker
      label="Стиль"
      options={data.facial_hairstyles}
      currentPath={data.facial_hair.style}
      onSelect={(path) => act('set_facial_hairstyle', { path })}
    />
    <ColorField
      label="Цвет"
      value={data.facial_hair.color}
      act={act}
      pickAction="pick_facial_hair_color"
      pickParams={{}}
    />
  </Panel>
);

const FaceSection = ({ act, data }: TabProps) => (
  <Panel title="Лицо">
    <PathDropdown
      label="Деталь лица"
      options={data.face_detail_styles}
      currentPath={data.face_detail_style}
      onSelect={(path) => act('set_face_detail', { path })}
    />
    {data.face_detail_style &&
      data.face_detail_colors?.map((c) => (
        <ColorField
          key={c.index}
          label={trColorKey(c.label)}
          value={c.value}
          act={act}
          pickAction="pick_face_detail_color"
          pickParams={{ index: c.index }}
        />
      ))}
    <PathDropdown
      label="Аксессуар"
      options={data.accessory_styles}
      currentPath={data.accessory_style}
      onSelect={(path) => act('set_accessory', { path })}
    />
    {data.accessory_style &&
      data.accessory_colors?.map((c) => (
        <ColorField
          key={c.index}
          label={trColorKey(c.label)}
          value={c.value}
          act={act}
          pickAction="pick_accessory_color"
          pickParams={{ index: c.index }}
        />
      ))}
  </Panel>
);

const TabCreature = ({ act, data }: TabProps) => (
  <Panel title="Черты">
    {CREATURE_ORGANS.map((organ) => (
      <OrganColorPanel
        key={organ.key}
        act={act}
        label={organ.label}
        organKey={organ.key}
        action={organ.action}
        options={data[organ.optionsKey] as StyleOption[]}
        organData={data[organ.key]}
      />
    ))}
  </Panel>
);

const ChestSection = ({ act, data }: TabProps) => {
  const breasts = data.breasts;
  const present = !!breasts.present;
  const skinColor = data.skin.color1;
  return (
    <Panel title="Грудь">
      <NameDropdown
        label="Тип груди"
        options={data.breast_styles}
        currentName={present ? breasts.style : 'Нет'}
        onSelect={(path) => act('set_breast_style', { path })}
      />
      {present && (
        <>
          <SizeStepper
            label="Размер"
            value={breasts.size}
            labels={BREAST_SIZE_LABELS}
            onChange={(size) => act('set_breast_size', { size })}
          />
          <SectionHeader>Цвет груди</SectionHeader>
          {breasts.colors?.map((c) => (
            <ColorField
              key={c.index}
              label={trColorKey(c.label)}
              value={c.value}
              act={act}
              pickAction="pick_organ_color"
              pickParams={{ organ: 'breasts', index: c.index }}
              matchLabel="Как кожа"
              matchAction="set_organ_color"
              matchParams={{ organ: 'breasts', index: c.index, color: skinColor }}
            />
          ))}
        </>
      )}
    </Panel>
  );
};

const GenitalsSection = ({ act, data }: TabProps) => {
  const penis = data.penis;
  const penisPresent = !!penis.present;
  const testicles = data.testicles;
  const testiclesPresent = !!testicles.present;
  const vagina = data.vagina;
  const vaginaPresent = !!vagina.present;
  const skinColor = data.skin.color1;
  return (
    <>
      <Panel title="Пенис">
        <PathDropdown
          label="Тип"
          options={data.penis_styles}
          currentPath={penis.style_path}
          onSelect={(path) => act('set_penis_style', { path })}
        />
        {penisPresent && (
          <>
            <SizeStepper
              label="Размер"
              value={penis.size}
              min={1}
              labels={ORGAN_SIZE_LABELS}
              onChange={(size) => act('set_penis_size', { size })}
            />
            {penis.colors?.map((c) => (
              <ColorField
                key={c.index}
                label={trColorKey(c.label)}
                value={c.value}
                act={act}
                pickAction="pick_organ_color"
                pickParams={{ organ: 'penis', index: c.index }}
                matchLabel="Как кожа"
                matchAction="set_organ_color"
                matchParams={{ organ: 'penis', index: c.index, color: skinColor }}
              />
            ))}
          </>
        )}
      </Panel>
      <Panel title="Яички">
        <NameDropdown
          label="Тип"
          options={data.testicle_styles}
          currentName={testiclesPresent ? testicles.style : 'Нет'}
          onSelect={(path) => act('set_testicles', { path })}
        />
        {testiclesPresent && (
          <>
            <SizeStepper
              label="Размер"
              value={testicles.size}
              min={1}
              labels={ORGAN_SIZE_LABELS}
              onChange={(size) => act('set_testicle_size', { size })}
            />
            {testicles.colors?.map((c) => (
              <ColorField
                key={c.index}
                label={trColorKey(c.label)}
                value={c.value}
                act={act}
                pickAction="pick_organ_color"
                pickParams={{ organ: 'testicles', index: c.index }}
                matchLabel="Как кожа"
                matchAction="set_organ_color"
                matchParams={{ organ: 'testicles', index: c.index, color: skinColor }}
              />
            ))}
          </>
        )}
      </Panel>
      <Panel title="Вагина">
        <NameDropdown
          label="Тип"
          options={data.vagina_styles}
          currentName={vaginaPresent ? vagina.style : 'Нет'}
          onSelect={(path) => act('set_vagina', { path })}
        />
        {vaginaPresent &&
          vagina.colors?.map((c) => (
            <ColorField
              key={c.index}
              label={trColorKey(c.label)}
              value={c.value}
              act={act}
              pickAction="pick_organ_color"
              pickParams={{ organ: 'vagina', index: c.index }}
              matchLabel="Как кожа"
              matchAction="set_organ_color"
              matchParams={{ organ: 'vagina', index: c.index, color: skinColor }}
            />
          ))}
      </Panel>
    </>
  );
};

const TabBody = ({ act, data }: TabProps) => (
  <>
    <SkinEyesSection act={act} data={data} />
    <FaceSection act={act} data={data} />
    <ChestSection act={act} data={data} />
    <GenitalsSection act={act} data={data} />
  </>
);

const MarkingZoneCard = ({
  act,
  zone,
  label,
  current,
  candidates,
}: {
  act: ActFn;
  zone: string;
  label: string;
  current: MarkingInstance[];
  candidates: StyleOption[];
}) => {
  const [pickerOpen, setPickerOpen] = useState(false);
  return (
    <div
      style={{
        border: `1px solid ${VAR_BORDER}`,
        borderRadius: '6px',
        padding: '6px 8px',
        marginBottom: '6px',
      }}>
      <div style={{ fontSize: '12px', fontWeight: 'bold', color: VAR_ACCENT, marginBottom: '4px' }}>
        {label}
      </div>
      {current.length === 0 && (
        <div style={{ fontSize: '11px', color: VAR_LABEL, marginBottom: '4px' }}>Нет меток</div>
      )}
      {current.map((m) => (
        <div key={m.name} style={{ ...rowStyle, gap: '8px' }}>
          {m.thumb ? (
            <img
              src={`data:image/png;base64,${m.thumb}`}
              alt={m.name}
              style={{ width: '20px', height: '20px', imageRendering: 'pixelated', flexShrink: 0 }}
            />
          ) : (
            <div style={{ width: '20px', height: '20px', flexShrink: 0 }} />
          )}
          <div style={{ flex: 1, fontSize: '12px' }}>{m.name}</div>
          <button
            type="button"
            title="Сбросить цвет"
            onClick={() => act('reset_marking_color', { zone, name: m.name })}
            className={btnClass(false)}
            style={{ padding: '2px 6px', fontSize: '10px' }}>
            Сброс
          </button>
          <button
            type="button"
            title="Выбрать цвет"
            className="mirror-swatch"
            onClick={() => act('pick_marking_color', { zone, name: m.name })}
            style={{
              width: '20px',
              height: '20px',
              borderRadius: '50%',
              border: `2px solid ${VAR_BORDER}`,
              backgroundColor: m.color || '#ffffff',
              boxShadow: `0 0 6px ${VAR_ACCENT_BRIGHT}`,
              cursor: 'pointer',
              padding: 0,
              flexShrink: 0,
            }}
          />
          <button
            type="button"
            title="Удалить"
            onClick={() => act('remove_marking', { zone, name: m.name })}
            className={btnClass(false)}
            style={{ padding: '2px 6px', fontSize: '10px' }}>
            Удалить
          </button>
        </div>
      ))}
      {candidates.length > 0 && (
        <button
          type="button"
          className={btnClass(false)}
          onClick={() => setPickerOpen(true)}
          style={{ marginTop: '4px' }}>
          + Добавить метку
        </button>
      )}
      {pickerOpen && (
        <StylePickerModal
          options={candidates}
          onSelect={(name) => act('add_marking', { zone, name })}
          onClose={() => setPickerOpen(false)}
          searchPlaceholder="Поиск метки..."
        />
      )}
    </div>
  );
};

const TabMarkings = ({ act, data }: TabProps) => {
  const zones = data.marking_zone_list || [];
  return (
    <Panel title="Отметки">
      {zones.map((z) => (
        <MarkingZoneCard
          key={z.zone}
          act={act}
          zone={z.zone}
          label={z.label}
          current={data.markings?.[z.zone] || []}
          candidates={data.marking_candidates?.[z.zone] || []}
        />
      ))}
    </Panel>
  );
};

const TabDescriptors = ({ act, data }: TabProps) => {
  const categories = data.descriptor_categories || [];
  if (!categories.length) {
    return (
      <Panel title="Описания">У вашего вида нет стандартных описаний для изменения.</Panel>
    );
  }
  return (
    <Panel title="Описания">
      {categories.map((cat) => (
        <PathDropdown
          key={cat.path}
          label={trDescriptor(cat.name)}
          options={cat.options}
          currentPath={data.descriptors[cat.path]}
          onSelect={(value) => act('set_descriptor', { category: cat.path, value })}
        />
      ))}
    </Panel>
  );
};

// ---------------------------------------------------------------------
// ROOT
// ---------------------------------------------------------------------

const TABS: { id: string; label: string; component: (props: TabProps) => ReactNode }[] = [
  { id: 'body', label: 'Тело', component: TabBody },
  { id: 'hair', label: 'Волосы', component: TabHair },
  { id: 'creature', label: 'Черты', component: TabCreature },
  { id: 'markings', label: 'Отметки', component: TabMarkings },
  { id: 'descriptors', label: 'Описания', component: TabDescriptors },
];

export const MirrorAppearance = () => {
  const { act, data } = useBackend<Partial<MirrorData>>();
  const [tabId, setTabId] = useState('body');

  // If the session became invalid (walked away / effect expired), the
  // backend sets an explicit "closing" flag. Checking for this directly
  // (rather than the absence of data.skin) matters here: tgui appears to
  // merge new data into the existing client-side state rather than
  // replacing it outright, so a key that's simply missing from a given
  // update doesn't actually disappear - the last known value sticks
  // around. An explicit boolean that gets a fresh value every single
  // update doesn't have that problem.
  if (data.closing || !data.skin) {
    return (
      <Window width={420} height={140}>
        <Window.Content>
          <div style={{ padding: '24px', textAlign: 'center', color: VAR_LABEL }}>
            Зеркало гаснет...
          </div>
        </Window.Content>
      </Window>
    );
  }

  const fullData = data as MirrorData;
  const ActiveTab = TABS.find((t) => t.id === tabId)?.component ?? TabBody;

  return (
    <Window width={680} height={640}>
      <style>{`
        @keyframes mirrorShimmer {
          0%, 100% { text-shadow: 0 0 12px ${VAR_ACCENT_BRIGHT}, 0 2px 2px rgba(0,0,0,0.6); }
          50% { text-shadow: 0 0 22px ${VAR_ACCENT_BRIGHT}, 0 0 8px ${VAR_ACCENT_BRIGHT}, 0 2px 2px rgba(0,0,0,0.6); }
        }
        @keyframes mirrorTabIn {
          from { opacity: 0; transform: translateY(4px); }
          to { opacity: 1; transform: translateY(0); }
        }
        @keyframes mirrorPopIn {
          from { opacity: 0; transform: translate(-50%, -50%) scale(0.92); }
          to { opacity: 1; transform: translate(-50%, -50%) scale(1); }
        }
        .Button { transition: transform 0.12s ease, box-shadow 0.12s ease, filter 0.12s ease; }
        .Button:hover { transform: translateY(-1px); filter: brightness(1.15); }
        .Button:active { transform: translateY(0); filter: brightness(0.95); }
        .mirror-swatch { transition: transform 0.12s ease, box-shadow 0.12s ease; }
        .mirror-swatch:hover { transform: scale(1.12); }
        .mirror-tab-content { animation: mirrorTabIn 0.18s ease; }
        .mirror-title { animation: mirrorShimmer 3.2s ease-in-out infinite; }
        .mirror-modal-pop { animation: mirrorPopIn 0.15s ease; }
      `}</style>
      <Window.Content
        scrollable
        style={{
          background:
            'radial-gradient(ellipse 140% 34% at 50% 0%, rgba(255,255,255,0.06), transparent 60%)',
        }}>
        <div
          className="mirror-title"
          style={{
            textAlign: 'center',
            padding: '10px 0 4px 0',
            fontSize: '26px',
            fontWeight: 'bold',
            fontStyle: 'italic',
            fontFamily: "'Lora', Georgia, serif",
            letterSpacing: '1px',
            color: VAR_ACCENT,
          }}>
          ~ Зеркало мерцает ~
        </div>
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            margin: '0 auto 14px auto',
            width: '80%',
          }}>
          <div
            style={{
              flex: 1,
              height: '1px',
              background: `linear-gradient(to right, transparent, ${VAR_ACCENT_BRIGHT})`,
            }}
          />
          <div
            style={{
              width: '7px',
              height: '7px',
              flexShrink: 0,
              background: VAR_ACCENT_BRIGHT,
              transform: 'rotate(45deg)',
              boxShadow: `0 0 6px ${VAR_ACCENT_BRIGHT}`,
            }}
          />
          <div
            style={{
              flex: 1,
              height: '1px',
              background: `linear-gradient(to left, transparent, ${VAR_ACCENT_BRIGHT})`,
            }}
          />
        </div>
        <div
          style={{
            display: 'flex',
            justifyContent: 'center',
            gap: '4px',
            marginBottom: '8px',
            flexWrap: 'wrap',
          }}>
          {TABS.map((tab) => (
            <button
              key={tab.id}
              type="button"
              className={btnClass(tabId === tab.id)}
              onClick={() => setTabId(tab.id)}>
              {tab.label}
            </button>
          ))}
        </div>
        <div key={tabId} className="mirror-tab-content">
          <ActiveTab act={act} data={fullData} />
        </div>
      </Window.Content>
    </Window>
  );
};
