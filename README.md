S3Link
=======

Uploads a file up to Amazon's S3 Service, and provides a time limited URL to
access.

Several options may be set via environment variables for ease of use.

Options:
--------

  --access-key    \<key\>    [ENV: AMAZON\_ACCESS\_KEY\_ID]     -- Amazon provided access key

  --secret-key    \<key\>     [ENV: AMAZON\_SECRET\_ACCESS\_KEY] -- Amazon provided secret key

  --bucket        \<name\>   [ENV: S3Link\_BUCKET\_NAME]      -- Bucket to store the uploaded file

  --expires-in    \<hours\>  [default: 24]                   -- How long the URL is valid for.

  --never-expire                                           -- Never expire the URL. If both expires commands are set, --expires-in will win.

  --silent                                                 -- Quiet mode outputs ONLY the url

NOTE: This tool DOES NOT ever remove files from S3. Cleaning your S3 of old
files manually is advised. Use the web interface, or the s3cmd tool.

WARNING: This tool will just silently overwrite a file that is already
present. This is good to replace files with new versions, but bad if it
destroys something.  Don't destroy anything please.

