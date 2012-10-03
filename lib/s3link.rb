require 'rubygems'
require 'aws/s3'

require 'usage'
require 'command_line_parser'

module S3Link
  class CmdLineArgsError < RuntimeError; end

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
end

