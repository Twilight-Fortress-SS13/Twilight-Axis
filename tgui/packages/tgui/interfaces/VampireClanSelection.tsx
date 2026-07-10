import { useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type PowerData = {
  name: string;
  level: number;
  desc: string;
};

type CovenData = {
  name: string;
  desc: string;
  icon?: string;
  powers: PowerData[];
};

type TraitData = {
  name: string;
  desc: string;
};

type LordFormData = {
  name: string;
  desc: string;
};

type ClanData = {
  id: string;
  name: string;
  desc: string;
  curse: string;
  downside: string;
  bloodPreference: string;
  covens: CovenData[];
  icon?: string;
  tagline?: string;
  isCustom?: boolean | number;
  lordTitle: string;
  lordForm: LordFormData | null;
  lordTraits: TraitData[];
  clanTraits: TraitData[];
  vitaeBonus: number;
};

type VampireClanSelectionData = {
  clans: ClanData[];
  selectedClanId: string;
  pendingCustomName: string;
  defaultClanName: string;
  language?: string;
  i18nOverrides?: Record<string, string> | null;
};

const DEFAULT_W = 1100;
const DEFAULT_H = 760;

const capFirst = (s: string | undefined | null): string => {
  if (!s) return '';
  return s.charAt(0).toUpperCase() + s.slice(1);
};

const FALLBACK_LANG = 'en';

const TRANSLATIONS: Record<string, Record<string, string>> = {
  en: {
    title: 'Clan Selection',
    subtitle: 'Choose your vampire clan',
    flavorLine1: 'The Blood remembers.',
    flavorLine2: 'Choose your lineage.',
    expand: 'Expand',
    restore: 'Restore',
    expandTip: 'Expand window',
    restoreTip: 'Restore window',
    availableClans: 'Available Clans',
    clanName: 'Clan Name',
    customNamePlaceholder: 'Name your Caitiff bloodline...',
    customNameHint: 'Leave blank to be known simply as the "Custom Clan".',
    description: 'Description',
    curseDownside: 'Curse / Downside',
    bloodPreference: 'Blood Preference',
    lordOfClan: 'Lord of the Clan',
    lordHailedAs: 'Hailed as the',
    lordVitae: ', endowed with an extra +{vitae} vitae',
    lordOnlyBoons: 'Lord-only Boons',
    specialClanTraits: 'Special Clan Traits',
    disciplinesPowers: 'Disciplines & Powers',
    caitiffNoDisciplines: 'A Caitiff chooses their own disciplines later.',
    none: 'None.',
    unknown: 'Unknown',
    noPowersDocumented: 'No powers documented.',
    accept: 'Accept Clan',
    close: 'Close',
    warningDefault:
      'If no clan is chosen, Crimson Fangs will be assigned by default.',
  },
  ru: {
    title: 'Выбор клана',
    subtitle: 'Выберите свой клан вампира',
    flavorLine1: 'Кровь помнит.',
    flavorLine2: 'Выбери свою линию крови.',
    expand: 'Развернуть',
    restore: 'Свернуть',
    expandTip: 'Развернуть окно',
    restoreTip: 'Свернуть окно',
    availableClans: 'Доступные кланы',
    clanName: 'Имя клана',
    customNamePlaceholder: 'Назовите свою линию кейтиффов...',
    customNameHint:
      'Если оставить пустым — будете известны просто как «Custom Clan».',
    description: 'Описание',
    curseDownside: 'Проклятие / Слабость',
    bloodPreference: 'Кровные предпочтения',
    lordOfClan: 'Лорд клана',
    lordHailedAs: 'Почитается как',
    lordVitae: ', благословлён +{vitae} витаэ',
    lordOnlyBoons: 'Дары лорда',
    specialClanTraits: 'Особые черты клана',
    disciplinesPowers: 'Дисциплины и силы',
    caitiffNoDisciplines: 'Кейтифф выбирает свои дисциплины позже.',
    none: 'Нет.',
    unknown: 'Неизвестно',
    noPowersDocumented: 'Силы не задокументированы.',
    accept: 'Принять клан',
    close: 'Закрыть',
    warningDefault:
      'Если клан не выбран, по умолчанию будет назначен Nosferatu.',
  },
};

type ClanLoc = {
  name: string;
  desc: string;
  curse: string;
  downside: string;
  bloodPreference: string;
  tagline: string;
  lordTitle: string;
};

const RU_CLANS_BY_NAME: Record<string, ClanLoc> = {
  Nosferatu: {
    name: 'Носферату',
    desc: 'Носферату носят своё проклятие наружу. Их тела чудовищно искажены и обезображены Объятием. Они обитают на задворках большинства городов, выступая шпионами и торговцами тайнами. Используя зверей и сверхъестественную способность скрываться, они видят всё — за это их и зовут Канализационными Крысами.',
    curse: 'Облик, нарушающий Маскарад.',
    downside: 'уродливое лицо и страдания на солнце',
    bloodPreference: 'кровь сородичей, кровь мёртвых, кровь паразитов',
    tagline: 'Шпионы канализаций и сломанные маски',
    lordTitle: 'Носферату',
  },
  'Vitabella Family': {
    name: 'Семья Витабелла',
    desc: 'Эора, тронутая твоим неустанным стремлением к искусству и красоте, благословила твою проклятую линию крови. Но в восхищении она проглядела тёмные грани твоей натуры: извращённое понимание любви и манию величия.',
    curse: 'Одержимость тщеславием, потребность быть любимым.',
    downside:
      'ты совершенен и не имеешь слабостей. Даже солнце тебе нипочём',
    bloodPreference: 'всё, что есть красота жизни — ты любишь',
    tagline: 'Красота, одержимость и обожание',
    lordTitle: 'Старейшина',
  },
  'House Thronleer': {
    name: 'Дом Тронлеер',
    desc: 'Нок, очарованный неутолимой жаждой твоего Дома собирать знания, благословил твою проклятую линию крови. Но Ксиликс сдал плохую руку — проклятие наградило тебя страхом перед прихотями и злыми судьбами.',
    curse: 'Боязнь шутов, одержимость познанием и тяжкая хандра.',
    downside: 'хроническая боязнь шутов, тяжёлые штрафы к настроению',
    bloodPreference: 'любая кровь — разнообразие есть знание',
    tagline: 'Знание, ужас и дурные предзнаменования',
    lordTitle: 'Старейшина',
  },
  'Children of the Abyss': {
    name: 'Дети Бездны',
    desc: 'Дети Бездны — линия крови вампиров, поклоняющихся древним демонам. Из-за родства с нечестивым они крайне уязвимы перед Церковью.',
    curse: 'Страх перед Религией.',
    downside: 'горят на солнце и в присутствии Десяти',
    bloodPreference: 'любая кровь',
    tagline: 'Демоническая набожность и святая слабость',
    lordTitle: 'Лорд',
  },
  'Crimson Fang': {
    name: 'Багровый Клык',
    desc: 'Багровых Клыков прочие сородичи часто считают опасными убийцами и диаблеристами. Но на деле — это стражи, воины и знатоки, что пытаются дистанцироваться от политики обоих миров: вампирского и мирского.',
    curse: 'Зависимость от крови сородичей и знати.',
    downside: 'горят на солнце',
    bloodPreference: 'кровь знати, духовенства, инквизиции или сородичей',
    tagline: 'Убийцы, воины и диаблеристы',
    lordTitle: 'Лорд',
  },
};

const RU_CAITIFF: ClanLoc = {
  name: 'Кастомный Клан Кейтиффов',
  desc: 'Выкуй собственную проклятую линию крови вне древних домов. Старейшины не примут тебя — но и их цепи тебя не свяжут.',
  curse: 'Нестабильное наследие.',
  downside: 'у тебя нет древнего дома, чтобы укрыть твоё имя',
  bloodPreference: 'твой голод — твой собственный',
  tagline: 'Выкуй собственную проклятую линию крови',
  lordTitle: 'Лорд Кейтиффов',
};

const RU_LORD_FORMS_BY_NAME: Record<string, { name: string; desc: string }> = {
  'Sewer Rat Form': {
    name: 'Облик Канализационной Крысы',
    desc: 'Сбрось вампирский облик ради формы канализационной крысы — проскальзывай в щели, недоступные ни одному человеку.',
  },
  'Bat Form': {
    name: 'Облик Летучей Мыши',
    desc: 'Воспари крылатой тенью — быстрой, неуловимой, по которой трудно попасть.',
  },
  'Gaseous Form': {
    name: 'Газообразный Облик',
    desc: 'Растворись в тумане — неуязвим, но призрачно привязан к этому миру.',
  },
  'Cabbit Form': {
    name: 'Облик Кэббита',
    desc: 'Изящная, обманчиво кроткая форма — красота как маскировка, клык за улыбкой.',
  },
};

const RU_TRAITS_BY_NAME: Record<string, { name: string; desc: string }> = {
  'Nasty Eater': {
    name: 'Неприхотливый Едок',
    desc: 'Желудок без жалоб переваривает мрачную пищу.',
  },
  'Hidden from Sight': {
    name: 'Сокрытый от Взора',
    desc: 'Гадальные чары соскальзывают с твоего имени.',
  },
  Unseemly: {
    name: 'Безобразный',
    desc: 'Искажённые черты тревожат всякого, кто их видит.',
  },
  'Keen Ears': {
    name: 'Чуткий Слух',
    desc: 'Звуки, недоступные другим, отчётливо доходят до тебя.',
  },
  Jesterphobia: {
    name: 'Шутобоязнь',
    desc: 'Скоморохи, шуты и дураки расшатывают тебе нервы.',
  },
  'Brooding Soul': {
    name: 'Меланхоличная Душа',
    desc: 'Дебаффы настроения бьют тебя сильнее, чем других.',
  },
  'Self-Sustenance': {
    name: 'Самообеспечение',
    desc: 'Долгие занятия научили тебя обходиться малым.',
  },
  'Skilled Hand': {
    name: 'Искусная Рука',
    desc: 'Твой почерк изящен и не поддаётся подделке.',
  },
  'Jack of All Trades': {
    name: 'На все руки мастер',
    desc: 'Широкая сноровка во многих ремёслах.',
  },
  Intellectual: {
    name: 'Интеллектуал',
    desc: 'Острый ум для арканных и мирских наук.',
  },
  'Light Step': {
    name: 'Лёгкая Поступь',
    desc: 'Двигаешься, не тревожа добычу или стражу.',
  },
  'Silver Tongue': {
    name: 'Серебряный Язык',
    desc: 'Речь склоняет умы там, где другие бессильны.',
  },
  Deathsight: {
    name: 'Смертовидение',
    desc: 'Чувствуешь умирающих — когда и где они падут.',
  },
  Beautiful: {
    name: 'Красивый',
    desc: 'Нечеловечески пригож; взгляды цепляются за тебя в любом помещении.',
  },
  Empath: {
    name: 'Эмпат',
    desc: 'Читаешь настроения и мелкую ложь окружающих.',
  },
  Exteroception: {
    name: 'Восприятие',
    desc: 'Обострённое чувство тел и окружения.',
  },
  'Heavy Armor Mastery': {
    name: 'Мастерство Тяжёлой Брони',
    desc: 'Латы и кольчуга больше тебя не отягощают.',
  },
  'Infinite Stamina': {
    name: 'Бесконечная Выносливость',
    desc: 'Труд и битва не утомляют тебя.',
  },
  'Uncapped Strength': {
    name: 'Безграничная Сила',
    desc: 'Твоя сырая мощь не имеет смертного предела.',
  },
  "Appraiser's Eye": {
    name: 'Глаз Оценщика',
    desc: 'С первого взгляда определяешь стоимость любого товара.',
  },
  'Deceiving Meekness': {
    name: 'Обманчивая Кротость',
    desc: 'Враги недооценивают тебя, пока не становится слишком поздно.',
  },
};

const RU_COVENS_BY_NAME: Record<string, { name: string; desc: string }> = {
  Auspex: {
    name: 'Ауспекс',
    desc: 'Позволяет видеть существ, ауры и их состояние сквозь стены.',
  },
  Bloodheal: {
    name: 'Кровоисцеление',
    desc: 'Используй силу витаэ, чтобы постепенно восстанавливать плоть.',
  },
  Celerity: {
    name: 'Алакритас',
    desc: 'Усиливает скорость. Нарушает Маскарад.',
  },
  Demonic: {
    name: 'Демоническое',
    desc: 'Призови подмогу адских тварей, противостой ОГНЮ, обернись бесом. Нарушает Маскарад.',
  },
  'Eoran Embrace': {
    name: 'Объятие Эоры',
    desc: 'Благословлены Богиней Любви, Семьи и Искусства. Эти вампиры развили силы, укрепляющие связи, вдохновляющие красоту и исцеляющие душевные раны.',
  },
  'Fae Trickery': {
    name: 'Фейские Уловки',
    desc: 'Этот ковен обычно развивается у вампиров, рождённых близ топей Дафтмарша среди Фей.',
  },
  Obfuscate: {
    name: 'Сокрытие',
    desc: 'Делает тебя менее заметным для живых и неживых существ.',
  },
  Potence: {
    name: 'Мощь',
    desc: 'Усиливает урон в ближнем и безоружном бою.',
  },
  Presence: {
    name: 'Присутствие',
    desc: 'Вторгайся в смертный разум — твои слова сильнее любого меча. Подчиняй их.',
  },
  Quietus: {
    name: 'Безмолвие',
    desc: 'Живи в тенях, разя лишь тогда, когда это нужно. Яды, всеобщее смятение и огонь.',
  },
  'Siren Blessing': {
    name: 'Благословение Сирены',
    desc: 'Обычно встречается у вампиров, что бывают у морей Энигмы; они переняли способность сирен. Используй голос, чтобы ОБЕЗДВИЖИТЬ врагов.',
  },
};

const RU_POWERS_BY_NAME: Record<string, { name: string; desc: string }> = {
  // Auspex
  'Heightened Senses': {
    name: 'Обострённые чувства',
    desc: 'Усиливает твои ощущения далеко за пределы человеческих.',
  },
  'An Ear For Lies': {
    name: 'Слух на ложь',
    desc: 'Слышишь больше, чем должно.',
  },
  "The Spirit's Touch": {
    name: 'Касание Духа',
    desc: 'Сможешь выследить добычу по ничтожнейшим следам.',
  },
  'Psychic Projection': {
    name: 'Психическая Проекция',
    desc: 'Оставь тело и пролети над землями.',
  },
  // Bloodheal
  'Minor Bloodheal': {
    name: 'Малое Кровоисцеление',
    desc: 'Медленно затягивай мелкие раны витаэ.',
  },
  Bloodheal: {
    name: 'Кровоисцеление',
    desc: 'Залечивай раны равномерным темпом.',
  },
  'Quick Bloodheal': {
    name: 'Быстрое Кровоисцеление',
    desc: 'Залечивай раны на видимых глазу скоростях — это нарушает Маскарад!',
  },
  'Major Bloodheal': {
    name: 'Большое Кровоисцеление',
    desc: 'Стремительно залечивай даже серьёзные ранения. Нарушает Маскарад!',
  },
  'Greater Bloodheal': {
    name: 'Великое Кровоисцеление',
    desc: 'Залечивай раны и восстанавливай повреждённые органы. Нарушает Маскарад!',
  },
  // Celerity
  'Celerity 1': {
    name: 'Алакритас 1',
    desc: 'Усиливает скорость, чтобы всё давалось чуть проще.',
  },
  'Celerity 2': {
    name: 'Алакритас 2',
    desc: 'Заметно повышает скорость и реакцию.',
  },
  'Celerity 3': {
    name: 'Алакритас 3',
    desc: 'Двигайся быстрее. Реагируй за меньшее время. Тело под идеальным контролем.',
  },
  'Celerity 4': {
    name: 'Алакритас 4',
    desc: 'Прорви пределы возможного для смертных. Двигайся подобно молнии.',
  },
  'Celerity 5': {
    name: 'Алакритас 5',
    desc: 'Ты словно свет. Прорывайся сквозь мир огнём.',
  },
  // Demonic
  'Deny the Mother': {
    name: 'Отрицание Матери',
    desc: 'Иммунитет к поджогу на двадцать секунд.',
  },
  'Fear of the Void': {
    name: 'Страх перед Бездной',
    desc: 'Короткий всплеск скорости и стойкости.',
  },
  Conflagration: {
    name: 'Возгорание',
    desc: 'Преврати руки в смертоносные когти.',
  },
  Psychomachia: {
    name: 'Психомахия',
    desc: 'Поджигай врагов огненным шаром.',
  },
  'Infernal Fireball': {
    name: 'Адский Огненный Шар',
    desc: 'Это заклинание выпускает разрывной огненный шар по цели.',
  },
  'Wall of Fire': {
    name: 'Огненная Стена',
    desc: 'Молния? Огненный шар? Нет. Огненная Стена!',
  },
  // Eoran
  'Empathic Bond': {
    name: 'Эмпатическая Связь',
    desc: 'Прикосновением считай эмоциональное состояние и нужды цели — на короткий срок становишься ею одержим.',
  },
  'Artistic Inspiration': {
    name: 'Художественное Вдохновение',
    desc: 'Вдохни в других божественную творческую искру, усиливая их искусство и настроение.',
  },
  'Familial Bond': {
    name: 'Семейные Узы',
    desc: 'Создай временную духовную связь между двумя людьми — они смогут чувствовать местоположение и состояние друг друга.',
  },
  "Beauty's Restoration": {
    name: 'Восстановление Красоты',
    desc: 'Прибегни к силе Эоры, чтобы вернуть красоту и исцелить уродства.',
  },
  // Fae Trickery
  'Darkling Trickery': {
    name: 'Тёмные Уловки',
    desc: 'Обезоружь жертв на расстоянии.',
  },
  Goblinism: {
    name: 'Гоблинизм',
    desc: 'Призови коварного гоблина, который вцепится врагу в лицо.',
  },
  'Chanjelin Ward': {
    name: 'Знак Чанжелина',
    desc: 'Ставит символ под тобой. Жестокая ловушка швыряет жертв, кружение лишает их равновесия, падение валит на землю и отбрасывает их оружие.',
  },
  'Riddle Phantastique': {
    name: 'Фантастическая Загадка',
    desc: 'Поставь жертве запутанную загадку — она не сможет действовать, пока не ответит.',
  },
  // Obfuscate
  'Cloak of Shadows': {
    name: 'Покров Теней',
    desc: 'Слейся с тенями и оставайся незамеченным, пока не привлекаешь внимания. Прерывается любым движением.',
  },
  'Unseen Presence': {
    name: 'Незримое Присутствие',
    desc: 'Двигайся в толпе, оставаясь незамеченным. Достигай невидимости при ходьбе.',
  },
  "Vanish from the Mind's Eye": {
    name: 'Исчезновение из Памяти',
    desc: 'Исчезни из вида мгновенно и сотри своё присутствие из недавних воспоминаний.',
  },
  'Cloak the Gathering': {
    name: 'Скрыть Собрание',
    desc: 'Сокрой себя и других в небольшой области. Все ближайшие союзники становятся невидимыми.',
  },
  // Potence
  'Potence 1': {
    name: 'Мощь 1',
    desc: 'Укрепи мышцы. Никогда не бей вполсилы.',
  },
  'Potence 2': {
    name: 'Мощь 2',
    desc: 'Стань сильнее своих мышц. Сокрушай людей и предметы.',
  },
  'Potence 3': {
    name: 'Мощь 3',
    desc: 'Стань силой разрушения. Поднимай и ломай неподъёмное и неломаемое.',
  },
  'Potence 4': {
    name: 'Мощь 4',
    desc: 'Стань неумолимой машиной — настолько, насколько хватит витаэ.',
  },
  'Potence 5': {
    name: 'Мощь 5',
    desc: 'Покажи это людям — и они станут поклоняться тебе как богу.',
  },
  // Presence
  Awe: {
    name: 'Благоговение',
    desc: 'Заставь окружающих восхищаться тобой. Кто отвернётся — тот столкнётся с последствиями.',
  },
  'Dread Gaze': {
    name: 'Грозный Взор',
    desc: 'Пробуди страх в других одними лишь словами и взглядом.',
  },
  Kneel: {
    name: 'На Колени',
    desc: 'Заставь окружающих преклонить колени.',
  },
  Summon: {
    name: 'Призыв',
    desc: 'Держи друзей близко, а врагов — ещё ближе. Телепортируй цель к себе.',
  },
  Majesty: {
    name: 'Величие',
    desc: 'Стань настолько великолепен, что другим почти невозможно ослушаться или причинить тебе вред.',
  },
  // Quietus
  'Silence of Death': {
    name: 'Тишь Смерти',
    desc: 'Создай вокруг себя зону полнейшей тишины, сбивая с толку всё внутри неё.',
  },
  "Scorpion's Touch": {
    name: 'Касание Скорпиона',
    desc: 'Создай мощное вещество, поджигающее врагов.',
  },
  "Baal's Caress": {
    name: 'Ласка Ваала',
    desc: 'Преврати свою витаэ в токсин, разъедающий любую плоть. Применяется на ОСТРОМ оружии.',
  },
  'Taste of Death': {
    name: 'Вкус Смерти',
    desc: 'Плюнь во врагов сгустком разъедающей крови.',
  },
  "Dagon's Call": {
    name: 'Зов Дагона',
    desc: 'Прокляни последнего, кого ударил, утопить его в собственной крови.',
  },
  // Siren
  'The Missing Voice': {
    name: 'Утерянный Голос',
    desc: 'Брось свой голос в любую видимую тебе точку.',
  },
  'Phantom Speaker': {
    name: 'Призрачный Говорящий',
    desc: 'Спроецируй голос любому, кого встречал, и говори с ним издалека.',
  },
  Madrigal: {
    name: 'Мадригал',
    desc: 'Спой песнь сирены — окружающие потянутся к тебе.',
  },
  "Siren's Beckoning": {
    name: 'Зов Сирены',
    desc: 'Затяни неземную песнь, чтобы оглушить окружающих.',
  },
  'Shattering Crescendo': {
    name: 'Сокрушающее Крещендо',
    desc: 'Издай крик неестественной высоты, разрывающий тела врагов.',
  },
};

const localizeClan = (clan: ClanData, lang: string): ClanData => {
  if (lang !== 'ru') return clan;
  const next: ClanData = { ...clan };
  const loc = clan.isCustom ? RU_CAITIFF : RU_CLANS_BY_NAME[clan.name];
  if (loc) {
    next.name = loc.name;
    next.desc = loc.desc;
    next.curse = loc.curse;
    next.downside = loc.downside;
    next.bloodPreference = loc.bloodPreference;
    next.tagline = loc.tagline;
    next.lordTitle = loc.lordTitle;
  }
  if (clan.lordForm && RU_LORD_FORMS_BY_NAME[clan.lordForm.name]) {
    const f = RU_LORD_FORMS_BY_NAME[clan.lordForm.name];
    next.lordForm = { name: f.name, desc: f.desc };
  }
  const localizeTraits = (traits: TraitData[] | undefined): TraitData[] =>
    (traits || []).map((tr) => {
      const tloc = RU_TRAITS_BY_NAME[tr.name];
      return tloc ? { name: tloc.name, desc: tloc.desc } : tr;
    });
  next.lordTraits = localizeTraits(clan.lordTraits);
  next.clanTraits = localizeTraits(clan.clanTraits);
  next.covens = (clan.covens || []).map((cv) => {
    const cvloc = RU_COVENS_BY_NAME[cv.name];
    const localizedPowers: PowerData[] = (cv.powers || []).map((p) => {
      const ploc = RU_POWERS_BY_NAME[p.name];
      return ploc
        ? { name: ploc.name, level: p.level, desc: ploc.desc }
        : p;
    });
    return cvloc
      ? {
          name: cvloc.name,
          desc: cvloc.desc,
          icon: cv.icon,
          powers: localizedPowers,
        }
      : { ...cv, powers: localizedPowers };
  });
  return next;
};

const resolveLang = (raw: string | undefined): string => {
  if (raw && TRANSLATIONS[raw]) {
    return raw;
  }
  return FALLBACK_LANG;
};

const makeT =
  (lang: string, overrides?: Record<string, string> | null) =>
  (key: string, vars?: Record<string, string | number>): string => {
    let value: string | undefined = overrides ? overrides[key] : undefined;
    if (value === undefined) {
      const dict = TRANSLATIONS[lang] || TRANSLATIONS[FALLBACK_LANG];
      value = dict[key];
    }
    if (value === undefined) {
      value = TRANSLATIONS[FALLBACK_LANG][key];
    }
    if (value === undefined) {
      return key;
    }
    if (vars) {
      for (const name of Object.keys(vars)) {
        value = value.replace(`{${name}}`, String(vars[name]));
      }
    }
    return value;
  };

const setVampireClanWindowSize = (expanded: boolean) => {
  if (typeof Byond === 'undefined' || !Byond?.winset) return;
  const scale = window.devicePixelRatio || 1;
  const screenWidth = Math.floor(window.screen.availWidth * scale);
  const screenHeight = Math.floor(window.screen.availHeight * scale);
  const width = expanded
    ? screenWidth
    : Math.min(DEFAULT_W, screenWidth);
  const height = expanded
    ? screenHeight
    : Math.min(DEFAULT_H, screenHeight);
  const x = expanded ? 0 : Math.max(Math.floor((screenWidth - width) / 2), 0);
  const y = expanded ? 0 : Math.max(Math.floor((screenHeight - height) / 2), 0);
  Byond.winset(Byond.windowId, {
    pos: `${x},${y}`,
    size: `${width}x${height}`,
  });
};

export const VampireClanSelection = () => {
  const { act, data } = useBackend<VampireClanSelectionData>();
  const [expandedCovens, setExpandedCovens] = useState<Set<string>>(new Set());
  const [customName, setCustomName] = useState(data.pendingCustomName || '');
  const [windowExpanded, setWindowExpanded] = useState(false);

  const lang = resolveLang(data.language);
  const t = makeT(lang, data.i18nOverrides);

  const localizedClans = data.clans.map((clan) => localizeClan(clan, lang));
  const selectedClan =
    localizedClans.find((clan) => clan.id === data.selectedClanId) ||
    localizedClans[0];
  const isCustom = !!selectedClan?.isCustom;

  const toggleCoven = (covenName: string) => {
    setExpandedCovens((prev) => {
      const next = new Set(prev);
      if (next.has(covenName)) {
        next.delete(covenName);
      } else {
        next.add(covenName);
      }
      return next;
    });
  };

  const onCustomNameChange = (value: string) => {
    setCustomName(value);
    act('set_custom_name', { name: value });
  };

  const toggleWindow = () => {
    const nextExpanded = !windowExpanded;
    setVampireClanWindowSize(nextExpanded);
    setWindowExpanded(nextExpanded);
  };

  return (
    <Window width={DEFAULT_W} height={DEFAULT_H} theme="generic">
      <Window.Content className="VampireClanSelection" fitted>
        <Box className="VampireClanSelection__shell">
          <Box className="VampireClanSelection__header">
            <Box className="VampireClanSelection__crest">
              <Box className="VampireClanSelection__crestInner">
                <Icon name="gem" />
              </Box>
            </Box>
            <Box className="VampireClanSelection__titleBlock">
              <Box className="VampireClanSelection__title">{t('title')}</Box>
              <Box className="VampireClanSelection__subtitle">
                {t('subtitle')}
              </Box>
            </Box>
            <Box className="VampireClanSelection__windowControls">
              <Button
                color="transparent"
                icon={windowExpanded ? 'compress' : 'expand'}
                tooltip={windowExpanded ? t('restoreTip') : t('expandTip')}
                tooltipPosition="left"
                onClick={toggleWindow}
                className="VampireClanSelection__windowButton"
              >
                {windowExpanded ? t('restore') : t('expand')}
              </Button>
            </Box>
            <Box className="VampireClanSelection__flavor">
              {t('flavorLine1')}
              <br />
              {t('flavorLine2')}
            </Box>
          </Box>

          <Box className="VampireClanSelection__body">
            <Box className="VampireClanSelection__leftPanel">
              <Section title={t('availableClans')} fill scrollable>
                <Stack vertical>
                  {localizedClans.map((clan, index) => {
                    const selected = clan.id === selectedClan?.id;
                    return (
                      <Stack.Item key={clan.id}>
                        <Button
                          fluid
                          className={
                            selected
                              ? 'VampireClanSelection__clanCard VampireClanSelection__clanCard--selected'
                              : 'VampireClanSelection__clanCard'
                          }
                          onClick={() =>
                            act('select_clan', { clan_id: clan.id })
                          }
                        >
                          <Stack align="center">
                            <Stack.Item>
                              <Box className="VampireClanSelection__number">
                                {index + 1}
                              </Box>
                            </Stack.Item>
                            <Stack.Item>
                              <Box
                                className={
                                  clan.isCustom
                                    ? 'VampireClanSelection__cardSigil VampireClanSelection__cardSigil--custom'
                                    : 'VampireClanSelection__cardSigil'
                                }
                              >
                                <Icon
                                  name={clan.isCustom ? 'question' : 'gem'}
                                />
                              </Box>
                            </Stack.Item>
                            <Stack.Item grow>
                              <Box className="VampireClanSelection__clanName">
                                {clan.name}
                              </Box>
                              <Box className="VampireClanSelection__tagline">
                                {clan.tagline}
                              </Box>
                            </Stack.Item>
                          </Stack>
                        </Button>
                      </Stack.Item>
                    );
                  })}
                </Stack>
              </Section>
            </Box>

            <Box className="VampireClanSelection__rightPanel">
              <Section fill scrollable>
                {selectedClan ? (
                  <Box className="VampireClanSelection__details">
                    <Box className="VampireClanSelection__selectedName">
                      {selectedClan.name}
                    </Box>
                    <Box className="VampireClanSelection__divider" />

                    {isCustom ? (
                      <Box className="VampireClanSelection__infoBlock">
                        <Box className="VampireClanSelection__infoTitle">
                          <Icon
                            name="pen"
                            className="VampireClanSelection__infoIcon"
                          />
                          {t('clanName')}
                        </Box>
                        <Input
                          fluid
                          className="VampireClanSelection__customNameInput"
                          placeholder={t('customNamePlaceholder')}
                          value={customName}
                          onChange={onCustomNameChange}
                          maxLength={42}
                        />
                        <Box
                          className="VampireClanSelection__infoText"
                          mt={0.5}
                        >
                          {t('customNameHint')}
                        </Box>
                      </Box>
                    ) : null}

                    <InfoBlock
                      title={t('description')}
                      icon="book"
                      text={capFirst(selectedClan.desc)}
                      fallback={t('unknown')}
                    />
                    <InfoBlock
                      title={t('curseDownside')}
                      icon="skull"
                      text={capFirst(
                        selectedClan.downside || selectedClan.curse,
                      )}
                      fallback={t('unknown')}
                    />
                    <InfoBlock
                      title={t('bloodPreference')}
                      icon="tint"
                      text={capFirst(selectedClan.bloodPreference)}
                      fallback={t('unknown')}
                    />

                    <LordBlock clan={selectedClan} t={t} />

                    <ClanTraitsBlock traits={selectedClan.clanTraits} t={t} />

                    <Box className="VampireClanSelection__infoBlock">
                      <Box className="VampireClanSelection__infoTitle">
                        <Icon
                          name="fire"
                          className="VampireClanSelection__infoIcon"
                        />
                        {t('disciplinesPowers')}
                      </Box>
                      {selectedClan.covens && selectedClan.covens.length > 0 ? (
                        <Stack vertical>
                          {selectedClan.covens.map((coven) => (
                            <Stack.Item key={coven.name}>
                              <CovenCard
                                coven={coven}
                                expanded={expandedCovens.has(coven.name)}
                                onToggle={() => toggleCoven(coven.name)}
                                t={t}
                              />
                            </Stack.Item>
                          ))}
                        </Stack>
                      ) : (
                        <Box className="VampireClanSelection__infoText">
                          {isCustom ? t('caitiffNoDisciplines') : t('none')}
                        </Box>
                      )}
                    </Box>
                  </Box>
                ) : null}
              </Section>
            </Box>
          </Box>

          <Box className="VampireClanSelection__footer">
            <Box className="VampireClanSelection__warning">
              {t('warningDefault')}
            </Box>
            <Stack align="center">
              <Stack.Item grow />
              <Stack.Item>
                <Button
                  color="red"
                  icon="check"
                  onClick={() => act('accept_clan')}
                  className="VampireClanSelection__footerAccept"
                >
                  {t('accept')}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="transparent"
                  icon="times"
                  onClick={() => act('close')}
                  className="VampireClanSelection__footerClose"
                >
                  {t('close')}
                </Button>
              </Stack.Item>
            </Stack>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};

type Translator = ReturnType<typeof makeT>;

const InfoBlock = (props: {
  title: string;
  icon: string;
  text?: string;
  fallback?: string;
}) => (
  <Box className="VampireClanSelection__infoBlock">
    <Box className="VampireClanSelection__infoTitle">
      <Icon
        name={props.icon}
        className="VampireClanSelection__infoIcon"
      />
      {props.title}
    </Box>
    <Box className="VampireClanSelection__infoText">
      {props.text || props.fallback || ''}
    </Box>
  </Box>
);

const LordBlock = (props: { clan: ClanData; t: Translator }) => {
  const { clan, t } = props;
  const hasForm = !!clan.lordForm;
  const hasTraits = clan.lordTraits && clan.lordTraits.length > 0;
  const hasVitae = !!clan.vitaeBonus;
  if (!hasForm && !hasTraits && !hasVitae && !clan.isCustom) {
    return null;
  }
  return (
    <Box className="VampireClanSelection__infoBlock">
      <Box className="VampireClanSelection__infoTitle">
        <Icon name="crown" className="VampireClanSelection__infoIcon" />
        {t('lordOfClan')}
      </Box>
      <Box className="VampireClanSelection__lordTitleLine">
        {t('lordHailedAs')} <b>{clan.lordTitle || 'Lord'}</b>
        {hasVitae ? t('lordVitae', { vitae: clan.vitaeBonus }) : null}.
      </Box>

      {hasForm ? (
        <Box className="VampireClanSelection__lordFormCard">
          <Box className="VampireClanSelection__lordFormTitle">
            <Icon name="dragon" className="VampireClanSelection__formIcon" />
            {clan.lordForm!.name}
          </Box>
          <Box className="VampireClanSelection__lordFormDesc">
            {clan.lordForm!.desc}
          </Box>
        </Box>
      ) : null}

      {hasTraits ? (
        <Box className="VampireClanSelection__traitList">
          <Box className="VampireClanSelection__traitListLabel">
            {t('lordOnlyBoons')}
          </Box>
          {clan.lordTraits.map((trait) => (
            <TraitRow key={`lord-${trait.name}`} trait={trait} />
          ))}
        </Box>
      ) : null}
    </Box>
  );
};

const ClanTraitsBlock = (props: { traits: TraitData[]; t: Translator }) => {
  const { traits, t } = props;
  if (!traits || traits.length === 0) {
    return null;
  }
  return (
    <Box className="VampireClanSelection__infoBlock">
      <Box className="VampireClanSelection__infoTitle">
        <Icon name="star" className="VampireClanSelection__infoIcon" />
        {t('specialClanTraits')}
      </Box>
      <Box className="VampireClanSelection__traitList">
        {traits.map((trait) => (
          <TraitRow key={`clan-${trait.name}`} trait={trait} />
        ))}
      </Box>
    </Box>
  );
};

const TraitRow = (props: { trait: TraitData }) => (
  <Box className="VampireClanSelection__traitRow">
    <Box className="VampireClanSelection__traitName">{props.trait.name}</Box>
    <Box className="VampireClanSelection__traitDesc">{props.trait.desc}</Box>
  </Box>
);

const CovenCard = (props: {
  coven: CovenData;
  expanded: boolean;
  onToggle: () => void;
  t: Translator;
}) => {
  const { coven, expanded, onToggle, t } = props;
  return (
    <Box className="VampireClanSelection__covenCard">
      <Button
        fluid
        className="VampireClanSelection__covenHeader"
        onClick={onToggle}
      >
        <Stack align="center">
          <Stack.Item>
            <Box className="VampireClanSelection__covenChevron">
              <Icon name={expanded ? 'chevron-down' : 'chevron-right'} />
            </Box>
          </Stack.Item>
          <Stack.Item grow>
            <Box className="VampireClanSelection__covenName">{coven.name}</Box>
            <Box className="VampireClanSelection__covenDesc">
              {capFirst(coven.desc)}
            </Box>
          </Stack.Item>
        </Stack>
      </Button>
      {expanded ? (
        <Box className="VampireClanSelection__powerList">
          {coven.powers && coven.powers.length > 0 ? (
            coven.powers.map((power) => (
              <Box
                key={`${coven.name}-${power.level}-${power.name}`}
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
                </Box>
              </Box>
            ))
          ) : (
            <Box className="VampireClanSelection__infoText">
              {t('noPowersDocumented')}
            </Box>
          )}
        </Box>
      ) : null}
    </Box>
  );
};
