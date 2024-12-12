class Rule < ApplicationRecord
  validate :conditions_validator, :effects_validator

  @@subjects = {}

  def self.subjects
    class_variable_get(:@@subjects)
  end

  def self.add_subject(klass)
    transformed_subjects = klass.rule_subjects.transform_values do |subj_type|
      [ case subj_type.to_s
        when "ActsAsTaggableOn::Tag"
          %w[include exclude]
        when "ActiveModel::Type::Float", "ActiveModel::Type::Integer", "ActiveModel::Type::Decimal"
          %w[equals >= > < <=]
        when "ActiveModel::Type::String"
          %w[= starts_with ends_with include]
        when "ActiveModel::Type::Boolean"
          %w[is_true is_false]
        else
          %w[is]
        end, subj_type ]
    end
    @@subjects.merge!(transformed_subjects)
  end

  def applicable_for?(instance_or_class)
    klass = instance_or_class.is_a?(Class) ? instance_or_class : instance_or_class.class
    klass.respond_to?(:rule_subjects) && conditions.keys.all? { klass.rule_subjects.key?(_1) }
  end

  private

  def conditions_validator
    conditions.each do |subject, operation|
      next(errors.add(:conditions, "'#{subject}' is not valid subject")) if !@@subjects.key?(subject)

      func, _ = *operation
      next(errors.add(:conditions, "'#{func}' is not a valid function allowed")) if @@subjects.dig(subject, 0).exclude?(func)
    end
  end


  def effects_validator
  end
end
