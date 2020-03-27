require_relative('./models/customer')
require_relative('./models/film')
#require_relative('./models/ticket')


class Cinema
  attr_accessor :name, :films

  def initialize(options)
    @name = (options)['name']
    @films = options['films']
    #@till = options['till']
  end

  def add_film(film_name)
    
  end


end
