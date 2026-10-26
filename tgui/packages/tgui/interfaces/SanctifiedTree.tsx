import { useState } from 'react';
import {
  Box,
  Button,
  Icon,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type OfferingLine = {
  id: string;
  name: string;
  icon: string | null;
  current: number;
  required: number;
  fulfilled: boolean;
};

type RitualData = {
  id: string;
  name: string;
  description: string;
  xp: number;
  repeatable: boolean;
  completed: boolean;
  required_skill_level: number;
  required_skill: string;
  blocked_reason: string | null;
  available: boolean;
  alternative_offerings: boolean;
  offerings: OfferingLine[];
};

type Data = {
  rituals: RitualData[];
  active_ritual: RitualData | null;
  wedding_active: boolean;
  integrity: number;
  max_integrity: number;
  integrity_bonus: number;
  slow_aura: boolean;
  heal_aura: boolean;
  soulbound_count: number;
  druidic_level: number;
  druidic_level_name: string;
};

const OfferingIcon = (props: { icon: string | null }) => {
  const { icon } = props;
  if (!icon) {
    return null;
  }
  return (
    <img
      src={`data:image/png;base64,${icon}`}
      width={32}
      height={32}
      style={{
        imageRendering: 'pixelated',
        marginRight: '8px',
        verticalAlign: 'middle',
      }}
    />
  );
};

const OfferingList = (props: {
  ritual: RitualData;
  showProgress?: boolean;
}) => {
  const { ritual, showProgress = false } = props;

  return (
    <>
      {Boolean(ritual.alternative_offerings) && (
        <NoticeBox info>
          Для завершения ритуала достаточно выполнить один из двух вариантов
          подношений.
        </NoticeBox>
      )}
      {ritual.offerings.map((offering) => (
        <Box
          key={offering.id}
          mb={0.5}
          color={showProgress && Boolean(offering.fulfilled) ? 'good' : undefined}
        >
          <Stack align="center">
            <Stack.Item>
              <OfferingIcon icon={offering.icon} />
            </Stack.Item>
            <Stack.Item grow>
              {showProgress ? (
                <>
                  <Icon name={Boolean(offering.fulfilled) ? 'check' : 'circle'} />{' '}
                  {offering.name}: {offering.current}/{offering.required}
                </>
              ) : (
                <>
                  {offering.required}× {offering.name}
                </>
              )}
            </Stack.Item>
          </Stack>
        </Box>
      ))}
    </>
  );
};

export const SanctifiedTree = () => {
  const { act, data } = useBackend<Data>();
  const {
    rituals = [],
    active_ritual,
    wedding_active,
    integrity,
    max_integrity,
    integrity_bonus,
    slow_aura,
    heal_aura,
    soulbound_count,
    druidic_level_name,
  } = data;
  const [selectedRitualId, setSelectedRitualId] = useState<string | null>(
    null,
  );

  const selectedRitual =
    rituals.find((ritual) => ritual.id === selectedRitualId) || rituals[0];
  const ritualLocked = Boolean(active_ritual) || Boolean(wedding_active);

  return (
    <Window
      title="Ритуалы освящённого древа"
      width={940}
      height={700}
      theme="parchment"
    >
      <Window.Content scrollable>
        <Section title="Роща Древоотца">
          <Stack>
            <Stack.Item grow>
              <Box bold>
                Прочность: {integrity}/{max_integrity}
              </Box>
              <Box color="label">Бонус леса: +{integrity_bonus}</Box>
            </Stack.Item>
            <Stack.Item grow>
              <Box bold>Druidic Trickery: {druidic_level_name}</Box>
              <Box color="label">
                Обереги: {Boolean(slow_aura) ? 'Оплот' : 'Нет'} ·{' '}
                {Boolean(heal_aura) ? 'Живой свет' : 'Нет лечебной ауры'}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Box bold>Связано душ: {soulbound_count}</Box>
            </Stack.Item>
          </Stack>
        </Section>

        {Boolean(wedding_active) ? (
          <Section title="Союз природы">
            <NoticeBox info>
              Обряд бракосочетания активен. Оба партнёра должны по одному разу
              укусить одно и то же яблоко, а затем принести его древу.
            </NoticeBox>
            <Button
              color="bad"
              icon="times"
              onClick={() => act('cancel_wedding')}
            >
              Отменить церемонию
            </Button>
          </Section>
        ) : null}

        {active_ritual ? (
          <Section title={`Активный ритуал: ${active_ritual.name}`}>
            <Box mb={1}>{active_ritual.description}</Box>
            <OfferingList ritual={active_ritual} showProgress />
            <Button
              mt={1}
              color="bad"
              icon="times"
              onClick={() => act('cancel_ritual')}
            >
              Отменить ритуал
            </Button>
          </Section>
        ) : null}

        <Section title="Ритуалы">
          <Stack>
            <Stack.Item grow={1}>
              {rituals.map((ritual) => {
                const selected = selectedRitual?.id === ritual.id;
                return (
                  <Box
                    key={ritual.id}
                    mb={1}
                    p={1}
                    style={{
                      border: `1px solid ${selected ? '#ffffff' : 'rgba(255,255,255,0.15)'}`,
                      borderRadius: '4px',
                      cursor: 'pointer',
                      opacity: Boolean(ritual.completed) ? 0.65 : 1,
                    }}
                    onClick={() => setSelectedRitualId(ritual.id)}
                  >
                    <Stack align="center">
                      <Stack.Item grow>
                        <Box bold>{ritual.name}</Box>
                        <Box
                          fontSize="0.9em"
                          color={Boolean(ritual.available) ? 'good' : 'label'}
                        >
                          {Boolean(ritual.completed)
                            ? 'Завершён'
                            : ritual.blocked_reason || 'Доступен'}
                        </Box>
                      </Stack.Item>
                      <Stack.Item>
                        <Box color="label">
                          {Boolean(ritual.repeatable)
                            ? 'Повторяемый'
                            : 'Один раз на древо'}
                        </Box>
                      </Stack.Item>
                    </Stack>
                  </Box>
                );
              })}
            </Stack.Item>

            <Stack.Item grow={1.4}>
              {selectedRitual ? (
                <>
                  <Section title={selectedRitual.name}>
                    <Box mb={1}>{selectedRitual.description}</Box>
                    <Box color="label">
                      Druidic Trickery: {selectedRitual.required_skill}
                    </Box>
                    <Box color="label">
                      Опыт Druidic Trickery: {selectedRitual.xp}
                    </Box>
                    <Box color="label">
                      Ограничение:{' '}
                      {Boolean(selectedRitual.repeatable)
                        ? 'Можно повторять'
                        : 'Один раз на освящённое древо'}
                    </Box>
                  </Section>

                  <Section title="Требуемые подношения">
                    <OfferingList ritual={selectedRitual} />
                  </Section>

                  {selectedRitual.blocked_reason ? (
                    <NoticeBox>{selectedRitual.blocked_reason}</NoticeBox>
                  ) : null}

                  <Button
                    fluid
                    color="good"
                    icon="leaf"
                    disabled={!Boolean(selectedRitual.available) || ritualLocked}
                    onClick={() =>
                      act('start_ritual', { ritual_id: selectedRitual.id })
                    }
                  >
                    Начать ритуал
                  </Button>
                </>
              ) : (
                <NoticeBox info>Нет доступных ритуалов.</NoticeBox>
              )}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
