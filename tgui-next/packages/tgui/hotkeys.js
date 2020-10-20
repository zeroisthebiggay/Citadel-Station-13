<<<<<<< HEAD:tgui-next/packages/tgui/hotkeys.js
=======
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { KEY_CTRL, KEY_ENTER, KEY_ESCAPE, KEY_F, KEY_F5, KEY_R, KEY_SHIFT, KEY_SPACE, KEY_TAB } from 'common/keycodes';
import { globalEvents } from './events';
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/hotkeys.js
import { createLogger } from './logging';
import { callByond, tridentVersion } from './byond';

const logger = createLogger('hotkeys');

<<<<<<< HEAD:tgui-next/packages/tgui/hotkeys.js
// Key codes
export const KEY_BACKSPACE = 8;
export const KEY_TAB = 9;
export const KEY_ENTER = 13;
export const KEY_SHIFT = 16;
export const KEY_CTRL = 17;
export const KEY_ALT = 18;
export const KEY_ESCAPE = 27;
export const KEY_SPACE = 32;
export const KEY_0 = 48;
export const KEY_1 = 49;
export const KEY_2 = 50;
export const KEY_3 = 51;
export const KEY_4 = 52;
export const KEY_5 = 53;
export const KEY_6 = 54;
export const KEY_7 = 55;
export const KEY_8 = 56;
export const KEY_9 = 57;
export const KEY_A = 65;
export const KEY_B = 66;
export const KEY_C = 67;
export const KEY_D = 68;
export const KEY_E = 69;
export const KEY_F = 70;
export const KEY_G = 71;
export const KEY_H = 72;
export const KEY_I = 73;
export const KEY_J = 74;
export const KEY_K = 75;
export const KEY_L = 76;
export const KEY_M = 77;
export const KEY_N = 78;
export const KEY_O = 79;
export const KEY_P = 80;
export const KEY_Q = 81;
export const KEY_R = 82;
export const KEY_S = 83;
export const KEY_T = 84;
export const KEY_U = 85;
export const KEY_V = 86;
export const KEY_W = 87;
export const KEY_X = 88;
export const KEY_Y = 89;
export const KEY_Z = 90;
export const KEY_EQUAL = 187;
export const KEY_MINUS = 189;
=======
// BYOND macros, in `key: command` format.
const byondMacros = {};
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/hotkeys.js

// Array of acquired keys, which will not be sent to BYOND.
const hotKeysAcquired = [
  // Default set of acquired keys
  KEY_ESCAPE,
  KEY_ENTER,
  KEY_SPACE,
  KEY_TAB,
  KEY_CTRL,
  KEY_SHIFT,
<<<<<<< HEAD:tgui-next/packages/tgui/hotkeys.js
=======
  KEY_F5,
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/hotkeys.js
];

// State of passed-through keys.
const keyState = {};

/**
 * Converts a browser keycode to BYOND keycode.
 */
const keyCodeToByond = keyCode => {
  if (keyCode === 16) return 'Shift';
  if (keyCode === 17) return 'Ctrl';
  if (keyCode === 18) return 'Alt';
  if (keyCode === 33) return 'Northeast';
  if (keyCode === 34) return 'Southeast';
  if (keyCode === 35) return 'Southwest';
  if (keyCode === 36) return 'Northwest';
  if (keyCode === 37) return 'West';
  if (keyCode === 38) return 'North';
  if (keyCode === 39) return 'East';
  if (keyCode === 40) return 'South';
  if (keyCode === 45) return 'Insert';
  if (keyCode === 46) return 'Delete';
  if (keyCode >= 48 && keyCode <= 57 || keyCode >= 65 && keyCode <= 90) {
    return String.fromCharCode(keyCode);
  }
<<<<<<< HEAD:tgui-next/packages/tgui/hotkeys.js
  else {
    str += '[' + keyCode + ']';
=======
  if (keyCode >= 96 && keyCode <= 105) {
    return 'Numpad' + (keyCode - 96);
  }
  if (keyCode >= 112 && keyCode <= 123) {
    return 'F' + (keyCode - 111);
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/hotkeys.js
  }
  if (keyCode === 188) return ',';
  if (keyCode === 189) return '-';
  if (keyCode === 190) return '.';
};

/**
 * Keyboard passthrough logic. This allows you to keep doing things
 * in game while the browser window is focused.
 */
const handlePassthrough = key => {
  // In addition to F5, support reloading with Ctrl+R and Ctrl+F5
  if (key.ctrl && (key.code === KEY_F5 || key.code === KEY_R)) {
    location.reload();
    return;
  }
  // Prevent passthrough on Ctrl+F
  if (key.ctrl && key.code === KEY_F) {
    return;
  }
  // NOTE: Alt modifier is pretty bad and sticky in IE11.
  if (key.event.defaultPrevented
      || key.isModifierKey()
      || hotKeysAcquired.includes(key.code)) {
    return;
  }
<<<<<<< HEAD:tgui-next/packages/tgui/hotkeys.js
  // Send this keypress to BYOND
  if (eventType === 'keydown' && !keyState[keyCode]) {
    logger.debug('passthrough', eventType, keyData);
    return callByond('', { __keydown: keyCode });
  }
  if (eventType === 'keyup' && keyState[keyCode]) {
    logger.debug('passthrough', eventType, keyData);
    return callByond('', { __keyup: keyCode });
=======
  const byondKeyCode = keyCodeToByond(key.code);
  if (!byondKeyCode) {
    return;
  }
  // Macro
  const macro = byondMacros[byondKeyCode];
  if (macro) {
    logger.debug('macro', macro);
    return Byond.command(macro);
  }
  // KeyDown
  if (key.isDown() && !keyState[byondKeyCode]) {
    keyState[byondKeyCode] = true;
    const command = `KeyDown "${byondKeyCode}"`;
    logger.debug(command);
    return Byond.command(command);
  }
  // KeyUp
  if (key.isUp() && keyState[byondKeyCode]) {
    keyState[byondKeyCode] = false;
    const command = `KeyUp "${byondKeyCode}"`;
    logger.debug(command);
    return Byond.command(command);
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/hotkeys.js
  }
};

/**
 * Acquires a lock on the hotkey, which prevents it from being
 * passed through to BYOND.
 */
<<<<<<< HEAD:tgui-next/packages/tgui/hotkeys.js
export const releaseHeldKeys = () => {
  for (let keyCode of Object.keys(keyState)) {
    if (keyState[keyCode]) {
      logger.log(`releasing [${keyCode}] key`);
      keyState[keyCode] = false;
      callByond('', { __keyup: keyCode });
    }
  }
};

const handleHotKey = (e, eventType, dispatch) => {
  if (eventType !== 'keyup') {
    return;
  }
  const keyData = getKeyData(e);
  const {
    ctrlKey,
    altKey,
    keyCode,
    hasModifierKeys,
    keyString,
  } = keyData;
  // Dispatch a detected hotkey as a store action
  if (hasModifierKeys && !MODIFIER_KEYS.includes(keyCode)) {
    logger.log(keyString);
    // Fun stuff
    if (ctrlKey && altKey && keyCode === KEY_BACKSPACE) {
      // NOTE: We need to call this in a timeout, because we need a clean
      // stack in order for this to be a fatal error.
      setTimeout(() => {
        throw new Error(
          'OOPSIE WOOPSIE!! UwU We made a fucky wucky!! A wittle'
          + ' fucko boingo! The code monkeys at our headquarters are'
          + ' working VEWY HAWD to fix this!');
      });
=======
export const acquireHotKey = keyCode => {
  hotKeysAcquired.push(keyCode);
};

/**
 * Makes the hotkey available to BYOND again.
 */
export const releaseHotKey = keyCode => {
  const index = hotKeysAcquired.indexOf(keyCode);
  if (index >= 0) {
    hotKeysAcquired.splice(index, 1);
  }
};

export const releaseHeldKeys = () => {
  for (let byondKeyCode of Object.keys(keyState)) {
    if (keyState[byondKeyCode]) {
      keyState[byondKeyCode] = false;
      logger.log(`releasing key "${byondKeyCode}"`);
      Byond.command(`KeyUp "${byondKeyCode}"`);
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/hotkeys.js
    }
    dispatch({
      type: 'hotKey',
      payload: keyData,
    });
  }
};

export const setupHotKeys = () => {
  // Read macros
  Byond.winget('default.*').then(data => {
    // Group each macro by ref
    const groupedByRef = {};
    for (let key of Object.keys(data)) {
      const keyPath = key.split('.');
      const ref = keyPath[1];
      const prop = keyPath[2];
      if (ref && prop) {
        if (!groupedByRef[ref]) {
          groupedByRef[ref] = {};
        }
        groupedByRef[ref][prop] = data[key];
      }
    }
    // Insert macros
    const escapedQuotRegex = /\\"/g;
    const unescape = str => str
      .substring(1, str.length - 1)
      .replace(escapedQuotRegex, '"');
    for (let ref of Object.keys(groupedByRef)) {
      const macro = groupedByRef[ref];
      const byondKeyName = unescape(macro.name);
      byondMacros[byondKeyName] = unescape(macro.command);
    }
    logger.debug('loaded macros', byondMacros);
  });
  // Setup event handlers
  globalEvents.on('window-blur', () => {
    releaseHeldKeys();
  });
<<<<<<< HEAD:tgui-next/packages/tgui/hotkeys.js
};

// Middleware
export const hotKeyMiddleware = store => {
  const { dispatch } = store;
  // Subscribe to key events
  subscribeToKeyPresses((e, eventType) => {
    // IE8: Can't determine the focused element, so by extension it passes
    // keypresses when inputs are focused.
    if (tridentVersion > 4) {
      handlePassthrough(e, eventType);
    }
    handleHotKey(e, eventType, dispatch);
  });
  // IE8: focusin/focusout only available on IE9+
  if (tridentVersion > 4) {
    // Clean up when browser window completely loses focus
    subscribeToLossOfFocus(() => {
      releaseHeldKeys();
    });
  }
  // Pass through store actions (do nothing)
  return next => action => next(action);
=======
  globalEvents.on('key', key => {
    handlePassthrough(key);
  });
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/hotkeys.js
};

// Reducer
export const hotKeyReducer = (state, action) => {
  const { type, payload } = action;
  if (type === 'hotKey') {
    const { ctrlKey, altKey, keyCode } = payload;
    // Toggle kitchen sink mode
    if (ctrlKey && altKey && keyCode === KEY_EQUAL) {
      return {
        ...state,
        showKitchenSink: !state.showKitchenSink,
      };
    }
    return state;
  }
  return state;
};
