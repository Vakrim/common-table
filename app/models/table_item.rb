class TableItem < ApplicationRecord
  belongs_to :room

  def self.create_from_template!(template, room)
    create!({ width: template.width,
              height: template.height,
              image_path: ActionController::Base.helpers.asset_path(template.image_path),
              pos_x: rand(1000),
              pos_y: rand(1000),
              pos_z: 1,
              room: room
           })
  end



end
