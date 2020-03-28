require_relative('../db/sql_runner')
require_relative('./screening')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @cinema_id = options['cinema_id']
    @title = options['title']
    @price = options['price']
  end

  def save()
    sql = "INSERT INTO films
          (
            title,
            price,
            cinema_id
          )
          VALUES
          (
            LOWER($1), $2, $3
          )
          RETURNING id"
    values = [@title, @price, @cinema_id]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end

  def update()
    sql = "UPDATE films SET
           (
             title,
             price,
             cinema_id
            ) =
            (
              LOWER($1), $2, $3
            )
            WHERE id = $4"
    values = [@title, @price, @cinema_id, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * from films ORDER BY title"
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

  # Finds a film in the films table by searching for the id
  def self.find_by_id(film_id)
    sql = "SELECT * FROM films WHERE id= $1"
    values = [film_id]
    film_result = SqlRunner.run(sql, values)
    return nil if film_result.first() == nil
    return film_result.map {|film| Film.new(film)}
  end

  def self.find_by_title(title)
    sql = "SELECT * FROM films WHERE title = LOWER($1)"
    values = [title]
    film_result = SqlRunner.run(sql, values)
    return nil if film_result.first() == nil
    return film_result.map {|film| Film.new(film)}
  end


  def customer_count_by_film()
    sql = "SELECT COUNT(*) FROM tickets WHERE film_id = $1"
    values = [@id]
    customers_result = SqlRunner.run(sql, values).first
    return customers_result['count']
  end

  def screenings()
    sql = "SELECT screenings.* FROM screenings
           INNER JOIN films
           ON films.id = screenings.film_id
           WHERE films.id = $1"
    values = [@id]
    screenings_results = SqlRunner.run(sql, values)
    return screenings_results.map {|screening| Screening.new(screening)}
  end

  def most_popular_screening()
    # find all screenings of film
    film_screenings = screenings()
    # get count of tickets for each screening
    most_popular_screening = film_screenings.max_by {|screening| screening.ticket_count()}
    # find maximum of all ticket counts
    return nil if most_popular_screening == 0
    return most_popular_screening.screen_time
  end

end
