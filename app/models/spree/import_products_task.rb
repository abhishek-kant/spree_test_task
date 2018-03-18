class Spree::ImportProductsTask < ApplicationRecord


  mount_uploader :import_file, ImportFileUploader

  validates_presence_of :import_file

  after_create :queue_import


  private

  def queue_import

  end

  def find_row_count

  end

end
