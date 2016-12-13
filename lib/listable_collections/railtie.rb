module ListableCollections
  class Railtie < Rails::Railtie

    initializer 'listable_collections.active_record' do
      ActiveSupport.on_load :active_record do
        ::ActiveRecord::Base.include(
          ListableCollections::Extensions::ActiveRecord::Base
        )
      end
    end

  end
end
