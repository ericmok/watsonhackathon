# watsonwork-helloworld

Ruby app that sends and receives messages to a space in
[IBM Watson Workspace] (https://workspace.ibm.com).

The Watson Work platform provides **spaces** for people to exchange
**messages** in conversations. This sample app shows how to retrieve
information about a space, then send a message to the conversation in
that space. It also demonstrates how to authenticate an application and
obtain the OAuth token needed to make Watson Work API calls.

### Registering the app

In your Web browser, go to [Watson Work Services - Apps]
(https://workspace.ibm.com/developer/apps), add a new app named
**Hello World** and write down its app id and app secret.

### Adding the app to a space

Leave the terminal window open as you'll need it again soon.

In your Web browser, go to [Watson Workspace](https://workspace.ibm.com),
create a space named **Examples**, then open the **Apps** tab for that space
and add the **Hello World** app to it.


## What API does the app use?

The app uses the [Watson Work OAuth API]
(https://workspace.ibm.com/developer/docs) to authenticate and get an
OAuth token.  It then uses the [Watson Work GraphQL API]
(https://workspace.ibm.com/developer/docs) to retrieve a list of spaces.
Finally, it uses the [Watson Work Spaces API]
(https://workspace.ibm.com/developer/docs) to send a message to the
conversation in the selected space.

## How can I contribute?

Pull requests welcome!
