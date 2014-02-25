require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'bacula::director::pool' do

  let(:title) { 'bacula::director::pool' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
      :service_autorestart => true,
      :bacula_director_service => 'Service[bacula-dir]',
      :pool_configs_dir => '/etc/bacula/director.d',
    }
  end

  describe 'Test pool.conf is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Pool {
  Name = "sample1"
  PoolType = Backup
  MaximumVolumeJobs = 1
  MaximumVolumeBytes = 1G
  UseVolumeOnce = true
  Recycle = true
  ActionOnPurge = truncate
  AutoPrune = true
  VolumeRetention = 1 month
  LabelFormat = "Volume-"
}
'
    end
    it 'should generate a valid pool configuration' do
      should contain_file('pool-sample1.conf').with_path('/etc/bacula/director.d/pool-sample1.conf').with_content(expected)
    end
  end

  describe 'Test pool.conf is created with all main options' do
    let(:params) do
      {
        :name => 'sample2',
        :type => 'BackupFull',
        :maximum_volume_jobs => '3',
        :maximum_volume_bytes => '10G',
        :use_volume_once  => false,
        :recycle => false,
        :action_on_purge => 'delete',
        :auto_prune => false,
        :volume_retention => '2 month',
        :volume_use_duration => '2 minutes',
        :label_format => 'Volume-Number-',
        :storage => 'SomeStorage',
      }
    end

    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Pool {
  Name = "sample2"
  PoolType = BackupFull
  MaximumVolumeJobs = 3
  MaximumVolumeBytes = 10G
  UseVolumeOnce = false
  Recycle = false
  ActionOnPurge = delete
  AutoPrune = false
  Volume Use Duration = 2 minutes
  VolumeRetention = 2 month
  LabelFormat = "Volume-Number-"
  Storage = "SomeStorage"
}
'
    end
    it 'should generate a pool config with most of its parameters set' do
      should contain_file('pool-sample2.conf').with_path('/etc/bacula/director.d/pool-sample2.conf').with_content(expected)
    end

    it 'should automatically restart the service, by default' do
      should contain_file('pool-sample2.conf').with_notify('Service[bacula-dir]')
    end
  end

end

