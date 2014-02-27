require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'bacula::director::fileset' do

  let(:title) { 'bacula::director::fileset' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
      :service_autorestart => true,
      :bacula_director_service => 'Service[bacula-dir]',
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
      signature = MD5
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

    it 'should automatically restart the service, by default' do
      should contain_file('fileset-sample2.conf').with_notify('Service[bacula-dir]')
    end
  end

  describe 'Test fileset.conf is created with all main options and some additional options' do
    let(:params) do
      {
        :name => 'sample3',
        :signature => 'MD5',
        :compression => 'GZIP',
        :onefs => 'no',
        :fstype => ['ext2','ext3','ext4'],
        :include => ['/home/sebastian','/etc'],
        :exclude => ['/proc','/sys','/tmp'],
        :options_hash => {'mtimeonly'=>true,'ignore_case'=>false,'recurse'=>'yes'},
      }
    end

    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

FileSet {
  Name = "sample3"
  Include {
    Options {
      signature = MD5
      compression = GZIP
      onefs = no
      ignore case = no
      mtimeonly = yes
      recurse = yes
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
    it { should contain_file('fileset-sample3.conf').with_path('/etc/bacula/director.d/fileset-sample3.conf').with_content(expected) }

    it 'should automatically restart the service, by default' do
      should contain_file('fileset-sample3.conf').with_notify('Service[bacula-dir]')
    end
  end

end

