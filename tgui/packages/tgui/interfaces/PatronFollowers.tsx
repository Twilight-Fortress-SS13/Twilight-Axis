import { useState } from 'react';
import { Box, Button, Input, Section, Stack, Table } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Follower = {
  ref: string;
  name: string;
  ckey: string;
};

type PatronGroup = {
  id: string;
  name: string;
  count: number;
  followers: Follower[];
};

type Data = {
  groups: PatronGroup[];
  total_followers: number;
};

export const PatronFollowers = () => {
  const { act, data } = useBackend<Data>();
  const { groups = [], total_followers = 0 } = data;
  const [query, setQuery] = useState('');
  const [collapsed, setCollapsed] = useState<string[]>([]);
  const needle = query.toLowerCase().trim();

  const filteredGroups = [...groups]
    .sort((a, b) => a.name.localeCompare(b.name))
    .map((group) => ({
      ...group,
      followers: [...group.followers]
        .filter((follower) =>
          !needle ||
          group.name.toLowerCase().includes(needle) ||
          follower.name.toLowerCase().includes(needle) ||
          follower.ckey.toLowerCase().includes(needle),
        )
        .sort((a, b) => a.name.localeCompare(b.name)),
    }))
    .filter((group) => group.followers.length > 0);

  const toggleGroup = (id: string) => {
    setCollapsed((current) => current.includes(id)
      ? current.filter((entry) => entry !== id)
      : [...current, id]);
  };

  return (
    <Window width={850} height={750} title="Followers by Patron">
      <Window.Content scrollable>
        <Section title={`Online followers (${total_followers})`}>
          <Stack align="center">
            <Stack.Item grow>
              <Input
                fluid
                value={query}
                placeholder="Search god, character or ckey..."
                onInput={(_, value) => setQuery(value)}
              />
            </Stack.Item>
            <Stack.Item>
              <Button icon="sync" onClick={() => act('refresh')}>
                Refresh
              </Button>
            </Stack.Item>
          </Stack>
        </Section>

        {filteredGroups.length === 0 ? (
          <Section>
            <Box color="label">No matching online followers.</Box>
          </Section>
        ) : (
          filteredGroups.map((group) => (
            <Section
              key={group.id}
              title={`${group.name} (${group.count})`}
              buttons={(
                <Stack>
                  <Stack.Item>
                    <Button
                      icon="comment"
                      onClick={() => act('narrate-group', { patron: group.id })}
                    >
                      Narrate to all
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon={collapsed.includes(group.id) ? 'chevron-down' : 'chevron-up'}
                      onClick={() => toggleGroup(group.id)}
                    >
                      {collapsed.includes(group.id) ? 'Expand' : 'Collapse'}
                    </Button>
                  </Stack.Item>
                </Stack>
              )}
            >
              {!collapsed.includes(group.id) && (
                <Table>
                  <Table.Row>
                    <Table.Cell>Character</Table.Cell>
                    <Table.Cell>CKEY</Table.Cell>
                    <Table.Cell textAlign="right">Actions</Table.Cell>
                  </Table.Row>
                  {group.followers.map((follower) => (
                    <Table.Row key={follower.ref}>
                      <Table.Cell>{follower.name}</Table.Cell>
                      <Table.Cell>{follower.ckey}</Table.Cell>
                      <Table.Cell textAlign="right">
                        <Button
                          icon="user"
                          tooltip="Player Panel"
                          onClick={() => act('player-panel', { ref: follower.ref })}
                        >
                          PP
                        </Button>
                        <Button
                          icon="comment"
                          tooltip="Direct Narrate"
                          onClick={() => act('direct-narrate', { ref: follower.ref })}
                        >
                          Narrate
                        </Button>
                        <Button
                          icon="envelope"
                          tooltip="Admin PM"
                          onClick={() => act('private-message', { ref: follower.ref })}
                        >
                          PM
                        </Button>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
            </Section>
          ))
        )}
      </Window.Content>
    </Window>
  );
};
