
require 'socket'

module Mason

  def self.version
    "0.0.1"
  end

  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end

  class Configuration
    attr_accessor :tftp_dir, :www_dir, :conf_dir
    attr_accessor :boot_template, :kickstart_template
    attr_accessor :address, :port, :url

    def initialize
      @tftp_dir = "/var/lib/tftpboot/pxelinux.cfg"
      @www_dir  = "/var/www/html/ks"

      @conf_dir = File.join(File.dirname(__FILE__), "..", "configuration")
      @boot_template = File.join(@conf_dir, "template")
      @kickstart_template = File.join(@conf_dir, "template.ks")

      @address = Socket.ip_address_list[1].ip_address
      @port    = 9090
      @url     = "http://#{@address}:#{port}"
    end

  end

end
