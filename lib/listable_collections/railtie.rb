module ListableCollections
  class Railtie < Rails::Railtie

    initializer :listable_collections do
      ::ActiveRecord::Base.send :include ListableCollections::Extensions::ActiveRecord::Base
    end

  end
end
