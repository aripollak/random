# from http://github.com/ConradIrwin/pry-debundle/blob/master/lib/pry-debundle.rb
if defined?(Gem.post_reset_hooks)
  Gem.post_reset_hooks.reject!{ |hook| hook.source_location.first =~ %r{/bundler/} }
  Gem::Specification.reset
  load 'rubygems/custom_require.rb'
  alias gem require
end
require 'irbtools/configure'
Irbtools.add_library_callback(:hirb) do
  Hirb.disable
  def hirb_enable; Hirb.enable unicode: true; end
  def hirb_disable; Hirb.disable; end
end
Irbtools.start