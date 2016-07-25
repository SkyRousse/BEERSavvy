require('bundler/setup')
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file}

brewery_db = BreweryDB::Client.new do |config|
  config.api_key = ("37f05932e468ea014afabb1d166a6f99")
end


get('/') do
  erb(:index)
end

get("/beers/:id") do
  @beer = brewery_db.beers.find(params.fetch('id'))
  @name = @beer[:name]
  @description = @beer[:description]
  @abv = @beer[:abv]
  @ibu = @beer[:ibu]
  @style = @beer[:style]
  @srm = @beer[:srm]
  @glass = @beer[:glass]
  erb(:beer)
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



get('/store/:id') do
  @store = Store.find(params.fetch('id').to_i())
  @brands = @store.brands()
  erb(:store)
end

patch('/store/:id') do
  @store = Store.find(params.fetch('id').to_i())
  name = params.fetch('new_name')
  if @store.update(:name => name)
    redirect('/store/'.concat(@store.id().to_s()))
  else
    erb(:store_errors)
  end
end

post('/store/:id/brands') do
  store_id = params.fetch('id').to_i()
  @store = Store.find(store_id)
  name = params.fetch('brand_name')
  @brand = @store.brands.new({:name => name})
  @store.brands.push(@brand)
  redirect('/store/'.concat(@store.id().to_s()))
  erb(:stores)
end

delete('/store/:id') do
  store_id = params.fetch('id').to_i()
  @store = Store.find(store_id)
  @store.destroy()
  redirect('/stores')
end

delete('/store/:id/remove_brand') do
  store = Store.find(params.fetch("id").to_i)
  brand_id = params.fetch("brand_id").to_i
  store.brands.destroy(Brand.find(brand_id))
  redirect('/store/'.concat(store.id.to_s))
end

get('/brands') do
  @brands = Brand.all()
  erb(:brands)
end

post('/brands') do
  name = params.fetch('brand_name')
  @brand = Brand.new(:name => name)
  if @brand.save()
    redirect('/brands')
  else
    erb(:brand_errors)
  end
end

get('/brand/:id') do
  @brand = Brand.find(params.fetch('id').to_i())
  erb(:brand)
end

patch('/brand/:id') do
  brand_id = params.fetch('id').to_i()
  @brand = Brand.find(brand_id)
  name = params.fetch('new_name')
  if @brand.update(:name => name)
    redirect('/brand/'.concat(@brand.id().to_s()))
  else
    erb(:brand_errors)
  end
end

delete('/brand/:id') do
  brand_id = params.fetch('id').to_i()
  @brand = Brand.find(brand_id)
  @brand.destroy()
  redirect('/brands')
end
