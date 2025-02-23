module ApplicationHelper
  def asset_exists?(filename)
    Rails.public_path.join("assets", filename).exist?
  end
end
