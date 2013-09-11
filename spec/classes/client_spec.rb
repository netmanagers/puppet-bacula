require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'bacula::client' do

  let(:title) { 'bacula::client' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard Centos installation' do
    let(:facts) { {  :operatingsystem => 'Centos', :install_client => 'true' } }
    it { should contain_package('bacula-client').with_ensure('present') }
    it { should contain_service('bacula-fd').with_ensure('running') }
    it { should contain_service('bacula-fd').with_enable('true') }
  end

  describe 'Test standard Debian installation' do
    let(:facts) { {  :operatingsystem => 'Debian', :install_client => 'true' } }
    it { should contain_package('bacula-fd').with_ensure('present') }
    it { should contain_service('bacula-fd').with_ensure('running') }
    it { should contain_service('bacula-fd').with_enable('true') }
    it { should contain_file('bacula-fd.conf').with_ensure('present') }
  end

  describe 'The absent in install_client => false mode ' do
    let(:facts) { {  :operatingsystem => 'Centos', :install_client => 'false' } }
    it { should_not contain_package('bacula-client').with_ensure('absent') }
  end

  describe 'Test standard installation with monitoring and firewalling' do
    let(:facts) do 
      { 
        :monitor        => 'true',
        :firewall       => 'true',
        :client_service => 'bacula-fd',
        :protocol       => 'tcp',
        :client_port    => '9102',
        :port    => '9102',
        :concat_basedir => '/var/lib/puppet/concat',
      }
    end
    it { should contain_package('bacula-client').with_ensure('present') }
    it { should contain_service('bacula-fd').with_ensure('running') }
    it { should contain_service('bacula-fd').with_enable(true) }
    it { should contain_file('bacula-fd.conf').with_ensure('present') }
    it { should contain_monitor__process('bacula_client_process').with_enable(true) }
    it { should contain_monitor__port('monitor_bacula_client_tcp_9102').with_enable(true) }
    it { should contain_firewall('firewall_bacula_client_tcp_9102').with_enable(true) }
  end

  describe 'Test Centos decommissioning - absent' do
    let(:facts) { {:bacula_absent => true, :operatingsystem => 'Centos', :monitor => true} }
    it 'should remove Package[bacula-client]' do should contain_package('bacula-client').with_ensure('absent') end
    it 'should stop Service[bacula-fd]' do should contain_service('bacula-fd').with_ensure('stopped') end
    it 'should not enable at boot Service[bacula-fd]' do should contain_service('bacula-fd').with_enable('false') end
  end

  describe 'Test Debian decommissioning - absent' do
    let(:facts) { {:bacula_absent => true, :operatingsystem => 'Debian', :monitor => true} }
    it 'should remove Package[bacula-fd]' do should contain_package('bacula-fd').with_ensure('absent') end
    it 'should stop Service[bacula-fd]' do should contain_service('bacula-fd').with_ensure('stopped') end
    it 'should not enable at boot Service[bacula-fd]' do should contain_service('bacula-fd').with_enable('false') end
  end

  describe 'Test decommissioning - disable' do
    let(:facts) { {:bacula_disable => true, :monitor => true} }
    it { should contain_package('bacula-client').with_ensure('present') }
    it 'should stop Service[bacula-fd]' do should contain_service('bacula-fd').with_ensure('stopped') end
    it 'should not enable at boot Service[bacula-fd]' do should contain_service('bacula-fd').with_enable('false') end
  end

  describe 'Test decommissioning - disableboot' do
    let(:facts) { {:bacula_disableboot => true, :monitor => true } }
    it { should contain_package('bacula-client').with_ensure('present') }
    it { should_not contain_service('bacula-fd').with_ensure('present') }
    it { should_not contain_service('bacula-fd').with_ensure('absent') }
    it 'should not enable at boot Service[bacula-fd]' do should contain_service('bacula-fd').with_enable('false') end
  end

  describe 'Test noops mode' do
    let(:facts) { {:bacula_noops => true, :monitor => true} }
    it { should contain_package('bacula-client').with_noop('true') }
    it { should contain_service('bacula-fd').with_noop('true') }
  end


end 

