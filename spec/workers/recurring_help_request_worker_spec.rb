require 'rails_helper'

RSpec.describe RecurringHelpRequestsWorker do
  subject :perform do
    RecurringHelpRequestsWorker.new.perform
  end

  def local_time
    Time.local(2020, 1, 1, 1, 0, 0)
  end

  def local_date
    local_time.to_date
  end

  def schedule_set_at
    (local_time - 8.days).to_date
  end

  let(:organization) { create :organization }
  let(:moderator) { create :user, :moderator, organization: organization }
  let(:volunteer) { create :user, :volunteer, organization: organization }

  context 'with recurring requests' do
    let(:repeatable_help_request) do
      create :help_request,
             state: state,
             creator: moderator,
             volunteer: volunteer,
             organization: organization,
             schedule_set_at: schedule_set_at,
             period: 7
    end

    let!(:created_log) do
      create :help_request_log,
             help_request: repeatable_help_request,
             user: moderator,
             kind: :created
    end

    context "when it's time to repeat" do
      before :all do
        Timecop.travel(local_time)
      end

      context 'when they are active' do
        let(:state) { :active }

        it 'keeps help request active' do
          expect { perform }.to_not(change { repeatable_help_request.reload.state })
        end

        it 'adds refresh logs' do
          expect { perform }.to(change { repeatable_help_request.logs.count }.from(1).to(2))
        end

        it 'updates schedule_set_at' do
          expect { perform }.to(change { repeatable_help_request.reload.schedule_set_at }.from(local_date - 8.days).to(nil))
        end
      end

      context 'when they are blocked' do
        let(:state) { :blocked }

        it 'keeps help request blocked' do
          expect { perform }.to_not(change { repeatable_help_request.reload.state })
        end

        it "doesn't add refresh logs" do
          expect { perform }.to_not(change { repeatable_help_request.logs.count })
        end

        it "doesn't update schedule_set_at" do
          expect { perform }.to_not(change { repeatable_help_request.reload.schedule_set_at })
        end
      end

      context 'when they are assigned' do
        let(:state) { :assigned }

        it 'activates help request' do
          expect { perform }.to(change { repeatable_help_request.reload.state.to_sym }.from(:assigned).to(:active))
        end

        it 'adds refresh logs' do
          expect { perform }.to(change { repeatable_help_request.logs.count }.from(1).to(2))
        end

        it 'updates schedule_set_at' do
          expect { perform }.to(change { repeatable_help_request.reload.schedule_set_at }.from(local_date - 8.days).to(nil))
        end
      end

      context 'when they are submitted' do
        let(:state) { :submitted }

        it 'activates help request' do
          expect { perform }.to(change { repeatable_help_request.reload.state.to_sym }.from(:submitted).to(:active))
        end

        it 'adds refresh logs' do
          expect { perform }.to(change { repeatable_help_request.logs.count }.from(1).to(2))
        end

        it 'updates schedule_set_at' do
          expect { perform }.to(change { repeatable_help_request.reload.schedule_set_at }.from(local_date - 8.days).to(nil))
        end
      end
    end

    context "when it's too early for repeating" do
      before :all do
        Timecop.travel(schedule_set_at + 1.day)
      end

      context 'when they are active' do
        let(:state) { :active }

        it 'keeps help request active' do
          expect { perform }.to_not(change { repeatable_help_request.reload.state })
        end

        it "doesn't add refresh logs" do
          expect { perform }.to_not(change { repeatable_help_request.logs.count })
        end

        it 'keeps schedule_set_at the same' do
          expect { perform }.to_not(change { repeatable_help_request.reload.schedule_set_at })
        end
      end

      context 'when they are blocked' do
        let(:state) { :blocked }

        it 'keeps help request active' do
          expect { perform }.to_not(change { repeatable_help_request.reload.state })
        end

        it "doesn't add refresh logs" do
          expect { perform }.to_not(change { repeatable_help_request.logs.count })
        end

        it 'keeps schedule_set_at the same' do
          expect { perform }.to_not(change { repeatable_help_request.reload.schedule_set_at })
        end
      end

      context 'when they are assigned' do
        let(:state) { :assigned }

        it 'keeps help request active' do
          expect { perform }.to_not(change { repeatable_help_request.reload.state })
        end

        it "doesn't add refresh logs" do
          expect { perform }.to_not(change { repeatable_help_request.logs.count })
        end

        it 'keeps schedule_set_at the same' do
          expect { perform }.to_not(change { repeatable_help_request.reload.schedule_set_at })
        end
      end

      context 'when they are submitted' do
        let(:state) { :submitted }

        it 'keeps help request active' do
          expect { perform }.to_not(change { repeatable_help_request.reload.state })
        end

        it "doesn't add refresh logs" do
          expect { perform }.to_not(change { repeatable_help_request.logs.count })
        end

        it 'keeps schedule_set_at the same' do
          expect { perform }.to_not(change { repeatable_help_request.reload.schedule_set_at })
        end
      end
    end
  end

  context 'without recurring requests' do
    before :all do
      Timecop.travel(local_time)
    end

    let(:repeatable_help_request) do
      create :help_request,
             state: :submitted,
             creator: moderator,
             volunteer: volunteer,
             organization: organization,
             schedule_set_at: nil,
             period: nil
    end

    let!(:created_log) do
      create :help_request_log,
             help_request: repeatable_help_request,
             user: moderator,
             kind: :created
    end

    it 'keeps help request active' do
      expect { perform }.to_not(change { repeatable_help_request.reload.state })
    end

    it "doesn't add refresh logs" do
      expect { perform }.to_not(change { repeatable_help_request.logs.count })
    end

    it 'keeps schedule_set_at the same' do
      expect { perform }.to_not(change { repeatable_help_request.reload.schedule_set_at })
    end
  end

  context 'with use case' do
    let(:period) { 10 }

    context 'when create help request with recurring' do
      before :each do
        params = {
          recurring: 'true',
          period: period
        }
        @help_request = moderator_creates_help_request(params)
      end

      context '1: submit it, time to repeat' do
        it 'should reactivate help request and drop volunteer' do
          volunteer_assigns_help_request(@help_request)
          volunteer_submits_help_request(@help_request)
          delay_in_days(period)
          check_reactivates(@help_request)
        end
      end

      context '2: assign it but not submit, time to repeat' do
        it 'should not reactivate help request and keep volunteer' do
          volunteer_assigns_help_request(@help_request)
          delay_in_days(period)
          check_does_not_reactivate(@help_request)
        end
      end

      context '3: it keeps active, time to repeat' do
        it 'should not reactivate help request and keep volunteer' do
          delay_in_days(period)
          check_does_not_reactivate(@help_request)
        end
      end

      context '4: block it, time to repeat' do
        it 'should not reactivate help request and keep volunteer' do
          moderator_blocks_help_request(@help_request)
          delay_in_days(period)
          check_does_not_reactivate(@help_request)
        end
      end

      context '5: assign it but not submit, block it, time to repeat' do
        it 'should not reactivate help request and keep volunteer' do
          volunteer_assigns_help_request(@help_request)
          moderator_blocks_help_request(@help_request)
          delay_in_days(period)
          check_does_not_reactivate(@help_request)
        end
      end

      context '6: submit it, block it, time to repeat' do
        it 'should not reactivate help request and keep volunteer' do
          volunteer_assigns_help_request(@help_request)
          volunteer_submits_help_request(@help_request)
          moderator_blocks_help_request(@help_request)
          delay_in_days(period)
          check_does_not_reactivate(@help_request)
        end
      end
    end

    context 'when moderator creates help request then setups recurring for it' do
      before :each do
        @help_request = moderator_creates_help_request
        moderator_sets_recurring(@help_request, period)
      end

      context '7-1: submit it, time to repeat' do
        it 'should reactivate help request and drop volunteer' do
          volunteer_assigns_help_request(@help_request)
          volunteer_submits_help_request(@help_request)
          delay_in_days(period)
          check_reactivates(@help_request)
        end
      end

      context '7-2: assign it but not submit, time to repeat' do
        it 'should not reactivate help request and keep volunteer' do
          volunteer_assigns_help_request(@help_request)
          delay_in_days(period)
          check_does_not_reactivate(@help_request)
        end
      end

      context '7-3: it keeps active, time to repeat' do
        it 'should not reactivate help request and keep volunteer' do
          delay_in_days(period)
          check_does_not_reactivate(@help_request)
        end
      end

      context '7-4: block it, time to repeat' do
        it 'should not reactivate help request and keep volunteer' do
          moderator_blocks_help_request(@help_request)
          delay_in_days(period)
          check_does_not_reactivate(@help_request)
        end
      end

      context '7-5: assign it but not submit, block it, time to repeat' do
        it 'should not reactivate help request and keep volunteer' do
          volunteer_assigns_help_request(@help_request)
          moderator_blocks_help_request(@help_request)
          delay_in_days(period)
          check_does_not_reactivate(@help_request)
        end
      end

      context '7-6: submit it, block it, time to repeat' do
        it 'should not reactivate help request and keep volunteer' do
          volunteer_assigns_help_request(@help_request)
          volunteer_submits_help_request(@help_request)
          moderator_blocks_help_request(@help_request)
          delay_in_days(period)
          check_does_not_reactivate(@help_request)
        end
      end
    end

    context '8: when moderator creates help request, volunteer submits it, then moderator adds recurring in X adter N days' do
      before :each do
        @help_request = moderator_creates_help_request
      end

      it 'should reactivate help request and drop volunteer in X - N days' do
        volunteer_assigns_help_request(@help_request)
        volunteer_submits_help_request(@help_request)
        delay_in_days(10)
        moderator_sets_recurring(@help_request, 12)
        delay_in_days(2)
        check_reactivates(@help_request)
      end
    end

    private

    def default_help_request_params
      {
        lonlat_geojson: '{"type":"Point","coordinates":[37.54852294921875,55.77502825125135]}',
        phone: '123123123',
        city: 'Moscow',
        district: 'Moscow Region',
        street: 'Lenina',
        person: 'Some Person To Help',
        house: '1a',
        apartment: '121',
        comment: 'Comment'
      }
    end

    def moderator_creates_help_request(help_request_params = {})
      help_request = HelpRequest.new
      help_request.organization = moderator.organization

      params = {
        help_request: default_help_request_params.merge(help_request_params)
      }

      Admin::HelpRequestCases::Create.new(
        help_request, build_params(params), moderator
      ).call

      raise help_request.errors.messages.to_json unless help_request.valid?

      help_request
    end

    def moderator_sets_recurring(help_request, period)
      params = {
        help_request: {
          recurring: 'true',
          period: period
        }
      }
      Admin::HelpRequestCases::Update.new(
        help_request, build_params(params), moderator
      ).call

      raise help_request.errors.messages unless help_request.valid?
    end

    def moderator_blocks_help_request(help_request)
      params = {
        help_request: {
          block: true
        }
      }
      Admin::HelpRequestCases::Update.new(
        help_request, build_params(params), moderator
      ).call

      raise help_request.errors.messages unless help_request.valid?
    end

    def volunteer_submits_help_request(help_request)
      params = {
        comment: 'Submit comment'
      }

      Api::V1::HelpRequestCases::Submit.new({
                                              help_request: help_request,
                                              volunteer: volunteer,
                                              params: build_params(params)
                                            }).call
    end

    def volunteer_assigns_help_request(help_request)
      params = {
        comment: 'Assign comment'
      }

      Api::V1::HelpRequestCases::Assign.new({
                                              help_request: help_request,
                                              volunteer: volunteer,
                                              params: build_params(params)
                                            }).call
    end

    def delay_in_days(days)
      Timecop.travel(Time.zone.now + days.days)
    end

    def check_does_not_reactivate(help_request)
      old_volunteer_id = help_request.volunteer_id
      old_state = help_request.reload.state
      perform
      expect(help_request.reload.state).to eq(old_state)
      expect(help_request.volunteer_id).to eq(old_volunteer_id)
    end

    def check_reactivates(help_request)
      perform
      expect(help_request.reload.state).to eq('active')
      expect(help_request.volunteer).to be_nil
    end

    def build_params(hsh)
      ActionController::Parameters.new(hsh)
    end
  end
end
