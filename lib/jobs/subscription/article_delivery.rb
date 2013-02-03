class Jobs::Subscription::ArticleDelivery < Struct.new(:article_id, :url)
  def perform
    if @article = Article.find_by_id(article_id)
      Idfix::Resources::SubscriptionMessage.create(
        :list     => "#{Rails.configuration.idfix.service}_section_#{@article.section.alias}",
        :subject  => @article.name,
        :text     => [
          @article.excerpt,
          Rails.configuration.idfix.services[:publishing][:domain] + "/articles/#{@article.id}"
        ].join("\n\n")
      )
    end
  end
end