module TableItemHelper

  def render_table_item(item)
    style = style_for_table_item item
    content_tag :div, style: style, class: 'table-item', 'data-table-item-id' => item.id do
      image_tag item.image_path, style: style
    end
  end

  def style_hash_for_table_item(item)
    style = {
      left: "#{item.pos_x}px",
      top: "#{item.pos_y}px",
      width: "#{item.width}px",
      height: "#{item.height}px",
      'z-index' => item.pos_z,
    }
  end

  def style_for_table_item(item)
    style_hash_for_table_item(item).map { |k, v| "#{k}: #{v};" }.join(' ')
  end
end
