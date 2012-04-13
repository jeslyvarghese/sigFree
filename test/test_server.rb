require 'sinatra'

ip = /.*/

get "/*"  do
	"SigFree Says:#{params[:splat]}"
end

get '/deny' do
	"SigFree Says: Denied The Request"	
end