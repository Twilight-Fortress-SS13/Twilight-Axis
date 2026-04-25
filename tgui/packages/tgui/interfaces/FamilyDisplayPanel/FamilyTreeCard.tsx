import { Box } from 'tgui-core/components';

import type { FamilyTreeNode } from './types';

const DEFAULT_ACCENT = '#9370DB';
const BG_DEFAULT = 'rgba(29, 24, 22, 0.78)';
const BG_PHANTOM = 'rgba(42, 41, 38, 0.72)';
const BG_SELF = 'rgba(62, 102, 46, 0.42)';
const SHADOW_DEFAULT = '0 2px 8px rgba(0, 0, 0, 0.35)';
const NAME_SHADOW = '0 0 8px rgba(0, 0, 0, 0.7)';

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

export const FamilyTreeCard = ({
  node,
  isSpouse,
}: {
  node: FamilyTreeNode;
  isSpouse?: boolean;
}) => {
  const accentColor = node.accentColor || DEFAULT_ACCENT;
  const details = node.details || [];
  const backgroundColor = node.isSelf
    ? BG_SELF
    : node.phantom
      ? BG_PHANTOM
      : BG_DEFAULT;

  return (
    <Box
      style={{
        backgroundColor,
        border: `1px solid ${accentColor}`,
        borderRadius: '6px',
        boxShadow: node.isSelf ? `0 0 12px ${accentColor}` : SHADOW_DEFAULT,
        minHeight: '72px',
        minWidth: isSpouse ? '132px' : '150px',
        maxWidth: '180px',
        padding: '8px 10px',
        textAlign: 'center',
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
      {!!details.length && (
        <Box mt={0.5} style={detailsStyle}>
          {details.join(', ')}
        </Box>
      )}
    </Box>
  );
};
