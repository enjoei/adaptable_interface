# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adaptable_interface/version'

Gem::Specification.new do |spec|
  spec.name = 'adaptable_interface'
  spec.version = AdaptableInterface::VERSION
  spec.authors = ['Anderson Dias']
  spec.email = ['andersondaraujo@gmail.com']

  spec.summary = 'Adaptable interface gem'
  spec.description = 'Unified way to create adaptable objects'
  spec.homepage = 'https://github.com/enjoei/adaptable_interface'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host' to allow pushing to a
  # single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = 'gems.enjoei.com.br'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
