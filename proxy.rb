
require_relative  'lib/sigfree_proxy.rb'
sipro = SigFree::SiProxy.new('0.0.0.0',9060,'127.0.0.1',4567)
sipro.sig_start