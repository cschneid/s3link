require File.dirname(__FILE__) + '/../lib/command_line_parser'

module S3Link
  describe CommandLineParser do
    subject { CommandLineParser }

    it "extracts --access-key and arg" do
      subject.new(["a"]).parse[:access_key].should be_nil
      subject.new(["--access-key", "lmnop"]).parse[:access_key].should == "lmnop"
    end

    it "extracts --secret-key and arg" do
      subject.new(["a"]).parse[:secret_key].should be_nil
      subject.new(["--secret-key", "xyz"]).parse[:secret_key].should == "xyz"
    end

    it "extracts --bucket and arg" do
      subject.new(["a"]).parse[:bucket].should be_nil
      subject.new(["--bucket", "abc"]).parse[:bucket].should == "abc"
    end

    it "extracts --expires-in and arg" do
      subject.new(["a"]).parse[:expires_in].should be_nil
      subject.new(["--expires-in", "10"]).parse[:expires_in].should == "10"
    end

    it "extracts --silent" do
      subject.new(["a"]).parse[:silent].should be_false
      subject.new(["--silent"]).parse[:silent].should be_true
    end

    it "extracts --never-expire" do
      subject.new(["a"]).parse[:never_expire].should be_false
      subject.new(["--never-expire"]).parse[:never_expire].should be_true
    end

    it "extracts the last arg as a filename" do
      subject.new(["a"]).parse[:filename].should == "a"
      subject.new(["a", "b", "c"]).parse[:filename].should == "c"
    end
  end
end
