
require 'mason' 

require 'json_helper'


describe Mason do

  subject { Mason.new }

  let(:server) { json_fixture("server.foo.local") }

  describe "#set" do

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

  end

end
