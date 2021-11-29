class QueryDnsRecordsByExcludedHostList
  def self.call(dns_records, excluded_hosts_list)
    return dns_records if excluded_hosts_list.blank?

    records_to_remove = records_to_remove(dns_records, excluded_hosts_list)

    dns_records
      .where
      .not(id: records_to_remove.pluck(:id))
  end

  def self.records_to_remove(dns_records, excluded_hosts_list)
    dns_records
      .joins(:hostnames)
      .where(hostnames: { name: excluded_hosts_list })
  end
end
