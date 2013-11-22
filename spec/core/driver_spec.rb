require 'spec_helper'

describe Conduit::Driver::Example do

  it 'has a list of actions' do
    subject.actions.should include('purchase')
  end

  it 'loads a class for each action' do
    subject.actions.each do |action|
      klass = action.classify.to_sym
      subject.constants.should include(klass)
    end
  end

end