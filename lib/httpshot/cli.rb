# frozen_string_literal: true

module Httpshot
  # Httpshot::CLI
  class CLI
    # @param [Array<String>]
    # @return [Httpshot::CLI]
    def initialize(argv)
      @options = { driver: 'chrome', ua: nil, width: 360, sleep: 0 }
      @urls = parse!(argv)
    end

    # @return [void]
    def execute
      d = init_driver
      urls.each { |url| screenshot(d, url) }
    end

    private

    # !@attribute [r] urls
    # @return [Array<String>]
    attr_reader :urls
    # !@attribute [r] options
    # @return [Hash]
    attr_reader :options

    # @return [OptionParser]
    def parser
      opt = OptionParser.new
      options.each do |k, v|
        opt.on("-#{k.to_s[0]} [=VAL]", v.class || String, "#{k} default: #{v}")
      end
      opt
    end

    # @param argv [Array<String>]
    # @return [Array<String>]
    def parse!(argv)
      parser.parse!(argv)
      argv
    end

    # @params driver [Selenium::WebDriver::Driver]
    # @param url [String]
    # @return [void]
    def screenshot(driver, url)
      driver.manage.window.resize_to(options[:width], 0)
      driver.navigate.to(url)
      driver.manage.window.resize_to(page_width(driver), page_height(driver))
      sleep(options[:sleep])
      driver.save_screenshot(filename(url))
    end

    # @param url [String]
    # @return [String]
    def filename(url)
      "#{Time.now.strftime('%Y%m%d%H%M%S%L')}_#{URI.encode_www_form_component(url)}_httpshot.png"
    end

    # @return [Selenium::WebDriver::Driver]
    def init_driver
      Webdrivers.install_dir = File.expand_path '../../drivers', __dir__
      case options[:driver]
      when 'chrome'
        chrome_driver
      else
        raise ArgumentError
      end
    end

    # @return [Selenium::WebDriver::Driver]
    def chrome_driver
      d_options = Selenium::WebDriver::Chrome::Options.new
      d_options.headless!
      d_options.add_argument("--user-agent=#{options[:ua]}") if options[:ua]
      Selenium::WebDriver.for(:chrome, options: d_options)
    end

    # @params [Selenium::WebDriver::Driver]
    # @return [Integer]
    def page_width(driver)
      driver.execute_script(<<~JS)
        return Math.max(
          document.body.scrollWidth, document.body.offsetWidth,
          document.documentElement.clientWidth,
          document.documentElement.scrollWidth,
          document.documentElement.offsetWidth
        );
      JS
    end

    # @params [Selenium::WebDriver::Driver]
    # @return [Integer]
    def page_height(driver)
      driver.execute_script(<<~JS)
        return Math.max(
          document.body.scrollHeight, document.body.offsetHeight,
          document.documentElement.clientHeight,
          document.documentElement.scrollHeight,
          document.documentElement.offsetHeight
        );
      JS
    end
  end
end
