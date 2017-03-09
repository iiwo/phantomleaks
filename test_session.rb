require 'timeout'
require ::File.expand_path('./../timeout', __FILE__)

class TestSession
  class << self
    # initialize phantomjs webdriver
    def setup_capybara
      require 'capybara/poltergeist'

      Capybara.default_max_wait_time = 10

      options = {
        js_errors: false,
        timeout: 180,
        debug: false,
        phantomjs_logger: StringIO.new,
        logger: nil,
        phantomjs_options: ['--ignore-ssl-errors=yes', '--ssl-protocol=any', '--web-security=no'],
        window_size: [1600, 1200],
        cookies: true
      }

      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, options)
      end

      Capybara.javascript_driver = :poltergeist
      Capybara.default_driver = :poltergeist

      session = Capybara::Session.new(:poltergeist)

      # Redefining kill_phantom_js to use our version of timeout
      # Everything other than the line using PowerScraper::Timeout is
      # copied from poltergeist's implementation
      metasession = class << session.driver.client; self; end
      metasession.send(:define_method, :kill_phantomjs, proc do
        begin
          if Capybara::Poltergeist.windows?
            Process.kill('KILL', pid)
          else
            Process.kill('TERM', pid)

            begin
              PowerScraper::Timeout.timeout(2) { Process.wait(pid) }
            rescue Timeout::Error
              puts 'Kill phantomjs'
              Process.kill('KILL', pid)
              Process.wait(pid)
            end
          end
        rescue Errno::ESRCH, Errno::ECHILD
          # Zed's dead, baby
        end
        @pid = nil
      end)

      session.driver.headers = {
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.86 Safari/537.36'
      }
      session
    end
  end
end
