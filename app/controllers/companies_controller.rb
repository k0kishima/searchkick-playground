class CompaniesController < ApplicationController
  def search
    term = params[:term].to_s.strip
    results = Company.search(term,
      body_options: {
        query: {
          bool: {
            should: [
              # Exact matches in synonyms (highest priority for acronyms)
              { term: {
                  "synonyms.keyword": {
                    value: term.upcase,
                    boost: 100
                  }
                }
              },
              # Exact matches in description
              { match_phrase: {
                  description: {
                    query: term,
                    analyzer: 'kuromoji_custom_analyzer',
                    boost: 50,
                    slop: 0
                  }
                }
              },
              # Match prefix for compound words
              { match_phrase_prefix: {
                  description: {
                    query: term,
                    analyzer: 'kuromoji_custom_analyzer',
                    boost: 40,
                    max_expansions: 50
                  }
                }
              },
              # Partial matches in description
              { match: {
                  description: {
                    query: term,
                    analyzer: 'kuromoji_custom_analyzer',
                    boost: 30,
                    operator: 'and'
                  }
                }
              },
              # Fallback to other fields with lower priority
              { multi_match: {
                  query: term,
                  fields: ['name^20', 'synonyms^20'],
                  type: 'best_fields',
                  analyzer: 'kuromoji_custom_analyzer',
                  operator: 'and',
                  minimum_should_match: '75%'
                }
              }
            ],
            minimum_should_match: 1
          }
        },
        min_score: 8.0,
        _source: true
      }
    )

    # Log the search details
    Rails.logger.debug "=== Search Details ==="
    Rails.logger.debug "Search term: #{term}"
    Rails.logger.debug "Search query: #{results.body}"
    Rails.logger.debug "=== Search Results ==="
    results.response['hits']['hits'].each do |hit|
      Rails.logger.debug "ID: #{hit['_id']}, Score: #{hit['_score']}"
      Rails.logger.debug "Matched fields: #{hit['_source']}"
      Rails.logger.debug "---"
    end

    render json: results.map { |company|
      {
        id: company.id,
        name: company.name,
        description: company.description
      }
    }
  end
end
