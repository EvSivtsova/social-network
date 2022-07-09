require_relative './post'

class PostRepository
  def all
    sql = 'SELECT id, title, content, views, user_account_id FROM posts;'
    result_set = DatabaseConnection.exec_params(sql, [])
    posts = []
    result_set.each do |record|
      post = record_to_post(record)
      posts << post
    end
    return posts
  end

  def find(id)
    sql = 'SELECT id, title, content, views, user_account_id FROM posts WHERE id = $1;'
    params = [id]
    result_set = DatabaseConnection.exec_params(sql, params)
    return nil if result_set.to_a.length == 0
    record = result_set[0]
    post = record_to_post(record)
    return post
  end

  def create(post)
    sql = 'INSERT INTO posts (title, content, views, user_account_id) VALUES($1, $2, $3, $4);'
    params = [post.title, post.content, post.views, post.user_account_id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def update(post)
    sql = 'UPDATE posts SET title = $1, content = $2, views = $3, user_account_id = $4 WHERE id = $5;'
    params = [post.title, post.content, post.views, post.user_account_id, post.id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  private

  def record_to_post(record)
    post = Post.new
    post.id = record['id'].to_i
    post.title = record['title']
    post.content = record['content']
    post.views = record['views'].to_i
    post.user_account_id = record['user_account_id'].to_i
    return post
  end  
end
  