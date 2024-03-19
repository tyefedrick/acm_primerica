class DeleteOldPdfsWorkerJob
  include Sidekiq::Job

  def perform(*args)
    Pdf.where('uploaded_at <= ?', 2.years.ago).destroy_all
  end
end