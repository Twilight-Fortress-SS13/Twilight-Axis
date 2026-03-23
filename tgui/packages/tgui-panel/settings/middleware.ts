/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { storage, IMPL_HUB_STORAGE, IMPL_MEMORY } from 'common/storage';

import {
  addHighlightSetting,
  exportSettings,
  importSettings,
  loadSettings,
  removeHighlightSetting,
  updateHighlightSetting,
  updateSettings,
} from './actions';
import { FONTS_DISABLED } from './constants';
import { setDisplayScaling } from './scaling';
import { selectSettings } from './selectors';
import { exportChatSettings } from './settingsImExport';

let statFontTimer: NodeJS.Timeout;
let statTabsTimer: NodeJS.Timeout;
let overrideRule: HTMLStyleElement;
let overrideFontFamily: string | undefined;
let overrideFontSize: string;

/** Updates the global CSS rule to override the font family and size. */
function updateGlobalOverrideRule() {
  let fontFamily = '';

  if (overrideFontFamily !== undefined) {
    fontFamily = `font-family: ${overrideFontFamily} !important;`;
  }

  const constructedRule = `body * :not(.Icon) {
    ${fontFamily}
  }`;

  if (overrideRule === undefined) {
    overrideRule = document.createElement('style');
    document.querySelector('head')!.append(overrideRule);
  }

  // no other way to force a CSS refresh other than to update its innerText
  overrideRule.innerText = constructedRule;

  document.body.style.setProperty('font-size', overrideFontSize);
}

function setGlobalFontSize(
  fontSize: string,
  statFontSize: string,
  statLinked: boolean,
) {
  overrideFontSize = `${fontSize}px`;

  clearInterval(statFontTimer);
  Byond.command(
    `.output statbrowser:set_font_size ${statLinked ? fontSize : statFontSize}px`,
  );
  statFontTimer = setTimeout(() => {
    Byond.command(
      `.output statbrowser:set_font_size ${statLinked ? fontSize : statFontSize}px`,
    );
  }, 1500);
}

function setGlobalFontFamily(fontFamily: string) {
  overrideFontFamily = fontFamily === FONTS_DISABLED ? undefined : fontFamily;
}

function setStatTabsStyle(style: string) {
  clearInterval(statTabsTimer);
  Byond.command(`.output statbrowser:set_tabs_style ${style}`);
  statTabsTimer = setTimeout(() => {
    Byond.command(`.output statbrowser:set_tabs_style ${style}`);
  }, 1500);
}

function getStorageImplName() {
  if (storage.impl === IMPL_HUB_STORAGE) {
    return 'HUB_STORAGE';
  }
  if (storage.impl === IMPL_MEMORY) {
    return 'MEMORY';
  }
  return `UNKNOWN(${storage.impl})`;
}

export function settingsMiddleware(store) {
  let initialized = false;

  return (next) => (action) => {
    const { type } = action;

    if (!initialized) {
      initialized = true;

      console.log('[panel-settings] middleware init');
      console.log('[panel-settings] storage impl:', getStorageImplName());

      setDisplayScaling();

      storage.get('panel-settings').then((settings) => {
        console.log('[panel-settings] loaded from storage:', settings);

        if (!settings || typeof settings !== 'object') {
          console.warn('[panel-settings] no valid stored settings found, using reducer defaults');
          store.dispatch(loadSettings(undefined));
          return;
        }

        store.dispatch(loadSettings(settings));
      }).catch((error) => {
        console.error('[panel-settings] failed to load settings:', error);
        store.dispatch(loadSettings(undefined));
      });
    }

    if (type === exportSettings.type) {
      const state = store.getState();
      const settings = selectSettings(state);
      console.log('[panel-settings] export settings:', settings);
      exportChatSettings(settings, state.chat.pageById);
      return;
    }

    if (
      type !== updateSettings.type &&
      type !== loadSettings.type &&
      type !== addHighlightSetting.type &&
      type !== removeHighlightSetting.type &&
      type !== updateHighlightSetting.type &&
      type !== importSettings.type
    ) {
      return next(action);
    }

    next(action);

    const settings = selectSettings(store.getState());

    console.log('[panel-settings] applying settings after action:', type, settings);

    setStatTabsStyle(settings.statTabsStyle);

    setGlobalFontSize(
      settings.fontSize,
      settings.statFontSize,
      settings.statLinked,
    );
    setGlobalFontFamily(settings.fontFamily);
    updateGlobalOverrideRule();

    console.log('[panel-settings] saving to storage:', settings);
    storage.set('panel-settings', settings).catch((error) => {
      console.error('[panel-settings] failed to save settings:', error);
    });

    return;
  };
}
