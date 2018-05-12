class FireflyServer
  class Configuration
    attr_reader(*%w[
      exit_signals
      watch_paths
      ignore_paths
      file_change_callbacks
    ])
    attr_accessor(*%w[
      start_server
      stop_server
      pid_file
      restart_attempt_throttle_threshold
      restart_attempt_throttle_sleep
    ])

    def initialize(params = {})
      # defaults
      self.restart_attempt_throttle_threshold = 3
      self.restart_attempt_throttle_sleep = 3
      self.exit_signals = %w[ SIGINT ]
      # watcher defaults
      self.watch_paths = []
      self.ignore_paths = []
      self.file_change_callbacks = []
      # override defaults
      params.each do |key, value|
        send("#{key}=", value)
      end
    end

    %w[ exit_signals watch_paths ignore_paths file_change_callbacks ].each do |accessor|
      define_method("#{accessor}=") { |paths| instance_variable_set("@#{accessor}", Array(paths)) }
    end

    def validate!
      # validate require options set
      %w[ start_server stop_server pid_file ].each do |attribute|
        if !send(attribute)
          raise(ArgumentError, "#{attribute} option must be provided")
        end
      end
      if watch_paths.empty?
        raise(ArgumentError, "watch_paths option must be provided")
      end
      self
    end
  end
end