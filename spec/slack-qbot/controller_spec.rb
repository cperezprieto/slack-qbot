require 'spec_helper'

describe SlackQBot::Controller do
  let(:app) { SlackQBot::Bot.instance }
  let(:model) { SlackQBot::Model.new }

  subject { app }
end
