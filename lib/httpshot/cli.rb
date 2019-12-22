# frozen_string_literal: true

module Httpshot
  # Httpshot::CLI
  class CLI
    attr_accessor :urls
    attr_accessor :options

    # @return [Httpshot::CLI]
    def initialize(argv)
      @options = { driver: :chrome, ua: nil }
      argv = parse!(argv)
      @urls = argv
    end

    # @return [OptionParser]
    def parser
      opt = OptionParser.new
      opt.on('-d [=VAL]', '--driver [=VAL]', String,
             "driver default: #{@options[:driver]}") do |v|
        @options[:driver] = v.to_sym
      end
      opt.on('-u [=VAL]', '--user-agent [=VAL]', String, 'user agent') do |v|
        @options[:ua] = v
      end
      opt
    end

    # @return [Array]
    def parse!(argv)
      parser.parse!(argv)
      argv
    end

    def execute
      d = driver
      @urls.each do |url|
        screenshot d, url
      end
    end

    # @params [Selenium::WebDriver::Driver]
    def screenshot(d, url)
      d.navigate.to url
      w = d.execute_script width_script
      h = d.execute_script height_script
      d.manage.window.resize_to(w + 100, h + 100)
      d.save_screenshot "#{Time.now.strftime('%Y%m%d%H%M%S%L')}_httpshot.png"
    end

    # @return [Selenium::WebDriver::Driver]
    def driver
      Webdrivers.install_dir = File.expand_path '../../drivers', __dir__
      case @options[:driver]
      when :chrome
        chrome_driver
      else
        raise ArgumentError
      end
    end

    # @return [Selenium::WebDriver::Driver]
    def chrome_driver
      Webdrivers::Chromedriver.required_version = '79.0.3945.36'
      d_options = Selenium::WebDriver::Chrome::Options.new
      d_options.add_argument '--headless'
      d_options.add_argument "--user-agent=#{@options[:ua]}" if @options[:ua]
      Selenium::WebDriver.for :chrome, options: d_options
    end

    # @return [String]
    def width_script
      <<~JS
        return Math.max(
          document.body.scrollWidth, document.body.offsetWidth,
          document.documentElement.clientWidth,
          document.documentElement.scrollWidth,
          document.documentElement.offsetWidth
        );
      JS
    end

    # @return [String]
    def height_script
      <<~JS
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
