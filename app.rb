require('bundler/setup')
require('pry')
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file}

brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ("37f05932e468ea014afabb1d166a6f99")
end


get('/') do
  erb(:index)
end

# get("/beers/:id") do
  get("/beers/") do
  # @beer = brewery_db.beers.find(params.fetch('id'))
  @beer = brewery_db.beers.all(name: 'Aztec')
  @name = @beer.first[:name]
  # @description = @beer.first[:description]
  # @abv = @beer.first[:abv]
  # @ibu = @beer.first[:ibu]
  # @style = @beer.first[:style][:short_name]
  # @srm_min = @beer.first[:style][:srm_min]
  # @srm_max = @beer[:style][:srm_max]
  # @glass = @beer[:glass]
  erb(:beer)
  binding.pry
end

post('/beers') do
  @id = params.fetch('beer_id')
   redirect('/beers/'.concat(@id.to_s()))
end

get('/breweries') do
  @brewery = brewery_db.breweries.find('bdjbTZ')
  @breweries = brewery_db.breweries.all(established: 2006)
  erb(:breweries)
end
