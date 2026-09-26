import { useEffect, useMemo, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  Input,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { isEscape } from 'tgui-core/keys';
import { createSearch } from 'tgui-core/string';

type TileAtom = {
  name: string;
  path: string;
  ref: string;
  appearance_ref?: string | null;
  is_turf?: boolean;
};

type TileGroup = {
  amount: number;
  item: TileAtom;
};

type Data = {
  has_target: boolean;
  name?: string;
  atoms?: TileAtom[];
};

type DragState = {
  active: boolean;
  started: boolean;
  srcRef: string | null;
  button: number;
  shift: number;
  ctrl: number;
  alt: number;
  startX: number;
  startY: number;
  pointerId: number | null;
};

const DRAG_THRESHOLD_PX = 6;

const defaultDrag: DragState = {
  active: false,
  started: false,
  srcRef: null,
  button: 0,
  shift: 0,
  ctrl: 0,
  alt: 0,
  startX: 0,
  startY: 0,
  pointerId: null,
};

function IconDisplay(props: { item: TileAtom; size?: number }) {
  const { item, size = 2.5 } = props;

  if (!item.appearance_ref) {
    return <Icon name="cube" size={1.5} color="gray" />;
  }

  return (
    <img
      src={item.appearance_ref}
      style={{
        width: `${size}em`,
        height: `${size}em`,
        objectFit: 'contain',
        imageRendering: 'pixelated',
        pointerEvents: 'none',
        display: 'block',
      }}
    />
  );
}

function TileBox(props: {
  item?: TileAtom;
  group?: TileGroup;
  dragRef: React.MutableRefObject<DragState>;
}) {
  const { act } = useBackend<Data>();

  let amount = 0;
  let item: TileAtom;

  if (props.group) {
    amount = props.group.amount;
    item = props.group.item;
  } else if (props.item) {
    item = props.item;
  } else {
    return null;
  }

  const refocusMap = () => {
    try {
      (window as any).Byond?.command?.('tgui_refocus_map');
    } catch {}
  };

  const sendInteract = (atomRef: string, e: PointerEvent) => {
    if (e.button === 2) {
      e.preventDefault?.();
    }

    act('interact', {
      ref: atomRef,
      button: e.button ?? 0,
      shift: e.shiftKey ? 1 : 0,
      ctrl: e.ctrlKey ? 1 : 0,
      alt: e.altKey ? 1 : 0,
    });

    queueMicrotask(refocusMap);
  };

  const getOverRefFromPoint = (clientX: number, clientY: number) => {
    const el = document.elementFromPoint(clientX, clientY) as HTMLElement | null;
    const card = el?.closest?.('[data-atom-ref]') as HTMLElement | null;
    return card?.dataset?.atomRef || null;
  };

  const sendDrop = (srcRef: string, overRef: string, d: DragState) => {
    act('drop', {
      src: srcRef,
      over: overRef,
      button: d.button,
      shift: d.shift,
      ctrl: d.ctrl,
      alt: d.alt,
      'icon-x': 16,
      'icon-y': 16,
    });

    queueMicrotask(refocusMap);
  };

  return (
    <div
      data-atom-ref={item.ref}
      onContextMenu={(event) => event.preventDefault()}
      onPointerDown={(event) => {
        if (event.button === 2) {
          event.preventDefault();
        }

        props.dragRef.current = {
          active: true,
          started: false,
          srcRef: item.ref,
          button: event.button ?? 0,
          shift: event.shiftKey ? 1 : 0,
          ctrl: event.ctrlKey ? 1 : 0,
          alt: event.altKey ? 1 : 0,
          startX: event.clientX,
          startY: event.clientY,
          pointerId: event.pointerId,
        };

        try {
          (event.currentTarget as any).setPointerCapture?.(event.pointerId);
        } catch {}
      }}
      onPointerMove={(event) => {
        const d = props.dragRef.current;
        if (!d.active || d.pointerId !== event.pointerId || !d.srcRef) {
          return;
        }

        const dx = Math.abs(event.clientX - d.startX);
        const dy = Math.abs(event.clientY - d.startY);

        if (!d.started && (dx > DRAG_THRESHOLD_PX || dy > DRAG_THRESHOLD_PX)) {
          d.started = true;
        }
      }}
      onPointerUp={(event) => {
        const d = props.dragRef.current;
        if (!d.active || d.pointerId !== event.pointerId) {
          return;
        }

        const srcRef = d.srcRef;
        const started = d.started;

        props.dragRef.current = { ...defaultDrag };

        try {
          (event.currentTarget as any).releasePointerCapture?.(event.pointerId);
        } catch {}

        if (!srcRef) {
          return;
        }

        if (!started) {
          sendInteract(srcRef, event.nativeEvent);
          return;
        }

        const overRef = getOverRefFromPoint(event.clientX, event.clientY);
        if (!overRef) {
          return;
        }

        sendDrop(srcRef, overRef, d);
      }}
      onPointerCancel={() => {
        props.dragRef.current = { ...defaultDrag };
      }}
      style={{
        userSelect: 'none',
        touchAction: 'none',
      }}
    >
      <Button fluid p={0.5} color="transparent">
        <Stack align="center">
          <Stack.Item minWidth="36px" minHeight="36px">
            <IconDisplay item={item} />
          </Stack.Item>

          <Stack.Item
            grow
            overflow="hidden"
            style={{ textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}
          >
            {item.name || '???'}
            {item.is_turf ? ' (floor)' : ''}
          </Stack.Item>

          <Stack.Item>{amount > 1 ? `x${amount}` : ''}</Stack.Item>
        </Stack>
      </Button>
    </div>
  );
}

function GroupedContents(props: {
  contents: Record<string, TileAtom[]>;
  searchText: string;
  dragRef: React.MutableRefObject<DragState>;
}) {
  const filteredContents: TileGroup[] = Object.entries(props.contents)
    .filter(createSearch(props.searchText, ([_, items]) => items[0].name))
    .map(([_, items]) => ({ amount: items.length, item: items[0] }));

  return (
    <Box m={-0.5}>
      {filteredContents.map((group) => (
        <TileBox
          key={`${group.item.path}|${group.item.name}|${group.amount}`}
          group={group}
          dragRef={props.dragRef}
        />
      ))}
    </Box>
  );
}

function RawContents(props: {
  contents: TileAtom[];
  searchText: string;
  dragRef: React.MutableRefObject<DragState>;
}) {
  const filteredContents = props.contents.filter(
    createSearch(props.searchText, (item: TileAtom) => item.name),
  );

  return (
    <Box m={-0.5}>
      {filteredContents.map((item) => (
        <TileBox key={item.ref} item={item} dragRef={props.dragRef} />
      ))}
    </Box>
  );
}

export const TilePanel = () => {
  const { act, data } = useBackend<Data>();
  const { atoms = [] } = data;

  const [grouping, setGrouping] = useState(true);
  const [searchText, setSearchText] = useState('');

  const dragRef = useRef<DragState>({ ...defaultDrag });

  const refocusMap = () => {
    try {
      (window as any).Byond?.command?.('tgui_refocus_map');
    } catch {}
  };

  useEffect(() => {
    queueMicrotask(refocusMap);
  }, []);

  const turfAtom = useMemo(() => atoms.find((a) => a.is_turf), [atoms]);
  const nonTurfAtoms = useMemo(() => atoms.filter((a) => !a.is_turf), [atoms]);

  const groupedContents = useMemo(() => {
    const acc: Record<string, TileAtom[]> = {};

    for (let i = 0; i < nonTurfAtoms.length; i++) {
      const item = nonTurfAtoms[i];
      const key = `${item.path}${item.name}`;
      if (!acc[key]) {
        acc[key] = [];
      }
      acc[key].push(item);
    }

    return acc;
  }, [nonTurfAtoms]);

  const title = data.has_target ? data.name || 'Tile Panel' : 'Tile Panel';

  return (
    <Window width={320} height={420} title={title}>
      <Window.Content
        fitted
        onKeyDown={(event) => {
          if (isEscape(event.key)) {
            act('close');
          }
        }}
      >
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            height: '100%',
            minHeight: 0,
          }}
        >
          <div style={{ flex: '0 0 auto', paddingBottom: '6px' }}>
            <Stack align="center">
              <Stack.Item grow basis={0}>
                <Input
                  fluid
                  onChange={setSearchText}
                  placeholder="Search..."
                  value={searchText}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  m={0}
                  width="28px"
                  icon="layer-group"
                  selected={grouping}
                  onClick={() => setGrouping(!grouping)}
                  tooltip="Toggle Grouping"
                />
              </Stack.Item>
            </Stack>
          </div>

          <div
            style={{
              flex: '1 1 auto',
              minHeight: 0,
              overflowY: 'auto',
              overflowX: 'hidden',
            }}
          >
            {!data.has_target ? (
              <NoticeBox>No turf selected.</NoticeBox>
            ) : (
              <Section fill>
                {turfAtom && (
                  <RawContents
                    contents={[turfAtom]}
                    searchText={searchText}
                    dragRef={dragRef}
                  />
                )}

                {grouping ? (
                  <GroupedContents
                    contents={groupedContents}
                    searchText={searchText}
                    dragRef={dragRef}
                  />
                ) : (
                  <RawContents
                    contents={nonTurfAtoms}
                    searchText={searchText}
                    dragRef={dragRef}
                  />
                )}
              </Section>
            )}
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};

export default TilePanel;
