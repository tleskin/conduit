Conduit.configure do |config|

  # Storage configuration values
  #
  config.storage_credentials  = {
    provider:          :aws,
    aws_access_key_id: 'foo',
    aws_access_secret: 'bar',
    bucket:            'baz'
  }

end