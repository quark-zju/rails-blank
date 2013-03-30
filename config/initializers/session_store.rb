# Cookie-based
# RailsApp::Application.config.session_store :cookie_store, key: 's'

# ActiveRecord-based
RailsApp::Application.config.session_store :active_record_store, :key => 's', expire_after: 2.years
