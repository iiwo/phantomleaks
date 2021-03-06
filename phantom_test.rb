i = 0

require 'logger'

TEST_URLS = [
  "google.com",
  "facebook.com",
  "youtube.com",
  "yahoo.com",
  "amazon.com",
  "bing.com",
  "ebay.com",
  "wikipedia.org",
  "craigslist.org",
  "linkedin.com",
  "live.com",
  "twitter.com",
  "blogspot.com",
  "aol.com",
  "go.com",
  "pinterest.com",
  "msn.com",
  "tumblr.com",
  "cnn.com",
  "ask.com",
  "huffingtonpost.com",
  "netflix.com",
  "paypal.com",
  "weather.com",
  "conduit.com",
  "espn.go.com",
  "instagram.com",
  "wordpress.com",
  "bankofamerica.com",
  "akamihd.net",
  "imdb.com",
  "chase.com",
  "microsoft.com",
  "about.com",
  "avg.com",
  "pornhub.com",
  "comcast.net",
  "foxnews.com",
  "apple.com",
  "walmart.com",
  "xhamster.com",
  "mywebsearch.com",
  "wellsfargo.com",
  "xvideos.com",
  "yelp.com",
  "imgur.com",
  "nytimes.com",
  "nbcnews.com",
  "cnet.com",
  "reddit.com",
  "adobe.com",
  "ehow.com",
  "pandora.com",
  "pch.com",
  "hulu.com",
  "zedo.com",
  "etsy.com",
  "flickr.com",
  "outbrain.com",
  "optmd.com",
  "indeed.com",
  "livejasmin.com",
  "zillow.com",
  "target.com",
  "xnxx.com",
  "homedepot.com",
  "redtube.com",
  "answers.com",
  "thepiratebay.sx",
  "att.com",
  "shopathome.com",
  "wikia.com",
  "dailymail.co.uk",
  "usps.com",
  "babylon.com",
  "ups.com",
  "bestbuy.com",
  "youporn.com",
  "reference.com",
  "godaddy.com",
  "groupon.com",
  "deviantart.com",
  "usatoday.com",
  "pof.com",
  "capitalone.com",
  "bbc.co.uk",
  "washingtonpost.com",
  "match.com",
  "drudgereport.com",
  "mlb.com",
  "tripadvisor.com",
  "pogo.com",
  "verizonwireless.com",
  "blogger.com",
  "buzzfeed.com",
  "doublepimp.com",
  "inksr.com",
  "delta-search.com",
  "fedex.com",
  "inksdata.com",
  "oyodomo.com",
  "aweber.com",
  "abcnews.go.com",
  "vimeo.com",
  "hootsuite.com",
  "bleacherreport.com",
  "lowes.com",
  "yellowpages.com",
  "americanexpress.com",
  "tube8.com",
  "yieldmanager.com",
  "salesforce.com"
].freeze

logger = Logger.new(STDOUT)
logger.level = Logger::ERROR

while true do
  require ::File.expand_path('./../test_session', __FILE__)
  require 'capybara/poltergeist'

  session = TestSession.setup_capybara
  url  = TEST_URLS.sample
  begin
    session.visit "https://#{url}"
  rescue Capybara::Poltergeist::StatusFailError, Capybara::CapybaraError
    logger.error("failed to load : #{url}")
  ensure
    session.driver.quit
  end
  i += 1
  logger.error("#{i} : #{url}")
end
