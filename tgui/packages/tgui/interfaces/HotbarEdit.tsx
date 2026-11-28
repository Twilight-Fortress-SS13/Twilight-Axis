import { LabeledGridList } from 'pm/components';
import type { KeyBind } from 'pm/data';
import { useBackendStrict } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Divider, Section } from 'tgui-core/components';

export type HotbarKeyBind = KeyBind & {
  description?: string;
  hotbar_index?: number;
  slot_index?: number;
};

export type HotbarKeybindGroup = {
  hotbar_index: number;
  title: string;
  keybindings: HotbarKeyBind[];
};

export type HotbarEditData = {
  max_keys_per_keybind?: number;
  hotbars?: HotbarKeybindGroup[];
  keybindings?: HotbarKeyBind[];
};

const DEFAULT_MAX_KEYS_PER_KEYBIND = 3;

export const HotbarEdit = () => {
  const { config } = useBackendStrict<HotbarEditData>();

  const theme =
    config.window?.theme === 'trey_liam'
      ? 'azure_ascendant'
      : config.window?.theme;

  return (
    <Window width={720} height={760} theme={theme} title="Hotbar edit">
      <Window.Content className="PreferencesMenu">
        <HotbarEditContent />
      </Window.Content>
    </Window>
  );
};

export const HotbarEditContent = () => {
  const { act, data } = useBackendStrict<HotbarEditData>();
  const maxKeysPerKeybind =
    data.max_keys_per_keybind || DEFAULT_MAX_KEYS_PER_KEYBIND;

  const hotbarGroups: HotbarKeybindGroup[] = data.hotbars?.length
    ? data.hotbars
    : groupKeybindingsByHotbar(data.keybindings || []);

  return (
    <Section fill scrollable title="Hotbar Keybinds (Auto-Saves on Change)">
      {hotbarGroups.map((group, groupIndex) => (
        <Box
          key={group.hotbar_index}
          pt={1.5}
          pb={1.5}
          pl={1}
          pr={1}
          mt={groupIndex === 0 ? 0.5 : 1.5}
          mb={1.5}
        >
          <LabeledGridList>
            {group.keybindings.map((kb) => (
              <HotbarKeybindRow
                key={kb.name}
                kb={kb}
                maxKeysPerKeybind={maxKeysPerKeybind}
              />
            ))}
          </LabeledGridList>
          {groupIndex < hotbarGroups.length - 1 ? (
            <Box mt={1.5}>
              <Divider />
            </Box>
          ) : null}
        </Box>
      ))}
      <Button inline color="bad" onClick={() => act('keybindings_reset')}>
        [Reset to default]
      </Button>
    </Section>
  );
};

const HotbarKeybindRow = (props: {
  kb: HotbarKeyBind;
  maxKeysPerKeybind: number;
}) => {
  const { kb, maxKeysPerKeybind } = props;
  const { act } = useBackendStrict<HotbarEditData>();

  return (
    <LabeledGridList.Item label={kb.full_name} tooltip={kb.description}>
      {kb.user_binds?.length ? (
        kb.user_binds.map((binding, idx) => (
          <Button
            key={idx}
            inline
            onClick={() =>
              act('keybindings_capture', {
                keybinding: kb.name,
                old_key: binding,
              })
            }
          >
            {binding}
          </Button>
        ))
      ) : (
        <Button
          inline
          onClick={() =>
            act('keybindings_capture', {
              keybinding: kb.name,
              old_key: 'Unbound',
            })
          }
        >
          Unbound
        </Button>
      )}
      {/* only show if it's not unbound */}
      {(kb.user_binds?.length || maxKeysPerKeybind) < maxKeysPerKeybind ? (
        <Button
          inline
          onClick={() =>
            act('keybindings_capture', {
              keybinding: kb.name,
              old_key: '',
            })
          }
        >
          Add Secondary
        </Button>
      ) : null}
      {kb.default_keys?.length ? (
        <Box inline>
          Default:&nbsp;
          {kb.default_keys.join(',')}
        </Box>
      ) : null}
    </LabeledGridList.Item>
  );
};

function groupKeybindingsByHotbar(
  keybindings: HotbarKeyBind[],
): HotbarKeybindGroup[] {
  const map = new Map<number, HotbarKeyBind[]>();

  for (const kb of keybindings) {
    let barIdx = kb.hotbar_index;
    if (!barIdx) {
      const match = kb.name.match(/^hotbar_(\d+)_slot_(\d+)$/);
      barIdx = match ? Number(match[1]) : 1;
    }
    const list = map.get(barIdx) || [];
    list.push(kb);
    map.set(barIdx, list);
  }

  return Array.from(map.entries())
    .sort((a, b) => a[0] - b[0])
    .map(([hotbar_index, list]) => ({
      hotbar_index,
      title: `Hotbar ${hotbar_index}`,
      keybindings: list,
    }));
}
