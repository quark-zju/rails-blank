require 'fileutils'

working_directory Dir.pwd

['pids', 'sockets'].each { |a| FileUtils.mkdir_p "./tmp/#{a}" }

pid "tmp/pids/unicorn.pid"
stderr_path "log/unicorn-error.log"
stdout_path "log/unicorn.log"

preload_app true

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end

socket_path = "#{Dir.pwd}/tmp/sockets/unicorn.socket"

FileUtils.rm_f socket_path

listen socket_path, backlog: 8
worker_processes 12
timeout 16
