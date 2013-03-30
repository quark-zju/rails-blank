# use timed FileStore
require 'fileutils'

class TimedFileStore < ActiveSupport::Cache::FileStore
  
  def exist?(name, options = {})
    delete_if_expired(name, options.try { |o| o[:time_to_live] })
    super
  end

  def read(name, options = {})
    delete_if_expired(name, options.try { |o| o[:time_to_live] })
    super
  end

  protected

  def delete_if_expired(name, time_to_live = 0)
    file_path = key_file_path(name)

    return if (time_to_live || 0) <= 0 or not File.exists?(file_path)
    if (Time.now - File.mtime(file_path)) >= time_to_live
      # delete
      delete(name)
      FileUtils.rm_f file_path
    end
  end

end


page_cache_path = Rails.root.join('tmp', 'cache', 'pages')
FileUtils.mkdir_p page_cache_path
ActionController::Base.cache_store = TimedFileStore.new(page_cache_path), { time_to_live: 12.hours }

Rails.application.config.action_controller.perform_caching = true

# Disable Rack::Cache
# Rack::Cache caches response headers when Cache-Control is public
# it's not useful and dangerous
require 'rack/cache'
Rails.application.config.middleware.delete Rack::Cache

