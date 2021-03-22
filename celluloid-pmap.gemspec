# -*- encoding: utf-8 -*-
require 'date'
require File.expand_path('../lib/celluloid/pmap/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "celluloid-pmap"
  gem.version       = Celluloid::Pmap::VERSION
  gem.authors       = ["Jesse Wolgamott"]
  gem.email         = ["jesse@comalproductions.com"]
  gem.description   = %q{Easy Parallel Executing using Celluloid}
  gem.summary       = %q{ Celluloid Futures are wicked sweet, and when combined with a #pmap implementation AND a supervisor to keep the max threads down, you can be wicked sweet too!}
  gem.homepage      = "https://github.com/jwo/celluloid-pmap"
  gem.license       = "MIT"
  gem.date = Date.today

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('celluloid', ' >= 0.16')

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "2.99"
  gem.add_development_dependency "pry"
  gem.add_development_dependency 'appraisal', '~> 2.1', '>= 2.1'
end
