require_relative('../db/sql_runner')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  def save()
    sql = "INSERT INTO films
          (
            title,
            price
          )
          VALUES
          (
            $1, $2
          )
          RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end

  def update()
    sql = "UPDATE films SET
           (
             title,
             name
            ) =
            (
              $1, $2
            )
            WHERE id = $3"
    values = [@title, @name, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * from films"
    films = SqlRunner.run(sql)
    result = films.map {|film| Film.new(film)}
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets
    ON customers.id = tickets.customer_id
    WHERE film_id = $1;"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return nil if customers.first() == nil
    return customers.map {|customer| Customer.new(customer)}
  end

  def self.find(film_title)
    sql = "SELECT * FROM films WHERE title = $1"
    values = [film_title]
    films_result = SqlRunner.run(sql, values).first
    p films_result
    return nil if films_result == nil
    return Film.new(films_result)
  end

  def customer_count()
    sql = "SELECT COUNT(*) FROM tickets WHERE film_id = $1"
    values = [@id]
    customers_result = SqlRunner.run(sql, values).first
    return customers_result['count']
  end

end
