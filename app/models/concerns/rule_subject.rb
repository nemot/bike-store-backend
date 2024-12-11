module RuleSubject
  extend ActiveSupport::Concern

  included do
    # def rule_representation
    #   self.class::RULE_FIELDS.to_h { [ _1, public_send(_1) ] }
    # end
  end

  class_methods do
    def rule_subjects
      class_variable_get(:@@rule_subjects)
    end

    def ruleable_as(name, fields)
      rule_subjects = { name => self }
      class_variable_set(:@@rule_subjects, rule_subjects)
      fields.each do |field|
        reflection_klass = reflections[field]&.class_name&.constantize
        next(rule_subjects["#{name}.#{field}"] = Product.type_for_attribute(field).class) if reflection_klass.nil?
        next(rule_subjects["#{name}.#{field}"] = reflection_klass) if !reflection_klass.respond_to?(:rule_subjects)

        reflection_klass.rule_subjects.each do |subject_name, subject_klass|
          sub_name = [ "#{name}.#{field}", subject_name.split(".")[1..].join(".") ].reject(&:empty?).compact.join(".")
          rule_subjects[sub_name] = subject_klass
        end
      end

      Rule.add_subject(self)
    end
  end
end
