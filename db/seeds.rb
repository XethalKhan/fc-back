# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "digest"

default_password = Digest::SHA256.hexdigest("Pass123!")

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

User.create!(full_name: 'Pera Peric', email: 'pera.peric@example.com', password: default_password) if Rails.env.development?
User.create!(full_name: 'Zika Zikic', email: 'zika.zikic@example.com', password: default_password) if Rails.env.development?
User.create!(full_name: 'Laza Lazic', email: 'laza.lazic@google.com', password: default_password) if Rails.env.development?
User.create!(full_name: 'Mika Mikic', email: 'mika.mikic@google.com', password: default_password) if Rails.env.development?
