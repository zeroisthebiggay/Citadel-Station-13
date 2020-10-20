import { createLogger } from 'common/logging.js';
import fs from 'fs';
import os from 'os';
import { basename } from 'path';
import { promisify } from 'util';
import { resolveGlob, resolvePath } from './util.js';
<<<<<<< HEAD:tgui-next/packages/tgui-dev-server/reloader.js
=======
import { regQuery } from './winreg.js';
import { DreamSeeker } from './dreamseeker.js';
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui-dev-server/reloader.js

const logger = createLogger('reloader');

const HOME = os.homedir();
const SEARCH_LOCATIONS = [
  // Windows
  `${HOME}/*/BYOND/cache`,
  // Wine
  `${HOME}/.wine/drive_c/users/*/*/BYOND/cache`,
  // Lutris
  `${HOME}/Games/byond/drive_c/users/*/*/BYOND/cache`,
  // WSL
  `/mnt/c/Users/*/*/BYOND/cache`,
];

let cacheRoot;

export const findCacheRoot = async () => {
  if (cacheRoot) {
    return cacheRoot;
  }
  logger.log('looking for byond cache');
  // Find BYOND cache folders
  for (let pattern of SEARCH_LOCATIONS) {
    const paths = await resolveGlob(pattern);
    if (paths.length > 0) {
      cacheRoot = paths[0];
      onCacheRootFound(cacheRoot);
      return cacheRoot;
    }
  }
<<<<<<< HEAD:tgui-next/packages/tgui-dev-server/reloader.js
=======
  // Query the Windows Registry
  if (process.platform === 'win32') {
    logger.log('querying windows registry');
    let userpath = await regQuery(
      'HKCU\\Software\\Dantom\\BYOND',
      'userpath');
    if (userpath) {
      cacheRoot = userpath
        .replace(/\\$/, '')
        .replace(/\\/g, '/')
        + '/cache';
      onCacheRootFound(cacheRoot);
      return cacheRoot;
    }
  }
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui-dev-server/reloader.js
  logger.log('found no cache directories');
};

const onCacheRootFound = cacheRoot => {
  logger.log(`found cache at '${cacheRoot}'`);
  // Plant dummy
  fs.closeSync(fs.openSync(cacheRoot + '/dummy', 'w'));
};

export const reloadByondCache = async bundleDir => {
  const cacheRoot = await findCacheRoot();
  if (!cacheRoot) {
    return;
  }
  // Find tmp folders in cache
  const cacheDirs = await resolveGlob(cacheRoot, './tmp*');
  if (cacheDirs.length === 0) {
    logger.log('found no tmp folder in cache');
    return;
  }
  // Get dreamseeker instances
  const pids = cacheDirs.map(cacheDir => (
    parseInt(cacheDir.split('/cache/tmp').pop(), 10)
  ));
  const dssPromise = DreamSeeker.getInstancesByPids(pids);
  // Copy assets
  const assets = await resolveGlob(bundleDir, './*.+(bundle|chunk|hot-update).*');
  for (let cacheDir of cacheDirs) {
    // Clear garbage
    const garbage = await resolveGlob(cacheDir, './*.+(bundle|chunk|hot-update).*');
    for (let file of garbage) {
      await promisify(fs.unlink)(file);
    }
    // Copy assets
    for (let asset of assets) {
      const destination = resolvePath(cacheDir, basename(asset));
      await promisify(fs.copyFile)(asset, destination);
    }
    logger.log(`copied ${assets.length} files to '${cacheDir}'`);
  }
  // Notify dreamseeker
  const dss = await dssPromise;
  if (dss.length > 0) {
    logger.log(`notifying dreamseeker`);
    for (let dreamseeker of dss) {
      dreamseeker.topic({
        tgui: 1,
        type: 'cacheReloaded',
      });
    }
  }
};
