import { useRef, useState } from 'react';

import { Box } from 'tgui-core/components';

import type { FamilyTreeNode } from './types';

const DEFAULT_ACCENT = '#9370DB';
const BG_DEFAULT = 'rgba(29, 24, 22, 0.78)';
const BG_PHANTOM = 'rgba(42, 41, 38, 0.72)';
const BG_COSMETIC = 'rgba(46, 38, 60, 0.75)';
const BG_SELF = 'rgba(62, 102, 46, 0.42)';
const SHADOW_DEFAULT = '0 2px 8px rgba(0, 0, 0, 0.35)';
const SHADOW_HOVER = '0 6px 18px rgba(0, 0, 0, 0.55)';
const NAME_SHADOW = '0 0 8px rgba(0, 0, 0, 0.7)';

const descriptorCache: Record<string, string> = {};

const labelStyle = {
  color: '#f4e9d3',
  fontSize: '11px',
  fontWeight: 700,
  letterSpacing: 0,
  lineHeight: 1.2,
  overflowWrap: 'anywhere',
} as const;

const detailsStyle = {
  color: '#c9b99b',
  fontSize: '11px',
  lineHeight: 1.2,
  overflowWrap: 'anywhere',
} as const;

const tooltipStyle = {
  position: 'absolute',
  zIndex: 50,
  top: 'calc(100% + 6px)',
  left: '50%',
  transform: 'translateX(-50%)',
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

export const FamilyTreeCard = ({
  node,
  isSpouse,
}: {
  node: FamilyTreeNode;
  isSpouse?: boolean;
}) => {
  const accentColor = node.accentColor || DEFAULT_ACCENT;
  const details = node.details || [];
  const parents = node.parents || [];
  const backgroundColor = node.isSelf
    ? BG_SELF
    : node.cosmetic
      ? BG_COSMETIC
      : node.phantom
        ? BG_PHANTOM
        : BG_DEFAULT;

  const [hovered, setHovered] = useState(false);
  const cacheKeyRef = useRef<string | null>(null);

  const ref = node.personRef;
  const rawDescriptor = node.descriptor;
  const cacheKey = ref || node.name;

  if (rawDescriptor && cacheKey) {
    descriptorCache[cacheKey] = rawDescriptor;
    cacheKeyRef.current = cacheKey;
  }
  const cachedDescriptor = cacheKey ? descriptorCache[cacheKey] : null;
  const tooltipText = rawDescriptor || cachedDescriptor || null;

  return (
    <Box
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      style={{
        backgroundColor,
        border: `1px solid ${accentColor}`,
        borderRadius: '6px',
        boxSizing: 'border-box',
        boxShadow:
          node.isSelf
            ? `0 0 12px ${accentColor}`
            : hovered
              ? SHADOW_HOVER
              : SHADOW_DEFAULT,
        minHeight: parents.length ? '88px' : '72px',
        minWidth: isSpouse ? '132px' : '150px',
        maxWidth: '180px',
        padding: '8px 10px',
        textAlign: 'center',
        cursor: 'default',
        position: 'relative',
        transition: 'box-shadow 0.15s ease, transform 0.15s ease',
        transform: 'none',
        width: '100%',
      }}>
      <Box
        style={{
          color: node.phantom ? '#d8d2c3' : accentColor,
          fontSize: '14px',
          fontWeight: 700,
          letterSpacing: 0,
          lineHeight: 1.2,
          overflowWrap: 'anywhere',
          textShadow: NAME_SHADOW,
        }}>
        {node.name}
      </Box>
      {!!node.label && (
        <Box mt={0.5} style={labelStyle}>
          {node.label}
        </Box>
      )}
      {!!parents.length && (
        <Box mt={0.5} style={detailsStyle}>
          Parents: {parents.join(' / ')}
        </Box>
      )}
      {!!details.length && (
        <Box mt={0.5} style={detailsStyle}>
          {details.join(', ')}
        </Box>
      )}
      {hovered && !!tooltipText && <Box style={tooltipStyle}>{tooltipText}</Box>}
    </Box>
  );
};
