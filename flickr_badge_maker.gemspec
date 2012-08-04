Gem::Specification.new do |s|
  s.name        = 'flickr_badge_maker'
  s.version     = '0.0.1'
  s.summary     = "Flickr photo gallery badge helper."
  s.description = "Convenient access to Flickr photosets for creating a photo gallery badge."
  s.authors     = ["lynnfaraday@github"]
  s.files       = Dir.glob("{bin,lib,spec}/**/*")
  s.homepage    = 'http://github.com/lynnfaraday/flickr_badge_maker'
  s.platform    = Gem::Platform::RUBY
  s.add_runtime_dependency "flickraw", '~> 0.9'
  s.add_runtime_dependency "awesome_print", '~> 1.0'
  s.executables = "flickr_badge_maker"
end
