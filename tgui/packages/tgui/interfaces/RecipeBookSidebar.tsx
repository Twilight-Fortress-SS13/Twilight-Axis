import { memo, useMemo, useState } from 'react';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';

type RecipeEntry = {
  name: string;
  path: string;
  category: string;
};

type Props = {
  title: string;
  recipes: RecipeEntry[];
  categories: string[];
  category: string;
  selectedRecipe: string | null;
  onCategoryChange: (value: string) => void;
  onSelectRecipe: (path: string) => void;
  onBack?: () => void;
};

export const RecipeBookSidebar = memo((props: Props) => {
  const {
    title,
    recipes,
    categories,
    category,
    selectedRecipe,
    onCategoryChange,
    onSelectRecipe,
    onBack,
  } = props;

  const [search, setSearch] = useState('');

  const filtered = useMemo(() => {
    const query = search.toLowerCase();
    const seen = new Set<string>();
    return recipes.filter((r) => {
      const matchCat = category === 'All' || r.category === category;
      const matchSearch = !query || r.name.toLowerCase().includes(query);
      if (!matchCat || !matchSearch) return false;
      if (category === 'All') {
        if (seen.has(r.path)) return false;
        seen.add(r.path);
      }
      return true;
    });
  }, [recipes, search, category]);

  return (
    <Stack vertical fill>
      {!!onBack && (
        <Stack.Item>
          <Button fluid icon="arrow-left" onClick={onBack}>
            Back to Library
          </Button>
        </Stack.Item>
      )}
      <Stack.Item>
        <Box bold textAlign="center" py={0.5}>
          {title}
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Input
          fluid
          placeholder="Search..."
          value={search}
          onChange={(value) => setSearch(value)}
        />
      </Stack.Item>
      {categories.length > 1 && (
        <Stack.Item>
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '2px' }}>
            {categories.map((cat) => (
              <Button
                key={cat}
                selected={category === cat}
                compact
                onClick={() => onCategoryChange(cat)}
              >
                {cat}
              </Button>
            ))}
          </Box>
        </Stack.Item>
      )}
      <Stack.Item grow basis={0} style={{ overflow: 'auto' }}>
        <Section fill scrollable>
          {filtered.length === 0 ? (
            <Box italic color="label" textAlign="center">
              No matching entries found.
            </Box>
          ) : (
            filtered.map((recipe) => (
              <Button
                key={recipe.path}
                fluid
                selected={selectedRecipe === recipe.path}
                onClick={() => onSelectRecipe(recipe.path)}
              >
                {recipe.name}
              </Button>
            ))
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
});
