module SlackQBot
  class AvailableApplication
    attr_accessor :application_name, :remote_repo

    def initialize(application_name, remote_repo)
      @application_name = application_name
      @remote_repo = remote_repo
    end
  end
end
