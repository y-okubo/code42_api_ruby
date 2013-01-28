require 'spec_helper'

describe Crashplan::Client do
  subject(:client) do
    Crashplan::Client.new(
      host: 'example.com',
      port: 1234,
      https: false,
      api_root: '/api/v2'
    )
  end

  before do
    Faraday.default_adapter = :net_http
  end

  describe "#get" do
    it "should make a request" do
      path = 'org/my'
      stub = stub_get(%r(#{path}$))
      client.get path
      stub.should have_been_made
    end
  end

  describe "#user" do
    context "when ID is not passed" do
      it "should return my user" do
        stub_get(/example.com/).to_return(body: fixture('user.my.json'))
        client.user.should be_a(Crashplan::User)
      end
    end

    context "when ID is passed in" do
      it "should return specific user" do
        request = stub_get(%r(/user/1)).to_return(body: fixture('user.1.json'))
        client.user(1)
        request.should have_been_made
      end
    end
  end

  describe "#org" do
    before do
      stub_get(/example.com/).to_return(body: fixture('org.my.json'))
    end

    context "when ID is not passed" do
      it "should return my org" do
        client.org.should be_a(Crashplan::Org)
      end
    end

    context "when ID is passed in" do
      it "should return specific org" do
        request = stub_get(%r(/org/1)).to_return(body: fixture("org.1.json"))
        client.org(1)
        request.should have_been_made
      end
    end
  end

  describe "#ping" do
    before do
      stub_get(/example.com/).to_return(body: fixture('ping.json'))
    end

    it "should return a ping" do
      client.ping.should be_a(Crashplan::Ping)
    end
  end
end
