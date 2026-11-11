export type WorkstationData = {
  id: number;
  name: string;
  workers_employed: number;
  workers_max: number;
  produce: string[];
  kind: string;
  type_of_produce: string;
  production_bonus: number;
  pool?: 'peasants' | 'artisans';
  icon?: string;
};

export type WarehouseItem = {
  id: string;
  name: string;
  quantity: number;
};

type ManorProductionStage = {
  id: 'processing' | 'workshop';
  station_id: number;
  name: string;
  kind: 'processing' | 'workshop';
  selected: string;
  options: {
    id: string;
    name: string;
    inputs: string[];
    produce: string[];
    points_per_unit: number;
  }[];
};

export type ManorIndustryData = {
  active: boolean;
  specialization?: string;
  stages?: ManorProductionStage[];
  last_production?: {
    processed: number;
    processed_good: string;
    consumed: number;
    points: number;
    material: string;
    material_name?: string;
  };
  smeltery_metal?: string;
  forge_metal?: string;
  metal_options?: string[];
  smeltery_options?: string[];
  forge_options?: string[];
  metal_names?: Record<string, string>;
  last_smeltery_metal?: string;
  last_forge_metal?: string;
  points: number;
  peasants: number;
  peasants_assigned: number;
  artisans: number;
  artisans_assigned: number;
  miners?: number;
  last_ore?: number;
  last_ingots?: number;
  last_forged_ingots?: number;
  points_per_ingot?: Record<string, number>;
  mining_options?: { id: string; name: string }[];
  mining_priority?: string | null;
  last_points?: number;
  last_sold_ore?: number;
  last_stored_ore?: number;
  has_report?: boolean;
  revision: number;
  recipes: {
    id: string;
    name: string;
    category: string;
    material: string;
    material_label: string;
    cost: number;
    units?: number;
    available: boolean;
    locked?: boolean;
    icon: string;
  }[];
};

export type ManorPanelData = {
  manor_name: string;
  manor_type: string;
  manor_patron_key: string;
  manor_origin: string;
  total_workers: number;
  workers_assigned: number;
  workers_free: number;
  productivity_last_cycle: number;
  estate_balance: number | null;
  estate_treasury_retention: number;
  estate_withdrawal_revision: number;
  warehouse: WarehouseItem[];
  warehouse_raw_sale: number;
  warehouse_processed_sale: number;
  warehouse_revision: number;
  warehouse_shipment_limit: number;
  industry: ManorIndustryData | null;
  workstations: WorkstationData[];
};
