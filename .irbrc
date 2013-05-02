# from http://github.com/ConradIrwin/pry-debundle/blob/master/lib/pry-debundle.rb
if defined?(Gem.post_reset_hooks)
  Gem.post_reset_hooks.reject!{ |hook| hook.source_location.first =~ %r{/bundler/} }
  Gem::Specification.reset
  load 'rubygems/custom_require.rb'
  alias gem require
end

begin
  require 'pry'
  Pry.start
  exit
rescue LoadError => e
  warn '=> Unable to load pry'
end
