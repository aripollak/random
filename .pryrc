rails = File.join Dir.getwd, 'config', 'environment.rb'

if File.exist?(rails) && ENV['SKIP_RAILS'].nil?
  require rails
  
  require 'rails/console/app'
  require 'rails/console/helpers'

  def sandbox
    require 'active_record/railties/console_sandbox'
  end
end
