#
# Namespace for the Socializer engine
#
module Socializer
  module ApplicationHelper
    # Build the sign path for the given provider
    #
    # @param provider [String/Symbol]
    #
    # @return [String]
    def signin_path(provider)
      "/auth/#{provider}"
    end

    # Check if the current_user and the user are the same
    #
    # @param user [Socializer::Person]
    #
    # @return [TrueClass/FalseClass]
    def current_user?(user)
      user == current_user
    end
  end
end
