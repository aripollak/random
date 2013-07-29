rails = File.join Dir.getwd, 'config', 'environment.rb'

if File.exist?(rails) && ENV['SKIP_RAILS'].nil?
  require rails
  
  require 'rails/console/app'
  require 'rails/console/helpers'

  def sandbox
    require 'active_record/railties/console_sandbox'
  end
end

if defined?(Gem.post_reset_hooks)
  Gem.post_reset_hooks.reject!{ |hook| hook.source_location.first =~ %r{/bundler/} }
  Gem::Specification.reset
  load 'rubygems/core_ext/kernel_require.rb'
  alias gem require
end
