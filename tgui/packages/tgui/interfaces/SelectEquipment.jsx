import { useState } from 'react';
import { Box, Button, Input, Section, Stack, Tabs } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import { useBackend } from '../backend';
import { Window } from '../layouts';

function getEntryLabel(entry) {
  return entry.path ? `${entry.name} - ${entry.path}` : entry.name;
}

export function SelectEquipment() {
  const { act, data } = useBackend();
  const {
    entries = [],
    selected,
    target_name,
    reset_before_apply = false,
    magic = {},
  } = data;
  const categories = ['General', 'Roguetown Jobs', 'Custom', 'Magic'];
  const [tab, setTab] = useState('General');
  const [searchText, setSearchText] = useState('');
  const searching = tab !== 'Magic' && !!searchText.trim();
  const searchFilter = createSearch(
    searchText,
    (entry) => `${entry.name} ${entry.path || ''} ${entry.category}`,
  );

  const visibleEntries = entries
    .filter((entry) => searching || entry.category === tab)
    .filter(searchFilter)
    .sort((left, right) => String(left.name).localeCompare(String(right.name)));

  const selectedEntry = entries.find((entry) => entry.id === selected);
  const majorAspects = magic.major_aspects || [];
  const minorAspects = magic.minor_aspects || [];
  const majorSlots = Number(magic.major_slots || 0);
  const minorSlots = Number(magic.minor_slots || 0);
  const mastery = Boolean(magic.mastery);
  const magicAvailable = Boolean(magic.available);

  return (
    <Window width={720} height={570}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title={`Select Equipment — ${target_name}`}>
              <Stack>
                <Stack.Item grow>
                  {tab !== 'Magic' && (
                    <Input
                      fluid
                      autoFocus
                      placeholder="Search outfits, jobs and presets..."
                      value={searchText}
                      onChange={setSearchText}
                    />
                  )}
                </Stack.Item>
                <Stack.Item>
                  <Button icon="save" onClick={() => act('save')}>
                    Save Preset
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Tabs textAlign="center">
              {categories.map((category) => (
                <Tabs.Tab
                  key={category}
                  selected={!searching && tab === category}
                  onClick={() => {
                    setTab(category);
                    setSearchText('');
                  }}
                >
                  {category}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>

          <Stack.Item grow basis={0}>
            {tab === 'Magic' ? (
              <Section fill scrollable>
                {!magicAvailable ? (
                  <Box color="label" textAlign="center" mt={2}>
                    Apply an outfit or create a human body before editing magic.
                  </Box>
                ) : (
                  <Stack vertical>
                    <Stack.Item>
                      <Section title="Major Aspects">
                        <Stack align="center">
                          <Stack.Item grow basis={0}>
                            <Box bold>
                              {majorAspects.length
                                ? majorAspects.join(', ')
                                : 'None'}
                            </Box>
                            <Box color="label">
                              Attuned: {majorAspects.length} / Slots: {majorSlots}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              icon="plus"
                              onClick={() => act('magic-give-major')}
                            >
                              Give
                            </Button>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              color="bad"
                              icon="minus"
                              disabled={!majorAspects.length}
                              onClick={() => act('magic-remove-major')}
                            >
                              Remove
                            </Button>
                          </Stack.Item>
                        </Stack>
                        <Stack align="center" mt={1}>
                          <Stack.Item grow />
                          <Stack.Item>
                            <Button
                              icon="minus"
                              disabled={majorSlots <= majorAspects.length}
                              onClick={() =>
                                act('magic-adjust-aspect-cap', {
                                  kind: 'major',
                                  delta: -1,
                                })
                              }
                            />
                          </Stack.Item>
                          <Stack.Item>
                            <Box bold minWidth="24px" textAlign="center">
                              {majorSlots}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              icon="plus"
                              onClick={() =>
                                act('magic-adjust-aspect-cap', {
                                  kind: 'major',
                                  delta: 1,
                                })
                              }
                            />
                          </Stack.Item>
                        </Stack>
                      </Section>
                    </Stack.Item>

                    <Stack.Item>
                      <Section title="Minor Aspects">
                        <Stack align="center">
                          <Stack.Item grow basis={0}>
                            <Box bold>
                              {minorAspects.length
                                ? minorAspects.join(', ')
                                : 'None'}
                            </Box>
                            <Box color="label">
                              Attuned: {minorAspects.length} / Slots: {minorSlots}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              icon="plus"
                              onClick={() => act('magic-give-minor')}
                            >
                              Give
                            </Button>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              color="bad"
                              icon="minus"
                              disabled={!minorAspects.length}
                              onClick={() => act('magic-remove-minor')}
                            >
                              Remove
                            </Button>
                          </Stack.Item>
                        </Stack>
                        <Stack align="center" mt={1}>
                          <Stack.Item grow />
                          <Stack.Item>
                            <Button
                              icon="minus"
                              disabled={minorSlots <= minorAspects.length}
                              onClick={() =>
                                act('magic-adjust-aspect-cap', {
                                  kind: 'minor',
                                  delta: -1,
                                })
                              }
                            />
                          </Stack.Item>
                          <Stack.Item>
                            <Box bold minWidth="24px" textAlign="center">
                              {minorSlots}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              icon="plus"
                              onClick={() =>
                                act('magic-adjust-aspect-cap', {
                                  kind: 'minor',
                                  delta: 1,
                                })
                              }
                            />
                          </Stack.Item>
                        </Stack>
                      </Section>
                    </Stack.Item>

                    <Stack.Item>
                      <Section title="Mastery">
                        <Stack align="center">
                          <Stack.Item grow>
                            <Box bold>{mastery ? 'Enabled' : 'Disabled'}</Box>
                            <Box color="label">
                              Enables mastery aspect variants and mastery-only aspect
                              choices.
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              selected={mastery}
                              icon={mastery ? 'check' : 'times'}
                              onClick={() => act('magic-toggle-mastery')}
                            >
                              Toggle Mastery
                            </Button>
                          </Stack.Item>
                        </Stack>
                      </Section>
                    </Stack.Item>

                    <Stack.Item>
                      <Section title="Miracles">
                        <Stack align="center">
                          <Stack.Item grow basis={0}>
                            <Box bold>Patron: {magic.patron || 'None'}</Box>
                            <Box color="label">
                              Current devotion tier: {magic.devotion_tier || 'None'}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              icon="plus"
                              onClick={() => act('magic-give-miracles')}
                            >
                              Give by Tier
                            </Button>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              color="bad"
                              icon="minus"
                              onClick={() => act('magic-remove-miracles')}
                            >
                              Remove Miracles
                            </Button>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              color="bad"
                              icon="trash"
                              onClick={() => act('magic-clear-devotion')}
                            >
                              Remove Devotion
                            </Button>
                          </Stack.Item>
                        </Stack>
                      </Section>
                    </Stack.Item>
                  </Stack>
                )}
              </Section>
            ) : (
              <Section fill scrollable>
                {!visibleEntries.length && (
                  <Box color="label" textAlign="center" mt={2}>
                    Nothing found.
                  </Box>
                )}
                {visibleEntries.map((entry) => (
                  <Stack key={entry.id} mb={0.5} align="center">
                    <Stack.Item grow basis={0}>
                      <Button
                        fluid
                        ellipsis
                        selected={entry.id === selected}
                        title={getEntryLabel(entry)}
                        onClick={() => act('select', { id: entry.id })}
                        onDoubleClick={() => act('apply', { id: entry.id })}
                      >
                        <Stack align="center">
                          <Stack.Item grow basis={0}>
                            {getEntryLabel(entry)}
                          </Stack.Item>
                          {searching && (
                            <Stack.Item>
                              <Box color="label" fontSize="11px">
                                {entry.category}
                              </Box>
                            </Stack.Item>
                          )}
                        </Stack>
                      </Button>
                    </Stack.Item>
                    {Boolean(entry.deletable) && (
                      <Stack.Item>
                        <Button
                          color="bad"
                          icon="trash"
                          tooltip="Delete saved preset"
                          onClick={() => act('delete', { id: entry.id })}
                        />
                      </Stack.Item>
                    )}
                  </Stack>
                ))}
              </Section>
            )}
          </Stack.Item>

          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow basis={0}>
                  <Box color="label">Selected:</Box>
                  <Box bold>
                    {selectedEntry ? getEntryLabel(selectedEntry) : 'Nothing selected'}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon={reset_before_apply ? 'check-square' : 'square'}
                    selected={reset_before_apply}
                    tooltip="Before Apply, restore base character stats and clear skills, spells, miracles, mage aspects and every trait except traits granted directly by the current patron."
                    onClick={() => act('toggle-reset-before-apply')}
                  >
                    Reset before Apply
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="bad"
                    icon="eraser"
                    tooltip="Immediately clear equipment and current class/loadout state without applying another outfit."
                    onClick={() => act('reset-character')}
                  >
                    Full Reset
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="good"
                    icon="check"
                    disabled={!selectedEntry}
                    onClick={() => act('apply', { id: selected })}
                  >
                    Apply
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}
