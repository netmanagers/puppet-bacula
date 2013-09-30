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

  describe 'Test job.conf is created with no options. It becomes a jobdef if no client is given' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

JobDefs {
  Name = "sample1"
  Type = Backup
}
'
    end
    it 'should generate a JobDef file' do 
      should contain_file('jobdef-sample1').with_path('/etc/bacula/director.d/jobdef-sample1.conf').with_content(expected)
    end
  end

  describe 'Test job.conf is created with all main options' do
    let(:params) do
      {
        :name     => 'sample2',
        :client   => 'bacula',
        :type     => 'restore',
        :fileset  => 'standardLinuxFileSet',
        :storage  => 'restoreStorage',
        :pool     => 'FullPool',
        :priority => '1',
        :messages => 'standard',
        :where    => '/tmp',
      }
    end

    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Job {
  Name = "sample2"
  Client = "bacula"
  Type = restore
  FileSet = "standardLinuxFileSet"
  Storage = "restoreStorage"
  Pool = "FullPool"
  Priority = 1
  Messages = "standard"
  Where = /tmp
}
'
    end
    it 'should generate a Job file with custom options' do
      should contain_file('job-bacula-sample2').with_path('/etc/bacula/director.d/job-bacula-sample2.conf').with_content(expected)
    end
  end

end

