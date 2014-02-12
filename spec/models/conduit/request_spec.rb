require 'spec_helper'

describe Conduit::Request do

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
    @request = Conduit::Request.create(driver: :fusion,
      action: :purchase, options: attributes)
  end

  describe "#create" do
    it "generates a file path for storage" do
      @request.file.should_not be_nil
    end

    it "saves the record to the database" do
      @request.persisted?.should be_true
    end
  end

  describe "#destroy" do
    before { @request.destroy }

    it "removes the record from the database" do
      @request.destroyed?.should be_true
    end
  end

end