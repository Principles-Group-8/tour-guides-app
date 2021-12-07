# README
Justin Carway, Joey Mathis, Garrett Crumb

## The Tour Guides Scheduling App - Group 8

This app will be responsible for scheduling tours for Vanderbilt.

We will be using the Ruby on Rails web framework with SQLite for 
development and PostgreSQL for production.

The app is available deployed to Heroku [here](https://tourguides-app.herokuapp.com/)

To run the development server:
1. Install the packages as listed in step 3.1 here (you might have to change to ruby version
2.7.4): https://guides.rubyonrails.org/getting_started.html
2. Run `$ bundle install`
3. Run `$ rails db:migrate`
4. Run `$ rails webpacker:install` (enter "Y" at all file overwrite prompts if they occur)
5. Run `$ rails server`
6. Open http://localhost:3000
7. Let us know if you have any problems/questions!

Code organization:
* All application logic can be found in the app folder
  * Controller logic is in app/controllers
  * Model logic (tours and users) is in app/models
  * Mailer logic is in app/mailers
  * All views can be found in app/views
* Test code is found in the test folder
  * We only wrote controller unit tests, so all test code can be found in test/controllers

To run tests:
* Ensure you have done steps 1-4 in the server setup instructions
* Run `$ rails db:migrate RAILS_ENV=test`
* Run `$ rake test` or `$ rails test`