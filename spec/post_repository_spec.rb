require 'post_repository'

def reset_posts_table
  seed_sql = File.read('spec/seeds_social_network.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end
  
describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  it 'returns all Post objects in the database' do
    repo = PostRepository.new
    posts = repo.all
    expect(posts.length).to eq 11

    expect(posts[0].id).to eq 1
    expect(posts[0].title).to eq 'I think'
    expect(posts[0].content).to eq 'I think about lots of things'
    expect(posts[0].views).to eq 5
    expect(posts[0].user_account_id).to eq 1

    expect(posts[7].id).to eq 8
    expect(posts[7].title).to eq 'Nice weather'
    expect(posts[7].content).to eq 'It is sunny and lovely outside'
    expect(posts[7].views).to eq  1235
    expect(posts[7].user_account_id).to eq 5
  end

  it 'returns a single Post object by its index' do
    repo = PostRepository.new

    post = repo.find(8)

    expect(post.id).to eq 8
    expect(post.title).to eq 'Nice weather'
    expect(post.content).to eq 'It is sunny and lovely outside'
    expect(post.views).to eq 1235
    expect(post.user_account_id).to eq 5
  end

  it 'returns nil if the Post with given ID does not exist' do
    repo = PostRepository.new
    expect(repo.find(128)).to eq nil
  end

  it "create a new Post object" do
    repo = PostRepository.new
    post = Post.new
    post.title = 'NEW NEW Nice weather'
    post.content =  'NEW It is sunny and lovely outside'
    post.views =  1000
    post.user_account_id =  3
    expect(repo.create(post)).to eq nil
    expect(repo.all.length).to eq 12
    expect(repo.all).to include(
      have_attributes(title: 'NEW NEW Nice weather', 
        content: 'NEW It is sunny and lovely outside')
      )
  end

  it 'updates the attributes of a Post object' do
    repo = PostRepository.new
    post_to_update = repo.find(1)
    post_to_update.title = 'updated_title'
    post_to_update.content = 'updated_post'
    post_to_update.views = '333'
    post_to_update.user_account_id = '1'
    expect(repo.update(post_to_update)).to eq nil

    updated_post = repo.find(1)
    expect(updated_post.id).to eq 1
    expect(updated_post.title).to eq 'updated_title'
    expect(updated_post.content).to eq 'updated_post'
    expect(updated_post.views).to eq 333
    expect(updated_post.user_account_id).to eq 1
  end

  it 'deletes a Post object from the database' do
    repo = PostRepository.new
    expect(repo.delete(7)).to eq nil
    expect(repo.find(7)).to eq nil
    expect(repo.all.length).to eq 10
    expect {(repo.all).to include(
      have_attributes(title: 'Nice weather', username: 'It is sunny and lovely outside')
      )}
  end
end
