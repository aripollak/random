# Load rails if present
rails = File.join Dir.getwd, 'config', 'environment.rb'

if defined?(Bundler) && File.exist?(rails)
  require rails
  require 'rails/console/app'
  require 'rails/console/helpers'

  include Rails::ConsoleMethods

  def sandbox
    require 'active_record/railties/console_sandbox'
  end
end

# from http://github.com/ConradIrwin/pry-debundle/blob/master/lib/pry-debundle.rb
if defined?(Bundler)
  Gem.post_reset_hooks.reject!{ |hook| hook.source_location.first =~ %r{/bundler/} }
  Gem::Specification.reset
  load 'rubygems/core_ext/kernel_require.rb'
  Kernel.module_eval do
    def gem(gem_name, *requirements) # :doc:
      skip_list = (ENV['GEM_SKIP'] || "").split(/:/)
      raise Gem::LoadError, "skipping #{gem_name}" if skip_list.include? gem_name
      spec = Gem::Dependency.new(gem_name, *requirements).to_spec
      spec.activate if spec
    end
  end
end

require 'table_print'
