#
# Namespace for the Socializer engine
#
module Socializer
  module People
    class ProfilesController < ApplicationController
      before_action :authenticate_user

      # POST /people/1/profiles
      def create
        @person_profile = current_user.profiles.build(params[:person_profile])
        @person_profile.save!
        redirect_to current_user
      end

      # PATCH/PUT /people/1/profiles/1
      def update
        @person_profile = find_person_profile
        @person_profile.update!(params[:person_profile])
        redirect_to current_user
      end

      # DELETE /people/1/profiles/1
      def destroy
        @person_profile = find_person_profile
        @person_profile.destroy
        redirect_to current_user
      end

      private

      def find_person_profile
        current_user.profiles.find_by(id: params[:id])
      end
    end
  end
end
