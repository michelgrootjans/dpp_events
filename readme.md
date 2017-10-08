Getting started
> docker-compose up
content creation: http://localhost:3000
supernews: http://localhost:4000
quicknews: http://localhost:4001
queue management: http://localhost:15672 guest/guest

experiment with resilience by switching services on or off:
> docker-compose [start|stop|restart] [service]
services available: [db, queue, content-creation, super-news-web, super-news-worker]

WIP:

ToDo:
rabbitmq automatic configuration
publish to quicknews
manual teasering on supernews
automatic teasering on quicknews
meganews - all news from all channels: http://localhost:4002
publish to meganews

Done:
publish to supernews
create content
