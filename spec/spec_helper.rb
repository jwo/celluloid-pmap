require 'bundler/setup'
require 'celluloid/pmap'
require 'support/benchmark_spec'
require 'logger'
Celluloid::Pmap.pool_class

Celluloid.task_class = if defined?(Celluloid::TaskThread)
                         Celluloid::TaskThread
                       else
                         Celluloid::Task::Threaded
                       end
Celluloid.logger = ::Logger.new(STDOUT)

RSpec.configure do |config|
  config.around(:each) do |example|
    celluloid_running = Celluloid.running? rescue false
    Celluloid.shutdown if celluloid_running
    Celluloid.boot
    example.run
    Celluloid.shutdown
  end
end