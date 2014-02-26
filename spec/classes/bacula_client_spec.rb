require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'bacula::client' do

  let(:title) { 'bacula::client' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42', :service_autorestart => true } }

  describe 'Test standard Centos installation' do
    let(:facts) { { :operatingsystem => 'Centos' } }
    it { should contain_package('bacula-client').with_ensure('present') }
    it { should contain_file('bacula-fd.conf').with_ensure('present') }
    it { should contain_service('bacula-fd').with_ensure('running') }
    it { should contain_service('bacula-fd').with_enable('true') }
  end

  describe 'Test standard Debian installation' do
    let(:facts) { { :operatingsystem => 'Debian' } }
    it { should contain_package('bacula-fd').with_ensure('present') }
    it { should contain_file('bacula-fd.conf').with_ensure('present') }
    it { should contain_file('bacula-fd.conf').with_path('/etc/bacula/bacula-fd.conf') }
    it { should contain_file('bacula-fd.conf').without_content }
    it { should contain_file('bacula-fd.conf').without_source }
    it { should contain_service('bacula-fd').with_ensure('running') }
    it { should contain_service('bacula-fd').with_enable('true') }
  end

  describe 'Test service autorestart' do
    it 'should automatically restart the service, by default' do
      should contain_file('bacula-fd.conf').with_notify('Service[bacula-fd]')
    end
  end

  describe 'Test customizations - provide source' do
    let(:facts) do
      {
        :bacula_client_source  => 'puppet:///modules/bacula/bacula.source'
      }
    end
    it { should contain_file('bacula-fd.conf').with_path('/etc/bacula/bacula-fd.conf') }
    it { should contain_file('bacula-fd.conf').with_source('puppet:///modules/bacula/bacula.source') }
  end

  describe 'Test customizations - master_password' do
    let(:facts) do
      {
        :bacula_client_name => 'master_client',
        :bacula_default_password => 'abcdefg',
        :bacula_client_template => 'bacula/bacula-fd.conf.erb'
      }
    end
    it { should contain_file('bacula-fd.conf').with_content(/Password = "abcdefg".*Password = "abcdefg"/m) }
  end

  describe 'Test customizations - provided template' do
    let(:facts) do
      {
        :bacula_director_name => 'here_director',
        :bacula_default_password => 'testing',
        :bacula_client_password => 'client_pass',
        :bacula_client_name => 'this_client',
        :bacula_client_port => '4242',
        :bacula_pid_directory => '/some/dir',
        :bacula_heartbeat_interval => '1 week',
        :bacula_client_address => '10.42.42.42',
        :bacula_client_template => 'bacula/bacula-fd.conf.erb'
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

# Directors who are permitted to contact this File daemon.
Director {
  Name = "here_director"
  Password = "client_pass"
}

# Restricted Director, used by tray-monitor for File daemon status.
Director {
  Name = "rspec.example42.com-mon"
  Password = "testing"
  Monitor = Yes
}

# "Global" File daemon configuration specifications.
FileDaemon {
  Name = "this_client"
  FDport = 4242
  WorkingDirectory = /var/spool/bacula
  PidDirectory = /some/dir
  FDAddress = 10.42.42.42
  Heartbeat Interval = 1 week
}

Messages {
  Name = "standard"
  Director = here_director = all, !skipped, !restored
}
'
    end
    it 'should create a valid config file' do
      should contain_file('bacula-fd.conf').with_content(expected)
    end
  end

  describe 'Test customizations - custom template' do
    let(:facts) do
      {
        :bacula_client_template => 'bacula/spec.erb',
        :options => { 'opt_a' => 'value_a' }
      }
    end
    it { should contain_file('bacula-fd.conf').without_source }
    it 'should generate a valid template' do
      should contain_file('bacula-fd.conf').with_content(/fqdn: rspec.example42.com/)
    end
    it 'should generate a template that uses custom options' do
      should contain_file('bacula-fd.conf').with_content(/value_a/)
    end
  end

  describe 'Test standard installation with monitoring and firewalling' do
    let(:facts) do
      {
        :monitor               => 'true',
        :bacula_monitor_target => '10.42.42.42',
        :firewall              => 'true',
        :bacula_protocol       => 'tcp',
        :bacula_client_service => 'bacula-fd',
        :bacula_client_port    => '9102',
        :concat_basedir        => '/var/lib/puppet/concat',
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
    let(:facts) { {:bacula_absent => true, :operatingsystem => 'Centos'} }
    it 'should remove Package[bacula-client]' do
      should contain_package('bacula-client').with_ensure('absent')
      should contain_file('bacula-fd.conf').with_ensure('absent')
    end
    it 'should stop Service[bacula-fd]' do
      should contain_service('bacula-fd').with_ensure('stopped')
    end
    it 'should not enable at boot Service[bacula-fd]' do
      should contain_service('bacula-fd').with_enable('false')
    end
  end

  describe 'Test Debian decommissioning - absent' do
    let(:facts) { {:bacula_absent => true, :operatingsystem => 'Debian'} }
    it 'should remove Package[bacula-fd]' do
      should contain_package('bacula-fd').with_ensure('absent')
    end
    it 'should stop Service[bacula-fd]' do
      should contain_service('bacula-fd').with_ensure('stopped')
    end
    it 'should not enable at boot Service[bacula-fd]' do
      should contain_service('bacula-fd').with_enable('false')
    end
  end

  describe 'Test decommissioning - disable' do
    let(:facts) { {:bacula_disable => true} }
    it { should contain_package('bacula-client').with_ensure('present') }
    it 'should stop Service[bacula-fd]' do
      should contain_service('bacula-fd').with_ensure('stopped')
    end
    it 'should not enable at boot Service[bacula-fd]' do
      should contain_service('bacula-fd').with_enable('false')
    end
  end

  describe 'Test decommissioning - disableboot' do
    let(:facts) { {:bacula_disableboot => true} }
    it { should contain_package('bacula-client').with_ensure('present') }
    it { should_not contain_service('bacula-fd').with_ensure('present') }
    it { should_not contain_service('bacula-fd').with_ensure('absent') }
    it 'should not enable at boot Service[bacula-fd]' do
      should contain_service('bacula-fd').with_enable('false')
    end
  end

  describe 'Test noops mode' do
    let(:facts) { {:bacula_noops => true} }
    it { should contain_package('bacula-client').with_noop('true') }
    it { should contain_file('bacula-fd.conf').with_noop('true') }
    it { should contain_service('bacula-fd').with_noop('true') }
  end
end
