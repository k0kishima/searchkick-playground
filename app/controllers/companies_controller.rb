class CompaniesController < ApplicationController
  def search
    term = params[:term].to_s.strip
    results = Company.search(term, fields: [:name, :description, :synonyms], misspellings: false)

    render json: results.map { |company|
      {
        id: company.id,
        name: company.name,
        description: company.description
      }
    }
  end
end
