require 'spec_helper'
require 'puppet/type/mcx'

describe Puppet::Type.type(:mcx) do
  before :each do
    provider_class = described_class.provider(described_class.providers[0])
    described_class.stubs(:defaultprovider).returns provider_class
  end

  properties = [:ensure, :content]
  parameters = [:name, :ds_type, :ds_name]

  parameters.each do |p|
    it "should have a #{p} parameter" do
      expect(described_class.attrclass(p).ancestors).to be_include(Puppet::Parameter)
    end
  end

  properties.each do |p|
    it "should have a #{p} property" do
      expect(described_class.attrclass(p).ancestors).to be_include(Puppet::Property)
    end
  end

  context 'default values' do
    it 'is nil for :ds_type' do
      expect(described_class.new(name: '/Foo/bar')[:ds_type]).to be_nil
    end

    it 'is nil for :ds_name' do
      expect(described_class.new(name: '/Foo/bar')[:ds_name]).to be_nil
    end

    it 'is nil for :content' do
      expect(described_class.new(name: '/Foo/bar')[:content]).to be_nil
    end
  end

  context 'validation' do
    it 'is able to create an instance' do
      expect {
        described_class.new(name: '/Foo/bar')
      }.not_to raise_error
    end

    it 'supports :present as a value to :ensure' do
      expect {
        described_class.new(name: '/Foo/bar', ensure: :present)
      }.not_to raise_error
    end

    it 'supports :absent as a value to :ensure' do
      expect {
        described_class.new(name: '/Foo/bar', ensure: :absent)
      }.not_to raise_error
    end
  end
end
