import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type FactionInfo = {
  name: string;
  accent: string;
  icon: string;
};

type MapNode = {
  id: string;
  name: string;
  accent: string;
  own: number | boolean;
  bloc: string;
};

type MapBloc = {
  id: string;
  name: string;
  members: string[];
};

type BlocEdge = {
  a: string;
  b: string;
  label: string;
  accent: string;
  warmth: number;
  weight: number;
};

type MapEdge = {
  a: string;
  b: string;
  label: string;
  accent: string;
  warmth: number;
  weight: number;
  declared: number | boolean;
  inner: number | boolean;
  exception: number | boolean;
};

type HouseEntry = {
  name: string;
  label: string;
  labelAccent: string;
  intensity: string;
  incidents: number;
};

type StanceEntry = {
  name: string;
  accent: string;
  icon: string;
  label: string;
  labelAccent: string;
  intensity: string;
};

type Data = {
  ownFaction: FactionInfo | null;
  map: { nodes: MapNode[]; edges: MapEdge[]; blocs: MapBloc[]; blocEdges: BlocEdge[] };
  ownHouse: string | null;
  houses: HouseEntry[];
  ownClan: string | null;
  clans: StanceEntry[];
};

const SIZE = 620;
const BOARD_H = 470;
const GAP = 14;
const ROW_H = 22;
const HEAD_H = 26;
const PAD = 12;

export const BondsFactions = () => {
  const { data } = useBackend<Data>();
  const {
    ownFaction,
    map = { nodes: [], edges: [], blocs: [], blocEdges: [] },
    ownHouse,
    houses = [],
    ownClan,
    clans = [],
  } = data;

  const nodes = map.nodes || [];
  const edges = map.edges || [];
  const blocs = map.blocs || [];
  const blocEdges = map.blocEdges || [];

  const [hidden, setHidden] = useState<Record<string, boolean>>({});
  const [showNeutral, setShowNeutral] = useState(false);
  const [focus, setFocus] = useState<string>('');

  const nodeNames = nodes.map((node) => node.name);
  const idByName: Record<string, string> = {};
  nodes.forEach((node) => {
    idByName[node.name] = node.id;
  });

  const nodeById: Record<string, MapNode> = {};
  nodes.forEach((node) => {
    nodeById[node.id] = node;
  });

  // The viewer's own bloc takes the big seat; without one the largest bloc does.
  const ownBlocId =
    nodes.find((node) => !!node.own)?.bloc ||
    blocs.reduce(
      (best, bloc) =>
        bloc.members.length > (best?.members.length || 0) ? bloc : best,
      blocs[0],
    )?.id;

  const primary = blocs.find((bloc) => bloc.id === ownBlocId) || blocs[0];
  const others = blocs.filter((bloc) => bloc !== primary);

  const boxHeight = (bloc: MapBloc) =>
    HEAD_H + PAD + bloc.members.length * ROW_H;

  // Primary on the left, everyone else stacked in two columns on the right.
  const boxes: Record<string, { x: number; y: number; w: number; h: number }> = {};
  const LEFT_W = 250;
  if (primary) {
    boxes[primary.id] = {
      x: 10,
      y: 10,
      w: LEFT_W,
      h: Math.max(boxHeight(primary), 150),
    };
  }
  const COL_W = (SIZE - LEFT_W - 30 - GAP) / 2;
  const colY = [10, 10];
  others.forEach((bloc, index) => {
    const col = index % 2;
    const h = boxHeight(bloc);
    boxes[bloc.id] = {
      x: LEFT_W + 20 + col * (COL_W + GAP),
      y: colY[col],
      w: COL_W,
      h,
    };
    colY[col] += h + GAP;
  });

  const boardHeight = Math.max(
    BOARD_H,
    Math.max(colY[0], colY[1], (boxes[primary?.id || '']?.h || 0) + 20) + 10,
  );

  const centre = (id: string) => {
    const b = boxes[id];
    return b ? { x: b.x + b.w / 2, y: b.y + b.h / 2 } : null;
  };

  // A row hangs off whichever side of its box faces the other end of the line,
  // so a link never has to cross the box it starts in.
  const rowInfo = (id: string) => {
    const node = nodeById[id];
    if (!node) return null;
    const box = boxes[node.bloc];
    const bloc = blocs.find((entry) => entry.id === node.bloc);
    if (!box || !bloc) return null;
    const index = bloc.members.indexOf(id);
    if (index < 0) return null;
    return {
      left: box.x + 2,
      right: box.x + box.w - 2,
      mid: box.x + box.w / 2,
      y: box.y + HEAD_H + 10 + index * ROW_H - 4,
    };
  };

  const rowPair = (idA: string, idB: string) => {
    const a = rowInfo(idA);
    const b = rowInfo(idB);
    if (!a || !b) return null;
    const aRight = a.mid <= b.mid;
    return {
      from: { x: aRight ? a.right : a.left, y: a.y },
      to: { x: aRight ? b.left : b.right, y: b.y },
    };
  };

  return (
    <Window title="Карта сил" width={640} height={780}>
      <Window.Content scrollable style={{ backgroundImage: 'none' }}>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Между фракциями">
              {!edges.length && (
                <Box opacity={0.6}>
                  Между фракциями пока ничего не произошло.
                </Box>
              )}
              <Stack mt={1} align="center" wrap>
                <Stack.Item>
                  <Dropdown
                    options={nodeNames}
                    selected={focus ? nodeById[focus]?.name : ''}
                    placeholder="найти фракцию"
                    width="12rem"
                    onSelected={(name) => setFocus(idByName[name] || '')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button icon="eraser" onClick={() => setFocus('')}>
                    сбросить
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    checked={showNeutral}
                    onClick={() => setShowNeutral(!showNeutral)}
                  >
                    все пары
                  </Button.Checkbox>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="eye" onClick={() => setHidden({})}>
                    вернуть скрытые
                  </Button>
                </Stack.Item>
              </Stack>
              <Box mt={0.5} opacity={0.5}>
                Клик по фракции — её связи. Клик по линии между блоками убирает её.
              </Box>
              <svg
                viewBox={`0 0 ${SIZE} ${boardHeight}`}
                style={{ width: '100%', height: 'auto' }}
              >
                {blocEdges.map((edge, index) => {
                  const from = centre(edge.a);
                  const to = centre(edge.b);
                  if (!from || !to) return null;
                  const key = `bloc:${edge.a}|${edge.b}`;
                  if (hidden[key]) return null;
                  const quiet = Math.abs(edge.warmth) < 8;
                  if (quiet && !showNeutral) return null;
                  const midX = (from.x + to.x) / 2;
                  const midY = (from.y + to.y) / 2;
                  const thickness = 1 + Math.min(6, edge.weight / 14);
                  return (
                    <g
                      key={index}
                      onClick={() => setHidden({ ...hidden, [key]: true })}
                      style={{ cursor: 'pointer' }}
                    >
                      <line
                        x1={from.x}
                        y1={from.y}
                        x2={to.x}
                        y2={to.y}
                        stroke={edge.accent}
                        strokeWidth={thickness}
                        opacity={focus ? 0.12 : quiet ? 0.25 : 0.6}
                      />
                      {!focus && !quiet && (
                        <g style={{ pointerEvents: 'none' }}>
                          <rect
                            x={midX - 17}
                            y={midY - 9}
                            width={34}
                            height={15}
                            rx={3}
                            fill="#0b0b0b"
                            opacity={0.85}
                          />
                          <text
                            x={midX}
                            y={midY + 2}
                            textAnchor="middle"
                            fill={edge.accent}
                            fontSize="11"
                            fontWeight="bold"
                          >
                            {edge.warmth > 0 ? `+${edge.warmth}` : edge.warmth}
                          </text>
                        </g>
                      )}
                    </g>
                  );
                })}

                {edges
                  .filter((edge) => !!edge.exception)
                  .map((edge, index) => {
                    const pair = rowPair(edge.a, edge.b);
                    if (!pair) return null;
                    const { from, to } = pair;
                    return (
                      <line
                        key={`x${index}`}
                        x1={from.x}
                        y1={from.y}
                        x2={to.x}
                        y2={to.y}
                        stroke={edge.accent}
                        strokeWidth={1.8}
                        strokeDasharray="5 4"
                        opacity={focus ? 0.18 : 0.9}
                      />
                    );
                  })}

                {!!focus &&
                  edges
                    .filter(
                      (edge) =>
                        (edge.a === focus || edge.b === focus) &&
                        (!!edge.declared || showNeutral),
                    )
                    .map((edge, index) => {
                      const pair = rowPair(edge.a, edge.b);
                      if (!pair) return null;
                      const { from, to } = pair;
                      const midX = (from.x + to.x) / 2;
                      const midY = (from.y + to.y) / 2;
                      return (
                        <g key={`f${index}`} style={{ pointerEvents: 'none' }}>
                          <line
                            x1={from.x}
                            y1={from.y}
                            x2={to.x}
                            y2={to.y}
                            stroke={edge.accent}
                            strokeWidth={1 + Math.min(5, edge.weight / 16)}
                            opacity={0.85}
                          />
                          <rect
                            x={midX - 17}
                            y={midY - 9}
                            width={34}
                            height={15}
                            rx={3}
                            fill="#0b0b0b"
                            opacity={0.85}
                          />
                          <text
                            x={midX}
                            y={midY + 2}
                            textAnchor="middle"
                            fill={edge.accent}
                            fontSize="11"
                            fontWeight="bold"
                          >
                            {edge.warmth > 0 ? `+${edge.warmth}` : edge.warmth}
                          </text>
                        </g>
                      );
                    })}

                {blocs.map((bloc) => {
                  const box = boxes[bloc.id];
                  if (!box) return null;
                  const home = bloc === primary;
                  return (
                    <g key={bloc.id}>
                      <rect
                        x={box.x}
                        y={box.y}
                        width={box.w}
                        height={box.h}
                        rx={5}
                        fill={home ? '#1d1a12' : '#161616'}
                        stroke={home ? '#b08d3f' : '#3a3a3a'}
                        strokeWidth={home ? 2.5 : 1.5}
                      />
                      <text
                        x={box.x + 11}
                        y={box.y + 18}
                        fill={home ? '#d8b45a' : '#cfcfcf'}
                        fontSize={home ? '13' : '12'}
                        fontWeight="bold"
                      >
                        {bloc.name}
                      </text>
                      {bloc.members.map((id, index) => {
                        const node = nodeById[id];
                        if (!node) return null;
                        const y = box.y + HEAD_H + 10 + index * ROW_H;
                        const selected = focus === id;
                        return (
                          <g
                            key={id}
                            onClick={() => setFocus(selected ? '' : id)}
                            style={{ cursor: 'pointer' }}
                          >
                            <rect
                              x={box.x + 5}
                              y={y - 12}
                              width={box.w - 10}
                              height={ROW_H - 3}
                              rx={3}
                              fill={selected ? '#2f2a1c' : 'transparent'}
                            />
                            <circle
                              cx={box.x + 15}
                              cy={y - 4}
                              r={4}
                              fill={node.accent}
                              opacity={node.own ? 1 : 0.75}
                            />
                            <text
                              x={box.x + 26}
                              y={y}
                              fill={node.own ? '#f0dfa8' : '#dcdcdc'}
                              fontSize="11"
                              fontWeight={node.own ? 'bold' : 'normal'}
                            >
                              {node.name.length > 22
                                ? `${node.name.slice(0, 21)}…`
                                : node.name}
                            </text>
                          </g>
                        );
                      })}
                    </g>
                  );
                })}
              </svg>

              {!!ownFaction && (
                <Box mt={1} opacity={0.7}>
                  Обведена ваша фракция:{' '}
                  <Box inline bold color={ownFaction.accent}>
                    <Icon name={ownFaction.icon} mr={1} />
                    {ownFaction.name}
                  </Box>
                </Box>
              )}
            </Section>
          </Stack.Item>

          {!!ownClan && (
            <Stack.Item>
              <Section title={`Клан: ${ownClan}`}>
                <Stack vertical>
                  {clans.map((clan, index) => (
                    <Stack.Item key={`c${index}`}>
                      <Box inline bold color={clan.accent}>
                        <Icon name={clan.icon} mr={1} />
                        {clan.name}
                      </Box>
                      <Box inline ml={1} bold color={clan.labelAccent}>
                        {clan.label}
                      </Box>
                      <Box opacity={0.6}>{clan.intensity}</Box>
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            </Stack.Item>
          )}

          {!!ownHouse && (
            <Stack.Item>
              <Section title={`Дом ${ownHouse}`}>
                {!houses.length && (
                  <Box opacity={0.6}>
                    С другими домами у вас пока ничего не случалось.
                  </Box>
                )}
                <Stack vertical>
                  {houses.map((house, index) => (
                    <Stack.Item key={`h${index}`}>
                      <Box inline bold>
                        {house.name}
                      </Box>
                      <Box inline ml={1} bold color={house.labelAccent}>
                        {house.label}
                      </Box>
                      <Box opacity={0.6}>
                        {house.intensity} · случаев: {house.incidents}
                      </Box>
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            </Stack.Item>
          )}

          {!ownFaction && !ownHouse && !ownClan && !edges.length && (
            <Stack.Item>
              <NoticeBox>Вам пока не о чем судить.</NoticeBox>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
