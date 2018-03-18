FactoryBot.define do
  factory :spree_import_products_task, class: 'Spree::ImportProductsTask' do
    import_file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files','import_files', 'sample.csv')) }
  end
end
