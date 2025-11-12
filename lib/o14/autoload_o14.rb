module O14
  autoload :Config, 'o14/config'
  autoload :ProjectLogger, 'o14/project_logger'
  autoload :WebBrowser, 'o14/web_browser'

  @config = O14::Config.get_config

  autoload :DB, 'o14/db'
  autoload :ExceptionHandler, 'o14/exception_handler'
end

