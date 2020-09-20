module Admin
  class SettingsController < BaseController
    def index
      authorize Setting.new
    end

    def update
      authorize Setting.new

      settings_params.each do |key, value|
        Setting.public_send("#{key}=", value)
      end
      flash[:notice] = 'Настройки сохранены'
      redirect_to action: :index
    end

    private

    def settings_params
      params.require(:settings).permit(:analytics)
    end
  end
end
