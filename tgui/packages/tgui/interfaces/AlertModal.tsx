import { type KeyboardEvent, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Autofocus, Box, Button, Section, Stack } from 'tgui-core/components';
import { isEscape, KEY } from 'tgui-core/keys';
import type { BooleanLike } from 'tgui-core/react';

import { Loader } from './common/Loader';

type Data = {
  autofocus: BooleanLike;
  buttons: string[];
  large_buttons: BooleanLike;
  message: string;
  swapped_buttons: BooleanLike;
  timeout: number;
  title: string;
};

enum DIRECTION {
  Increment = 1,
  Decrement = -1,
}

function renderButtonContent(button: string, large_buttons: BooleanLike) {
  const [label, detail] = button.split('\n', 2);

  if (!detail) {
    return !large_buttons ? button : button.toUpperCase();
  }

  return (
    <span
      style={{
        display: 'inline-flex',
        flexDirection: 'column',
        gap: '2px',
        lineHeight: 1.05,
      }}
    >
      <span>{!large_buttons ? label : label.toUpperCase()}</span>
      <span
        style={{
          color: '#ffd36a',
          fontSize: '0.82em',
          fontWeight: 700,
        }}
      >
        {detail}
      </span>
    </span>
  );
}

export function AlertModal(props) {
  const { act, data } = useBackend<Data>();
  const {
    autofocus,
    buttons = [],
    large_buttons,
    message = '',
    timeout,
    title,
  } = data;

  // Stolen wholesale from fontcode
  function textWidth(text: string, font: string, fontsize: number) {
    // default font height is 12 in tgui
    font = `${fontsize}x ${font}`;
    const c = document.createElement('canvas');
    const ctx = c.getContext('2d') as CanvasRenderingContext2D;
    ctx.font = font;
    return ctx.measureText(text).width;
  }

  const [selected, setSelected] = useState(0);

  const hasButtonDetails = buttons.some((button) => button.includes('\n'));
  const messageLineBreaks = (message.match(/\n/g) || []).length;
  const windowWidth = hasButtonDetails
    ? 520
    : 345 + (buttons.length > 2 ? 55 : 0);

  // very accurate estimate of padding for each num of buttons
  const paddingMagicNumber = 67 / buttons.length + 23;

  // At least one of the buttons has a long text message
  const isVerbose = buttons.some(
    (button) =>
      textWidth(
        button.replace('\n', ' '),
        '',
        large_buttons ? 14 : 12,
      ) > // 14 is the larger font size for large buttons
      windowWidth / buttons.length - paddingMagicNumber,
  );
  const largeSpacing = isVerbose && large_buttons ? 20 : 15;

  // Dynamically sets window dimensions
  const windowHeight =
    140 +
    (isVerbose ? largeSpacing * buttons.length : 0) +
    (hasButtonDetails ? 16 * buttons.length : 0) +
    messageLineBreaks * 12 +
    (message.length > 30 ? Math.ceil(message.length / 4) : 0) +
    (message.length && large_buttons ? 5 : 0);

  /** Changes button selection, etc */
  function keyDownHandler(event: KeyboardEvent<HTMLDivElement>) {
    switch (event.key) {
      case KEY.Space:
      case KEY.Enter:
        act('choose', { choice: buttons[selected] });
        return;
      case KEY.Left:
        event.preventDefault();
        onKey(DIRECTION.Decrement);
        return;
      case KEY.Tab:
      case KEY.Right:
        event.preventDefault();
        onKey(DIRECTION.Increment);
        return;

      default:
        if (isEscape(event.key)) {
          act('cancel');
          return;
        }
    }
  }

  /** Manages iterating through the buttons */
  function onKey(direction: DIRECTION) {
    const newIndex = (selected + direction + buttons.length) % buttons.length;
    setSelected(newIndex);
  }

  return (
    <Window height={windowHeight} title={title} width={windowWidth}>
      {!!timeout && <Loader value={timeout} />}
      <Window.Content onKeyDown={keyDownHandler}>
        <Section fill>
          <Stack fill vertical>
            <Stack.Item m={1} grow>
              <Box
                color="label"
                overflow="hidden"
                style={{ whiteSpace: 'pre-line' }}
              >
                {message}
              </Box>
            </Stack.Item>
            <Stack.Item grow>
              {!!autofocus && <Autofocus />}
              {isVerbose ? (
                <VerticalButtons selected={selected} />
              ) : (
                <HorizontalButtons selected={selected} />
              )}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
}

type ButtonDisplayProps = {
  selected: number;
};

/**
 * Displays a list of buttons ordered by user prefs.
 */
function HorizontalButtons(props: ButtonDisplayProps) {
  const { act, data } = useBackend<Data>();
  const { buttons = [], large_buttons, swapped_buttons } = data;
  const { selected } = props;

  return (
    <Stack fill justify="space-around" reverse={!swapped_buttons}>
      {buttons.map((button, index) => (
        <Stack.Item grow={large_buttons ? 1 : undefined} key={index}>
          <Button
            fluid={!!large_buttons}
            minWidth={5}
            onClick={() => act('choose', { choice: button })}
            overflowX="hidden"
            px={2}
            py={large_buttons ? 0.5 : 0}
            selected={selected === index}
            textAlign="center"
          >
            {renderButtonContent(button, large_buttons)}
          </Button>
        </Stack.Item>
      ))}
    </Stack>
  );
}

/**
 * Technically the parent handles more than 2 buttons, but you
 * should just be using a list input in that case.
 */
function VerticalButtons(props: ButtonDisplayProps) {
  const { act, data } = useBackend<Data>();
  const { buttons = [], large_buttons, swapped_buttons } = data;
  const { selected } = props;

  return (
    <Stack
      align="center"
      fill
      justify="space-around"
      reverse={!swapped_buttons}
      vertical
    >
      {buttons.map((button, index) => (
        <Stack.Item
          grow
          width={large_buttons ? '100%' : undefined}
          key={index}
          m={0}
        >
          <Button
            fluid
            minWidth={20}
            onClick={() => act('choose', { choice: button })}
            overflowX="hidden"
            px={2}
            py={large_buttons ? 0.5 : 0}
            selected={selected === index}
            textAlign="center"
          >
            {renderButtonContent(button, large_buttons)}
          </Button>
        </Stack.Item>
      ))}
    </Stack>
  );
}
