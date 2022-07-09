require_relative './user_account'

class UserAccountRepository
  def all
    sql = 'SELECT id, email, username FROM user_accounts;'
    result_set = DatabaseConnection.exec_params(sql, [])
    user_accounts = []
    result_set.each do |record|
      user_account = record_to_user_account(record)
      user_accounts << user_account
    end
    return user_accounts
  end

  def find(id)
    sql = 'SELECT id, email, username FROM user_accounts WHERE id = $1;'
    params = [id]
    result_set = DatabaseConnection.exec_params(sql, params)
    return nil if result_set.to_a.length == 0
    record = result_set[0]
    user_account = record_to_user_account(record)
    return user_account
  end
  
  def create(user_account)
    sql ='INSERT INTO user_accounts (email, username) VALUES($1, $2);'
    params = [user_account.email, user_account.username]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end
  
  def update(user_account)
    sql = 'UPDATE user_accounts SET email = $1, username = $2 WHERE id = $3;'
    params = [user_account.email, user_account.username, user_account.id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end
  
  def delete(id)
    sql = 'DELETE FROM user_accounts WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  private

  def record_to_user_account(record)
    user_account = UserAccount.new
    user_account.id = record['id'].to_i
    user_account.email = record['email']
    user_account.username = record['username'] 
    return user_account
  end  
end