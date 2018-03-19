class ImportProductsJob < ApplicationJob
  queue_as :default

  def perform(import_product_task_id, first_row_index, last_row_index)
    # ImportProducts.new(import_product_task_id, first_row_index, last_row_index).run
    # Do something later
  end
end