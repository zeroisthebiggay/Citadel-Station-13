import { createLogger, directLog } from 'common/logging.js';
import http from 'http';
import { inspect } from 'util';
import WebSocket from 'ws';
import { retrace, loadSourceMaps } from './retrace.js';

const logger = createLogger('link');

const DEBUG = process.argv.includes('--debug');

export { loadSourceMaps };

export const setupLink = () => new LinkServer();

class LinkServer {
  constructor() {
    logger.log('setting up');
    this.wss = null;
    this.setupWebSocketLink();
    this.setupHttpLink();
  }

  // WebSocket-based client link
  setupWebSocketLink() {
    const port = 3000;
    this.wss = new WebSocket.Server({ port });
    this.wss.on('connection', ws => {
      logger.log('client connected');
      ws.on('message', json => {
        const msg = deserializeObject(json);
        this.handleLinkMessage(ws, msg);
      });
      ws.on('close', () => {
        logger.log('client disconnected');
      });
    });
    logger.log(`listening on port ${port} (WebSocket)`);
  }

  // One way HTTP-based client link for IE8
  setupHttpLink() {
    const port = 3001;
    this.httpServer = http.createServer((req, res) => {
      if (req.method === 'POST') {
        let body = '';
        req.on('data', chunk => {
          body += chunk.toString();
        });
        req.on('end', () => {
          const msg = deserializeObject(body);
          this.handleLinkMessage(null, msg);
          res.end();
        });
        return;
      }
      res.write('Hello');
      res.end();
    });
    this.httpServer.listen(port);
    logger.log(`listening on port ${port} (HTTP)`);
  }

  handleLinkMessage(ws, msg) {
    const { type, payload } = msg;
    if (type === 'log') {
      const { level, ns, args } = payload;
      // Skip debug messages
      if (level <= 0 && !DEBUG) {
        return;
      }
      directLog(ns, ...args.map(arg => {
        if (typeof arg === 'object') {
          return inspect(arg, {
            depth: Infinity,
            colors: true,
            compact: 8,
          });
        }
        return arg;
      }));
      return;
    }
    if (type === 'relay') {
      for (let client of this.wss.clients) {
        if (client === ws) {
          continue;
        }
        this.sendMessage(client, msg);
      }
      return;
    }
    logger.log('unhandled message', msg);
  }

  sendMessage(ws, msg) {
    ws.send(JSON.stringify(msg));
  }

  broadcastMessage(msg) {
    const clients = [...this.wss.clients];
    if (clients.length === 0) {
      return;
    }
    logger.log(`broadcasting ${msg.type} to ${clients.length} clients`);
    for (let client of clients) {
      const json = JSON.stringify(msg);
      client.send(json);
    }
  }
}

const deserializeObject = obj => {
  return JSON.parse(obj, (key, value) => {
    if (typeof value === 'object' && value !== null) {
<<<<<<< HEAD:tgui-next/packages/tgui-dev-server/link/server.js
      if (value.__error__) {
        return retrace(value.stack);
=======
      if (value.__undefined__) {
        // NOTE: You should not rely on deserialized object's undefined,
        // this is purely for inspection purposes.
        return {
          [inspect.custom]: () => undefined,
        };
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui-dev-server/link/server.js
      }
      if (value.__number__) {
        return parseFloat(value.__number__);
      }
<<<<<<< HEAD:tgui-next/packages/tgui-dev-server/link/server.js
=======
      if (value.__error__) {
        if (!value.stack) {
          return value.string;
        }
        return retrace(value.stack);
      }
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui-dev-server/link/server.js
      return value;
    }
    return value;
  });
};
<<<<<<< HEAD:tgui-next/packages/tgui-dev-server/link/server.js

const handleLinkMessage = msg => {
  const { type, payload } = msg;

  if (type === 'log') {
    const { level, ns, args } = payload;
    // Skip debug messages
    if (level <= 0 && !DEBUG) {
      return;
    }
    directLog(ns, ...args.map(arg => {
      if (typeof arg === 'object') {
        return inspect(arg, {
          depth: Infinity,
          colors: true,
          compact: 8,
        });
      }
      return arg;
    }));
    return;
  }

  logger.log('unhandled message', msg);
};

// WebSocket-based client link
const setupWebSocketLink = () => {
  const port = 3000;
  const wss = new WebSocket.Server({ port });

  wss.on('connection', ws => {
    logger.log('client connected');

    ws.on('message', json => {
      const msg = deserializeObject(json);
      handleLinkMessage(msg);
    });

    ws.on('close', () => {
      logger.log('client disconnected');
    });
  });

  logger.log(`listening on port ${port} (WebSocket)`);
  return wss;
};

// One way HTTP-based client link for IE8
const setupHttpLink = () => {
  const port = 3001;

  const server = http.createServer((req, res) => {
    if (req.method === 'POST') {
      let body = '';
      req.on('data', chunk => {
        body += chunk.toString();
      });
      req.on('end', () => {
        const msg = JSON.parse(body);
        handleLinkMessage(msg);
        res.end();
      });
      return;
    }
    res.write('Hello');
    res.end();
  });

  server.listen(port);
  logger.log(`listening on port ${port} (HTTP)`);
};
=======
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui-dev-server/link/server.js
