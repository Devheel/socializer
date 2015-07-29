#
# Namespace for the Socializer engine
#
module Socializer
  module Activities
    #
    # Audiences controller
    #
    class AudiencesController < ApplicationController
      before_action :authenticate_user

      # GET activities/1/audience
      def index
        activity    = Activity.find_by(id: params[:id])
        @object_ids = ActivityAudienceList.new(activity: activity).call

        respond_to do |format|
          format.html { render layout: false if request.xhr? }
        end
      end
    end
  end
end
