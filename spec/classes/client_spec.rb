require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'bacula::client' do

  let(:title) { 'bacula::client' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    let(:facts) { {  :operatingsystem => 'Centos', :is_client => 'true' , :concat_basedir => '/var/lib/puppet/concat'} }
    it { should contain_package('bacula-client').with_ensure('present') }
  end

end 

