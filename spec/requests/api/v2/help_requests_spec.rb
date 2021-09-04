require 'rails_helper'

RSpec.describe 'Api::V2::HelpRequests', type: :request do
  include_context 'jwt authenticated'
  let(:moderator) { create :user, :moderator, organization: organization }

  describe 'when old token from wrong user role' do
    let(:user) { create :user, :admin, organization: organization, score: 3 }

    describe 'GET /api/v2/help_requests' do
      it "can't find the user" do
        get api_v2_help_requests_path
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to eq({ 'errors' => [{ 'message' => 'Пользователь не найден' }] })
      end
    end
  end

  let(:user) { create :user, :volunteer, organization: organization, score: 3 }
  let(:organization) { create :organization }

  describe 'GET /api/v2/help_requests' do
    it 'returns empty array' do
      get api_v2_help_requests_path
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([])
    end

    context 'when help_requests exist' do
      before(:each) do
        kind = create :help_request_kind, name: 'test', organization: organization
        string_field = create :custom_field, name: "string_field", help_request_kind: kind, data_type: :string
        textarea_field = create :custom_field, name: "textarea_field", help_request_kind: kind, data_type: :textarea
        checkbox_field = create :custom_field, name: "checkbox_field", help_request_kind: kind, data_type: :checkbox
        date_field = create :custom_field, name: "date_field", help_request_kind: kind, data_type: :date
        phone_field = create :custom_field, name: "phone_field", help_request_kind: kind, data_type: :phone
        help_request = create :help_request, organization: organization, creator: moderator, help_request_kind: kind
        custom_values = {
          string_field.id => "string",
          textarea_field.id => "<p><b>textarea</b></p>",
          checkbox_field.id => "true",
          date_field.id => "22-09-1989",
          phone_field.id => "{\"phone\": \"89293811231\"}"
        }

        custom_values.each do |custom_field_id, value|
          help_request.custom_values.build(
            custom_field_id: custom_field_id,
            value: value
          )
        end

        help_request.save!
      end

      it 'returns the list' do
        get api_v2_help_requests_path
        expect(response).to have_http_status(200)
        help_request_response = JSON.parse(response.body)[0]
        help_request_response.delete('created_at')
        help_request_response.delete('updated_at')
        help_request_response.delete('id')
        help_request_response.delete('creator_phone')
        lonlat = help_request_response.delete('lonlat')
        expect(lonlat['type']).to eq("Point")
        expect(lonlat['coordinates']).not_to be_empty
        expect(help_request_response).to eq(
          {
            "activated_days_ago"=>0,
            "address"=>"Moscow Center Test Street 12",
            "comment"=>"test comment",
            "custom_fields"=>
             [{"name"=>"string_field", "type"=>"string", "value"=>"string"},
              {"name"=>"textarea_field",
               "type"=>"textarea",
               "value"=>"<p><b>textarea</b></p>"},
              {"name"=>"checkbox_field", "type"=>"checkbox", "value"=>false},
              {"name"=>"date_field", "type"=>"date", "value"=>"22-09-1989"},
              {"name"=>"phone_field",
               "type"=>"phone",
               "value"=>"89293811231"}],
            "date_begin"=>nil,
            "date_end"=>nil,
            "detailed_address"=>
             {"apartment"=>nil,
              "city"=>"Moscow",
              "district"=>"Center",
              "house"=>nil,
              "street"=>"Test Street"},
            "distance"=>"",
            "geo_salt"=>true,
            "mediated"=>false,
            "meds_preciption_required"=>nil,
            "number"=>"1",
            "period"=>nil,
            "phone"=>"123****23",
            "recurring"=>nil,
            "state"=>"active",
            "title"=>nil,
            "volunteer_id"=>nil
          }
        )
      end
    end
  end

  describe 'GET /api/v1/help_requests with not empty content' do
    let!(:help_request) { create :help_request, organization: organization, creator: moderator }

    it 'returns help request JSON' do
      get api_v1_help_requests_path
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(1)
      help_request = data[0]
      expect(help_request['creator_phone']).to_not be_blank
    end
  end

  describe 'POST /api/v2/help_requests/:id/assign' do
    let!(:help_request) { create :help_request, organization: organization, creator: moderator }

    it 'assigns HelpRequest record' do
      expect(help_request.volunteer).to be_nil
      expect(help_request.state).to eq('active')
      post(assign_api_v2_help_request_path(help_request))
      expect(help_request.reload.volunteer).to eq(user)
      expect(help_request.state).to eq('assigned')
    end
  end

  describe 'POST /api/v2/help_requests/:id/refuse' do
    let!(:help_request) { create :help_request, :assigned, volunteer: user, creator: moderator, organization: organization }

    it 'refuses HelpRequest record' do
      expect(help_request.volunteer).to eq(user)
      expect(help_request.state).to eq('assigned')
      post(refuse_api_v2_help_request_path(help_request))
      expect(help_request.reload.volunteer).to be_nil
      expect(help_request.state).to eq('active')
    end
  end

  describe 'POST /api/v2/help_requests/:id/submit' do
    let!(:help_request) { create :help_request, :assigned, volunteer: user, creator: moderator, organization: organization, score: 4 }
    let(:score_result_after_submit) { user.score + help_request.score }

    it 'submits HelpRequest record' do
      volunteer = help_request.volunteer
      expecting_score = score_result_after_submit
      expect(help_request.volunteer).to eq(user)
      expect(help_request.state).to eq('assigned')
      post(submit_api_v2_help_request_path(help_request))
      expect(help_request.reload.volunteer).to be_nil
      expect(help_request.state).to eq('submitted')
      expect(volunteer.reload.score).to eq(expecting_score)
    end

    context 'when periodic HelpRequest' do
      let!(:help_request) do
        create :help_request,
               :assigned,
               period: 1,
               creator: moderator,
               volunteer: user,
               organization: organization,
               schedule_set_at: nil,
               score: 4
      end

      let(:current_date) { Time.zone.now.to_date }

      it 'sets recurring date for the record on submission' do
        post(submit_api_v2_help_request_path(help_request))
        help_request.reload
        expect(help_request.state).to eq('submitted')
        expect(help_request.schedule_set_at).to eq(current_date)
      end
    end
  end
end
