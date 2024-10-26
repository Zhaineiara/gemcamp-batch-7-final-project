# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(email: 'admin123@gmail.com', password: 'admin123', username: 'admin123', role: 'admin', phone: '+639995240842', coins: 0, total_deposit: 0.0, children_members: 0)
