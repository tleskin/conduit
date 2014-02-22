require 'spec_helper'

shared_examples_for Conduit::Core::Action do

  subject do
    described_class.new(request_attributes)
  end

  context 'without an instance' do
    its(:class) { should respond_to(:remote_url)          }
    its(:class) { should respond_to(:required_attributes) }
    its(:class) { should respond_to(:optional_attributes) }

    describe '.requirements' do
      it 'returns an array of required attributes' do
        subject.class.requirements.should == %i(foo bar baz)
      end
    end

    describe '.attributes' do
      it 'returns an array of known attributes' do
        subject.class.requirements.should == %i(foo bar baz)
      end
    end
  end

  context 'with an instance' do
    describe '#view_context' do
      it 'returns a path to the driver views' do
        base_path   = Conduit::Configuration.driver_path
        driver_path = File.join(base_path, 'my_driver', 'views/')

        subject.view_path.should == driver_path
      end
    end

    describe '#view' do
      it 'returns a rendered view for an action' do
        a = subject.view.gsub(/\s+/, '')
        b = read_support_file('xml/xml_request.xml').gsub(/\s+/, '')
        a.should == b
      end
    end

    describe '#perform' do
      it 'returns a 200 status' do
        subject.perform.status.should == 200
      end

      it 'returns a response body' do
        a = subject.perform.body.gsub(/\s+/, '')
        b = read_support_file('xml/xml_response.xml').gsub(/\s+/, '')
        a.should == b
      end
    end
  end

end

describe Conduit::Driver::MyDriver::Foo do
  it_behaves_like Conduit::Core::Action
end
