# web-odca-ruby

In order to build docker image:
```
docker build https://github.com/THCLab/web-odca-ruby.git -t thclab/web-odca-ruby
```

To run server:
```
docker run -ti -p 9292:9292 -v $(pwd)/public:/usr/src/app/public thclab/web-odca-ruby:latest
```
