IRB.conf[:SAVE_HISTORY] = 1000

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
require 'irbtools/configure'
Irbtools.add_library_callback(:hirb) do
  Hirb.disable
  def hirb_enable; Hirb.enable unicode: true; end
  def hirb_disable; Hirb.disable; end
end
Irbtools.start
