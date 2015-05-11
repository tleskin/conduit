require 'spec_helper'

shared_examples_for Conduit::Core::Driver do

  context 'without an instance' do
    describe '.credentials' do
      it 'returns an array of required credentials' do
        subject.credentials.should == [:username, :password].to_set
      end
    end

    describe '.actions' do
      it 'returns an array of known action' do
        subject.actions.should == [:foo].to_set
      end
    end

    describe '.permitted_attributes' do
      it 'returns the union of required and optional attributes' do
        subject.permitted_attributes.should == [:subdomain, :mock].to_set
      end
    end

    describe 'required_attributes' do
      it 'should return only the required attributes' do
        subject.required_attributes.should eql [:subdomain].to_set
      end
    end

    describe 'optional_attributes' do
      it 'should return only the optional attributes' do
        subject.optional_attributes.should eql [:mock].to_set
      end
    end

  end

end

describe Conduit::Driver::MyDriver do
  it_behaves_like Conduit::Core::Driver
end
