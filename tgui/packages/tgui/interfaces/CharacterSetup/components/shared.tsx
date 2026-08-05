import { type CSSProperties, type ReactNode } from 'react';
import { Box, Button, Slider, Stack } from 'tgui-core/components';

import type { RoleplayData } from '../types';

export const cardStyle = {
  border: '1px solid rgba(255,255,255,0.12)',
};

export const selectedCardStyle = {
  border: '1px solid rgba(255,255,255,0.32)',
  boxShadow: 'inset 0 0 0 1px rgba(255,255,255,0.08)',
};

const modalBackdrop = {
  position: 'absolute' as const,
  inset: '0',
  background: 'rgba(0, 0, 0, 0.82)',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  zIndex: 30,
};

const normalizeCssColor = (color?: string | null) => {
  if (!color) {
    return null;
  }
  if (color.startsWith('#') || color.startsWith('rgb') || color.startsWith('hsl')) {
    return color;
  }
  if (/^[0-9a-f]{3,8}$/i.test(color)) {
    return `#${color}`;
  }
  return color;
};

export const manorSummary = (roleplay: RoleplayData) => {
  if (!roleplay.have_manor) {
    return 'Нет';
  }
  const name = roleplay.manor_name || 'Unknown Manor';
  const type = roleplay.manor_type || 'Manor';
  return `${name} • ${type}`;
};

export const swatch = (color?: string | null) => {
  const cssColor = normalizeCssColor(color);
  if (!cssColor) {
    return null;
  }
  return (
    <Box
      inline
      ml={0.5}
      style={{
        width: '12px',
        height: '12px',
        backgroundColor: cssColor,
        border: '1px solid rgba(255,255,255,0.25)',
        verticalAlign: 'middle',
      }}
    />
  );
};

export const truncate = (value?: string | null, max = 180) => {
  if (!value) {
    return 'Не задано';
  }
  return value.length > max ? `${value.slice(0, max)}…` : value;
};

export const translateChoiceValue = (value?: string | null) => {
  if (!value) {
    return 'Не задано';
  }
  const raw = `${value}`;
  const lower = raw.toLowerCase();

  if (lower === 'androgynous') {
    return 'Андрогинный';
  }
  if (lower === 'masculine') {
    return 'Мужской';
  }
  if (lower === 'feminine') {
    return 'Женский';
  }
  if (lower === 'he/him') {
    return 'he/him';
  }
  if (lower === 'she/her') {
    return 'she/her';
  }
  if (lower === 'they/them') {
    return 'they/them';
  }
  if (lower === 'it/its') {
    return 'it/its';
  }

  return raw;
};

export const ModalShell = (props: {
  title: string;
  width?: string;
  maxHeight?: string;
  contentMaxHeight?: string;
  children: ReactNode;
  onClose: () => void;
}) => (
  <Box style={modalBackdrop}>
    <Box
      style={{
        width: props.width || '1180px',
        maxWidth: 'calc(100% - 24px)',
        maxHeight: props.maxHeight || '92%',
        overflow: 'hidden',
        border: '1px solid rgba(255,255,255,0.14)',
        background: 'rgba(0,0,0,0.96)',
      }}
    >
      <Box
        px={1}
        py={0.75}
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          borderBottom: '1px solid rgba(255,255,255,0.12)',
        }}
      >
        <Box bold>{props.title}</Box>
        <Button onClick={props.onClose}>Закрыть</Button>
      </Box>
      <Box p={1} style={{ maxHeight: props.contentMaxHeight || '84vh', overflow: 'auto' }}>
        {props.children}
      </Box>
    </Box>
  </Box>
);

export const CompactRow = (props: {
  label: string;
  value: ReactNode;
  onClick?: () => void;
  colorPreview?: string | null;
  subtle?: boolean;
  wrap?: boolean;
  auxButton?: ReactNode;
  labelBasis?: string;
  valueStyle?: CSSProperties;
}) => {
  const valueNode = (
    <Box
      bold
      style={{
        minWidth: 0,
        maxWidth: '100%',
        ...(props.wrap
          ? { overflowWrap: 'anywhere', whiteSpace: 'normal', lineHeight: 1.15, wordBreak: 'break-word' }
          : { overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }),
        ...props.valueStyle,
      }}
    >
      {props.value}
      {swatch(props.colorPreview)}
    </Box>
  );

  return (
    <Box mb={0.35} p={0.35} style={{ ...cardStyle, opacity: props.subtle ? 0.88 : 1 }}>
      <Stack align={props.wrap ? 'start' : 'center'}>
        <Stack.Item basis={props.labelBasis || '160px'} shrink={0}>
          <Box color="label">{props.label}</Box>
        </Stack.Item>
        {props.auxButton ? (
          <Stack.Item shrink={0} mr={0.35}>
            {props.auxButton}
          </Stack.Item>
        ) : null}
        <Stack.Item grow style={{ minWidth: 0, maxWidth: '100%' }}>
          {props.onClick ? (
            <Button
              fluid
              textAlign="left"
              onClick={props.onClick}
              style={{
                minWidth: 0,
                maxWidth: '100%',
                minHeight: props.wrap ? 'unset' : '28px',
                overflow: 'hidden',
              }}
            >
              {valueNode}
            </Button>
          ) : (
            <Box px={0.7} py={0.45} style={{ ...cardStyle, minWidth: 0, maxWidth: '100%' }}>
              {valueNode}
            </Box>
          )}
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const PaletteButton = (props: {
  color?: string | null;
  disabled?: boolean;
  tooltip?: string;
  onClick: () => void;
}) => (
  <Button
    compact
    icon="palette"
    disabled={props.disabled}
    tooltip={props.tooltip}
    tooltipPosition="bottom"
    onClick={props.onClick}
    style={{
      minWidth: '28px',
      width: '28px',
      height: '28px',
      padding: 0,
      border: props.color ? `1px solid ${props.color}` : undefined,
      boxShadow: props.color ? `inset 0 0 0 1px ${props.color}` : undefined,
    }}
  />
);

const clampNumericValue = (value: number, min: number, max: number) => Math.min(max, Math.max(min, value));

const normalizeStepValue = (value: number, step: number) => {
  if (step >= 1) {
    return Math.round(value);
  }
  const decimals = Math.max(0, (`${step}`.split('.')[1] || '').length);
  return Number(value.toFixed(decimals));
};

export const SliderNumberRow = (props: {
  label: string;
  value: number;
  min: number;
  max: number;
  step: number;
  onCommit: (value: number) => void;
  paletteColor?: string | null;
  paletteTooltip?: string;
  sliderTooltip?: string;
  onPaletteClick?: () => void;
  disabled?: boolean;
  labelBasis?: string;
  stepPixelSize?: number;
  formatValue?: (value: number) => ReactNode;
}) => {
  const handleSliderChange = (...args: unknown[]) => {
    const rawValue = typeof args[0] === 'number' ? args[0] : args[1];
    if (typeof rawValue !== 'number' || !Number.isFinite(rawValue)) {
      return;
    }
    const nextValue = normalizeStepValue(
      clampNumericValue(rawValue, props.min, props.max),
      props.step,
    );
    if (nextValue !== props.value) {
      props.onCommit(nextValue);
    }
  };

  return (
    <Box mb={0.35} p={0.35} style={cardStyle}>
      <Stack align="center">
        <Stack.Item basis={props.labelBasis || '160px'} shrink={0}>
          <Box color="label">{props.label}</Box>
        </Stack.Item>
        {props.onPaletteClick ? (
          <Stack.Item shrink={0} mr={0.35}>
            <PaletteButton
              color={props.paletteColor}
              disabled={props.disabled}
              tooltip={props.paletteTooltip}
              onClick={props.onPaletteClick}
            />
          </Stack.Item>
        ) : null}
        <Stack.Item grow style={{ minWidth: 0 }}>
          <Slider
            fluid
            minValue={props.min}
            maxValue={props.max}
            step={props.step}
            stepPixelSize={props.stepPixelSize || 2}
            value={props.value}
            format={props.formatValue}
            disabled={props.disabled}
            suppressFlicker={250}
            onChange={handleSliderChange}
          />
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const Subhead = (props: { children: ReactNode }) => (
  <Box mt={0.6} mb={0.35} bold color="label">
    {props.children}
  </Box>
);
