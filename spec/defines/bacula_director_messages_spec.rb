require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'bacula::director::messages' do

  let(:title) { 'bacula::director::messages' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
      :bacula_log_file => '/var/log/bacula/bacula.log'
    }
  end

  describe 'Test messages.conf is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Messages {
  Name = "sample1"
  console = all, !skipped, !saved
  catalog = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
}
'
    end
    it 'should generate a default messages section' do
      should contain_file('messages-sample1.conf').with_path('/etc/bacula/director.d/messages-sample1.conf').with_content(expected)
    end
  end

  describe 'Test messages.conf is created with all main options' do
    let(:params) do
      {
        :name => 'sample2',
        :mail_command => '/usr/bin/bsmtp',
        :mail_host => 'localhost',
        :mail_from => 'noreply@netmanagers.com.ar',
        :mail_to => 'system-notifications@netmanagers.com.ar',
      }
    end

    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Messages {
  Name = "sample2"
  mailcommand = "/usr/bin/bsmtp -h localhost -f \"Bacula <noreply@netmanagers.com.ar>\" -s \"Bacula: %t %e of %c %l\" %r"
  operatorcommand = "/usr/bin/bsmtp -h localhost -f \"Bacula <noreply@netmanagers.com.ar>\" -s \"Bacula: Intervention needed for %j\" %r"
  mail = system-notifications@netmanagers.com.ar = all, !skipped
  operator = system-notifications@netmanagers.com.ar = mount
  mailonerror = system-notifications@netmanagers.com.ar = all
  console = all, !skipped, !saved
  catalog = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
}
'
    end
    it 'should generate a messages section with multiple options set' do
      should contain_file('messages-sample2.conf').with_path('/etc/bacula/director.d/messages-sample2.conf').with_content(expected)
    end
  end

end

