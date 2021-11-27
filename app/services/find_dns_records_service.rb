class FindDnsRecordsService
  def self.call(included_hostnames:, page:)
    dns_records = find_dns_records(included_hostnames, page).to_a

    {
      total_records: dns_records.size,
      records: format_dns_records(dns_records),
      related_hostnames: format_related_hostnames(included_hostnames, dns_records)
    }
  end

  def self.find_dns_records(included_hostnames, page)

    DomainNameSystem
      .then { |dns_records| include_hostnames(dns_records, included_hostnames) }
      .page(page)
  end

  def self.include_hostnames(dns_records, included_hostnames)
    return dns_records if included_hostnames.blank?

    hostnames_list = included_hostnames.split(',')

    dns_records
      .joins(:hostnames)
      .where(hostnames: { name: hostnames_list })
      .group('domain_name_systems.id')
      .having('count(domain_name_systems.id) = ?', hostnames_list.count)
  end

  def self.format_dns_records(dns_records)
    dns_records.map { |dns| { id: dns.id, ip_address: dns.ip } }
  end

  def self.format_related_hostnames(included_hostnames, dns_records)
    dns_records
      .flat_map(&:hostnames)
      .map(&:name)
      .filter { |name| !included_hostnames&.include?(name) }
      .tally
      .map { |name, count| { hostname: name, count: count } }
  end
end
