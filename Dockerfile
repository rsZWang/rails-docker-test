# Dockerfile
FROM heroku/heroku:22

# 安裝必要套件
RUN apt-get update -y && apt-get install -y \
    build-essential libpq-dev curl gpg

# 匯入 GPG 公鑰並安裝 RVM 和 Ruby
RUN gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys \
    409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || \
    (curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
     curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -)
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby=3.3.0

# 設定 Ruby 和 bundler 的 PATH
ENV PATH /usr/local/rvm/rubies/ruby-3.3.0/bin:$PATH
ENV BUNDLE_PATH /usr/local/bundle

# 安裝 bundler
RUN gem install bundler

# 設定工作目錄
WORKDIR /usr/src/app/rails-app

# 複製專案檔案
COPY rails-app ./

# 複製 entrypoint.sh
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["bin/rails", "s", "-b", "0.0.0.0"]