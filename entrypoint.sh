#!/bin/bash

set -e

# 檢查是否存在 Gemfile.lock，若不存在則執行 bundle install
if [ ! -f Gemfile.lock ]; then
  echo "Gemfile.lock not found. Running bundle install..."
  bundle install
fi

# 檢查資料庫是否存在
if ! rails db:exists > /dev/null 2>&1; then
  echo "Database does not exist. Creating database..."
  bin/rails db:create
else
  echo "Database already exists."
fi

# 移除可能存在的 server.pid 檔案
rm -f tmp/pids/server.pid

# 啟動 Rails 伺服器
exec "$@"