require 'pp'
require 'irb/completion'
require 'irb/ext/save-history'
require 'rubygems' rescue nil
require 'interactive_editor' rescue nil


IRB.conf.merge!({
  :USE_READLINE =>  true,
  :AUTO_INDENT  =>  true,
  :SAVE_HISTORY =>  1000,
  :PROMPT_MODE  =>  :VERBOSE,
  :HISTORY_FILE =>  "#{ENV['HOME']}/.irb_history",
})

IRB.conf[:PROMPT] ||= {}
IRB.conf[:PROMPT][:VERBOSE] = {
  :PROMPT_I => "#{cwd = File.basename(Dir.pwd)}> ",
  :PROMPT_S => "#{cwd}* ",
  :PROMPT_C => "#{cwd}? ",
  :RETURN   => "=> %s\n"
}

# log all database traffic
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

