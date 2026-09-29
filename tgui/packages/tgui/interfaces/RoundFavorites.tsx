import { useMemo, useState } from 'react';
import { Box, Button, Input, Section, Stack, Table } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type FavoriteData = {
  favorite_ref: string;
  name: string;
  type: string;
  location: string;
  can_jump: boolean;
  can_follow: boolean;
  can_player_panel: boolean;
  can_narrate: boolean;
  connected: boolean;
};

type Data = {
  favorites: FavoriteData[];
};

type SortKey = 'name' | 'type' | 'location';

export const RoundFavorites = () => {
  const { act, data } = useBackend<Data>();
  const { favorites = [] } = data;
  const [search, setSearch] = useState('');
  const [sortKey, setSortKey] = useState<SortKey>('name');
  const [sortDescending, setSortDescending] = useState(false);

  const visibleFavorites = useMemo(() => {
    const loweredSearch = search.trim().toLowerCase();
    const filtered = favorites.filter((favorite) => {
      if (!loweredSearch) {
        return true;
      }

      return [
        favorite.name,
        favorite.type,
        favorite.location,
      ]
        .join(' ')
        .toLowerCase()
        .includes(loweredSearch);
    });

    return filtered.sort((left, right) => {
      const leftValue = String(left[sortKey] || '');
      const rightValue = String(right[sortKey] || '');
      const comparison = leftValue.localeCompare(rightValue, undefined, {
        numeric: true,
        sensitivity: 'base',
      });
      return sortDescending ? -comparison : comparison;
    });
  }, [favorites, search, sortKey, sortDescending]);

  const changeSort = (newSortKey: SortKey) => {
    if (sortKey === newSortKey) {
      setSortDescending(!sortDescending);
      return;
    }
    setSortKey(newSortKey);
    setSortDescending(false);
  };

  const sortIcon = (key: SortKey) => {
    if (sortKey !== key) {
      return 'sort';
    }
    return sortDescending ? 'sort-down' : 'sort-up';
  };

  const header = (label: string, key: SortKey) => (
    <Button fluid icon={sortIcon(key)} onClick={() => changeSort(key)}>
      {label}
    </Button>
  );

  return (
    <Window width={820} height={620} title="Round Favorites">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow>
                  <Input
                    autoFocus
                    fluid
                    placeholder="Search name, type or area..."
                    value={search}
                    onChange={setSearch}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Box bold>
                    Showing {visibleFavorites.length} / {favorites.length}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="sync" onClick={() => act('refresh')}>
                    Refresh
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section fill scrollable>
              {favorites.length === 0 ? (
                <Box textAlign="center" mt={4}>
                  No favorites saved this round.
                </Box>
              ) : (
                <Table>
                  <Table.Row header>
                    <Table.Cell>{header('Name', 'name')}</Table.Cell>
                    <Table.Cell>{header('Type', 'type')}</Table.Cell>
                    <Table.Cell>{header('Area', 'location')}</Table.Cell>
                    <Table.Cell collapsing>Actions</Table.Cell>
                  </Table.Row>

                  {visibleFavorites.map((favorite) => (
                    <Table.Row className="candystripe" key={favorite.favorite_ref}>
                      <Table.Cell>
                        <Box bold>{favorite.name}</Box>
                      </Table.Cell>
                      <Table.Cell>
                        <Box>{favorite.type}</Box>
                      </Table.Cell>
                      <Table.Cell>{favorite.location}</Table.Cell>
                      <Table.Cell collapsing>
                        <Stack g={0.5} wrap>
                          {!!favorite.can_player_panel && (
                            <Stack.Item>
                              <Button
                                onClick={() =>
                                  act('player-panel', {
                                    favorite_ref: favorite.favorite_ref,
                                  })
                                }
                              >
                                PP
                              </Button>
                            </Stack.Item>
                          )}
                          {!!favorite.connected && (
                            <Stack.Item>
                              <Button
                                onClick={() =>
                                  act('private-message', {
                                    favorite_ref: favorite.favorite_ref,
                                  })
                                }
                              >
                                PM
                              </Button>
                            </Stack.Item>
                          )}
                          {!!favorite.can_narrate && (
                            <Stack.Item>
                              <Button
                                tooltip="Narrate"
                                onClick={() =>
                                  act('narrate', {
                                    favorite_ref: favorite.favorite_ref,
                                  })
                                }
                              >
                                NRT
                              </Button>
                            </Stack.Item>
                          )}
                          <Stack.Item>
                            <Button
                              onClick={() =>
                                act('view-variables', {
                                  favorite_ref: favorite.favorite_ref,
                                })
                              }
                            >
                              VV
                            </Button>
                          </Stack.Item>
                          {!!favorite.can_jump && (
                            <Stack.Item>
                              <Button
                                onClick={() =>
                                  act('jump', {
                                    favorite_ref: favorite.favorite_ref,
                                  })
                                }
                              >
                                JMP
                              </Button>
                            </Stack.Item>
                          )}
                          {!!favorite.can_follow && (
                            <Stack.Item>
                              <Button
                                onClick={() =>
                                  act('follow', {
                                    favorite_ref: favorite.favorite_ref,
                                  })
                                }
                              >
                                FLW
                              </Button>
                            </Stack.Item>
                          )}
                          <Stack.Item>
                            <Button
                              color="bad"
                              icon="trash"
                              onClick={() =>
                                act('remove', {
                                  favorite_ref: favorite.favorite_ref,
                                })
                              }
                            >
                              Remove
                            </Button>
                          </Stack.Item>
                        </Stack>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
