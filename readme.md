Getting started
> docker-compose up

content creation: http://localhost:3000
publishing: http://localhost:3001
supernews: http://localhost:4000
quicknews: http://localhost:4001
queue management: http://localhost:15672 guest/guest

experiment with resilience by switching services on or off:
> docker-compose [start|stop|restart] [service]
services available: see docker-compose.yml

WIP:

ToDo:
manual teasering on supernews
automatic teasering on quicknews
meganews - all news from all channels: http://localhost:4002
publish to meganews

Done:
rabbitmq automatic configuration
publish to quicknews
publish to supernews
create content


## Reminders to self:
### Create new rails project:
> docker-compose run web rails new . --force --database=postgresql

