require 'rubygems'
require 'aws/s3'

module S3Link
  class CmdLineArgsError < RuntimeError; end

  class CommandLineParser
    attr_accessor :args

    def initialize(args)
      @args = args
    end

    def parse
      options = {}

      Usage.new if @args.include?("--help") || @args.include?("--help") || @args.length == 0

      options[:silent] == ! @args.include?("--silent")    

      if @args.include?("--access-key")
        options[:access_key] = next_arg_after("--access-key")
      end

      if @args.include?("--secret-key")
        options[:access_key] = next_arg_after("--secret-key")
      end

      if @args.include?("--bucket")
        options[:bucket] = next_arg_after("--bucket")
      end

      if @args.include?("--expires-in")
        options[:expires_in] = next_arg_after("--expires-in")
      end

      if @args.include?("--never-expire")
        options[:never_expire] = true
      end

      # Last arg has to be filename
      options[:filename] = @args[-1]

      return options
    end

    def next_arg_after(key)
      index = @args.index(key)
      raise CmdLineArgsError if @args.length <= index
      @args[index + 1]
    end
  end

  class Main
    def initialize
      @options = {}
    end

    def run_from_cmd_line
      @options = begin
        S3Link::CommandLineParser.new($ARGV).parse
      rescue CmdLineArgsError
        Usage.new
      end

      puts "Establishing Connection" unless @options[:silent]
      establish_connection

      puts "Uploading File... please wait" unless @options[:silent]
      upload_file

      url = generate_url 
      print "URL: " unless @options[:silent]
      puts "#{url}"
    end

    def establish_connection
      @aws = AWS::S3::Base.establish_connection!(:access_key_id => access_key, :secret_access_key => secret_key)
    end

    def access_key
      @options[:access_key] || ENV["AMAZON_ACCESS_KEY_ID"] || false
    end

    def secret_key
      @options[:secret_key] || ENV["AMAZON_SECRET_ACCESS_KEY"] || false
    end

    def upload_file
      AWS::S3::S3Object.store(@options[:filename], File.open(@options[:filename]), bucket_name)
    end

    def bucket_name
      @options[:bucket] || ENV["S3LINK_BUCKET_NAME"]
    end

    def generate_url
      AWS::S3::S3Object.url_for(@options[:filename], bucket_name, expires_hash )
    end

    def expires_hash
      if @options[:never_expire]
        doomsday = Time.mktime(2038, 1, 18).to_i
        {:expires => doomsday}
      elsif @options[:expires_in]
        # Convert from hours to seconds
        {:expires_in => @options[:expires_in] * 60 * 60}
      else
        # 24 hours default
        {:expires_in => 24 * 60 * 60}
      end
    end

  end

  class Usage
    def initialize(msg=nil)
      puts msg if msg
      puts <<-EOF 
Uploads a file up to Amazon's S3 Service, and provides a time limited URL to access.  

Several options may be set via environment variables for ease of use.

Options:
  --access-key    <key>    [ENV: AMAZON_ACCESS_KEY_ID]     -- Amazon provided access key
  --secret-key    <key     [ENV: AMAZON_SECRET_ACCESS_KEY] -- Amazon provided secret key
  --bucket        <name>   [ENV: S3LINK_BUCKET_NAME]      -- Bucket to store the uploaded file
  --expires-in    <hours>  [default: 24]                   -- How long the URL is valid for.
  --never-expire                                           -- Never expire the URL. If both 
                                                              expires commands are set, 
                                                              --expires-in will win.
  --silent                                                 -- Quiet mode outputs ONLY the url

NOTE: This tool DOES NOT ever remove files from S3. Manually using the web
interface, or the s3cmd tool to clean out your bucket is advised.

WARNING: This tool will just silently overwrite a file that is already
present. This is good to replace files with new versions, but bad if it
destroys something.  Don't destroy anything please.

      EOF
      exit(1)
    end
  end
end

