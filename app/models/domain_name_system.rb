class DomainNameSystem < ApplicationRecord
  has_and_belongs_to_many :hostnames

  validates :ip, presence: true
end
