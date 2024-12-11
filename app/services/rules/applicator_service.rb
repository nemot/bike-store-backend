module Rules
  class ApplicatorService < ServiceObject
    attribute :rule, Types.Instance(Rule)
    attribute :instance, Types::Any

    def call
      validate_conditions!
      validate_effects!

      return Failure(self.errors) if self.errors.any?

      rule = Rule.new(conditions:, effects:)
      rule.save ? Success(rule) : Failure(rule.errors.full_messages)
    end

    private

    def validate_conditions!
      # conditions.each do |subject, operation|
      #   subject_kind, field = *subject.split('.')
      #   sibject_class
      #   self.errors.push("#{subject_kind} does not provide :#{field} field")
      #   func, arguments = *operation
      #   self.errors << "#{func} is not allowed on #{subject_kind}" if

      # end
    end
  end
end
