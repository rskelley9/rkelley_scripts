require 'combine_pdf'
require 'libreconv'
require 'optparse'

soffice_path = "/Applications/LibreOffice.app/Contents/MacOS/soffice"

args = {}

OptionParser.new do | arg |

  arg.on( '--source_directory SOURCE_DIRECTORY' ) { | a | args[ :source_directory ] = a }
  arg.on( '--save_directory SAVE_DIRECTORY' ) { | a | args[ :save_directory ] = a }
  arg.on( '--source_file_extension SOURCE_FILE_EXTENSION' ) { | a | args[ :source_file_extension ] = a }

end.parse!

## Default files taken from current working directory
args[ :source_directory ] ||= Dir.pwd

## Default, files saved to desktop
args[ :save_directory ] ||= ENV[ 'HOME' ] + '/Desktop/'

args[ :source_file_extension ] ||= ".pdf"

args[ :source_file_extension ] = args[ :source_file_extension ][ 0 ].eql?( "." ) ? args[ :source_file_extension ] : ( "." + args[ :source_file_extension ] )

if ( args[ :source_file_extension ] =~ /pdf/ix ).nil? ## if starting files not pdf

	## abort if odt and Windows
	if ( /cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM ) && args[ :source_file_extension ] =~ /odt/ix
		abort( "ABORTED! Can only convert odt files if using Mac OS X" )
	end

	if File.exists?( soffice_path )

		Dir[ "#{ args[ :source_directory ] }/*#{ args[ :source_file_extension ] }" ].each do | f |
			puts "converting #{ File.basename( f ) } to pdf document for merge."

			Libreconv.
				convert(
					f,
					"#{ args[ :save_directory ] }#{ File.basename( f ) }",
					soffice_path
					)
		end
	else
		abort( "ABORTED! #{ soffice_path } was not found." )
	end
end

args[ :source_directory ] = File.join( args[ :source_directory ], "" )
args[ :save_directory ] = File.join( args[ :save_directory ] , "" )

[ args[ :source_directory ], args[ :save_directory ] ].each do | path_string |
	unless File.directory?( path_string )
		abort( "ABORTED! #{ path_string } does not exist!" )
	end
end

pdf = CombinePDF.new()

Dir[ "#{ args[ :source_directory ] }*.pdf" ].each do | doc |
	pdf << CombinePDF.load( "#{ doc }" )
end

args[ :save_directory ] = "#{ args[ :save_directory ] }#{ Time.now.strftime( '%Y-%m-%d_%H%M%S' ) }.pdf"

pdf.save args[ :save_directory ]

puts "pdf saved to #{ args[ :save_directory ] }!"

