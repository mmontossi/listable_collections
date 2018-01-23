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
          if current_values.sort != new_values.sort
            attribute_will_change! name
            instance_variable_set variable, new_values.join(',')
            added_values = (new_values - current_values)
            removed_values = (current_values - new_values)
            if relation_attribute = options[:by]
              reflection = self.class.reflections[attribute.to_s]
              scope = options[:scope]
              relation = (scope ? send(scope).send(attribute) : reflection.klass)
              added_values.each do |added_value|
                send(attribute) << relation.find_or_initialize_by(
                  relation_attribute => added_value
                )
              end
              through = reflection.options[:through]
              source = reflection.source_reflection.name
              removed_values.each do |removed_value|
                send(through).each do |record|
                  if record.send(source).send(relation_attribute) == removed_value
                    record.mark_for_destruction
                  end
                end
              end
            else
              attribute_will_change! name
              new_value = ((current_values & new_values) + (new_values - current_values))
              send "#{attribute}=", new_value
            end
            if add_callback = options[:after_add]
              added_values.each do |added_value|
                send add_callback, added_value
              end
            end
            if remove_callback = options[:after_remove]
              removed_values.each do |removed_value|
                send remove_callback, removed_value
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
            if relation_attribute = options[:by]
              values = values.map do |record|
                record.send relation_attribute
              end
            end
            values.join ','
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
