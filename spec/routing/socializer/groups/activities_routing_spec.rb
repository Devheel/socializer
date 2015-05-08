require 'rails_helper'

module Socializer
  RSpec.describe Groups::ActivitiesController, type: :routing do
    routes { Socializer::Engine.routes }

    describe 'routing' do
      it 'routes to #index' do
        expect(get: '/groups/1/activities').to route_to('socializer/groups/activities#index', group_id: '1')
      end

      it 'does not route to #new' do
        expect(get: '/groups/1/activities/new').to_not be_routable
      end

      it 'does not route to #show' do
        expect(get: '/groups/1/activities/1/show').to_not be_routable
      end

      it 'does not route to #edit' do
        expect(get: '/groups/1/activities/1/edit').to_not be_routable
      end

      it 'does not route to #create' do
        expect(post: '/groups/1/activities').to_not be_routable
      end

      it 'does not route to #update' do
        expect(patch: '/groups/1/activities/1').to_not be_routable
        expect(put: '/groups/1/activities/1').to_not be_routable
      end

      it 'does not route to #destroy' do
        expect(delete: '/groups/1/activities/1').to_not be_routable
      end
    end
  end
end