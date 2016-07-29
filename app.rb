require('bundler/setup')
require('pry')
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file}
enable :sessions

brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ("d095dc59bcacf6877086a3fbdaf969db")
end

get('/') do
  erb(:beer)
end

post('/beers') do
  @name = params.fetch('beer_name')
  @beer = brewery_db.beers.all(name: @name, withBreweries: 'Y')
  if @beer.first.nil? ||
    !([:breweries, :description, :name_display, :style ].all? {|key| @beer.first.has_key? key}) ||
    !([:id, :srm_min, :srm_max, :short_name, :description].all? {|key| @beer.first[:style].has_key? key})

      flash[:error] = 'No data returned. Try another search.'
      redirect('/')
  else
    @id = @beer.first[:id]
    redirect("/beers/#{@id}")
  end
end

get("/beers/:id") do
  @all_beers = []
  @id = params.fetch('id')
  @all_beers.push(brewery_db.beers.find(@id, withBreweries: "Y"))
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
      @all_beers.push(item)
      break if @all_beers.size >= 5
    end
    @srm_min = @all_beers[0][:style][:srm_min]
    @srm_max = @all_beers[0][:style][:srm_max]
    @srm_avg = (@srm_min.to_i + @srm_max.to_i)/2
    erb(:beer)
  end
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

  # need to find correct values for individual beers
  begin
    @srm_min = @all_beers[0][:style][:srm_min]
    @srm_max = @all_beers[0][:style][:srm_max]
    @srm_avg = (@srm_min.to_i + @srm_max.to_i)/2
  rescue
    @srm_avg = 3/2
  end
  erb(:brewery)
end

post('/random') do
  @beer = brewery_db.beers.random(withBreweries: 'Y')
    @id = @beer[:id]
    redirect("/beers/#{@id}")
end
