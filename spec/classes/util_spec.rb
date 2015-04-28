require 'spec_helper'

describe Conduit::Util do
  describe 'find_driver' do
    it 'should find MyDriver' do
      driver = Conduit::Util.find_driver(:my_driver)
      driver.should_not be_nil
    end

    it 'should not throw exception for missing driver' do
      driver = Conduit::Util.find_driver(:missing)
      driver.should be_nil
    end
  end

  describe 'find_driver!' do
    it 'should throw NameError if it driver not found' do
      lambda do
        Conduit::Util.find_driver!(:not_really_there)
      end.should raise_error(NameError)
    end
  end
end
