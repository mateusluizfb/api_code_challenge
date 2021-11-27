class QueryDnsRecordsByExcludedHostList
  def self.call(dns_records, excluded_hosts)
    return dns_records if excluded_hosts.blank?

    records_to_remove = QueryDnsRecordsByIncludedHostList.call(dns_records, excluded_hosts)

    dns_records
      .where
      .not(id: records_to_remove.pluck(:id))
  end
end
