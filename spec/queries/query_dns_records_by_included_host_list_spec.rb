require 'rails_helper'

RSpec.describe QueryDnsRecordsByIncludedHostList do
  describe '.call' do
    it 'includes dns records based on their hostnames' do
      hostname = Hostname.new(name: 'google.com')
      DomainNameSystem.create(ip: '1.1.1.1', hostnames: [hostname])

      result = described_class.call(DomainNameSystem, ['google.com'])
      expect(result).to be_present
    end

    it 'doesnt include dns records not listed' do
      hostname = Hostname.new(name: 'google.com')
      DomainNameSystem.create(ip: '1.1.1.1', hostnames: [hostname])

      result = described_class.call(DomainNameSystem, ['yahoo.com'])
      expect(result).to be_blank
    end
  end
end
