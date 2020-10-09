unless User.moderators.any?
  User.create!(
    roles: { 'moderator' => true },
    name: 'Модератор',
    surname: 'Модераторов',
    phone: '+79999999999',
    email: 'moderator@covihelp.ru',
    password: 'covihelp19',
    password_confirmation: 'covihelp19',
    organization: Organization.first
  )
end
