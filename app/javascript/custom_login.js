document.addEventListener("turbo:load", function () {
    // Sposta il link "Password dimenticata?" nel campo della password della pagina di login
    const forgotPasswordLink = document.querySelector(".forgot-password-link");
    const passwordFieldDiv = document.querySelector(".field-password");
    if (forgotPasswordLink && passwordFieldDiv) {
      const forgotPasswordContainer = document.createElement("div");
      forgotPasswordContainer.className = "forgot-password-container";
      forgotPasswordContainer.appendChild(forgotPasswordLink);
      passwordFieldDiv.appendChild(forgotPasswordContainer);
    }
  
    // Sposta il pulsante di "login con Google" nel punto giusto nella pagina di log in
    const omniauthButton = document.querySelector(".omniauth-login-button");
    const signupLink = document.querySelector(".signup-link");
    
    if (omniauthButton && signupLink) {
      
      signupLink.parentNode.insertBefore(omniauthButton, signupLink);
    }
  });

