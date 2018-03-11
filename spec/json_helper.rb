
require 'json'

module JsonHelper
  def json_fixture(name)
    text = File.read(File.join('spec', 'fixtures', "#{name}.json"))
    JSON.parse(text)
  end
end
