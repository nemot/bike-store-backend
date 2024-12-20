class ResponseObject < Dry::Struct
  attribute? :relation, Types.Instance(ActiveRecord::Relation).optional

  def initialize(*args)
    @errors = []
    super(*args)
  end

  def self.call(**params)
    new(**params).call
  end
end
