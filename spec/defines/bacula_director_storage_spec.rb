require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'bacula::director::storage' do

  let(:title) { 'bacula::director::storage' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
      :service_autorestart => true,
      :bacula_director_service => 'Service[bacula-dir]',
      :bacula_default_password => 'master_pass',
      :director_configs_dir => '/etc/bacula/director.d',
    }
  end

  describe 'Test storage.conf is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Storage {
  Name = "sample1"
  SDPort = 9103
  Password = "master_pass"
  AllowCompression = Yes
}
'
    end
    it { should contain_file('storage-sample1.conf').with_path('/etc/bacula/director.d/storage-sample1.conf').with_content(expected) }
  end

  describe 'Test storage.conf is created with all main options' do
    let(:params) do
      {
        :name => 'sample2',
        :device => 'FileDevice01',
        :media_type => 'File01',
        :address => 'bacula',
        :sd_port => '7321',
        :password => 'bacula',
        :max_concurrent => '10',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Storage {
  Name = "sample2"
  Device = FileDevice01
  Media Type = File01
  Address = bacula
  SDPort = 7321
  Password = "bacula"
  Maximum Concurrent Jobs = 10
  AllowCompression = Yes
}
'
    end
    it { should contain_file('storage-sample2.conf').with_path('/etc/bacula/director.d/storage-sample2.conf').with_content(expected) }

    it 'should automatically restart the service, by default' do
      should contain_file('storage-sample2.conf').with_notify('Service[bacula-dir]')
    end
  end

end

