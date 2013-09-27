require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'bacula::director::fileset' do

  let(:title) { 'bacula::fileset' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
      :director_configs_dir => '/etc/bacula/director.d',
    }
  end

  describe 'Test fileset.conf is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

FileSet {
  Name = "sample1"
  Include {
    Options {
      signature = 
      compression = 
      onefs = 
    }
  }
  Exclude {
  }
}
'
    end
    it { should contain_file('fileset-sample1.conf').with_path('/etc/bacula/director.d/fileset-sample1.conf').with_content(expected) }
  end

  describe 'Test fileset.conf is created with all main options' do
    let(:params) do
      {
        :name => 'sample2',
        :signature => 'MD5',
        :compression => 'GZIP',
        :onefs => 'no',
        :fstype => ['ext2','ext3','ext4'],
        :include => ['/home/sebastian','/etc'],
        :exclude => ['/proc','/sys','/tmp'],
      }
    end

    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

FileSet {
  Name = "sample2"
  Include {
    Options {
      signature = MD5
      compression = GZIP
      onefs = no
      fstype = ext2
      fstype = ext3
      fstype = ext4
    }
    File = /home/sebastian
    File = /etc
  }
  Exclude {
    File = /proc
    File = /sys
    File = /tmp
  }
}
'
    end
    it { should contain_file('fileset-sample2.conf').with_path('/etc/bacula/director.d/fileset-sample2.conf').with_content(expected) }
  end

end

