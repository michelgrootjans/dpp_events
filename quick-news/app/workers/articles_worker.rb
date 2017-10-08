class ArticlesWorker
  include Sneakers::Worker
  from_queue "quicknews.articles", env: nil

  def work(raw_event)
    event = JSON.parse(raw_event, object_class: OpenStruct)
    if(event.type == "ArticleWasMadeAvailable")
      article_data = event.payload.article
     if(article_data.tags.any?{|tag| tag.include?('quick')})
        Article.find_or_create_by(reference: article_data.reference) do |article|
          article.title = article_data.title
          article.content = article_data.content
        end
     end
    end
    if(event.type == "ArticleWasRecalled")
      payload = event.payload
      Article.connection.execute("DELETE FROM articles WHERE reference='#{payload.article_reference}'")
    end

    ack! # we need to let queue know that message was received
  end
end