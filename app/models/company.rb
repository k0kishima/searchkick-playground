class Company < ApplicationRecord
  has_many :company_synonyms, dependent: :destroy

  accepts_nested_attributes_for :company_synonyms
end
