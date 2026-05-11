import { Box } from 'tgui-core/components';

import { FamilyTreeCard } from './FamilyTreeCard';
import type { FamilyTreeNode } from './types';

const CONNECTOR_COLOR = '#6f7562';

const nodeRowStyle = {
  alignItems: 'center',
  display: 'flex',
  gap: '8px',
  justifyContent: 'center',
} as const;

const spouseGroupStyle = {
  alignItems: 'center',
  display: 'flex',
  gap: '8px',
} as const;

const spouseLineStyle = {
  backgroundColor: CONNECTOR_COLOR,
  height: '2px',
  width: '18px',
} as const;

const verticalLineStyle = {
  backgroundColor: CONNECTOR_COLOR,
  height: '18px',
  width: '2px',
} as const;

const childrenRowStyle = {
  alignItems: 'flex-start',
  borderTop: `2px solid ${CONNECTOR_COLOR}`,
  display: 'flex',
  gap: '18px',
  justifyContent: 'center',
  paddingTop: '14px',
} as const;

export const FamilyTreeBranch = ({
  node,
  depth = 0,
}: {
  node: FamilyTreeNode;
  depth?: number;
}) => {
  const spouses = node.spouses || [];
  const children = node.children || [];

  return (
    <Box
      style={{
        alignItems: 'center',
        display: 'flex',
        flexDirection: 'column',
        minWidth: depth ? '170px' : '190px',
      }}>
      <Box style={nodeRowStyle}>
        <FamilyTreeCard node={node} />
        {spouses.map((spouse, index) => (
          <Box
            key={`${node.name}-spouse-${spouse.name}-${index}`}
            style={spouseGroupStyle}>
            <Box style={spouseLineStyle} />
            <FamilyTreeCard node={spouse} isSpouse />
          </Box>
        ))}
      </Box>
      {!!children.length && <Box style={verticalLineStyle} />}
      {!!children.length && (
        <Box style={childrenRowStyle}>
          {children.map((child, index) => (
            <FamilyTreeBranch
              key={`${node.name}-child-${child.name}-${index}`}
              node={child}
              depth={depth + 1}
            />
          ))}
        </Box>
      )}
    </Box>
  );
};
