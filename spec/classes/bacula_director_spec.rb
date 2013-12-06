require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'bacula::director' do

  let(:title) { 'bacula::director' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :manage_director => 'true',
      :ipaddress => '10.42.42.42'
    }
  end
  describe 'Test standard Centos installation' do
    it { should contain_package('bacula-director-mysql').with_ensure('present') }
    it { should contain_file('bacula-dir.conf').with_ensure('present') }
    it { should contain_file('bacula-dir.conf').with_path('/etc/bacula/bacula-dir.conf') }
    it { should contain_file('bacula-dir.conf').without_content }
    it { should contain_file('bacula-dir.conf').without_source }
    it { should contain_service('bacula-dir').with_ensure('running') }
    it { should contain_service('bacula-dir').with_enable('true') }
  end

  describe 'Test service autorestart' do
    it 'should automatically restart the service, by default' do
      should contain_file('bacula-dir.conf').with_notify('Service[bacula-dir]')
    end
  end

  describe 'Test customizations - provide source' do
    let(:facts) do
      {
        :bacula_director_source  => 'puppet:///modules/bacula/bacula.source'
      }
    end
    it { should contain_file('bacula-dir.conf').with_path('/etc/bacula/bacula-dir.conf') }
    it { should contain_file('bacula-dir.conf').with_source('puppet:///modules/bacula/bacula.source') }
  end

  describe 'Test customizations - default_password' do
    let(:facts) do
      {
        :bacula_director_name => 'master_director',
        :bacula_default_password => 'master_pass',
        :bacula_director_template => 'bacula/bacula-dir.conf.erb'
      }
    end
    it { should contain_file('bacula-dir.conf').with_content(/Password = "master_pass".*Password = "master_pass"/m) }
  end

  describe 'Test customizations - provided template - most parameters' do
    let(:facts) do
      {
        :bacula_director_name => 'here_director',
        :bacula_default_password => 'default_pass',
        :bacula_director_password => 'director_pass',
        :bacula_director_port => '4242',
        :bacula_pid_directory => '/some/dir',
        :bacula_director_address => '10.42.42.42',
        :bacula_director_template => 'bacula/bacula-dir.conf.erb'
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

# Define the Director name, password used for authenticating the Console program.
Director {
  Name = "here_director"
  DirPort = 4242
  QueryFile = /etc/bacula/scripts/query.sql
  WorkingDirectory = /var/spool/bacula
  PidDirectory = /some/dir
  MaximumConcurrentJobs = 30
  Password = "director_pass"
  Messages = "standard"
  DirAddress = 10.42.42.42
  HeartbeatInterval = 1 minute
}

# Restricted Console, used by tray-monitor for Director status.
Console {
  Name = "rspec.example42.com-mon"
  Password = "default_pass"
  CommandACL = status, .status
}

# Include split config files. Remember to bconsole "reload" after modifying a config file.
@|"find /etc/bacula/director.d -name \'*.conf\' -type f -exec echo @{} \\;"

# Read client directory for config files. Remember to bconsole "reload" after adding a client.
@|"find /etc/bacula/clients.d -name \'*.conf\' -type f -exec echo @{} \\;"
'
    end
    it 'should create a valid config file' do
      should contain_file('bacula-dir.conf').with_content(expected)
    end
  end

  describe 'Test customizations - custom template' do
    let(:facts) do
      {
        :bacula_director_template => 'bacula/spec.erb',
        :options => { 'opt_a' => 'value_a' }
      }
    end
    it { should contain_file('bacula-dir.conf').without_source }
    it 'should generate a valid template' do
      should contain_file('bacula-dir.conf').with_content(/fqdn: rspec.example42.com/)
    end
    it 'should generate a template that uses custom options' do
      should contain_file('bacula-dir.conf').with_content(/value_a/)
    end
  end

  describe 'Test Centos decommissioning - absent' do
    let(:facts) { {:bacula_absent => true, :operatingsystem => 'Centos'} }
    it 'should remove Package[bacula-director-mysql] and related' do
      should contain_package('bacula-director-mysql').with_ensure('absent')
      should contain_file('bacula-dir.conf').with_ensure('absent')
    end
    it 'should stop Service[bacula-dir]' do
      should contain_service('bacula-dir').with_ensure('stopped')
    end
    it 'should not enable at boot Service[bacula-dir]' do
      should contain_service('bacula-dir').with_enable('false')
    end
  end

  describe 'Test decommissioning - disable' do
    let(:facts) { {:bacula_disable => true} }
    it { should contain_package('bacula-director-mysql').with_ensure('present') }
    it 'should stop Service[bacula-dir]' do
      should contain_service('bacula-dir').with_ensure('stopped')
    end
    it 'should not enable at boot Service[bacula-dir]' do
      should contain_service('bacula-dir').with_enable('false')
    end
  end

  describe 'Test decommissioning - disableboot' do
    let(:facts) do
      {
        :bacula_disableboot => true,
        :bacula_monitor_target => '10.42.42.42',
        :director_pid_file =>  'some.pid.file',
        :monitor => true
      }
    end
    it { should contain_package('bacula-director-mysql').with_ensure('present') }
    it { should_not contain_service('bacula-dir').with_ensure('present') }
    it { should_not contain_service('bacula-dir').with_ensure('absent') }
    it 'should not enable at boot Service[bacula-dir]' do
      should contain_service('bacula-dir').with_enable('false')
    end
    it { should contain_monitor__process('bacula_director_process').with_enable('false') }
  end

  describe 'Test noops mode' do
    let(:facts) do
      { 
        :bacula_noops => true,
        :bacula_monitor_target => '10.42.42.42',
        :director_pid_file =>  'some.pid.file',
        :monitor => true
      }
    end
    it { should contain_package('bacula-director-mysql').with_noop('true') }
    it { should contain_service('bacula-dir').with_noop('true') }
    it { should contain_monitor__process('bacula_director_process').with_noop('true') }
  end
end
