class Company < ApplicationRecord
  searchkick

  has_many :company_synonyms, dependent: :destroy

  accepts_nested_attributes_for :company_synonyms

  def search_data
    {
      name: name,
      description: description,
      synonyms: company_synonyms.pluck(:name)
    }
  end
end
