# frozen_string_literal: true

require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.filter_sensitive_data("<X-Api-Key>") do |interaction|
    interaction.request.headers["X-Api-Key"] = ""
  end
end
