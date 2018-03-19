require 'rails_helper'

feature "import_products_task creation", js: true do
  stub_authorization!
  given(:valid_attributes) { attributes_for(:spree_import_products_task) }

  scenario "Creating import_products_task with valid fields" do
    visit spree.admin_products_path
    click_on("Import Products")
    wait_for_ajax

    find('#import_products_task_import_file').set(File.join(Rails.root, 'spec', 'support', 'files','import_files', 'sample.csv'))

    expect {  click_on("Upload CSV")
              wait_for_ajax
    }.to change { Spree::ImportProductsTask.count }.by(1)


  end

  scenario "Creating import_products_task with valid infields" do
    visit spree.admin_products_path
    click_on("Import Products")
    wait_for_ajax

    find('#import_products_task_import_file').set('')

    expect {  click_on("Upload CSV")
    wait_for_ajax
    }.to change { Spree::ImportProductsTask.count }.by(0)


  end

end