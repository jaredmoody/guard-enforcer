guard-enforcer
==============

A guard plugin and git hook to force you to run guards before you commit.

## Assumptions

* You are using git
* You are using guard
* You want to make sure some guard runs before you commit

## Install

### Using bundler

Add to your Gemfile:

```
group :development do
  gem 'guard-enforcer', :git => 'git://github.com/jaredmoody/guard-enforcer.git'
end
```

then run:

```
bundle install
guard init enforcer
```

The init command will:
* Copy a pre-commit script to your project directory
* Symlink .git/hooks/pre-commit to it as long as you do not already have a pre-commit script
* Add .guardrun to your .gitignore file.

## Setup

To your Guardfile:

Add `require 'guard/enforcer'` at the top, then add this callback to each Guard you wish to enforce:

`callback(Enforcer, [:start_end, :run_all_end])`

For example, the following will enforce the guard-cucumber run:

```
  guard 'cucumber', :cli => "-f UnusedProgress" do
    watch(%r{^features/.+\.feature$})
    watch(%r{^features/support/.+$})          { 'features' }
    watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }

    callback(Enforcer, [:start_end, :run_all_end])
  end
```

The first time you run guard, your .guardrun file will be updated with the timestamps of the last successful run.

## Skipping the enforcer

In practice but not in theory, there are times when you want to bypass the enforcer.  Use the -n flag to git to skip the pre-commit hook when committing, but use sparingly as this defeats the purpose.

