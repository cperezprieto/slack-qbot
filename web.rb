require 'sinatra/base'

module SlackQBot
  class Web < Sinatra::Base
    get '/' do
      'Slack QBot working...'
    end
  end
end
