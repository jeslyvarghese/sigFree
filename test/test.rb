require 'open-uri'

test_rounds = 10
test_count = 0

o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;  


while test_count<=test_rounds do
	string  =  (0..50).map{ o[rand(o.length)]  }.join;
	url = "http://localhost:9060/#{string}"
	test_count+=1
	puts "Test: \##{test_count}"
	puts "GET String: #{string}"
	begin
		open(url){ |f|	
		}
	rescue EOFError
		sleep 10
		next
	end
end