restaurant = Restaurant.find_or_create_by!(slug: "marmitaria-sabor-da-casa") do |r|
  r.name = "Marmitaria Sabor da Casa"
  r.whatsapp = "5561999999999"
  r.active = true
  r.accepting_orders = true
end

User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "Administrador"
  u.password = "password123"
  u.restaurant = restaurant
end

categories = %w[Marmitas Massas Bebidas Adicionais].each_with_index.map do |name, index|
  restaurant.categories.find_or_create_by!(name: name) do |c|
    c.position = index
    c.active = true
  end
end

marmitas, massas, bebidas, _adicionais_categoria = categories

queijo_extra = restaurant.addons.find_or_create_by!(name: "Queijo extra") { |a| a.price = 3.00 }
bacon = restaurant.addons.find_or_create_by!(name: "Bacon") { |a| a.price = 4.00 }
ovo = restaurant.addons.find_or_create_by!(name: "Ovo") { |a| a.price = 2.00 }

parmegiana = restaurant.products.find_or_create_by!(name: "Parmegiana de Frango") do |p|
  p.category = marmitas
  p.description = "Filé de frango empanado com molho e queijo."
  p.price = 25.00
  p.active = true
  p.position = 0
end
parmegiana.addons = [ queijo_extra, bacon, ovo ]

carne = restaurant.products.find_or_create_by!(name: "Marmita de Carne") do |p|
  p.category = marmitas
  p.description = "Carne moída, arroz, feijão e farofa."
  p.price = 20.00
  p.active = true
  p.position = 1
end
carne.addons = [ queijo_extra, ovo ]

restaurant.products.find_or_create_by!(name: "Espaguete à Bolonhesa") do |p|
  p.category = massas
  p.description = "Massa fresca com molho bolonhesa."
  p.price = 22.00
  p.active = true
  p.position = 0
end

restaurant.products.find_or_create_by!(name: "Refrigerante Lata") do |p|
  p.category = bebidas
  p.description = "350ml, diversos sabores."
  p.price = 6.00
  p.active = true
  p.position = 0
end

(0..6).each do |day|
  restaurant.business_hours.find_or_create_by!(day_of_week: day) do |h|
    h.active = day.between?(1, 5)
    h.open_time = "08:00"
    h.close_time = "14:00"
  end
end

puts "Seed concluído. Login admin: admin@example.com / password123"
puts "Cardápio público: /r/#{restaurant.slug}"
