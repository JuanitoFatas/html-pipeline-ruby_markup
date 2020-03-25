# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "html/pipeline/ruby_markup/version"

Gem::Specification.new do |spec|
  spec.name          = "html-pipeline-ruby_markup"
  spec.version       = HTML::Pipeline::RubyMarkup::VERSION
  spec.authors       = ["Juanito Fatas"]
  spec.email         = ["katehuang0320@gmail.com"]
  spec.summary       = %q{A HTML::Pipeline filter to write ruby markup elements.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/juanitofatas/html-pipeline-ruby_markup"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f =~ %r{^(spec)/} }
  spec.require_paths = ["lib"]

  spec.add_dependency "html-pipeline", ">= 1.11"
end
