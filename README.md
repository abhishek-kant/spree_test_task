# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation rake db:create 

* Database initialization:  rake db:migrate

* How to run the test suite: just run rspec

* Services (job queues, cache servers, search engines, etc.): Run start sidekiq

* Deployment instructions

* ...

To test import feature: 

1. Add an admin user and log in to the admin panel
2. Go to product list page (/admin/products) and click on the "import products" button. 
  - upload the Sample.csv from this repo.
