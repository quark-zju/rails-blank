# Be sure to restart your server when you modify this file.

# Cookie-based
# RailsApp::Application.config.session_store :cookie_store, key: 's'

# ActiveRecord-based
RailsApp::Application.config.session_store :active_record_store, :key => CONFIG[:session_store_key] || 's', expire_after: 2.years
