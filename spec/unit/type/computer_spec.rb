require 'spec_helper'
require 'puppet/type/computer'

describe Puppet::Type.type(:computer) do
  let(:resource) do
    Puppet::Type::Computer.new(
      name: 'puppetcomputertest',
      en_address: 'aa:bb:cc:dd:ee:ff',
      ip_address: '1.2.3.4',
    )
  end

  before :each do
    provider_class = described_class.provider(described_class.providers[0])
    described_class.stubs(:defaultprovider).returns provider_class
  end

  it 'is able to create an instance' do
    expect(described_class.new(name: 'bar')).to be_a_kind_of(Puppet::Type::Computer)
  end

  properties = [:en_address, :ip_address]
  params = [:name]

  properties.each do |property|
    it "should have a #{property} property" do
      expect(described_class.attrclass(property).ancestors).to be_include(Puppet::Property)
    end

    it 'accepts :absent as a value' do
      prop = described_class.attrclass(property).new(resource: resource)
      prop.should = :absent
      expect(prop.should).to eq(:absent)
    end
  end

  params.each do |param|
    it "should have a #{param} parameter" do
      expect(described_class.attrclass(param).ancestors).to be_include(Puppet::Parameter)
    end
  end

  describe 'when managing the ensure property' do
    it 'supports a :present value' do
      resource[:ensure] = :present
      expect(resource[:ensure]).to eq(:present)
    end

    it 'supports an :absent value' do
      resource[:ensure] = :absent
      expect(resource[:ensure]).to eq(:absent)
    end
  end
end
