require 'securerandom'

module SlackQBot
  class Work
    attr_accessor :work_id, :user_id, :application, :environment, :branch_name

    def initialize(user_id, target_application, target_environment, branch_name)
      @work_id = SecureRandom.uuid
      @user_id = user_id
      @target_application = target_application
      @target_environment = target_environment
      @branch_name = branch_name
    end
  end
end
