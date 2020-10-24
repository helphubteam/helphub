module Admin
  class ManualPushesController < BaseController
    before_action :check_admin!

    def recurring
      begin
        Recurring.call
        flash[:success] = 'Периодические просьбы созданы'
      rescue Error => e
        flash[:error] = "Возникли ошибки при создании просьб: \n#{e.message}"
      end
      redirect_to :admin_dashboard
    end

    private

    def check_admin!
      raise Pundit::NotAuthorizedError unless current_user.admin?
    end
  end
end
