import { Component, type CSSProperties, type PropsWithChildren } from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  KeyListener,
  LabeledList,
  Slider,
  Tooltip,
} from 'tgui-core/components';
import type { KeyEvent } from 'tgui-core/events';
import { KEY } from 'tgui-core/keys';

const pauseEvent = (e) => {
  if (e.stopPropagation) {
    e.stopPropagation();
  }
  if (e.preventDefault) {
    e.preventDefault();
  }
  e.cancelBubble = true;
  e.returnValue = false;
  return false;
};

type Props = PropsWithChildren<{
  onZoom?: (zoom: number) => void;
  onClick?: (x: number, y: number) => void; // TA EDIT
}>;

type State = {
  offsetX: number;
  offsetY: number;
  dragging: boolean;
  originX: number;
  originY: number;
  zoom: number;
};

export class NanoMap extends Component<Props, State> {
  static Marker: React.FC<NanoMapMarkerProps>;
  static Zoomer: React.FC<NanoMapZoomerProps>;

  handleDragStart: React.MouseEventHandler<HTMLDivElement>;
  handleDragMove: (e: MouseEvent) => void;
  handleDragEnd: (e: MouseEvent) => void;
  handleZoom: (e: Event, v: number) => void;
  handleWheel: (e: WheelEvent) => void;
  handleKey: (e: KeyEvent) => void;
  ref: EventTarget;

  componentDidMount() {
    document.addEventListener('wheel', this.handleWheel);
  }

  componentWillUnmount() {
    document.removeEventListener('wheel', this.handleWheel);
  }

  getWxH = (zoom: number) => {
    // TA EDIT BEGIN
    const { config, data } = useBackend<any>();
    const maxx = data?.maxx ?? config?.mapInfo?.maxx ?? 255;
    const maxy = data?.maxy ?? config?.mapInfo?.maxy ?? 255;
    return [maxx * 2 * zoom, maxy * 2 * zoom];
    // TA EDIT END
  };

  setZoom(zoom: number, mouseX: number, mouseY: number) {
    const newZoom = Math.min(Math.max(zoom, 1), 8);
    this.setState((state) => {
      const oldWxH = this.getWxH(state.zoom);
      const newWxH = this.getWxH(newZoom);

      const scaleX = newWxH[0] / oldWxH[0];
      const scaleY = newWxH[1] / oldWxH[1];

      const viewMouseX = mouseX - state.offsetX;
      const viewMouseY = mouseY - state.offsetY;

      const newOffsetX = mouseX - viewMouseX * scaleX;
      const newOffsetY = mouseY - viewMouseY * scaleY;

      return {
        ...state,
        zoom: newZoom,
        offsetX: newOffsetX,
        offsetY: newOffsetY,
      };
    });

    if (this.props.onZoom) {
      this.props.onZoom(newZoom);
    }
  }

  constructor(props: Props) {
    super(props);

    // Auto center based on window size
    const Xcenter = window.innerWidth / 2 - 256;
    const Ycenter = window.innerHeight / 2 - 256;

    this.state = {
      offsetX: Xcenter,
      offsetY: Ycenter,
      dragging: false,
      originX: 0,
      originY: 0,
      zoom: 1,
    };

    // Dragging
    this.handleDragStart = (e: React.MouseEvent<HTMLDivElement>) => {
      this.ref = e.target;
      this.setState({
        dragging: false,
        originX: e.screenX,
        originY: e.screenY,
      });
      document.addEventListener('mousemove', this.handleDragMove);
      document.addEventListener('mouseup', this.handleDragEnd);
      pauseEvent(e);
    };

    this.handleDragMove = (e: MouseEvent) => {
      this.setState((prevState) => {
        const state = { ...prevState };
        const newOffsetX = e.screenX - state.originX;
        const newOffsetY = e.screenY - state.originY;
        if (prevState.dragging) {
          state.offsetX += newOffsetX;
          state.offsetY += newOffsetY;
          state.originX = e.screenX;
          state.originY = e.screenY;
        } else {
          state.dragging = true;
        }
        return state;
      });
      pauseEvent(e);
    };

    this.handleDragEnd = (e: MouseEvent) => {
      this.setState({
        dragging: false,
        originX: 0,
        originY: 0,
      });
      document.removeEventListener('mousemove', this.handleDragMove);
      document.removeEventListener('mouseup', this.handleDragEnd);
      pauseEvent(e);
    };

    this.handleWheel = (e: WheelEvent) => {
      if (e.deltaY > 0) {
        this.setZoom(this.state.zoom - 1, e.clientX, e.clientY);
      } else if (e.deltaY < 0) {
        this.setZoom(this.state.zoom + 1, e.clientX, e.clientY);
      }
    };

    this.handleZoom = (_e: Event, value: number) => {
      this.setZoom(value, window.innerWidth / 2, window.innerHeight / 2);
    };

    this.handleKey = (e: KeyEvent) => {
      switch (e.event.key) {
        case KEY.Up:
        case KEY.W: {
          this.setZoom(
            this.state.zoom + 1,
            window.innerWidth / 2,
            window.innerHeight / 2,
          );
          break;
        }
        case KEY.Down:
        case KEY.S: {
          this.setZoom(
            this.state.zoom - 1,
            window.innerWidth / 2,
            window.innerHeight / 2,
          );
          break;
        }
      }
    };
  }

  render() {
    const { config, data } = useBackend<any>(); // TA EDIT
    const { dragging, offsetX, offsetY, zoom = 1 } = this.state;
    const { children } = this.props;

    const WxH = this.getWxH(zoom);
    // TA EDIT BEGIN
    const mapZLevel = data?.mapZLevel ?? config?.mapZLevel ?? 1;
    const mapUrl = resolveAsset(`/minimap_${mapZLevel}.png`);
    // TA EDIT END
    const newStyle: CSSProperties = {
      width: `${WxH[0]}px`,
      height: `${WxH[1]}px`,
      transform: `translate(${offsetX}px, ${offsetY}px)`, // TA EDIT
      overflow: 'hidden',
      position: 'absolute', // TA EDIT
      imageRendering: 'pixelated',
      backgroundImage: `url(${mapUrl})`,
      backgroundSize: 'cover',
      backgroundRepeat: 'no-repeat',
      textAlign: 'center',
      cursor: dragging ? 'move' : 'auto',
    };
    // TA EDIT BEGIN
    const handleMapClick = (e: React.MouseEvent<HTMLDivElement>) => {
      if (this.state.dragging) return;
      if (!this.props.onClick) return;

      const rect = e.currentTarget.getBoundingClientRect();
      const clickX = e.clientX - rect.left;
      const clickY = e.clientY - rect.top;

      const tileX = Math.floor(clickX / (2 * zoom)) + 1;
      const tileY = Math.floor((rect.height - clickY) / (2 * zoom)) + 1;

      this.props.onClick(tileX, tileY);
    };

    return (
      <Box
        className="NanoMap__container"
        overflow="hidden"
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
        }}
      // TA EDIT END
      >
        <Box
          style={newStyle}
          textAlign="center"
          onMouseDown={this.handleDragStart}
          onClick={handleMapClick} // TA EDIT
        >
          <Box>{children}</Box>
        </Box>
        <NanoMapZoomer zoom={zoom} onZoom={this.handleZoom} />
        <KeyListener onKeyDown={this.handleKey} />
      </Box>
    );
  }
}

type NanoMapMarkerProps = {
  x: number;
  y: number;
  zoom: number;
  icon: string;
  tooltip: string;
  color: string;
  onClick?: (e: React.MouseEvent<HTMLDivElement>) => void;
};

const NanoMapMarker = (props: NanoMapMarkerProps) => {
  const { x, y, zoom = 1, icon, tooltip, color, onClick } = props;

  const handleOnClick = (e: React.MouseEvent<HTMLDivElement>) => {
    pauseEvent(e);
    if (onClick) {
      onClick(e);
    }
  };

  const rx = x * 2 * zoom - zoom;
  const ry = y * 2 * zoom - zoom;
  return (
    <Tooltip content={tooltip}>
      <Box
        position="absolute"
        className="NanoMap__marker"
        lineHeight="0"
        bottom={`${ry}px`}
        left={`${rx}px`}
        onMouseDown={handleOnClick}
      >
        <Icon name={icon} color={color} size={zoom * 0.25} />
      </Box>
    </Tooltip>
  );
};

NanoMap.Marker = NanoMapMarker;

type Data = {
  map_levels: number[];
};

type NanoMapZoomerProps = {
  zoom: number;
  onZoom: (e: Event, v: number) => void;
};

const NanoMapZoomer = (props: NanoMapZoomerProps) => {
  const { act, config, data } = useBackend<Data>();
  return (
    <Box className="NanoMap__zoomer">
      <LabeledList>
        <LabeledList.Item label="Zoom">
          <Slider
            tickWhileDragging
            minValue={1}
            maxValue={8}
            stepPixelSize={10}
            format={(v) => `${v}x`}
            value={props.zoom}
            onChange={(e, v) => props.onZoom(e, v)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Z-Level">
          {(data?.map_levels || []) // TA EDIT
            .sort((a, b) => Number(a) - Number(b))
            .map((level) => (
              <Button
                key={level}
                selected={~~level === ~~(data?.mapZLevel ?? config?.mapZLevel ?? 1)} // TA EDIT
                onClick={() => {
                  act('setZLevel', { mapZLevel: level });
                }}
              >
                {level}
              </Button>
            ))}
        </LabeledList.Item>
      </LabeledList>
    </Box>
  );
};

NanoMap.Zoomer = NanoMapZoomer;
