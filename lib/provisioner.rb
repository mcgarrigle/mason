
TFTP_DIR = "/var/lib/tftpboot/pxelinux.cfg"
WWW_DIR  = "/var/www/html/ks"

CONF_DIR = File.join(File.dirname(__FILE__), "..", "configuration")
BOOT_TEMPLATE      = File.join(CONF_DIR, "template")
KICKSTART_TEMPLATE = File.join(CONF_DIR, "template.ks")

require 'socket'
require 'whiskers'

class Provisioner

  def initialize(node)
    @listening = Socket.ip_address_list[1].ip_address
    @node = node
    @node["mason.listening"] = @listening
  end

  def mac_address(mac)
    mac.scan(/../).join(":")
  end

  def mac_boot(mac)
    mac = "01" + mac
    mac.downcase.scan(/../).join("-")
  end

  def bootfile
    mac  = mac_boot(@node["interfaces"][0]["mac"])
    temp = File.read(BOOT_TEMPLATE)
    text = Whiskers.template(temp, @node)
    path = File.join(TFTP_DIR, mac)
    File.write(path, text)
  end

  def kickstart
    node = @node.dup
    fqdn = node["fqdn"]
    node["interfaces"].each do |v|
      v["mac"] = mac_address(v["mac"])
    end
    temp = File.read(KICKSTART_TEMPLATE)
    path = File.join(WWW_DIR, "#{fqdn}.ks")
    File.write(path, Whiskers.template(temp, node))
  end

  def provision
    bootfile
    kickstart
  end

end

