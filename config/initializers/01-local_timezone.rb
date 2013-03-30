if Rails.application.config.time_zone.nil?

  # code from rake task time:zones:local
  jan_offset = Time.now.beginning_of_year.utc_offset
  jul_offset = Time.now.beginning_of_year.change(:month => 7).utc_offset
  offset = jan_offset < jul_offset ? jan_offset : jul_offset

  offset = if offset.to_s.match(/(\+|-)?(\d+):(\d+)/)
             sign = $1 == '-' ? -1 : 1
             hours, minutes = $2.to_f, $3.to_f
             ((hours * 3600) + (minutes.to_f * 60)) * sign
           elsif offset.to_f.abs <= 13
             offset.to_f * 3600
           else
             offset.to_f
           end

  ActiveSupport::TimeZone.all.each do |zone|
    if offset.nil? || offset == zone.utc_offset
      # get one, use that timezone
      Rails.application.config.time_zone = zone.name
      break
    end
  end

end
