# frozen_string_literal: true

require_relative "lib/cashflow_sim/version"

Gem::Specification.new do |spec|
  spec.name = "cashflow_sim"
  spec.version = CashflowSim::VERSION
  spec.authors = ["篠原亮太"]
  spec.email = ["your.email@example.com"]

  spec.summary = "Simple amortization & cashflow simulator for loans/investments."
  spec.description = "Generate schedules with variable interest rates, CSV/JSON output, and an extensible API."
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata["homepage_uri"] = "https://github.com/ryota1119/cashflow_sim"
  spec.metadata["source_code_uri"] = "https://github.com/ryota1119/cashflow_sim"
  spec.metadata["changelog_uri"] = "https://github.com/ryota1119/cashflow_sim/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
