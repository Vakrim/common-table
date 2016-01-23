class TableItem < ApplicationRecord
  belongs_to :room

  def self.create_from_template!(template, room)
    create!({ width: template.width,
              height: template.height,
              image_path: ActionController::Base.helpers.asset_path(template.image_path),
              pos_x: 10,
              pos_y: 10,
              pos_z: 1,
              room: room
           })
  end

  def update_from_css(style)
    style_hash = style.split(';').map do |prop|
      prop.split(':').map(&:strip)
    end.to_h
    update(
      pos_x: style_hash['left'].to_f,
      pos_y: style_hash['top'].to_f,
      width: style_hash['width'].to_f,
      height: style_hash['height'].to_f,
      pos_z: style_hash['z-index'].to_i
    )
  end
end
