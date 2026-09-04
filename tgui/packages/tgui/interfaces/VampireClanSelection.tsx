import { useState } from 'react';
import { Box, Button, Icon, Input, Section, Stack } from 'tgui-core/components';

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
    lordFallback: 'Lord',
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
    subtitle: 'Избери свой клан',
    flavorLine1: 'Кровь помнит.',
    flavorLine2: 'Избери свою линию крови.',
    expand: 'Развернуть',
    restore: 'Восстановить',
    expandTip: 'Развернуть окно',
    restoreTip: 'Восстановить размер окна',
    availableClans: 'Доступные кланы',
    clanName: 'Имя клана',
    customNamePlaceholder: 'Нареки свою линию крови...',
    customNameHint:
      'Оставь поле пустым — и клан будет именоваться «Пользовательский клан».',
    description: 'Описание',
    curseDownside: 'Проклятие и изъян',
    bloodPreference: 'Предпочитаемая кровь',
    lordOfClan: 'Владыка клана',
    lordHailedAs: 'Титул:',
    lordFallback: 'Лорд',
    lordVitae: '; запас витэ: +{vitae}',
    lordOnlyBoons: 'Дары владыки',
    specialClanTraits: 'Особые черты клана',
    disciplinesPowers: 'Дисциплины и силы',
    caitiffNoDisciplines: 'Каитифф изберёт свои дисциплины позже.',
    none: 'Нет.',
    unknown: 'Неизвестно',
    noPowersDocumented: 'Сведения о силах отсутствуют.',
    accept: 'Избрать клан',
    close: 'Закрыть',
    warningDefault:
      'Если ты не сделаешь выбор, тебе будет назначен клан «Носферату».',
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
    desc: 'Носферату носят своё проклятие на виду у всех. Объятие чудовищно исказило их тела; они таятся на окраинах городов, служа шпионами и торговцами сведениями. Им помогают звери и сверхъестественный дар скрытности — потому ничто не ускользает от взора Носферату.',
    curse: 'Облик, нарушающий Маскарад.',
    downside: 'отвратительный облик и муки под солнцем',
    bloodPreference: 'кровь сородичей, мёртвых и паразитов',
    tagline: 'Шпионы подземелий и разбитые маски',
    lordTitle: 'Носферату',
  },
  'Vitabella Family': {
    name: 'Семейство Витабелла',
    desc: 'Эора, тронутая твоим неустанным стремлением к искусству и красоте, благословила твою проклятую линию крови. Но, восхищаясь тобой, она не разглядела тёмные грани твоей натуры: извращённое понимание любви и манию величия.',
    curse: 'Одержимость тщеславием и потребность быть любимым.',
    downside:
      'ты совершенен и лишён слабостей — даже солнце тебе не страшно',
    bloodPreference: 'всё, в чём есть красота жизни',
    tagline: 'Красота, одержимость и обожание',
    lordTitle: 'Старейшина',
  },
  'House Thronleer': {
    name: 'Дом Тронлеер',
    desc: 'Нок, пленённая неутолимой жаждой знаний твоего Дома, благословила твою проклятую линию крови. Но Ксайликс сдал дурную карту, и проклятая кровь обрекла тебя на боязнь шутовства и недоброй судьбы.',
    curse: 'Шутобоязнь, жажда познания и тяжкая хандра.',
    downside: 'хроническая шутобоязнь и тяжёлые удары по настроению',
    bloodPreference: 'любая кровь — в разнообразии знание',
    tagline: 'Знание, ужас и дурные предзнаменования',
    lordTitle: 'Старейшина',
  },
  'Children of the Abyss': {
    name: 'Дети Бездны',
    desc: 'Дети Бездны — линия крови вампиров, поклоняющихся древним демонам. Родство с нечестивым делает их крайне уязвимыми перед святостью богов.',
    curse: 'Страх перед верой.',
    downside: 'горят под солнцем и в присутствии Десяти',
    bloodPreference: 'любая кровь',
    tagline: 'Демоническое благочестие и святая магия',
    lordTitle: 'Лорд',
  },
  'Crimson Fang': {
    name: 'Багровый Клык',
    desc: 'Прочие сородичи считают Багровых Клыков опасными убийцами и диаблеристами. На деле же это стражи, воины и учёные, сторонящиеся политики как вампирского, так и смертного мира.',
    curse: 'Зависимость от крови сородичей и знати.',
    downside: 'горишь под солнцем',
    bloodPreference: 'кровь знати, духовенства, Инквизиции и сородичей',
    tagline: 'Убийцы, воины и диаблеристы',
    lordTitle: 'Лорд',
  },
};

const RU_CAITIFF: ClanLoc = {
  name: 'Собственный клан каитиффа',
  desc: 'Выкуй собственную проклятую линию крови вне древних Домов. Старейшины не признают тебя, но и их цепи тебя не скуют.',
  curse: 'Нестабильное наследие.',
  downside: 'у тебя нет древнего Дома, чтобы укрыть твоё имя',
  bloodPreference: 'твой голод — твой собственный',
  tagline: 'Выкуй собственную проклятую линию крови',
  lordTitle: 'Владыка каитиффов',
};

const RU_LORD_FORMS_BY_NAME: Record<string, { name: string; desc: string }> = {
  'Sewer Rat Form': {
    name: 'Облик канализационной крысы',
    desc: 'Сбрось облик сородича и обернись канализационной крысой — проскользни туда, куда не проберётся ни один смертный.',
  },
  'Bat Form': {
    name: 'Облик летучей мыши',
    desc: 'Взмой крылатой тенью — быстрой, неуловимой, трудной для удара.',
  },
  'Gaseous Form': {
    name: 'Туманный облик',
    desc: 'Растворись в тумане — недосягаем, но едва связан с этим миром.',
  },
  'Cabbit Form': {
    name: 'Облик кролика',
    desc: 'Изящный, обманчиво кроткий облик — красота как маскировка, клык за улыбкой.',
  },
};

const RU_TRAITS_BY_NAME: Record<string, { name: string; desc: string }> = {
  'Nasty Eater': {
    name: 'Непривередливый желудок',
    desc: 'Твой желудок безропотно принимает даже скверную пищу.',
  },
  'Hidden from Sight': {
    name: 'Сокрыт от взоров',
    desc: 'Гадательные чары скользят мимо твоего имени.',
  },
  Unseemly: {
    name: 'Отталкивающий облик',
    desc: 'Искажённые черты тревожат всякого, кто их увидит.',
  },
  'Keen Ears': {
    name: 'Острый слух',
    desc: 'Ты ясно слышишь звуки, ускользающие от других.',
  },
  Jesterphobia: {
    name: 'Шутобоязнь',
    desc: 'Скоморохи, шуты и дураки выводят тебя из равновесия.',
  },
  'Brooding Soul': {
    name: 'Мрачная душа',
    desc: 'Удары по настроению стают для тебя настоящей трагедией.',
  },
  'Self-Sustenance': {
    name: 'Самодостаточность',
    desc: 'Долгие занятия научили тебя довольствоваться малым.',
  },
  'Skilled writer': {
    name: 'Искусный писец',
    desc: 'Твой почерк изящен и лёгок для чтения.',
  },
  'Jack of All Trades': {
    name: 'Мастер на все руки',
    desc: 'Ты сведущ во множестве ремёсел.',
  },
  Intellectual: {
    name: 'Учёный ум',
    desc: 'Твой разум острее: ты легко судишь и о людях, и об их помыслах.',
  },
  'Light Step': {
    name: 'Лёгкая поступь',
    desc: 'Двигаешься, не тревожа добычу или стражу.',
  },
  Cicerone: {
    name: 'Искушённый дегустатор',
    desc: 'Ловкая рука и зоркий глаз позволяют узнать, что налито в чаше.',
  },
  Deathsight: {
    name: 'Взор смерти',
    desc: 'Ты чувствуешь умирающих — когда и где им суждено пасть.',
  },
  Beautiful: {
    name: 'Неземная красота',
    desc: 'Твоя красота не по-человечески совершенна — взгляды приковываются к тебе в любой зале.',
  },
  Empath: {
    name: 'Эмпат',
    desc: 'Читаешь настроения и мелкую ложь окружающих.',
  },
  Exteroception: {
    name: 'Обострённое восприятие',
    desc: 'Ты остро чувствуешь тела и окружение.',
  },
  'Heavy Armor Mastery': {
    name: 'Владение тяжёлой бронёй',
    desc: 'Латы и кольчуга больше тебя не отягощают.',
  },
  'Infinite Stamina': {
    name: 'Неиссякаемая выносливость',
    desc: 'Труд и битва тебя не истощают.',
  },
  'Uncapped Strength': {
    name: 'Безграничная сила',
    desc: 'Твоя грубая мощь не знает смертного предела.',
  },
  "Appraiser's Eye": {
    name: 'Глаз оценщика',
    desc: 'С первого взгляда определяешь стоимость любого товара.',
  },
  'Deceiving Meekness': {
    name: 'Обманчивая кротость',
    desc: 'Враги недооценивают тебя, пока не становится слишком поздно.',
  },
};

const RU_COVENS_BY_NAME: Record<string, { name: string; desc: string }> = {
  Auspex: {
    name: 'Прорицание',
    desc: 'Позволяет видеть сквозь стены существ, их ауры и состояние здоровья.',
  },
  Bloodheal: {
    name: 'Кровавое исцеление',
    desc: 'Используй силу витэ, чтобы постепенно восстанавливать плоть.',
  },
  Celerity: {
    name: 'Стремительность',
    desc: 'Дарует скорость, превосходящую пределы смертного тела. Нарушает Маскарад.',
  },
  Demonic: {
    name: 'Демонизм',
    desc: 'Призови адских тварей на помощь, противостой пламени и обернись бесом. Нарушает Маскарад.',
  },
  'Eoran Embrace': {
    name: 'Объятие Эоры',
    desc: 'Благословлённые Богиней Любви, Семьи и Искусства, эти вампиры укрепляют узы, вдохновляют красотой и исцеляют душевные раны.',
  },
  'Fae Trickery': {
    name: 'Фейские уловки',
    desc: 'Эта дисциплина чаще всего пробуждается у вампиров, рождённых близ топей Дафтмарша, среди фей.',
  },
  Obfuscate: {
    name: 'Сокрытие',
    desc: 'Делает тебя менее заметным для живых и мёртвых.',
  },
  Potence: {
    name: 'Могущество',
    desc: 'Усиливает урон в ближнем и безоружном бою.',
  },
  Presence: {
    name: 'Присутствие',
    desc: 'Вторгайся в смертный разум — твои слова сильнее любого меча. Подчиняй их.',
  },
  Quietus: {
    name: 'Смертоносность',
    desc: 'Таись в тенях и рази лишь тогда, когда это нужно. Яды, смятение и огонь.',
  },
  'Siren Blessing': {
    name: 'Благословение сирены',
    desc: 'Дар тех, кто ходит по морям Энигмы: голос сирены позволяет лишить врагов воли к движению.',
  },
};

const RU_POWERS_BY_NAME: Record<string, { name: string; desc: string }> = {
  // Auspex
  'Heightened Senses': {
    name: 'Обострённые чувства',
    desc: 'Твои чувства выходят далеко за человеческие пределы.',
  },
  'An Ear For Lies': {
    name: 'Слух на ложь',
    desc: 'Ты слышишь больше, чем должен.',
  },
  "The Spirit's Touch": {
    name: 'Прикосновение духа',
    desc: 'Выследи добычу по едва заметным следам.',
  },
  'Psychic Projection': {
    name: 'Психическая проекция',
    desc: 'Оставь тело и воспари над землями.',
  },
  // Bloodheal
  'Minor Bloodheal': {
    name: 'Малое кровавое исцеление',
    desc: 'Медленно затягивай лёгкие раны, расходуя витэ.',
  },
  Bloodheal: {
    name: 'Кровавое исцеление',
    desc: 'Ровно и без спешки залечивай раны.',
  },
  'Quick Bloodheal': {
    name: 'Стремительное кровавое исцеление',
    desc: 'Залечивай раны с заметной глазу быстротой — это нарушает Маскарад!',
  },
  'Major Bloodheal': {
    name: 'Большое кровавое исцеление',
    desc: 'Стремительно залечивай даже серьёзные ранения. Нарушает Маскарад!',
  },
  'Greater Bloodheal': {
    name: 'Великое кровавое исцеление',
    desc: 'Залечивай раны и восстанавливай повреждённые органы. Нарушает Маскарад!',
  },
  // Celerity
  'Celerity 1': {
    name: 'Малая стремительность',
    desc: 'Повысь скорость — и любое дело дастся немного легче.',
  },
  'Celerity 2': {
    name: 'Стремительность',
    desc: 'Заметно повышает твою скорость и реакцию.',
  },
  'Celerity 3': {
    name: 'Сверхчеловеческая стремительность',
    desc: 'Двигайся быстрее. Реагируй мгновеннее. Тело подчиняется тебе безупречно.',
  },
  'Celerity 4': {
    name: 'Великая стремительность',
    desc: 'Превзойди пределы смертного тела. Двигайся подобно молнии.',
  },
  'Celerity 5': {
    name: 'Сверхъестественная стремительность',
    desc: 'Ты подобен свету. Прорубай себе путь сквозь мир огнём.',
  },
  // Demonic
  'Deny the Mother': {
    name: 'Отвержение Естества',
    desc: 'На двадцать секунд ты неуязвим для огня.',
  },
  'Fear of the Void': {
    name: 'Страх Бездны',
    desc: 'Ненадолго повышает твою скорость и стойкость.',
  },
  Conflagration: {
    name: 'Воспламенение',
    desc: 'Преврати руки в смертоносные когти.',
  },
  Psychomachia: {
    name: 'Власть огня',
    desc: 'Испепели врагов огненным шаром.',
  },
  'Infernal Fireball': {
    name: 'Адский огненный шар',
    desc: 'Выпусти по цели разрывной огненный шар.',
  },
  'Wall of Fire': {
    name: 'Стена огня',
    desc: 'Огненная стрела? Огненный шар? Нет — стена огня!',
  },
  // Eoran
  'Empathic Bond': {
    name: 'Эмпатическая связь',
    desc: 'Коснись цели, чтобы ощутить её чувства и сиюминутные нужды; на короткое время тебя охватит одержимость ею.',
  },
  'Artistic Inspiration': {
    name: 'Художественное вдохновение',
    desc: 'Вдохнови других божественной творческой искрой, усиливая их искусство и поднимая настроение.',
  },
  'Familial Bond': {
    name: 'Семейные узы',
    desc: 'Создай временную духовную связь между двумя людьми — они смогут чувствовать местоположение и состояние друг друга.',
  },
  "Beauty's Restoration": {
    name: 'Возвращение красоты',
    desc: 'Направь силу Эоры, чтобы вернуть телу красоту и исцелить уродства.',
  },
  // Fae Trickery
  'Darkling Trickery': {
    name: 'Тёмные уловки',
    desc: 'Обезоружь жертв на расстоянии.',
  },
  Goblinism: {
    name: 'Гоблинизм',
    desc: 'Призови коварного гоблина, который вцепится врагу в лицо.',
  },
  'Chanjelin Ward': {
    name: 'Знак Чанджелина',
    desc: 'Начерти знак у своих ног. Жестокая ловушка отбрасывает жертв, кружит им голову, валит наземь и выбивает оружие из рук.',
  },
  'Riddle Phantastique': {
    name: 'Фантасмагорическая загадка',
    desc: 'Поставь жертве запутанную загадку — она не сможет действовать, пока не ответит.',
  },
  'Fae Wrath': {
    name: 'Гнев фей',
    desc: 'Обрушь град ударов на врагов.',
  },
  // Obfuscate
  'Cloak of Shadows': {
    name: 'Покров теней',
    desc: 'Слейся с тенями и оставайся незамеченным, пока не привлекаешь внимания. Любое движение развеет покров.',
  },
  'Unseen Presence': {
    name: 'Незримое присутствие',
    desc: 'Двигайся в толпе незамеченным. Стань невидимым даже на ходу.',
  },
  "Vanish from the Mind's Eye": {
    name: 'Исчезновение из мысленного взора',
    desc: 'Мгновенно исчезни из вида и сотри своё присутствие из недавней памяти.',
  },
  'Cloak the Gathering': {
    name: 'Сокрытие собрания',
    desc: 'Укрой себя и других в небольшой области. Все ближайшие союзники становятся невидимы.',
  },
  // Potence
  'Potence 1': {
    name: 'Могущество I',
    desc: 'Укрепи мышцы. Никогда не бей вполсилы.',
  },
  'Potence 2': {
    name: 'Могущество II',
    desc: 'Стань сильнее собственных мышц. Сокрушай людей и вещи.',
  },
  'Potence 3': {
    name: 'Могущество III',
    desc: 'Стань орудием разрушения. Поднимай и ломай то, что не поднять и не сломать.',
  },
  'Potence 4': {
    name: 'Могущество IV',
    desc: 'Стань неумолимой машиной, пока хватает витэ.',
  },
  'Potence 5': {
    name: 'Могущество V',
    desc: 'Покажи эту силу смертным — и они начнут поклоняться тебе как богу.',
  },
  // Presence
  Awe: {
    name: 'Благоговение',
    desc: 'Заставь окружающих восхищаться тобой. Кто отвернётся — тот столкнётся с последствиями.',
  },
  'Dread Gaze': {
    name: 'Устрашающий взор',
    desc: 'Пробуди страх в других одними лишь словами и взглядом.',
  },
  Kneel: {
    name: 'На колени',
    desc: 'Заставь окружающих преклонить колени.',
  },
  Summon: {
    name: 'Призыв',
    desc: 'Держи друзей близко, а врагов — ещё ближе. Телепортируй цель к себе.',
  },
 
  // Quietus
  'Silence of Death': {
    name: 'Тишина смерти',
    desc: 'Создай вокруг себя зону полнейшей тишины, сбивая с толку всё внутри неё.',
  },
  "Scorpion's Touch": {
    name: 'Касание скорпиона',
    desc: 'Создай мощное вещество, поджигающее врагов.',
  },
  "Baal's Caress": {
    name: 'Ласка Баала',
    desc: 'Преврати свою витэ в яд, уничтожающий всякую плоть, к которой он прикоснётся. Наносится на ОСТРОЕ оружие.',
  },
  'Taste of Death': {
    name: 'Вкус смерти',
    desc: 'Плюнь во врагов сгустком разъедающей крови.',
  },
  "Dagon's Call": {
    name: 'Зов Дагона',
    desc: 'Прокляни последнего, кого ты ударил, — пусть он утонет в собственной крови.',
  },
  // Siren
  'The Missing Voice': {
    name: 'Утерянный голос',
    desc: 'Брось свой голос в любую видимую тебе точку.',
  },
  'Phantom Speaker': {
    name: 'Призрачный голос',
    desc: 'Спроецируй голос любому, кого встречал, и говори с ним издалека.',
  },
  Madrigal: {
    name: 'Мадригал',
    desc: 'Спой песнь сирены — окружающие потянутся к тебе.',
  },
  "Siren's Beckoning": {
    name: 'Зов сирены',
    desc: 'Затяни неземную песнь, чтобы оглушить окружающих.',
  },
  'Shattering Crescendo': {
    name: 'Сокрушающее крещендо',
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
  const width = expanded ? screenWidth : Math.min(DEFAULT_W, screenWidth);
  const height = expanded ? screenHeight : Math.min(DEFAULT_H, screenHeight);
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
      <Icon name={props.icon} className="VampireClanSelection__infoIcon" />
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
        {t('lordHailedAs')} <b>{clan.lordTitle || t('lordFallback')}</b>
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
