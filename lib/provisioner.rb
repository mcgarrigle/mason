
# TFTP_DIR = "/var/lib/tftpboot/pxelinux.cfg"
# WWW_DIR  = "/var/www/html/ks"

# CONF_DIR = File.join(File.dirname(__FILE__), "..", "configuration")
# BOOT_TEMPLATE      = File.join(CONF_DIR, "template")
# KICKSTART_TEMPLATE = File.join(CONF_DIR, "template.ks")

require 'hosts'
require 'mason'
require 'whiskers'

class Provisioner

  def initialize(node)
    @node = node.dup
    @fqdn = @node["fqdn"]
    @node["mason.address"] = Mason.config.address
    @node["mason.url"]     = Mason.config.url
  end

  def mac_address(mac)
    mac.scan(/../).join(":")
  end

  def mac_boot(mac)
    mac = "01" + mac
    mac.downcase.scan(/../).join("-")
  end

  def kickstart
    @node["interfaces"].each do |interface|
      interface["mac"] = mac_address(interface["mac"])
    end
    template = File.read(Mason.config.kickstart_template)
    Whiskers.template(template, @node)
  end

  # target = install or localdisk

  def bootfile(boot = "install")
    @node["mason.boot"] = boot
    mac  = mac_boot(@node["interfaces"][0]["mac"])
    temp = File.read(Mason.config.boot_template)
    text = Whiskers.template(temp, @node)
    path = File.join(Mason.config.tftp_dir, mac)
    File.write(path, text)
  end

  def dns
    hosts = Hosts::File.read("/etc/hosts")
    hosts.elements.delete_if {|h| h.name == @fqdn }
    @node["interfaces"].each do |interface|
      element = Hosts::Entry.new(interface["ip"], @fqdn)
      hosts.elements << element
    end
    hosts.write
    system "systemctl reload dnsmasq"
  end

end

