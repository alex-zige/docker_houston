worker_processes 2

preload_app true

timeout 30

listen 3000

working_directory "/app"

pid "/var/run/unicorn.pid"
stderr_path "/var/log/unicorn.log"
stdout_path "/var/log/unicorn.log"
