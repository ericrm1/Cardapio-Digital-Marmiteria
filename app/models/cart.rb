class Cart
  Item = Struct.new(:id, :product_id, :quantity, :observation, :addon_ids, keyword_init: true)

  def initialize(session)
    @session = session
    @session["cart"] ||= { "items" => [] }
  end

  def items
    raw_items.map do |i|
      Item.new(
        id: i["id"],
        product_id: i["product_id"],
        quantity: i["quantity"],
        observation: i["observation"],
        addon_ids: i["addon_ids"] || []
      )
    end
  end

  def add(product_id:, quantity:, observation: nil, addon_ids: [])
    raw_items << {
      "id" => SecureRandom.uuid,
      "product_id" => product_id.to_s,
      "quantity" => quantity.to_i,
      "observation" => observation,
      "addon_ids" => Array(addon_ids).map(&:to_s)
    }
    persist
  end

  def update(item_id, quantity: nil, observation: nil, addon_ids: nil)
    item = raw_items.find { |i| i["id"] == item_id }
    return false unless item

    item["quantity"] = quantity.to_i if quantity
    item["observation"] = observation unless observation.nil?
    item["addon_ids"] = Array(addon_ids).map(&:to_s) if addon_ids
    persist
    true
  end

  def remove(item_id)
    raw_items.reject! { |i| i["id"] == item_id }
    persist
  end

  def empty?
    raw_items.empty?
  end

  def clear
    @session["cart"] = { "items" => [] }
  end

  private

  def raw_items
    @session["cart"]["items"]
  end

  def persist
    @session["cart"]["items"] = raw_items
  end
end
