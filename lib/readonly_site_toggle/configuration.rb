module ReadonlySiteToggle
  class Configuration
    attr_writer :read_only

    def read_only
      @read_only || false
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
  end

  private

  def self.configuration
    @config ||= Configuration.new
  end
end