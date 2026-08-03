import { Section, Stack } from 'tgui-core/components';

import type { Data } from '../types';
import { ContextDropdownRow, resolveContextSelector } from '../modals/PreferenceModals';
import {
  CompactRow,
  PaletteButton,
  SliderNumberRow,
  manorSummary,
} from '../components/shared';

export const GeneralTab = (props: {
  data: Data;
  onEditPreference: (preference: string) => void;
  onManageVices: () => void;
  onOpenDescriptors: () => void;
  onOpenCulinary: () => void;
  onOpenFamiliar: () => void;
  onOpenManor: () => void;
  onOpenVirtueSelector: (kind: 'virtue_primary' | 'virtue_secondary') => void;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => (
  <Stack fill>
    <Stack.Item basis="56%">
      <Section title="Общее" fill scrollable>
        <ContextDropdownRow
          label="Возраст"
          selector={resolveContextSelector(props.data, 'age')}
          onSelected={(value) => props.act('set_context_preference', { kind: 'age', value })}
        />
        <ContextDropdownRow
          label="Вера"
          selector={resolveContextSelector(props.data, 'faith')}
          showMeta={false}
          onSelected={(value) => props.act('set_context_preference', { kind: 'faith', value })}
        />
        <ContextDropdownRow
          label="Покровитель"
          selector={resolveContextSelector(props.data, 'patron')}
          onSelected={(value) => props.act('set_context_preference', { kind: 'patron', value })}
        />
        <CompactRow label="Происхождение" value={props.data.appearance.origin} onClick={() => props.onEditPreference('origin')} />
        {props.data.appearance.race_bonus_available ? (
          <CompactRow
            label="Расовый бонус"
            value={props.data.appearance.race_bonus || 'None'}
            onClick={() => props.onEditPreference('race_bonus_select')}
          />
        ) : null}
        <ContextDropdownRow
          label="Доп. язык"
          selector={resolveContextSelector(props.data, 'extra_language')}
          onSelected={(value) => props.act('set_context_preference', { kind: 'extra_language', value })}
        />
        <ContextDropdownRow
          label="Акцент"
          selector={resolveContextSelector(props.data, 'char_accent')}
          onSelected={(value) => props.act('set_context_preference', { kind: 'char_accent', value })}
        />
        <CompactRow label="Дескрипторы" value="Открыть" onClick={props.onOpenDescriptors} />
        <ContextDropdownRow
          label="Голосовой пак"
          selector={resolveContextSelector(props.data, 'voicepack')}
          onSelected={(value) => props.act('set_context_preference', { kind: 'voicepack', value })}
        />
        <SliderNumberRow
          label="Высота голоса"
          value={Number(props.data.identity.voice_pitch || 1)}
          min={props.data.preference_limits?.voice_pitch_min || 0.8}
          max={props.data.preference_limits?.voice_pitch_max || 1.35}
          step={0.01}
          paletteColor={props.data.identity.voice_color}
          paletteTooltip="Цвет голоса"
          sliderTooltip="Высота голоса"
          onPaletteClick={() => props.onEditPreference('voice')}
          onCommit={(value) => props.act('set_voice_pitch_value', { value })}
        />
      </Section>
    </Stack.Item>
    <Stack.Item grow>
      <Stack vertical fill>
        <Stack.Item basis="48%">
          <Section title="Черты" fill scrollable>
            <CompactRow
              label="Статпак"
              value={props.data.appearance.statpack || 'None'}
              onClick={() => props.onEditPreference('statpack')}
            />
            <CompactRow
              label="Особенность"
              value={props.data.context_selectors?.virtue_primary?.current || 'None'}
              onClick={() => props.onOpenVirtueSelector('virtue_primary')}
            />
            {props.data.appearance.statpack_virtuous ? (
              <CompactRow
                label="Вторая особенность"
                value={props.data.context_selectors?.virtue_secondary?.current || 'None'}
                onClick={() => props.onOpenVirtueSelector('virtue_secondary')}
              />
            ) : null}
            <CompactRow
              wrap
              label="Пороки"
              value={props.data.virtues.vices.length ? props.data.virtues.vices.join(', ') : 'Открыть'}
              onClick={props.onManageVices}
            />
            <CompactRow label="Доминация руки" value={props.data.identity.domhand || 'Right-handed'} onClick={() => props.onEditPreference('domhand')} />
            <CompactRow label="Возможность воскрешать" value={props.data.identity.dnr_pref ? 'Нет' : 'Да'} onClick={() => props.onEditPreference('dnr')} />
            <CompactRow label="Предпочтения в еде" value="Открыть" onClick={props.onOpenCulinary} />
          </Section>
        </Stack.Item>
        <Stack.Item grow>
          <Section title="Разное" fill scrollable>
            <CompactRow
              label="Прозвище"
              value={props.data.identity.nickname}
              onClick={() => props.onEditPreference('nickname')}
              labelBasis="120px"
              valueStyle={{ fontSize: 'clamp(11px, 1.15vw, 14px)' }}
              auxButton={(
                <PaletteButton
                  color={props.data.identity.highlight_color}
                  onClick={() => props.onEditPreference('highlight_color')}
                />
              )}
            />
            <CompactRow label="Боевая музыка" value={props.data.identity.combat_music || 'Default'} onClick={() => props.onEditPreference('combat_music')} />
            <CompactRow label="Имение" value={manorSummary(props.data.roleplay)} onClick={props.onOpenManor} />
            <CompactRow label="Фамильяр" value="Открыть" onClick={props.onOpenFamiliar} />
            <CompactRow label="Арлит" value="Открыть" onClick={() => props.act('link', { preference: 'ccg_settings' })} />
            <CompactRow
              label="Быть ментором"
              value={props.data.system_settings?.schizo_voice ? 'Да' : 'Нет'}
              onClick={() => props.act('link', { preference: 'schizo_voice' })}
            />
            <CompactRow
              label="Autoconsume"
              value={props.data.system_settings?.autoconsume ? 'Да' : 'Нет'}
              onClick={() => props.act('toggle_system_pref', { pref: 'autoconsume' })}
            />
          </Section>
        </Stack.Item>
      </Stack>
    </Stack.Item>
  </Stack>
);
