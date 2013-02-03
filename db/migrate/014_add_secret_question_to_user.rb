class AddSecretQuestionToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :secret_question, :integer
    add_column :users, :secret_answer, :string
  end

  def self.down
    remove_column :users, :secret_question
    remove_column :users, :secret_answer
  end
end
