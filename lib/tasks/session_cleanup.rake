namespace :db do
  namespace :sessions do
    desc "Clean up expired Active Record sessions (updated before ENV['EXPIRE_AT'], defaults to 1 month ago)."
    task :expire => :environment do
      log "Cleaning up expired sessions..."
      time = ENV['EXPIRE_AT'] || 4.months.ago.to_s(:db)
      rows = ActiveRecord::SessionStore::Session.delete_all ["updated_at < ?", time]
      log "Expired sessions cleanup: #{rows} session row(s) deleted."
    end

    def log(msg)
      Rails.logger.info msg
      puts msg
    end
  end
end
