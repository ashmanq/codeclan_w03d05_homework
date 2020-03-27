require_relative('../db/sql_runner')

class Customer

  attr_accessor :name
  attr_reader :id, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
    sql = "INSERT INTO customers
          (
            name,
            funds
          )
          VALUES
          (
            $1, $2
          )
          RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET
           (
             name,
             funds
            ) =
            (
              $1, $2
            )
            WHERE id = $3"
    values = [@name, @funds, @id]
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

  def buy_ticket(film_name)

    film_result = Film.find(film_name)

    if film_result != nil
      price = film_result.price.to_i
      if can_afford?(price) # check if customer can afford it
        # take money from customer
        reduce_funds(price)
        self.update()
        # add customer to tickets table
        ticket = Ticket.new({'customer_id' => @id, 'film_id' => film_result.id})
        ticket.save()
      end
    else
      p "Film not found!"
    end
  end

  def tickets()
    sql = "SELECT COUNT(*) FROM tickets WHERE customer_id = $1"
    values = [@id]
    no_of_tickets = SqlRunner.run(sql, values).first
    return no_of_tickets['count']
  end
end
