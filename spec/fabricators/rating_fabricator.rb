Fabricator(:rating) do
  rate { rand(1..5) }
  description { Faker::Lorem.paragraph(2)}
end