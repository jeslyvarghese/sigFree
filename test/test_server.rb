require 'sinatra'

ip = /.*/

get "/#{ip}"  do
	puts ip
	"SigFree Says:#{ip}"
end