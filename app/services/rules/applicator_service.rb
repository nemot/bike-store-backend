module Rules
  class ApplicatorService < ServiceObject
    attribute :rule, Types.Instance(Rule)
    attribute :instance, Types::Any

    def call
      apply_effects! if ::Rules::ConditionsMatchingService.new(rule:, instance:).match?

      instance.save ? Success(instance) : Failure(instance.errors.full_messages)
    end

    private

    def apply_effects!
      rule.effects.each do |subject, (operation, value)|
        obj = subject.split(".")[1..].reduce(instance) { |obj, m| obj = obj.public_send(m);  obj }
        send(operator, obj, value)
      end
    end

    def reduce_by(obj, value)
      obj -= value.to_f.round(2)
    end

    def reduce_by_percent(obj, value)
      obj -= (obj.to_f/100)*value.to_f.round(2)
    end

    def increase_by(obj, value)
      obj += value.to_f.round(2)
    end

    def increase_by_percent(obj, value)
      obj += (obj.to_f/100)*value.to_f.round(2)
    end

    def set(obj, value)
      obj = value
    end
  end
end
