namespace :sidekiq do
    desc 'Run Sidekiq worker jobs'
    task run_worker: :environment do
      require 'sidekiq/testing'
      Sidekiq::Testing.inline! do
        DeleteOldPdfsWorkerJob.perform_async
      end
    end
  end
  