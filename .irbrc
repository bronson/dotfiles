require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"

# log all database traffic
Mongoid.config.logger = Logger.new $stdout if defined? Mongoid
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

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
