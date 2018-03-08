
module Whiskers

  def flatten(hash)
    node = {}
    hash.each do |k,v|
      if v.is_a?(Hash)
        v.each do |j,v|
          node["#{k}.#{j}"] = v
        end
      else
        node[k] = v
      end
    end
    return node
  end

  def template(text, args)
    text.gsub(/{{.*?}}/) {|v| v.gsub!(/[{}]/,""); args[v] }
  end

end
