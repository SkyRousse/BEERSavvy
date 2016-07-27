require('bundler/setup')
require('pry')
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file}

brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ("43506106cbd0ef9555703beb003e8141")
end


get('/') do
  erb(:index)
end


post('/beers') do
  @name = params.fetch('beer_name').strip.sub(/ /,'+')
  redirect('/beers/'.concat(@name))
end

get("/beers/:name") do
  @all_beers = []
  @name = params.fetch('name').sub('+',' ')
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
  @srm_min = @all_beers[0][:style][:srm_min]
  @srm_max = @all_beers[0][:style][:srm_max]
  @srm_avg = (@srm_min.to_i + @srm_max.to_i)/2
  @glass = @all_beers[0][:glass]
  erb(:beer)
end

post('/beers') do
  @name = params.fetch('beer_name').strip.sub(/ /,'+')
  redirect('/beers/'.concat(@name))
end

get('/breweries') do
  @brewery = brewery_db.breweries.find('bdjbTZ')
  @breweries = brewery_db.breweries.all(established: 2006)
  erb(:breweries)
end
