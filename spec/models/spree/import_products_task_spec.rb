require 'rails_helper'

RSpec.describe Spree::ImportProductsTask, type: :model do

  let(:new_import_products_task) { build(:spree_import_products_task) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:import_file) }
  end

  describe "callbacks" do
    it "executes queue_import after create" do
      expect(new_import_products_task).to receive(:queue_import)
      new_import_products_task.run_callbacks :create
    end
  end

end
