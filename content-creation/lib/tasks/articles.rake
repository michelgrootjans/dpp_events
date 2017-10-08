namespace :articles do
  def generate_article
    article = Article.new
    article.title   = Faker::Lorem.sentence
    article.content = Faker::Lorem.paragraphs((1..10).to_a.sample).join('<br/>')
    article.tags    = ((['quick', 'super']) + Faker::Lorem.words((1..10).to_a.sample)).sample(3).join('; ')
    article.status  = :available
    article.reference = SecureRandom.urlsafe_base64
    article.save

    message = {type: "ArticleWasMadeAvailable", payload: {article: article.to_message}}
    Publisher.publish("articles", message)
  end

  task generate: :environment do
    1000.times do
      generate_article
    end
  end
end