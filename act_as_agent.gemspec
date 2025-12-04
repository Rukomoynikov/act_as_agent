# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "act_as_agent"
  spec.version = "0.4.0"
  spec.authors = ["Max Rukomoynikov"]
  spec.email = ["rukomoynikov@gmail.com"]

  spec.summary = "Your navigator to the world of agents."
  spec.description = "
  Build and manage AI agents with ease using ActAsAgent. This gem provides a robust framework for creating, configuring, and deploying intelligent agents that can perform tasks autonomously. Whether you're looking to automate workflows, enhance user interactions, or develop complex AI systems, ActAsAgent offers the tools and flexibility you need to bring your ideas to life.
  "
  spec.homepage = "https://github.com/Rukomoynikov/act_as_agent"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Rukomoynikov/act_as_agent"
  spec.metadata["changelog_uri"] = "https://github.com/Rukomoynikov/act_as_agent/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "act_as_api_client", "~> 1.3.2"
  spec.add_dependency "rake", "~> 13.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
