Paperclip::Attachment.default_options[:s3_host_name] = 's3-eu-west-1.amazonaws.com'
Paperclip::Attachment.default_options[:access_key_id] = ENV['AWS_ACCESS_KEY_ID']
Paperclip::Attachment.default_options[:secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']