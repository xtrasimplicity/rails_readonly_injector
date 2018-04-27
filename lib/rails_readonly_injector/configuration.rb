# frozen_string_literal: true

module RailsReadonlyInjector
  class Configuration
    attr_reader :controller_rescue_action, :classes_to_include, :classes_to_exclude

    def initialize
      @read_only = false
      @controller_rescue_action = proc {}
      @classes_to_exclude = []

      @changed_attributes = {}
    end

    # @return [Array<Class>] An array of classes to include
    # If not specified upon initialisation, it defaults to:
    #   ActiveRecord::Base.descendants on Rails < 5.0.0, or
    #   ApplicationRecord.descendants on Rails >= 5.0.0
    def classes_to_include
      return @classes_to_include if defined? @classes_to_include

      Rails.application.eager_load!

      if Rails::VERSION::STRING < '5.0.0'
        ActiveRecord::Base.descendants
      else
        ApplicationRecord.descendants
      end
    end

    #######################
    # Setter Methods      #
    #######################

    # @param new_value [Boolean] Whether the site should be in read-only mode
    def read_only=(new_value)
      update_instance_variable('@read_only', new_value)
    end

    # @param action [Lambda, Proc] The action to execute when rescuing from
    #   `ActiveRecord::RecordReadOnly` errors, within a controller
    def controller_rescue_action=(action)
      raise 'A lambda or proc must be specified' unless action.respond_to? :call

      update_instance_variable('@controller_rescue_action', action)
    end

    # @param klasses [Array<Class>] The classes to exclude from being marked as read-only
    def classes_to_exclude=(klasses)
      update_instance_variable('@classes_to_exclude', klasses)
    end

    # @param klasses [Array<Class>] The classes to mark as read-only
    def classes_to_include=(klasses)
      update_instance_variable('@classes_to_include', klasses)
    end

    #####################
    # Instance methods  #
    #####################

    # @return [Boolean] Whether the configuration
    #   has changed since the config was last reloaded
    def dirty?
      !changed_attributes.empty?
    end

    # @return [Hash] A hash of changed attributes
    #   and their previous values
    attr_reader :changed_attributes

    private

    # Updates the value of the specified instance variable
    # and tracks the attribute's previous value (for `#dirty?`)
    def update_instance_variable(variable_name, new_value)
      old_value = instance_variable_get(variable_name).freeze

      instance_variable_set(variable_name.to_sym, new_value)

      unless old_value == new_value
        changed_attributes[variable_name.to_s.delete('@').to_sym] = old_value
      end
    end

    # Resets the changed attributes hash,
    # so that `#dirty?` returns false
    def reset_dirty_status!
      @changed_attributes = {}
    end

    attr_reader :read_only
  end
  private_constant :Configuration

  private

  # @return [Configuration] The current configuration object
  def self.configuration
    @config ||= Configuration.new
  end

  # Resets the current configuration to the defaults
  # and reloads RailsReadonlyInjector
  def self.reset_configuration!
    @config = Configuration.new

    reload!
  end
end
