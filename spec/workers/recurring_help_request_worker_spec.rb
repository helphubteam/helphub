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

        xit 'adds refresh logs' do
          expect { perform }.to(change { repeatable_help_request.logs.count }.from(1).to(2))
        end

        xit 'updates schedule_set_at' do
          expect { perform }.to(change { repeatable_help_request.reload.schedule_set_at }.from(local_date - 8.days).to(local_date))
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

        xit 'activates help request' do
          expect { perform }.to(change { repeatable_help_request.reload.state.to_sym }.from(:assigned).to(:active))
        end

        xit 'adds refresh logs' do
          expect { perform }.to(change { repeatable_help_request.logs.count }.from(1).to(2))
        end

        xit 'updates schedule_set_at' do
          expect { perform }.to(change { repeatable_help_request.reload.schedule_set_at }.from(local_date - 8.days).to(local_date))
        end
      end

      context 'when they are submitted' do
        let(:state) { :submitted }

        xit 'activates help request' do
          expect { perform }.to(change { repeatable_help_request.reload.state.to_sym }.from(:submitted).to(:active))
        end

        xit 'adds refresh logs' do
          expect { perform }.to(change { repeatable_help_request.logs.count }.from(1).to(2))
        end

        xit 'updates schedule_set_at' do
          expect { perform }.to(change { repeatable_help_request.reload.schedule_set_at }.from(local_date - 8.days).to(local_date))
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
end
