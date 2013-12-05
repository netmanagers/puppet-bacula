require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'bacula::director::catalog' do

  let(:title) { 'bacula::director::catalog' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
      :service_autorestart => true,
      :bacula_director_service => 'Service[bacula-dir]',
      :bacula_default_password => 'bacula',
    }
  end

  describe 'Test catalog.conf is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Catalog {
  Name = "sample1"
  DBDriver = dbi:mysql
  DBAddress = localhost
  DBName = "bacula"; dbuser = "bacula"; dbpassword = "bacula";
}
'
    end
    it { should contain_file('catalog-sample1.conf').with_path('/etc/bacula/director.d/catalog-sample1.conf').with_content(expected) }
  end

  describe 'Test catalog.conf is created with all main options' do
    let(:params) do
      {
        :name => 'sample2',
        :db_driver => 'dbi:postgres',
        :db_address => '10.0.0.3',
        :db_port => '3824',
        :db_name => 'test',
        :db_user => 'netmanagers',
        :db_password => 'password',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Catalog {
  Name = "sample2"
  DBDriver = dbi:postgres
  DBAddress = 10.0.0.3
  DBPort = 3824
  DBName = "test"; dbuser = "netmanagers"; dbpassword = "password";
}
'
    end
    it { should contain_file('catalog-sample2.conf').with_path('/etc/bacula/director.d/catalog-sample2.conf').with_content(expected) }

    it 'should automatically restart the director service' do
      should contain_file('catalog-sample2.conf').with_notify('Service[bacula-dir]')
    end
  end

end

