import * as request from 'request';
import debug from 'debug';

// Debug log
const log = debug('watsonwork-helloworld-app');

// Return the list of spaces the app belongs to
const spaces = (tok, cb) => {
  request.post('https://api.watsonwork.ibm.com/graphql', {
    headers: {
      jwt: tok,
      'Content-Type': 'application/graphql'
    },

    // This is a GraphQL query, used to retrieve the list of spaces
    // visible to the app (given the app OAuth token)
    body: `
      query {
        spaces (first: 50) {
          items {
            title
            id
          }
        }
      }`
  }, (err, res) => {
    if(err || res.statusCode !== 200) {
      log('Error retrieving spaces %o', err || res.statusCode);
      cb(err || new Error(res.statusCode));
      return;
    }

    // Return the list of spaces
    const body = JSON.parse(res.body);
    log('Space query result %o', body.data.spaces.items);
    cb(null, body.data.spaces.items);
  });
};


// Send an app message to the conversation in a space
const send = (spaceId, text, tok, cb) => {
  request.post(
    'https://api.watsonwork.ibm.com/v1/spaces/' + spaceId + '/messages', {
      headers: {
        Authorization: 'Bearer ' + tok
      },
      json: true,
      // An App message can specify a color, a title, markdown text and
      // an 'actor' useful to show where the message is coming from
      body: {
        type: 'appMessage',
        version: 1.0,
        annotations: [{
          type: 'generic',
          version: 1.0,

          color: '#6CB7FB',
          title: 'Sample Message',
          text: text,

          actor: {
            name: 'from sample helloworld app',
            avatar: 'https://avatars1.githubusercontent.com/u/22985179',
            url: 'https://github.com/watsonwork-helloworld'
          }
        }]
      }
    }, (err, res) => {
      if(err || res.statusCode !== 201) {
        log('Error sending message %o', err || res.statusCode);
        cb(err || new Error(res.statusCode));
        return;
      }
      log('Send result %d, %o', res.statusCode, res.body);
      cb(null, res.body);
    });
};

export class Bot {
  run(tok, name, text, cb) {
    console.log('hi');

        // List the spaces the app belongs to
        spaces(tok, (err, slist) => {
          if(err) {
            cb(err);
            return;
          }

          // Find a space matching the given name
          const space = slist.filter((s) => s.title === name)[0];
          if(!space) {
            cb(new Error('Space not found'));
            return;
          }

          // Send the message
          log('Sending \'%s\' to space %s', text, space.title);
          send(space.id,
            text || 'Hello Naive Bayes!',
            tok, (err, res) => {
              if(err) {
                cb(err);
                return;
              }
              log('Sent message to space %s', space.title);
              cb(null);
            });
        });

  }
}
