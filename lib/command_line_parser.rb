module S3Link
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
end
