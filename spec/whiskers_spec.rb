
require 'whiskers'


describe Whiskers do

  describe "#flatten" do

    it "should reproduce top level keys" do
      example = {'foo.bar.baz' => 'bob'}
      expect(Whiskers.flatten(example)).to eql(example)
    end

    it "should enumerate nested keys" do
      example = {'foo' => {'bar' => 100 } }
      expect(Whiskers.flatten(example)).to eql({'foo.bar' => 100})
    end

    it "should enumerate really nested keys" do
      example = {'foo' => {'bar' => {'baz' => 100 } } }
      expect(Whiskers.flatten(example)).to eql({'foo.bar.baz' => 100})
    end

    it "should enumerate a tree" do
      example = {'foo' => {'bar' => {'baz' => 100 }, 'bob' => 200 }, 'rat' => {'pig' => 300 } }
      expect(Whiskers.flatten(example)).to eql({"foo.bar.baz"=>100, "foo.bob"=>200, "rat.pig"=>300})
    end

  end

end
