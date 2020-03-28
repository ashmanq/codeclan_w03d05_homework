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

cinema.add_screen('screen1', 2)
cinema.add_screen('screen2', 3)
cinema.add_screen('screen3', 10)

cinema.add_film('Human Centipede', 6.00)
cinema.add_film('Spirited Away', 5.00)
cinema.add_film('Ghost In The Shell', 6.00)

cinema.add_customer('Gabrielle Munro', 200.00)
cinema.add_customer('Ali Baba', 1000.00)
cinema.add_customer('Snake Pliskin', 50.00)



binding.pry()
nil
