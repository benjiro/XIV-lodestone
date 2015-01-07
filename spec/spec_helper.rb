require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

LOCAL_FILE = File.join(File.dirname(__FILE__), "resources/character.html")
INVALID_FILE = File.join(File.dirname(__FILE__), "resources/invalid.html")
SERVER_FILE = File.join(File.dirname(__FILE__), "resources/status.html")

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
