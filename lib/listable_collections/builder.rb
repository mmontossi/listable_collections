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
      if model.reflections.has_key?(attribute.to_s)
        relation_attribute = options[:by]
        define_relation_writer name, attribute, relation_attribute
        define_relation_reader name, attribute, relation_attribute
      else
        define_attribute_writer name, attribute
        define_attribute_reader name, attribute
      end
      model.include concern
    end

    private

    def define_attribute_writer(name, attribute)
      concern.class_eval do
        define_method "#{name}=" do |value|
          send "#{attribute}=", ListableCollections.parse_list(value)
        end
      end
    end

    def define_attribute_reader(name, attribute)
      concern.class_eval do
        define_method name do
          send(attribute).join ','
        end
      end
    end

    def define_relation_writer(name, attribute, relation_attribute)
      reflection = model.reflections[attribute.to_s]
      relation_model = reflection.klass
      concern.class_eval do
        define_method "new_#{name}=" do |value|
          ListableCollections.parse_list(value).each do |token|
            relation = send(attribute)
            record = begin
              if relation_model.attribute_names.include?(relation_attribute)
                relation.find_by relation_attribute => token
              else
                relation.send "find_by_#{relation_attribute}", token
              end
            end
            if record
              relation << record 
            else
              relation.create relation_attribute => token
            end
          end
        end
      end
    end

    def define_relation_reader(name, attribute, relation_attribute)
      concern.class_eval do
        define_method name do
          tokens = send(attribute).map do |record|
            record.send relation_attribute
          end
          tokens.join ','
        end
      end
    end

  end
end
