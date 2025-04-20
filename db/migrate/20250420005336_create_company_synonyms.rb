class CreateCompanySynonyms < ActiveRecord::Migration[8.0]
  def change
    create_table :company_synonyms do |t|
      t.string :name, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
