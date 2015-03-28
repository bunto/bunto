module Bunto
  module Errors
    class FatalException < RuntimeError
    end

    class MissingDependencyException < FatalException
    end
  end
end
