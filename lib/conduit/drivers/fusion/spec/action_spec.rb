require 'spec_helper'

describe Conduit::Driver::Fusion::Purchase do

  let(:attributes) do
    {
      clec_id:  'foo',
      username: 'bar',
      token:    'foo2',
      mdn:      'bar2',
      plan_id:  1
    }
  end

  subject do
    Conduit::Driver::Fusion::Purchase.new(attributes)
  end

  it { should respond_to(:perform)    }
  it { should respond_to(:request)    }
  it { should respond_to(:render)     }
  it { should respond_to(:remote_url) }

  describe '#requirements' do
    it 'has a list of required attributes' do
      subject.requirements.should_not be_nil
    end
  end

  describe '#attributes' do
    it 'has a list of both required, and optional attributes' do
      subject.attributes.should eq attributes.keys
    end
  end

  describe '#view_context' do
    it 'returns an object containing the attributes key/values' do
      instance_methods = subject.view_context.instance_variable_get("@table")
      instance_methods.should eq attributes
    end
  end

  describe '#view_path' do
    it 'returns the path to the driver views directory' do
      subject.view_path.should =~ /conduit\/drivers\/fusion\/views/
    end

    it 'returns a path that exists' do
      File.exists?(subject.view_path).should be true
    end
  end

  describe '#view' do
    it 'parses the template, and returns a string' do
      subject.view.should_not be_nil
    end
  end

end