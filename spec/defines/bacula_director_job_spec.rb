require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'bacula::director::job' do

  let(:title) { 'bacula::job' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
      :director_configs_dir => '/etc/bacula/director.d',
    }
  end

  describe 'Test job.conf is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Job {
  Name = sample1

}
'
    end
    it { should contain_file('job-sample1.conf').with_path('/etc/bacula/director.d/job-sample1.conf').with_content(expected) }
  end

  describe 'Test job.conf is created with all main options' do
    let(:params) do
      {
        :name => 'sample2',
        :client => 'bacula',
        :type => 'restore',
        :fileset => 'standardLinuxFileSet',
        :jobdefs_storage => 'restoreStorage',
        :pool => 'FullPool',
        :priority => '1',
        :messages => 'standard',
        :where => '/tmp',
      }
    end

    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Job {
  Name = sample2
  Client = bacula
  Type = restore
  FileSet = standardLinuxFileSet
  Storage = restoreStorage
  Pool = FullPool
  Priority = 1
  Messages = standard
  Where = /tmp
}
'
    end
    it { should contain_file('job-sample2.conf').with_path('/etc/bacula/director.d/job-sample2.conf').with_content(expected) }
  end

end

