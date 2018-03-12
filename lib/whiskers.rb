
module Whiskers

  def self.to_hash(list)
    list = list.each_with_index.map { |v,i| [i.to_s,v] }
    Hash[*list.flatten]
  end

  def self.flatten(hash, root = "")
    node = {}
    hash.each do |k,v|
      case v
      when Hash  then node.merge!(flatten(v, "#{root}#{k}."))
      when Array then node.merge!(flatten(to_hash(v), "#{root}#{k}."))
      else node["#{root}#{k}"] = v
      end
    end
    return node
  end

  def self.template(text, args)
    vars = flatten(args)
    text.gsub(/{{.*?}}/) {|v| v.gsub!(/[{}]/,""); vars[v] }
  end

end
