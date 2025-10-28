# db/seeds.rb
# Rails 8 — Idempotent and aligned with your schema/models

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

  user1 = User.find_or_create_by!(name: "Nicolas Leighton") do |u|
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

  user3 = User.find_or_create_by!(name: "LeBron") do |u|
    u.password = "Sunshine"
    u.birthday = Date.new(1984, 12, 30)
    u.nationality = "USA"
    u.gender = "M"
    u.is_admin = false
  end

  puts "Seeding badges..."
  b1 = Badge.find_or_create_by!(name: "First Challenge") do |b|
    b.logo = "badge_start.png"
    b.badge_type = "participation"
    b.description = "You completed your first challenge"
    b.requirement = "Join any challenge"
  end

  b2 = Badge.find_or_create_by!(name: "Top Runner") do |b|
    b.logo = "badge_runner.png"
    b.badge_type = "performance"
    b.description = "Finish in the top 3 of a running challenge"
    b.requirement = "Top 3 in a running challenge"
  end

  b3 = Badge.find_or_create_by!(name: "Consistent") do |b|
    b.logo = "badge_streak.png"
    b.badge_type = "participation"
    b.description = "Participate for 7 consecutive days"
    b.requirement = "7 consecutive days with progress"
  end

  puts "Seeding challenges..."
  c1 = Challenge.find_or_create_by!(name: "Weekly Running Challenge") do |c|
    c.description = "Run 10 kilometers throughout the week"
    c.start_day   = Date.today
    c.end_day     = Date.today + 7
    c.point_rules = "1 point per kilometer run"
    c.creator     = admin
  end

  c2 = Challenge.find_or_create_by!(name: "Cycling Challenge") do |c|
    c.description = "Cycle 50 km in one week"
    c.start_day   = Date.today
    c.end_day     = Date.today + 7
    c.point_rules = "1 point per km completed"
    c.creator     = admin
  end

  puts "Linking challenge badges..."
  ChallengeBadge.find_or_create_by!(challenge: c1, badge: b2) do |cb|
    cb.requirement = "Top 3 weekly in running"
  end
  ChallengeBadge.find_or_create_by!(challenge: c2, badge: b3) do |cb|
    cb.requirement = "7 consecutive days with progress"
  end

  puts "Seeding participations..."
  Participation.find_or_create_by!(challenge: c1, user: user1) do |p|
    p.points     = 120
    p.date_start = c1.start_day
  end
  Participation.find_or_create_by!(challenge: c1, user: user2) do |p|
    p.points     = 80
    p.date_start = c1.start_day
  end
  Participation.find_or_create_by!(challenge: c2, user: user3) do |p|
    p.points     = 60
    p.date_start = c2.start_day
  end

  puts "Seeding progress entries..."
  ProgressEntry.find_or_create_by!(challenge: c1, user: user1, date: c1.start_day + 1) do |e|
    e.points = 20
    e.description = "Ran 5 km"
  end
  ProgressEntry.find_or_create_by!(challenge: c1, user: user2, date: c1.start_day + 1) do |e|
    e.points = 10
    e.description = "Ran 2.5 km"
  end
  ProgressEntry.find_or_create_by!(challenge: c2, user: user3, date: c2.start_day + 1) do |e|
    e.points = 15
    e.description = "Cycled 15 km"
  end

  puts "Assigning user badges..."
  UserBadge.find_or_create_by!(user: user1, badge: b1) { |ub| ub.awarded_at = Time.now }
  UserBadge.find_or_create_by!(user: user1, badge: b2) { |ub| ub.awarded_at = Time.now }
  UserBadge.find_or_create_by!(user: user3, badge: b1) { |ub| ub.awarded_at = Time.now }

  puts "Seeding notifications..."
  Notification.find_or_create_by!(user: user1, message: "You earned the 'First Challenge' badge!") { |n| n.read = false }
  Notification.find_or_create_by!(user: user2, message: "A new challenge is available!") { |n| n.read = false }
  Notification.find_or_create_by!(user: user3, message: "You completed your cycling challenge!") { |n| n.read = true }

  puts "Seed data created successfully!"
end
