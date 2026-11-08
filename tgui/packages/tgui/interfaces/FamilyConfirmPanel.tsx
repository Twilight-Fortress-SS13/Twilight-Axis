import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Box, Button, Section, Stack } from 'tgui-core/components';

type Data = {
  title?: string;
  message?: string;
  mutual?: boolean;
  openCount?: number;
};

export const FamilyConfirmPanel = () => {
  const { act, data } = useBackend<Data>();
  const {
    title = 'Семейная система',
    message = '',
  } = data;

  return (
    <Window width={540} height={460} title={title}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <Section fill scrollable title="Семейное предложение">
              <Box style={{ whiteSpace: 'pre-line' }}>{message}</Box>
            </Section>
          </Stack.Item>


          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <Button
                  fluid
                  color="good"
                  icon="check"
                  onClick={() => act('accept')}
                  py={1}
                  textAlign="center"
                >
                  Да, принять
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  color="bad"
                  icon="xmark"
                  onClick={() => act('reject')}
                  py={1}
                  textAlign="center"
                >
                  Нет, отказаться
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
