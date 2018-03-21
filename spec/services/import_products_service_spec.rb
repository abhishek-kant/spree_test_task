require 'rails_helper'

RSpec.describe ImportProductsService do
  let(:spree_import_products_task) { create(:spree_import_products_task) }
  let(:csv_first_row_as_hash) {
    CSV.read(spree_import_products_task.import_file.file.path,
             { col_sep: ';', headers: true, header_converters: :symbol }).first.to_hash
  }
  let(:import_service) { ImportProductsService.new(spree_import_products_task.id, 0, 21) }

  describe "run" do

    it "creates products from import valid data in csv" do
      expect{ import_service.run }.to change{ Spree::Product.count }.by(3)
    end

    describe "product assignments" do

      before(:each) do
        import_service.run
        @product = Spree::Product.find_by(slug: csv_first_row_as_hash[:slug])
      end

      it "sets product attributes correctly" do

        expect(@product.name).to eq(csv_first_row_as_hash[:name])
        expect(@product.description).to eq(csv_first_row_as_hash[:description])
        expect(@product.available_on).to eq(csv_first_row_as_hash[:available_on])
      end

      it "sets correct category" do
        import_service.run
        @product = Spree::Product.find_by(slug: csv_first_row_as_hash[:slug])
        category = Spree::Taxon.find_by(name: csv_first_row_as_hash[:category])
        expect(@product.taxons).to include(category)
      end

      it "sets correct shipping category" do
        import_service.run
        @product = Spree::Product.find_by(slug: csv_first_row_as_hash[:slug])
        shipping_category = Spree::ShippingCategory.find_by(name: csv_first_row_as_hash[:shipping_category])
        expect(@product.shipping_category).to eq shipping_category
      end


      it "sets correct option types" do
        import_service.run
        @product = Spree::Product.find_by(slug: csv_first_row_as_hash[:slug])
        csv_first_row_as_hash[:option_types].split("|").each do |option_type_name|
          option_type = Spree::OptionType.find_or_initialize_by(name: option_type_name)
          expect(@product.option_types).to include(option_type)
        end
      end


      it "creates a variant for product" do
        import_service.run
        @product = Spree::Product.find_by(slug: csv_first_row_as_hash[:slug])
        expect(@product.variants).not_to be_empty
      end
    end




  end
end