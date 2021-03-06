
require 'json_helper'
require 'whiskers'


describe Whiskers do

  describe "#flatten" do

    let(:server) { json_fixture("server.foo.local") }

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
      expect(Whiskers.flatten(example)).to eql ({"foo.bar.baz"=>100, "foo.bob"=>200, "rat.pig"=>300})
    end

    it "should enumerate an array" do
      example = {'foo' => [{'bar' => 100}, {'baz' => 200 }, {'bob' => 300 }] }
      expect(Whiskers.flatten(example)).to eql ({"foo.0.bar"=>100, "foo.1.baz"=>200, "foo.2.bob"=>300})
    end

  end

  describe "#template" do

    it "should replace any {{pattern}}" do
      expect(Whiskers.template("begin {{bar}} end", {"bar" => "foo"})).to eql("begin foo end")
    end

    it "should replace any {{nested.pattern}}" do
      expect(Whiskers.template("begin {{foo.bar}} end", {"foo" => {"bar" => "baz"}})).to eql("begin baz end")
    end

  end

end
