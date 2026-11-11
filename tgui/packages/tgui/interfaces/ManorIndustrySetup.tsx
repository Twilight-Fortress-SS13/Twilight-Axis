import { type CSSProperties, useEffect, useState } from 'react';
import { Button, Stack, Tabs } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Size = 'small' | 'medium' | 'big';
type Metal = string;
type Upgrade = 'expand_mine' | 'expand_forge' | 'unlock_steel';
type ResourceSelections = Record<string, string[]>;

type Plan = {
  artisans: number;
  specialization: string;
  processing_workers: number;
  workshop_workers: number;
  processing_material?: string | null;
  workshop_material?: string | null;
  raw_workers: Record<string, number>;
  resource_pool?: ResourceSelections;
  resource_unlocks?: ResourceSelections;
  miners?: number;
  smelters?: number;
  finishers?: number;
  expand_mine?: number;
  expand_forge?: number;
  unlock_steel?: number;
  smeltery_metal?: Metal;
  forge_metal?: Metal;
  metal?: Metal;
};

type ProductionMaterial = {
  id: string;
  name: string;
  description?: string;
  input_ids?: string[];
  ready_good_id?: string;
  requires_steel?: boolean | number;
  direct?: boolean | number;
  can_fund?: boolean | number;
};

type MaterialOption = ProductionMaterial & { unavailable?: string };

type ProductionLane = {
  id: string;
  name: string;
  processing_name: string;
  workshop_name: string;
  materials: ProductionMaterial[];
};

type WorksiteResource = {
  id: string;
  name: string;
  cost: number;
  base: boolean | number;
  free_in?: string[];
};

type RawWorksite = {
  id: string;
  name: string;
  capacity: number;
  resources?: WorksiteResource[];
  focus_limit?: number;
};

type PlanOption = {
  size: Size;
  limits: {
    population: number;
    artisan_cost?: number;
    mine_slots: number;
    finishers: number;
    points: number;
    mine_upgrade_cost?: number;
    forge_upgrade_cost?: number;
    steel_upgrade_cost?: number;
  };
  profile: Plan;
  default_profile: Plan;
  raw_workstations: RawWorksite[];
  saved: boolean;
};

type ManorSettings = {
  enabled: boolean | number;
  name: string;
  type: string;
  treasury_retention: number;
};

type ManorSetupData = {
  settings: ManorSettings;
  settings_revision: number;
  settings_error?: string | null;
  max_name_length?: number;
  manor_types: { id: string; name: string }[];
  plans_by_type: Record<string, PlanOption[]>;
  production_lanes: Record<string, ProductionLane[]>;
};

type SettingsDraft = Omit<ManorSettings, 'treasury_retention'> & {
  treasury_retention: number | '';
};

type PlanDrafts = Partial<Record<Size, Plan | null>>;
type EstatePlanDrafts = Partial<Record<string, PlanDrafts>>;

const sizeNames: Record<Size, string> = {
  small: 'Малое',
  medium: 'Среднее',
  big: 'Большое',
};

const upgrades: { id: Upgrade; name: string; description: string }[] = [
  {
    id: 'expand_mine',
    name: 'Расширение шахты',
    description: 'Добавляет пять рабочих мест в шахтах.',
  },
  {
    id: 'expand_forge',
    name: 'Расширение кузницы',
    description: 'Добавляет одно рабочее место в кузнице.',
  },
  {
    id: 'unlock_steel',
    name: 'Обработка стали',
    description: 'Позволяет плавить стальные слитки и изготавливать стальные изделия.',
  },
];

const panelStyle: CSSProperties = {
  padding: '9px 12px',
  border: '1px solid rgba(224,187,128,0.22)',
  borderRadius: '9px',
  background: 'linear-gradient(180deg, #2e1d0f, #21150b)',
};

const mutedColor = '#bba585';

const contentStyle = {
  background: 'linear-gradient(180deg, #20140c, #100a06)',
  color: '#ead9bb',
  '--button-background-default': '#6b4828',
  '--button-background-selected': '#a77739',
  '--tab-background-hover': '#382515',
  '--tab-background-selected': '#49321c',
  '--tab-color': '#bba585',
  '--tab-color-selected': '#ead9bb',
} as CSSProperties;

const countStyle: CSSProperties = {
  textAlign: 'right',
  fontVariantNumeric: 'tabular-nums',
  whiteSpace: 'nowrap',
};

type AllocationSliderProps = {
  label: string;
  value: number;
  max: number;
  onChange: (value: number) => void;
};

const populationRangeClass = 'ManorIndustrySetup__populationRange';
const populationRangeStyle = `
  .${populationRangeClass}::-webkit-slider-thumb {
    -webkit-appearance: none;
    box-sizing: border-box;
    width: 18px;
    height: 17px;
    border-radius: 4px;
    border: 1px solid #332315;
    background: #f0dab0;
  }
  .${populationRangeClass}::-moz-range-thumb {
    box-sizing: border-box;
    width: 18px;
    height: 17px;
    border-radius: 4px;
    border: 1px solid #332315;
    background: #f0dab0;
  }
  .${populationRangeClass}:focus-visible {
    outline: 2px solid #f0dab0;
    outline-offset: 3px;
  }
`;

function PopulationSplit(props: {
  peasants: number;
  artisans: number;
  maxArtisans: number;
  onChange: (artisans: number) => void;
}) {
  const { peasants, artisans, maxArtisans, onChange } = props;
  const peasantsShare = maxArtisans ? 1 - artisans / maxArtisans : 1;
  // The native slider places the thumb's center 9px inside either endpoint.
  const split = `calc(${peasantsShare * 100}% + ${9 - 18 * peasantsShare}px)`;
  return (
    <div style={{ display: 'grid', gap: '5px', marginTop: '8px' }}>
      <style>{populationRangeStyle}</style>
      <div style={{ display: 'flex', justifyContent: 'space-between', gap: '10px' }}>
        <span style={{ color: '#d6d3a2' }}>
          Крестьяне <strong>{peasants}</strong>
        </span>
        <span style={{ color: '#efb57b' }}>
          Ремесленники <strong>{artisans}</strong>
        </span>
      </div>
      <input
        className={populationRangeClass}
        aria-label="Ремесленники в населении"
        aria-valuetext={`Крестьяне ${peasants}, ремесленники ${artisans}`}
        type="range"
        dir="rtl"
        min={0}
        max={maxArtisans}
        step={1}
        disabled={maxArtisans < 1}
        value={artisans}
        onChange={(event) => onChange(event.currentTarget.valueAsNumber)}
        style={{
          appearance: 'none',
          display: 'block',
          width: '100%',
          height: '17px',
          margin: 0,
          border: 0,
          borderRadius: '5px',
          cursor: 'ew-resize',
          background: `linear-gradient(to right, #7c7c44 ${split}, #ae6f3e ${split})`,
        }}
      />
    </div>
  );
}

function AllocationSlider(props: AllocationSliderProps) {
  const { label, value, max, onChange } = props;
  return (
    <input
      aria-label={label}
      type="range"
      min={0}
      max={Math.max(max, 1)}
      step={1}
      disabled={max < 1}
      value={value}
      onChange={(event) => onChange(event.currentTarget.valueAsNumber)}
      style={{ width: '100%', margin: 0, accentColor: '#d7b065' }}
    />
  );
}

function Worksite(props: AllocationSliderProps & { group: string; slots: number }) {
  const { label, value, max, group, slots, onChange } = props;
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'minmax(10em, 1fr) 8em minmax(0, 1.25fr) 3.5em',
        alignItems: 'center',
        gap: '10px',
        minHeight: '29px',
      }}>
      <span>{label}</span>
      <span style={{ color: mutedColor }}>{group}</span>
      <AllocationSlider
        label={`Рабочие места в разделе «${label}»`}
        value={value}
        max={max}
        onChange={onChange}
      />
      <span style={countStyle}>{value}/{slots}</span>
    </div>
  );
}

function MetalChoice(props: {
  label: string;
  value: Metal;
  onChange: (value: Metal) => void;
}) {
  const { label, value, onChange } = props;
  return (
    <div role="group" aria-label={label}>
      <div style={{ color: mutedColor, marginBottom: '4px' }}>{label}</div>
      <Button selected={value === 'iron'} onClick={() => onChange('iron')}>
        Iron Ingot
      </Button>
      <Button selected={value === 'steel'} onClick={() => onChange('steel')}>
        Steel Ingot
      </Button>
    </div>
  );
}

function MaterialChoice(props: {
  id: string;
  label: string;
  materials: MaterialOption[];
  value?: string | null;
  showInputs?: boolean;
  onChange: (value: string) => void;
}) {
  const { id, label, materials, value, showInputs, onChange } = props;
  if (!materials.length) {
    return null;
  }
  const selected = selectedMaterial(materials, value);

  return (
    <label htmlFor={id} style={{ display: 'grid', gap: '4px' }}>
      <span style={{ color: mutedColor }}>{label}</span>
      {materials.length === 1 ? (
        <span id={id} title={materials[0].description}>
          {materials[0].name}
          {materials[0].unavailable && <span style={{ color: mutedColor }}> · {materials[0].unavailable}</span>}
        </span>
      ) : (
        <select
          id={id}
          name={id}
          value={selected?.id ?? ''}
          title={selected?.description}
          style={fieldStyle}
          onChange={(event) => onChange(event.currentTarget.value)}>
          {!selected && <option value="" disabled>Нет доступного сырья</option>}
          {materials.map((material) => (
            <option
              key={material.id}
              value={material.id}
              disabled={!!material.unavailable}
              title={material.description}>
              {material.name}
              {material.unavailable && ` (${material.unavailable})`}
            </option>
          ))}
        </select>
      )}
      {showInputs && selected?.description && (
        <span style={{ color: mutedColor }}>{selected.description}</span>
      )}
    </label>
  );
}

function selectedMaterial(materials: MaterialOption[], value?: string | null) {
  const available = materials.filter((material) => !material.unavailable);
  return available.find((material) => material.id === value) ?? available[0];
}

function rawWorkersAt(plan: Plan, id: string) {
  return plan.raw_workers?.[id] ?? (id === 'mining' ? plan.miners ?? 0 : 0);
}

function isFreeResource(resource: WorksiteResource, specialization: string) {
  return !!resource.base || !!resource.free_in?.includes(specialization);
}

function materialOptionsFor(lane: ProductionLane, plan: Plan, sites: RawWorksite[]) {
  const available = new Set<string>();
  const names = new Map<string, string>();
  for (const site of sites) {
    const unlocked = plan.resource_unlocks?.[site.id] ?? [];
    for (const resource of site.resources ?? []) {
      names.set(resource.id, resource.name);
      if (isFreeResource(resource, plan.specialization) || unlocked.includes(resource.id)) {
        available.add(resource.id);
      }
    }
  }
  function getOption(material: ProductionMaterial, acceptsReady: boolean): MaterialOption {
    if (material.requires_steel && !plan.unlock_steel) {
      return { ...material, unavailable: 'Требуется обработка стали' };
    }
    const missing = material.input_ids?.filter((id) => !available.has(id)) ?? [];
    if (!missing.length || (acceptsReady && material.ready_good_id && available.has(material.ready_good_id))) {
      return material;
    }
    const missingNames = missing.map((id) => names.get(id)).filter(Boolean);
    return {
      ...material,
      unavailable: missingNames.length === missing.length
        ? `Нужно открыть ${missingNames.join(', ')}`
        : 'Нужное сырьё недоступно',
    };
  }
  return {
    processing: lane.materials.filter((material) => !material.direct).map((material) => getOption(material, false)),
    workshop: lane.materials
      .filter((material) => material.can_fund == null || !!material.can_fund)
      .map((material) => getOption(material, true)),
  };
}

function toggleResource(
  selection: ResourceSelections | undefined,
  site: string,
  resource: string,
) {
  const current = selection?.[site] ?? [];
  return {
    ...selection,
    [site]: current.includes(resource)
      ? current.filter((id) => id !== resource)
      : [...current, resource],
  };
}

function resourceSelectionsDiffer(
  first: ResourceSelections | undefined,
  second: ResourceSelections | undefined,
) {
  return Object.keys({ ...first, ...second }).some((site) => {
    const firstIds = first?.[site] ?? [];
    const secondIds = second?.[site] ?? [];
    return (
      firstIds.length !== secondIds.length ||
      firstIds.some((id) => !secondIds.includes(id))
    );
  });
}

function plansDiffer(first: Plan, second: Plan) {
  const {
    raw_workers: firstWorkers,
    resource_pool: firstPool,
    resource_unlocks: firstUnlocks,
    ...firstSettings
  } = first;
  const {
    raw_workers: secondWorkers,
    resource_pool: secondPool,
    resource_unlocks: secondUnlocks,
    ...secondSettings
  } = second;
  const settingsKeys = Object.keys(firstSettings) as (keyof typeof firstSettings)[];
  return (
    settingsKeys.some((key) => firstSettings[key] !== secondSettings[key]) ||
    resourceSelectionsDiffer(firstPool, secondPool) ||
    resourceSelectionsDiffer(firstUnlocks, secondUnlocks) ||
    Object.keys({ ...firstWorkers, ...secondWorkers }).some(
      (id) => (firstWorkers?.[id] ?? 0) !== (secondWorkers?.[id] ?? 0),
    )
  );
}

const resourceRowStyle: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: 'minmax(6em, 1fr) 9.5em 8em',
  alignItems: 'center',
  gap: '8px',
  padding: '5px 8px',
};

function ManorResourcePlan(props: {
  sites: RawWorksite[];
  plan: Plan;
  pointsLeft: number;
  pointsTotal: number;
  onUnlock: (site: string, resource: string) => void;
  onFocus: (site: string, resource: string) => void;
}) {
  const { sites, plan, pointsLeft, pointsTotal, onUnlock, onFocus } = props;
  const [siteId, setSiteId] = useState<string>();
  const site = sites.find(({ id }) => id === siteId) ?? sites[0];
  if (!site) {
    return null;
  }

  const unlocked = plan.resource_unlocks?.[site.id] ?? [];
  const focused = plan.resource_pool?.[site.id] ?? [];
  const focusLimit = site.focus_limit ?? 3;

  return (
    <section style={panelStyle} aria-label="Добыча ресурсов">
      <Stack align="center" mb={0.6}>
        <Stack.Item grow bold>Угодья</Stack.Item>
        <Stack.Item color={mutedColor}>
          Очки развития {pointsLeft} / {pointsTotal}
        </Stack.Item>
      </Stack>
      <Tabs fluid>
        {sites.map((entry) => (
          <Tabs.Tab
            key={entry.id}
            selected={site.id === entry.id}
            onClick={() => setSiteId(entry.id)}>
            {entry.name}
          </Tabs.Tab>
        ))}
      </Tabs>
      <div
        style={{ marginTop: '8px', maxHeight: '370px', overflowY: 'auto' }}>
        <div
          style={{
            ...resourceRowStyle,
            position: 'sticky',
            top: 0,
            zIndex: 1,
            backgroundColor: '#2e1d0f',
            color: mutedColor,
          }}>
          <span>Ресурс</span>
          <span>Доступ</span>
          <span title="Выбранные ресурсы добывают чаще">
            Приоритет {focused.length}/{focusLimit}
          </span>
        </div>
        <ul
          aria-label={`Ресурсы угодья «${site.name}»`}
          style={{ listStyle: 'none', margin: 0, padding: 0 }}>
          {site.resources?.map((resource) => {
            const free = isFreeResource(resource, plan.specialization);
            const purchased = unlocked.includes(resource.id);
            const selected = focused.includes(resource.id);
            const affordable = pointsLeft >= resource.cost;
            return (
              <li
                key={resource.id}
                data-resource-id={resource.id}
                style={{
                  ...resourceRowStyle,
                  borderTop: '1px solid rgba(224,187,128,0.12)',
                }}>
                <span>{resource.name}</span>
                <div>
                  {free ? (
                    <span style={{ color: mutedColor }}>
                      {resource.base ? 'Базовый' : 'Специализация'}
                    </span>
                  ) : (
                    <Button
                      aria-label={`${purchased ? 'Закрыть' : 'Открыть'} ${resource.name}`}
                      disabled={!purchased && !affordable}
                      selected={purchased}
                      tooltip={purchased ? 'Вернуть очки развития' : undefined}
                      onClick={() => onUnlock(site.id, resource.id)}>
                      {purchased ? `Закрыть (+${resource.cost})` : `Открыть (${resource.cost})`}
                    </Button>
                  )}
                </div>
                <div>
                  <Button
                    aria-label={selected
                      ? `Убрать из приоритета ${resource.name}`
                      : `Добавить в приоритет ${resource.name}`}
                    aria-pressed={selected}
                    selected={selected}
                    disabled={!selected && ((!free && !purchased) || focused.length >= focusLimit)}
                    onClick={() => onFocus(site.id, resource.id)}>
                    {selected ? 'Выбран' : 'Выбрать'}
                  </Button>
                </div>
              </li>
            );
          })}
        </ul>
      </div>
    </section>
  );
}

function ManorProductionPlan(props: {
  manorType: string;
  lanes: ProductionLane[];
  plans: PlanOption[];
  size: Size;
  onSizeChange: (size: Size) => void;
  draft: Plan | null | undefined;
  onChange: (update: (plan: Plan) => Plan) => void;
  onReset: () => void;
}) {
  const {
    manorType,
    lanes,
    plans,
    size,
    onSizeChange,
    draft,
    onChange,
    onReset,
  } = props;
  const [viewedUpgrade, setViewedUpgrade] = useState<Upgrade>('expand_mine');
  const [view, setView] = useState<'work' | 'resources'>('work');
  const selected = plans.find((entry) => entry.size === size);
  if (!selected || !lanes.length) {
    return null;
  }

  const { limits, profile, default_profile, raw_workstations, saved } = selected;
  const plan = draft === null ? default_profile : (draft ?? profile);
  const resourceSites = raw_workstations.filter((site) => site.resources?.length);
  const showResources = view === 'resources' && resourceSites.length > 0;
  const lane = lanes.find((entry) => entry.id === plan.specialization) ?? lanes[0];
  const mining = manorType === 'mining_settlement';
  const smith = mining && lane.id === 'smith';
  const { processing: processingOptions, workshop: workshopOptions } =
    materialOptionsFor(lane, plan, resourceSites);
  const artisanCost = limits.artisan_cost ?? 3;
  const artisanMax = Math.floor(limits.population / artisanCost);
  const peasants = limits.population - artisanCost * plan.artisans;
  const processingWorkers = plan.processing_workers ?? plan.smelters ?? 0;
  const workshopWorkers = plan.workshop_workers ?? plan.finishers ?? 0;
  const workshopSlots = Math.min(
    plan.artisans,
    limits.finishers + (plan.expand_forge ?? 0),
  );
  const assignedPeasants = raw_workstations.reduce(
    (total, station) => total + rawWorkersAt(plan, station.id),
    0,
  );
  const availableUpgrades = upgrades
    .filter(({ id }) => id === 'expand_forge' || (id === 'expand_mine' ? mining : smith))
    .map((entry) =>
      entry.id === 'expand_forge' && !smith
        ? {
            ...entry,
            name: 'Расширение мастерской',
            description: 'Добавляет одно рабочее место в мастерской выбранной специализации.',
          }
        : entry,
    );
  const upgradePrices: Record<Upgrade, number> = {
    expand_mine: limits.mine_upgrade_cost ?? 1,
    expand_forge: limits.forge_upgrade_cost ?? 2,
    unlock_steel: limits.steel_upgrade_cost ?? 2,
  };
  function pointsSpent(current: Plan) {
    const infrastructure = upgrades.reduce(
      (total, { id }) =>
        total +
        (current[id] && (id !== 'unlock_steel' || current.specialization === 'smith')
          ? upgradePrices[id]
          : 0),
      0,
    );
    let resourcePoints = 0;
    for (const site of resourceSites) {
      const unlocked = current.resource_unlocks?.[site.id] ?? [];
      for (const resource of site.resources ?? []) {
        if (unlocked.includes(resource.id) && !isFreeResource(resource, current.specialization)) {
          resourcePoints += resource.cost;
        }
      }
    }
    return infrastructure + resourcePoints;
  }
  const pointsLeft = limits.points - pointsSpent(plan);
  const upgrade = availableUpgrades.find(({ id }) => id === viewedUpgrade)
    ?? availableUpgrades[0];
  const upgradeSelected = !!plan[upgrade.id];
  const upgradePrice = upgradePrices[upgrade.id];

  function rawCapacity(station: RawWorksite, current: Plan) {
    const expansion = mining && station.id === 'mining' ? 5 * (current.expand_mine ?? 0) : 0;
    return station.capacity + expansion;
  }

  function edit(update: Partial<Plan> | ((plan: Plan) => Partial<Plan>)) {
    onChange((previous) => {
      const change = typeof update === 'function' ? update(previous) : update;
      const next = { ...previous, ...change };
      if (change.specialization && change.specialization !== previous.specialization) {
        const newLane = lanes.find((entry) => entry.id === change.specialization);
        if (!newLane) {
          return previous;
        }
        next.processing_material = newLane.materials[0]?.id ?? null;
        next.workshop_material = newLane.materials[0]?.id ?? null;
        if (newLane.id === 'smith' && pointsSpent(next) > limits.points) {
          next.unlock_steel = 0;
        }
      }
      if (pointsSpent(next) > limits.points) {
        return previous;
      }

      const resourceUnlocks: ResourceSelections = {};
      const resourcePool: ResourceSelections = {};
      for (const site of resourceSites) {
        const resources = site.resources ?? [];
        const available = new Set(
          resources.filter((resource) => isFreeResource(resource, next.specialization))
            .map(({ id }) => id),
        );
        const unlocked = (next.resource_unlocks?.[site.id] ?? []).filter(
          (id) => !available.has(id) && resources.some((resource) => resource.id === id),
        );
        for (const id of unlocked) {
          available.add(id);
        }
        const focused = (next.resource_pool?.[site.id] ?? [])
          .filter((id) => available.has(id))
          .slice(0, site.focus_limit ?? 3);
        if (unlocked.length > 0) {
          resourceUnlocks[site.id] = unlocked;
        }
        if (focused.length > 0) {
          resourcePool[site.id] = focused;
        }
      }
      next.resource_unlocks = resourceUnlocks;
      next.resource_pool = resourcePool;
      const nextLane = lanes.find((entry) => entry.id === next.specialization);
      if (nextLane?.materials.length) {
        const { processing, workshop } = materialOptionsFor(nextLane, next, resourceSites);
        if (next.specialization === 'smith') {
          next.smeltery_metal = selectedMaterial(processing, next.smeltery_metal ?? next.metal)?.id ?? 'iron';
          next.forge_metal = selectedMaterial(workshop, next.forge_metal ?? next.metal)?.id ?? 'iron';
        } else {
          next.processing_material = selectedMaterial(processing, next.processing_material)?.id ?? null;
          next.workshop_material = selectedMaterial(workshop, next.workshop_material)?.id ?? null;
        }
      } else if (change.unlock_steel === 0) {
        next.smeltery_metal = 'iron';
        next.forge_metal = 'iron';
      }

      let availablePeasants = limits.population - artisanCost * next.artisans;
      next.raw_workers = Object.fromEntries(
        raw_workstations.map((station) => {
          const assigned = Math.min(
            rawWorkersAt(next, station.id),
            rawCapacity(station, next),
            availablePeasants,
          );
          availablePeasants -= assigned;
          return [station.id, assigned];
        }),
      );
      next.workshop_workers = Math.min(
        next.workshop_workers ?? next.finishers ?? 0,
        limits.finishers + (next.expand_forge ?? 0),
        next.artisans,
      );
      next.processing_workers = Math.min(
        next.processing_workers ?? next.smelters ?? 0,
        next.artisans - next.workshop_workers,
      );
      if (mining) {
        next.miners = rawWorkersAt(next, 'mining');
      }
      if (next.specialization === 'smith') {
        next.smelters = next.processing_workers;
        next.finishers = next.workshop_workers;
      }
      return next;
    });
  }

  function assignRawWorkers(id: string, workers: number) {
    edit((current) => ({ raw_workers: { ...current.raw_workers, [id]: workers } }));
  }

  return (
    <>
      <Tabs fluid>
        {plans.map((entry) => (
          <Tabs.Tab
            key={entry.size}
            selected={entry.size === size}
            onClick={() => onSizeChange(entry.size)}>
            {sizeNames[entry.size]}
          </Tabs.Tab>
        ))}
      </Tabs>
      {resourceSites.length > 0 && (
        <Tabs fluid>
          <Tabs.Tab selected={!showResources} onClick={() => setView('work')}>
            Работы и улучшения
          </Tabs.Tab>
          <Tabs.Tab selected={showResources} onClick={() => setView('resources')}>
            Добыча
          </Tabs.Tab>
        </Tabs>
      )}
      {showResources ? (
        <ManorResourcePlan
          sites={resourceSites}
          plan={plan}
          pointsLeft={pointsLeft}
          pointsTotal={limits.points}
          onUnlock={(site, resource) =>
            edit((current) => ({
              resource_unlocks: toggleResource(current.resource_unlocks, site, resource),
            }))
          }
          onFocus={(site, resource) =>
            edit((current) => ({
              resource_pool: toggleResource(current.resource_pool, site, resource),
            }))
          }
        />
      ) : (
        <>
          <section style={panelStyle}>
            <Stack justify="space-between" bold>
              <Stack.Item>Население</Stack.Item>
              <Stack.Item style={countStyle}>
                {assignedPeasants + processingWorkers + workshopWorkers}/{peasants + plan.artisans}
              </Stack.Item>
            </Stack>
            <PopulationSplit
              peasants={peasants}
              artisans={plan.artisans}
              maxArtisans={artisanMax}
              onChange={(artisans) => edit({ artisans })}
            />
          </section>
          <section style={panelStyle}>
            <div
              role="group"
              aria-label="Специализация"
              style={{ marginBottom: '8px' }}>
              <div style={{ marginBottom: '4px', color: mutedColor }}>
                Специализация
              </div>
              {lanes.length === 1 ? (
                <strong>{lane.name}</strong>
              ) : (
                lanes.map((entry) => (
                  <Button
                    key={entry.id}
                    aria-pressed={entry.id === lane.id}
                    selected={entry.id === lane.id}
                    onClick={() => {
                      if (entry.id !== lane.id) {
                        edit({ specialization: entry.id });
                      }
                    }}>
                    {entry.name}
                  </Button>
                ))
              )}
            </div>
            <div style={{ fontWeight: 700, marginBottom: '5px' }}>
              Рабочие места
            </div>
            {raw_workstations.map((station) => {
              const workers = rawWorkersAt(plan, station.id);
              const capacity = rawCapacity(station, plan);
              return (
                <Worksite
                  key={station.id}
                  label={station.name}
                  group="Крестьяне"
                  slots={capacity}
                  value={workers}
                  max={Math.min(capacity, peasants - assignedPeasants + workers)}
                  onChange={(value) => assignRawWorkers(station.id, value)}
                />
              );
            })}
            <Worksite
              label={lane.processing_name}
              group="Ремесленники"
              slots={plan.artisans}
              value={processingWorkers}
              max={plan.artisans - workshopWorkers}
              onChange={(processing_workers) => edit({ processing_workers })}
            />
            <Worksite
              label={lane.workshop_name}
              group="Ремесленники"
              slots={workshopSlots}
              value={workshopWorkers}
              max={Math.min(workshopSlots, plan.artisans - processingWorkers)}
              onChange={(workshop_workers) => edit({ workshop_workers })}
            />
            {lane.materials.length > 0 && (
              <div style={materialGridStyle}>
                <MaterialChoice
                  id={smith ? 'manor-smeltery-metal' : 'manor-processing-material'}
                  label={smith ? 'Металл плавильни' : 'Результат переработки'}
                  materials={processingOptions}
                  value={smith ? plan.smeltery_metal ?? plan.metal : plan.processing_material}
                  showInputs
                  onChange={(value) =>
                    edit(smith ? { smeltery_metal: value } : { processing_material: value })
                  }
                />
                <MaterialChoice
                  id={smith ? 'manor-forge-metal' : 'manor-workshop-material'}
                  label={smith ? 'Металл кузницы' : 'Материал для мастерской'}
                  materials={workshopOptions}
                  value={smith ? plan.forge_metal ?? plan.metal : plan.workshop_material}
                  onChange={(value) =>
                    edit(smith ? { forge_metal: value } : { workshop_material: value })
                  }
                />
              </div>
            )}
            {smith && !lane.materials.length && !!plan.unlock_steel && (
              <div style={materialGridStyle}>
                <MetalChoice
                  label="Металл плавильни"
                  value={plan.smeltery_metal ?? plan.metal ?? 'iron'}
                  onChange={(smeltery_metal) => edit({ smeltery_metal })}
                />
                <MetalChoice
                  label="Металл кузницы"
                  value={plan.forge_metal ?? plan.metal ?? 'iron'}
                  onChange={(forge_metal) => edit({ forge_metal })}
                />
              </div>
            )}
          </section>
          <section style={panelStyle}>
            <Stack align="center" mb={0.6}>
              <Stack.Item grow bold>
                Улучшения
              </Stack.Item>
              <Stack.Item color={mutedColor}>
                Очки развития {pointsLeft} / {limits.points}
              </Stack.Item>
            </Stack>
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: '44% minmax(0, 1fr)',
                gap: '12px',
              }}>
              <Tabs vertical>
                {availableUpgrades.map((entry) => (
                  <Tabs.Tab
                    key={entry.id}
                    selected={entry.id === upgrade.id}
                    onClick={() => setViewedUpgrade(entry.id)}
                    rightSlot={plan[entry.id] ? 'Выбрано' : undefined}>
                    {entry.name}
                  </Tabs.Tab>
                ))}
              </Tabs>
              <div style={{ padding: '4px 0' }}>
                <div style={{ marginBottom: '5px' }}>{upgrade.description}</div>
                <Stack align="center" wrap>
                  <Stack.Item color={mutedColor}>
                    {upgradePrice} {upgradePrice === 1 ? 'очко' : 'очка'}
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      selected={upgradeSelected}
                      disabled={!upgradeSelected && pointsLeft < upgradePrice}
                      onClick={() =>
                        edit({ [upgrade.id]: upgradeSelected ? 0 : 1 })
                      }>
                      {upgradeSelected ? 'Убрать' : 'Выбрать'}
                    </Button>
                  </Stack.Item>
                </Stack>
              </div>
            </div>
          </section>
        </>
      )}
      {(saved || draft) && (
        <div style={{ textAlign: 'right' }}>
          <Button onClick={onReset}>
            {draft === null ? 'Отменить сброс' : 'Сбросить план'}
          </Button>
        </div>
      )}
    </>
  );
}

const materialGridStyle: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
  gap: '12px',
  marginTop: '9px',
};

const fieldStyle: CSSProperties = {
  minWidth: 0,
  padding: '6px 8px',
  border: '1px solid rgba(224,187,128,0.36)',
  borderRadius: '4px',
  backgroundColor: '#20140c',
  color: '#ead9bb',
  font: 'inherit',
};

function ManorGeneralSettings(props: {
  settings: SettingsDraft;
  manorTypes: ManorSetupData['manor_types'];
  maxNameLength?: number;
  onChange: (change: Partial<SettingsDraft>) => void;
}) {
  const { settings, manorTypes, maxNameLength, onChange } = props;
  return (
    <section style={panelStyle} aria-label="Общие настройки поместья">
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'minmax(10em, 2fr) minmax(0, 3fr)',
          alignItems: 'center',
          gap: '12px',
          padding: '4px 0',
        }}>
        <span>Наличие поместья</span>
        <div>
          <Button
            aria-label="Наличие поместья"
            aria-pressed={!!settings.enabled}
            selected={!!settings.enabled}
            onClick={() => onChange({ enabled: !settings.enabled })}>
            {settings.enabled ? 'Включено' : 'Отключено'}
          </Button>
        </div>
        <label htmlFor="manor-name">Название</label>
        <input
          id="manor-name"
          name="manor-name"
          type="text"
          style={fieldStyle}
          value={settings.name}
          maxLength={maxNameLength}
          onChange={(event) => onChange({ name: event.currentTarget.value })}
        />
        <label htmlFor="manor-type">Тип поместья</label>
        <select
          id="manor-type"
          name="manor-type"
          style={fieldStyle}
          value={settings.type}
          onChange={(event) => onChange({ type: event.currentTarget.value })}>
          {manorTypes.map(({ id, name }) => (
            <option value={id} key={id}>
              {name}
            </option>
          ))}
        </select>
        <label htmlFor="manor-treasury-retention">Доля дохода в казну имения</label>
        <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
          <input
            id="manor-treasury-retention"
            name="manor-treasury-retention"
            type="number"
            style={{ ...fieldStyle, width: '5em' }}
            min={0}
            max={100}
            step={1}
            value={settings.treasury_retention}
            onChange={(event) => {
              const { value, valueAsNumber } = event.currentTarget;
              onChange({
                treasury_retention: value === '' ? '' : valueAsNumber,
              });
            }}
          />
          <span aria-hidden="true">%</span>
        </div>
      </div>
    </section>
  );
}

export function ManorIndustrySetup() {
  const { act, data } = useBackend<ManorSetupData>();
  const [tab, setTab] = useState<'general' | 'production'>('general');
  const [size, setSize] = useState<Size>('small');
  const [settingsDraft, setSettingsDraft] = useState<Partial<SettingsDraft>>({});
  const [planDrafts, setPlanDrafts] = useState<EstatePlanDrafts>({});
  const [pendingRevision, setPendingRevision] = useState<number | null>(null);
  const { settings, settings_revision, settings_error, plans_by_type, production_lanes } = data;

  useEffect(() => {
    if (pendingRevision === null || settings_revision <= pendingRevision) {
      return;
    }
    if (!settings_error) {
      setSettingsDraft({});
      setPlanDrafts({});
    }
    setPendingRevision(null);
  }, [pendingRevision, settings_revision, settings_error]);

  if (!settings) {
    return null;
  }

  const pending = pendingRevision !== null;
  const editedSettings = { ...settings, ...settingsDraft };
  const manorType = editedSettings.type;
  const plans = plans_by_type[manorType] ?? [];
  const lanes = production_lanes[manorType] ?? [];
  const showProduction = plans.length > 0 && lanes.length > 0;
  const productionSelected = showProduction && tab === 'production';
  const profileChanges: EstatePlanDrafts = {};
  for (const [type, drafts] of Object.entries(planDrafts)) {
    const changes: PlanDrafts = {};
    for (const option of plans_by_type[type] ?? []) {
      const draft = drafts?.[option.size];
      if (draft === null && option.saved) {
        changes[option.size] = null;
      } else if (draft && plansDiffer(draft, option.profile)) {
        changes[option.size] = draft;
      }
    }
    if (Object.keys(changes).length > 0) {
      profileChanges[type] = changes;
    }
  }

  const changed =
    !!editedSettings.enabled !== !!settings.enabled ||
    editedSettings.name !== settings.name ||
    editedSettings.type !== settings.type ||
    editedSettings.treasury_retention !== settings.treasury_retention ||
    Object.keys(profileChanges).length > 0;
  const retention = editedSettings.treasury_retention;
  const validRetention =
    typeof retention === 'number' &&
    Number.isInteger(retention) &&
    retention >= 0 &&
    retention <= 100;

  function updatePlan(update: (plan: Plan) => Plan) {
    const option = plans.find((entry) => entry.size === size);
    if (!option) {
      return;
    }
    setPlanDrafts((current) => {
      const drafts = current[manorType];
      const draft = drafts?.[size];
      const plan =
        draft === null ? option.default_profile : (draft ?? option.profile);
      return { ...current, [manorType]: { ...drafts, [size]: update(plan) } };
    });
  }

  function resetPlan() {
    const option = plans.find((entry) => entry.size === size);
    setPlanDrafts((current) => {
      const drafts = { ...current[manorType] };
      if (option?.saved && drafts[size] !== null) {
        drafts[size] = null;
      } else {
        delete drafts[size];
      }
      return { ...current, [manorType]: drafts };
    });
  }

  function applySettings() {
    if (pending || !changed || !validRetention) {
      return;
    }
    setPendingRevision(settings_revision);
    act('save_settings', {
      settings: {
        ...editedSettings,
        enabled: Number(!!editedSettings.enabled),
        treasury_retention: retention,
      },
      profiles: profileChanges,
    });
  }

  return (
    <Window title="Настройки поместья" width={620} height={productionSelected ? 650 : 360}>
      <Window.Content scrollable style={contentStyle}>
        <div style={{ display: 'grid', gap: '8px', margin: '8px' }}>
          <div inert={pending} style={{ display: 'grid', gap: '8px' }}>
            <Tabs fluid>
              <Tabs.Tab
                selected={!productionSelected}
                onClick={() => setTab('general')}>
                Общее
              </Tabs.Tab>
              {showProduction && (
                <Tabs.Tab
                  selected={productionSelected}
                  onClick={() => setTab('production')}>
                  Производство
                </Tabs.Tab>
              )}
            </Tabs>
            {productionSelected ? (
              <ManorProductionPlan
                key={manorType}
                manorType={manorType}
                lanes={lanes}
                plans={plans}
                size={size}
                onSizeChange={setSize}
                draft={planDrafts[manorType]?.[size]}
                onChange={updatePlan}
                onReset={resetPlan}
              />
            ) : (
              <ManorGeneralSettings
                settings={editedSettings}
                manorTypes={data.manor_types}
                maxNameLength={data.max_name_length}
                onChange={(change) =>
                  setSettingsDraft((previous) => ({ ...previous, ...change }))
                }
              />
            )}
          </div>
          <div
            style={{
              alignItems: 'center',
              background: '#171009',
              borderTop: '1px solid rgba(224,187,128,0.22)',
              bottom: 0,
              display: 'flex',
              gap: '10px',
              padding: '7px 0 2px',
              position: 'sticky',
              zIndex: 1,
            }}>
            <Stack.Item grow color={mutedColor}>
              {settings_error && <span role="alert">{settings_error}</span>}
              {!settings_error && !validRetention && (
                <span role="alert">Введите целое число от 0 до 100.</span>
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                disabled={pending || !changed || !validRetention}
                onClick={applySettings}>
                Применить
              </Button>
            </Stack.Item>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
}
