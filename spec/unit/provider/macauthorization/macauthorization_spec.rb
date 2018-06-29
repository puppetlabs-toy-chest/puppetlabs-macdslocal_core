require 'spec_helper'
require 'puppet/type/macauthorization'

module Puppet::Util::Plist
end

describe Puppet::Type.type(:macauthorization).provider(:macauthorization) do
  let(:resource) { stub 'resource' }
  let(:provider) { described_class.new(resource) }
  let(:authname) { 'foo.spam.eggs.puppettest' }

  before :each do
    authdb = {}
    authdb['rules'] = { 'foorule' => 'foo' }
    authdb['rights'] = { 'fooright' => 'foo' }

    # Stub out Plist::parse_xml
    Puppet::Util::Plist.stubs(:parse_plist).returns(authdb)
    Puppet::Util::Plist.stubs(:write_plist_file)

    # A catch all; no parameters set
    resource.stubs(:[]).returns(nil)

    # But set name, ensure
    resource.stubs(:[]).with(:name).returns authname
    resource.stubs(:[]).with(:ensure).returns :present
    resource.stubs(:ref).returns "MacAuthorization[#{authname}]"
  end

  it 'has a create method' do
    expect(provider).to respond_to(:create)
  end

  it 'has a destroy method' do
    expect(provider).to respond_to(:destroy)
  end

  it 'has an exists? method' do
    expect(provider).to respond_to(:exists?)
  end

  it 'has a flush method' do
    expect(provider).to respond_to(:flush)
  end

  properties = [:allow_root, :authenticate_user, :auth_class, :comment,
                :group, :k_of_n, :mechanisms, :rule, :session_owner,
                :shared, :timeout, :tries, :auth_type]

  properties.each do |prop|
    it "should have a #{prop} method" do
      expect(provider).to respond_to(prop.to_s)
    end

    it "should have a #{prop}= method" do
      expect(provider).to respond_to(prop.to_s + '=')
    end
  end

  describe 'when destroying a right' do
    before :each do
      resource.stubs(:[]).with(:auth_type).returns(:right)
    end

    it 'calls the internal method destroy_right' do
      provider.expects(:destroy_right)
      provider.destroy
    end
    it "calls the external command 'security authorizationdb remove authname" do
      provider.expects(:security).with('authorizationdb', :remove, authname)
      provider.destroy
    end
  end

  describe 'when destroying a rule' do
    before :each do
      resource.stubs(:[]).with(:auth_type).returns(:rule)
    end

    it 'calls the internal method destroy_rule' do
      provider.expects(:destroy_rule)
      provider.destroy
    end
  end

  describe 'when flushing a right' do
    before :each do
      resource.stubs(:[]).with(:auth_type).returns(:right)
    end

    it 'calls the internal method flush_right' do
      provider.expects(:flush_right)
      provider.flush
    end

    it 'calls the internal method set_right' do
      provider.expects(:execute).with { |cmds, args|
        cmds.include?('read') &&
          cmds.include?(authname) &&
          args[:combine] == false
      }.once
      provider.expects(:set_right)
      provider.flush
    end

    it 'reads and write to the auth database with the right arguments' do
      provider.expects(:execute).with { |cmds, args|
        cmds.include?('read') &&
          cmds.include?(authname) &&
          args[:combine] == false
      }.once

      provider.expects(:execute).with { |cmds, args|
        cmds.include?('write') &&
          cmds.include?(authname) &&
          args[:combine] == false &&
          !args[:stdinfile].nil?
      }.once
      provider.flush
    end
  end

  describe 'when flushing a rule' do
    before :each do
      resource.stubs(:[]).with(:auth_type).returns(:rule)
    end

    it 'calls the internal method flush_rule' do
      provider.expects(:flush_rule)
      provider.flush
    end

    it 'calls the internal method set_rule' do
      provider.expects(:set_rule)
      provider.flush
    end
  end
end
