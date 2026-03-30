import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section, Stack } from 'tgui-core/components';

type Data = {
  stats: Record<string, number>;
  skills: Record<string, number>;
  traits: string[];
  items: Record<string, number>;

  available_stats: Record<string, any>;
  available_skills: Record<string, any>;
  available_traits: Record<string, any>;
  available_items: Record<string, any>;

  points_stats: number;
  points_skills: number;
  points_traits: number;
  points_items: number;
};

const ListBlock = ({
  title,
  entries,
  selected,
  onAdd,
  onRemove,
}: any) => {
  return (
    <Section title={title}>
      <Stack vertical>
        {Object.keys(entries || {}).map((key) => {
          const val = selected[key] || 0;
          return (
            <Stack.Item key={key}>
              <Stack justify="space-between">
                <Stack.Item>{key}</Stack.Item>
                <Stack.Item>
                  <Button compact onClick={() => onAdd(key)}>
                    +
                  </Button>
                  <Box as="span" mx={1}>
                    {val}
                  </Box>
                  <Button compact onClick={() => onRemove(key)}>
                    -
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
};

export const TATBuild = () => {
  const { act, data } = useBackend<Data>();

  return (
    <Window title="TAT" width={600} height={700}>
      <Window.Content scrollable>
        <Stack vertical>
          <ListBlock
            title="Stats"
            entries={data.available_stats}
            selected={data.stats}
            onAdd={(id) => act('add_stat', { id, amount: 1 })}
            onRemove={(id) => act('remove_stat', { id })}
          />

          <ListBlock
            title="Skills"
            entries={data.available_skills}
            selected={data.skills}
            onAdd={(path) => act('add_skill', { path, amount: 1 })}
            onRemove={(path) => act('remove_skill', { path })}
          />

          <Section title="Traits">
            <Stack wrap>
              {Object.keys(data.available_traits || {}).map((id) => {
                const selected = data.traits.includes(id);
                return (
                  <Stack.Item key={id}>
                    <Button
                      selected={selected}
                      onClick={() =>
                        act(selected ? 'remove_trait' : 'add_trait', { id })
                      }>
                      {id}
                    </Button>
                  </Stack.Item>
                );
              })}
            </Stack>
          </Section>

          <ListBlock
            title="Items"
            entries={data.available_items}
            selected={data.items}
            onAdd={(path) => act('add_item', { path, amount: 1 })}
            onRemove={(path) => act('remove_item', { path })}
          />

          <Section title="Points">
            <Box>Stats: {data.points_stats}</Box>
            <Box>Skills: {data.points_skills}</Box>
            <Box>Traits: {data.points_traits}</Box>
            <Box>Items: {data.points_items}</Box>
          </Section>

          <Section>
            <Stack justify="space-between">
              <Button onClick={() => act('reset_all')}>
                RESET
              </Button>

              <Button color="good" onClick={() => act('save')}>
                SAVE
              </Button>
            </Stack>
          </Section>
        </Stack>
      </Window.Content>
    </Window>
  );
};
