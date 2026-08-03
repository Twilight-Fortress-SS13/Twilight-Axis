import { useEffect, useRef } from 'react';
import { Button, Stack } from 'tgui-core/components';

import { ModalShell, cardStyle } from '../components/shared';

export const KeyCaptureModal = (props: {
  bindingLabel: string;
  oldKey?: string | null;
  onClose: () => void;
  onSet: (payload: {
    key: string;
    alt: boolean;
    ctrl: boolean;
    shift: boolean;
    numpad: boolean;
  }) => void;
  onClear: () => void;
}) => {
  const captureRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    captureRef.current?.focus();
  }, []);

  const onKeyDown = (event: React.KeyboardEvent<HTMLDivElement>) => {
    event.preventDefault();
    event.stopPropagation();

    if (event.key === 'Escape') {
      props.onClose();
      return;
    }

    props.onSet({
      key: event.key,
      alt: event.altKey,
      ctrl: event.ctrlKey,
      shift: event.shiftKey,
      numpad: event.location === 3,
    });
  };

  return (
    <ModalShell title={`Назначение клавиши: ${props.bindingLabel}`} width="520px" onClose={props.onClose}>
      <div
        ref={captureRef}
        tabIndex={0}
        style={{
          ...cardStyle,
          outline: 'none',
          minHeight: '140px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          textAlign: 'center',
          lineHeight: 1.4,
          padding: '1.2rem',
        }}
        onKeyDown={onKeyDown}
      >
        <div>
          Нажми нужную клавишу или сочетание.
          <br />
          Escape — закрыть.
        </div>
      </div>
      <Stack mt={0.75}>
        <Stack.Item grow>
          <Button fluid onClick={props.onClose}>Отмена</Button>
        </Stack.Item>
        {props.oldKey ? (
          <Stack.Item grow>
            <Button fluid color="bad" onClick={props.onClear}>Очистить</Button>
          </Stack.Item>
        ) : null}
      </Stack>
    </ModalShell>
  );
};
