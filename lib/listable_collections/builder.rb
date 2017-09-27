module ListableCollections
  class Builder

    attr_reader :model, :concern

    def initialize(model)
      @model = model
      @concern = Module.new
    end

    def define(attribute, options)
      plural = (options[:as] || attribute).to_s
      singular = plural.singularize
      name = "#{singular}_list"
      variable = "@#{name}"
      was = "#{name}_was"
      model.attribute name
      define_list_writer name, variable, attribute, options
      define_list_reader name, variable, attribute, options
      define_added_to_list plural, name, was
      define_removed_from_list plural, name, was
      model.include concern
    end

    private

    def define_list_writer(name, variable, attribute, options)
      concern.class_eval do
        define_method "#{name}=" do |value|
          current_values = send(name).split(',')
          new_values = value.split(',').reject(&:blank?).map(&:strip)
          value = ((current_values & new_values) + (new_values - current_values))
          if current_values.sort != new_values.sort
            if options.has_key?(:attribute)
              attribute_will_change! name
              instance_variable_set variable, value.join(',')
            else
              attribute_will_change! name
              send "#{attribute}=", value
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
      concern.class_eval do
        define_method name do
          if list = instance_variable_get(variable)
            list
          elsif values = send(attribute)
            if options.has_key?(:attribute)
              values = values.map do |record|
                record.send options[:attribute]
              end
            end
            values.join(',')
          end
        end
      end
    end

    def define_added_to_list(plural, name, was)
      concern.class_eval do
        define_method "added_#{plural}_to_list" do
          send(name).split(',') - send(was).split(',')
        end
      end
    end

    def define_removed_from_list(plural, name, was)
      concern.class_eval do
        define_method "removed_#{plural}_from_list" do
          send(was).split(',') - send(name).split(',')
        end
      end
    end

  end
end
