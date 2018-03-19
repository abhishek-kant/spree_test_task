require 'csv'
class Spree::ImportProductsTask < ApplicationRecord


  mount_uploader :import_file, ImportFileUploader

  validates_presence_of :import_file

  after_create :queue_import

  private

  def queue_import
    _csv = CSV.read(import_file.file.path, { :col_sep => ';', :headers => true })
    (0.._csv.length - 1).to_a.in_groups_of(50, false).each do |current_array|
      ImportProductsJob.perform_later id, current_array.first, current_array.last
    end
  end


end
