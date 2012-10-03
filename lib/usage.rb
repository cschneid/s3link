module S3Link
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
