require 'spec_helper'

shared_examples_for Conduit::Core::Driver do

  context 'without an instance' do
    describe '.credentials' do
      it 'returns an array of required credentials' do
        subject.credentials.should == %i(username password).to_set
      end
    end

    describe '.actions' do
      it 'returns an array of known action' do
        subject.actions.should == %i(foo).to_set
      end
    end

  end

end

describe Conduit::Driver::MyDriver do
  it_behaves_like Conduit::Core::Driver
end
