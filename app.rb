require('bundler/setup')
require('pry')
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file}

brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ("7ad2c83100277e6fe89592046aae718c")
end


get('/') do
  erb(:index)
end


post('/beers') do
  @name = params.fetch('beer_name').strip.gsub(/ /,'+')
  redirect('/beers/'.concat(@name))
end

get("/beers/:name") do
  @all_beers = []
  @name = params.fetch('name').gsub('+',' ')
  @all_beers.push(brewery_db.beers.all(name: @name).first)
  # @name = @beer.first[:name_display]
  # @description = @beer.first[:description]
  # @abv = @beer.first[:abv]
  # @ibu = @beer.first[:ibu]
  # @style = @beer.first[:style][:short_name]
  @style_id = @all_beers[0][:style][:id]
  @style_info = brewery_db.styles.find(@style_id)
  @style_description = @style_info[:description]
  brewery_db.beers.all(styleId: @style_id).each_with_index do |item, index|
    @all_beers.push(item)
    break if index == 3
  end
# binding.pry
  @srm_min = @all_beers[0][:style][:srm_min]
  @srm_max = @all_beers[0][:style][:srm_max]
  @srm_avg = (@srm_min.to_i + @srm_max.to_i)/2
  @glass = @all_beers[0][:glass]
  erb(:beer)
end

post('/beers') do
  @name = params.fetch('beer_name').strip.gsub(/ /,'+')
  redirect('/beers/'.concat(@name))
end

get('/breweries') do
  @brewery = brewery_db.breweries.find('bdjbTZ')
  @breweries = brewery_db.breweries.all(established: 2006)
  erb(:breweries)
end

get '/queries' do
  erb :queries
end

post '/result' do
# binding.pry
  case params[:query]
    when "brewery_db.beers.all(abv: '5.5')"
      @result = brewery_db.beers.all(abv: '5.5')
    when "brewery_db.beers.find('vYlBZQ')"
      @result = brewery_db.beers.find('vYlBZQ')
    when "brewery_db.beers.random"
      @result = brewery_db.beers.random
    when "brewery_db.breweries.all(established: 2006)"
      @result = brewery_db.breweries.all(established: 2006)
    when "brewery_db.breweries.find('d1zSa7')"
      @result = brewery_db.breweries.find('d1zSa7')
    when "brewery_db.brewery('d1zSa7').beers"
      @result = brewery_db.brewery('d1zSa7').beers
    when "brewery_db.categories.all"
      @result = brewery_db.categories.all
    when "brewery_db.categories.find(1)"
      @result = brewery_db.categories.find(1)
    when "brewery_db.fermentables.all(country: 'Brazil')"
      @result = brewery_db.fermentables.all(country: 'Brazil')
    when "brewery_db.fermentables.find(1924)"
      @result = brewery_db.fermentables.find(1924)
    when "brewery_db.fluid_size.all"
      @result = brewery_db.fluid_size.all
    when "brewery_db.fluid_size.find(1)"
      @result = brewery_db.fluid_size.find(1)
    when "brewery_db.glassware.all"
      @result = brewery_db.glassware.all
    when "brewery_db.glassware.find(1)"
      @result = brewery_db.glassware.find(1)
    when "brewery_db.hops.all"
      @result = brewery_db.hops.all
    when "brewery_db.hops.find(1)"
      @result = brewery_db.hops.find(1)
    when "brewery_db.search.all(q: 'IPA')"
      @result = brewery_db.search.all(q: 'IPA')
    when "brewery_db.search.beers(q: 'IPA')"
      @result = brewery_db.search.beers(q: 'IPA')
    when "brewery_db.search.breweries(q: 'IPA')"
      @result = brewery_db.search.breweries(q: 'IPA')
    when "brewery_db.search.guilds(q: 'IPA')"
      @result = brewery_db.search.guilds(q: 'IPA')
    when "brewery_db.search.events(q: 'IPA')"
      @result = brewery_db.search.events(q: 'IPA')
    when "brewery_db.search.upc(code: '030613000043')"
      @result = brewery_db.search.upc(code: '030613000043')
    when "brewery_db.styles.all"
      @result = brewery_db.styles.all
    when "brewery_db.styles.find(1)"
      @result = brewery_db.styles.find(1)
    when "brewery_db.locations.all(locality: 'San Francisco')"
      @result = brewery_db.locations.all(locality: 'San Francisco')
    when "brewery_db.yeasts.all"
      @result = brewery_db.yeasts.all
    when "brewery_db.yeasts.find(1836)"
      @result = brewery_db.yeasts.find(1836)
    when "brewery_db.menu.beer_availability"
      @result = brewery_db.menu.beer_availability
  end
  @result= @result.first
binding.pry
  erb :result
end
