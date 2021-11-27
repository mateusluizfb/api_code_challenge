class Hostname < ApplicationRecord
  has_and_belongs_to_many :domain_name_systems

  validates :name, presence: true
end
