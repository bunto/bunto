require 'helper'

class TestPathSanitization < BuntoUnitTest
  context "on Windows with absolute source" do
    setup do
      @source = "C:/Users/xmr/Desktop/mpc-hc.org"
      @dest   = "./_site/"
      allow(Dir).to receive(:pwd).and_return("C:/Users/xmr/Desktop/mpc-hc.org")
    end
    should "strip drive name from path" do
      assert_equal "C:/Users/xmr/Desktop/mpc-hc.org/_site", Bunto.sanitized_path(@source, @dest)
    end

    should "strip just the initial drive name" do
      assert_equal "/tmp/foobar/jail/..c:/..c:/..c:/etc/passwd", Bunto.sanitized_path("/tmp/foobar/jail", "..c:/..c:/..c:/etc/passwd")
    end
  end
end
