class QueryDnsRecordsByIncludedHostList
  def self.call(dns_records, included_hosts)
    return dns_records if included_hosts.blank?

    hostnames_list = hostnames_list(included_hosts)

    dns_records
      .joins(:hostnames)
      .where(hostnames: { name: hostnames_list })
      .group('domain_name_systems.id')
      .having('count(domain_name_systems.id) = ?', hostnames_list.count)
  end

  def self.hostnames_list(included_hosts)
    included_hosts.include?(',') ? included_hosts.split(',') : [included_hosts]
  end
end
