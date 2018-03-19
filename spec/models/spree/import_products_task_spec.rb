require 'rails_helper'

RSpec.describe Spree::ImportProductsTask, type: :model do
  include ActiveJob::TestHelper
  let(:new_import_products_task) { build(:spree_import_products_task) }
  let(:new_import_products_task_191_rows) { build(:spree_import_products_task, import_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files','import_files', 'SampleCsv191Rows.csv'))) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:import_file) }
  end

  describe "callbacks" do
    it "executes queue_import after create" do
      expect(new_import_products_task).to receive(:queue_import)
      new_import_products_task.run_callbacks :create
    end

    describe "queue_import" do
      it "enqueues 1 ImportProductsJob" do
        expect {new_import_products_task.save}.to enqueue_job(ImportProductsJob)
      end

      it "enqueues 4 job for  191 csv rows" do
        new_import_products_task_191_rows.save
        expect(enqueued_jobs.size).to eq(4)
      end

    end

  end

end
