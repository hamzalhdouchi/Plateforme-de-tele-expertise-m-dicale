package tele_expertise.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tele_expertise.dao.UtilisateurDaoImpl;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.servise.UserServiceImpl;

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

//        UtilisateurDaoImpl user = (UtilisateurDaoImpl) request.getServletContext().getAttribute("UtlistaeurImpl");

        UserServiceImpl userService = (UserServiceImpl) request.getServletContext().getAttribute("userService");


        Utilisateur loggedUser =userService.login(email, password);

        if (loggedUser == null) {
            request.setAttribute("error", "Le utilisateur n'existe pas");
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
        }
        HttpSession session = request.getSession();
        session.setAttribute("role", loggedUser.getRole());
        session.setAttribute("loggedUser", loggedUser);
        if (loggedUser != null) {
            if (loggedUser.getRole() == RoleUtilisateur.INFIRMIER) {
            response.sendRedirect(request.getContextPath() + "/Home-Infirmier");
            } else if (loggedUser.getRole() == RoleUtilisateur.GENERALISTE) {
                response.sendRedirect(request.getContextPath() + "/medecin/dashboard");
            }else{

                response.sendRedirect(request.getContextPath() + "/specialiste/dashboard-specialiste");
            }
        }else  {

            request.setAttribute("error", "Email ou mot de passe incorrect");

            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }

    }
}
