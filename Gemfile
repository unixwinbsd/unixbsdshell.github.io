source "https://rubygems.org"

# To update to the latest github dependencies run: `bundle update`
# To list current versions: `bundle exec github-pages versions`
# Check github versions: https://pages.github.com/versions/
gem "jekyll", "~> 3.10.0"
gem "github-pages", "~> 232", group: :jekyll_plugins
gem "rake", "~> 12"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.17.0"
  gem 'jekyll-paginate'
  #gem "jekyll-seo-tag", "~> 2.8.0"
  gem 'jekyll-seo-tag', git: 'https://github.com/adamsdesk/jekyll-seo-tag.git', branch: 'fix-json-ld-alt'
  gem "jekyll-sitemap", "~> 1.4.0"
  gem "jekyll-compose", "~> 0.5"
  gem "jekyll-redirect-from", "~> 0.16.0"
  gem "jekyll-coffeescript"
  gem "jekyll-default-layout"
gem "jekyll-gist"
gem "jekyll-github-metadata"
gem "jekyll-optional-front-matter"
gem "jekyll-readme-index"
gem "jekyll-titles-from-headings"
gem "jekyll-relative-links"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?

gem "webrick", "~> 1.8"
#gem "github-pages", "~> 232"
#gem 'github-pages', group: :jekyll_plugins
