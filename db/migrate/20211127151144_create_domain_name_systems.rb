class CreateDomainNameSystems < ActiveRecord::Migration[6.1]
  def change
    create_table :domain_name_systems do |t|
      t.string :ip

      t.timestamps
    end
  end
end
