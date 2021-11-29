class QueryDnsRecordsByIncludedHostList
  def self.call(dns_records, included_hosts_list)
    return dns_records if included_hosts_list.blank?

    dns_records
      .joins(:hostnames)
      .where(hostnames: { name: included_hosts_list })
      .group('domain_name_systems.id')
      .having('count(domain_name_systems.id) = ?', included_hosts_list.count)
  end
end
