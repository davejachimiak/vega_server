# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vega_server/version'

Gem::Specification.new do |spec|
  spec.name          = "vega_server"
  spec.version       = VegaServer::VERSION
  spec.authors       = ["Dave Jachimiak"]
  spec.email         = ["dave.jachimiak@gmail.com"]
  spec.description   = %q{VegaServer is a server-side implementation of the Vega protocol.}
  spec.summary       = %q{VegaServer is a server-side implementation of the Vega protocol.
                          The Vega protocol is a way to send preliminary messages for WebRTC
                          peer connections. The protocol and this server are works in progress.}
  spec.homepage      = "https://github.com/davejachimiak/vega_server"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'faye-websocket', '~> 0.7'
  spec.add_runtime_dependency 'rack', '~> 1.5'
  spec.add_runtime_dependency 'puma', '~> 2.8'
  spec.add_runtime_dependency 'multi_json', '~> 1.9'
  spec.add_runtime_dependency 'activesupport', '~> 4.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.1"
  spec.add_development_dependency "bourne", "~> 1.5"
  spec.add_development_dependency "rspec-eventmachine", "~> 0.1"
  spec.add_development_dependency "pry"
end
