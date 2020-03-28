require_relative('./customer')
require_relative('./film')
require_relative('./screening')
require_relative('./ticket')


class Screen

attr_reader :name, :id, :max_seats

def initialize(options)
  @id = options['id'].to_i if options['id']
  @name = options['name']
  @cinema_id = options['cinema_id']
  @screenings = []
  @max_seats = options['max_seats']
end

def save()
  sql = "INSERT INTO screens
         (
           name,
           cinema_id
          )
          VALUES
          (
            LOWER($1), $2
          )
          RETURNING id"
  values = [@name, @cinema_id]
  cinema = SqlRunner.run(sql, values).first
  @id = cinema['id'].to_i
end

def update()
  sql = "UPDATE screens SET
         (
           name,
           cinema_id
          )
          =
          (
            LOWER($1), $2
          )
          WHERE id = $3"
  values = [@name, @cinema_id, @id]
  SqlRunner.run(sql, values)
end

def self.all()
  sql = "SELECT * from screens"
  screens = SqlRunner.run(sql)
  result = screens.map {|screen| Screen.new(screen)}
  return result
end

def self.delete_all()
  sql = "DELETE FROM screens"
  SqlRunner.run(sql)
end

def delete()
  sql = "DELETE FROM screens WHERE id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end

def self.delete_by_id(id)
  sql = "DELETE FROM screens WHERE id = $1"
  values = [id]
  SqlRunner.run(sql, values)
end

def self.find(name, cinema_id)
  sql = "SELECT * FROM screens
         WHERE name = LOWER($1)
         AND cinema_id = $2"
  values = [name, cinema_id]
  result = SqlRunner.run(sql, values)
  return nil if result.first() == nil
  return result.map {|screen| Screen.new(screen)}.first
end

def add_screening(film_name, time)
  film = Film.find_by_title(film_name)
  if film != nil
    screening = Screening.new('film_id' => film.id,
                              'screen_time' => time,
                              'cinema_id' => @id)
    screening.save()
    @screenings.push(screening)
  end
end



end
