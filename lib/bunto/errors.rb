module Bunto
  module Errors
    FatalException = Class.new(::RuntimeError)

    DropMutationException       = Class.new(FatalException)
    InvalidPermalinkError       = Class.new(FatalException)
    InvalidYAMLFrontMatterError = Class.new(FatalException)
    MissingDependencyException  = Class.new(FatalException)

    InvalidDateError = Class.new(FatalException)
    InvalidPostNameError = Class.new(FatalException)
    PostURLError = Class.new(FatalException)
  end
end