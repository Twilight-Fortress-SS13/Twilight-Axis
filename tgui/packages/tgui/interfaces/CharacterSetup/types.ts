export type IdentityData = {
  real_name: string;
  nickname: string;
  pronouns: string;
  titles: string;
  clothes: string;
  voice_type: string;
  voice_pack: string;
  accent?: string;
  voice_color?: string;
  voice_pitch?: string | number;
  highlight_color?: string;
  dnr_pref?: boolean;
  combat_music?: string;
  domhand?: string;
};

export type AppearanceData = {
  species: string;
  subspecies: string;
  origin: string;
  statpack: string;
  faith: string;
  patron: string;
  extra_language: string;
  gender_label: string;
  body_is_feminine?: boolean;
  age: string | number;
  hair_color: string;
  eye_color: string;
  skin_tone?: string;
  uses_skin_tones?: boolean;
  update_mutant_colors?: boolean;
  mutant_colors_available?: boolean;
  mutant_color_1?: string;
  mutant_color_2?: string;
  mutant_color_3?: string;
  body_size?: string | number;
  taur_type: string;
  taur_color: string;
  taur_available?: boolean;
  statpack_virtuous?: boolean;
  race_bonus: string;
  race_bonus_available?: boolean;
};

export type VirtuesData = {
  virtue: string;
  virtue_two: string;
  vices: string[];
};

export type RoleplayData = {
  flavortext: string;
  ooc_notes: string;
  rumour: string;
  noble_gossip: string;
  headshot_link: string;
  lich_headshot_link: string;
  vampire_headshot_link: string;
  nsfwflavortext: string;
  erpprefs: string;
  descriptor_count?: number;
  culinary_count?: number;
  sfw_gallery_count?: number;
  nsfw_gallery_count?: number;
  music_url?: string;
  song_artist?: string;
  song_title?: string;
  sfw_gallery?: string[];
  nsfw_gallery?: string[];
  have_manor?: boolean;
  manor_name?: string;
  manor_type?: string;
};

export type BodyMarkingSummary = {
  zone: string;
  label: string;
  count: number;
  names: string[];
};

export type BodyMarkingOption = {
  name: string;
  icon?: string | null;
  icon_state?: string | null;
  icon_class_name?: string | null;
};

export type BodyMarkingCatalog = {
  zone: string;
  label: string;
  options: BodyMarkingOption[];
};

export type SlotSummary = {
  index: number;
  name: string;
  occupied_class?: string | null;
  current: boolean;
  empty: boolean;
};

export type JobEntry = {
  id: string;
  name: string;
  current_pref: 'never' | 'low' | 'medium' | 'high' | string;
  current_pref_label: string;
  disabled_reason?: string | null;
  tutorial?: string;
  slots?: number;
  assigned_slot?: string;
  column?: number;
  group?: string;
  separator_before?: boolean;
};

export type JobSlotChoice = {
  id: string;
  label: string;
  current: boolean;
};

export type CustomizerSummary = {
  id: string;
  name: string;
  disabled: boolean;
  choice_name: string;
  option_count: number;
  current_accessory_name: string;
  icon?: string | null;
  icon_state?: string | null;
  group?: 'body' | 'simple' | string;
};

export type HairCustomizer = {
  id: string;
  name: string;
  current_accessory_name: string;
  choice_name: string;
  hair_color?: string;
  natural_gradient?: string;
  natural_color?: string;
  dye_gradient?: string;
  dye_color?: string;
} | null;

export type ChoiceGroup = {
  id: string;
  name: string;
  current: boolean;
};

export type CustomizerOption = {
  id: string;
  name: string;
  icon?: string | null;
  icon_state?: string | null;
  icon_class_name?: string | null;
};

export type ActiveCustomizer = {
  id: string;
  name: string;
  disabled: boolean;
  allows_disabling: boolean;
  can_change_choice: boolean;
  choice_id?: string | null;
  choice_name: string;
  choice_groups?: ChoiceGroup[];
  current_accessory_name: string;
  selected_accessory_id?: string | null;
  option_count: number;
  total_filtered: number;
  window_start?: number;
  window_size?: number;
  search_query?: string;
  options: CustomizerOption[];
  allows_accessory_color_customization?: boolean;
  accessory_color_labels?: string[];
  accessory_color_values?: string[];
  group?: 'body' | 'simple' | string;
  is_hair?: boolean;
  hair_color?: string;
  natural_gradient?: string;
  natural_color?: string;
  dye_gradient?: string;
  dye_color?: string;
  custom_hair_available?: boolean;
  custom_hair_applied?: boolean;
};

export type SimpleCustomizer = {
  id: string;
  name: string;
  disabled: boolean;
  allows_disabling: boolean;
  can_change_choice: boolean;
  choice_name: string;
  choice_groups?: ChoiceGroup[];
  current_accessory_name: string;
  selected_accessory_id?: string | null;
  option_count: number;
  options: CustomizerOption[];
  allows_accessory_color_customization?: boolean;
  accessory_color_labels?: string[];
  accessory_color_values?: string[];
  size_label?: string;
  size_value?: string | number | null;
  size_var_name?: string | null;
  size_is_numeric?: boolean;
  size_options?: SelectionOption[];
  size_selected_id?: string | null;
};

export type AntagRole = {
  id: string;
  name: string;
  enabled: boolean;
  disabled_reason?: string | null;
};

export type VillainSettings = {
  lich_headshot_link?: string | null;
  vampire_headshot_link?: string | null;
  qsr_pref?: boolean;
  vampire_skin?: string | null;
  vampire_eyes?: string | null;
  vampire_hair?: string | null;
  vampire_ears?: string | null;
  storyteller_enabled?: boolean;
  preset_bounty_enabled?: boolean;
  preset_bounty_poster?: string;
  preset_bounty_wretch_severity?: string;
  preset_bounty_bandit_severity?: string;
  preset_bounty_vagabond_severity?: string;
  preset_bounty_crime?: string;
};

export type SystemSettings = {
  preview_floor?: string;
  preview_floor_name?: string;
  tgui_theme?: string | null;
  tgui_theme_name?: string | null;
  parchment_skin_name?: string | null;
  statbrowser_theme_name?: string | null;
  tgui_lock?: boolean;
  ambientocclusion?: boolean;
  windowflashing?: boolean;
  clientfps?: number;
  auto_fit_viewport?: boolean;
  widescreenpref?: boolean;
  chat_on_map?: boolean;
  see_chat_non_mob?: boolean;
  buttons_locked?: boolean;
  anonymize?: boolean;
  masked_examine?: boolean;
  full_examine?: boolean;
  mute_animal_emotes?: boolean;
  autoconsume?: boolean;
  no_examine_blocks?: boolean;
  no_autopunctuate?: boolean;
  no_language_fonts?: boolean;
  no_language_icon?: boolean;
  no_redflash?: boolean;
  is_admin?: boolean;
  play_admin_midis?: boolean;
  hear_adminhelps?: boolean;
  asaycolor?: string | null;
  can_edit_asaycolor?: boolean;
  deadmin_always?: boolean;
  deadmin_antag?: boolean;
  deadmin_head?: boolean;
  schizo_voice?: boolean;
  can_use_donor_visuals?: boolean;
  donor_ooc_color?: boolean;
  donor_ooc_icon?: boolean;
  donor_examine_icon?: boolean;
  examine_theme_name?: string;
  deadmin_always_forced?: boolean;
  deadmin_antag_forced?: boolean;
  deadmin_head_forced?: boolean;
};

export type KeybindEntry = {
  id: string;
  label: string;
};

export type KeybindCategory = {
  name: string;
  bindings: KeybindEntry[];
};

export type SelectionOption = {
  id: string;
  name: string;
  description?: string;
  meta?: string;
  current?: boolean;
  group?: string;
  icon?: string | null;
  icon_state?: string | null;
  icon_class_name?: string | null;
};

export type ContextSelector = {
  title?: string;
  current?: string;
  options?: SelectionOption[];
};

export type ViceOption = {
  id: string;
  name: string;
  description?: string;
  selected?: boolean;
};

export type PreferenceLimits = {
  voice_pitch_min?: number;
  voice_pitch_max?: number;
  body_size_min?: number;
  body_size_max?: number;
  vice_limit?: number;
};

export type DescriptorChoiceEntry = {
  id: string;
  name: string;
  value: string;
  options: SelectionOption[];
};

export type CustomDescriptorEntry = {
  index: number;
  visible: boolean;
  prefix_id: string;
  prefix_label: string;
  content: string;
  prefix_options: SelectionOption[];
};

export type DescriptorEditorData = {
  entries: DescriptorChoiceEntry[];
  custom_entries: CustomDescriptorEntry[];
};

export type CulinaryChoice = {
  key: 'cuisine' | 'dish' | 'drink';
  label: string;
  value: string;
};

export type CulinaryOptionCatalog = {
  cuisine: SelectionOption[];
  dish: SelectionOption[];
  drink: SelectionOption[];
};

export type CulinaryEditorData = {
  entries: CulinaryChoice[];
};

export type FamiliarPlaneData = {
  planar_origin: string;
  plane_name: string;
  familiar_name: string;
  familiar_pronouns: string;
  familiar_headshot_link: string;
  familiar_flavortext: string;
  familiar_ooc_notes: string;
  familiar_ooc_extra_link: string;
  familiar_specie: string;
  lore_blurb?: string;
  species_options: SelectionOption[];
};

export type FamiliarEditorData = {
  entries: FamiliarPlaneData[];
  pronoun_options: SelectionOption[];
};

export type CharacterPreviewData = {
  map_id?: string | null;
  control_generation?: number;
  grid_size?: number;
};

export type Data = {
  loaded_slot: number;
  max_save_slots: number;
  slot_summaries: SlotSummary[];
  player_quality: string;
  player_quality_color?: string | null;
  triumphs?: string | number | null;
  loadout_count: number;
  species_warning?: string | null;
  identity: IdentityData;
  appearance: AppearanceData;
  virtues: VirtuesData;
  roleplay: RoleplayData;
  body_markings: BodyMarkingSummary[];
  body_marking_catalog?: BodyMarkingCatalog[];
  customizer_summaries: CustomizerSummary[];
  genital_customizers: SimpleCustomizer[];
  body_context_customizers?: SimpleCustomizer[];
  hair_customizer: HairCustomizer;
  facial_hair_customizer?: HairCustomizer;
  hair_option_catalog?: Record<string, CustomizerOption[]>;
  active_customizer?: ActiveCustomizer | null;
  job_entries: JobEntry[];
  job_slot_target?: string | null;
  job_slot_choices?: JobSlotChoice[];
  current_joblessrole?: string;
  antag_roles?: AntagRole[];
  villain_settings?: VillainSettings;
  system_settings?: SystemSettings;
  keybind_mode?: string;
  keybinding_catalog?: KeybindCategory[];
  keybinding_values?: Record<string, string[]>;
  voice_type_choices?: string[];
  context_selectors?: Record<string, ContextSelector>;
  context_selector_catalog?: Record<string, ContextSelector>;
  vice_catalog?: ViceOption[];
  selected_vices?: string[];
  preference_limits?: PreferenceLimits;
  preview_floor_options?: { id: string; name: string }[];
  descriptor_editor?: DescriptorEditorData;
  culinary_editor?: CulinaryEditorData;
  culinary_option_catalog?: CulinaryOptionCatalog;
  familiar_editor?: FamiliarEditorData;
  character_preview?: CharacterPreviewData;
};

export type MainTab = 'general' | 'appearance' | 'markings' | 'notes' | 'classes' | 'loadout' | 'antags' | 'system' | 'keys';

export type DialogTab = 'job_slot' | 'feature' | 'gender' | 'vices' | 'descriptors' | 'culinary' | 'familiar' | 'manor' | null;
