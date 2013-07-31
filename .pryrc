rails = File.join Dir.getwd, 'config', 'environment.rb'

if File.exist?(rails) && ENV['SKIP_RAILS'].nil?
  require rails

  require 'rails/console/app'
  require 'rails/console/helpers'

  def sandbox
    require 'active_record/railties/console_sandbox'
  end
end

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
