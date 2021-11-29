class QueryDnsRecordsByExcludedHostList
  def self.call(dns_records, excluded_hosts)
    return dns_records if excluded_hosts.blank?

    records_to_remove = records_to_remove(dns_records, excluded_hosts)

    dns_records
      .where
      .not(id: records_to_remove.pluck(:id))
  end

  def self.records_to_remove(dns_records, excluded_hosts)
    dns_records
      .joins(:hostnames)
      .where(hostnames: { name: hostnames_list(excluded_hosts) })
  end

  def self.hostnames_list(excluded_hosts)
    excluded_hosts.include?(',') ? excluded_hosts.split(',') : [excluded_hosts]
  end
end
