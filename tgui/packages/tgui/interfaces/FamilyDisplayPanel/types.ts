export type FamilyDisplayEntry = {
  name: string;
  label?: string | null;
  details?: string[];
  accentColor?: string | null;
};

export type FamilyDisplaySection = {
  title: string;
  entries: FamilyDisplayEntry[];
};

export type FamilyTreeNode = FamilyDisplayEntry & {
  spouses?: FamilyTreeNode[];
  children?: FamilyTreeNode[];
  isSelf?: boolean;
  phantom?: boolean;
  generation?: number | null;
  parents?: string[];
};

export type FamilyDisplayData = {
  title: string;
  subtitle?: string;
  emptyMessage?: string;
  sections: FamilyDisplaySection[];
  tree?: FamilyTreeNode[];
};
