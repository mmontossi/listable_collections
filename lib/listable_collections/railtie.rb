module ListableCollections
  class Railtie < Rails::Railtie

    initializer 'listable_collections.extensions' do
      ::ActiveRecord::Base.include(
        ListableCollections::Extensions::ActiveRecord::Base
      )
    end

  end
end
