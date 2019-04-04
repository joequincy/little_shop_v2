class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || Hash.new(0)
  end

  def add_item(item_id)
    if @contents.keys.include?(item_id)
      @contents[item_id] +=1
    else
      @contents[item_id] = 1
    end
  end

  def total_count
    @contents.values.sum
  end
end