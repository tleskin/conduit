require 'spec_helper'

describe Conduit::Response do

  let(:attributes) do
    {
      clec_id:  'foo',
      username: 'bar',
      token:    'foo2',
      mdn:      'bar2',
      plan_id:  1
    }
  end

  before do
    @request  = Conduit::Request.create(driver: :fusion,
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