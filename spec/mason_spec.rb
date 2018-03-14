
require 'mason' 
require 'json_helper'


describe Mason do

  subject { Mason.new }

  before :each do
    @mock_redis = double(:set => "OK", :get => '{ "fqdn": "X" }')
    allow(Redis).to receive(:new).and_return(@mock_redis)
  end

  describe "#set" do

    let(:server) { json_fixture("server.foo.local") }

    it "should ensure :fqdn" do
      server.delete 'fqdn'
      expect { subject.set(server) }.to raise_error(ArgumentError);
    end

    it "should ensure :fqdn is String" do
      server['fqdn'] = 1
      expect { subject.set(server) }.to raise_error(ArgumentError);
    end

    it "should error on incorrect :fqdn" do
      server['fqdn'] = 's1%2.foo.local'
      expect { subject.set(server) }.to raise_error(ArgumentError);
    end

    it "should be ok with correct :fqdn" do
      server['fqdn'] = 'bar.foo.local'
      expect { subject.set(server) }.not_to raise_error;
    end

    it "should store node in redis" do
      expect(@mock_redis).to receive(:set).with("node/server.foo.local", any_args)
      subject.set(server)
    end

  end

  describe "#get" do

    it "should get the node from redis" do
      expect(@mock_redis).to receive(:get).with("node/server.foo.local")
      subject.get("server.foo.local")
    end
      
    it "should convert the node from json" do
      expect(@mock_redis).to receive(:get).with("node/server.foo.local")
      expect(subject.get("server.foo.local")).to eql({"fqdn" => "X"})
    end
      
  end

end
