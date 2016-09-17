module ListableCollections
  class Builder

    attr_reader :model

    def initialize(model)
      @model = model
    end

    def define(attribute, options)
      plural = (options[:as] || attribute).to_s
      singular = plural.singularize
      name = "#{singular}_list"
      variable = "@#{name}"
      was = "#{name}_was"
      if Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR < 2
        model.skip_time_zone_conversion_for_attributes << name.to_sym
      end
      model.define_attribute_method name
      define_list_writer name, variable, attribute, options
      define_list_reader name, variable, attribute, options
      define_added_to_list_reader plural, name, was
      define_removed_from_list_reader plural, name, was
    end

    private

    def define_list_writer(name, variable, attribute, options)
      model.class_eval do
        define_method "#{name}=" do |value|
          list = value.split(',').reject(&:blank?).map(&:strip).join(',')
          current_values = send(name).split(',')
          new_values = list.split(',')
          if current_values.sort != new_values.sort
            if options.has_key?(:attribute)
              attribute_will_change! name
              instance_variable_set variable, list
            else
              attribute_will_change! name
              send "#{attribute}=", list.split(',')
            end
            if options.has_key?(:after_add)
              (new_values - current_values).each do |added_value|
                send options[:after_add], added_value
              end
            end
            if options.has_key?(:after_remove)
              (current_values - new_values).each do |removed_value|
                send options[:after_remove], removed_value
              end
            end
          end
        end
      end
    end

    def define_list_reader(name, variable, attribute, options)
      model.class_eval do
        define_method name do
          if list = instance_variable_get(variable)
            list
          elsif values = send(attribute)
            if options.has_key?(:attribute)
              values = values.map do |record|
                record.send options[:attribute]
              end
            end
            values.reverse.join(',')
          end
        end
      end
    end

    def define_added_to_list_reader(plural, name, was)
      model.class_eval do
        define_method "added_#{plural}_to_list" do
          send(name).split(',') - send(was).split(',')
        end
      end
    end

    def define_removed_from_list_reader(plural, name, was)
      model.class_eval do
        define_method "removed_#{plural}_from_list" do
          send(was).split(',') - send(name).split(',')
        end
      end
    end

  end
end
