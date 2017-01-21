// A sample app that sends a 'hello world' message to a space in IBM
// Watson Workspace

// Usage:
// npm run helloworld "space name" ["message text"]

import * as request from 'request';
import debug from 'debug';
import {Bot} from './bot.js';

// Debug log
const log = debug('watsonwork-helloworld-app');

// Return an OAuth token for the app
const token = (appId, secret, cb) => {
  request.post('https://api.watsonwork.ibm.com/oauth/token', {
    auth: {
      user: appId,
      pass: secret
    },
    json: true,
    form: {
      grant_type: 'client_credentials'
    }
  }, (err, res) => {
    if(err || res.statusCode !== 200) {
      log('Error getting OAuth token %o', err || res.statusCode);
      cb(err || new Error(res.statusCode));
      return;
    }
    cb(null, res.body.access_token);
  });
};

// Main app entry point
// Send a message to the conversation in the space matching the given name
export const main = (name, text, appId, secret, cb) => {
  // Get an OAuth token for the app
  token(appId, secret, (err, tok) => {
    if(err) {
      cb(err);
      return;
    }

    var bot = new Bot();
    bot.run(tok, name, text, cb);
  });
};

if(require.main === module)
  // Run the app
  main(process.argv[2], process.argv[3],
    // Expect the app id and secret to be configured in env variables
    //process.env.HELLOWORLD_APP_ID, process.env.HELLOWORLD_APP_SECRET,
    "80d53043-ef76-45af-9dc7-12abc226319c",
    "l6zh47dr0xlp82ybaketfsllxa8674qm",
    (err) => {
      if(err)
        console.log('Error sending message:', err);
    });
