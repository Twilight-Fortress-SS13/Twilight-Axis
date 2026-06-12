import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Box, Button, Section } from 'tgui-core/components';

import { FamilyTreeCard } from './FamilyTreeCard';
import type { FamilyTreeNode } from './types';

const CARD_W = 170;
const CARD_GAP_X = 30;
const ROW_H = 170;
const ROW_GAP_PAD = 48;
const PADDING = 48;
const CONNECTOR_COLOR = '#6f7562';
const SPOUSE_COLOR = '#b57d5d';

const MIN_SCALE = 0.3;
const MAX_SCALE = 2.5;

type LaidNode = {
  key: string;
  node: FamilyTreeNode;
  x: number;
  y: number;
  isSpouse?: boolean;
  anchorCX: number;
  anchorCY: number;
};

type LaidEdge =
  | {
      type: 'spouse';
      key: string;
      x1: number;
      y1: number;
      x2: number;
      y2: number;
    }
  | {
      type: 'parent';
      key: string;
      x1: number;
      y1: number;
      x2: number;
      y2: number;
    };

type LayoutResult = {
  nodes: LaidNode[];
  edges: LaidEdge[];
  width: number;
  height: number;
};

type ChildTarget = {
  x: number;
  y: number;
};

const clamp = (v: number, lo: number, hi: number) =>
  Math.max(lo, Math.min(hi, v));

function collectGenerationMin(
  nodes: FamilyTreeNode[],
  current = Number.POSITIVE_INFINITY,
): number {
  let min = current;
  for (const node of nodes) {
    if (
      typeof node.generation === 'number' &&
      Number.isFinite(node.generation)
    ) {
      min = Math.min(min, node.generation);
    }
    min = collectGenerationMin(node.parentNodes || [], min);
    min = collectGenerationMin(node.spouses || [], min);
    min = collectGenerationMin(node.children || [], min);
  }
  return min;
}

function generationRow(
  node: FamilyTreeNode,
  generationMin: number,
  fallbackRow: number,
  minimumRow: number,
): number {
  if (
    typeof node.generation === 'number' &&
    Number.isFinite(node.generation) &&
    Number.isFinite(generationMin)
  ) {
    return Math.max(minimumRow, node.generation - generationMin);
  }
  return Math.max(minimumRow, fallbackRow);
}

function selfRowWidth(node: FamilyTreeNode): number {
  const slots = rowSlotWidths(node);
  return (
    slots.reduce((sum, width) => sum + width, 0) +
    (slots.length - 1) * CARD_GAP_X
  );
}

function parentRowWidth(nodes: FamilyTreeNode[]): number {
  if (!nodes.length) {
    return 0;
  }
  return nodes.length * CARD_W + (nodes.length - 1) * CARD_GAP_X;
}

function spouseSlotWidth(spouse: FamilyTreeNode): number {
  return Math.max(CARD_W, parentRowWidth(spouse.parentNodes || []));
}

function rowSlotWidths(node: FamilyTreeNode): number[] {
  return [CARD_W, ...(node.spouses || []).map(spouseSlotWidth)];
}

function placeSubtree(
  node: FamilyTreeNode,
  depth: number,
  xStart: number,
  out: LaidNode[],
  edges: LaidEdge[],
  pathKey: string,
  maxDepthRef: { v: number },
  minDepthRef: { v: number },
  generationMin: number,
  minimumRow = 0,
): { width: number; selfCenterX: number; y: number } {
  const spouses = node.spouses || [];
  const children = node.children || [];
  const row = generationRow(node, generationMin, depth, minimumRow);
  const y = row * ROW_H;
  const slotWidths = rowSlotWidths(node);
  const ownRow = selfRowWidth(node);

  let childrenWidth = 0;
  const childTargets: ChildTarget[] = [];
  let cursor = xStart;
  for (let i = 0; i < children.length; i++) {
    const child = children[i];
    const childKey = `${pathKey}/c${i}:${child.name}`;
    const { width: cw, selfCenterX: ccx, y: cy } = placeSubtree(
      child,
      depth + 1,
      cursor,
      out,
      edges,
      childKey,
      maxDepthRef,
      minDepthRef,
      generationMin,
      row + 1,
    );
    childTargets.push({ x: ccx, y: cy });
    cursor += cw + CARD_GAP_X;
  }
  if (children.length > 0) {
    childrenWidth = cursor - xStart - CARD_GAP_X;
  }

  const subtreeWidth = Math.max(ownRow, childrenWidth);
  const rowLeft = xStart + (subtreeWidth - ownRow) / 2;
  if (row > maxDepthRef.v) {
    maxDepthRef.v = row;
  }
  if (row < minDepthRef.v) {
    minDepthRef.v = row;
  }

  const selfX = rowLeft + (slotWidths[0] - CARD_W) / 2;
  const selfKey = `${pathKey}:self`;
  const selfAnchorX = selfX + CARD_W / 2;
  out.push({
    key: selfKey,
    node,
    x: selfX,
    y,
    anchorCX: selfAnchorX,
    anchorCY: y,
  });

  let lastSpouseRight = selfX + CARD_W;
  let slotLeft = rowLeft + slotWidths[0] + CARD_GAP_X;
  for (let i = 0; i < spouses.length; i++) {
    const spouse = spouses[i];
    const slotWidth = slotWidths[i + 1];
    const sx = slotLeft + (slotWidth - CARD_W) / 2;
    const skey = `${pathKey}:sp${i}:${spouse.name}`;
    out.push({
      key: skey,
      node: spouse,
      x: sx,
      y,
      isSpouse: true,
      anchorCX: sx + CARD_W / 2,
      anchorCY: y,
    });
    edges.push({
      type: 'spouse',
      key: `${selfKey}->${skey}`,
      x1: lastSpouseRight,
      y1: y + 40,
      x2: sx,
      y2: y + 40,
    });
    lastSpouseRight = sx + CARD_W;

    const parentNodes = spouse.parentNodes || [];
    if (parentNodes.length > 0) {
      const parentRow = row - 1;
      const parentY = parentRow * ROW_H;
      if (parentRow < minDepthRef.v) {
        minDepthRef.v = parentRow;
      }
      const parentWidth = parentRowWidth(parentNodes);
      const parentLeft = slotLeft + (slotWidth - parentWidth) / 2;
      const parentTargets: ChildTarget[] = [];
      for (let j = 0; j < parentNodes.length; j++) {
        const parent = parentNodes[j];
        const px = parentLeft + j * (CARD_W + CARD_GAP_X);
        const pkey = `${skey}:parent${j}:${parent.name}`;
        out.push({
          key: pkey,
          node: parent,
          x: px,
          y: parentY,
          anchorCX: px + CARD_W / 2,
          anchorCY: parentY,
        });
        parentTargets.push({ x: px + CARD_W / 2, y: parentY });
      }

      const spouseCenterX = sx + CARD_W / 2;
      const busY = y - ROW_GAP_PAD / 2;
      for (let j = 0; j < parentTargets.length; j++) {
        edges.push({
          type: 'parent',
          key: `${skey}:parentdrop${j}`,
          x1: parentTargets[j].x,
          y1: parentTargets[j].y + 80,
          x2: parentTargets[j].x,
          y2: busY,
        });
      }
      const parentCenters = parentTargets.map((parent) => parent.x);
      edges.push({
        type: 'parent',
        key: `${skey}:parentbus`,
        x1: Math.min(spouseCenterX, ...parentCenters),
        y1: busY,
        x2: Math.max(spouseCenterX, ...parentCenters),
        y2: busY,
      });
      edges.push({
        type: 'parent',
        key: `${skey}:spousedrop`,
        x1: spouseCenterX,
        y1: busY,
        x2: spouseCenterX,
        y2: y,
      });
    }

    slotLeft += slotWidth + CARD_GAP_X;
  }

  const selfCenterX = selfAnchorX;
  const familyCenterX = selfX + ownRow / 2;

  if (children.length > 0) {
    const parentBottomX = familyCenterX;
    const busY = y + ROW_H - ROW_GAP_PAD / 2;

    edges.push({
      type: 'parent',
      key: `${selfKey}:trunk`,
      x1: parentBottomX,
      y1: y + 80,
      x2: parentBottomX,
      y2: busY,
    });

    const childCenters = childTargets.map((child) => child.x);
    const leftBus = Math.min(parentBottomX, ...childCenters);
    const rightBus = Math.max(parentBottomX, ...childCenters);
    edges.push({
      type: 'parent',
      key: `${selfKey}:bus`,
      x1: leftBus,
      y1: busY,
      x2: rightBus,
      y2: busY,
    });

    for (let i = 0; i < childTargets.length; i++) {
      edges.push({
        type: 'parent',
        key: `${selfKey}:cdrop${i}`,
        x1: childTargets[i].x,
        y1: busY,
        x2: childTargets[i].x,
        y2: childTargets[i].y,
      });
    }
  }

  return { width: subtreeWidth, selfCenterX, y };
}

function computeLayout(roots: FamilyTreeNode[]): LayoutResult {
  const nodes: LaidNode[] = [];
  const edges: LaidEdge[] = [];
  const maxDepthRef = { v: 0 };
  const minDepthRef = { v: 0 };
  const generationMin = collectGenerationMin(roots);
  let cursor = 0;
  for (let i = 0; i < roots.length; i++) {
    const r = roots[i];
    const { width } = placeSubtree(
      r,
      0,
      cursor,
      nodes,
      edges,
      `r${i}:${r.name}`,
      maxDepthRef,
      minDepthRef,
      generationMin,
    );
    cursor += width + CARD_GAP_X * 2;
  }
  const yShift = minDepthRef.v < 0 ? -minDepthRef.v * ROW_H : 0;
  if (yShift > 0) {
    for (const node of nodes) {
      node.y += yShift;
      node.anchorCY += yShift;
    }
    for (const edge of edges) {
      edge.y1 += yShift;
      edge.y2 += yShift;
    }
  }
  const totalWidth = Math.max(0, cursor - CARD_GAP_X * 2);
  const totalHeight = (maxDepthRef.v - minDepthRef.v + 1) * ROW_H;
  return {
    nodes,
    edges,
    width: totalWidth + PADDING * 2,
    height: totalHeight + PADDING * 2,
  };
}

type Transform = { scale: number; tx: number; ty: number };

const INITIAL_TRANSFORM: Transform = { scale: 1, tx: 0, ty: 0 };

export const FamilyTree = ({ tree }: { tree: FamilyTreeNode[] }) => {
  const layout = useMemo(() => computeLayout(tree), [tree]);
  const viewportRef = useRef<HTMLDivElement | null>(null);
  const [transform, setTransform] = useState<Transform>(INITIAL_TRANSFORM);
  const dragRef = useRef<{
    pointerId: number;
    startX: number;
    startY: number;
    startTx: number;
    startTy: number;
  } | null>(null);

  const fitToView = useCallback(() => {
    const el = viewportRef.current;
    if (!el) {
      return;
    }
    const rect = el.getBoundingClientRect();
    if (rect.width <= 0 || rect.height <= 0) {
      return;
    }
    const sx = rect.width / layout.width;
    const sy = rect.height / layout.height;
    const s = clamp(Math.min(sx, sy), MIN_SCALE, 1);
    const tx = (rect.width - layout.width * s) / 2;
    const ty = Math.max(16, (rect.height - layout.height * s) / 2);
    setTransform({ scale: s, tx, ty });
  }, [layout.width, layout.height]);

  useEffect(() => {
    fitToView();
  }, [fitToView]);

  useEffect(() => {
    const el = viewportRef.current;
    if (!el) {
      return;
    }
    if (typeof ResizeObserver === 'undefined') {
      window.addEventListener('resize', fitToView);
      return () => window.removeEventListener('resize', fitToView);
    }
    const observer = new ResizeObserver(() => fitToView());
    observer.observe(el);
    return () => observer.disconnect();
  }, [fitToView]);

  useEffect(() => {
    const el = viewportRef.current;
    if (!el) {
      return;
    }
    const handler = (e: WheelEvent) => {
      e.preventDefault();
      const rect = el.getBoundingClientRect();
      const mx = e.clientX - rect.left;
      const my = e.clientY - rect.top;
      setTransform((prev) => {
        const factor = Math.exp(-e.deltaY * 0.0015);
        const nextScale = clamp(prev.scale * factor, MIN_SCALE, MAX_SCALE);
        const ratio = nextScale / prev.scale;
        return {
          scale: nextScale,
          tx: mx - ratio * (mx - prev.tx),
          ty: my - ratio * (my - prev.ty),
        };
      });
    };
    el.addEventListener('wheel', handler, { passive: false });
    return () => el.removeEventListener('wheel', handler);
  }, []);

  const onPointerDown = useCallback(
    (e: React.PointerEvent<HTMLDivElement>) => {
      if (e.button !== 0) {
        return;
      }
      (e.currentTarget as HTMLDivElement).setPointerCapture(e.pointerId);
      dragRef.current = {
        pointerId: e.pointerId,
        startX: e.clientX,
        startY: e.clientY,
        startTx: transform.tx,
        startTy: transform.ty,
      };
    },
    [transform.tx, transform.ty],
  );

  const onPointerMove = useCallback(
    (e: React.PointerEvent<HTMLDivElement>) => {
      const drag = dragRef.current;
      if (!drag || drag.pointerId !== e.pointerId) {
        return;
      }
      const dx = e.clientX - drag.startX;
      const dy = e.clientY - drag.startY;
      setTransform((prev) => ({
        ...prev,
        tx: drag.startTx + dx,
        ty: drag.startTy + dy,
      }));
    },
    [],
  );

  const endDrag = useCallback(
    (e: React.PointerEvent<HTMLDivElement>) => {
      const drag = dragRef.current;
      if (!drag) {
        return;
      }
      try {
        (e.currentTarget as HTMLDivElement).releasePointerCapture(
          drag.pointerId,
        );
      } catch (_err) {
        /* noop */
      }
      dragRef.current = null;
    },
    [],
  );

  const stepZoom = useCallback((mult: number) => {
    setTransform((prev) => {
      const el = viewportRef.current;
      const rect = el?.getBoundingClientRect();
      const cx = rect ? rect.width / 2 : 0;
      const cy = rect ? rect.height / 2 : 0;
      const nextScale = clamp(prev.scale * mult, MIN_SCALE, MAX_SCALE);
      const ratio = nextScale / prev.scale;
      return {
        scale: nextScale,
        tx: cx - ratio * (cx - prev.tx),
        ty: cy - ratio * (cy - prev.ty),
      };
    });
  }, []);

  const controls = (
    <Box
      style={{
        alignItems: 'center',
        display: 'flex',
        gap: '6px',
      }}>
      <Button compact icon="search-plus" onClick={() => stepZoom(1.2)}>
        Zoom +
      </Button>
      <Button compact icon="search-minus" onClick={() => stepZoom(1 / 1.2)}>
        Zoom -
      </Button>
      <Button compact icon="expand" onClick={fitToView}>
        Fit
      </Button>
      <Button
        compact
        icon="crosshairs"
        onClick={() => setTransform(INITIAL_TRANSFORM)}>
        Reset
      </Button>
      <Box
        style={{
          color: '#c9b99b',
          fontSize: '11px',
          marginLeft: '8px',
        }}>
        {Math.round(transform.scale * 100)}%
      </Box>
    </Box>
  );

  return (
    <Section title="Family Tree" buttons={controls}>
      <div
        ref={viewportRef}
        onPointerDown={onPointerDown}
        onPointerMove={onPointerMove}
        onPointerUp={endDrag}
        onPointerCancel={endDrag}
        onPointerLeave={endDrag}
        style={{
          background:
            'radial-gradient(circle at 50% 0%, rgba(60, 50, 40, 0.35), rgba(12, 10, 9, 0.9))',
          border: '1px solid #3b3630',
          borderRadius: '4px',
          cursor: dragRef.current ? 'grabbing' : 'grab',
          height: 'min(460px, calc(100vh - 190px))',
          minHeight: '320px',
          overflow: 'hidden',
          position: 'relative',
          touchAction: 'none',
          userSelect: 'none',
          width: '100%',
        }}>
        <Box
          style={{
            height: `${layout.height}px`,
            left: 0,
            position: 'absolute',
            top: 0,
            transform: `translate(${transform.tx}px, ${transform.ty}px) scale(${transform.scale})`,
            transformOrigin: '0 0',
            width: `${layout.width}px`,
          }}>
          <svg
            width={layout.width}
            height={layout.height}
            style={{
              left: 0,
              pointerEvents: 'none',
              position: 'absolute',
              top: 0,
            }}>
            <g transform={`translate(${PADDING}, ${PADDING})`}>
              {layout.edges.map((edge) => (
                <line
                  key={edge.key}
                  x1={edge.x1}
                  y1={edge.y1}
                  x2={edge.x2}
                  y2={edge.y2}
                  stroke={
                    edge.type === 'spouse' ? SPOUSE_COLOR : CONNECTOR_COLOR
                  }
                  strokeWidth={edge.type === 'spouse' ? 2 : 2}
                  strokeDasharray={edge.type === 'spouse' ? '5 3' : undefined}
                />
              ))}
            </g>
          </svg>
          {layout.nodes.map((ln) => (
            <Box
              key={ln.key}
              style={{
                left: `${ln.x + PADDING}px`,
                position: 'absolute',
                top: `${ln.y + PADDING}px`,
                width: `${CARD_W}px`,
              }}>
              <FamilyTreeCard node={ln.node} isSpouse={ln.isSpouse} />
            </Box>
          ))}
        </Box>
      </div>
    </Section>
  );
};
