require 'test_helper'
require 'mock_redis'

class DeleteOldPdfsWorkerJobTest < ActiveSupport::TestCase
  def setup
    @old_pdf = Pdf.create(uploaded_at: 2.years.ago)
    @recent_pdf = Pdf.create(uploaded_at: Time.current)
    @mock_redis = MockRedis.new
  end

  def test_delete_old_pdfs
    Sidekiq.redis = @mock_redis

    DeleteOldPdfsWorkerJob.perform_async

    assert_equal 1, @mock_redis.keys.count # Assuming you are using Redis keys to track jobs
    assert_difference('Pdf.count', -1) do
      DeleteOldPdfsWorkerJob.drain # Process the job synchronously
    end

    assert_not Pdf.exists?(@old_pdf.id), "Old PDF should have been deleted"
    assert Pdf.exists?(@recent_pdf.id), "Recent PDF should not have been deleted"
  end
end