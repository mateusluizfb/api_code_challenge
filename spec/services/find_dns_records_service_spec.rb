require 'rails_helper'

RSpec.describe FindDnsRecordsService do
  describe '.call' do
    it 'calls included query' do
      expect(QueryDnsRecordsByIncludedHostList).to receive(:call)
        .and_return(DomainNameSystem)

      described_class.call(
        included_hostnames: '',
        excluded_hostnames: '',
        page: 1
      )
    end

    it 'calls excluded query' do
      expect(QueryDnsRecordsByExcludedHostList).to receive(:call)
        .and_return(DomainNameSystem)

      described_class.call(
        included_hostnames: '',
        excluded_hostnames: '',
        page: 1
      )
    end

    it 'returns correct hash' do
      hostname = Hostname.new(name: 'google.com')
      DomainNameSystem.create(ip: '1.1.1.1', hostnames: [hostname])

      result = described_class.call(
        included_hostnames: '',
        excluded_hostnames: '',
        page: 1
      )

      expect(result).to eq(
        {
          total_records: 1,
          records: [{:id=>1, :ip_address=>"1.1.1.1"}],
          related_hostnames: [{:count=>1, :hostname=>"google.com"}]
        }
      )
    end
  end
end
