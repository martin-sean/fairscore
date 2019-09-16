# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Default media watch status (Do not modify)
Status.create(id: 0, label: 'Watching')
Status.create(id: 1, label: 'Plan to Watch')
Status.create(id: 2, label: 'Completed')
Status.create(id: 3, label: 'On Hold')
Status.create(id: 4, label: 'Dropped')