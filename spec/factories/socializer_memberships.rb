# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :socializer_membership, class: Socializer::Membership do
    active true
    association :group, factory: :group
    association :activity_member, factory: :activity_object_person
  end
end
