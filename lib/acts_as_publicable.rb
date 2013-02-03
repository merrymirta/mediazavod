# This module includes full publication logic, including states, state transitions,
# and scopes

module ActsAsPublicable
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end
  
  module ClassMethods
    def acts_as_publicable
      acts_as_state_machine :initial => :draft

      state :draft
      state :pending
      state :deleted
      state :publicated, :enter => :do_publicate

      event :send_to_test do
        transitions :from => [:publicated, :draft, :deleted], :to => :pending
      end

      event :publicate do
        transitions :from => [:draft, :pending, :deleted], :to => :publicated
      end

      event :mark_deleted do
        transitions :from => [:draft, :pending, :publicated], :to => :deleted
      end

      named_scope :pending,
        :conditions => ["#{table_name}.state = ?", "pending"]
      named_scope :publicated, 
        :conditions => ["#{table_name}.state = ?", "publicated"], 
        :order      => "#{table_name}.publicated_at DESC"

      named_scope :publicated_as_hot,
        :conditions => ["#{table_name}.state = ? AND #{table_name}.publicate_as_hot = ?", "publicated", true],
        :order      => "#{table_name}.publicated_at DESC"
      named_scope :publicated_at_homepage,
        :conditions => ["#{table_name}.state = ? AND #{table_name}.publicate_at_homepage = ?", "publicated", true],
        :order      => "#{table_name}.publicated_at DESC"

      # Search materials within section and all its subsections
      named_scope :publicated_at_section, Proc.new { |section|
        section = Section.find_by_alias(section) if section.is_a?(String)

        {
          :conditions => [
            %{
              #{table_name}.section_id IN (?) AND
              #{table_name}.state = ? AND
              #{table_name}.publicate_at_section = ?
            },
            section.nil? ? [-1] : section.full_set_ids,
            "publicated",
            true
          ],
          :order => "#{table_name}.publicated_at DESC"
        }
      }

      named_scope :publicated_before, Proc.new{|material|
        {
          :conditions => ["state = 'publicated' AND publicated_at < ?", material.publicated_at],
          :order => "publicated_at DESC"
        }
      }

      named_scope :publicated_after, Proc.new{|material|
        {
          :conditions => ["state = 'publicated' AND publicated_at > ?", material.publicated_at],
          :order => "publicated_at ASC"
        }
      }
    end
  end
  
  module InstanceMethods

    protected

    def do_publicate
      self.publicated_at ||= Time.now
    end
    
  end
end