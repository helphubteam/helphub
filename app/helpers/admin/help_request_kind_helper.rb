module Admin
  module HelpRequestKindHelper
    def options_for_datatype
      [
        ['Текстовое поле', :string],
        ['Галочка (Да/Нет)', :checkbox],
        ['Текстовое поле с переносами строки и возможностью форматирования', :textarea],
        ['Дата и время', :date]
      ]
    end
  end
end

