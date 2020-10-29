unless User.any?
  User.create!(
    roles: { 'admin' => true },
    email: 'adminadmin@covihelp.ru',
    password: 'covihelp19',
    password_confirmation: 'covihelp19'
  )
end
