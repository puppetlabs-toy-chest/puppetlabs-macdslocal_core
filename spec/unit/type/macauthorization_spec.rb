require 'spec_helper'
require 'puppet/type/macauthorization'

module Puppet::Util::Plist
end

describe Puppet::Type.type(:macauthorization) do
  let(:resource) { described_class.new(name: 'foo') }

  before(:each) do
    authplist = {}
    authplist['rules'] = { 'foorule' => 'foo' }
    authplist['rights'] = { 'fooright' => 'foo' }
    provider_class = described_class.provider(described_class.providers[0])
    Puppet::Util::Plist.stubs(:parse_plist).with('/etc/authorization').returns(authplist)
    described_class.stubs(:defaultprovider).returns provider_class
  end

  describe 'when validating attributes' do
    parameters = [:name]
    properties = [:auth_type, :allow_root, :authenticate_user, :auth_class,
                  :comment, :group, :k_of_n, :mechanisms, :rule,
                  :session_owner, :shared, :timeout, :tries]

    parameters.each do |parameter|
      it "should have a #{parameter} parameter" do
        expect(described_class.attrclass(parameter).ancestors).to be_include(Puppet::Parameter)
      end
    end

    properties.each do |property|
      it "should have a #{property} property" do
        expect(described_class.attrclass(property).ancestors).to be_include(Puppet::Property)
      end
    end
  end

  describe 'when validating properties' do
    it 'has a default provider inheriting from Puppet::Provider' do
      expect(described_class.defaultprovider.ancestors).to be_include(Puppet::Provider)
    end

    it 'is able to create an instance' do
      expect {
        described_class.new(name: 'foo')
      }.not_to raise_error
    end

    it 'supports :present as a value to :ensure' do
      expect {
        described_class.new(name: 'foo', ensure: :present)
      }.not_to raise_error
    end

    it 'supports :absent as a value to :ensure' do
      expect {
        described_class.new(name: 'foo', ensure: :absent)
      }.not_to raise_error
    end
  end

  [:k_of_n, :timeout, :tries].each do |property|
    describe "when managing the #{property} property" do
      it 'converts number-looking strings into actual numbers' do
        prop = described_class.attrclass(property).new(resource: resource)
        prop.should = '300'
        expect(prop.should).to eq(300)
      end
      it 'supports integers as a value' do
        prop = described_class.attrclass(property).new(resource: resource)
        prop.should = 300
        expect(prop.should).to eq(300)
      end
      it 'raises an error for non-integer values' do
        prop = described_class.attrclass(property).new(resource: resource)
        expect { prop.should = 'foo' }.to raise_error(Puppet::Error)
      end
    end
  end

  [:allow_root, :authenticate_user, :session_owner, :shared].each do |property|
    describe "when managing the #{property} property" do
      it 'converts boolean-looking false strings into actual booleans' do
        prop = described_class.attrclass(property).new(resource: resource)
        prop.should = 'false'
        expect(prop.should).to eq(:false)
      end
      it 'converts boolean-looking true strings into actual booleans' do
        prop = described_class.attrclass(property).new(resource: resource)
        prop.should = 'true'
        expect(prop.should).to eq(:true)
      end
      it 'raises an error for non-boolean values' do
        prop = described_class.attrclass(property).new(resource: resource)
        expect { prop.should = 'foo' }.to raise_error(Puppet::Error)
      end
    end
  end
end
