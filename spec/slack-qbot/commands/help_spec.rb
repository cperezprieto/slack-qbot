require 'spec_helper'

describe SlackQBot::Commands::Help do
  def app
    SlackQBot::Bot.instance
  end
  it 'help' do
    expect(message: 'qbot help').to respond_with_slack_message('TODO...')
  end
end
