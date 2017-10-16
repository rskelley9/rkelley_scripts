require 'combine_pdf'
require 'libreconv'

soffice_path = "/Applications/LibreOffice.app/Contents/MacOS/soffice"

## Default files taken from current working directory
file_path = ARGV[ 0 ] || Dir.pwd

## Default, files saved to desktop
save_path = ARGV[ 1 ] || ENV[ 'HOME' ] + '/Desktop/'

file_type = ARGV[ 2 ] || ".pdf"

file_type = file_type[ 0 ].eql?( "." ) ? file_type : ( "." + file_type )

if ( file_type =~ /pdf/ix ).nil? ## if starting files not pdf

	## abort if odt and Windows
	if ( /cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM ) && file_type =~ /odt/ix
		abort( "ABORTED! Can only convert odt files if using Mac OS X" )
	end

	if File.exists?( soffice_path )

		Dir[ "#{ file_path }/*#{ file_type }" ].each do | f |
			puts "converting #{ File.basename( f ) } to pdf document for merge."

			Libreconv.
				convert(
					f,
					"#{ save_path }#{ File.basename( f ) }",
					soffice_path
					)
		end
	else
		abort( "ABORTED! #{ soffice_path } was not found." )
	end
end

file_path = File.join( file_path , "" )
save_path = File.join( save_path , "" )

[ file_path, save_path ].each do | path_string |
	unless File.directory?( path_string )
		abort( "ABORTED! #{ path_string } does not exist!" )
	end
end

pdf = CombinePDF.new()

Dir[ "#{ file_path }*.pdf" ].each do | doc |
	pdf << CombinePDF.load( "#{ doc }" )
end

save_path = "#{ save_path }#{ Time.now.strftime( '%Y-%m-%d_%H%M%S' ) }.pdf"

pdf.save save_path

puts "pdf saved to #{ save_path }!"

