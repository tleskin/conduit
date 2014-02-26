require 'spec_helper'

# Create a temporary ActiveRecord object to test with
#
class MyRequestable < ActiveRecord::Base
  acts_as_requestable

  # Update the `updated_at` timestamp
  # so we know this has been called
  #
  def after_conduit_update(action, parsed_response)
    self.update_column(:updated_at, 1.day.from_now)
  end
end

describe MyRequestable do

  # Silly magic to create an empty table for MyRequestable
  #
  before(:all) do
    ActiveRecord::Migration.tap do |a|
      a.verbose = false
      a.create_table(:my_requestables) do |t|
        t.timestamps
      end
    end
  end

  # Silly magic to remove an empty table for MyRequestable
  #
  after(:all) do
    ActiveRecord::Migration.tap do |a|
      a.verbose = false
      a.drop_table(:my_requestables)
    end
  end

  context 'without an instance' do
    its(:class) { should respond_to(:acts_as_requestable) }
    it { should have_many :conduit_requests }
  end

  context 'with an instance' do
    before(:each) do
      Excon.stub({}, body: read_support_file("xml/xml_response.xml"), status: 200)

      @obj = MyRequestable.create
      @obj.conduit_requests.create(driver: :my_driver, action: :foo,
        options: request_attributes).perform_request
    end

    describe '#last_conduit_request' do
      it 'returns the last conduit request made' do
        @obj.last_conduit_request.should_not be_nil
      end

      it 'it should exists within the conduit_requests collection' do
        @obj.conduit_requests.include?(@obj.last_conduit_request).should == true
      end
    end

    describe '#last_conduit_request_action' do
      it 'returns the action of the last conduit request made' do
        @obj.last_conduit_request_action.should == 'foo'
      end
    end

    describe '#last_conduit_request_status' do
      it 'returns the status of the last conduit request made' do
        @obj.last_conduit_request_status.should == 'success'
      end
    end

    describe '#after_conduit_update' do
      it 'gets called after a request is updated' do
        @obj.reload # Bust the cache
        @obj.updated_at.should_not == @obj.created_at
      end
    end

  end

end