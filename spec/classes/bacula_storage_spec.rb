require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'bacula::storage' do

  let(:title) { 'bacula::storage' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :manage_storage => 'true',
      :ipaddress => '10.42.42.42',
      :service_autorestart => true
    }
  end
  describe 'Test standard Centos installation' do
    let(:facts) { {  :operatingsystem => 'Centos' } } 
    it { should contain_package('bacula-storage-mysql').with_ensure('present') }
    it { should contain_file('bacula-sd.conf').with_ensure('present') }
    it { should contain_file('bacula-sd.conf').with_path('/etc/bacula/bacula-sd.conf') }
    it { should contain_file('bacula-sd.conf').without_content }
    it { should contain_file('bacula-sd.conf').without_source }
    it { should contain_service('bacula-sd').with_ensure('running') }
    it { should contain_service('bacula-sd').with_enable('true') }
  end

  describe 'Test standard Debian installation' do
    let(:facts) { {  :operatingsystem => 'Debian' } }
    it { should contain_package('bacula-sd-mysql').with_ensure('present') }
  end

  describe 'Test service autorestart' do
    it 'should automatically restart the service, by default' do
      should contain_file('bacula-sd.conf').with_notify('Service[bacula-sd]')
    end
  end

  describe 'Test customizations - provide source' do
    let(:facts) do
      {
        :bacula_storage_source  => 'puppet:///modules/bacula/bacula.source'
      }
    end
    it { should contain_file('bacula-sd.conf').with_path('/etc/bacula/bacula-sd.conf') }
    it { should contain_file('bacula-sd.conf').with_source('puppet:///modules/bacula/bacula.source') }
  end

  describe 'Test customizations - default_password' do
    let(:facts) do
      {
        :bacula_storage_name => 'storage_master',
        :bacula_default_password => 'master_pass',
        :bacula_storage_template => 'bacula/bacula-sd.conf.erb'
      }
    end
    it { should contain_file('bacula-sd.conf').with_content(/Password = "master_pass".*Password = "master_pass"/m) }
  end

  describe 'Test customizations - provided template' do
    let(:facts) do
      {
        :bacula_storage_name => 'here_storage',
        :bacula_default_password => 'stuvwxyz',
        :bacula_storage_password => 'storage_pass',
        :bacula_storage_port => '4242',
        :bacula_storage_address => '10.42.42.42',
        :bacula_storage_template => 'bacula/bacula-sd.conf.erb',
        :bacula_heartbeat_interval => 'some interval'
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

# Note: use external director address for clients to connect.
Storage {
  Name = "here_storage"
  SDAddress = 10.42.42.42
  SDPort = 4242
  WorkingDirectory = /var/spool/bacula
  Pid Directory = /var/run
  Maximum Concurrent Jobs = 30
  Heartbeat Interval = some interval
}

# Director who is permitted to contact this Storage daemon.
Director {
  Name = "rspec.example42.com-dir"
  Password = "storage_pass"
}

# Storage devices.
# Read storage directory for config files. Remember to bconsole "reload" after adding a client.
@|"find /etc/bacula/storage.d -name \'*.conf\' -type f -exec echo @{} \;"

# Restricted Director, used by tray-monitor for Storage daemon status.
Director {
  Name = "rspec.example42.com-mon"
  Password = "stuvwxyz"
  Monitor = Yes
}

Messages {
  Name = "standard"
  Director = rspec.example42.com-dir = all, !skipped, !restored
}
'
    end
    it 'should create a valid config file' do
      should contain_file('bacula-sd.conf').with_content(expected)
    end
  end

  describe 'Test customizations - custom template' do
    let(:facts) do
      {
        :bacula_storage_template => 'bacula/spec.erb',
        :options => { 'opt_a' => 'value_a' }
      }
    end
    it { should contain_file('bacula-sd.conf').without_source }
    it 'should generate a valid template' do
      should contain_file('bacula-sd.conf').with_content(/fqdn: rspec.example42.com/)
    end
    it 'should generate a template that uses custom options' do
      should contain_file('bacula-sd.conf').with_content(/value_a/)
    end
  end


  describe 'Test Centos decommissioning - absent' do
    let(:facts) do
      { 
        :bacula_absent => true,
        :bacula_monitor_target => '10.42.42.42',
        :storage_pid_file =>  'some.pid.file',
        :operatingsystem => 'Centos',
        :monitor => true
      }
    end
    it 'should remove Package[bacula-storage-mysql]' do should contain_package('bacula-storage-mysql').with_ensure('absent') end
    it 'should stop Service[bacula-sd]' do should contain_service('bacula-sd').with_ensure('stopped') end
    it 'should not enable at boot Service[bacula-sd]' do should contain_service('bacula-sd').with_enable('false') end
  end

  describe 'Test Debian decommissioning - absent' do
    let(:facts) do
      {
        :bacula_absent => true,
        :bacula_monitor_target => '10.42.42.42',
        :storage_pid_file =>  'some.pid.file',
        :operatingsystem => 'Debian',
        :monitor => true
      }
    end
    it 'should remove Package[bacula-sd-mysql]' do should contain_package('bacula-sd-mysql').with_ensure('absent') end
    it 'should stop Service[bacula-sd]' do should contain_service('bacula-sd').with_ensure('stopped') end
    it 'should not enable at boot Service[bacula-sd]' do should contain_service('bacula-sd').with_enable('false') end
  end

  describe 'Test decommissioning - disable' do
    let(:facts) do
      {
        :bacula_disable => true,
        :bacula_monitor_target => '10.42.42.42',
        :storage_pid_file =>  'some.pid.file',
        :monitor => true
      }
    end
    it { should contain_package('bacula-storage-mysql').with_ensure('present') }
    it 'should stop Service[bacula-sd]' do should contain_service('bacula-sd').with_ensure('stopped') end
    it 'should not enable at boot Service[bacula-sd]' do should contain_service('bacula-sd').with_enable('false') end
  end

  describe 'Test decommissioning - disableboot' do
    let(:facts) do
      { 
        :bacula_disableboot => true,
        :bacula_monitor_target => '10.42.42.42',
        :storage_pid_file =>  'some.pid.file',
        :monitor => true 
      }
    end
    it { should contain_package('bacula-storage-mysql').with_ensure('present') }
    it { should_not contain_service('bacula-sd').with_ensure('present') }
    it { should_not contain_service('bacula-sd').with_ensure('absent') }
    it 'should not enable at boot Service[bacula-sd]' do should contain_service('bacula-sd').with_enable('false') end
    it { should contain_monitor__process('bacula_storage_process').with_enable('false') }
  end

  describe 'Test noops mode' do
    let(:facts) do
      { 
        :bacula_noops => true,
        :bacula_monitor_target => '10.42.42.42',
        :storage_pid_file =>  'some.pid.file',
        :monitor => true 
      }
    end
    it { should contain_package('bacula-storage-mysql').with_noop('true') }
    it { should contain_service('bacula-sd').with_noop('true') }
    it { should contain_monitor__process('bacula_storage_process').with_noop('true') }
    it { should contain_monitor__process('bacula_storage_process').with_noop('true') }
  end
end
