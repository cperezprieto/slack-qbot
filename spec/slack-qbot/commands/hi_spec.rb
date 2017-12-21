require 'spec_helper'

describe SlackRubyBot::Commands::Hi do
  def app
    SlackQBot::Bot.instance
  end
  it 'says hi' do
    expect(message: 'qbot hi').to respond_with_slack_message('Hi <@user>!')
  end
end
