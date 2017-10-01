# Slack-Queuebot

A simple Slack bot that manages a queue of users, made with [Slack-Ruby-Bot](https://github.com/slack-ruby/slack-ruby-bot).

Any user can ask to join the queue and leave at any time. A user may only join the queue once. When the user at the front of the queue leaves, the next user in the queue is privately pinged by Queuebot.

## Usage

Queuebot can be invited to a channel (`/invite queuebot`), although it is probably best to issue commands in Queuebot's direct channel to avoid cluttering public channels.

### Commands

The following list of commands can be issued in any channel the bot is in with the name of bot ("queuebot") in front. In Queuebot's direct channel, the name of the command is enough. Confirmation messages are sent to the same channel the command was issued from.

#### show

Show the current state of the queue.

#### join

Join the queue. Returns a confirmation message.

#### leave

Leave the queue. Returns a confirmation message and pings the next user to reach the front of the queue if applicable.

#### help

Show the list of commands.

#### hi

Say hi to Queuebot. Queuebot will say hi back.

## Development

### Running the bot

You need to have admin access to a Slack organisation and add a new bot to it in order to test Queuebot. See [Bot Users | Slack](https://api.slack.com/bot-users) for more information.

```
git clone git@github.com:zendesk/slack-queuebot.git && cd slack-queuebot
bundle install
```

Then create a `.env` file store the API token of your bot in it:

```
SLACK_API_TOKEN=...
```

And finally start the bot:

```
foreman start
```

### Running the tests

```
bundle exec rspec
```
