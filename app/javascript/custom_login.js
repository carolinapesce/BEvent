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
    const loginButton = document.querySelector(".btn-login");
    if (omniauthButton && loginButton) {
      const googleButtonContainer = document.createElement("div");
      googleButtonContainer.className = "google-button-container";
      googleButtonContainer.style.display = "inline-block";
      googleButtonContainer.appendChild(omniauthButton);
      loginButton.parentNode.insertBefore(googleButtonContainer, loginButton);
    }
  });
