require_relative('../db/sql_runner')

class Screening
  attr_accessor :screen_time, :film_id, :max_tickets
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @screen_time = options['screen_time']
    @film_id = options['film_id']
    @max_tickets = options['max_tickets']
  end

  def save()
    sql = "INSERT INTO screenings
            (
              screen_time,
              film_id,
              max_tickets
              )
              VALUES
              (
                $1, $2, $3
              )
              RETURNING id"
      values = [@screen_time, @film_id, @max_tickets]
      screening = SqlRunner.run(sql, values).first
      @id = screening['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET
           (
             screen_time,
             film_id,
             max_tickets
           )
           =
          (
            $1, $2, $3
          )
          WHERE id = $4"

    values = [@screen_time, @film_id, @max_tickets, @id]
    SqlRunner.run(sql, values)
  end
  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def delete_by_id(id)
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def is_available?()
    sql = "SELECT COUNT(*) FROM tickets
           WHERE screening_id = $1"
    values = [@id]
    no_of_tickets_booked = SqlRunner.run(sql,values).first['count']
    p no_of_tickets_booked
    no_of_tickets_booked.to_i < @max_tickets ? true : false

  end

  def ticket_count()
    sql = "SELECT COUNT(*) FROM tickets WHERE screening_id = $1"
    values = [@id]
    customers_result = SqlRunner.run(sql, values).first
    return customers_result['count']
  end

  def self.find(screening_id)
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [screening_id]
    result = SqlRunner.run(sql, values)
    return nil if result.first() == nil
    return result.map {|screening| Screening.new(screening)}
  end

  def self.find_film(screening_id)
    sql = "SELECT films.* FROM films
           INNER JOIN screenings
           ON films.id = screenings.film_id
           WHERE screenings.id = $1"
    values = [screening_id]
    film_result = SqlRunner.run(sql, values)
    return nil if film_result.first() == nil
    return film_result.map {|film| Film.new(film)}.first
  end






end
