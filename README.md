Alright, I used all the available time, and here’s my solution:

The code is approximately 60% ready for the backend, 30% for the admin interface, and 0% for the client-facing interface.

This process was exciting: I encountered a non-trivial algorithmic challenge, refreshed my knowledge of React and NextJS (they’ve changed a lot since I last used them), and explored an interesting UI library, AntDesign, which I might adopt for my future projects.

Let me describe the solution, though it hasn’t fully crystallized into code yet and is more of a conceptual outline at this stage.



# Products

We have a store that sells bike parts, bicycles, and other sports goods.

Each product is represented by the Product model with attributes such as name, description, price, and stock_quantity. For simplicity, a product has a single image (has_one_attached :image).

A product can belong to multiple categories. Initially, I implemented categories as tags, but looking back, I would now replace them with standard models using Single Table Inheritance (STI).

Categories

Let’s talk about categories. Since categories are implemented as tags (using the acts-as-taggable-on gem), I decided to wrap them in a Category model, inheriting from ActsAsTaggableOn::Tag, which narrows the scope. Categories can also be nested, and to handle this, I devised a simple scheme by encoding the hierarchy in the category name (e.g., "Parent Category -> Child1 -> Child2"). This approach simplifies rule creation (discussed later) but introduces challenges in representing data for the frontend.

For instance, you can look at app/services/categories/index_response.rb, where a DFS algorithm is used to build a category tree for the frontend. This design choice also impacted the admin frontend, especially when searching for categories by ID (e.g., src/providers/CategoriesProvider.tsx -> findCategoryById).

# Orders

At the core of any commercial application is the LineItem model, which has attributes like source_id, source_type, holder_type, holder_id, quantity, and price. A LineItem can originate from any entity—in our case, a Product or a CustomBicycle—and it can belong to another entity, which in our case is an Order.

What about the shopping cart, you ask? The cart is simply an Order with a default status of "cart", along with fields like shipping_address, details, and user_id. As the order progresses, its status transitions through states like cart -> paid -> sent, which is managed by a state machine (in my case, aasm).

# Custom Bicycles

Now we have the basic functionality of an online store. Let’s move on to the more intricate part: the relationships and components of bicycles.

As we mentioned earlier, bicycles can be different. There are pre-assembled bicycles as products, and there are custom bicycles that users can build through the interface.

To represent these custom bicycles, I use the CustomBicycle model (CustomBicycle(user_id, name?)). This model has many line_items, which link it to products of specific categories (see app/models/custom_bicycle.rb). For example, there is a line_item for handlebars, another for wheels, and so on.

Once a custom bicycle is fully assembled, it generates a single line_item, which is then added to the cart. However, when rendering the cart in the interface, the user sees both the total cost of the assembled bicycle and the cost of its individual components.

# Rules

Now let’s talk about rules. To implement complex conditions, I created a Rule model (Rule(condition, effect)). It essentially consists of two parts: the conditions under which it is triggered and the effect it applies.

Both conditions and effect are stored in JSON format, for example:
{"bicycle.frame.product.name"=>["starts_with", "Somethign"], "bicycle.frame.product.category_list"=>["includes", "Bicycle Parts -> Frames -> Golden"] } and {"bicycle.wheels.price"=>["increase_by_percent", "20"], ... }

Each element of this JSON is a simple pattern of subject operation value.

The list of available subjects is defined by specifying ruleable_as "subject_name", %w[list of fields] in the relevant model.
For instance:
  • In the CustomBicycle model, it’s ruleable_as "bicycle", %w[id frame wheels chain fork pedals brakes optional_products services].
  • In the LineItem model, it’s ruleable_as "line_item", %w[price quantity product].

This approach gathers a list of possible subjects, supported operations, and the scopes of allowable values. The logic for generating this data is encapsulated in app/models/concerns/rule_subject.rb and is accessible via Rule.subjects.

Here’s an example of what it looks like:


{
"product"=>[["is"], Product(id: integer, name: string, price: float, created_at: datetime, updated_at: datetime, stock_quantity: integer, description: text, category_list: )],
 "product.name"=>[["=", "starts_with", "ends_with", "include"], ActiveModel::Type::String],
 "product.price"=>[["equals", ">=", ">", "<", "<="], ActiveModel::Type::Float],
 "product.categories"=>[["include", "exclude"], ActsAsTaggableOn::Tag(id: integer, name: string, created_at: datetime, updated_at: datetime, taggings_count: integer)],
 "line_item"=>[["is"], LineItem(id: integer, holder_type: string, holder_id: integer, quantity: integer, price: decimal, created_at: datetime, updated_at: datetime, source_id: integer, source_type: string)],
 "line_item.price"=>[["equals", ">=", ">", "<", "<="], ActiveModel::Type::Float],
 "line_item.quantity"=>[["is"], ActiveModel::Type::Value],
 "line_item.product"=>[["is"], Product(id: integer, name: string, price: float, created_at: datetime, updated_at: datetime, stock_quantity: integer, description: text, category_list: )],
 "line_item.product.name"=>[["=", "starts_with", "ends_with", "include"], ActiveModel::Type::String],
 "line_item.product.price"=>[["equals", ">=", ">", "<", "<="], ActiveModel::Type::Float],
 "line_item.product.categories"=>[["include", "exclude"], ActsAsTaggableOn::Tag(id: integer, name: string, created_at: datetime, updated_at: datetime, taggings_count: integer)],
 ...
 }


 This structure allows sending precise directives to the admin frontend, where they populate dropdown menus with available subjects, operations, and valid values.


 And finally, these rules are applied here in app/services/rules/applicator_service.rb.

The rules part turned out to be quite complex, and I hope I’ll be able to demonstrate it personally.