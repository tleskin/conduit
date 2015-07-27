require 'spec_helper'

shared_examples_for Conduit::Core::Action do

  let(:request)  { read_support_file('xml/xml_request.xml')  }
  let(:response) { read_support_file('xml/xml_response.xml') }

  subject do
    described_class.new(request_attributes)
  end

  context 'without an instance' do
    its(:class) { should respond_to(:remote_url)          }
    its(:class) { should respond_to(:required_attributes) }
    its(:class) { should respond_to(:optional_attributes) }

    describe '.requirements' do
      it 'returns an array of required attributes' do
        subject.class.requirements.should == [:foo, :bar, :baz].to_set
      end
    end

    describe '.attributes' do
      it 'returns an array of known attributes' do
        subject.class.requirements.should == [:foo, :bar, :baz].to_set
      end
    end
  end

  context 'with an instance' do
    describe '#view' do
      before do
        Excon.stub({}, body: request, status: 200)
      end

      it 'returns a rendered view for an action' do
        a = subject.view.gsub(/\s+/, '')
        b = request.gsub(/\s+/, '')
        a.should == b
      end
    end

    describe '.new' do
      it 'should raise an error if any required arguments are not supplied' do
        expect { described_class.new({}) }.to raise_error(ArgumentError)
      end

      it 'should raise an error if any required arguments are nil' do
        options = request_attributes.inject({}) do |h, (k, v)|
          h.merge(k => nil)
        end
        expect { described_class.new(options) }.to raise_error(ArgumentError)
      end
    end

    describe '#perform' do
      before { Excon.stub({}, body: response, status: 200) }

      it 'returns a response wrapper' do
        subject.perform.should be_a_kind_of(Conduit::ApiResponse)
      end

      it 'should return the raw_content' do
        subject.perform.body.should_not be_nil
      end
    end
  end

end

describe Conduit::Driver::MyDriver::Foo do
  it_behaves_like Conduit::Core::Action
end
