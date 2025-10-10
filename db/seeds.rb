# db/seeds.rb
# Rails 8 – idempotente y alineado a tu schema/models

require "date"
ActiveRecord::Base.transaction do
  puts "Seeding users..."
  admin = User.find_or_create_by!(name: "Messi") do |u|
    u.password = "Maradona"
    u.birthday = Date.new(1987, 6, 27)
    u.nationality = "Argentina"
    u.gender = "M"
    u.is_admin = true
  end

  user1 = User.find_or_create_by!(name: "Nicolás Leighton") do |u|
    u.password = "password"
    u.birthday = Date.new(2002, 3, 15)
    u.nationality = "Chile"
    u.gender = "M"
    u.is_admin = false
  end

  user2 = User.find_or_create_by!(name: "Shakira") do |u|
    u.password = "WakaWaka"
    u.birthday = Date.new(1977, 2, 2)
    u.nationality = "Colombia"
    u.gender = "F"
    u.is_admin = false
  end

  user3 = User.find_or_create_by!(name: "Lebron") do |u|
    u.password = "Sunshine"
    u.birthday = Date.new(1984, 12, 30)
    u.nationality = "USA"
    u.gender = "M"
    u.is_admin = false
  end

  puts "Seeding badges..."
  b1 = Badge.find_or_create_by!(name: "Primer Desafío") do |b|
    b.logo = "badge_start.png"
    b.badge_type = "participación"
    b.description = "Completaste tu primer desafío"
    b.requirement = "Participar en cualquier desafío"
  end

  b2 = Badge.find_or_create_by!(name: "Top Runner") do |b|
    b.logo = "badge_runner.png"
    b.badge_type = "rendimiento"
    b.description = "Termina en el top 3 de un challenge de correr"
    b.requirement = "Top 3 en challenge de correr"
  end

  b3 = Badge.find_or_create_by!(name: "Constante") do |b|
    b.logo = "badge_streak.png"
    b.badge_type = "participación"
    b.description = "Participa por 7 días seguidos"
    b.requirement = "7 días consecutivos con progreso"
  end

  puts "Seeding challenges..."
  c1 = Challenge.find_or_create_by!(name: "Desafío Semanal Running") do |c|
    c.description = "Corre 10 kilómetros a lo largo de la semana"
    c.start_day   = Date.today
    c.end_day     = Date.today + 7
    c.point_rules = "1 punto por km corrido"
    c.creator     = admin
  end

  c2 = Challenge.find_or_create_by!(name: "Reto de Bicicleta") do |c|
    c.description = "Recorre 50 km en una semana"
    c.start_day   = Date.today
    c.end_day     = Date.today + 7
    c.point_rules = "1 punto por cada km completado"
    c.creator     = admin
  end

  puts "Linking challenge badges..."
  ChallengeBadge.find_or_create_by!(challenge: c1, badge: b2) do |cb|
    cb.requirement = "Top 3 semanal en running"
  end
  ChallengeBadge.find_or_create_by!(challenge: c2, badge: b3) do |cb|
    cb.requirement = "7 días seguidos con progreso"
  end

  puts "Seeding participations..."
  Participation.find_or_create_by!(challenge: c1, user: user1) do |p|
    p.points     = 120
    p.date_start = Date.today - 1
  end
  Participation.find_or_create_by!(challenge: c1, user: user2) do |p|
    p.points     = 80
    p.date_start = Date.today - 1
  end
  Participation.find_or_create_by!(challenge: c2, user: user3) do |p|
    p.points     = 60
    p.date_start = Date.today - 1
  end

  puts "Seeding progress entries..."
  ProgressEntry.find_or_create_by!(challenge: c1, user: user1, date: Date.today) do |e|
    e.points = 20
    e.description = "Corrí 5 km"
  end
  ProgressEntry.find_or_create_by!(challenge: c1, user: user2, date: Date.today) do |e|
    e.points = 10
    e.description = "Corrí 2.5 km"
  end
  ProgressEntry.find_or_create_by!(challenge: c2, user: user3, date: Date.today) do |e|
    e.points = 15
    e.description = "Anduve 15 km en bici"
  end

  puts "Assigning user badges..."
  UserBadge.find_or_create_by!(user: user1, badge: b1) { |ub| ub.awarded_at = Time.now }
  UserBadge.find_or_create_by!(user: user1, badge: b2) { |ub| ub.awarded_at = Time.now }
  UserBadge.find_or_create_by!(user: user3, badge: b1) { |ub| ub.awarded_at = Time.now }

  puts "Seeding notifications..."
  Notification.find_or_create_by!(user: user1, message: "Ganaste la medalla 'Primer Desafío'!") { |n| n.read = false }
  Notification.find_or_create_by!(user: user2, message: "Tienes nuevo desafío disponible") { |n| n.read = false }
  Notification.find_or_create_by!(user: user3, message: "Completaste tu reto de bicicleta") { |n| n.read = true }

  puts "Seed data created successfully!"
end
