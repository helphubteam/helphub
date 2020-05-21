unless User.volunteers.any?
  User.create!(
    role: :volunteer,
    email: 'volunteer@covihelp.ru',
    password: 'covihelp19',
    password_confirmation: 'covihelp19',
    organization: Organization.first
  )
end
