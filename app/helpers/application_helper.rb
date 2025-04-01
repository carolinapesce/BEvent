module ApplicationHelper
  def asset_exists?(filename)
    Rails.public_path.join("assets", filename).exist?
  end

  def body_class
    "#{controller_name} #{action_name}"
  end

  def role_class(role)
    case role
    when 0 then 'user'
    when 1 then 'event-planner'
    when 2 then 'admin'
    else ''
    end
  end

  include Pagy::Frontend
  
end


