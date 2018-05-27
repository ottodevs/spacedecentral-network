module Job
  def reset_jobs
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end

  def jobs_count
    ActiveJob::Base.queue_adapter.enqueued_jobs.size
  end
end
