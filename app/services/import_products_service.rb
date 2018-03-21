class ImportProductsService

  attr_accessor :import_product_task, :first_row_index, :last_row_index

  def initialize import_product_task_id, _first_row_index, _last_row_index
    @import_product_task = Spree::ImportProductsTask.find(import_product_task_id)
    @first_row_index = _first_row_index
    @last_row_index = _last_row_index
    @default_shipping_category = Spree::ShippingCategory.find_by(name: "Default")
  end

  def run
    (@first_row_index..@last_row_index).each do |index|
      _csv_row_as_hash = csv_rows[index].to_hash.compact if csv_rows[index].present?
      import_a_csv_row (_csv_row_as_hash.to_hash.compact) if !_csv_row_as_hash.blank?
    end
  end


  private


  def import_a_csv_row _csv_row_as_hash
    product = save_product(_csv_row_as_hash)
    save_product_associations(product, _csv_row_as_hash) if product.persisted?
  end

  def save_product_associations product, _csv_row_as_hash
    product.taxons.find_or_create_by(name: _csv_row_as_hash[:category])
    associate_with_option_types product, _csv_row_as_hash
    associate_with_variant product, _csv_row_as_hash
  end


  def associate_with_option_types product, _csv_row_as_hash
    _csv_row_as_hash[:option_types].split("|").each do |option_type_name|
      option_type = Spree::OptionType.find_or_initialize_by(name: option_type_name)
      option_type.update!(presentation: option_type_name) if !option_type.presentation
      product.option_types << option_type if !product.option_types.include?(option_type)
    end
  end

  def associate_with_variant product, _csv_row_as_hash
    variant = product.variants.find_or_initialize_by(sku: _csv_row_as_hash[:sku])
    ## option_type_and_values_hash = {"color"=>"blue", "size"=>"L"}
    option_type_and_values_hash = _csv_row_as_hash[:variant].split("|").collect{|s| s.split(":")}.to_h
    option_type_and_values_hash.each do |option_type_name, option_value_name|
      option_type = product.option_types.find_by(name: option_type_name)
      option_value = Spree::OptionValue.find_or_initialize_by(name: option_value_name, option_type: option_type)
      option_value.update(presentation: option_value_name) if !option_value.presentation
      variant.option_values << option_value if !variant.option_values.include?(option_value)
    end
    variant.save
  end

  def save_product _csv_row_as_hash
    # name, slug
    #category, stock_total
    product = Spree::Product.find_or_initialize_by(slug: _csv_row_as_hash[:slug])
    product.update!(build_product_attributes(_csv_row_as_hash))
    product
  end

  def build_product_attributes _csv_row_as_hash
    product_attributes = get_only_product_table_fields _csv_row_as_hash
    product_attributes[:shipping_category] = Spree::ShippingCategory.find_or_create_by(name: _csv_row_as_hash[:shipping_category]) || @default_shipping_category
    product_attributes
  end


  def get_only_product_table_fields _csv_row_as_hash
    _csv_row_as_hash.select{|key| [:name, :description, :available_on, :price].include?(key) }
  end

  def csv_rows
    CSV.read(@import_product_task.import_file.file.path, { col_sep: ';', headers: true, header_converters: :symbol })
  end


end