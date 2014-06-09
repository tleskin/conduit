require 'spec_helper'

shared_examples_for Conduit::Core::Parser do

  let(:response) { read_support_file('xml/xml_response.xml') }

  subject do
    described_class.new(response)
  end

  context 'without an instance' do
    its(:class) { should respond_to(:attribute)  }
    its(:class) { should respond_to(:attributes) }
  end

  context 'with an instance' do
    describe '#attributes' do
      it 'returns an array of known attributes' do
        subject.attributes.should == %i(foo bar baz).to_set
      end

      it 'defines a method for foo' do
        subject.foo.should == 'foo'
      end

      it 'defines a method for bar' do
        subject.bar.should == 'bar'
      end

      it 'defines a method for baz' do
        subject.baz.should == 'baz'
      end
    end

    describe '#response_status' do
      it 'should respond with success' do
        subject.response_status.should == 'success'
      end
    end

    describe '#response_errors' do
      it 'should respond with an empty array' do
        subject.response_errors.should == []
      end
    end
  end

end

describe Conduit::Driver::MyDriver::Foo::Parser do
  it_behaves_like Conduit::Core::Parser
end
