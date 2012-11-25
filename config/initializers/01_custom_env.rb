custom_config_path = Rails.root.join('config', 'env.yml')

begin
  config = YAML.load_file(custom_config_path)

  setenv = ->(pair) { ENV[pair.first.to_s] = pair.second.to_s }

  ['default', Rails.env].each do |env|
    config[env].try { |e| e.map(&setenv) } 
  end

rescue
end
