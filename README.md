# web-odca-ruby

In order to build docker image from source:
```
docker build https://github.com/THCLab/web-odca-ruby.git -t thclab/web-odca-ruby
```
or if you have already repository fetched run within main directory

```
docker build .
```

To run latest build from official image:
```
docker run -d --name web-odca-ruby -p 9292:9292 -v $(pwd)/public:/usr/src/app/public thehumancolossuslab/web-odca-ruby:latest
```
