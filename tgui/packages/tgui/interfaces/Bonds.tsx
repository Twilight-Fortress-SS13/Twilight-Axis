import { useState } from 'react';
import { Box, Button, NoticeBox, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type HistoryEntry = {
  label: string;
  story: string;
};

type BondEntry = {
  name: string;
  label: string;
  desc: string;
  accent: string;
  job: string;
  species: string;
  history: HistoryEntry[];
};

type BondGroup = {
  key: string;
  entries: BondEntry[];
};

type Data = {
  groups: BondGroup[];
};

const GROUP_TITLES: Record<string, string> = {
  family: 'Родня',
  warm: 'Близкие',
  hostile: 'Враги',
  cold: 'Напряжение',
  known: 'Знакомые',
};

const GROUP_ORDER = ['family', 'warm', 'hostile', 'cold', 'known'];

const groupRank = (key: string) => {
  const index = GROUP_ORDER.indexOf(key);
  return index === -1 ? GROUP_ORDER.length : index;
};

function BondCard(props: { entry: BondEntry }) {
  const { entry } = props;
  const [open, setOpen] = useState(false);
  const details = [entry.job, entry.species].filter(Boolean).join(' · ');
  const moments = entry.history.length;

  return (
    <Section>
      <Stack vertical>
        <Stack.Item>
          <Box inline bold color={entry.accent}>
            {entry.label}
          </Box>
          <Box inline ml={1} bold>
            {entry.name}
          </Box>
          {!!details && (
            <Box inline ml={1} opacity={0.6}>
              {details}
            </Box>
          )}
          {!!moments && (
            <Button
              compact
              ml={1}
              icon={open ? 'chevron-up' : 'chevron-down'}
              onClick={() => setOpen(!open)}
            >
              {open ? 'скрыть' : `вспомнить (${moments})`}
            </Button>
          )}
        </Stack.Item>
        {!!entry.desc && (
          <Stack.Item>
            <Box italic opacity={0.8}>
              {entry.desc}
            </Box>
          </Stack.Item>
        )}
        {!!open &&
          entry.history.map((moment, index) => (
            <Stack.Item key={index}>
              <Box opacity={0.5} inline>
                {moment.label}:
              </Box>
              <Box inline ml={1}>
                {moment.story}
              </Box>
            </Stack.Item>
          ))}
      </Stack>
    </Section>
  );
}

export const Bonds = () => {
  const { data } = useBackend<Data>();
  const { groups = [] } = data;
  const ordered = [...groups].sort(
    (a, b) => groupRank(a.key) - groupRank(b.key),
  );

  return (
    <Window title="Связи" width={720} height={620}>
      <Window.Content scrollable style={{ backgroundImage: 'none' }}>
        {!ordered.length && (
          <NoticeBox>Вы пока ни к кому ничего не испытываете.</NoticeBox>
        )}
        <Stack vertical fill>
          {ordered.map((group) => (
            <Stack.Item key={group.key}>
              <Section title={GROUP_TITLES[group.key] || group.key}>
                <Stack vertical>
                  {group.entries.map((entry, index) => (
                    <Stack.Item key={index}>
                      <BondCard entry={entry} />
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};
