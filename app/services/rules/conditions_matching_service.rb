module Rules
  class ConditionsMatchingService < Dry::Struct
    attribute :rule, Types.Instance(Rule)
    attribute :instance, Types::Any

    def match?
      return false unless rule.valid?
      return false unless rule.applicable_for?(instance)

      rule.conditions.all? do |subject, (operator, value)|
        obj = subject.split(".")[1..].reduce(instance) { |obj, m| break "NOT_FOUND" if obj.nil?; obj = obj.public_send(m); obj }
        next if obj == "NOT_FOUND"

        public_send(operator, obj, value)
      end
    end

    def starts_with(obj, value)
      obj.to_s.downcase.starts_with?(value.downcase)
    end

    def ends_with(obj, value)
      obj.to_s.downcase.ends_with?(value.downcase)
    end

    def is(obj, value)
      obj.id == value.to_h.stringify_keys["id"].to_i
    end

    def include(obj, value)
      return obj.include?(value) unless obj.is_a?(ActiveRecord::Associations::CollectionProxy)
      return false if !value.is_a?(Hash) || value.stringify_keys.key?("id")

      obj.where(id: value.stringify_keys["id"]).any?
    end

    def exclude(obj, value)
      return obj.exclude?(value) unless obj.is_a?(ActiveRecord::Associations::CollectionProxy)
      return false if !value.is_a?(Hash) || value.stringify_keys.key?("id")

      obj.where(id: value.stringify_keys["id"]).none?
    end

    def equals(obj, value)
      obj.to_f.round(2) == value.to_f.round(2)
    end

    def >(obj, value)
      obj.to_f.round(2) > value.to_f.round(2)
    end

    def >=(obj, value)
      obj.to_f.round(2) >= value.to_f.round(2)
    end

    def <(obj, value)
      obj.to_f.round(2) < value.to_f.round(2)
    end

    def <=(obj, value)
      obj.to_f.round(2) <= value.to_f.round(2)
    end

    def is_true(obj, _)
      (!!obj).is_a?(TrueClass)
    end

    def is_false(obj, _)
      (!!obj).is_a?(FalseClass)
    end
  end
end
