module TableItemHelper

  def render_table_item(item)
    style = {
      left: "#{item.pos_x}px",
      top: "#{item.pos_y}px",
      width: "#{item.width}px",
      height: "#{item.height}px",
      'z-index' => item.pos_z,
    }.map { |k, v| "#{k}: #{v}; " }.join

    image_tag item.image_path, style: style, class: 'table-item', 'data-table-item-id' => item.id
  end
end
