class FindDnsRecordsService
  def self.call(included_hostnames:, excluded_hostnames:, page:)
    dns_records = find_dns_records(included_hostnames, excluded_hostnames, page).to_a

    {
      total_records: dns_records.size,
      records: format_dns_records(dns_records),
      related_hostnames: format_related_hostnames(included_hostnames, excluded_hostnames, dns_records)
    }
  end

  def self.find_dns_records(included_hostnames, excluded_hostnames, page)
    DomainNameSystem
      .then { |dns_records| QueryDnsRecordsByExcludedHostList.call(dns_records, hostnames_list(excluded_hostnames)) }
      .then { |dns_records| QueryDnsRecordsByIncludedHostList.call(dns_records, hostnames_list(included_hostnames)) }
      .page(page)
  end

  def self.hostnames_list(hosts)
    return [] if hosts.blank?

    hosts.include?(',') ? hosts.split(',') : [hosts]
  end

  def self.format_dns_records(dns_records)
    dns_records.map { |dns| { id: dns.id, ip_address: dns.ip } }
  end

  def self.format_related_hostnames(included_hostnames, excluded_hostnames, dns_records)
    dns_records
      .flat_map(&:hostnames)
      .map(&:name)
      .filter { |name| !included_hostnames&.include?(name) }
      .filter { |name| !excluded_hostnames&.include?(name) }
      .tally
      .map { |name, count| { hostname: name, count: count } }
  end
end
