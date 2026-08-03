import { Box, Button, Section, Stack } from 'tgui-core/components';

import type { Data } from '../types';
import {
  CompactRow,
  Subhead,
  cardStyle,
  selectedCardStyle,
  truncate,
} from '../components/shared';

const VillainColorRow = (props: {
  label: string;
  value?: string | null;
  onEdit: () => void;
  onClear: () => void;
}) => (
  <CompactRow
    label={props.label}
    value={props.value || 'Не задано'}
    colorPreview={props.value}
    onClick={props.onEdit}
    auxButton={props.value ? (
      <Button
        compact
        icon="times"
        tooltip="Сбросить цвет"
        tooltipPosition="bottom"
        onClick={props.onClear}
      />
    ) : undefined}
  />
);

export const AntagsTab = (props: {
  data: Data;
  act: (action: string, payload?: Record<string, unknown>) => void;
  onEditPreference: (preference: string) => void;
  onEditTextField: (field: string) => void;
}) => (
  <Stack fill>
    <Stack.Item basis="56%">
      <Section title="Предпочтения антагонистов" fill scrollable>
        <Subhead>Доступные роли</Subhead>
        <Box style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: '8px' }}>
          {(props.data.antag_roles || []).map((role) => (
            <Box
              key={role.id}
              p={0.65}
              style={role.enabled ? selectedCardStyle : cardStyle}
            >
              <Box bold mb={0.25}>{role.name}</Box>
              <Box color="label" mb={0.5}>
                {role.disabled_reason || (role.enabled ? 'Включено' : 'Выключено')}
              </Box>
              <Button
                fluid
                selected={role.enabled}
                disabled={!!role.disabled_reason}
                onClick={() => props.act('link', { preference: 'antag', task: 'be_special', be_special_type: role.id })}
              >
                {role.enabled ? 'Отключить' : 'Включить'}
              </Button>
            </Box>
          ))}
        </Box>
        {!(props.data.antag_roles || []).length ? (
          <Box color="label">Список ролей не загрузился.</Box>
        ) : null}
        <Subhead>События</Subhead>
        <CompactRow
          label="Storyteller"
          value={props.data.villain_settings?.storyteller_enabled ? 'Включён' : 'Выключен'}
          onClick={() => props.act('link', { preference: 'storyteller' })}
        />
      </Section>
    </Stack.Item>
    <Stack.Item grow>
      <Section title="Настройки" fill scrollable>
        <Subhead>Портреты</Subhead>
        <CompactRow
          wrap
          label="Хедшот для лича"
          value={truncate(props.data.villain_settings?.lich_headshot_link || 'Не задан', 72)}
          onClick={() => props.onEditTextField('lich_headshot_link')}
        />
        <CompactRow
          wrap
          label="Хедшот для вампира"
          value={truncate(props.data.villain_settings?.vampire_headshot_link || 'Не задан', 72)}
          onClick={() => props.onEditTextField('vampire_headshot_link')}
        />

        <Subhead>Цвета вампира</Subhead>
        <VillainColorRow
          label="Кожа вампира"
          value={props.data.villain_settings?.vampire_skin}
          onEdit={() => props.act('edit_villain_color', { pref: 'vampire_skin' })}
          onClear={() => props.act('clear_villain_color', { pref: 'vampire_skin' })}
        />
        <VillainColorRow
          label="Глаза вампира"
          value={props.data.villain_settings?.vampire_eyes}
          onEdit={() => props.act('edit_villain_color', { pref: 'vampire_eyes' })}
          onClear={() => props.act('clear_villain_color', { pref: 'vampire_eyes' })}
        />
        <VillainColorRow
          label="Волосы вампира"
          value={props.data.villain_settings?.vampire_hair}
          onEdit={() => props.act('edit_villain_color', { pref: 'vampire_hair' })}
          onClear={() => props.act('clear_villain_color', { pref: 'vampire_hair' })}
        />
        <VillainColorRow
          label="Уши вампира"
          value={props.data.villain_settings?.vampire_ears}
          onEdit={() => props.act('edit_villain_color', { pref: 'vampire_ears' })}
          onClear={() => props.act('clear_villain_color', { pref: 'vampire_ears' })}
        />

        <Subhead>Прочее</Subhead>
        <CompactRow
          label="Устойчивость к quicksilver"
          value={props.data.villain_settings?.qsr_pref ? 'Да' : 'Нет'}
          onClick={() => props.act('toggle_system_pref', { pref: 'qsr_pref' })}
        />

        <Subhead>Предустановленная награда</Subhead>
        <CompactRow
          label="Назначать награду"
          value={props.data.villain_settings?.preset_bounty_enabled ? 'Да' : 'Нет'}
          onClick={() => props.onEditPreference('preset_bounty_toggle')}
        />
        {props.data.villain_settings?.preset_bounty_enabled ? (
          <>
            <CompactRow
              label="Заказчик"
              value={props.data.villain_settings?.preset_bounty_poster || 'None'}
              onClick={() => props.onEditPreference('preset_bounty_poster_key')}
            />
            <CompactRow
              label="Тяжесть: Wretch"
              value={props.data.villain_settings?.preset_bounty_wretch_severity || 'None'}
              onClick={() => props.onEditPreference('preset_bounty_severity_key')}
            />
            <CompactRow
              label="Тяжесть: Bandit"
              value={props.data.villain_settings?.preset_bounty_bandit_severity || 'None'}
              onClick={() => props.onEditPreference('preset_bounty_severity_b_key')}
            />
            <CompactRow
              label="Тяжесть: Vagabond"
              value={props.data.villain_settings?.preset_bounty_vagabond_severity || 'None'}
              onClick={() => props.onEditPreference('preset_bounty_severity_v_key')}
            />
            <CompactRow
              wrap
              label="Преступление"
              value={props.data.villain_settings?.preset_bounty_crime || 'None'}
              onClick={() => props.onEditPreference('preset_bounty_crime')}
            />
          </>
        ) : null}
      </Section>
    </Stack.Item>
  </Stack>
);
