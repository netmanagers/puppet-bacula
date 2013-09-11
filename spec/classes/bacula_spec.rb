require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'bacula' do

  let(:title) { 'bacula' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test include bacula::client' do
    let(:params) { {:install_client => true } }
    it { should include_class('bacula::client') }
  end

  describe 'Test include bacula::storage' do
    let(:params) { {:install_storage => true } }
    it { should include_class('bacula::storage') }
  end

  describe 'Test include bacula::director' do
    let(:params) { {:install_director => true } }
    it { should include_class('bacula::director') }
  end

  describe 'Test include bacula::console' do
    let(:params) { {:install_console => true } }
    it { should include_class('bacula::console') }
  end

  describe 'Test not include bacula::client' do
    let(:params) { {:install_client => 'false' } }
    it { should_not include_class('bacula::client') }
  end

  describe 'Test not include bacula::storage' do
    let(:params) { {:install_storage => 'false' } }
    it { should_not include_class('bacula::storage') }
  end

  describe 'Test not include bacula::director' do
    let(:params) { {:install_director => 'false' } }
    it { should_not include_class('bacula::director') }
  end

  describe 'Test not include bacula::console' do
    let(:params) { {:install_console => 'false' } }
    it { should_not include_class('bacula::console') }
  end
end

