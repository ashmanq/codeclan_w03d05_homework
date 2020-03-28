require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')
require_relative('./models/screen')
require_relative('./models/cinema')

require('pry')

# Deleting a cinema will cascade and delete screens/screenings and tickets
# associated with the screenings
Cinema.delete_all()
#Screen.delete_all()
#Screening.delete_all()
#Ticket.delete_all()

# Customers and Films arent associated with a cinema in the SQL table and
# so have to be deleted seperately.
Customer.delete_all()
#Film.delete_all()
#----------------------------------------------------------------------------

# A cinema is created with 3 screens and 3 movies on offer.
cinema = Cinema.new({'name' => 'Motherwell Sillyma Cinema', 'till' => 0})
cinema.save()

cinema.add_screen('screen1')
cinema.add_screen('screen2')
cinema.add_screen('screen3')

cinema.add_film('Human Centipede', 6.00)
cinema.add_film('Spirited Away', 5.00)
cinema.add_film('Ghost In The Shell', 6.00)


# screen1 = Screen.new({'name'=>'screen1', 'cinema_id' => cinema.id})
# screen1.save()
# screen2 = Screen.new({'name'=>'screen2', 'cinema_id' => cinema.id})
# screen2.save()
# screen3 = Screen.new({'name'=>'screen3', 'cinema_id' => cinema.id})
# screen3.save()

# film1 = Film.new({'title' => 'Human Centipede', 'price' => '6.00'})
# film1.save()
# film2 = Film.new({'title' => 'Spirited Away', 'price' => '5.00'})
# film2.save()
# film3 = Film.new({'title' => 'Ghost In The Shell', 'price' => '6.00'})
# film3.save()

customer1 = Customer.new({ 'name' => 'Gabrielle Munro', 'funds' => 200.00})
customer1.save()
customer2 = Customer.new({ 'name' => 'Ali Baba', 'funds' => 1000.00})
customer2.save()
customer3 = Customer.new({ 'name' => 'Snake Pliskin', 'funds' => 50.00})
customer3.save()






binding.pry()
nil








# Customer.delete_all()
# Film.delete_all()
# Ticket.delete_all()
#
# customer1 = Customer.new({ 'name' => 'James Johnson', 'funds' => 100.00})
# customer1.save()
# customer2 = Customer.new({ 'name' => 'Gabrielle Munro', 'funds' => 200.00})
# customer2.save()
# customer3 = Customer.new({ 'name' => 'Ali Baba', 'funds' => 1000.00})
# customer3.save()
# customer4 = Customer.new({ 'name' => 'Snake Pliskin', 'funds' => 50.00})
# customer4.save()
#
# film1 = Film.new({'title' => 'Human Centipede', 'price' => '6.00'})
# film1.save()
# film2 = Film.new({'title' => 'Spirited Away', 'price' => '5.00'})
# film2.save()
# film3 = Film.new({'title' => 'Ghost In The Shell', 'price' => '6.00'})
# film3.save()
#
#
# screening1 = Screening.new({'screen_time' => '10:00', 'film_id' => film1.id, 'max_tickets' => 3})
# screening1.save()
# screening2 = Screening.new({'screen_time' => '11:00', 'film_id' => film1.id, 'max_tickets' => 1})
# screening2.save()
# screening3 = Screening.new({'screen_time' => '12:00', 'film_id' => film1.id, 'max_tickets' => 1})
# screening3.save()
# screening4 = Screening.new({'screen_time' => '10:00', 'film_id' => film2.id, 'max_tickets' => 2})
# screening4.save()
# screening5 = Screening.new({'screen_time' => '11:00', 'film_id' => film2.id, 'max_tickets' => 2})
# screening5.save()
# screening6 = Screening.new({'screen_time' => '12:00', 'film_id' => film2.id, 'max_tickets' => 2})
# screening6.save()
#
# tickets1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => screening1.film_id,
#                         'screening_id' => screening1.id})
# tickets1.save()
# tickets2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => screening1.film_id,
#                         'screening_id' => screening1.id})
# tickets2.save()
# tickets3 = Ticket.new({'customer_id' => customer3.id, 'film_id' => screening3.film_id,
#                         'screening_id' => screening3.id})
# tickets3.save()
# tickets4 = Ticket.new({'customer_id' => customer4.id, 'film_id' => screening4.film_id,
#                         'screening_id' => screening1.id})
# tickets4.save()
