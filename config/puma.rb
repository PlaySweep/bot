workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

on_worker_boot do
  $api = Api.new
  $fb_api = FacebookApi.new
  $aws = Fog::Storage.new({
    :provider                 => 'AWS',
    :aws_access_key_id        => ENV['AWSAccessKeyId'],
    :aws_secret_access_key    => ENV['AWSSecretKey']
  })
end

rackup      DefaultRackup
port        ENV['PORT']     || 5000
environment ENV['RACK_ENV'] || 'development'
