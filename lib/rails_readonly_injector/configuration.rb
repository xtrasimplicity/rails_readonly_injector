module RailsReadonlyInjector

  class Configuration
    attr_reader :read_only, :controller_rescue_action, :classes_to_include, :classes_to_exclude

    def initialize
      @read_only = false
      @controller_rescue_action = Proc.new {}
      @classes_to_exclude = []

      @changed_attributes = Hash.new
    end

    #######################
    # Getter Methods      #
    #######################
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
    def read_only=(new_value)
      update_instance_variable('@read_only', new_value)
    end

    def controller_rescue_action=(action)
      raise 'A lambda or proc must be specified' unless action.respond_to? :call

      update_instance_variable('@controller_rescue_action', action)
    end

    def classes_to_exclude=(klasses)
      update_instance_variable('@classes_to_exclude', klasses)
    end

    def classes_to_include=(klasses)
      update_instance_variable('@classes_to_include', klasses)
    end

    #####################
    # Instance methods  #
    #####################
    def dirty?
      !changed_attributes.empty?
    end

    def changed_attributes
      @changed_attributes
    end

    private

    def update_instance_variable(variable_name, new_value)
      old_value = instance_variable_get(variable_name).freeze

      instance_variable_set(variable_name.to_sym, new_value)

      unless old_value == new_value
        changed_attributes[variable_name.to_s.gsub('@', '').to_sym] = old_value
      end
    end

    def reset_dirty_status!
     @changed_attributes = Hash.new
    end
  end
  private_constant :Configuration

  private
  
  def self.configuration
    @config ||= Configuration.new
  end

  def self.reset_configuration!
    @config = Configuration.new

    self.reload!
  end
end