# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  def update_resource(resource, params)
    if resource.provider == "google_oauth2"
      params.delete("current_password")
      resource.password = params["password"]
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def user_params
    params.require(:user).permit(:città, :num_telefono, :roles_mask, :cap_residenza, :via_residenza, images: [])
  end

  def create
    super do |resource|
      role = role_from_params
      resource.role = role
      resource.save
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    if resource.provider == "google_oauth2"
      root_path
    else
      new_user_confirmation_path
    end
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    new_user_confirmation_path
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role, :city, :phone_number, :image_url)
  end

  def role_from_params
    role = 0
    if params[:user][:role].include?('1')
      role = 1
    end
    if params[:user][:role].include?('2')
      role = 2
    end
    if params[:user][:email]=="zarola.admin@gmail.com" || params[:user][:email]=="paula.admin@gmail.com" || params[:user][:email]=="pesce.admin@gmail.com"
      role = 3
    end
    role
  end

end
