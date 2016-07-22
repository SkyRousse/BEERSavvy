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
    erb(:errors)
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
    erb(:errors)
  end
end

delete('/store/:id') do
  store_id = params.fetch('id').to_i()
  @store = Store.find(store_id)
  @store.destroy()
  redirect('/stores')
end
