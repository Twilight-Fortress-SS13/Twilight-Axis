import { Box, Button, Section, Stack } from 'tgui-core/components';

import type { Data, KeybindEntry } from '../types';
import { Subhead, cardStyle } from '../components/shared';

export const KeysTab = (props: {
  data: Data;
  onCapture: (binding: KeybindEntry, oldKey?: string | null) => void;
  onResetDefaults: () => void;
}) => (
  <Section title="Клавиши" fill scrollable>
    <Stack mb={0.6} align="center">
      <Stack.Item grow>
        <Box color="label">Активный пресет: <b>{props.data.keybind_mode || 'Hotkey'}</b></Box>
      </Stack.Item>
      <Stack.Item>
        <Button onClick={props.onResetDefaults}>Сбросить</Button>
      </Stack.Item>
    </Stack>

    {(props.data.keybinding_catalog || []).map((category) => (
      <Box key={category.name} mb={0.8}>
        <Subhead>{category.name}</Subhead>
        {category.bindings.map((binding) => {
          const keys = props.data.keybinding_values?.[binding.id] || [];
          return (
            <Box key={binding.id} mb={0.35} p={0.55} style={cardStyle}>
              <Stack align="center">
                <Stack.Item grow>
                  <Box style={{ overflowWrap: 'anywhere' }}>{binding.label}</Box>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    {keys.length ? keys.map((key) => (
                      <Stack.Item key={`${binding.id}-${key}`}>
                        <Button compact onClick={() => props.onCapture(binding, key)}>{key}</Button>
                      </Stack.Item>
                    )) : (
                      <Stack.Item>
                        <Button compact onClick={() => props.onCapture(binding, null)}>Не назначено</Button>
                      </Stack.Item>
                    )}
                    <Stack.Item>
                      <Button compact onClick={() => props.onCapture(binding, null)}>+</Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Box>
          );
        })}
      </Box>
    ))}
  </Section>
);
