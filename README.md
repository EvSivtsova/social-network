# Social network
<div align="left">
  <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/EvSivtsova/bank_tech_test">
</div>
<div>
  <img src="https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white"/> 
  <img src="https://img.shields.io/badge/RSpec-blue?style=for-the-badge&logo=Rspec&logoColor=white" alt="Rspec"/>
  <img src="https://img.shields.io/badge/Test_coverage:_100-blue?style=for-the-badge&logo=Rspec&logoColor=white" alt="Rspec"/>
</div><br>

This is a Makers' exercise from week 3. In this exercise, I did the following:
* Set up a new project directory social_network.
* Created a new database social_network.
* Designed the two tables for the below user stories.
* Test-driven the Model and Repository classes for these two tables: implemented the four methods `all`, `find`, `create` and `delete` for each Repository class and added `update` as an extra challenge.


## User stories

As a social network user,<br>
So I can have my information registered,<br>
I'd like to have a user account with my email address.

As a social network user,<br>
So I can have my information registered,<br>
I'd like to have a user account with my username.

As a social network user,<br>
So I can write on my timeline,<br>
I'd like to create posts associated with my user account.

As a social network user,<br>
So I can write on my timeline,<br>
I'd like each of my posts to have a title and a content.

As a social network user,<br>
So I can know who reads my posts,<br>
I'd like each of my posts to have a number of views.

## TechBit

Technologies used: 
* Ruby(3.0.0)
* RVM
* Rspec(Testing)
* Simplecov(Test Coverage)

To install the project, clone the repository and run `bundle install` to install the dependencies within the folder:

```
git clone https://github.com/EvSivtsova/social-network.git
cd social-network
bundle install
```

To run the tests:

```
createdb social_network_test
psql -h 127.0.0.1 social_network_test < spec/seeds_social_network.sql
rspec
```

To seed the data and run the SQL queries in the app:
```
createdb social_network
psql -h 127.0.0.1 social_network < spec/seeds_social_network.sql
ruby app.rb
```

Test coverage: 100%
