module Categories
  class IndexResponse < ResponseObject
    def call
      categories.reduce([]) do |tree, tag|
        append_to_tree(tree, tag.name.split(Category::DELIMETER), tag)
        tree
      end
    end

    private

    def categories
      relation || Category.all
    end

    def append_to_tree(children, path, category)
      return nil if path.empty?
      name = path[0]
      cat = children.find { _1[:name] == name } || children.push({ id: nil, name:, tag: nil, children: [] }).last
      cat.merge!({ id: category.id, tag: category.name }) if path.one?

      append_to_tree(cat[:children], path[1..], category)
    end
  end
end
