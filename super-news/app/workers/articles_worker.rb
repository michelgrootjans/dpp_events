class ArticlesWorker
  include Sneakers::Worker
  # This worker will connect to "dashboard.posts" queue
  # env is set to nil since by default the actual queue name would be
  # "dashboard.posts_development"
  from_queue "supernews.articles", env: nil

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  # which we can pass to RecentPosts service without
  # changes
  def work(raw_article)
    article = JSON.parse(raw_article)
    Article.create(title: article['title'], content: article['content'])
    ack! # we need to let queue know that message was received
  end
end