require 'spec_helper'

describe Conduit::Driver::Example::Purchase do

  let(:attributes) do
    {
      required_foo: 'foo',
      required_bar: 'bar',
      optional_foo: 'foo2',
      optional_bar: 'bar2'
    }
  end

  subject do
    Conduit::Driver::Example::Purchase.new(attributes)
  end

  it { should respond_to(:perform) }
  it { should respond_to(:request) }
  it { should respond_to(:render)  }

  describe '::remote_url' do
    it 'allows setting a remote url' do
      subject.class.send(:remote_url, 'http://foo.com')
      subject.remote_url.should eq 'http://foo.com'
    end
  end

  describe '#requirements' do
    it 'has a list of required attributes' do
      required_keys = attributes.select do |k,v|
        k =~ /required_.*/
      end.keys

      subject.requirements.should eq required_keys
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
      subject.view_path.should =~ /spec\/support\/example\/views\/$/
    end

    it 'returns a path that exists' do
      File.exists?(subject.view_path).should be true
    end
  end

  describe '#view' do
    it 'parses the template, and returns a string' do
      subject.view.should_not be_nil
    end

    it 'contains the values from #view_context' do
      values = Hash.from_xml(subject.view).values.first
      values.should eq Hash[attributes.map { |k,v| [k.to_s, v.to_s] }]
    end
  end

end