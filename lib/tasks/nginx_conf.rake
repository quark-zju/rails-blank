namespace :conf do
  desc 'Generate partial nginx.conf. It should be used together with thin.'
  task :nginx, [:domain, :limit] do |t, args|
    root = File.expand_path('../../..', __FILE__)

    domain, path = (args[:domain] || ENV['DOMAIN'] || File.basename(root)).downcase.split(?/, 2)
    limit = nil

    (args[:limit] || ENV['LIMIT']).tap do |x|
      limit = x && (x.to_i <= 0 ? 2 : x.to_i)
    end

    identify = domain.gsub('.', '-')

    require 'yaml'
    thin_config = YAML.load_file("#{root}/config/thin.yml")
    socket_file = File.expand_path(thin_config['socket'], root)
    servers = (thin_config['servers'] || 2).to_i

    puts <<"!"
upstream #{identify}-cluster {
!

    thin_config['servers'].to_i.times do |i|
puts <<"!"
  server unix:#{socket_file.sub /[^.]*$/, "#{i}.\\0"};
!
    end

puts <<"!"
}
!

puts <<"!" if limit
limit_req_zone $binary_remote_addr zone=#{identify}-limit-zone:5m rate=#{limit}r/s;
!

puts <<"!"
server {
  server_name '#{domain}';
  charset utf-8;
  client_max_body_size 16m;
  autoindex off;

  root #{root}/public;
  error_page 500 502 503 504 /500.html;

  location /#{path} {
    gzip_proxied any;
    index index.html;
    try_files $uri @thin;
  }
  location ~ \.(js|ico|css|png|jpg|gif|bmp|svg)$ {
    add_header Cache-Control public;
    expires max;
    gzip_static on;
  }
  location @thin {
!
puts <<"!" if limit
    limit_req zone=#{identify} burst=#{limit * servers * 2};
!
puts <<"!"
    proxy_set_header CLIENT_IP $remote_addr;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    proxy_pass http://#{identify}-cluster;
  }
}
!
  end
end
