require_relative 'config/loader'

use(ViteRuby::DevServerProxy, ssl_verify_none: true) if ViteRuby.run_proxy?

run App
