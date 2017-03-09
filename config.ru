require ::File.expand_path('./../test_session', __FILE__)
require 'capybara/poltergeist'

run lambda { |env|
  session = TestSession.setup_capybara
  url  = 'https://google.com'
  session.visit url
  session.driver.quit
  [200, {'Content-Type'=>'text/plain'}, StringIO.new("#{session.status_code.inspect}\n")]
}
