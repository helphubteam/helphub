unless User.any?
  User.create!(
    role: :admin,
    email: 'admin@covihelp.ru',
    password: 'covihelp19',
    password_confirmation: 'covihelp19'
  )
end
