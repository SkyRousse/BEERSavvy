require('bundler/setup')
require('pry')
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file}
enable :sessions

brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ("37f05932e468ea014afabb1d166a6f99")
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

  no_apos_name = params[:name].strip.gsub "'", ""
  @name = no_apos_name.strip.gsub(/ /,'+')

binding.pry

  # @name = params['name'].gsub('+', ' ')
  @all_beers.push(brewery_db.beers.all(name: @name, withBreweries: 'Y').first)


puts @all_beers.first.nil?
puts !([:breweries, :description, :name_display, :style].all? {|key| @all_beers.first.has_key? key})
puts !([:id, :srm_min, :srm_max, :short_name, :description].all? {|key| @all_beers.first[:style].has_key? key})
puts @all_beers.first

binding.pry

  if @all_beers.first.nil? ||
    !([:breweries, :description, :name_display, :style ].all? {|key| @all_beers.first.has_key? key}) ||
    !([:id, :srm_min, :srm_max, :short_name, :description].all? {|key| @all_beers.first[:style].has_key? key})

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
  count = 0
  until count == 3
    returned = brewery_db.beers.random

puts "count: #{count.to_s}"
puts "top - returned[:name] - #{returned[:name]}"

    if ((returned[:name] =~ /[^ -~] /).nil?)
      no_apos_name = returned[:name].strip.gsub "'", ""
      @name = no_apos_name.strip.gsub(/ /,'+')

puts "returned[:name] - " + returned[:name]
puts ((returned[:name] =~ /[^ -~] /).nil?)

      break
    end
    count += 1
  end

puts "after if - @name: #{@name}"

  if !(@name.nil?)
    redirect("/beers/#{@name}")
  else
    redirect '/'
  end
end
