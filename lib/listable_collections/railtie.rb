module ListableCollections
  class Railtie < Rails::Railtie

    initializer :listable_collections do
      ::ActiveRecord::Base.include Extensions::ActiveRecord::Base
    end

  end
end
