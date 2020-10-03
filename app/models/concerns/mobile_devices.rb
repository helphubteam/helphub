require 'active_support/concern'

module MobileDevices
  extend ActiveSupport::Concern

  ANDROID = 'android'.freeze
  IOS = 'ios'.freeze
  DEVICE_PLATFORMS = [ANDROID, IOS].freeze

  included do
    validates :device_platform, inclusion: { in: DEVICE_PLATFORMS, allow_blank: true }

    def android_device?
      device_platform == ANDROID
    end

    def ios_device?
      device_platform == IOS
    end
  end
end
