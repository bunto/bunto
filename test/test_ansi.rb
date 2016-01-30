require "helper"

class TestAnsi < BuntoUnitTest
  context nil do
    setup do
      @subject = Bunto::Utils::Ansi
    end

    Bunto::Utils::Ansi::COLORS.each do |color, val|
      should "respond_to? #{color}" do
        assert @subject.respond_to?(color)
      end
    end

    should "be able to strip colors" do
      assert_equal @subject.strip(@subject.yellow(@subject.red("hello"))), "hello"
    end

    should "be able to detect colors" do
      assert @subject.has?(@subject.yellow("hello"))
    end
  end
end
