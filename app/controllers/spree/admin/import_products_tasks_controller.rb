class Spree::Admin::ImportProductsTasksController < Spree::Admin::ResourceController


  def new
    @import_product_task = Spree::ImportProductsTask.new
  end

  def create
    @import_product_task = Spree::ImportProductsTask.create(import_product_task_params)
  end

  private

  def import_product_task_params
    params.require(:import_products_task).permit(:import_file)
  end


end
