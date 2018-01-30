module SlackQBot
  class Work
    MAX_WORKS = (ENV['MAX_WORKS'] || 20).freeze
    attr_accessor :work_id, :user, :application, :environment, :branch, :status

    def initialize(work_id: nil, user: nil, application: nil, environment: nil, branch: nil, status: nil)
      work_id ||= SecureRandom.hex(4)
      @work_id = work_id
      @user = user
      @application = application
      @environment = environment
      @branch = branch

      @status ||= :pending
    end

    def from_hash(h)
      h.each do |k, v|
        self.instance_variable_set("@#{k}", v)
      end
      return self
    end
  end
end
