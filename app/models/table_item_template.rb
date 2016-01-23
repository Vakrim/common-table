class TableItemTemplate
  include ActiveModel::Model

  attr_accessor :name, :width, :height, :image, :category

  def id
    @id ||= "#{ category[:name].underscore.tr(' ', '_') }/#{ image }"
  end

  def image_path
    Pathname.new('ti').join("#{ id }.png")
  end
end
