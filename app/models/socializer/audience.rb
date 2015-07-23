#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Audience model
  #
  # Every {Socializer::Activity} is shared with one or more
  # {Socializer::Audience audiences}.
  #
  class Audience < ActiveRecord::Base
    extend Enumerize

    enumerize :privacy, in:  %w(public circles limited),
                        default: :public, predicates: true, scope: true

    attr_accessible :activity_id, :privacy

    # Relationships
    belongs_to :activity, inverse_of: :audiences
    belongs_to :activity_object, inverse_of: :audiences

    # Validations
    # validates :activity_id, presence: true,
    #                         uniqueness: { scope: :activity_object_id }
    validates :privacy, presence: true

    # Named Scopes

    # Class Methods

    # Find audiences where the activity_id is equal to the given id
    #
    # @param id: [Fixnum]
    #
    # @return [ActiveRecord::Relation]
    def self.by_activity_id(id:)
      where(activity_id: id)
    end

    # Find audiences where the activity_object_id is equal to the given id
    #
    # @param id: [Fixnum]
    #
    # @return [ActiveRecord::Relation]
    def self.by_activity_object_id(id:)
      where(activity_object_id: id)
    end

    # Instance Methods

    def object
      activity_object.activitable
    end
  end
end
