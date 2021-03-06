# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )


Rails.application.config.assets.precompile += %w( get_all_users.js )
Rails.application.config.assets.precompile += %w( bundle.js )
Rails.application.config.assets.precompile += %w( validate_pref.js )
Rails.application.config.assets.precompile += %w( update_edit.js )
Rails.application.config.assets.precompile += %w( signoff_page.js )
Rails.application.config.assets.precompile += %w( jquery.scrollTableBody-1.0.0.js )
# Rails.application.config.assets.configure do |env|
#   env.unregister_postprocessor 'application/javascript', Sprockets::SafetyColons
# end