import { Box, Dropdown, Section, Stack } from 'tgui-core/components';

import type { Data } from '../types';
import { CompactRow, Subhead, cardStyle } from '../components/shared';

const miscLabelBasis = '140px';

const getPreviewFloorName = (name?: string) => {
  const names: Record<string, string> = {
    Арлекинская: 'Плитка',
    Каменная: 'Камень',
    Земленая: 'Земля',
    Земляная: 'Земля',
  };
  return name ? names[name] || name : 'Плитка';
};

export const SystemTab = (props: {
  data: Data;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const settings = props.data.system_settings || {};
  return (
    <Stack fill>
      <Stack.Item basis="52%">
        <Section title="Интерфейс и отображение" fill scrollable>
          <Subhead>Интерфейс</Subhead>
          <Box mb={0.35} p={0.35} style={cardStyle}>
            <Stack align="center">
              <Stack.Item basis="180px" shrink={0}>
                <Box color="label">Фон персонажа</Box>
              </Stack.Item>
              <Stack.Item grow>
                <Dropdown
                  width="100%"
                  options={(props.data.preview_floor_options || []).map((floor) => ({
                    displayText: getPreviewFloorName(floor.name),
                    value: floor.id,
                  }))}
                  selected={getPreviewFloorName(settings.preview_floor_name)}
                  onSelected={(value) => props.act('set_preview_floor', { floor: String(value) })}
                />
              </Stack.Item>
            </Stack>
          </Box>
          <CompactRow
            label="Тема TGUI"
            value={settings.tgui_theme_name || 'Default'}
            onClick={() => props.act('link', { preference: 'tgui_theme' })}
          />
          <CompactRow
            label="Тема пергамента"
            value={settings.parchment_skin_name || 'Leatherbound'}
            onClick={() => props.act('link', { preference: 'parchment_skin' })}
          />
          <CompactRow
            label="Тема стат-панели"
            value={settings.statbrowser_theme_name || 'Matte Black'}
            onClick={() => props.act('link', { preference: 'statbrowser_theme' })}
          />
          <CompactRow
            label="Мониторы TGUI"
            value={settings.tgui_lock ? 'Primary' : 'All'}
            onClick={() => props.act('link', { preference: 'tgui_lock' })}
          />
          <CompactRow
            label="Фиксировать кнопки способностей"
            value={settings.buttons_locked ? 'Да' : 'Нет'}
            onClick={() => props.act('link', { preference: 'action_buttons' })}
          />

          <Subhead>Экран</Subhead>
          <CompactRow
            label="FPS"
            value={settings.clientfps ?? 0}
            onClick={() => props.act('link', { preference: 'clientfps', task: 'input' })}
          />
          <CompactRow
            label="Ambient Occlusion"
            value={settings.ambientocclusion ? 'Включено' : 'Выключено'}
            onClick={() => props.act('link', { preference: 'ambientocclusion' })}
          />
          <CompactRow
            label="Широкий экран"
            value={settings.widescreenpref ? 'Включён' : 'Выключен'}
            onClick={() => props.act('link', { preference: 'widescreenpref' })}
          />
          <CompactRow
            label="Fit Viewport"
            value={settings.auto_fit_viewport ? 'Auto' : 'Manual'}
            onClick={() => props.act('link', { preference: 'auto_fit_viewport' })}
          />
          <CompactRow
            label="Мигание окна"
            value={settings.windowflashing ? 'Включено' : 'Выключено'}
            onClick={() => props.act('link', { preference: 'winflash' })}
          />
          <CompactRow
            label="Красная вспышка экрана"
            value={settings.no_redflash ? 'Реже' : 'Обычно'}
            onClick={() => props.act('toggle_system_pref', { pref: 'no_redflash' })}
          />

          <Subhead>Чат</Subhead>
          <CompactRow
            label="Рунчат"
            value={settings.chat_on_map ? 'Да' : 'Нет'}
            onClick={() => props.act('link', { preference: 'chat_on_map' })}
          />
          <CompactRow
            label="Показывать рунчат без моба"
            value={settings.see_chat_non_mob ? 'Да' : 'Нет'}
            onClick={() => props.act('link', { preference: 'see_chat_non_mob' })}
          />
          <CompactRow
            label="Автопунктуация"
            value={settings.no_autopunctuate ? 'Выключена' : 'Включена'}
            onClick={() => props.act('toggle_system_pref', { pref: 'no_autopunctuate' })}
          />
          <CompactRow
            label="Шрифты языков"
            value={settings.no_language_fonts ? 'Скрыты' : 'Показываются'}
            onClick={() => props.act('toggle_system_pref', { pref: 'no_language_fonts' })}
          />
          <CompactRow
            label="Иконка языка"
            value={settings.no_language_icon ? 'Скрыта' : 'Показывается'}
            onClick={() => props.act('toggle_system_pref', { pref: 'no_language_icon' })}
          />
          <CompactRow
            label="Заглушать звуковые эмоуты животных"
            value={settings.mute_animal_emotes ? 'Да' : 'Нет'}
            onClick={() => props.act('toggle_system_pref', { pref: 'mute_animal_emotes' })}
          />
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="Разное" fill scrollable>
          <Subhead>Examine</Subhead>
          <CompactRow
            labelBasis={miscLabelBasis}
            label="Examine Theme"
            value={settings.examine_theme_name || 'None (Use Viewer\'s)'}
            onClick={() => props.act('link', { preference: 'examine_theme', task: 'input' })}
          />
          <CompactRow
            labelBasis={miscLabelBasis}
            label="Anonymize"
            value={settings.anonymize ? 'Да' : 'Нет'}
            onClick={() => props.act('toggle_system_pref', { pref: 'anonymize' })}
          />
          <CompactRow
            labelBasis={miscLabelBasis}
            label="Masked examine"
            value={settings.masked_examine ? 'Да' : 'Нет'}
            onClick={() => props.act('toggle_system_pref', { pref: 'masked_examine' })}
          />
          <CompactRow
            labelBasis={miscLabelBasis}
            label="Full examine"
            value={settings.full_examine ? 'Да' : 'Нет'}
            onClick={() => props.act('toggle_system_pref', { pref: 'full_examine' })}
          />
          <CompactRow
            labelBasis={miscLabelBasis}
            label="No examine blocks"
            value={settings.no_examine_blocks ? 'Да' : 'Нет'}
            onClick={() => props.act('toggle_system_pref', { pref: 'no_examine_blocks' })}
          />

          {settings.can_use_donor_visuals ? (
            <>
              <Subhead>Визуал для меценатов</Subhead>
              <CompactRow
                labelBasis={miscLabelBasis}
                label="Цвет в OOC"
                value={settings.donor_ooc_color ? 'Включён' : 'Выключен'}
                onClick={() => props.act('link', { preference: 'donor_ooc_color' })}
              />
              <CompactRow
                labelBasis={miscLabelBasis}
                label="Иконка в OOC"
                value={settings.donor_ooc_icon ? 'Включена' : 'Выключена'}
                onClick={() => props.act('link', { preference: 'donor_ooc_icon' })}
              />
              <CompactRow
                labelBasis={miscLabelBasis}
                label="Иконка в examine"
                value={settings.donor_examine_icon ? 'Включена' : 'Выключена'}
                onClick={() => props.act('link', { preference: 'donor_examine_icon' })}
              />
            </>
          ) : null}

          {settings.is_admin ? (
            <>
              <Subhead>Администратор</Subhead>
              <CompactRow
                labelBasis={miscLabelBasis}
                label="Play Admin MIDIs"
                value={settings.play_admin_midis ? 'Включено' : 'Выключено'}
                onClick={() => props.act('link', { preference: 'hear_midis' })}
              />
              <CompactRow
                labelBasis={miscLabelBasis}
                label="Adminhelp sounds"
                value={settings.hear_adminhelps ? 'Включено' : 'Выключено'}
                onClick={() => props.act('link', { preference: 'hear_adminhelps' })}
              />
              {settings.can_edit_asaycolor ? (
                <CompactRow
                  labelBasis={miscLabelBasis}
                  label="ASAY цвет"
                  value={settings.asaycolor || '#ff4500'}
                  colorPreview={settings.asaycolor || '#ff4500'}
                  onClick={() => props.act('link', { preference: 'asaycolor', task: 'input' })}
                />
              ) : null}
              <CompactRow
                labelBasis={miscLabelBasis}
                label="Always deadmin"
                value={settings.deadmin_always_forced ? 'Принудительно' : settings.deadmin_always ? 'Включено' : 'Выключено'}
                onClick={settings.deadmin_always_forced ? undefined : () => props.act('link', { preference: 'toggle_deadmin_always' })}
              />
              <CompactRow
                labelBasis={miscLabelBasis}
                label="Deadmin as antag"
                value={settings.deadmin_antag_forced ? 'Принудительно' : settings.deadmin_antag ? 'Deadmin' : 'Keep Admin'}
                onClick={settings.deadmin_antag_forced ? undefined : () => props.act('link', { preference: 'toggle_deadmin_antag' })}
              />
              <CompactRow
                labelBasis={miscLabelBasis}
                label="Deadmin as command"
                value={settings.deadmin_head_forced ? 'Принудительно' : settings.deadmin_head ? 'Deadmin' : 'Keep Admin'}
                onClick={settings.deadmin_head_forced ? undefined : () => props.act('link', { preference: 'toggle_deadmin_head' })}
              />
            </>
          ) : null}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
