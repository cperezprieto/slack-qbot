module SlackQBot
  class Environment
    attr_accessor :name, :remote

    def initialize (name: nil, remote: nil)
      @name = name
      @remote = remote
    end

    def from_hash(h)
      h.each do |k, v|
        self.instance_variable_set("@#{k}", v)
      end
      return self
    end
  end
end
