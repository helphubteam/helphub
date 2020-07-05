class CustomValue < ApplicationRecord
  belongs_to :help_request
  belongs_to :custom_field
end
