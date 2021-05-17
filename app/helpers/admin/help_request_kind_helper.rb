module Admin
  module HelpRequestKindHelper
    def options_for_datatype
      [
        ["#{t(".enter_text_field")}", :string],
        ["#{t(".enter_checkbox")}", :checkbox],
        ["#{t(".enter_textarea")}", :textarea],
        ["#{t(".enter_data_time")}", :date]
      ]
    end
  end
end
