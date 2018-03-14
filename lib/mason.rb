
require 'redis'
require 'json'

class Mason

  def initialize
    @redis = Redis.new
  end

  def _required(field, klass)
    raise ArgumentError, "missing #{field}" unless klass === @node[field]
  end

  def _matches(field, regex)
    _required(field, String)
    match = @node[field].match(regex)
    raise ArgumentError, "incorrect #{field}" unless match
  end

  def set(node)
    @node = node
    _matches('fqdn', /^[\-\.a-z0-9]+$/)
    key = "node/#{node['fqdn']}"
    @redis.set(key, node.to_json)
  end

  def get(fqdn)
    key  = "node/#{fqdn}"
    text = @redis.get(key)
    JSON.parse(text)
  end

  def del(fqdn)
  end

  def provision(fqdn)
  end

end
