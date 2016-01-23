namespace :storage do
  namespace :templates do
    desc "Updates width and height field in YAML files"
    task measure_images: :environment do
      require 'dimensions'

      file_names = Dir.entries(TableItemTemplateStorage::STORAGE_PATH)
      file_names -= %w(. .. categories.yml)
      file_names.keep_if { |name| name.ends_with? '.yml' }
      file_names.each do |file_name|
        no_ext_name = file_name.slice(0..-5)
        templates = YAML.load_file(TableItemTemplateStorage::STORAGE_PATH.join(file_name))
        templates.each do |template|
          dimensions = Dimensions.dimensions(Rails.root.join('app', 'assets', 'images', 'ti', no_ext_name, "#{template['image']}.png"))
          template['width'] = dimensions[0]
          template['height'] = dimensions[1]
        end
        File.write TableItemTemplateStorage::STORAGE_PATH.join(file_name) ,templates.to_yaml
      end
    end
  end
end
