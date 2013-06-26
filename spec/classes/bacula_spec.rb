require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'bacula' do

  let(:title) { 'bacula' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42', :concat_basedir => '/var/lib/puppet/concat'} }

  describe 'Test include bacula::client' do
    let(:params) { {:is_client => 'true' } }
    it { should include_class('bacula::client') }
  end

  describe 'Test include bacula::storage' do
    let(:params) { {:is_storage => 'true' } }
    it { should include_class('bacula::storage') }
  end

  describe 'Test include bacula::director' do
    let(:params) { {:is_director => 'true' } }
    it { should include_class('bacula::director') }
  end

  describe 'Test include bacula::console' do
    let(:params) { {:manage_console => 'true' } }
    it { should include_class('bacula::console') }
  end

  describe 'Test not include bacula::client' do
    let(:params) { {:is_client => 'false' } }
    it { should_not include_class('bacula::client') }
  end

  describe 'Test not include bacula::storage' do
    let(:params) { {:is_storage => 'false' } }
    it { should_not include_class('bacula::storage') }
  end

  describe 'Test not include bacula::director' do
    let(:params) { {:is_director => 'false' } }
    it { should_not include_class('bacula::director') }
  end

  describe 'Test not include bacula::console' do
    let(:params) { {:manage_console => 'false' } }
    it { should_not include_class('bacula::console') }
  end

#  describe 'Test standard installation' do
#    it { should contain_package('bacula').with_ensure('present') }
#    it { should contain_service('bacula').with_ensure('running') }
#    it { should contain_service('bacula').with_enable('true') }
#    it { should contain_file('bacula.conf').with_ensure('present') }
#  end

#  describe 'Test installation of a specific version' do
#    let(:params) { {:version => '1.0.42' } }
#    it { should contain_package('bacula').with_ensure('1.0.42') }
#  end

#  describe 'Test standard installation with monitoring and firewalling' do
#    let(:params) { {:monitor => true , :firewall => true, :port => '42', :protocol => 'tcp' } }
#    it { should contain_package('bacula').with_ensure('present') }
#    it { should contain_service('bacula').with_ensure('running') }
#    it { should contain_service('bacula').with_enable('true') }
#    it { should contain_file('bacula.conf').with_ensure('present') }
#    it { should contain_monitor__process('bacula_process').with_enable('true') }
#    it { should contain_firewall('bacula_tcp_42').with_enable('true') }
#  end

#  describe 'Test decommissioning - absent' do
#    let(:params) { {:absent => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
#    it 'should remove Package[bacula]' do should contain_package('bacula').with_ensure('absent') end
#    it 'should stop Service[bacula]' do should contain_service('bacula').with_ensure('stopped') end
#    it 'should not enable at boot Service[bacula]' do should contain_service('bacula').with_enable('false') end
#    it 'should remove bacula configuration file' do should contain_file('bacula.conf').with_ensure('absent') end
#    it { should contain_monitor__process('bacula_process').with_enable('false') }
#    it { should contain_firewall('bacula_tcp_42').with_enable('false') }
#  end

#  describe 'Test decommissioning - disable' do
#    let(:params) { {:disable => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
#    it { should contain_package('bacula').with_ensure('present') }
#    it 'should stop Service[bacula]' do should contain_service('bacula').with_ensure('stopped') end
#    it 'should not enable at boot Service[bacula]' do should contain_service('bacula').with_enable('false') end
#    it { should contain_file('bacula.conf').with_ensure('present') }
#    it { should contain_monitor__process('bacula_process').with_enable('false') }
#    it { should contain_firewall('bacula_tcp_42').with_enable('false') }
#  end

#  describe 'Test decommissioning - disableboot' do
#    let(:params) { {:disableboot => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
#    it { should contain_package('bacula').with_ensure('present') }
#    it { should_not contain_service('bacula').with_ensure('present') }
#    it { should_not contain_service('bacula').with_ensure('absent') }
#    it 'should not enable at boot Service[bacula]' do should contain_service('bacula').with_enable('false') end
#    it { should contain_file('bacula.conf').with_ensure('present') }
#    it { should contain_monitor__process('bacula_process').with_enable('false') }
#    it { should contain_firewall('bacula_tcp_42').with_enable('true') }
#  end

#  describe 'Test noops mode' do
#    let(:params) { {:noops => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
#    it { should contain_package('bacula').with_noop('true') }
#    it { should contain_service('bacula').with_noop('true') }
#    it { should contain_file('bacula.conf').with_noop('true') }
#    it { should contain_monitor__process('bacula_process').with_noop('true') }
#    it { should contain_monitor__process('bacula_process').with_noop('true') }
#   it { should contain_monitor__port('bacula_tcp_42').with_noop('true') }
#    it { should contain_firewall('bacula_tcp_42').with_noop('true') }
#  end

#  describe 'Test customizations - template' do
#    let(:params) { {:template => "bacula/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
#    it 'should generate a valid template' do
#      content = catalogue.resource('file', 'bacula.conf').send(:parameters)[:content]
#      content.should match "fqdn: rspec.example42.com"
#    end
#    it 'should generate a template that uses custom options' do
#      content = catalogue.resource('file', 'bacula.conf').send(:parameters)[:content]
#      content.should match "value_a"
#    end
#  end

#  describe 'Test customizations - source' do
#    let(:params) { {:source => "puppet:///modules/bacula/spec"} }
#    it { should contain_file('bacula.conf').with_source('puppet:///modules/bacula/spec') }
#  end

 # describe 'Test customizations - source_dir' do
 #   let(:params) { {:source_dir => "puppet:///modules/bacula/dir/spec" , :source_dir_purge => true } }
 #   it { should contain_file('bacula.dir').with_source('puppet:///modules/bacula/dir/spec') }
 #   it { should contain_file('bacula.dir').with_purge('true') }
 #   it { should contain_file('bacula.dir').with_force('true') }
 # end

#  describe 'Test customizations - custom class' do
#    let(:params) { {:my_class => "bacula::spec" } }
#    it { should contain_file('bacula.conf').with_content(/rspec.example42.com/) }
#  end

#  describe 'Test service autorestart' do
#    let(:params) { {:service_autorestart => "no" } }
#    it 'should not automatically restart the service, when service_autorestart => false' do
#      content = catalogue.resource('file', 'bacula.conf').send(:parameters)[:notify]
#      content.should be_nil
#    end
#  end

#  describe 'Test Puppi Integration' do
#    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }
#    it { should contain_puppi__ze('bacula').with_helper('myhelper') }
#  end

#  describe 'Test Monitoring Tools Integration' do
#    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }
#    it { should contain_monitor__process('bacula_process').with_tool('puppi') }
#  end

#  describe 'Test Firewall Tools Integration' do
#    let(:params) { {:firewall => true, :firewall_tool => "iptables" , :protocol => "tcp" , :port => "42" } }
#    it { should contain_firewall('bacula_tcp_42').with_tool('iptables') }
#  end

#  describe 'Test OldGen Module Set Integration' do
#    let(:params) { {:monitor => "yes" , :monitor_tool => "puppi" , :firewall => "yes" , :firewall_tool => "iptables" , :puppi => "yes" , :port => "42" , :protocol => 'tcp' } }
#    it { should contain_monitor__process('bacula_process').with_tool('puppi') }
#    it { should contain_firewall('bacula_tcp_42').with_tool('iptables') }
#    it { should contain_puppi__ze('bacula').with_ensure('present') }
#  end

#  describe 'Test params lookup' do
#    let(:facts) { { :monitor => true , :ipaddress => '10.42.42.42' } }
#    let(:params) { { :port => '42' } }
#    it 'should honour top scope global vars' do should contain_monitor__process('bacula_process').with_enable('true') end
#  end

#  describe 'Test params lookup' do
#    let(:facts) { { :bacula_monitor => true , :ipaddress => '10.42.42.42' } }
#    let(:params) { { :port => '42' } }
#    it 'should honour module specific vars' do should contain_monitor__process('bacula_process').with_enable('true') end
#  end

#  describe 'Test params lookup' do
#    let(:facts) { { :monitor => false , :bacula_monitor => true , :ipaddress => '10.42.42.42' } }
#    let(:params) { { :port => '42' } }
#    it 'should honour top scope module specific over global vars' do should contain_monitor__process('bacula_process').with_enable('true') end
#  end

#  describe 'Test params lookup' do
#    let(:facts) { { :monitor => false , :ipaddress => '10.42.42.42' } }
#    let(:params) { { :monitor => true , :firewall => true, :port => '42' } }
#    it 'should honour passed params over global vars' do should contain_monitor__process('bacula_process').with_enable('true') end
#  end

end

