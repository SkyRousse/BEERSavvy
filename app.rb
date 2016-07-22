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
    erb(:error)
  end
end
