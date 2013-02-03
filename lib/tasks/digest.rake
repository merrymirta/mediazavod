namespace :app do
  desc "Send digest newsletter"
  task :digest => :environment do
    @articles = Article.publicated.find(:all, 
      :conditions => ["publicated_at > ? AND publicate_in_general_digest = ?", Time.now - 24.hours, true]
    )
    @shorties = Shorty.publicated.find(:all, 
      :conditions => ["publicated_at > ? AND publicate_in_general_digest = ?", Time.now - 24.hours, true]
    )

    if @articles.any? or @shorties.any?
      Idfix::Resources::SubscriptionMessage.create(
        :list     => "#{Rails.configuration.idfix.service}_digest",
        :subject  => "Дайджест материалов",
        :text     => (
          @shorties.collect{|s|
            [
              s.first_sentence,
              Rails.configuration.idfix.services[:publishing][:domain] + "/shorties/#{s.id}"
            ].join("\n")
          } +
          @articles.collect{|a|
            [
              a.excerpt,
              Rails.configuration.idfix.services[:publishing][:domain] + "/articles/#{a.id}"
            ].join("\n")
          }
        ).join("\n\n")
      )
    end
  end
end