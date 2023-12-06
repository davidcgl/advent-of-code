require "pry"

def dep_graph(instructions)
  steps = "A".."Z"
  fdeps = steps.map { |s| [s, Set.new] }.to_h # A => [B] means A depends on B.
  rdeps = steps.map { |s| [s, Set.new] }.to_h # A => [B] means B depends on A.

  instructions.each do |line|
    s1, s2 = /Step (\w) must be finished before step (\w)/.match(line).captures
    fdeps[s2] << s1
    rdeps[s1] << s2
  end

  [fdeps, rdeps]
end

def get_sequence(instructions)
  blockers, dependents = dep_graph(instructions)
  queue = blockers.select { |_, d| d.empty? }.keys
  sequence = ""
  while queue.any?
    step = queue.delete(queue.min)
    sequence += step
    next unless dependents[step]

    dependents[step].each do |dep|
      blockers[dep].delete(step)
      queue << dep if blockers[dep].empty?
    end
  end
  sequence
end

def get_duration(instructions)
  blockers, dependents = dep_graph(instructions)
  job_queue = blockers.select { |_, d| d.empty? }.keys.map { |s| make_job(s) }
  job_progress = []
  schedule_jobs(job_queue, job_progress)

  duration = 0
  while job_progress.any? || job_queue.any?
    job_progress.each do |job|
      job[:remaining] -= 1
      next unless job[:remaining].zero?

      # Job is complete. Add all unblocked steps into job queue.
      dependents[job[:step]].each do |dep|
        blockers[dep].delete(job[:step])
        job_queue << make_job(dep) if blockers[dep].empty?
      end
    end

    job_progress.reject! { |j| j[:remaining].zero? }
    schedule_jobs(job_queue, job_progress)
    duration += 1
  end
  duration
end

def make_job(step)
  {step:, remaining: 61 + (step.ord - "A".ord)}
end

def schedule_jobs(job_queue, job_progress, max_concurrent_jobs = 5)
  while job_queue.any? && job_progress.size < max_concurrent_jobs
    job = job_queue.min_by { |j| j[:step] }
    job_progress << job_queue.delete(job)
  end
end

File.open(File.join(__dir__, "input.txt")) do |file|
  instructions = file.readlines

  # In what order should the steps in your instructions be completed?
  sequence = get_sequence(instructions)
  puts "Step sequence: #{sequence}"

  # With 5 workers and the 60+ second step durations described above, how long
  # will it take to complete all of the steps?
  duration = get_duration(instructions)
  puts "Total duration: #{duration}"
end
