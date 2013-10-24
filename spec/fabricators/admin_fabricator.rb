Fabricator(:admin) do
  Fabricate(:user, admin: true)
end