module ApplicationHelper
    def body_class
        case request.path
            when '/users/sign_in'
                'login-page'
            else
                'default-page'
            end
        end
    end

