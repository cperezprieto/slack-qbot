module SlackQBot
  class Application
    attr_accessor :name, :repository, :environments

    def initialize (name: nil, repository: nil, environments:[])
      @name = name
      @repository = repository
      @environments = environments
    end

    def from_hash(h)
      h.each do |k, v|
        if v.kind_of?(Array)
          environments_list = []
          v.each do |e|
            environments_list.append(Environment.new.from_hash(e))
          end
          self.instance_variable_set("@#{k}", environments_list)
        else
          self.instance_variable_set("@#{k}", v)
        end
      end
      return self
    end
  end
end
