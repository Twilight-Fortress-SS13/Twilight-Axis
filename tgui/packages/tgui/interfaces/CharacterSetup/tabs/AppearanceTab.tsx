import { useMemo, useState } from 'react';
import { Box, Dropdown, Section, Stack } from 'tgui-core/components';

import type { Data, SimpleCustomizer } from '../types';
import { HairPopup } from '../modals/CustomizerModals';
import { ContextDropdownRow, resolveContextSelector } from '../modals/PreferenceModals';
import {
  CompactRow,
  PaletteButton,
  SliderNumberRow,
  cardStyle,
} from '../components/shared';

const isNoneAccessoryValue = (value?: string | null) => !value || value === '__none__';

const ContextCustomizerRow = (props: {
  entry: SimpleCustomizer;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const isPrimaryGenital = /^(Пенис|Яички)$/i.test(props.entry.name) || /^(Penis|Testicles)$/i.test(props.entry.name);
  const isPresetSizeGenital = /^(Пенис|Яички|Влагалище|Грудь)$/i.test(props.entry.name)
    || /^(Penis|Testicles|Vagina|Breasts?)$/i.test(props.entry.name);
  const forceNoneOption = ['Влагалище', 'Грудь'].includes(props.entry.name);
  const selectedValue = props.entry.selected_accessory_id || '__none__';
  const accessoryDisabled = isNoneAccessoryValue(selectedValue);
  const customizerDisabled = !!props.entry.disabled;
  const colorLabels = props.entry.accessory_color_labels || [];
  const colorValues = props.entry.accessory_color_values || [];
  const hasInlineColorButtons = !!(props.entry.allows_accessory_color_customization && colorLabels.length);
  const lockAccessorySelection = /душ/i.test(props.entry.name) || /soul/i.test(props.entry.name);
  const optionItems = [
    ...(props.entry.allows_disabling || forceNoneOption || accessoryDisabled ? [{ displayText: 'None', value: '__none__' }] : []),
    ...props.entry.options.map((option) => ({
      displayText: option.name,
      value: option.id,
    })),
  ];
  const currentChoice = props.entry.choice_groups?.find((group) => group.current);
  const hasChoiceGroups = !!props.entry.choice_groups?.length;
  const hasChoiceSelector = !!(!lockAccessorySelection && props.entry.can_change_choice && hasChoiceGroups);
  const useMergedGenitalSelector = !!(!lockAccessorySelection && isPrimaryGenital && hasChoiceGroups);
  const hideEmptyAccessorySelector = hasChoiceSelector && !props.entry.options.length;
  const mergedGenitalOptions = [
    { displayText: 'None', value: '__none__' },
    ...(props.entry.choice_groups || []).map((group) => ({ displayText: group.name, value: group.id })),
  ];
  const showSize = !!props.entry.size_var_name && (isPrimaryGenital ? !customizerDisabled : !accessoryDisabled);
  const numericSize = Number(props.entry.size_value ?? 2);
  const fallbackSizeId = numericSize <= 1 ? 'small' : numericSize >= 3 ? 'large' : 'medium';
  const effectiveSizeOptions = props.entry.size_options?.length
    ? props.entry.size_options
    : (isPresetSizeGenital && props.entry.size_is_numeric
      ? [
          { id: 'small', name: 'Маленький', current: fallbackSizeId === 'small' },
          { id: 'medium', name: 'Средний', current: fallbackSizeId === 'medium' },
          { id: 'large', name: 'Большой', current: fallbackSizeId === 'large' },
        ]
      : []);
  const effectiveSizeSelectedId = props.entry.size_selected_id || fallbackSizeId;

  return (
    <Box mb={0.35} p={0.35} style={cardStyle}>
      <Stack align="center">
        <Stack.Item basis="124px" shrink={0}>
          <Box color="label">{props.entry.name}</Box>
        </Stack.Item>
        {hasInlineColorButtons ? (
          <Stack.Item shrink={0} mr={0.35}>
            <Stack>
              {colorLabels.map((label, index) => (
                <Stack.Item key={`${props.entry.id}-color-${index}`}>
                  <PaletteButton
                    color={colorValues[index]}
                    disabled={customizerDisabled || accessoryDisabled}
                    tooltip={label}
                    onClick={() => props.act('edit_accessory_color', { customizer: props.entry.id, index: index + 1 })}
                  />
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
        ) : null}
        {useMergedGenitalSelector ? (
          <Stack.Item grow>
            <Dropdown
              width="100%"
              options={mergedGenitalOptions}
              selected={customizerDisabled ? 'None' : (currentChoice?.name || props.entry.choice_name)}
              onSelected={(value) => {
                if (value === '__none__') {
                  props.act('set_customizer_none', { customizer: props.entry.id });
                } else {
                  props.act('set_customizer_choice', { customizer: props.entry.id, choice: value, enable: 1 });
                }
              }}
            />
          </Stack.Item>
        ) : (
          <>
            {hasChoiceSelector ? (
              <Stack.Item basis={hideEmptyAccessorySelector ? undefined : '150px'} grow={hideEmptyAccessorySelector} shrink={0}>
                <Dropdown
                  width="100%"
                  options={props.entry.choice_groups!.map((group) => ({ displayText: group.name, value: group.id }))}
                  selected={currentChoice?.name || props.entry.choice_name}
                  onSelected={(value) => props.act('set_customizer_choice', { customizer: props.entry.id, choice: value })}
                />
              </Stack.Item>
            ) : null}
            {!hideEmptyAccessorySelector ? (
              <Stack.Item grow>
                {lockAccessorySelection ? (
                  <Box px={0.7} py={0.45} style={cardStyle}>Цвет</Box>
                ) : (
                  <Dropdown
                    width="100%"
                    options={optionItems}
                    selected={accessoryDisabled ? 'None' : (props.entry.current_accessory_name || 'None')}
                    onSelected={(value) => {
                      if (value === '__none__') {
                        props.act('set_customizer_none', { customizer: props.entry.id });
                      } else {
                        props.act('set_customizer_accessory', { customizer: props.entry.id, accessory: value });
                      }
                    }}
                  />
                )}
              </Stack.Item>
            ) : null}
          </>
        )}
      </Stack>
      {showSize ? (
        <Box mt={0.3} style={{ minWidth: 0, maxWidth: '100%', overflow: 'hidden' }}>
          {effectiveSizeOptions.length ? (
            <Box p={0.35} style={{ ...cardStyle, minWidth: 0, maxWidth: '100%', overflow: 'hidden' }}>
              <Stack align="center" fill>
                <Stack.Item basis="100px" shrink={0}>
                  <Box color="label">{props.entry.size_label || 'Размер'}</Box>
                </Stack.Item>
                <Stack.Item grow style={{ minWidth: 0 }}>
                  <Dropdown
                    width="100%"
                    options={effectiveSizeOptions.map((option) => ({ displayText: option.name, value: option.id }))}
                    selected={effectiveSizeOptions.find((option) => option.id === effectiveSizeSelectedId)?.name || String(props.entry.size_value ?? 'Не задан')}
                    onSelected={(value) => props.act('set_customizer_size_choice', {
                      customizer: props.entry.id,
                      var_name: props.entry.size_var_name,
                      value,
                    })}
                  />
                </Stack.Item>
              </Stack>
            </Box>
          ) : (
            <CompactRow
              label={props.entry.size_label || 'Размер'}
              labelBasis="100px"
              value={props.entry.size_value ?? 'Не задан'}
              onClick={() => props.act('edit_customizer_size', {
                customizer: props.entry.id,
                var_name: props.entry.size_var_name,
              })}
            />
          )}
        </Box>
      ) : null}
    </Box>
  );
};

export const AppearanceTab = (props: {
  data: Data;
  onEditPreference: (preference: string) => void;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const simpleEntries = useMemo(() => props.data.genital_customizers || [], [props.data.genital_customizers]);
  const bodyContextEntries = useMemo(() => props.data.body_context_customizers || [], [props.data.body_context_customizers]);
  const hairCustomizer = props.data.hair_customizer;
  const facialHairCustomizer = props.data.facial_hair_customizer;
  const [openHairCustomizerId, setOpenHairCustomizerId] = useState<string | null>(null);
  const activeHairCustomizer = props.data.active_customizer?.id === openHairCustomizerId && props.data.active_customizer.is_hair
    ? props.data.active_customizer
    : null;
  const activeHairOptions = activeHairCustomizer?.choice_id
    ? props.data.hair_option_catalog?.[activeHairCustomizer.choice_id] || []
    : [];

  const toggleHairCustomizer = (customizerId?: string) => {
    if (!customizerId) {
      return;
    }
    if (openHairCustomizerId === customizerId) {
      setOpenHairCustomizerId(null);
      return;
    }
    setOpenHairCustomizerId(customizerId);
    props.act('select_customizer', { customizer: customizerId });
  };

  const taurDisabled = !props.data.appearance.taur_type || props.data.appearance.taur_type === 'Нет' || props.data.appearance.taur_type === 'None';
  const bodyEntryMatcher = /ниж|бель|underwear|bra|pant|sock|stocking|чул|нос(ки|ок)|wing|крыл|tail|хвост|soul|душ/i;
  const bodyEntries = bodyContextEntries.filter((entry) => bodyEntryMatcher.test(entry.name));
  const faceEntries = bodyContextEntries.filter((entry) => !bodyEntryMatcher.test(entry.name));

  return (
    <Box style={{ position: 'relative', height: '100%' }}>
      <Stack fill>
        <Stack.Item basis="58%">
          <Stack vertical fill>
            <Stack.Item basis="55%">
              <Section title="Лицо и волосы" fill scrollable>
                {props.data.appearance.eye_heterochromia_available ? (
                  <CompactRow
                    label="Гетерохромия"
                    value={props.data.appearance.eye_heterochromia ? 'Да' : 'Нет'}
                    onClick={() => props.onEditPreference('eye_heterochromia')}
                  />
                ) : null}
                <CompactRow
                  label={props.data.appearance.eye_heterochromia ? 'Первый глаз' : 'Цвет глаз'}
                  value={props.data.appearance.eye_color}
                  colorPreview={props.data.appearance.eye_color}
                  onClick={() => props.onEditPreference('eyes')}
                />
                {props.data.appearance.eye_heterochromia_available && props.data.appearance.eye_heterochromia ? (
                  <CompactRow
                    label="Второй глаз"
                    value={props.data.appearance.eye_second_color || props.data.appearance.eye_color}
                    colorPreview={props.data.appearance.eye_second_color || props.data.appearance.eye_color}
                    onClick={() => props.onEditPreference('eye_second_color')}
                  />
                ) : null}
                <CompactRow label="Причёска" value={hairCustomizer?.current_accessory_name || 'Нет'} onClick={hairCustomizer?.id ? () => toggleHairCustomizer(hairCustomizer.id) : undefined} />
                {facialHairCustomizer?.option_count ? (
                  <CompactRow label="Борода" value={facialHairCustomizer.current_accessory_name || 'Нет'} onClick={facialHairCustomizer.id ? () => toggleHairCustomizer(facialHairCustomizer.id) : undefined} />
                ) : null}
                {faceEntries.length ? faceEntries.map((entry) => (
                  <ContextCustomizerRow key={entry.id} entry={entry} act={props.act} />
                )) : (
                  <Box color="label">Для этой расы нет дополнительных внешних настроек.</Box>
                )}
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section title="Тело" fill scrollable>
                {props.data.appearance.uses_skin_tones ? (
                  <ContextDropdownRow
                    label={props.data.appearance.skin_tone_wording || 'Skin Tone'}
                    selector={resolveContextSelector(props.data, 'skin_tone')}
                    onSelected={(value) => props.act('set_context_preference', { kind: 'skin_tone', value })}
                  />
                ) : null}
                <SliderNumberRow
                  label="Размер персонажа"
                  value={Number(props.data.appearance.body_size || 100)}
                  min={props.data.preference_limits?.body_size_min || 50}
                  max={props.data.preference_limits?.body_size_max || 150}
                  step={1}
                  stepPixelSize={12}
                  formatValue={(value) => `${Math.round(value)}%`}
                  onCommit={(value) => props.act('set_body_size_value', { value })}
                />
                <CompactRow
                  label="Обновлять цвета частей тела"
                  value={props.data.appearance.update_mutant_colors ? 'Да' : 'Нет'}
                  onClick={() => props.onEditPreference('update_mutant_colors')}
                />
                {props.data.appearance.mutant_colors_available ? (
                  <>
                    <CompactRow
                      label="Расовый цвет #1"
                      value="Изменить"
                      colorPreview={props.data.appearance.mutant_color_1}
                      onClick={() => props.onEditPreference('mutant_color')}
                    />
                    <CompactRow
                      label="Расовый цвет #2"
                      value="Изменить"
                      colorPreview={props.data.appearance.mutant_color_2}
                      onClick={() => props.onEditPreference('mutant_color2')}
                    />
                    <CompactRow
                      label="Расовый цвет #3"
                      value="Изменить"
                      colorPreview={props.data.appearance.mutant_color_3}
                      onClick={() => props.onEditPreference('mutant_color3')}
                    />
                  </>
                ) : null}
                {(props.data.appearance.taur_available || props.data.appearance.taur_type !== 'Нет') ? (
                  <ContextDropdownRow
                    label="Taur-body"
                    selector={resolveContextSelector(props.data, 'taur_type')}
                    onSelected={(value) => props.act('set_context_preference', { kind: 'taur_type', value })}
                    auxButton={(
                      <PaletteButton
                        color={props.data.appearance.taur_color}
                        disabled={taurDisabled}
                        onClick={() => props.onEditPreference('taur_color')}
                      />
                    )}
                  />
                ) : null}
                {bodyEntries.map((entry) => (
                  <ContextCustomizerRow key={entry.id} entry={entry} act={props.act} />
                ))}
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow>
          <Section title="Гениталии" fill scrollable>
            {simpleEntries.length ? simpleEntries.map((entry) => (
              <ContextCustomizerRow key={entry.id} entry={entry} act={props.act} />
            )) : (
              <Box color="label">Для этой расы нет дополнительных телесных настроек.</Box>
            )}
          </Section>
        </Stack.Item>
      </Stack>
      {openHairCustomizerId ? (
        <HairPopup
          active={activeHairCustomizer}
          options={activeHairOptions}
          act={props.act}
          onClose={() => setOpenHairCustomizerId(null)}
        />
      ) : null}
    </Box>
  );
};
