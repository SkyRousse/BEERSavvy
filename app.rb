require('bundler/setup')
require('pry')
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file}
enable :sessions

brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ("7ad2c83100277e6fe89592046aae718c")
end

get('/') do
  erb(:beer)
end

post('/beers') do
  @name = params.fetch('beer_name').strip.gsub(/ /,'+')
  redirect('/beers/'.concat(@name))
end

get("/beers/:name") do
  @all_beers = []
  @name = params.fetch('name').gsub('+', ' ')
  @all_beers.push(brewery_db.beers.all(name: @name, withBreweries: 'Y').first)
  if @all_beers.first.nil?
    flash[:error] = 'No data returned. Try another search.'
    redirect('/')
  else
    @brewery = @all_beers[0][:breweries]
    @style_id = @all_beers[0][:style][:id]
    @style_info = brewery_db.styles.find(@style_id)
    @style_description = @style_info[:description]
    @related_beers = brewery_db.beers.all(styleId: @style_id, withBreweries: 'Y')
    @related_beers.each_with_index do |item, index|

    if [:breweries, :description, :name_display, :style, :ibu, :abv].all? {|key| item.has_key? key}
      if [:id, :srm_min, :srm_max, :short_name, :description].all? {|key| item[:style].has_key? key}
        @all_beers.push(item)
      end
    end

    break if @all_beers.size >= 5
    end
    @srm_min = @all_beers[0][:style][:srm_min]
    @srm_max = @all_beers[0][:style][:srm_max]
    @srm_avg = (@srm_min.to_i + @srm_max.to_i)/2
    erb(:beer)
  end
end

post('/beers') do
  @name = params.fetch('beer_name').strip.gsub(/ /,'+')
  redirect('/beers/'.concat(@name))
end

get('/breweries/:id') do
  @id = params.fetch('id')
  @all_beers = []
  @brewery = brewery_db.breweries.find(@id)
  @beers = brewery_db.brewery(@id).beers(withBreweries: 'Y')
  @beers.each_with_index do |item, index|
    if [:description, :name_display, :style, :ibu, :abv].all? {|key| item.has_key? key}
      if [:id, :srm_min, :srm_max, :short_name, :description].all? {|key| item[:style].has_key? key}
        @all_beers.push(item)
      end
    end
  end
# binding.pry
  # need to find correct values for individual beers
  @srm_min = @all_beers[0][:style][:srm_min]
  @srm_max = @all_beers[0][:style][:srm_max]
  @srm_avg = (@srm_min.to_i + @srm_max.to_i)/2

  erb(:brewery)
end

post('/random') do
  count = 1
  begin
    returned = brewery_db.beers.random
    # binding.pry
    puts "top - returned[:name] - #{returned[:name]}"
    if ((returned[:name] =~ /\W /).nil?)
      @name = returned[:name].strip.gsub(/ /,'+')
      # binding.pry
    end
    count += 1
    puts count.to_s
  end until count == 3

  if !@name.nil?
    puts "/beers/#{@name}"
    redirect("/beers/#{@name}")
  else
    puts "/" + "returned[:name] - #{returned[:name]}"
    redirect '/'
  end
  # binding.pry
  # @name = temp[:name]  count += 1
  # @name = brewery_db.beers.random[:name]
  # @name = return.strip
  # @name = params.fetch('beer_name').strip.gsub(/ /,'+')
  # redirect("/beers/#{@name}")
  # redirect ""
end
