# frozen_string_literal: true

require 'rails_readonly_injector/version'
require 'rails_readonly_injector/configuration'

module RailsReadonlyInjector
  # Applies changes defined in the `config` object
  # and resets `config.dirty?` to false
  def self.reload!
    config.classes_to_include.each do |klass|
      # Ensure we restore classes that we want to exclude, to their defaults
      # in case they were previously marked as read-only.
      if config.classes_to_exclude.include? klass
        restore_readonly_method(klass)
        next
      end

      if config.send(:read_only)
        override_readonly_method(klass)
      else
        restore_readonly_method(klass)
      end
    end

    inject_error_handler_into_actioncontroller_base

    config.send(:reset_dirty_status!)
  end

  # Returns the currently loaded `config.read_only` value.
  # @return [Boolean] Whether the currently loaded config is set to read-only.
  def self.in_read_only_mode?
    if config.dirty? && config.changed_attributes.key?(:read_only)
      # Return the previously stored value
      config.changed_attributes[:read_only]
    else
      config.send(:read_only)
    end
  end

  # Sets the desired configuration object, if a block is provided,
  # and then returns the current configuration object.
  # @return [Configuration] The current configuration object.
  def self.config
    yield configuration if block_given?

    configuration
  end

  private

  ALIASED_METHOD_NAME = :old_readonly?

  def self.override_readonly_method(klass)
    klass.class_eval do
      alias_method ALIASED_METHOD_NAME, :readonly?

      def readonly?
        true
      end
    end
  end

  def self.restore_readonly_method(klass)
    klass.class_eval do
      def readonly?
        super
      end
    end
  end

  def self.inject_error_handler_into_actioncontroller_base
    ActionController::Base.class_eval do
      rescue_from ActiveRecord::ReadOnlyRecord, with: :rescue_from_readonly_failure

      protected

      def rescue_from_readonly_failure
        instance_eval &RailsReadonlyInjector.config.controller_rescue_action
      end
    end
  end
end
