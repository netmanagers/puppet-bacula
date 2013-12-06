require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'bacula' do

  let(:title) { 'bacula' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/monit/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('bacula.dir').with_purge('true') }
    it { should contain_file('bacula.dir').with_force('true') }
  end

  describe 'Test include bacula::client' do
    let(:params) { {:manage_client => true } }
    it { should contain_class('bacula::client') }
  end

  describe 'Test include bacula::storage' do
    let(:params) { {:manage_storage => true } }
    it { should contain_class('bacula::storage') }
  end

  describe 'Test include bacula::director' do
    let(:params) { {:manage_director => true } }
    it { should contain_class('bacula::director') }
  end

  describe 'Test include bacula::console' do
    let(:params) { {:manage_console => true } }
    it { should contain_class('bacula::console') }
  end

  describe 'Test not include bacula::client' do
    let(:params) { {:manage_client => 'false' } }
    it { should_not contain_class('bacula::client') }
  end

  describe 'Test not include bacula::storage' do
    let(:params) { {:manage_storage => 'false' } }
    it { should_not contain_class('bacula::storage') }
  end

  describe 'Test not include bacula::director' do
    let(:params) { {:manage_director => 'false' } }
    it { should_not contain_class('bacula::director') }
  end

  describe 'Test not include bacula::console' do
    let(:params) { {:manage_console => 'false' } }
    it { should_not contain_class('bacula::console') }
  end
end

