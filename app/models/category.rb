class Category < ActsAsTaggableOn::Tag
  default_scope -> { for_context(:categories) }
  DELIMETER = " -> "


  def nested?
    name.include?(DELIMETER)
  end

  def path
    name.split(DELIMETER)
  end
end
