require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'bacula::console' do

  let(:title) { 'bacula::console' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard Centos installation' do
    let(:facts) { { :operatingsystem => 'Centos' } }
    it { should contain_package('bacula-console').with_ensure('present') }
    it { should contain_file('bconsole.conf').with_ensure('present') }
  end

  describe 'Test customizations - provide source' do
    let(:facts) do
      {
        :bacula_console_source  => 'puppet:///modules/bacula/bconsole.source'
      }
    end
    it { should contain_file('bconsole.conf').with_path('/etc/bacula/bconsole.conf') }
    it { should contain_file('bconsole.conf').with_source('puppet:///modules/bacula/bconsole.source') }
  end

  describe 'Test customizations - master_password' do
    let(:facts) do
      {
        :bacula_console_name => 'master_console',
        :bacula_default_password => 'abcdefg',
        :bacula_console_template => 'bacula/bconsole.conf.erb'
      }
    end
    it { should contain_file('bconsole.conf').with_content(/Password = "abcdefg"/) }
  end

  describe 'Test customizations - provided template' do
    let(:facts) do
      {
        :bacula_director_name => 'here_director',
        :bacula_director_address => '10.42.42.42',
        :bacula_default_password => 'testing',
        :bacula_console_password => 'console_pass',
        :bacula_console_template => 'bacula/bconsole.conf.erb'
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

# Bacula User Agent "Console" (bconsole).
Director {
  Name = "here_director"
  DIRPort = 9101
  Address = 10.42.42.42
  Password = "console_pass"
}
'
    end
    it 'should create a valid config file' do
      should contain_file('bconsole.conf').with_content(expected)
    end
  end

  describe 'Test customizations - custom template' do
    let(:facts) do
      {
        :bacula_console_template => 'bacula/spec.erb',
        :options => { 'opt_a' => 'value_a' }
      }
    end
    it { should contain_file('bconsole.conf').without_source }
    it 'should generate a valid template' do
      should contain_file('bconsole.conf').with_content(/fqdn: rspec.example42.com/)
    end
    it 'should generate a template that uses custom options' do
      should contain_file('bconsole.conf').with_content(/value_a/)
    end
  end

  describe 'Test Centos decommissioning - absent' do
    let(:facts) { {:bacula_absent => true, :operatingsystem => 'Centos'} }
    it 'should remove Package[bacula-console]' do
      should contain_package('bacula-console').with_ensure('absent')
      should contain_file('bconsole.conf').with_ensure('absent')
    end
  end

  describe 'Test noops mode' do
    let(:facts) { {:bacula_noops => true} }
    it { should contain_package('bacula-console').with_noop('true') }
    it { should contain_file('bconsole.conf').with_noop('true') }
  end
end
