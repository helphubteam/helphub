module Admin
  module DashboardHelper
    def dashboard_field(name, value)
      content_tag :div, class: 'col' do
        [
          content_tag(:h1, value),
          content_tag(:div, name)
        ].join.html_safe
      end
    end
  end
end
