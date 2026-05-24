export type FamilyDisplayEntry = {
  name: string;
  label?: string | null;
  details?: string[];
  accentColor?: string | null;
  personRef?: string | null;
  descriptor?: string | null;
};

export type FamilyDisplaySection = {
  title: string;
  entries: FamilyDisplayEntry[];
};

export type FamilyTreeNode = FamilyDisplayEntry & {
  parentNodes?: FamilyTreeNode[];
  spouses?: FamilyTreeNode[];
  children?: FamilyTreeNode[];
  isSelf?: boolean;
  phantom?: boolean;
  cosmetic?: boolean;
  generation?: number | null;
  parents?: string[];
  personRef?: string | null;
  descriptor?: string | null;
};

export type FamilyDisplayData = {
  title: string;
  subtitle?: string;
  emptyMessage?: string;
  sections: FamilyDisplaySection[];
  tree?: FamilyTreeNode[];
};
