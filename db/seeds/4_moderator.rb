unless User.moderators.any?
  User.create!(
    roles: { 'moderator' => true },
    name: 'Модератор',
    surname: 'Модераторов',
    phone: '+79999999999',
    email: 'moderator@covihelp.ru',
    password: 'covihelp19',
    password_confirmation: 'covihelp19',
    organization: Organization.first,
    confirmed_at: '2021-01-01 00:00:00',
    policy_confirmed: true
  )
end
