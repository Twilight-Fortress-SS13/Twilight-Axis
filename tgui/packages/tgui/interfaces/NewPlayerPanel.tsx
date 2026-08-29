import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack, Tooltip } from 'tgui-core/components';

import { TegakiAnimation } from './common/TegakiAnimation';
import { Window } from '../layouts';

type ReadyJob = {
  count_only: boolean;
  length: number;
  name: string;
  players: string[];
};

type ReadyJobGroup = {
  color: string;
  jobs: ReadyJob[];
  name: string;
};

type Data = {
  active_character: string;
  migrant: boolean;
  pregame: boolean | number;
  ready: number;
  ready_count: number;
  ready_job_groups: ReadyJobGroup[];
  round_in_progress: boolean | number;
  server_name: string;
  ticker_state: number;
  time_remaining: number;
};

const bonusTooltip =
  'Ready up bonus:\n' +
  '20 mammons in a stashed pouch\n' +
  'Full Hydration & Great Meal bonus\n' +
  '+1 Triumph';

export const NewPlayerPanel = () => {
  const { act, data } = useBackend<Data>();
  const {
    migrant,
    pregame,
    ready,
    ready_count,
    ready_job_groups,
    round_in_progress,
    time_remaining,
  } = data;

  const secondsRemaining = Math.max(0, Math.ceil((time_remaining || 0) / 10));
  const isReady = ready !== 0;
  const isPregame = Boolean(pregame);
  const isRoundInProgress = Boolean(round_in_progress);

  return (
    <Window width={330} height={830}>
      <Window.Content scrollable>
        <Box mt={2.5} mb={2.5}>
          <TegakiAnimation
            height={4}
            time={{ mode: 'uncontrolled', speed: 10, loop: false }}
            style={{ fontSize: 30, textAlign: 'center' }}
          >
            Welcome To Twilight Axis
          </TegakiAnimation>
        </Box>

        {isPregame && (
          <Section title="PRE-GAME LOBBY">
            <Stack vertical>
              <Stack.Item>
                <Stack align="center">
                  <Stack.Item grow>
                    <Box>Time to start: {secondsRemaining}s</Box>
                    <Box mt={0.5}>Total players ready: {ready_count || 0}</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Box
                      textAlign="center"
                      color={isReady ? 'good' : 'bad'}
                    >
                      {isReady ? 'Ready Bonus!' : 'No Bonus'}{' '}
                      <Tooltip content={bonusTooltip} position="bottom">
                        <Box
                          inline
                          style={{
                            cursor: 'help',
                            textDecoration: 'underline',
                          }}
                        >
                          (?)
                        </Box>
                      </Tooltip>
                    </Box>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Section>
        )}

        {isRoundInProgress && (
          <Section title="ROUND IN PROGRESS">
            <Button
              fluid
              icon="sign-in-alt"
              mb={0.5}
              onClick={() => act('late_join')}
            >
              Join Game
            </Button>
            <Button
              fluid
              disabled={migrant}
              icon="people-carry"
              mb={0.5}
              onClick={() => act('migrants')}
            >
              Migrants
            </Button>
            <Button fluid icon="scroll" onClick={() => act('manifest')}>
              Manifest
            </Button>
          </Section>
        )}

        <Section title="CLASSES" minHeight="260px">
          {ready_job_groups?.map((group) => (
            <Box key={group.name} mb={1}>
              <Box
                bold
                mb={0.5}
                textAlign="center"
                style={{ color: group.color }}
              >
                ----- {group.name} -----
              </Box>
              <Box
                p={0.75}
                style={{
                  background: 'rgba(0, 0, 0, 0.18)',
                  border: '1px solid rgba(123, 83, 83, 0.35)',
                }}
              >
                {[...group.jobs]
                  .sort((a, b) => a.name.localeCompare(b.name))
                  .map((job) => (
                    <Box key={job.name} mb={0.25}>
                      <b>{job.name}</b> ({job.length})
                      {!job.count_only && job.players?.length
                        ? ` - ${job.players.join(', ')}`
                        : ''}
                    </Box>
                  ))}
              </Box>
            </Box>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
