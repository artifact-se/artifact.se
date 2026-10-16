#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

# Match the Bundler version recorded in Gemfile.lock.
bundler_version=$(awk '/^BUNDLED WITH$/ { getline; gsub(/^[[:space:]]+|[[:space:]]+$/, ""); print }' Gemfile.lock)
gem install bundler -v "$bundler_version" --no-document
bundle "_${bundler_version}_" install
npm ci

export JEKYLL_ENV=production
bundle "_${bundler_version}_" exec jekyll build
# Compile only the stylesheet used by the layout, directly into the deployment.
# Do not rewrite the checked-in CSS or publish Sass source maps.
./node_modules/.bin/sass --no-source-map assets/scss/custom.scss _site/assets/css/custom.css
