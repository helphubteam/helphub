unless User.volunteers.any?
  User.create!(
      role: :volunteer,
      email: 'moderator@covihelp.ru',
      password: 'covihelp19',
      password_confirmation: 'covihelp19',
      organization: Organization.first
  )
end
