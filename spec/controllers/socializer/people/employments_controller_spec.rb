require "spec_helper"

module Socializer
  RSpec.describe People::EmploymentsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user nad employment
    let(:user) { create(:person) }

    let(:valid_attributes) do
      {
        person_id: user,
        person_employment: { employer_name: "Test Company",
                             job_title: "Tester",
                             started_on: Time.zone.now.to_date
                           }
      }
    end

    let(:employment) do
      user.employments.create!(valid_attributes[:person_employment])
    end

    let(:update_attributes) do
      { id: employment,
        person_id: user,
        person_employment: { label: "updated content" }
      }
    end

    describe "when not logged in" do
      describe "GET #new" do
        it "requires login" do
          get :new, person_id: user
          expect(response).to redirect_to root_path
        end
      end

      describe "POST #create" do
        it "requires login" do
          post :create, valid_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #edit" do
        it "requires login" do
          get :edit, id: employment, person_id: user
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, update_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, id: employment, person_id: user
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe "GET #new" do
        before do
          get :new, person_id: user
        end

        it "assigns a new Person::Employment to @employment" do
          expect(assigns(:employment)).to be_a_new(Person::Employment)
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new employment in the database" do
            expect { post :create, valid_attributes }
              .to change(Person::Employment, :count).by(1)
          end

          it "redirects to people#show" do
            post :create, valid_attributes
            expect(response).to redirect_to user
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "GET #edit" do
        before do
          get :edit, id: employment, person_id: user
        end

        it "assigns the requested employment to @employment" do
          expect(assigns(:employment)).to eq employment
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          it "redirects to people#show" do
            patch :update, update_attributes
            expect(response).to redirect_to user
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "DELETE #destroy" do
        it "deletes the employment" do
          employment
          expect { delete :destroy, id: employment, person_id: user }
            .to change(Person::Employment, :count).by(-1)
        end

        it "redirects to people#show" do
          delete :destroy, id: employment, person_id: user
          expect(response).to redirect_to user
        end
      end
    end
  end
end
