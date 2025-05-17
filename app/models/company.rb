class Company < ApplicationRecord
  searchkick(
    searchable: [:name, :description, :synonyms],
    word_start: [:name, :synonyms],
    text_middle: [:name, :synonyms, :description],
    settings: {
      analysis: {
        tokenizer: {
          kuromoji_custom_tokenizer: {
            type: "kuromoji_tokenizer",
            mode: "search"
          },
          ngram_tokenizer: {
            type: "ngram",
            min_gram: 2,
            max_gram: 3,
            token_chars: ["letter", "digit"]
          }
        },
        analyzer: {
          kuromoji_custom_analyzer: {
            type: "custom",
            tokenizer: "kuromoji_custom_tokenizer",
            filter: ["kuromoji_baseform", "lowercase"]
          },
          ngram_analyzer: {
            type: "custom",
            tokenizer: "ngram_tokenizer",
            filter: ["lowercase"]
          }
        }
      }
    },
    mappings: {
      properties: {
        name: { 
          type: 'text',
          analyzer: 'kuromoji_custom_analyzer',
          fields: {
            ngram: {
              type: 'text',
              analyzer: 'ngram_analyzer'
            }
          }
        },
        description: { 
          type: 'text',
          analyzer: 'kuromoji_custom_analyzer',
          fields: {
            ngram: {
              type: 'text',
              analyzer: 'ngram_analyzer'
            }
          }
        },
        synonyms: { 
          type: 'text',
          analyzer: 'kuromoji_custom_analyzer',
          fields: {
            ngram: {
              type: 'text',
              analyzer: 'ngram_analyzer'
            },
            keyword: {
              type: 'keyword',
              normalizer: 'lowercase'
            }
          }
        }
      }
    },
    callbacks: false,  # Disable callbacks to prevent automatic reindexing
    batch_size: 200    # Process in batches of 200
  )

  has_many :company_synonyms, dependent: :destroy

  accepts_nested_attributes_for :company_synonyms

  def search_data
    {
      name: name,
      description: description,
      synonyms: company_synonyms.pluck(:name).map(&:strip)
    }
  end

  def should_index?
    true
  end
end
