require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'bacula::storage::device' do

  let(:title) { 'bacula::device' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
      :storage_configs_dir => '/etc/bacula/storage.d',
    }
  end

  describe 'Test device.conf is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Device {
  Name = "sample1"
  MediaType = 
  ArchiveDevice = 
  LabelMedia = yes
  RandomAccess = yes
  AutomaticMount = yes
  RemovableMedia = no
  AlwaysOpen = false
}
'
    end
    it { should contain_file('device-sample1.conf').with_path('/etc/bacula/storage.d/device-sample1.conf').with_content(expected) }
#    it { should contain_file('device-sample1.conf').with_path('/device-sample1.conf').with_content(expected) }
  end

  describe 'Test device.conf is created with all main options' do
    let(:params) do
      {
        :name => 'sample2',
        :media_type => 'File01',
        :archive_device => '/backups/bacula_storage',
        :label_media => 'yes',
        :random_access => 'yes',
        :automatic_mount => 'yes',
        :removable_media => 'no' ,
        :always_open => false,
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Device {
  Name = "sample2"
  MediaType = File01
  ArchiveDevice = /backups/bacula_storage
  LabelMedia = yes
  RandomAccess = yes
  AutomaticMount = yes
  RemovableMedia = no
  AlwaysOpen = false
}
'
    end
    it { should contain_file('device-sample2.conf').with_path('/etc/bacula/storage.d/device-sample2.conf').with_content(expected) }
  end

end
