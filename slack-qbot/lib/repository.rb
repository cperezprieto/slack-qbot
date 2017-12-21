module SlackQBot
  class Repository
    attr_accessor :remote_repo
    GIT_FOLDER = ENV['GIT_FOLDER']

    def initialize(remote_repo:)
      @remote_repo = remote_repo
    end

    def has_remote_branch?(branch:)
      return false if !exist_remote?

      result = `git ls-remote --heads #{self.remote_repo} #{branch}`
      return true if !result.empty?

      return false
    end

    def exist_remote?
      return system("git ls-remote --heads #{self.remote_repo}")
    end

    def exist_local?
      return system("ls -d #{GIT_FOLDER}/#{repo_folder}")
    end

    def clone?
      return system("cd #{GIT_FOLDER} && git clone #{remote_repo}")
    end

    def repo_folder
      start_index = remote_repo.rindex('/') + 1
      return remote_repo[start_index..remote_repo.length].chomp('.git')
    end

    def fetch?
      if !exist_local?
        return clone
      end

      return system("cd #{GIT_FOLDER}/#{repo_folder} && git fetch")
    end

    def push?(remote:, branch:)
      return false if !has_remote_branch?(branch: branch)
      return false if !fetch?

      return system("cd #{GIT_FOLDER}/#{repo_folder} && git push #{remote} #{branch}")
    end
  end
end
