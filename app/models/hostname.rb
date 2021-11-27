class Hostname < ApplicationRecord
  has_and_belongs_to_many :domain_name_systems
end
