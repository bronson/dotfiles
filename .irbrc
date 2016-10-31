require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"
IRB.conf[:BACK_TRACE_LIMIT] = 10000


# calls vi to edit the previous command.  if you save, the command gets executed.
# thanks to bundler, it's tough to use the interactive_editor gem inside rails console
def vi
  path = '/tmp/irb.rb'
  File.exist?(path) or FileUtils.touch(path)
  mtime = File.stat(path).mtime
  Kernel::system 'vi', path
  if mtime < File.stat(path).mtime
    eval IO.read(path), TOPLEVEL_BINDING
  end
end


# Loads all fixtures, then defines the Rails fixture helpers.
# For example: users(:jon) will load the jon fixture from fixtures/users.yml
def load_fixtures
  require 'active_record/fixtures'
  Dir["#{Rails.root}/{test,spec}"].each do |dir|
    Dir["#{dir}/fixtures/*.yml"].map { |filename| filename.match(/\/([^\/]+)\.yml/)[1].to_sym }.each do |name|
      ActiveRecord::FixtureSet.create_fixtures('spec/fixtures', name)
      define_method(name) { |*args|
        name.to_s.singularize.titleize.constantize.find(ActiveRecord::FixtureSet.identify(args[0]))
      }
    end
  end
end


# log all database traffic   (probably never a need, eh?)
# Mongoid.config.logger = Logger.new $stdout if defined? Mongoid
# if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
#   require 'logger'
#   RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
# end

