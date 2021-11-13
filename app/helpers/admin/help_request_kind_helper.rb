module Admin
  module HelpRequestKindHelper
    def options_for_datatype
      [
        ['Текстовое поле', :string],
        ['Галочка (Да/Нет)', :checkbox],
        ['Текстовое поле с переносами строки и возможностью форматирования', :textarea],
        ['Телефон', :phone],
        ['Дата и время', :date],
        ['Адрес', :address]
      ]
    end
  end
end
