FROM ruby:3.1

WORKDIR /usr/src/app

ENV LANG=C.UTF-8 \
  LC_ALL=C.UTF-8

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . .

RUN wget https://github.com/THCLab/oca-parser-xls/releases/latest/download/parser.bin
RUN chmod +x ./parser.bin

EXPOSE 9292
