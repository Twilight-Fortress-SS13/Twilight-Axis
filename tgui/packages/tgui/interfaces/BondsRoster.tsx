import { Box, Icon, NoticeBox, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Person = {
  name: string;
  job: string;
  self: number | boolean;
};

type Rank = {
  label: string;
  level: number;
  leader: number | boolean;
  people: Person[];
  vacant: string[];
};

type Block = {
  id: string;
  name: string;
  accent: string;
  icon: string;
  ranks: Rank[];
  total: number;
  warmth?: number;
  label?: string;
  labelAccent?: string;
};

type Data = {
  own: Block | null;
  ally: Block | null;
  allyWarmth: number;
  leaders: Block[];
};

function SlotCard(props: { accent: string; person?: Person; title?: string }) {
  const { accent, person, title } = props;

  if (!person) {
    return (
      <Box
        style={{
          background: 'rgba(16, 15, 14, 0.6)',
          border: '1px dashed #3a3630',
          borderRadius: '3px',
          minWidth: '9rem',
          padding: '4px 8px',
        }}
      >
        <Box opacity={0.3} italic>
          <Icon name="user-slash" mr={1} />
          свободно
        </Box>
        <Box opacity={0.35}>{title}</Box>
      </Box>
    );
  }

  return (
    <Box
      style={{
        background: 'rgba(28, 26, 20, 0.9)',
        border: `1px solid ${accent}`,
        borderRadius: '3px',
        minWidth: '9rem',
        padding: '4px 8px',
      }}
    >
      <Box bold color={person.self ? accent : undefined}>
        {person.name}
        {!!person.self && (
          <Box inline ml={1} color={accent}>
            <Icon name="location-dot" />
          </Box>
        )}
      </Box>
      <Box opacity={0.55}>{person.job}</Box>
    </Box>
  );
}

function Tier(props: { rank: Rank; accent: string; last: boolean }) {
  const { rank, accent, last } = props;
  const leader = !!rank.leader;

  return (
    <Box
      style={{ alignItems: 'center', display: 'flex', flexDirection: 'column' }}
    >
      <Box
        style={{
          color: leader ? accent : '#8a8378',
          fontSize: leader ? '13px' : '11px',
          fontWeight: leader ? 'bold' : 'normal',
          letterSpacing: '0.06em',
          marginBottom: '4px',
          textTransform: 'uppercase',
        }}
      >
        {leader && <Icon name="chess-king" mr={1} />}
        {rank.label}
      </Box>
      <Box
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          gap: '6px',
          justifyContent: 'center',
        }}
      >
        {rank.people.map((person, index) => (
          <SlotCard key={`p${index}`} accent={accent} person={person} />
        ))}
        {rank.vacant.map((title, index) => (
          <SlotCard key={`v${index}`} accent={accent} title={title} />
        ))}
        {!rank.people.length && !rank.vacant.length && (
          <Box opacity={0.3} italic>
            нет мест
          </Box>
        )}
      </Box>
      {!last && (
        <Box
          style={{
            background: '#3a3630',
            height: '14px',
            margin: '6px 0',
            width: '1px',
          }}
        />
      )}
    </Box>
  );
}

function OrgChart(props: { block: Block }) {
  const { block } = props;

  return (
    <Section
      title={
        <Box inline color={block.accent} bold>
          <Icon name={block.icon} mr={1} />
          {block.name}
        </Box>
      }
      buttons={<Box opacity={0.5}>на месте: {block.total}</Box>}
    >
      {!block.ranks.length && (
        <Box opacity={0.6}>Об этой фракции ничего не известно.</Box>
      )}
      {block.ranks.map((rank, index) => (
        <Tier
          key={index}
          rank={rank}
          accent={block.accent}
          last={index === block.ranks.length - 1}
        />
      ))}
    </Section>
  );
}

function LeaderRow(props: { block: Block }) {
  const { block } = props;

  return (
    <Box mb={1}>
      <Box>
        <Box inline bold color={block.accent}>
          <Icon name={block.icon} mr={1} />
          {block.name}
        </Box>
        {!!block.label && (
          <Box inline ml={1} bold color={block.labelAccent}>
            {block.label}
          </Box>
        )}
        <Box inline ml={1} opacity={0.45}>
          на месте {block.total}
        </Box>
      </Box>
      {!block.ranks.length && (
        <Box ml={2} opacity={0.4} italic>
          никого из старших нет
        </Box>
      )}
      {block.ranks.map((rank, index) => (
        <Box key={index} ml={2}>
          <Box inline opacity={0.6}>
            {rank.label}:
          </Box>
          {!rank.people.length && (
            <Box inline ml={1} opacity={0.35} italic>
              место свободно
            </Box>
          )}
          {rank.people.map((person, i) => (
            <Box key={i} inline ml={1}>
              <Box inline bold={!!person.self}>
                {person.name}
              </Box>
              <Box inline ml={1} opacity={0.5}>
                {person.job}
              </Box>
            </Box>
          ))}
        </Box>
      ))}
    </Box>
  );
}

export const BondsRoster = () => {
  const { data } = useBackend<Data>();
  const { own, ally, allyWarmth = 0, leaders = [] } = data;

  return (
    <Window title="Лист фракции" width={700} height={760}>
      <Window.Content scrollable style={{ backgroundImage: 'none' }}>
        <Stack vertical fill>
          {!own && (
            <Stack.Item>
              <NoticeBox>
                Вы ни к кому не приписаны, но кто здесь распоряжается — видно
                ниже.
              </NoticeBox>
            </Stack.Item>
          )}
          {!!own && (
            <Stack.Item>
              <OrgChart block={own} />
            </Stack.Item>
          )}
          {!!ally && (
            <Stack.Item>
              <Section
                title={
                  <Box inline color={ally.accent} bold>
                    <Icon name={ally.icon} mr={1} />
                    {ally.name}
                  </Box>
                }
                buttons={
                  <Box opacity={0.5}>союзники · расположение {allyWarmth}</Box>
                }
              >
                <LeaderRow block={ally} />
              </Section>
            </Stack.Item>
          )}
          {!!leaders.length && (
            <Stack.Item>
              <Section title="Кто распоряжается в прочих">
                {leaders.map((block) => (
                  <LeaderRow key={block.id} block={block} />
                ))}
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
