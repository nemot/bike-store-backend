module Categories
  class UpdateService < ServiceObject
    attribute :category_tag, Types.Instance(Category)
    attribute :new_name, Types::Strict::String

    def call
      update_sibling_tags! if category_tag.nested?
      category_tag.update(name: new_name)
      Success(category_tag)
    end

    private

    def update_sibling_tags!
      prefixes_to_update.each do |(new_prefix, old_prefix)|
        tags = ActsAsTaggableOn::Tag.for_context(:categories).where("name like ?", "#{old_prefix}%")
        tags.each do |tag|
          tag.name.gsub!(old_prefix, new_prefix)
          tag.save!
        end
      end
    end

    def prefixes_to_update
      [ new_name, category_tag.name ].map do |tag_name|
          tag_name.split(Category::DELIMETER)[..-2].each_with_object([]) do |n, memo|
            memo << [ memo.last, n ].compact.join(Category::DELIMETER)
          end
        end
        .reduce(&:zip)
        .reverse
    end
  end
end
