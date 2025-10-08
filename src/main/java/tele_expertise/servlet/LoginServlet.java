package tele_expertise.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.servise.UserService;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String csrfToken = request.getParameter("csrfToken");
        String csrfTokenFromSession = (String) request.getSession().getAttribute("csrfToken");

        if (csrfToken == null || !csrfToken.equals(csrfTokenFromSession)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            return;
        }

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UtilisateurDTO dto = (UtilisateurDTO) request.getServletContext().getAttribute("utilisateurDTO");
        UserService userService = (UserService) request.getServletContext().getAttribute("userService");
        dto.setEmail(email);
        dto.setMotDePasse(password);
        UtilisateurDTO loggedUser = userService.getUser(dto);

        if (loggedUser != null) {
            request.getSession().setAttribute("loggedUser", loggedUser);
            response.sendRedirect("patient/accueilDach.jsp");
        } else {
            request.setAttribute("error", "Email ou mot de passe incorrect");
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
        }
    }
}
