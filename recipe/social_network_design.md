# {{SOCIAL NETWORK}} Model and Repository Classes Design Recipe

# Two Tables Design Recipe Template

## 1. Extract nouns from the user stories or specification

```
# USER STORY:
As a social network user,
So I can have my information registered,
I'd like to have a user account with my email address.

As a social network user,
So I can have my information registered,
I'd like to have a user account with my username.

As a social network user,
So I can write on my timeline,
I'd like to create posts associated with my user account.

As a social network user,
So I can write on my timeline,
I'd like each of my posts to have a title and a content.

As a social network user,
So I can know who reads my posts,
I'd like each of my posts to have a number of views.
```

```
Nouns:

user account, email address, username, posts, posts' title, posts content, posts views
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties            |
| --------------------- | ----------------------|
| user_account          | email, username       |
| posts                 | title, content, views |

1. Name of the first table (always plural): `user_accounts` 

    Column names: `email`, `username`

2. Name of the second table (always plural): `posts` 

    Column names: `title`, `content`, `views`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
Table: user_accounts
id: SERIAL
email: text
username: text

Table: posts
id: SERIAL
title: text
content: text
views: int
```

## 4. Decide on The Tables Relationship

```

1. Can one user_account have many posts? YES
2. Can one post have many user_accounts? NO

-> Therefore,
-> A user_account HAS MANY posts
-> A post BELONGS TO a user_account

Post --> many to one --> user_account

-> Therefore, the foreign key is on the posts table (user_account_id).
```

## 4. Write the SQL.

```sql
-- file: seeds_social_network.sql

-- Create the table without the foreign key first.
CREATE TABLE "public"."user_accounts" (
    id SERIAL PRIMARY KEY,
    email text,
    username text
);

-- Then the table with the foreign key first.
CREATE TABLE "public"."posts" (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  views int,
-- The foreign key name is always {other_table_singular}_id
  user_account_id int,
  constraint fk_user_account foreign key(user_account_id) references user_accounts(id)
  ON DELETE CASCADE
);
-- the data and further details are in the seeds sql.
```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 social_network < seeds_social_network.sql
```

## 6email. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: user_accounts

# Model class
# (in lib/user_account.rb)
class UserAccount
end

# Repository class
# (in lib/user_account_repository.rb)
class UserAccountRepository
end

# Table name: posts

# Model class
# (in lib/posts.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby

# Table name: user_accounts

# Model class
# (in lib/user_account.rb)

class UserAccount
  attr_accessor :id, :email, :username
end

# Table name: posts

# Model class
# (in lib/post.rb)

class Post
  attr_accessor :id, :title, :content, :views, :user_account_id
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby

# Table name: user_accounts

# Repository class
# (in lib/user_account_repository.rb)

class UserAccountRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, email, username FROM user_accounts;
    # Returns an array of UserAccount objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, email, username FROM user_accounts WHERE id = $1;
    # Returns a single UserAccount object.
  end

  # creates a UserAccount
  def create(user_account)
    # Executes the SQL query:
    # INSERT INTO user_accounts (email, username) VALUES($1, $2);
    # Returns nil
  end

  # updates a UserAccount
  def update(user_account)
    # Executes the SQL query:
    # UPDATE user_accounts SET email = $1, username = $2 WHERE id = $3;
    # Returns nil
  end

  # deletes a UserAccount
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM user_accounts WHERE id = $1;
    # Returns nil
  end
end

# Table name: posts

# Repository class
# (in lib/post_repository.rb)
class PostRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, views, user_account_id FROM posts;
    # Returns an array of Post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, views, user_account_id FROM posts WHERE id = $1;
    # Returns a single Post object.
  end

  # creates a Post
  def create(post)
    # Executes the SQL query:
    # INSERT INTO posts (title, content, views, user_account_id) VALUES($1, $2, $3, $4);
    # Returns nil
  end

  # updates a Post
  def update(post)
    # Executes the SQL query:
    # UPDATE posts SET title = $1, content = $2, views = $3, user_account_id = $4 WHERE id = $5;
    # Returns nil
  end

  # deletes a Post
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM posts WHERE id = $1;
    # Returns nil
  end
end
```



## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# USER ACCOUNT REPOSITORY TESTS

# 1
# Get all user accounts

repo = UserAccountRepository.new

user_accounts = repo.all

user_accounts.length # =>  6

user_accounts[0].id # =>  1
user_accounts[0].email # =>  'anna@gmail.com'
user_accounts[0].username # =>  'anna'

user_accounts[3].id # =>  4
user_accounts[3].email # =>  'alice@gmail.com' 
user_accounts[3].username # =>  'alice'

# 2
# Get a single UserAccount object

repo = UserAccountRepository.new

user_account = repo.find(2)

user_account.id # =>  2
user_account.email # =>  'shaun@gmail.com' 
user_account.username # =>  'shaun'

# 3
# create a UserAccount object

repo = UserAccountRepository.new
user_account = UserAccount.new
user_account.email = 'new_account@gmail.com' 
user_account.username = 'new_account'
repo.create(user_account) # =>  nil
repo.all.length # =>  7
repo.all # =>  to include attributes email: 'new_account@gmail.com', username: 'new_account'

# 4
# Update UserAccount object's attributes

repo = UserAccountRepository.new
account_to_update = repo.find(1)
account_to_update.email = 'updated_email'
account_to_update.username = 'updated_username'
repo.update(account_to_update) # =>  nil
updated_account = repo.find(1)
updated_account.id # =>  1
updated_account.email # =>  'updated_email'
updated_account.username # =>  'updated_username'

# 5
# delete a UserAccount object

repo = UserAccountRepository.new
repo.delete(1) # =>  nil
repo.find(1) # =>  nil
repo.all.length # => 5
repo.all to include attributes email: 'anna@gmail.com', username: 'anna' # =>  to fail


# POST REPOSITORY TESTS

# 1
# Get all posts

repo = PostRepository.new

posts = repo.all

posts.length # =>  11

posts[0].id # =>  1
posts[0].title # =>  'I think'
posts[0].content # =>  'I think about lots of things'
posts[0].views # =>  5
posts[0].user_account_id # =>  1

posts[7].id # =>  8
posts[7].title # =>  'Nice weather'
posts[7].content # =>  'It is sunny and lovely outside'
posts[7].views # =>  1235
posts[7].user_account_id # =>  5

# 2
# Get a single post

repo = PostRepository.new

post = repo.find(8)

post.id # =>  8
post.title # =>  'Nice weather'
post.content # =>  'It is sunny and lovely outside'
post.views # =>  1235
post.user_account_id # =>  5

# 3
# create a Post object

repo = PostRepository.new
post = Post.new
post.title = 'NEW NEW Nice weather'
post.content =  'NEW It is sunny and lovely outside'
post.views =  1000
post.user_account_id =  3
repo.create(post) # =>  nil
repo.all.length # =>  12
repo.all # =>  to include attributes title: 'NEW NEW Nice weather'', content: 'NEW It is sunny and lovely outside'

# 4
# Update Post object's attributes

repo = PostRepository.new
post_to_update = repo.find(1)
post_to_update.title = 'updated_title'
post_to_update.content = 'updated_post'
post_to_update.views = '333'
post_to_update.user_account_id = '1'
repo.update(post_to_update) # =>  nil
updated_post = repo.find(1)
updated_post.id # =>  1
updated_post.title # => 'updated_title'
updated_post.content # => 'updated_post'
updated_post.views # => 333
updated_post.user_account_id # => 1

# 5
# delete a Post object

repo = PostRepository.new
repo.delete(7) # =>  nil
repo.find(7) # =>  nil
repo.all.length # => 10
repo.all to include attributes title: 'Nice weather', username: 'It is sunny and lovely outside' # =>  to fail


```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby

# file: spec/user_account_repository_spec.rb

def reset_user_accounts_table
  seed_sql = File.read('spec/seeds_social_network.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'user_accounts' })
  connection.exec(seed_sql)
end

describe UserAccountRepository do
  before(:each) do 
    reset_user_accounts_table
  end

  # (your tests will go here).
end

-----

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_social_network.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'posts' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

