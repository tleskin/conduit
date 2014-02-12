require 'spec_helper'

describe Conduit::Driver::Fusion do

  subject { Conduit::Driver::Fusion }

  its(:actions)     { should eq [:purchase, :activate, :deactivate, :suspend, :swap] }
  its(:credentials) { should eq [:clec_id, :username, :token] }

end