# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'date'

#  USERS 
puts "Creating users..."
admin = User.create!(
  name: "Messi",
  password: "Maradona",
  birthday: Date.new(1987, 6, 27),
  nationality: "Argentina",
  gender: "M",
  is_admin: true
)

user1 = User.create!(
  name: "Nicolás Leighton",
  password: "password",
  birthday: Date.new(2002, 3, 15),
  nationality: "Chile",
  gender: "M",
  is_admin: false
)

user2 = User.create!(
  name: "Shakira",
  password: "WakaWaka",
  birthday: Date.new(1977, 2, 2),
  nationality: "Colombia",
  gender: "F",
  is_admin: false
)

user3 = User.create!(
  name: "Lebron",
  password: "Sunshine",
  birthday: Date.new(1984, 12, 30),
  nationality: "USA",
  gender: "M",
  is_admin: false
)

#BADGES
puts "Creating badges..."
b1 = Badge.create!(
  name: "Primer Desafío",
  logo: "badge_start.png",
  badge_type: "participación",
  description: "Completaste tu primer desafío",
  requirement: "Participar en cualquier desafío"
)

b2 = Badge.create!(
  name: "Top Runner",
  logo: "badge_runner.png",
  badge_type: "rendimiento",
  description: "Termina en el top 3 the un challenge de correr",
  requirement: "Termina en el top 3 the un challenge de correr"
)

b3 = Badge.create!(
  name: "Constante",
  logo: "badge_streak.png",
  badge_type: "Participacion",
  description: "Participa por 7 días seguidos",
  requirement: "7 días consecutivos con progreso"
)

#  CHALLENGES 
puts "Creating challenges..."
c1 = Challenge.create!(
  name: "Desafío Semanal Running",
  description: "Corre 10 kilometros a lo largo de la semana",
  start_day: Date.today,
  end_day: Date.today + 7,
  point_rules: "1 punto por km corrido",
  creator_id: admin.id
)

c2 = Challenge.create!(
  name: "Reto de Bicicleta",
  description: "Recorre 50 km en una semana",
  start_day: Date.today,
  end_day: Date.today + 7,
  point_rules: "1 punto por cada km completado",
  creator_id: admin.id
)

#  CHALLENGE BADGES 
ChallengeBadge.create!(challenge_id: c1.id, badge_id: b2.id, requirement: "1 punto por cada km completado")
ChallengeBadge.create!(challenge_id: c2.id, badge_id: b3.id, requirement: "1 punto por cada km completado")

#  PARTICIPATIONS 
puts "Creating participations..."
Participation.create!(challenge_id: c1.id, user_id: user1.id, points: 120, date_start: Date.today - 1)
Participation.create!(challenge_id: c1.id, user_id: user2.id, points: 80, date_start: Date.today - 1)
Participation.create!(challenge_id: c2.id, user_id: user3.id, points: 60, date_start: Date.today - 1)

#  PROGRESS ENTRIES 
puts "Creating progress entries..."
ProgressEntry.create!(challenge_id: c1.id, user_id: user1.id, date: Date.today, points: 20, description: "Corrí 5 km")
ProgressEntry.create!(challenge_id: c1.id, user_id: user2.id, date: Date.today, points: 10, description: "Corrí 2.5 km")
ProgressEntry.create!(challenge_id: c2.id, user_id: user3.id, date: Date.today, points: 15, description: "Anduve 15 km en bici")

#  USER BADGES 
puts "Assigning user badges..."
UserBadge.create!(user_id: user1.id, badge_id: b1.id, awarded_at: Time.now)
UserBadge.create!(user_id: user1.id, badge_id: b2.id, awarded_at: Time.now)
UserBadge.create!(user_id: user3.id, badge_id: b1.id, awarded_at: Time.now)

# NOTIFICATIONS 
puts "Creating notifications..."
Notification.create!(user_id: user1.id, message: "Ganaste la medalla 'Primer Desafío'!", read: false)
Notification.create!(user_id: user2.id, message: "Tienes nuevo desafío disponible", read: false)
Notification.create!(user_id: user3.id, message: "Completaste tu reto de bicicleta", read: true)

puts "Seed data created successfully!"
