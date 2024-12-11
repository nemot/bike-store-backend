class ServiceObject < Dry::Struct
  include Dry::Monads[:result]
  attr_reader :errors

  def initialize(*args)
    @errors = []
    super(*args)
  end

  def self.call(**params)
    new(**params).call
  end
end
