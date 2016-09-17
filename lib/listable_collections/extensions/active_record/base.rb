module ListableCollections
  module Extensions
    module ActiveRecord
      module Base
        extend ActiveSupport::Concern

        class_methods do

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
