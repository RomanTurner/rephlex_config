require_relative 'config/loader'
require_relative 'app'

use(ViteRuby::DevServerProxy, ssl_verify_none: true) if ViteRuby.run_proxy?

run App
