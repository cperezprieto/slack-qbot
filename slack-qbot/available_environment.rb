module SlackQBot
  class AvailableEnvironment
    attr_accessor :environment_name, :remote

    def initialize(environment_name, remote)
      @environment_name = environment_name
      @remote = remote
    end
  end
end
