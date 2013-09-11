require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'bacula::director' do

  let(:title) { 'bacula::director' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard Centos installation' do
    let(:facts) { {  :install_director => 'true' , :concat_basedir => '/var/lib/puppet/concat'} }
    it { should contain_package('bacula-director-mysql').with_ensure('present') }
    it { should contain_service('bacula-dir').with_ensure('running') }
    it { should contain_service('bacula-dir').with_enable('true') }
  end
                                                                                                                                                                                                
  describe 'The absent in install_director => false mode ' do                                                                                                                                          
    let(:facts) { {  :install_director => 'false' , :concat_basedir => '/var/lib/puppet/concat'} }
    it { should_not contain_package('bacula-director-mysql').with_ensure('absent') }
  end

  describe 'Test Centos decommissioning - absent' do
    let(:facts) { {:bacula_absent => true,  :monitor => true} }
    it 'should remove Package[bacula-director-mysql]' do should contain_package('bacula-director-mysql').with_ensure('absent') end
    it 'should stop Service[bacula-dir]' do should contain_service('bacula-dir').with_ensure('stopped') end
    it 'should not enable at boot Service[bacula-dir]' do should contain_service('bacula-dir').with_enable('false') end
  end

  describe 'Test decommissioning - disable' do
    let(:facts) { {:bacula_disable => true, :monitor => true} }
    it { should contain_package('bacula-director-mysql').with_ensure('present') }
    it 'should stop Service[bacula-dir]' do should contain_service('bacula-dir').with_ensure('stopped') end
    it 'should not enable at boot Service[bacula-dir]' do should contain_service('bacula-dir').with_enable('false') end
  end

  describe 'Test decommissioning - disableboot' do
    let(:facts) { {:bacula_disableboot => true, :monitor => true } }
    it { should contain_package('bacula-director-mysql').with_ensure('present') }
    it { should_not contain_service('bacula-dir').with_ensure('present') }
    it { should_not contain_service('bacula-dir').with_ensure('absent') }
    it 'should not enable at boot Service[bacula-dir]' do should contain_service('bacula-dir').with_enable('false') end
#    it { should contain_monitor__process('nut_process').with_enable('false') }
  end

  describe 'Test noops mode' do
    let(:facts) { {:bacula_noops => true, :monitor => true} }
    it { should contain_package('bacula-director-mysql').with_noop('true') }
    it { should contain_service('bacula-dir').with_noop('true') }
#    it { should contain_monitor__process('nut_process').with_noop('true') }
#    it { should contain_monitor__process('nut_process').with_noop('true') }
  end


end 
