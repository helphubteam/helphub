unless User.content_managers.any?
  User.create!(
    roles: { 'content_manager' => true },
    name: 'Контент',
    surname: 'Менеджер',
    phone: '+79999123499',
    email: 'contentmanager@covihelp.ru',
    password: 'covihelp19',
    password_confirmation: 'covihelp19',
    organization: Organization.first,
    confirmed_at: '2021-01-01 00:00:00',
    policy_confirmed: true
  )
end
