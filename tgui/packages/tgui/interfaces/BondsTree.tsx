import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Box, Button, NoticeBox, Section } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type LogEntry = {
  label: string;
  story: string;
  warmth: number;
  weight: number;
  dream: number | boolean;
};

type EdgeEntry = {
  name: string;
  job: string;
  log: LogEntry[];
  accent: string;
  outLabel: string;
  outProgress: number;
  inLabel: string | null;
  inProgress: number;
  inAccent: string;
};

type SelfInfo = {
  name: string;
  accent: string;
};

type Data = {
  self: SelfInfo | null;
  edges: EdgeEntry[];
};

const WIDTH = 820;
const HEIGHT = 700;

const NODE_R = 28;
const SELF_R = 42;
const ARC_PER_NODE = 158;
const RING_BASE = 210;
const RING_STEP = 215;
const RING_CAPACITY = 12;
const PADDING = 110;

const BAR_HALF = 44;
const BAR_HEIGHT = 7;

const MIN_SCALE = 0.2;
const MAX_SCALE = 3;

function clamp(value: number, low: number, high: number) {
  return Math.min(high, Math.max(low, value));
}

type Placed = {
  edge: EdgeEntry;
  x: number;
  y: number;
};

// Nodes are spread over as many concentric rings as it takes to give every one of them a fixed
// slice of arc. A ring only ever holds as many nodes as its circumference can seat, so a viewer
// with forty bonds gets three roomy rings instead of one unreadable crush.
function computeLayout(edges: EdgeEntry[]) {
  const rings: { from: number; count: number; radius: number }[] = [];
  let placedCount = 0;
  let ringIndex = 0;

  while (placedCount < edges.length) {
    const capacity = RING_CAPACITY + ringIndex * 6;
    const take = Math.min(edges.length - placedCount, capacity);
    const needed = (take * ARC_PER_NODE) / (2 * Math.PI);
    const radius = Math.max(RING_BASE + ringIndex * RING_STEP, needed);
    rings.push({ from: placedCount, count: take, radius });
    placedCount += take;
    ringIndex++;
  }

  const maxRadius = rings.length ? rings[rings.length - 1].radius : RING_BASE;
  const size = (maxRadius + NODE_R + PADDING) * 2;
  const center = size / 2;
  const placed: Placed[] = [];

  for (const ring of rings) {
    for (let i = 0; i < ring.count; i++) {
      const angle = (i / ring.count) * Math.PI * 2 - Math.PI / 2;
      placed.push({
        edge: edges[ring.from + i],
        x: center + Math.cos(angle) * ring.radius,
        y: center + Math.sin(angle) * ring.radius,
      });
    }
  }

  return { placed, size, center };
}

function trim(text: string, limit: number) {
  return text.length > limit ? `${text.slice(0, limit - 1)}…` : text;
}

type Transform = { scale: number; tx: number; ty: number };

const INITIAL_TRANSFORM: Transform = { scale: 1, tx: 0, ty: 0 };

export const BondsTree = () => {
  const { data } = useBackend<Data>();
  const { self, edges = [] } = data;

  // Same stage reads next to same stage, so the ring groups into arcs of friends and arcs of
  // enemies instead of scattering them.
  const ordered = useMemo(
    () => [...edges].sort((a, b) => a.outLabel.localeCompare(b.outLabel)),
    [edges],
  );
  const layout = useMemo(() => computeLayout(ordered), [ordered]);

  const viewportRef = useRef<HTMLDivElement | null>(null);
  const [transform, setTransform] = useState<Transform>(INITIAL_TRANSFORM);
  const [hovered, setHovered] = useState<number | null>(null);
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
    const s = clamp(
      Math.min(rect.width / layout.size, rect.height / layout.size),
      MIN_SCALE,
      1.4,
    );
    setTransform({
      scale: s,
      tx: (rect.width - layout.size * s) / 2,
      ty: (rect.height - layout.size * s) / 2,
    });
  }, [layout.size]);

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
      setHovered(null);
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

  const onPointerMove = useCallback((e: React.PointerEvent<HTMLDivElement>) => {
    const drag = dragRef.current;
    if (!drag || drag.pointerId !== e.pointerId) {
      return;
    }
    setTransform((prev) => ({
      ...prev,
      tx: drag.startTx + (e.clientX - drag.startX),
      ty: drag.startTy + (e.clientY - drag.startY),
    }));
  }, []);

  const endDrag = useCallback((e: React.PointerEvent<HTMLDivElement>) => {
    const drag = dragRef.current;
    if (!drag) {
      return;
    }
    try {
      (e.currentTarget as HTMLDivElement).releasePointerCapture(drag.pointerId);
    } catch (_err) {
      /* noop */
    }
    dragRef.current = null;
  }, []);

  const stepZoom = useCallback((mult: number) => {
    setTransform((prev) => {
      const rect = viewportRef.current?.getBoundingClientRect();
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

  if (!self || !ordered.length) {
    return (
      <Window title="Древо связей" width={WIDTH} height={HEIGHT}>
        <Window.Content style={{ backgroundImage: 'none' }}>
          <NoticeBox>Вы пока ни к кому ничего не испытываете.</NoticeBox>
        </Window.Content>
      </Window>
    );
  }

  const controls = (
    <Box style={{ alignItems: 'center', display: 'flex', gap: '6px' }}>
      <Button compact icon="search-plus" onClick={() => stepZoom(1.2)} />
      <Button compact icon="search-minus" onClick={() => stepZoom(1 / 1.2)} />
      <Button compact icon="expand" onClick={fitToView}>
        Вписать
      </Button>
      <Box style={{ color: '#c9b99b', fontSize: '11px', marginLeft: '8px' }}>
        {Math.round(transform.scale * 100)}% · {ordered.length}
      </Box>
    </Box>
  );

  return (
    <Window title="Древо связей" width={WIDTH} height={HEIGHT}>
      <Window.Content style={{ backgroundImage: 'none' }}>
        <Section title="Древо связей" buttons={controls}>
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
              height: 'min(560px, calc(100vh - 130px))',
              minHeight: '320px',
              overflow: 'hidden',
              position: 'relative',
              touchAction: 'none',
              userSelect: 'none',
              width: '100%',
            }}
          >
            <div
              style={{
                height: `${layout.size}px`,
                left: 0,
                position: 'absolute',
                top: 0,
                transform: `translate(${transform.tx}px, ${transform.ty}px) scale(${transform.scale})`,
                transformOrigin: '0 0',
                width: `${layout.size}px`,
              }}
            >
              <svg
                width={layout.size}
                height={layout.size}
                style={{ left: 0, pointerEvents: 'none', position: 'absolute', top: 0 }}
              >
                {layout.placed.map((spot, index) => (
                  <line
                    key={`spoke${index}`}
                    x1={layout.center}
                    y1={layout.center}
                    x2={spot.x}
                    y2={spot.y}
                    stroke={spot.edge.accent}
                    strokeWidth={2}
                    opacity={0.35}
                  />
                ))}

                {layout.placed.map((spot, index) => {
                  const { edge, x, y } = spot;
                  const outWidth = clamp(edge.outProgress, 0, 1);
                  const inWidth = clamp(edge.inProgress, 0, 1);
                  const barY = y + NODE_R + 8;

                  return (
                    <g
                      key={index}
                      style={{ cursor: 'help', pointerEvents: 'auto' }}
                      onPointerEnter={() => !dragRef.current && setHovered(index)}
                      onPointerLeave={() => setHovered(null)}
                    >
                      <circle
                        cx={x}
                        cy={y}
                        r={NODE_R + 26}
                        fill="transparent"
                      />
                      <text
                        x={x}
                        y={y - NODE_R - 10}
                        textAnchor="middle"
                        fill={edge.accent}
                        fontSize="13"
                        fontWeight="bold"
                      >
                        {edge.outLabel}
                      </text>

                      <circle
                        cx={x}
                        cy={y}
                        r={NODE_R}
                        fill="#1c1c1c"
                        stroke={edge.accent}
                        strokeWidth={2}
                      />
                      <text
                        x={x}
                        y={y + 4}
                        textAnchor="middle"
                        fill="#e8e8e8"
                        fontSize="11"
                      >
                        {trim(edge.name, 12)}
                      </text>

                      <rect
                        x={x - BAR_HALF}
                        y={barY}
                        width={BAR_HALF * 2}
                        height={BAR_HEIGHT}
                        fill="#00000055"
                        rx={2}
                      />
                      <rect
                        x={x - BAR_HALF * inWidth}
                        y={barY}
                        width={BAR_HALF * inWidth}
                        height={BAR_HEIGHT}
                        fill={edge.inAccent}
                        rx={2}
                      />
                      <rect
                        x={x}
                        y={barY}
                        width={BAR_HALF * outWidth}
                        height={BAR_HEIGHT}
                        fill={edge.accent}
                        rx={2}
                      />
                      <line
                        x1={x}
                        y1={barY - 2}
                        x2={x}
                        y2={barY + BAR_HEIGHT + 2}
                        stroke="#e0e0e0"
                        strokeWidth={1}
                      />

                      {!!edge.inLabel && (
                        <text
                          x={x}
                          y={barY + BAR_HEIGHT + 14}
                          textAnchor="middle"
                          fill={edge.inAccent}
                          fontSize="11"
                          opacity={0.85}
                        >
                          {edge.inLabel} &#8592;
                        </text>
                      )}
                    </g>
                  );
                })}

                <circle
                  cx={layout.center}
                  cy={layout.center}
                  r={SELF_R}
                  fill="#241f16"
                  stroke={self.accent}
                  strokeWidth={3}
                />
                <text
                  x={layout.center}
                  y={layout.center + 4}
                  textAnchor="middle"
                  fill={self.accent}
                  fontSize="12"
                  fontWeight="bold"
                >
                  {trim(self.name, 14)}
                </text>
              </svg>
            </div>
            {hovered !== null && !!layout.placed[hovered] && (
              <div
                style={{
                  background: 'rgba(10, 9, 8, 0.96)',
                  border: `1px solid ${layout.placed[hovered].edge.accent}`,
                  borderRadius: '4px',
                  bottom: '10px',
                  fontSize: '12px',
                  left: '10px',
                  maxHeight: '55%',
                  maxWidth: '22rem',
                  overflowY: 'auto',
                  padding: '8px 10px',
                  pointerEvents: 'none',
                  position: 'absolute',
                }}
              >
                <Box bold color={layout.placed[hovered].edge.accent}>
                  {layout.placed[hovered].edge.name}
                  {!!layout.placed[hovered].edge.job && (
                    <Box inline ml={1} opacity={0.6}>
                      {layout.placed[hovered].edge.job}
                    </Box>
                  )}
                </Box>
                <Box opacity={0.75} mb={0.5}>
                  Вы к нему: {layout.placed[hovered].edge.outLabel}
                  {!!layout.placed[hovered].edge.inLabel &&
                    ` · он к вам: ${layout.placed[hovered].edge.inLabel}`}
                </Box>
                {(() => {
                  const log = layout.placed[hovered].edge.log || [];
                  const dreams = log.filter((entry) => !!entry.dream);
                  const deeds = log.filter((entry) => !entry.dream);
                  return (
                    <>
                      {!!dreams.length && (
                        <Box mt={0.5}>
                          <Box bold opacity={0.8}>
                            Сны
                          </Box>
                          {dreams.map((entry, i) => (
                            <Box key={`d${i}`} mt={0.25} italic opacity={0.85}>
                              {entry.story}
                            </Box>
                          ))}
                        </Box>
                      )}
                      {!!deeds.length && (
                        <Box mt={0.5}>
                          <Box bold opacity={0.8}>
                            Последнее
                          </Box>
                          {deeds.map((entry, i) => (
                            <Box key={`e${i}`} mt={0.25}>
                              <Box inline bold opacity={0.7}>
                                {entry.label}
                              </Box>
                              <Box inline ml={1} opacity={0.85}>
                                {entry.story}
                              </Box>
                              {!!entry.warmth && (
                                <Box
                                  inline
                                  ml={1}
                                  color={entry.warmth > 0 ? 'good' : 'bad'}
                                >
                                  {entry.warmth > 0 ? '+' : ''}
                                  {entry.warmth}
                                </Box>
                              )}
                            </Box>
                          ))}
                        </Box>
                      )}
                      {!dreams.length && !deeds.length && (
                        <Box opacity={0.5}>Ничего конкретного не припомнить.</Box>
                      )}
                    </>
                  );
                })()}
              </div>
            )}
          </div>
        </Section>
      </Window.Content>
    </Window>
  );
};
