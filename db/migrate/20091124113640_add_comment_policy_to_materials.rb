class AddCommentPolicyToMaterials < ActiveRecord::Migration
  def self.up
    add_column :materials, :comment_policy, :string, :default => "post"
  end

  def self.down
    remove_column :materials, :comment_policy
  end
end
