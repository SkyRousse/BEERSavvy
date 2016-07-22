require('bundler/setup')
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file}


get('/') do
  erb(:index)
end

get('/stores') do
  @stores = Store.all()
  erb(:stores)
end

post('/stores') do
  name = params.fetch('store_name')
  @store = Store.new(:name => name)
  if @store.save()
    redirect('/stores')
  else
    erb(:store_errors)
  end
end

get('/store/:id') do
  @store = Store.find(params.fetch('id').to_i())
  erb(:store)
end

patch('/store/:id') do
  store_id = params.fetch('id').to_i()
  @store = Store.find(store_id)
  name = params.fetch('new_name')
  if @store.update(:name => name)
    redirect('/store/'.concat(@store.id().to_s()))
  else
    erb(:store_errors)
  end
end

delete('/store/:id') do
  store_id = params.fetch('id').to_i()
  @store = Store.find(store_id)
  @store.destroy()
  redirect('/stores')
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
