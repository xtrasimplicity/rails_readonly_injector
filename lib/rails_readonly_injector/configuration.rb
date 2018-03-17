module RailsReadonlyInjector
  class Configuration
    attr_writer :read_only, :classes_to_exclude

    def read_only
      @read_only || false
    end

    def controller_rescue_action=(action)
      raise 'A lambda or proc must be specified' unless action.respond_to? :call

      @controller_rescue_action = action
    end

    def controller_rescue_action
      @controller_rescue_action || Proc.new {}
    end

    def classes_to_exclude
      @classes_to_exclude || []
    end
  end
  private_constant :Configuration

   # Sets the specified configuration options, if a block is provided
  # @return [Configuration] the current configuration object.
  def self.config
    yield self.configuration if block_given?

    self.configuration
  end

  def self.reset_configuration!
    @config = Configuration.new

    self.reload!
  end

  private

  def self.configuration
    @config ||= Configuration.new
  end
end