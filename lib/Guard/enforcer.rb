class Guard::Enforcer

  LOG_FILE = ".guardrun"

  #
  # Callback executed from guardfile on successful run
  #

  def self.call(guard_class, event, *args)
    Guard::UI.debug "Enforcer: Updating #{guard_class} last run."
    yaml = File.exists?(LOG_FILE) ? YAML.load_file(LOG_FILE) || {} : {}
    yaml[guard_class.to_s] = Time.now
    File.open(LOG_FILE, 'w'){|file| YAML.dump(yaml, file)}
  end

  #
  # Init command to install the enforcer
  #

  def self.init(guard_name)

    puts
    puts "Installing the Enforcer..."
    puts

    # Copy the pre-commit hook into the project directory and set the permissions

    FileUtils.mkdir_p("git_hooks")

    if File.exists?("git_hooks/pre-commit")
      puts "  pre-commit script already installed, skipping"
    else
      template_path = File.join(File.expand_path(File.dirname(__FILE__)), "../git/pre-commit.rb")
      FileUtils.cp(template_path, "git_hooks/pre-commit")
      FileUtils.chmod(0755, "git_hooks/pre-commit")
      puts "  installed pre-commit script to git_hooks/pre-commit"
    end

    puts

    # Symlink the git pre-commit hook location to the project hook script we copied

    if File.exists?(".git/hooks/pre-commit") or File.symlink?(".git/hooks/pre-commit")
      puts "  It looks like you've already have a pre-commit hook for this repository."
      puts "  Make sure your pre-commit script executes the git_hooks/pre-commit script in your project directory"
    else
      File.symlink(File.join(Dir.pwd, "git_hooks/pre-commit"), ".git/hooks/pre-commit")
      puts "  symlinked .git/hooks/pre-commit to ./git_hooks/pre-commit"
    end

    puts

    # Add .guardrun to .gitignore
    FileUtils.touch ".gitignore" unless File.exists?(".gitignore")

    if File.readlines(".gitignore").grep(/\.guardrun/).size == 0
      open('.gitignore', 'a'){|f| f.puts ".guardrun"}
      puts "  Added .guardrun to .gitignore"
    else
      puts "  .gitignore contains .guardrun, skipping"
    end

    puts

    # print what to do next

    puts "Installed the Enforcer."
    puts
    puts "Add this callback to your Guardfile at the end of the guard blocks you wish to enforce:"
    puts
    puts "  callback(Guard::Enforcer, [:start_end, :run_all_end])"
    puts
    puts "See http://github.com/jaredmoody/guard-inforcer for more information."
    puts
  end
end