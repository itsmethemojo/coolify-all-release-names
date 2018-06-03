require 'json'

class NamelistsModel
  include ActiveModel::Model

  def index
    JSON.parse(File.read Rails.root.join('storage', 'namelists.json'))
  end

  def item(id)
    filename = Rails.root.join('storage', 'namelists', id + '.json')
    if File.exist?(filename)
      JSON.parse(File.read filename)
    end
  end
end
