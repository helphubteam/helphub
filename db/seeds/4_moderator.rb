unless User.moderators.any?
  User.create!(
    role: :moderator,
    email: 'moderator@covihelp.ru',
    password: 'covihelp19',
    password_confirmation: 'covihelp19',
    organization: Organization.first
  )
end
