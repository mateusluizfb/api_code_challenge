class CreateDnsService
  def self.call(dns_attributes:, hostnames_attributes:)
    hostnames = create_hostnames(hostnames_attributes)
    create_dns(dns_attributes, hostnames)
  end

  def self.create_hostnames(hostnames_attributes)
    hostnames_attributes
      .map { |attributes| { name: attributes[:hostname] } }
      .map { |attributes| Hostname.find_or_create_by(attributes) }
  end

  def self.create_dns(dns_attributes, hostnames)
    DomainNameSystem.create(dns_attributes.merge(hostnames: hostnames))
  end
end
