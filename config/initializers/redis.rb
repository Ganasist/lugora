uri = URI.parse(ENV['REDISTOGO_URL'])
local = URI.parse('redis://localhost:6379/')

if Rails.env.staging? || Rails.env.production?
	REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
else	
	REDIS = Redis.new(host: local.host, port: local.port, password: local.password)
end