# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    super do |user|
      if user.errors.empty?
        sign_out(user)
        flash[:notice] = "La tua password è stata cambiata con successo. Effettua nuovamente il login."
        return redirect_to new_user_session_path
      end
    end
  end

  protected

  # The path used after resetting password
  def after_resetting_password_path_for(resource)
    new_session_path(resource)
  end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
