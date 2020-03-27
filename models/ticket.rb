require_relative('../db/sql_runner')


class Ticket
  attr_accessor :customer_id, :film_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id']
    @film_id = options['film_id']
    @screening_id = options['screening_id']
  end

  def save()
    sql = "INSERT INTO tickets
          (
            customer_id,
            film_id,
            screening_id
          )
          VALUES
          (
            $1, $2, $3
          )
          RETURNING id"
    values = [@customer_id, @film_id, @screening_id]
    ticket = SqlRunner.run(sql, values).first
    @id = ticket['id'].to_i
  end

  def update()
    sql = "UPDATE tickets SET
           (
             customer_id,
             film_id,
             screening_id
            ) =
            (
              $1, $2, $3
            )
            WHERE id = $4"
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * from tickets"
    tickets = SqlRunner.run(sql)
    result = tickets.map {|film| Ticket.new(tickets)}
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

end
