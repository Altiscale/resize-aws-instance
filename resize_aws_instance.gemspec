# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resize_aws_instance/version'

Gem::Specification.new do |spec|
  spec.name          = 'resize-aws-instance'
  spec.version       = ResizeAwsInstance::VERSION
  spec.authors       = ['Tucker']
  spec.email         = ['tucker@altiscale.com']
  spec.description   = %q(Simple tool to resize AWS instances with EBS root.)
  spec.summary       = IO.read(File.join(File.dirname(__FILE__), 'README.md'))
  spec.homepage      = 'https://github.com/Altiscale/resize-aws-instance'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk', '~> 1.42'
  spec.add_runtime_dependency 'trollop', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3'
  spec.add_development_dependency 'rubocop', '~> 0.23'
end
