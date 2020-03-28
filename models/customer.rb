require_relative('../db/sql_runner')
require_relative('./screening')

class Customer

  attr_accessor :name
  attr_reader :id, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @cinema_id = options['cinema_id']
    @funds = options['funds']
  end

  def save()
    sql = "INSERT INTO customers
          (
            name,
            cinema_id,
            funds
          )
          VALUES
          (
            LOWER($1), $2, $3
          )
          RETURNING id"
    values = [@name, @cinema_id, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET
           (
             name,
             cinema_id,
             funds
            ) =
            (
              LOWER($1), $2, $3
            )
            WHERE id = $4"
    values = [@name, @cinema_id, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * from customers"
    customers = SqlRunner.run(sql)
    result = customers.map {|film| Film.new(film)}
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def delete_by_id(id)
    sql = "DELETE FROM customers WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films
           INNER JOIN tickets
           ON films.id = tickets.film_id
           WHERE tickets.customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return nil if films.first() == nil
    return films.map {|film| Film.new(film)}
  end

  def reduce_funds(amount)
    @funds -= amount
  end

  def can_afford?(amount)
    if @funds >= amount
      return true
    else
      return false
    end
  end

  # Method will purchase a film ticket using a screening id
  def buy_ticket(screening)
    # Gets film information using screening id

    film = Screening.find_film(screening.id)

    return 'Can\'t find screening!' if film ==  nil
    return 'Screening full!'        if !screening.is_available?

    price = film.price.to_i

    return 'Can\'t afford ticket!'  if !can_afford?(price)

    reduce_funds(price)
    self.update()
    ticket = Ticket.new({'customer_id' => @id,
                         'film_id' => film.id,
                         'screening_id' => screening.id})
    ticket.save()
    return 'ticket successfully purchased!'
  end

  def tickets()
    sql = "SELECT COUNT(*) FROM tickets WHERE customer_id = $1"
    values = [@id]
    no_of_tickets = SqlRunner.run(sql, values).first
    return no_of_tickets['count']
  end

  def self.find_by_name(name, cinema_id)
    sql = "SELECT * FROM customers
           WHERE name = LOWER($1)
           AND cinema_id = $2"
    values = [name, cinema_id]
    customer_result = SqlRunner.run(sql, values)
    p customer_result.map {|customer| Customer.new(customer)}.first
    return nil if customer_result.first() == nil
    return customer_result.map {|customer| Customer.new(customer)}.first
  end
end
