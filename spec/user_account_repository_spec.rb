require 'user_account_repository'

def reset_user_accounts_table
  seed_sql = File.read('spec/seeds_social_network.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end
  
describe UserAccountRepository do
  before(:each) do 
    reset_user_accounts_table
  end

  it "returns all of the UserAccount objects" do
    repo = UserAccountRepository.new
    user_accounts = repo.all

    expect(user_accounts.length).to eq 6

    expect(user_accounts[0].id).to eq 1
    expect(user_accounts[0].email).to eq 'anna@gmail.com'
    expect(user_accounts[0].username).to eq 'anna'

    expect(user_accounts[3].id).to eq 4
    expect(user_accounts[3].email).to eq 'alice@gmail.com' 
    expect(user_accounts[3].username).to eq 'alice'
  end

  it 'returns a single UserAccount object by its index' do
    repo = UserAccountRepository.new
    user_account = repo.find(2)
    
    expect(user_account.id).to eq 2
    expect(user_account.email).to eq 'shaun@gmail.com' 
    expect(user_account.username).to eq 'shaun'
  end

  it 'returns nil if the UserAccount with given ID does not exist' do
    repo = UserAccountRepository.new
    expect(repo.find(12)).to eq nil
  end

  it 'creates a UserAccount object' do
    repo = UserAccountRepository.new
    user_account = UserAccount.new
    user_account.email = 'new_account@gmail.com' 
    user_account.username = 'new_account'
    expect(repo.create(user_account)).to eq nil
    expect(repo.all.length).to eq 7
    expect(repo.all).to include( 
      have_attributes(email: 'new_account@gmail.com', 
        username: 'new_account')
      )
  end

  it 'updates the attributes of a UserAccount object' do
    repo = UserAccountRepository.new
    account_to_update = repo.find(1)
    account_to_update.email = 'updated_email'
    account_to_update.username = 'updated_username'
    expect(repo.update(account_to_update)).to eq nil
    updated_account = repo.find(1)
    expect(updated_account.id).to eq 1
    expect(updated_account.email).to eq 'updated_email'
    expect(updated_account.username).to eq 'updated_username'
  end

  it 'delete a UserAccount object from the database' do
    repo = UserAccountRepository.new
    expect(repo.delete(1)).to eq nil
    expect(repo.find(1)).to eq nil
    expect(repo.all.length).to eq 5
    expect {(repo.all).to include( 
      have_attributes(email: 'anna@gmail.com', username: 'anna'))}
  end
end
