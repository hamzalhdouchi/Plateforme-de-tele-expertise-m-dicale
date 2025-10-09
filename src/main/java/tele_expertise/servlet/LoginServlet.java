package tele_expertise.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.servise.UserService;

import java.io.IOException;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/Login.jsp").forward(request, response);

    }

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
        HttpSession session = request.getSession();
        session.setAttribute("loggedUser", loggedUser);
        if (loggedUser != null) {
            request.getSession().setAttribute("user", dto);
            response.sendRedirect(request.getContextPath() + "/Home-Infirmier");
        }else  {

            request.setAttribute("error", "Email ou mot de passe incorrect");

            // اعرض نفس الصفحة عبر forward (لا تغير URL)
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }

    }
}
