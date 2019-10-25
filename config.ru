$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require File.expand_path('../web', __FILE__)

run Web
