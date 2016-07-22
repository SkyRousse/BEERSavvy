# Shoe Distribution

##### This is the week 4 independent project for the Ruby class at Epicodus. This app is uses a many-to-many relationship between shoe stores and shoe brands using Active Record and a Postgres database.

#### By Sky Rousse

## Objectives

* A many-to-many relationship is successfully implemented.
* The project includes at least one functional validation.
* The project includes least one functional callback.
* Use of standard naming conventions for database tables and columns.
* Execution of CRUD functionality in class methods and routes.
* Use of RESTful routes
* Objects are created from a custom class with custom methods.
* Specs have complete coverage for the behaviors that need to be tested.
* Specs are passing.
* Logic is easy to understand.
* Code has proper indentation and spacing.
* Variable names are descriptive.
* Sinatra application uses views, instance variables and forms.

## Technologies Used

* Application: Ruby, Sinatra, Active Record
* Testing: Rspec, Capybara, Pry
* Database: Postgres

Installation
------------

```
$ git clone https://github.com/SkyRousse/shoe-distribution.git
```

Install required gems:
```
$ bundle install
```

Create databases:
```
rake db:create
rake db:schema:load
```

Start the webserver:
```
$ ruby app.rb
```

Navigate to `localhost:4567` in browser.

License
-------

GNU GPL v2. Copyright 2016 **Epicodus**
