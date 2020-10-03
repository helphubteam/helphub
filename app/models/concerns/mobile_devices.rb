require 'active_support/concern'

module MobileDevices
  extend ActiveSupport::Concern

  DEVICE_PLATFORMS = %w[android ios].freeze

  included do
    validates :device_platform, inclusion: { in: DEVICE_PLATFORMS, allow_blank: true }

    def android_device?
      device_platform == 'android'
    end
  
    def ios_device?
      device_platform == 'ios'
    end
  end
end
