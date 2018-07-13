Rails.application.configure do
  swiftype_config = YAML.load_file(Rails.root.join('config', 'swiftype.yml'))

  config.x.swiftype.app_search_host_identifier = swiftype_config['app_search_host_identifier']
  config.x.swiftype.app_search_api_key = swiftype_config['app_search_api_key']
end
