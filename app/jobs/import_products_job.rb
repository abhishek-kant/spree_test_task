class ImportProductsJob < ApplicationJob
  queue_as :default

  def perform(import_product_task_id, first_row_index, last_row_index)
    ImportProductsService.new(import_product_task_id, first_row_index, last_row_index).run
  end
end