# frozen_string_literal: true

class CreateSocializerPersonProfiles < ActiveRecord::Migration[4.2]
  def change
    create_table :socializer_person_profiles do |t|
      t.integer  :person_id, null: false
      t.string   :display_name, null: false
      t.string   :url, null: false

      t.timestamps null: false
    end

    add_index :socializer_person_profiles, :person_id
    add_foreign_key :socializer_person_profiles, :socializer_people
  end
end
