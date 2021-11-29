require 'rails_helper'

RSpec.describe QueryDnsRecordsByExcludedHostList do
  describe '.call' do
    it 'excludes dns records based on their hostnames' do
      hostname = Hostname.new(name: 'google.com')
      DomainNameSystem.create(ip: '1.1.1.1', hostnames: [hostname])

      result = described_class.call(DomainNameSystem, ['google.com'])
      expect(result).to be_blank
    end

    it 'doesnt exclude dns records without a valid hostname' do
      hostname = Hostname.new(name: 'google.com')
      DomainNameSystem.create(ip: '1.1.1.1', hostnames: [hostname])

      result = described_class.call(DomainNameSystem, ['yahoo.com'])
      expect(result).to_not be_blank
    end
  end
end
