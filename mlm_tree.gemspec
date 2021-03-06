lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mlm_tree/version"

Gem::Specification.new do |spec|
  spec.name          = "mlm_tree"
  spec.version	      = MlmTree::VERSION
  spec.authors       = ["Rafat Katta"]
  spec.email         = ["rafatkatta@gsibc.net"]

  spec.summary       = %q{Upline Douwnline for User.}
  spec.description   = %q{mlm_tree is an upline downline functionality for Ruby on Rails.}
  spec.homepage      = "https://github.com/rafatkatta/mlm_tree"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://github.com/rafatkatta/mlm_tree"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16.a"
  spec.add_development_dependency "rake", "~> 10.0"
 
  # add configuration
  spec.add_runtime_dependency 'gem_config'

  # add sqlite3
  spec.add_runtime_dependency 'sqlite3'

  # add activerecord
  spec.add_runtime_dependency 'activerecord'

end
