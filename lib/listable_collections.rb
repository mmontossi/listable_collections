require 'listable_collections/builder'
require 'listable_collections/extensions/active_record/base'
require 'listable_collections/railtie'
require 'listable_collections/version'

module ListableCollections

  def self.parse_list(value)
    value.split(',').reject(&:blank?).map(&:strip).uniq
  end

end
