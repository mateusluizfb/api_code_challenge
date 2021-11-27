class CreateJoinTableDomainNameSystemHostname < ActiveRecord::Migration[6.1]
  def change
    create_join_table :domain_name_systems, :hostnames do |t|
      # t.index [:domain_name_system_id, :hostname_id]
      # t.index [:hostname_id, :domain_name_system_id]
    end
  end
end
