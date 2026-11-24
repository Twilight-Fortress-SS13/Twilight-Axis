import { type ReactNode, useState } from 'react';
import { Box, Button, Icon, Input, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { useWindowExpand } from './common/useWindowExpand';

type Power = {
  name: string;
  desc: string;
  level: number;
  vitaeCost: number;
};

type Coven = {
  id: string;
  name: string;
  desc: string;
  powers: Power[];
};

type Trait = {
  name: string;
  desc: string;
};

type Clan = {
  id: string;
  name: string;
  tagline: string;
  desc: string;
  curse: string;
  downside: string;
  bloodPreference: string;
  isCustom: BooleanLike;
  covensToSelect: number;
  covenIds: string[];
  clanTraits: Trait[];
  lordTitle: string;
  lordForms: Trait[];
  lordTraits: Trait[];
  vitaeBonus: number;
};

type Data = {
  clans: Clan[];
  covens: Coven[];
  defaultClanId: string;
  maxNameLength: number;
};

const WINDOW_WIDTH = 1100;
const WINDOW_HEIGHT = 760;

const capFirst = (text: string) =>
  text ? text.charAt(0).toUpperCase() + text.slice(1) : '';

const isCoven = (coven: Coven | undefined): coven is Coven => !!coven;

const getDisciplineChoice = (count: number) =>
  count > 0
    ? `Каитифф сам изберёт дисциплины, доступно: ${count}.`
    : 'Кровь этого поколения слишком жидка для собственных дисциплин.';

const InfoBlock = (props: {
  title: string;
  icon: string;
  children: ReactNode;
}) => (
  <Box className="VampireClanSelection__infoBlock">
    <Box className="VampireClanSelection__infoTitle">
      <Icon name={props.icon} className="VampireClanSelection__infoIcon" />
      {props.title}
    </Box>
    {props.children}
  </Box>
);

const InfoText = (props: { text: string }) => (
  <Box className="VampireClanSelection__infoText">{capFirst(props.text)}</Box>
);

const TraitRow = (props: { trait: Trait }) => (
  <Box className="VampireClanSelection__traitRow">
    <Box className="VampireClanSelection__traitName">{props.trait.name}</Box>
    <Box className="VampireClanSelection__traitDesc">{props.trait.desc}</Box>
  </Box>
);

const LordBlock = (props: { clan: Clan }) => {
  const { clan } = props;

  return (
    <InfoBlock title="Владыка клана" icon="crown">
      <Box className="VampireClanSelection__lordTitleLine">
        Титул: <b>{clan.lordTitle}</b>
        {clan.vitaeBonus > 0 && `; запас витэ: +${clan.vitaeBonus}`}.
      </Box>
      {clan.lordForms.map((form) => (
        <Box key={form.name} className="VampireClanSelection__lordFormCard">
          <Box className="VampireClanSelection__lordFormTitle">
            <Icon name="dragon" className="VampireClanSelection__formIcon" />
            {form.name}
          </Box>
          <Box className="VampireClanSelection__lordFormDesc">{form.desc}</Box>
        </Box>
      ))}
      {clan.lordTraits.length > 0 && (
        <Box className="VampireClanSelection__traitList">
          <Box className="VampireClanSelection__traitListLabel">
            Дары владыки
          </Box>
          {clan.lordTraits.map((trait) => (
            <TraitRow key={trait.name} trait={trait} />
          ))}
        </Box>
      )}
    </InfoBlock>
  );
};

const CovenCard = (props: { coven: Coven }) => {
  const { coven } = props;
  const [expanded, setExpanded] = useState(false);

  return (
    <Box className="VampireClanSelection__covenCard">
      <Button
        fluid
        className="VampireClanSelection__covenHeader"
        onClick={() => setExpanded(!expanded)}
      >
        <Stack align="center">
          <Stack.Item>
            <Box className="VampireClanSelection__covenChevron">
              <Icon name={expanded ? 'chevron-down' : 'chevron-right'} />
            </Box>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <Box className="VampireClanSelection__covenName">{coven.name}</Box>
            <Box
              className="VampireClanSelection__covenDesc"
              style={{ whiteSpace: 'normal' }}
            >
              {capFirst(coven.desc)}
            </Box>
          </Stack.Item>
        </Stack>
      </Button>
      {expanded && (
        <Box className="VampireClanSelection__powerList">
          {coven.powers.map((power) => (
            <Box
              key={`${power.level}-${power.name}`}
              className="VampireClanSelection__powerItem"
            >
              <Box className="VampireClanSelection__powerLevel">
                {power.level}
              </Box>
              <Box className="VampireClanSelection__powerBody">
                <Box className="VampireClanSelection__powerName">
                  {power.name}
                </Box>
                <Box className="VampireClanSelection__powerDesc">
                  {capFirst(power.desc)}
                </Box>
                <Box className="VampireClanSelection__covenDesc">
                  {power.vitaeCost} витэ
                </Box>
              </Box>
            </Box>
          ))}
          {!coven.powers.length && (
            <InfoText text="Сведения о силах отсутствуют." />
          )}
        </Box>
      )}
    </Box>
  );
};

const ClanCard = (props: {
  clan: Clan;
  index: number;
  selected: boolean;
  onSelect: () => void;
}) => {
  const { clan, index, selected, onSelect } = props;

  return (
    <Button
      fluid
      className={
        selected
          ? 'VampireClanSelection__clanCard VampireClanSelection__clanCard--selected'
          : 'VampireClanSelection__clanCard'
      }
      onClick={onSelect}
    >
      <Stack align="center">
        <Stack.Item>
          <Box className="VampireClanSelection__number">{index + 1}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box
            className={
              clan.isCustom
                ? 'VampireClanSelection__cardSigil VampireClanSelection__cardSigil--custom'
                : 'VampireClanSelection__cardSigil'
            }
          >
            <Icon name={clan.isCustom ? 'question' : 'gem'} />
          </Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box className="VampireClanSelection__clanName">{clan.name}</Box>
          <Box
            className="VampireClanSelection__tagline"
            style={{ whiteSpace: 'normal' }}
          >
            {clan.tagline}
          </Box>
        </Stack.Item>
      </Stack>
    </Button>
  );
};

const ClanDetails = (props: {
  clan: Clan;
  covens: Coven[];
  customName: string;
  maxNameLength: number;
  onCustomNameChange: (value: string) => void;
}) => {
  const { clan, covens, customName, maxNameLength, onCustomNameChange } = props;
  const clanCovens = clan.covenIds
    .map((covenId) => covens.find((coven) => coven.id === covenId))
    .filter(isCoven);

  return (
    <Box className="VampireClanSelection__details">
      <Box className="VampireClanSelection__selectedName">{clan.name}</Box>
      <Box className="VampireClanSelection__divider" />

      {!!clan.isCustom && (
        <InfoBlock title="Имя клана" icon="pen">
          <Input
            fluid
            className="VampireClanSelection__customNameInput"
            placeholder="Нареки свою линию крови..."
            value={customName}
            onChange={onCustomNameChange}
            maxLength={maxNameLength}
          />
          <Box className="VampireClanSelection__infoText" mt={0.5}>
            Оставь поле пустым, и клан будет именоваться «Пользовательский
            клан».
          </Box>
        </InfoBlock>
      )}

      <InfoBlock title="Описание" icon="book">
        <InfoText text={clan.desc} />
      </InfoBlock>
      <InfoBlock title="Проклятие и изъян" icon="skull">
        <InfoText text={clan.curse} />
        <InfoText text={clan.downside} />
      </InfoBlock>
      <InfoBlock title="Предпочитаемая кровь" icon="tint">
        <InfoText text={clan.bloodPreference} />
      </InfoBlock>

      <LordBlock clan={clan} />

      {clan.clanTraits.length > 0 && (
        <InfoBlock title="Особые черты клана" icon="star">
          <Box className="VampireClanSelection__traitList">
            {clan.clanTraits.map((trait) => (
              <TraitRow key={trait.name} trait={trait} />
            ))}
          </Box>
        </InfoBlock>
      )}

      <InfoBlock title="Дисциплины и силы" icon="fire">
        {clanCovens.map((coven) => (
          <CovenCard key={coven.id} coven={coven} />
        ))}
        {!clanCovens.length && (
          <InfoText
            text={
              clan.isCustom ? getDisciplineChoice(clan.covensToSelect) : 'Нет.'
            }
          />
        )}
      </InfoBlock>
    </Box>
  );
};

export const VampireClanSelection = () => {
  const { act, data } = useBackend<Data>();
  const { clans = [], covens = [], defaultClanId, maxNameLength } = data;
  const [selectedId, setSelectedId] = useState(defaultClanId);
  const [customName, setCustomName] = useState('');
  const [expanded, toggleExpanded] = useWindowExpand(
    WINDOW_WIDTH,
    WINDOW_HEIGHT,
  );
  const selected = clans.find((clan) => clan.id === selectedId) || clans[0];

  return (
    <Window width={WINDOW_WIDTH} height={WINDOW_HEIGHT} theme="generic">
      <Window.Content className="VampireClanSelection" fitted>
        <Box className="VampireClanSelection__shell">
          <Box className="VampireClanSelection__header">
            <Box className="VampireClanSelection__crest">
              <Box className="VampireClanSelection__crestInner">
                <Icon name="gem" />
              </Box>
            </Box>
            <Box className="VampireClanSelection__titleBlock">
              <Box className="VampireClanSelection__title">Выбор клана</Box>
              <Box className="VampireClanSelection__subtitle">
                Избери свой клан
              </Box>
            </Box>
            <Box className="VampireClanSelection__windowControls">
              <Button
                color="transparent"
                icon={expanded ? 'compress' : 'expand'}
                tooltip={
                  expanded ? 'Восстановить размер окна' : 'Развернуть окно'
                }
                tooltipPosition="left"
                onClick={toggleExpanded}
                className="VampireClanSelection__windowButton"
              >
                {expanded ? 'Восстановить' : 'Развернуть'}
              </Button>
            </Box>
            <Box className="VampireClanSelection__flavor">
              Кровь помнит.
              <br />
              Избери свою линию крови.
            </Box>
          </Box>

          <Box className="VampireClanSelection__body">
            <Box className="VampireClanSelection__leftPanel">
              <Section title="Доступные кланы" fill scrollable>
                <Stack vertical>
                  {clans.map((clan, index) => (
                    <Stack.Item key={clan.id}>
                      <ClanCard
                        clan={clan}
                        index={index}
                        selected={clan.id === selected?.id}
                        onSelect={() => setSelectedId(clan.id)}
                      />
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            </Box>

            <Box className="VampireClanSelection__rightPanel">
              <Section key={selected?.id} fill scrollable>
                {!!selected && (
                  <ClanDetails
                    clan={selected}
                    covens={covens}
                    customName={customName}
                    maxNameLength={maxNameLength}
                    onCustomNameChange={setCustomName}
                  />
                )}
              </Section>
            </Box>
          </Box>

          <Box className="VampireClanSelection__footer">
            <Box className="VampireClanSelection__warning">
              Выбор окончателен. Закрытое окно можно открыть снова значком на
              экране.
            </Box>
            <Stack align="center">
              <Stack.Item grow />
              <Stack.Item>
                <Button
                  color="red"
                  icon="check"
                  disabled={!selected}
                  onClick={() =>
                    act('confirm_clan', {
                      clan_id: selected?.id,
                      custom_name: customName,
                    })
                  }
                  className="VampireClanSelection__footerAccept"
                >
                  Избрать клан
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="transparent"
                  icon="times"
                  onClick={() => act('dismiss')}
                  className="VampireClanSelection__footerClose"
                >
                  Закрыть
                </Button>
              </Stack.Item>
            </Stack>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};
