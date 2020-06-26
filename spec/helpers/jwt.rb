def jwt_authenticated_header(user)
  time = Time.now + 1.hour
  token = JsonWebToken.encode({ user_id: user.id, exp: time })
  { 'Authorization': "Bearer #{token}" }
end
