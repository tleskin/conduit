require 'spec_helper'

describe Conduit::Response do

  let(:attributes) do
    {
      required_foo: 'foo',
      required_bar: 'bar',
      optional_foo: 'foo2',
      optional_bar: 'bar2'
    }
  end

  before do
    @request  = Conduit::Request.create(driver: :example,
      action: :purchase, options: attributes)
    @response = @request.responses.first
  end

  describe "#create" do
    it "generates a file path from the request" do
      File.dirname(@response.file).should eq File.dirname(@request.file)
    end

    it "saves the record to the database" do
      Conduit::Response.count.should eq 1
    end
  end

  describe "#destroy" do
    before { @response.destroy }

    it "removes the record from the database" do
      @response.destroyed?.should be_true
    end
  end

end