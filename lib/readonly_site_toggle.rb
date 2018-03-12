require "readonly_site_toggle/version"
require "readonly_site_toggle/configuration"

module ReadonlySiteToggle
  def self.reload!
    descendants = ActiveRecord::Base.descendants

    if descendants.empty?
      Rails.application.eager_load!
      descendants = ActiveRecord::Base.descendants
    end

    descendants.each do |descendant_class|
      if self.config.read_only
        override_readonly_method(descendant_class)
      else
        restore_readonly_method(descendant_class)
      end
    end
  end

  private

  ALIASED_METHOD_NAME = 'old_readonly?'

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
      alias_method :readonly?, ALIASED_METHOD_NAME if methods.include? ALIASED_METHOD_NAME
    end
  end
end
