module ActsAsTagged
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def related_by_tags(options = {})
      options.reverse_merge!(
        :limit => 5,
        :on => "tags"
      )
      
      self.class.find_tagged_with(self.tags,
        :select     => "DISTINCT #{self.class.table_name}.*, COUNT(taggable_id) as intersection",
        :conditions => ["#{self.class.table_name}.id != ? AND #{self.class.table_name}.state = 'publicated'", self.id],
        :group      => "taggable_id",
        :order      => "intersection DESC, #{self.class.table_name}.publicated_at DESC",
        :on         => options[:on],
        :limit      => options[:limit]
      )
    end
  end
end