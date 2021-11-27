require 'rails_helper'

RSpec.describe CreateDnsService do
  describe '.call' do
    let(:dns_attributes) { { 'ip': '1.1.1.1' } }
    let(:hostnames_attributes) { [{ 'hostname': 'lorem.com' }]  }

    subject do
      CreateDnsService.call(
        dns_attributes: dns_attributes,
        hostnames_attributes: hostnames_attributes
      )
    end

    it 'creates a Dns record' do
      expect { subject }.to change { DomainNameSystem.count }
        .from(0).to(1)
    end

    it 'creates a Hostname record' do
      expect { subject }.to change { Hostname.count }
        .from(0).to(1)
    end

    it 'creates dns with many hostnames' do
      subject

      expect(DomainNameSystem.last.hostnames.count).to eq(1)
    end

    it 'creates dns for with blank hostnames' do
      CreateDnsService.call(dns_attributes: dns_attributes, hostnames_attributes: nil)
      expect(DomainNameSystem.last.hostnames.count).to eq(0)
    end
  end

end
