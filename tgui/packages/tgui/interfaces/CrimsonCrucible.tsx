import type { ReactNode } from 'react';
import {
  Box,
  Button,
  Divider,
  Icon,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { suspendStart } from '../events/handlers/suspense';
import { Window } from '../layouts';
import { useWindowExpand } from './common/useWindowExpand';

type Contributor = {
  name: string;
  amount: number;
};

type ProjectInfo = {
  type: string;
  name: string;
  description: string;
  mechanics: string;
  category: string;
  cost: number;
};

type PersonalServant = {
  name: string;
  description: string;
  mechanics: string;
  cost: number;
};

type ActiveProject = {
  type: string;
  paid: number;
  fromCup: number;
  maxContribution: number;
  lockedReason: string | null;
  contributors: Contributor[];
};

type AvailableProject = {
  type: string;
  lockedReason: string | null;
};

type Data = {
  projects: ProjectInfo[];
  personalServant: PersonalServant;
  ascensionTotal: number;
  capacityPerAscension: number;
  vitaeReserve: number;
  minDonation: number;
  donationVitae: number;
  donationBlood: number;
  bloodNormal: number;
  cup: number;
  cupCapacity: number;
  isVampire: BooleanLike;
  vitae: number;
  maxVitae: number;
  blood: number;
  maxGive: number;
  isLord: BooleanLike;
  maxPour: number;
  summoning: string | null;
  ascensions: number;
  sunStolen: BooleanLike;
  sunRiteDone: BooleanLike;
  activeProjects: ActiveProject[];
  availableProjects: AvailableProject[];
  hasPersonalCall: BooleanLike;
  personalCallLock: string | null;
};

const WINDOW_WIDTH = 1680;
const WINDOW_HEIGHT = 920;

const shellStyle = {
  background:
    'linear-gradient(180deg, rgba(24, 3, 5, 0.95), rgba(8, 7, 7, 0.98))',
  display: 'grid',
  gap: '8px',
  gridTemplateRows: '136px minmax(0, 1fr)',
  height: '100%',
  minHeight: 0,
};

const frameStyle = {
  background:
    'linear-gradient(135deg, rgba(45, 5, 8, 0.95), rgba(12, 10, 10, 0.96))',
  border: '1px solid #5b1b1f',
  borderRadius: '6px',
  boxShadow: 'inset 0 0 18px rgba(0, 0, 0, 0.55)',
};

const headerGridStyle = {
  ...frameStyle,
  alignItems: 'center',
  display: 'grid',
  gap: '16px',
  gridTemplateColumns: '210px minmax(320px, 1fr) minmax(280px, 420px)',
  padding: '14px',
};

const sealControlStyle = {
  alignItems: 'center',
  display: 'grid',
  gap: '10px',
  gridTemplateColumns: '64px minmax(118px, 1fr)',
};

const windowControlStackStyle = {
  display: 'grid',
  gap: '6px',
};

const windowControlButtonStyle = {
  border: '1px solid rgba(232, 208, 160, 0.5)',
  boxShadow: '0 0 10px rgba(216, 32, 52, 0.2)',
  fontWeight: 700,
};

const contentGridStyle = {
  display: 'grid',
  gap: '8px',
  gridTemplateColumns: 'repeat(3, minmax(0, 1fr))',
  height: '100%',
  minHeight: 0,
};

const parchmentStyle = {
  background: 'linear-gradient(180deg, #c9b98d, #a99461)',
  border: '1px solid #1f1614',
  borderRadius: '6px',
  color: '#17110f',
  boxShadow: 'inset 0 0 12px rgba(255, 246, 190, 0.22)',
  minWidth: 0,
  padding: '10px',
};

const lockedParchmentStyle = {
  ...parchmentStyle,
  opacity: 0.6,
};

const sealStyle = {
  width: '52px',
  height: '52px',
  borderRadius: '6px',
  border: '1px solid #572126',
  background: 'radial-gradient(circle at 50% 35%, #611820, #18090b 74%)',
  color: '#d8c7a0',
  textAlign: 'center' as const,
  lineHeight: '52px',
  fontWeight: 700,
  fontSize: '21px',
  textShadow: '0 0 8px #d82034',
};

const labelStyle = {
  color: '#3a2723',
  fontSize: '11px',
  fontWeight: 700,
  textTransform: 'uppercase' as const,
};

const descriptionBlockStyle = {
  borderTop: '1px solid rgba(74, 52, 35, 0.35)',
  paddingTop: '7px',
};

const copyStyle = {
  color: '#2f211e',
  lineHeight: 1.35,
  overflowWrap: 'break-word' as const,
};

const mechanicsBlockStyle = {
  background:
    'linear-gradient(90deg, rgba(112, 64, 184, 0.2), rgba(112, 64, 184, 0.06))',
  borderLeft: '4px solid #7040b8',
  marginTop: '8px',
  padding: '7px 9px 7px 10px',
};

const mechanicsLabelStyle = {
  ...labelStyle,
  color: '#5b239b',
};

const mechanicsStyle = {
  color: '#7040b8',
  fontStyle: 'normal',
  fontWeight: 400,
  lineHeight: 1.35,
  overflowWrap: 'break-word' as const,
  whiteSpace: 'pre-line' as const,
};

const emptyStateStyle = {
  border: '1px dashed #5b1b1f',
  borderRadius: '6px',
  background: 'rgba(24, 6, 7, 0.45)',
};

const CATEGORY_ICONS: Record<string, string> = {
  summoning: 'hand-sparkles',
  ascension: 'crown',
  sun: 'sun',
};

const formatVitae = (value: number) =>
  Math.round(value || 0).toLocaleString('ru-RU');

const getPourTooltip = (data: Data) => {
  const { maxPour = 0, cup = 0, cupCapacity = 0, vitaeReserve = 0 } = data;
  if (maxPour >= 1) {
    return `Могу влить до ${formatVitae(maxPour)} витэ`;
  }
  if (cup >= cupCapacity) {
    return 'Чаша полна';
  }
  return `Последние ${formatVitae(vitaeReserve)} витэ останутся со мной`;
};

const getGiveTooltip = (data: Data) => {
  const {
    maxGive = 0,
    cup = 0,
    cupCapacity = 0,
    minDonation = 0,
    donationVitae = 0,
    donationBlood = 0,
  } = data;
  if (maxGive > 0) {
    const bloodCost = donationVitae
      ? Math.ceil((maxGive * donationBlood) / donationVitae)
      : 0;
    return `Могу отдать до ${formatVitae(maxGive)} витэ ценой ${formatVitae(bloodCost)} крови`;
  }
  if (cupCapacity - cup < minDonation) {
    return 'Чаша полна';
  }
  return `Тигель берёт не меньше ${formatVitae(minDonation)} витэ`;
};

const getContributeTooltip = (project: ActiveProject) => {
  if (project.lockedReason) {
    return project.lockedReason;
  }
  if (project.maxContribution < 1) {
    return 'Мне нечего отдать этому ритуалу';
  }
  return `Могу направить до ${formatVitae(project.maxContribution)} витэ, сперва из чаши`;
};

const Seal = (props: { icon: string }) => (
  <Box style={sealStyle}>
    <Icon name={props.icon} />
  </Box>
);

const EmptyState = (props: { text: string }) => (
  <Box italic textAlign="center" color="#b99b7c" p={2} style={emptyStateStyle}>
    {props.text}
  </Box>
);

const Meter = (props: { label: string; value: number; max: number }) => {
  const { label, value, max } = props;

  return (
    <Box mb={0.5}>
      <ProgressBar value={value} maxValue={Math.max(max, 1)} color="red">
        {`${label}: ${formatVitae(value)} / ${formatVitae(max)}`}
      </ProgressBar>
    </Box>
  );
};

const RiteCopy = (props: { description: string; mechanics: string }) => {
  const { description, mechanics } = props;

  return (
    <Box mt={0.7}>
      <Box style={descriptionBlockStyle}>
        <Box style={labelStyle}>Описание</Box>
        <Box mt={0.2} style={copyStyle}>
          {description}
        </Box>
      </Box>
      {!!mechanics && (
        <Box style={mechanicsBlockStyle}>
          <Box style={mechanicsLabelStyle}>Эффект</Box>
          <Box mt={0.2} style={mechanicsStyle}>
            {mechanics}
          </Box>
        </Box>
      )}
    </Box>
  );
};

const RiteCard = (props: {
  icon: string;
  name: string;
  description: string;
  mechanics: string;
  locked: boolean;
  buttons?: ReactNode;
  children?: ReactNode;
}) => {
  const { icon, name, description, mechanics, locked, buttons, children } =
    props;

  return (
    <Box mb={1} style={locked ? lockedParchmentStyle : parchmentStyle}>
      <Stack align="center">
        <Stack.Item>
          <Seal icon={icon} />
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box bold fontSize={1.08}>
            {name}
          </Box>
        </Stack.Item>
        {!!buttons && <Stack.Item width="118px">{buttons}</Stack.Item>}
      </Stack>
      <RiteCopy description={description} mechanics={mechanics} />
      {children}
    </Box>
  );
};

const ActiveRite = (props: { project: ActiveProject; info: ProjectInfo }) => {
  const { project, info } = props;
  const { act, data } = useBackend<Data>();
  const canContribute = !project.lockedReason && project.maxContribution >= 1;
  const contributors = project.contributors
    .map((entry) => `${entry.name} (${formatVitae(entry.amount)})`)
    .join(', ');

  return (
    <RiteCard
      icon={CATEGORY_ICONS[info.category]}
      name={info.name}
      description={info.description}
      mechanics={info.mechanics}
      locked={!!project.lockedReason}
      buttons={
        !!data.isLord && (
          <>
            <Button
              fluid
              color="red"
              disabled={!canContribute}
              tooltip={getContributeTooltip(project)}
              onClick={() => act('feed_rite', { type: project.type })}
            >
              Направить
            </Button>
            <Button
              fluid
              color="bad"
              mt={0.5}
              onClick={() => act('cancel_rite', { type: project.type })}
            >
              Отменить
            </Button>
          </>
        )
      }
    >
      <Divider />
      <ProgressBar
        value={project.paid}
        maxValue={Math.max(info.cost, 1)}
        color="red"
      >
        {`${formatVitae(project.paid)} / ${formatVitae(info.cost)}`}
      </ProgressBar>
      <Box color="#563f37" mt={0.5}>
        {`Осталось: ${formatVitae(Math.max(info.cost - project.paid, 0))} витэ. Из чаши: ${formatVitae(project.fromCup)}.`}
      </Box>
      <Box color="#563f37" mt={0.3} fontSize={0.9}>
        {`Отдали свою кровь: ${contributors || 'пока никто'}`}
      </Box>
    </RiteCard>
  );
};

const AvailableRite = (props: {
  icon: string;
  name: string;
  description: string;
  mechanics: string;
  cost: number;
  lockedReason: string | null;
  onBegin: () => void;
}) => {
  const { icon, name, description, mechanics, cost, lockedReason, onBegin } =
    props;

  return (
    <RiteCard
      icon={icon}
      name={name}
      description={description}
      mechanics={mechanics}
      locked={!!lockedReason}
      buttons={
        <Button
          fluid
          color="red"
          disabled={!!lockedReason}
          tooltip={lockedReason || `Начать за ${formatVitae(cost)} витэ`}
          onClick={onBegin}
        >
          Начать
        </Button>
      }
    >
      <Box color="#563f37" mt={0.6}>
        {`Цена: ${formatVitae(cost)} витэ`}
      </Box>
    </RiteCard>
  );
};

const PersonalCall = () => {
  const { act, data } = useBackend<Data>();
  const { personalServant, personalCallLock } = data;

  return (
    <AvailableRite
      icon="user-plus"
      name={personalServant.name}
      description={personalServant.description}
      mechanics={personalServant.mechanics}
      cost={personalServant.cost}
      lockedReason={personalCallLock}
      onBegin={() => act('call_servant')}
    />
  );
};

const RiteColumn = (props: {
  category: string;
  title: string;
  status?: ReactNode;
  header?: ReactNode;
  footer?: ReactNode;
  emptyText: string;
}) => {
  const { category, title, status, header, footer, emptyText } = props;
  const { act, data } = useBackend<Data>();
  const { projects = [], activeProjects = [], availableProjects = [] } = data;
  const infoByType = new Map(
    projects
      .filter((info) => info.category === category)
      .map((info) => [info.type, info]),
  );
  const active = activeProjects.filter((entry) => infoByType.has(entry.type));
  const available = availableProjects.filter((entry) =>
    infoByType.has(entry.type),
  );
  const isEmpty = !active.length && !available.length && !footer;

  return (
    <Section title={title} buttons={status} fill scrollable>
      {header}
      {active.map((project) => (
        <ActiveRite
          key={project.type}
          project={project}
          info={infoByType.get(project.type) as ProjectInfo}
        />
      ))}
      {available.map((project) => {
        const info = infoByType.get(project.type) as ProjectInfo;
        return (
          <AvailableRite
            key={project.type}
            icon={CATEGORY_ICONS[category]}
            name={info.name}
            description={info.description}
            mechanics={info.mechanics}
            cost={info.cost}
            lockedReason={project.lockedReason}
            onBegin={() => act('begin_rite', { type: project.type })}
          />
        );
      })}
      {footer}
      {isEmpty && <EmptyState text={emptyText} />}
    </Section>
  );
};

const SummoningColumn = () => {
  const { data } = useBackend<Data>();
  const { summoning, isLord, hasPersonalCall } = data;

  return (
    <RiteColumn
      category="summoning"
      title="Обряды призыва"
      status={
        !!summoning && (
          <Box inline nowrap color="average">
            <Icon name="hourglass-half" mr={0.5} />
            {`Тигель зовёт: ${summoning}`}
          </Box>
        )
      }
      footer={!!hasPersonalCall && <PersonalCall />}
      emptyText={
        isLord
          ? 'Доступных обрядов призыва нет.'
          : 'Ни один обряд призыва не начат.'
      }
    />
  );
};

const AscensionColumn = () => {
  const { data } = useBackend<Data>();
  const {
    ascensions = 0,
    ascensionTotal = 0,
    capacityPerAscension = 0,
    isLord,
  } = data;

  let emptyText = 'Ни один обряд возвышения не начат.';
  if (ascensionTotal > 0 && ascensions >= ascensionTotal) {
    emptyText = 'Владыка цел. Обрядов возвышения не осталось.';
  } else if (ascensionTotal > 0 && ascensions === ascensionTotal - 1) {
    emptyText = 'Остался последний обряд. Он погасит Солнце.';
  } else if (isLord) {
    emptyText = 'Доступных обрядов возвышения нет.';
  }

  return (
    <RiteColumn
      category="ascension"
      title="Обряды возвышения"
      header={
        <Box mb={1}>
          <ProgressBar
            value={ascensions}
            maxValue={Math.max(ascensionTotal, 1)}
            color="red"
          >
            {`Исполнено обрядов: ${ascensions} / ${ascensionTotal}`}
          </ProgressBar>
          <Box mt={0.5} italic color="#c7a97a">
            {`Каждый исполненный обряд расширяет чашу на ${formatVitae(capacityPerAscension)} витэ.`}
          </Box>
        </Box>
      }
      emptyText={emptyText}
    />
  );
};

const SunColumn = () => {
  const { data } = useBackend<Data>();
  const { sunStolen, sunRiteDone } = data;

  let sunText =
    'Солнце всё ещё правит небом. Его погасит последний обряд возвышения.';
  if (sunStolen) {
    sunText = 'Солнце сорвано с небес. Оно вернётся, лишь когда падёт его вор.';
  } else if (sunRiteDone) {
    sunText = 'Солнце вернулось. Дважды его не украсть.';
  }

  return <RiteColumn category="sun" title="Солнце" emptyText={sunText} />;
};

const MortalCrucible = () => {
  const { act, data } = useBackend<Data>();
  const {
    blood = 0,
    bloodNormal = 0,
    vitae = 0,
    maxVitae = 0,
    cup = 0,
    cupCapacity = 0,
    maxGive = 0,
    donationVitae = 0,
    donationBlood = 0,
  } = data;

  return (
    <Window width={520} height={270} theme="dark">
      <Window.Content fitted>
        <Box p={1} height="100%">
          <Box p={1.5} height="100%" style={frameStyle}>
            <Box bold fontSize={1.4} color="#e0c090" textAlign="center" mb={1}>
              БАГРОВЫЙ ТИГЕЛЬ
            </Box>
            <Meter label="Моя кровь" value={blood} max={bloodNormal} />
            <Meter label="Моя витэ" value={vitae} max={maxVitae} />
            <Meter label="Витэ в чаше" value={cup} max={cupCapacity} />
            <Button
              fluid
              color="red"
              mt={1}
              textAlign="center"
              disabled={maxGive <= 0}
              tooltip={getGiveTooltip(data)}
              onClick={() => act('give_blood')}
            >
              Пожертвовать кровь
            </Button>
            <Box mt={1} italic color="#c7a97a">
              {`Тигель принимает кровь в чашу: каждые ${formatVitae(donationVitae)} витэ стоят ${formatVitae(donationBlood)} крови. Обратить эту витэ на ритуалы могут только Мафусаилы.`}
            </Box>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};

const KindredCrucible = () => {
  const { act, data } = useBackend<Data>();
  const [expanded, toggleExpanded] = useWindowExpand(
    WINDOW_WIDTH,
    WINDOW_HEIGHT,
  );
  const {
    vitae = 0,
    maxVitae = 0,
    cup = 0,
    cupCapacity = 0,
    maxPour = 0,
    isLord,
  } = data;

  return (
    <Window width={WINDOW_WIDTH} height={WINDOW_HEIGHT} theme="dark">
      <Window.Content fitted>
        <Box p={1} style={shellStyle}>
          <Box style={headerGridStyle}>
            <Box style={sealControlStyle}>
              <Box style={sealStyle}>V</Box>
              <Box style={windowControlStackStyle}>
                <Button
                  fluid
                  color="gold"
                  icon={expanded ? 'compress' : 'expand'}
                  tooltip={
                    expanded
                      ? 'Восстановить размер окна'
                      : 'Развернуть окно на весь экран'
                  }
                  tooltipPosition="right"
                  onClick={toggleExpanded}
                  style={windowControlButtonStyle}
                >
                  {expanded ? 'Свернуть' : 'Развернуть'}
                </Button>
                <Button
                  fluid
                  color="red"
                  icon="times"
                  tooltip="Закрыть окно"
                  tooltipPosition="right"
                  onClick={() => suspendStart()}
                  style={windowControlButtonStyle}
                >
                  Закрыть
                </Button>
              </Box>
            </Box>
            <Box>
              <Box bold fontSize={1.65} color="#e0c090" textAlign="center">
                БАГРОВЫЙ ТИГЕЛЬ
              </Box>
              <Box color="#c8878d" textAlign="center" mt={0.3}>
                {isLord
                  ? 'Воля Мафусаила: я начинаю ритуалы и направляю в них чашу'
                  : 'Каинит: я наполняю чашу, а ритуалами правит Мафусаил'}
              </Box>
            </Box>
            <Box>
              <Meter label="Моя витэ" value={vitae} max={maxVitae} />
              <Meter label="Витэ в чаше" value={cup} max={cupCapacity} />
              <Button
                fluid
                color="red"
                textAlign="center"
                disabled={maxPour < 1}
                tooltip={getPourTooltip(data)}
                onClick={() => act('pour_vitae')}
              >
                Влить витэ
              </Button>
            </Box>
          </Box>
          <Box style={contentGridStyle}>
            <SummoningColumn />
            <AscensionColumn />
            <SunColumn />
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};

export const CrimsonCrucible = () => {
  const { data } = useBackend<Data>();
  return data.isVampire ? <KindredCrucible /> : <MortalCrucible />;
};
