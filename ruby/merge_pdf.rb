require 'combine_pdf'

## Default files taken from current working directory
file_path = ARGV[ 0 ] || Dir.pwd

## Default, files saved to desktop
save_path = ARGV[ 1 ] || ENV['HOME'] + '/Desktop/'

file_path = File.join( file_path , "")
save_path = File.join( save_path , "")

[ file_path, save_path ].each do | path_string |
	unless File.directory?( path_string )
		puts "ERROR: #{ path_string } does not exist!"
		abort
	end
end

pdf = CombinePDF.new()

Dir[ "#{ file_path }*.pdf" ].each do | doc |
		pdf <<
			CombinePDF.
				load(
					"#{ doc }"
				)
end

save_path = "#{ save_path }#{ Time.now.strftime('%Y-%m-%d_%H%M%S') }.pdf"

pdf.save save_path

puts "pdf saved to #{ save_path }!"

