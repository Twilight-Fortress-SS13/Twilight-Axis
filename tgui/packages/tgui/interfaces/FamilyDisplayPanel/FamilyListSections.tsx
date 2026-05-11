import { Box, NoticeBox, Section, Stack } from 'tgui-core/components';

import type { FamilyDisplayEntry, FamilyDisplaySection } from './types';

const DEFAULT_ACCENT = '#9370DB';
const NAME_SHADOW = '0 0 10px #8d5958, 0 0 20px #8d5958';

const labelStyle = {
  color: '#f4e9d3',
  fontSize: '12px',
  fontWeight: 700,
  letterSpacing: 0,
} as const;

const detailsStyle = {
  color: '#c9b99b',
  fontSize: '12px',
} as const;

const FamilyEntry = ({ entry }: { entry: FamilyDisplayEntry }) => {
  const accentColor = entry.accentColor || DEFAULT_ACCENT;
  const details = entry.details || [];

  return (
    <Box mb={1.5}>
      <Box
        style={{
          color: accentColor,
          fontWeight: 700,
          textShadow: NAME_SHADOW,
        }}>
        {entry.name}
      </Box>
      {!!entry.label && <Box style={labelStyle}>{entry.label}</Box>}
      {!!details.length && (
        <Box style={detailsStyle}>{details.join(', ')}</Box>
      )}
    </Box>
  );
};

export const FamilyListSections = ({
  sections,
  emptyMessage,
}: {
  sections: FamilyDisplaySection[];
  emptyMessage: string;
}) => (
  <>
    {sections.map((section) => (
      <Stack.Item key={section.title}>
        <Section title={section.title} fill>
          {!section.entries.length && <NoticeBox>{emptyMessage}</NoticeBox>}
          {section.entries.map((entry, index) => (
            <FamilyEntry
              key={`${section.title}-${entry.name}-${index}`}
              entry={entry}
            />
          ))}
        </Section>
      </Stack.Item>
    ))}
  </>
);
