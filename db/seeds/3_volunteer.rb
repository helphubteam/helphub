unless User.volunteers.any?
  User.create!(
    roles: { 'volunteer' => true },
    name: 'Волонтир',
    surname: 'Волонтиров',
    phone: '+76666666666',
    email: 'volunteer@covihelp.ru',
    password: 'covihelp19',
    password_confirmation: 'covihelp19',
    organization: Organization.first,
    confirmed_at: '2021-01-01 00:00:00',
    policy_confirmed: true
  )
end
