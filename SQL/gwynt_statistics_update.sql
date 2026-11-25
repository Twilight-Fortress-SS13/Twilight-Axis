-- Gwynt booster progression for an existing prefixed database.
ALTER TABLE `SS13_ccg_settings`
  ADD COLUMN `win_progress` tinyint(3) unsigned NOT NULL DEFAULT '0' AFTER `presets_are_virtual`,
  ADD COLUMN `loss_progress` tinyint(3) unsigned NOT NULL DEFAULT '0' AFTER `win_progress`;
