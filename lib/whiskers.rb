
module Whiskers

  def self.flatten(hash, root = "")
    node = {}
    hash.each do |k,v|
      if v.is_a?(Hash)
        child = flatten(v, "#{root}#{k}.")
        node.merge!(child)
      else
        node["#{root}#{k}"] = v
      end
    end
    return node
  end

  def self.template(text, args)
    text.gsub(/{{.*?}}/) {|v| v.gsub!(/[{}]/,""); args[v] }
  end

end
