require 'spec_helper'
describe 'controlrepo' do
  context 'with default values for all parameters' do
    it { should contain_class('controlrepo') }
  end
end
