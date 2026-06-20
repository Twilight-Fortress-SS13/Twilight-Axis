import { useState } from 'react';

import { Box, NoticeBox, Section, Stack } from 'tgui-core/components';

import type { FamilyDisplayEntry, FamilyDisplaySection } from './types';

const DEFAULT_ACCENT = '#9370DB';
const NAME_SHADOW = '0 0 10px #8d5958, 0 0 20px #8d5958';

const entryDescriptorCache: Record<string, string> = {};

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

const tooltipStyle = {
  position: 'absolute',
  zIndex: 50,
  top: 'calc(100% + 4px)',
  left: 0,
  minWidth: '180px',
  maxWidth: '260px',
  padding: '8px 10px',
  backgroundColor: 'rgba(15, 12, 10, 0.96)',
  border: '1px solid rgba(201, 160, 78, 0.55)',
  borderRadius: '6px',
  color: '#e6ddc4',
  fontSize: '11px',
  lineHeight: 1.35,
  textAlign: 'left',
  whiteSpace: 'pre-line',
  boxShadow: '0 6px 22px rgba(0, 0, 0, 0.6)',
  pointerEvents: 'none',
} as const;

const FamilyEntry = ({ entry }: { entry: FamilyDisplayEntry }) => {
  const accentColor = entry.accentColor || DEFAULT_ACCENT;
  const details = entry.details || [];
  const [hovered, setHovered] = useState(false);

  const ref = entry.personRef;
  const cacheKey = ref || entry.name;
  if (entry.descriptor && cacheKey) {
    entryDescriptorCache[cacheKey] = entry.descriptor;
  }
  const tooltipText =
    entry.descriptor || (cacheKey ? entryDescriptorCache[cacheKey] : null);

  return (
    <Box
      mb={1.5}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      style={{
        cursor: 'default',
        position: 'relative',
      }}>
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
      {hovered && !!tooltipText && <Box style={tooltipStyle}>{tooltipText}</Box>}
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
