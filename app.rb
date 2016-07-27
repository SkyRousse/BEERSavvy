require('bundler/setup')
require('pry')
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file}
enable :sessions

brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ("fef981024ebb8b79b69f3ef9827b166b")
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
    @all_beers.push(item)
  end

  # need to find correct values for individual beers
  @srm_min = @all_beers[0][:style][:srm_min]
  @srm_max = @all_beers[0][:style][:srm_max]
  @srm_avg = (@srm_min.to_i + @srm_max.to_i)/2

  erb(:brewery)
end
