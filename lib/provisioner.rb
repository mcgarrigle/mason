
# TFTP_DIR = "/var/lib/tftpboot/pxelinux.cfg"
# WWW_DIR  = "/var/www/html/ks"

# CONF_DIR = File.join(File.dirname(__FILE__), "..", "configuration")
# BOOT_TEMPLATE      = File.join(CONF_DIR, "template")
# KICKSTART_TEMPLATE = File.join(CONF_DIR, "template.ks")

require 'mason'
require 'whiskers'

class Provisioner

  def self.mac_address(mac)
    mac.scan(/../).join(":")
  end

  def self.kickstart(node)
    node["mason.address"] = Mason.config.address
    node["mason.url"]     = Mason.config.url
    fqdn = node["fqdn"]
    node["interfaces"].each do |v|
      v["mac"] = mac_address(v["mac"])
    end
    template = File.read(Mason.config.kickstart_template)
    Whiskers.template(template, node)
  end

  def self.mac_boot(mac)
    mac = "01" + mac
    mac.downcase.scan(/../).join("-")
  end

  def self.bootfile(node)
    node["mason.address"] = Mason.config.address
    node["mason.url"]     = Mason.config.url
    mac  = mac_boot(node["interfaces"][0]["mac"])
    temp = File.read(Mason.config.boot_template)
    text = Whiskers.template(temp, node)
    path = File.join(Mason.config.tftp_dir, mac)
    File.write(path, text)
  end

end

