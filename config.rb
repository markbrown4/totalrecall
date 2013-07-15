
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

activate :directory_indexes
set :relative_links, true
activate :relative_assets

configure :build do
  # activate :minify_css
  # activate :minify_javascript
  # activate :asset_hash
end
