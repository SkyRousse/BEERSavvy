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


get("/beers/:name") do
  @beer = brewery_db.beers.all(name: params.fetch('name'))
  @name = @beer.first[:name_display]
  @description = @beer.first[:description]
  @abv = @beer.first[:abv]
  @ibu = @beer.first[:ibu]
  @style = @beer.first[:style][:short_name]
  @style_id = @beer.first[:style][:id]
  @style_info = brewery_db.styles.find(@style_id)
  @style_description = @style_info[:description]
  @similar_beers = brewery_db.beers.all(styleId: @style_id)
  @srm_min = @beer.first[:style][:srm_min]
  @srm_max = @beer.first[:style][:srm_max]
  @glass = @beer.first[:glass]
  binding.pry
  erb(:beer)
end

post('/beers') do
  @name = params.fetch('beer_name')
  redirect('/beers/'.concat(@name))
end

get('/breweries') do
  @brewery = brewery_db.breweries.find('bdjbTZ')
  @breweries = brewery_db.breweries.all(established: 2006)
  erb(:breweries)
end
