require 'json'

class BundlesModel
  include ActiveModel::Model

  def list
    bundlesFile = File.read Rails.root.join('storage', 'bundles.json')
    JSON.parse(bundlesFile)
  end
end
