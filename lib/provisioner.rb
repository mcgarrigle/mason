
TFTPBOOT = "/var/lib/tftpboot/pxelinux/pxelinux.cfg"
WWWROOT  = "/var/www/html/ks"

class Provisioner

  def initialize(node)
    @node = node
  end

  def mac_address(mac)
    mac.scan(/../).join(":")
  end

  def mac_boot(mac)
    mac = "01" + mac
    mac.downcase.scan(/../).join("-")
  end

  def bootfile
    temp = File.read("#{TFTPBOOT}/template")
    text = Whiskers.template(temp, @node)
    mac  = mac_boot(node["interfaces.0.mac"])
    File.write("#{TFTPBOOT}/#{mac}", text)
  end

  def kickstart
    node = node.dup
    fqdn = node["fqdn"]
    node["interfaces"].values.each do |v|
      v = mac_address(v)
    end
    text = File.read("/var/www/html/ks/template.ks")
    File.write("/var/www/html/ks/#{fqdn}.ks", template(text, node))
  end

  def provision
    bootfile
    kickstart
  end

end

