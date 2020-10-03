unless User.volunteers.any?
  User.create!(
    roles: { 'volunteer' => true },
    email: 'volunteer@covihelp.ru',
    password: 'covihelp19',
    password_confirmation: 'covihelp19',
    organization: Organization.first
  )
end
