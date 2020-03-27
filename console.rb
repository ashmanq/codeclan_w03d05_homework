require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry')

Customer.delete_all()
Film.delete_all()
Ticket.delete_all()

customer1 = Customer.new({ 'name' => 'James Johnson', 'funds' => 100.00})
customer1.save()
customer2 = Customer.new({ 'name' => 'Gabrielle Munro', 'funds' => 200.00})
customer2.save()
customer3 = Customer.new({ 'name' => 'Ali Baba', 'funds' => 1000.00})
customer3.save()
customer4 = Customer.new({ 'name' => 'Snake Pliskin', 'funds' => 50.00})
customer4.save()

film1 = Film.new({'title' => 'Human Centipede', 'price' => '6.00'})
film1.save()
film2 = Film.new({'title' => 'Spirited Away', 'price' => '5.00'})
film2.save()
film3 = Film.new({'title' => 'Ghost In The Shell', 'price' => '6.00'})
film3.save()

tickets1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
tickets1.save()
tickets2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id})
tickets2.save()
tickets3 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film2.id})
tickets3.save()
tickets4 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film3.id})
tickets4.save()






binding.pry()
nil
