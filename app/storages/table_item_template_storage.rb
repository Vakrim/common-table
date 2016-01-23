class TableItemTemplateStorage
  include Singleton
  STORAGE_PATH = Rails.root.join('db', 'storages', 'table_item_templates')
  CATEGORIES_PATH = STORAGE_PATH.join('categories.yml')

  def initialize
    load_data!
  end

  def categories
    @categories.dup
  end

  private

  def load_data!
    @categories = YAML.load_file CATEGORIES_PATH
    @categories.each do |category|
      category.symbolize_keys!
      templates_path = STORAGE_PATH.join("#{ category[:name].underscore.tr(' ', '_') }.yml")
      templates_arguments = YAML.load_file templates_path
      category[:templates] = templates_arguments.map { |args| TableItemTemplate.new(args.symbolize_keys) }
    end
    @categories
  end
end
