unless User.any?
  User.create!(
    roles: { 'admin' => true },
    email: 'admin@covihelp.ru',
    password: 'covihelp19',
    password_confirmation: 'covihelp19',
    confirmed_at: '2021-01-01 00:00:00',
    policy_confirmed: true
  )
end
