import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type FactionEntry = {
  id: string;
  name: string;
  accent: string;
  clan: number | boolean;
};

type StanceEntry = {
  a: string;
  b: string;
  nameA: string;
  nameB: string;
  warmth: number;
  weight: number;
  label: string;
  labelAccent: string;
  history: number;
};

type HouseEntry = {
  nameA: string;
  nameB: string;
  warmth: number;
  weight: number;
  incidents: number;
  label: string;
  labelAccent: string;
};

type Person = {
  ref: string;
  name: string;
  job: string;
  faction: string;
  dead: number | boolean;
};

type BondEntry = {
  target: string;
  warmth: number;
  weight: number;
  warmthCommitted: number;
  weightCommitted: number;
  stage: string;
  accent: string;
  tags: number;
  history: number;
  active: number;
};

type KinEntry = {
  target: string;
  kind: string;
  adopted: number | boolean;
  house: string;
};

type PersonDump = {
  ref: string;
  name: string;
  job: string;
  jobType: string;
  faction: string;
  archetypes: number;
  influence: number;
  muted: number | boolean;
  bonds: BondEntry[];
  kin: KinEntry[];
};

type HouseCache = {
  ref: string;
  name: string;
  members: number;
  cached: number | boolean;
  revision: number;
  dirtyRelations: number | boolean;
  dirtyGenerations: number | boolean;
  dirtyDisplay: number | boolean;
  relationRows: number;
  displayTrees: number;
};

type Caches = {
  graph: Record<string, number>;
  seedFlavors: number;
  zoneLens: number;
  mapWeight: string;
  dreams: number;
  rulingGod: string;
  lensApplied: number | boolean;
  houses: HouseCache[];
};

type Data = {
  tab: string;
  factions: FactionEntry[];
  stances: StanceEntry[];
  houses: HouseEntry[];
  people: Person[];
  focus: PersonDump | null;
  partner: PersonDump | null;
  pair: { forward: BondEntry | null; backward: BondEntry | null; kin: string[] } | null;
  kinKinds: string[];
  caches: Caches;
  storyteller: string | null;
  mapName: string | null;
  warmthMin: number;
  warmthMax: number;
  weightMax: number;
};

const TAG_FLAGS: [number, string][] = [
  [1, 'Пролита кровь'],
  [2, 'Убил меня'],
  [4, 'Убит мной'],
  [8, 'Утешал'],
  [16, 'Служили вместе'],
  [32, 'Долг'],
];

const KIN_LABELS: Record<string, string> = {
  parent: 'Родитель',
  child: 'Ребёнок',
  spouse: 'Супруг',
  former_spouse: 'Бывший супруг',
  sworn_sibling: 'Названый брат',
};

function PersonPicker(props: {
  label: string;
  people: Person[];
  selected: PersonDump | null;
  action: string;
}) {
  const { act } = useBackend<Data>();
  const { label, people, selected, action } = props;
  const options = people.map((p) => `${p.name} — ${p.job}`);

  return (
    <Stack align="center">
      <Stack.Item width="5rem">{label}</Stack.Item>
      <Stack.Item grow>
        <Dropdown
          width="100%"
          placeholder="не выбран"
          selected={selected ? `${selected.name} — ${selected.job}` : ''}
          options={options}
          onSelected={(value) => {
            const index = options.indexOf(value);
            if (index >= 0) {
              act(action, { ref: people[index].ref });
            }
          }}
        />
      </Stack.Item>
      <Stack.Item>
        <Button icon="times" onClick={() => act(action, { ref: '' })} />
      </Stack.Item>
    </Stack>
  );
}

function BondRow(props: { bond: BondEntry }) {
  const { bond } = props;
  return (
    <Box>
      <Box inline bold>
        {bond.target}
      </Box>
      <Box inline ml={1} bold color={bond.accent}>
        {bond.stage}
      </Box>
      <Box inline ml={1} opacity={0.55}>
        w {bond.warmth} (пост. {bond.warmthCommitted}) / p {bond.weight} (пост.{' '}
        {bond.weightCommitted}) / история {bond.history} / активных {bond.active}
      </Box>
    </Box>
  );
}

function BondEditor(props: {
  title: string;
  from: string;
  to: string;
  bond: BondEntry | null;
  warmthMin: number;
  warmthMax: number;
  weightMax: number;
}) {
  const { act } = useBackend<Data>();
  const { title, from, to, bond, warmthMin, warmthMax, weightMax } = props;
  const [warmth, setWarmth] = useState(bond ? bond.warmthCommitted : 0);
  const [weight, setWeight] = useState(bond ? bond.weightCommitted : 0);

  return (
    <Section title={title}>
      {bond ? <BondRow bond={bond} /> : <Box opacity={0.6}>Связи пока нет.</Box>}
      <Stack mt={1} align="center">
        <Stack.Item>Тепло</Stack.Item>
        <Stack.Item>
          <NumberInput
            value={warmth}
            minValue={warmthMin}
            maxValue={warmthMax}
            step={5}
            width="4.5rem"
            onChange={setWarmth}
          />
        </Stack.Item>
        <Stack.Item>Вес</Stack.Item>
        <Stack.Item>
          <NumberInput
            value={weight}
            minValue={0}
            maxValue={weightMax}
            step={5}
            width="4.5rem"
            onChange={setWeight}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="check"
            content="Записать"
            onClick={() => act('set_bond', { from, to, warmth, weight })}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="trash"
            color="bad"
            content="Снести"
            disabled={!bond}
            onClick={() => act('drop_bond', { from, to })}
          />
        </Stack.Item>
      </Stack>
      {!!bond && (
        <Box mt={1}>
          {TAG_FLAGS.map(([flag, label]) => (
            <Button
              key={flag}
              selected={(bond.tags & flag) !== 0}
              content={label}
              onClick={() => act('toggle_tag', { from, to, tag: flag })}
            />
          ))}
        </Box>
      )}
    </Section>
  );
}

function FactionsTab() {
  const { act, data } = useBackend<Data>();
  const {
    stances = [],
    houses = [],
    warmthMin = -100,
    warmthMax = 100,
    weightMax = 100,
  } = data;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title={`Фракции (${stances.length} пар)`}>
          {!stances.length && (
            <Box opacity={0.6}>Пока нет ни одной установленной пары.</Box>
          )}
          {stances.map((stance, index) => (
            <StanceRow
              key={index}
              stance={stance}
              warmthMin={warmthMin}
              warmthMax={warmthMax}
              weightMax={weightMax}
            />
          ))}
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title={`Дома (${houses.length} пар)`}>
          {!houses.length && (
            <Box opacity={0.6}>Между домами пока ничего не накопилось.</Box>
          )}
          {houses.map((house, index) => (
            <Box key={index}>
              <Box inline>
                {house.nameA} — {house.nameB}
              </Box>
              <Box inline ml={1} bold color={house.labelAccent}>
                {house.label}
              </Box>
              <Box inline ml={1} opacity={0.5}>
                w {house.warmth} / p {house.weight} / случаев {house.incidents}
              </Box>
            </Box>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
}

function StanceRow(props: {
  stance: StanceEntry;
  warmthMin: number;
  warmthMax: number;
  weightMax: number;
}) {
  const { act } = useBackend<Data>();
  const { stance, warmthMin, warmthMax, weightMax } = props;
  const [warmth, setWarmth] = useState(stance.warmth);
  const [weight, setWeight] = useState(stance.weight);

  return (
    <Stack align="center" mb={0.5}>
      <Stack.Item grow>
        <Box>
          {stance.nameA} — {stance.nameB}
        </Box>
        <Box inline bold color={stance.labelAccent}>
          {stance.label}
        </Box>
        <Box inline ml={1} opacity={0.5}>
          w {stance.warmth} / p {stance.weight} / записей {stance.history}
        </Box>
      </Stack.Item>
      <Stack.Item>
        <NumberInput
          value={warmth}
          minValue={warmthMin}
          maxValue={warmthMax}
          step={5}
          width="4rem"
          onChange={setWarmth}
        />
      </Stack.Item>
      <Stack.Item>
        <NumberInput
          value={weight}
          minValue={0}
          maxValue={weightMax}
          step={5}
          width="4rem"
          onChange={setWeight}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="check"
          onClick={() =>
            act('set_stance', { a: stance.a, b: stance.b, warmth, weight })
          }
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="trash"
          color="bad"
          onClick={() => act('reset_stance', { a: stance.a, b: stance.b })}
        />
      </Stack.Item>
    </Stack>
  );
}

function PersonTab() {
  const { data } = useBackend<Data>();
  const { people = [], focus } = data;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section>
          <PersonPicker
            label="Персона"
            people={people}
            selected={focus}
            action="pick_person"
          />
        </Section>
      </Stack.Item>
      {!focus && (
        <Stack.Item>
          <NoticeBox>Выберите персону, чтобы увидеть её узел графа.</NoticeBox>
        </Stack.Item>
      )}
      {!!focus && (
        <>
          <Stack.Item>
            <Section title={focus.name}>
              <LabeledList>
                <LabeledList.Item label="Работа">
                  {focus.job} ({focus.jobType})
                </LabeledList.Item>
                <LabeledList.Item label="Фракция">
                  {focus.faction}
                </LabeledList.Item>
                <LabeledList.Item label="Архетипы">
                  {focus.archetypes}
                </LabeledList.Item>
                <LabeledList.Item label="Влияние">
                  {focus.influence} {focus.muted ? '(заглушен)' : ''}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title={`Связи (${focus.bonds.length})`}>
              {!focus.bonds.length && (
                <Box opacity={0.6}>Ни к кому ничего не испытывает.</Box>
              )}
              {focus.bonds.map((bond, index) => (
                <Box key={index} mb={0.5}>
                  <BondRow bond={bond} />
                </Box>
              ))}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title={`Родство (${focus.kin.length})`}>
              {!focus.kin.length && <Box opacity={0.6}>Родни нет.</Box>}
              {focus.kin.map((link, index) => (
                <Box key={index}>
                  <Box inline bold>
                    {KIN_LABELS[link.kind] || link.kind}
                  </Box>
                  <Box inline ml={1}>
                    {link.target}
                  </Box>
                  <Box inline ml={1} opacity={0.5}>
                    {link.adopted ? 'приёмный · ' : ''}
                    {link.house}
                  </Box>
                </Box>
              ))}
            </Section>
          </Stack.Item>
        </>
      )}
    </Stack>
  );
}

function RelationTab() {
  const { act, data } = useBackend<Data>();
  const {
    people = [],
    focus,
    partner,
    pair,
    kinKinds = [],
    warmthMin = -100,
    warmthMax = 100,
    weightMax = 100,
  } = data;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section>
          <PersonPicker
            label="Первый"
            people={people}
            selected={focus}
            action="pick_person"
          />
          <Box mt={0.5}>
            <PersonPicker
              label="Второй"
              people={people}
              selected={partner}
              action="pick_partner"
            />
          </Box>
          <Box mt={0.5}>
            <Button
              icon="exchange-alt"
              content="Поменять местами"
              onClick={() => act('swap_pair')}
            />
          </Box>
        </Section>
      </Stack.Item>
      {(!focus || !partner) && (
        <Stack.Item>
          <NoticeBox>Выберите обоих участников.</NoticeBox>
        </Stack.Item>
      )}
      {!!focus && !!partner && (
        <>
          <Stack.Item>
            <Section title="Родство">
              <Box opacity={0.6} mb={1}>
                Отношение {focus.name} к {partner.name}. Обратная сторона
                проставляется сама.
              </Box>
              {kinKinds.map((kind) => {
                const active = pair ? pair.kin.includes(kind) : false;
                return (
                  <Button
                    key={kind}
                    selected={active}
                    content={KIN_LABELS[kind] || kind}
                    onClick={() =>
                      act('set_kin', {
                        from: focus.ref,
                        to: partner.ref,
                        kind,
                        adding: active ? 0 : 1,
                      })
                    }
                  />
                );
              })}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <BondEditor
              title={`${focus.name} → ${partner.name}`}
              from={focus.ref}
              to={partner.ref}
              bond={pair ? pair.forward : null}
              warmthMin={warmthMin}
              warmthMax={warmthMax}
              weightMax={weightMax}
            />
          </Stack.Item>
          <Stack.Item>
            <BondEditor
              title={`${partner.name} → ${focus.name}`}
              from={partner.ref}
              to={focus.ref}
              bond={pair ? pair.backward : null}
              warmthMin={warmthMin}
              warmthMax={warmthMax}
              weightMax={weightMax}
            />
          </Stack.Item>
        </>
      )}
    </Stack>
  );
}

function CachesTab() {
  const { act, data } = useBackend<Data>();
  const { caches } = data;
  if (!caches) {
    return <NoticeBox>Нет данных.</NoticeBox>;
  }
  const graph = caches.graph || {};

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="Граф связей">
          <LabeledList>
            <LabeledList.Item label="Узлы">{graph.nodes}</LabeledList.Item>
            <LabeledList.Item label="Связи">{graph.bonds}</LabeledList.Item>
            <LabeledList.Item label="Родство">{graph.kin}</LabeledList.Item>
            <LabeledList.Item label="Записей истории">
              {graph.history}
            </LabeledList.Item>
            <LabeledList.Item label="Активных событий">
              {graph.active}
            </LabeledList.Item>
            <LabeledList.Item label="Пулы влияния">
              {graph.pools}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section
          title="Кеши поиска"
          buttons={
            <Button
              icon="broom"
              color="bad"
              content="Сбросить"
              onClick={() => act('flush_caches')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="Вкусы сидинга">
              {caches.seedFlavors}
            </LabeledList.Item>
            <LabeledList.Item label="Линзы зон">
              {caches.zoneLens}
            </LabeledList.Item>
            <LabeledList.Item label="Вес карты">
              {caches.mapWeight}
            </LabeledList.Item>
            <LabeledList.Item label="Снов в таблице">
              {caches.dreams}
            </LabeledList.Item>
            <LabeledList.Item label="Правящий бог">
              {caches.rulingGod}
            </LabeledList.Item>
            <LabeledList.Item label="Линза применена">
              {caches.lensApplied ? 'да' : 'нет'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title={`Кеши домов (${caches.houses.length})`}>
          {!caches.houses.length && <Box opacity={0.6}>Домов нет.</Box>}
          {caches.houses.map((house) => (
            <Stack key={house.ref} align="center" mb={0.5}>
              <Stack.Item grow>
                <Box bold>
                  {house.name}
                  <Box inline ml={1} opacity={0.5}>
                    участников {house.members}
                  </Box>
                </Box>
                <Box opacity={0.55}>
                  {house.cached
                    ? `ревизия ${house.revision} · строк ${house.relationRows} · деревьев ${house.displayTrees}`
                    : 'кеш не построен'}
                  {house.dirtyRelations ? ' · связи грязные' : ''}
                  {house.dirtyGenerations ? ' · поколения грязные' : ''}
                  {house.dirtyDisplay ? ' · отображение грязное' : ''}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="recycle"
                  content="Пометить"
                  onClick={() => act('house_cache', { ref: house.ref, drop: 0 })}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="trash"
                  color="bad"
                  content="Сбросить"
                  onClick={() => act('house_cache', { ref: house.ref, drop: 1 })}
                />
              </Stack.Item>
            </Stack>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
}

export const BondsAdmin = () => {
  const { act, data } = useBackend<Data>();
  const { tab = 'factions', storyteller, mapName } = data;

  return (
    <Window title="Bonds: инспектор связей" width={860} height={760}>
      <Window.Content scrollable>
        <NoticeBox info>
          Карта: {mapName || 'неизвестна'} · Правящий бог:{' '}
          {storyteller || 'не выбран'}
        </NoticeBox>
        <Tabs>
          <Tabs.Tab
            selected={tab === 'factions'}
            onClick={() => act('set_tab', { tab: 'factions' })}
          >
            Фракции
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'person'}
            onClick={() => act('set_tab', { tab: 'person' })}
          >
            Персона
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'relation'}
            onClick={() => act('set_tab', { tab: 'relation' })}
          >
            Связь
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'caches'}
            onClick={() => act('set_tab', { tab: 'caches' })}
          >
            Кеши
          </Tabs.Tab>
        </Tabs>
        {tab === 'factions' && <FactionsTab />}
        {tab === 'person' && <PersonTab />}
        {tab === 'relation' && <RelationTab />}
        {tab === 'caches' && <CachesTab />}
      </Window.Content>
    </Window>
  );
};
