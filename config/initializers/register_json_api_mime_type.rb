mime_types = %w(application/vnd.api+json text/x-json application/json)

Mime::Type.unregister :json
Mime::Type.register 'application/vnd.api+json', :json, mime_types
