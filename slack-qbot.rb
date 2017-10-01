require 'slack-ruby-bot'
require './slack-qbot/model'
require './slack-qbot/controller'
require './slack-qbot/view'
require './slack-qbot/bot'
require './slack-qbot/available_environment'
require './slack-qbot/available_application'
require './slack-qbot/work'

SlackRubyBot::Client.logger.level = Logger::WARN
