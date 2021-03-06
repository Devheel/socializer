# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :person_place, class: Socializer::Person::Place do
    city_name "name"
    current true
    association :person, factory: :person
  end
end
