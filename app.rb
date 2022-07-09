require_relative 'lib/database_connection'
require_relative 'lib/user_account_repository'
require_relative 'lib/post_repository'


# We need to give the database name to the method `connect`.
DatabaseConnection.connect('social_network')

# Perform a SQL query on the database and get the result set.

user_accounts = UserAccountRepository.new.all
posts = PostRepository.new.all


user_accounts.map do |user_account|
  puts "#{user_account.username}: #{user_account.email}"
end

posts.map do |post|
  puts "From user No #{post.user_account_id}: #{post.title}.
  #{post.content}.
  Seen #{post.views} times."
end 