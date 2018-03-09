
require 'whiskers'


describe Whiskers do

  describe "#flatten" do

    it "should reproduce top level keys" do
      example = {'foo.ar.baz' => 'bob'}
      expect(Whiskers.flatten(example)).to eql(example)
    end

  end

end
