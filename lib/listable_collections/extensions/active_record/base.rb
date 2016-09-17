module ListableCollections
  module Extensions
    module ActiveRecord
      module Base
        extend ActiveSupport::Concern

        module ClassMethods

          def lists(*args)
            options = args.extract_options!
            builder = Builder.new(self)
            args.each do |attribute|
              builder.define attribute, options
            end
          end

        end
      end
    end
  end
end
