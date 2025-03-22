module ApplicationHelper
  def asset_exists?(filename)
    Rails.public_path.join("assets", filename).exist?
  end

  def body_class
    "#{controller_name} #{action_name}"
  end

  include Pagy::Frontend
  
end


