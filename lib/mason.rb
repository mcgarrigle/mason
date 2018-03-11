
class Mason

  def _required(field)
    raise ArgumentError, "missing #{field}" unless @node[field]
  end

  def _matches(field, regex)
    match = @node[field].match(regex)
    raise ArgumentError, "incorrect #{field}" unless match
  end


  def set(node)
    @node = node
    _required('fqdn')
    _matches('fqdn', /^[\-\.a-z0-9]+$/)
  end

  def get(fqdn)
  end

  def del(fqdn)
  end

  def provision(fqdn)
  end

end
