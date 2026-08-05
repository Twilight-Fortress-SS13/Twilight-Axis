import { Section, Stack } from 'tgui-core/components';

import type { Data } from '../types';
import { ContextDropdownRow, resolveContextSelector } from '../modals/PreferenceModals';
import {
  CompactRow,
  PaletteButton,
  SliderNumberRow,
  manorSummary,
} from '../components/shared';

const generalLabelBasis = '100px';
const traitsLabelBasis = '130px';

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
          labelBasis={generalLabelBasis}
          selector={resolveContextSelector(props.data, 'age')}
          showMeta={false}
          onSelected={(value) => props.act('set_context_preference', { kind: 'age', value })}
        />
        <ContextDropdownRow
          label="Вера"
          labelBasis={generalLabelBasis}
          selector={resolveContextSelector(props.data, 'faith')}
          showMeta={false}
          showCurrentInfo
          onSelected={(value) => props.act('set_context_preference', { kind: 'faith', value })}
        />
        <ContextDropdownRow
          label="Покровитель"
          labelBasis={generalLabelBasis}
          selector={resolveContextSelector(props.data, 'patron')}
          onSelected={(value) => props.act('set_context_preference', { kind: 'patron', value })}
        />
        <CompactRow label="Происхождение" labelBasis={generalLabelBasis} value={props.data.appearance.origin} onClick={() => props.onEditPreference('origin')} />
        {props.data.appearance.race_bonus_available ? (
          <CompactRow
            label="Расовый бонус"
            labelBasis={generalLabelBasis}
            value={props.data.appearance.race_bonus || 'None'}
            onClick={() => props.onEditPreference('race_bonus_select')}
          />
        ) : null}
        <ContextDropdownRow
          label="Доп. язык"
          labelBasis={generalLabelBasis}
          selector={resolveContextSelector(props.data, 'extra_language')}
          onSelected={(value) => props.act('set_context_preference', { kind: 'extra_language', value })}
        />
        <ContextDropdownRow
          label="Акцент"
          labelBasis={generalLabelBasis}
          selector={resolveContextSelector(props.data, 'char_accent')}
          onSelected={(value) => props.act('set_context_preference', { kind: 'char_accent', value })}
        />
        <CompactRow label="Дескрипторы" labelBasis={generalLabelBasis} value="Открыть" onClick={props.onOpenDescriptors} />
        <ContextDropdownRow
          label="Голосовой пак"
          labelBasis={generalLabelBasis}
          selector={resolveContextSelector(props.data, 'voicepack')}
          onSelected={(value) => props.act('set_context_preference', { kind: 'voicepack', value })}
        />
        <SliderNumberRow
          label="Высота голоса"
          labelBasis={generalLabelBasis}
          value={Number(props.data.identity.voice_pitch || 1)}
          min={props.data.preference_limits?.voice_pitch_min || 0.8}
          max={props.data.preference_limits?.voice_pitch_max || 1.35}
          step={0.01}
          stepPixelSize={5}
          formatValue={(value) => value.toFixed(2)}
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
              labelBasis={traitsLabelBasis}
              value={props.data.appearance.statpack || 'None'}
              onClick={() => props.onEditPreference('statpack')}
            />
            <CompactRow
              label="Особенность"
              labelBasis={traitsLabelBasis}
              value={props.data.context_selectors?.virtue_primary?.current || 'None'}
              onClick={() => props.onOpenVirtueSelector('virtue_primary')}
            />
            {props.data.appearance.statpack_virtuous ? (
              <CompactRow
                label="Вторая особенность"
                labelBasis={traitsLabelBasis}
                value={props.data.context_selectors?.virtue_secondary?.current || 'None'}
                onClick={() => props.onOpenVirtueSelector('virtue_secondary')}
              />
            ) : null}
            <CompactRow
              wrap
              label="Пороки"
              labelBasis={traitsLabelBasis}
              value={props.data.virtues.vices.length ? props.data.virtues.vices.join(', ') : 'Открыть'}
              onClick={props.onManageVices}
            />
            <CompactRow label="Доминация руки" labelBasis={traitsLabelBasis} value={props.data.identity.domhand || 'Right-handed'} onClick={() => props.onEditPreference('domhand')} />
            <CompactRow label="Возможность воскрешать" labelBasis={traitsLabelBasis} value={props.data.identity.dnr_pref ? 'Нет' : 'Да'} onClick={() => props.onEditPreference('dnr')} />
            <CompactRow label="Предпочтения в еде" labelBasis={traitsLabelBasis} value="Открыть" onClick={props.onOpenCulinary} />
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
            <CompactRow label="Arlette" value="Открыть" onClick={() => props.act('link', { preference: 'ccg_settings' })} />
            <CompactRow
              label="Быть ментором"
              value={props.data.system_settings?.schizo_voice ? 'Да' : 'Нет'}
              onClick={() => props.act('link', { preference: 'schizo_voice' })}
            />
          </Section>
        </Stack.Item>
      </Stack>
    </Stack.Item>
  </Stack>
);
