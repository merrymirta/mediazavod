module ActsAsFilterable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def paginate_filtered(options = {})
      options = options.dup
      options.symbolize_keys!
      options.delete_if {|key, value| (key != :page) && value.blank? }

      state = options.delete(:state)
      
      finder_options = self.find_where_options do |f|
        f.state           === state                     if state
        f.base_tags.name  === options.delete(:tag)      if options[:tag]
        f.author_id       === options.delete(:author)   if options[:author]
        
        if options[:section] and section = Section.find_by_alias(options.delete(:section))
          f.section_id === section.full_set_ids
        end

        date = (state == "publicated" ? f.publicated_at : f.created_at)
        
        begin
          day = Time.parse(options.delete(:date))

          date <=> (day.beginning_of_day .. day.end_of_day)
        rescue
        ensure
          date.order! :desc
        end
      end

      self.paginate(:all, finder_options.merge(options))
    end
    
    def active_days_filtered(options = {})
      options = options.dup

      options.symbolize_keys!
      options.delete_if {|key, value| (key != :page) && value.blank? }

      cache_key = "active_days_#{self.to_s}_#{options.except(:date, :page).to_s.hash}"

      unless data = Rails.configuration.idfix.session.cache.get(cache_key)
        logger.debug("Fetching active days for #{self} by #{options.inspect}")

        state = options.delete(:state)
        date = nil

        finder_options = self.find_where_options do |f|
          f.state           === state                     if state
          f.base_tags.name  === options.delete(:tag)      if options[:tag]
          f.author_id       === options.delete(:author)   if options[:author]

          if options[:section] and section = Section.find_by_alias(options.delete(:section))
            f.section_id === section.full_set_ids
          end

          date = (state == "publicated" ? f.publicated_at : f.created_at)

          date.order! :desc
        end

        data = self.find(:all,
          finder_options.merge(
            :select => "#{self.table_name}.#{date.name}",
            :group => "#{self.table_name}.#{date.name}"
          )
        ).collect{|object| object[date.name].to_date}

        data.uniq!
        data = data[0..364] # Оставляем только последний год

        Rails.configuration.idfix.session.cache.set(cache_key, data, 1.hour)
      end

      return data
    end
  end
end
