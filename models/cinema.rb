require_relative('./screen')
require_relative('./film')
require_relative('./customer')


class Cinema
  attr_accessor :name
  attr_reader :till, :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @till = options['till']
  end

  def save()
    sql = "INSERT INTO cinemas
           (
             name,
             till
            )
            VALUES
            (
              LOWER($1), $2
            )
            RETURNING id"
    values = [@name, @till]
    cinema = SqlRunner.run(sql, values).first
    @id = cinema['id'].to_i
  end

  def update()
    sql = "UPDATE cinemas SET
           (
             name,
             till
            )
            =
            (
              LOWER($1), $2
            )
            WHERE id = $3"
    values = [@name, @till, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * from cinemas"
    cinemas = SqlRunner.run(sql)
    result = cinemas.map {|cinema| Cinema.new(cinema)}
    return result
  end

  def delete()
    sql = "DELETE FROM cinemas WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_by_id(id)
    sql = "DELETE FROM cinemas WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM cinemas"
    SqlRunner.run(sql)
  end

  def add_screen(name)
    screen = Screen.new({'name' => name, 'cinema_id' => @id})
    screen.save()
  end

  def remove_screen(name)
    screen = Screen.find(name)
    if screen!= nil
      screen.delete()
    end
  end

  def all_screens()
    sql = "SELECT * from screens WHERE cinema_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map {|screen| Screen.new(screen)}
  end

  def add_film(title, price)
    film = Film.new({'cinema_id' => @id, 'title' => title, 'price' => price})
    film.save()
  end

  def remove_film(title)
    film = Film.find_by_title(title)
    if film!= nil
      film.delete()
    end
  end

  def all_films()
    sql = "SELECT * from films WHERE cinema_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map {|film| Film.new(film)}
  end

  def add_customer(name, funds)

  end

  def remove_customer(name, funds)

  end


end
