# Be sure to restart your server when you modify this file.

# Cookie-based
# RailsApp::Application.config.session_store :cookie_store, key: 's'

# NON-DEFAULT ActiveRecord-based
RailsApp::Application.config.session_store :active_record_store, key: ENV['SESSION_STORE_KEY'] || 's', expire_after: 2.years
