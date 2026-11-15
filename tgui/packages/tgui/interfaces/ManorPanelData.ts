export type WorkstationData = {
  id: number;
  name: string;
  workers_employed: number;
  workers_max: number;
  produce: string[];
  kind: string;
  type_of_produce: string;
  production_bonus: number;
};

export type ManorPanelData = {
  manor_name: string;
  manor_type: string;
  manor_type_label: string;
  manor_patron_name: string;
  manor_patron_key: string;
  manor_origin: string;
  total_workers: number;
  workers_assigned: number;
  workers_free: number;
  productivity_last_cycle: number;
  workstations: WorkstationData[];
};
