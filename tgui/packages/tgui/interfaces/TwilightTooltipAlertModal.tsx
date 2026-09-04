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
  button_tooltips?: Record<string, string>;
  large_buttons: BooleanLike;
  message: string;
  swapped_buttons: BooleanLike;
  timeout: number;
  title: string;
};

enum Direction {
  Increment = 1,
  Decrement = -1,
}

function renderButtonContent(button: string, largeButtons: BooleanLike) {
  return !largeButtons ? button : button.toUpperCase();
}

export function TwilightTooltipAlertModal(props) {
  const { act, data } = useBackend<Data>();
  const {
    autofocus,
    buttons = [],
    large_buttons,
    message = '',
    timeout,
    title,
  } = data;

  function textWidth(text: string, font: string, fontsize: number) {
    font = `${fontsize}x ${font}`;
    const canvas = document.createElement('canvas');
    const context = canvas.getContext('2d') as CanvasRenderingContext2D;
    context.font = font;
    return context.measureText(text).width;
  }

  const [selected, setSelected] = useState(0);

  const messageLineBreaks = (message.match(/\n/g) || []).length;
  const windowWidth = 345 + (buttons.length > 2 ? 55 : 0);
  const paddingMagicNumber = 67 / buttons.length + 23;
  const isVerbose = buttons.some(
    (button) =>
      textWidth(button, '', large_buttons ? 14 : 12) >
      windowWidth / buttons.length - paddingMagicNumber,
  );
  const largeSpacing = isVerbose && large_buttons ? 20 : 15;
  const windowHeight =
    140 +
    (isVerbose ? largeSpacing * buttons.length : 0) +
    messageLineBreaks * 12 +
    (message.length > 30 ? Math.ceil(message.length / 4) : 0) +
    (message.length && large_buttons ? 5 : 0);

  function keyDownHandler(event: KeyboardEvent<HTMLDivElement>) {
    switch (event.key) {
      case KEY.Space:
      case KEY.Enter:
        act('choose', { choice: buttons[selected] });
        return;
      case KEY.Left:
        event.preventDefault();
        onKey(Direction.Decrement);
        return;
      case KEY.Tab:
      case KEY.Right:
        event.preventDefault();
        onKey(Direction.Increment);
        return;

      default:
        if (isEscape(event.key)) {
          act('cancel');
          return;
        }
    }
  }

  function onKey(direction: Direction) {
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

function HorizontalButtons(props: ButtonDisplayProps) {
  const { act, data } = useBackend<Data>();
  const {
    buttons = [],
    button_tooltips = {},
    large_buttons,
    swapped_buttons,
  } = data;
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
            tooltip={button_tooltips[button]}
          >
            {renderButtonContent(button, large_buttons)}
          </Button>
        </Stack.Item>
      ))}
    </Stack>
  );
}

function VerticalButtons(props: ButtonDisplayProps) {
  const { act, data } = useBackend<Data>();
  const {
    buttons = [],
    button_tooltips = {},
    large_buttons,
    swapped_buttons,
  } = data;
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
            tooltip={button_tooltips[button]}
          >
            {renderButtonContent(button, large_buttons)}
          </Button>
        </Stack.Item>
      ))}
    </Stack>
  );
}
