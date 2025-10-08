package tele_expertise.servlet;

import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.servise.UserService;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Register")
public class RegisterServlet extends HttpServlet {

        public void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String csrfToken = request.getParameter("csrfToken");
            String csrfTokenFromSession = (String) request.getSession().getAttribute("csrfToken");

            if (csrfToken == null || !csrfToken.equals(csrfTokenFromSession)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
                return;
            }

            String nom = request.getParameter("firstName");
            String prenom = request.getParameter("lastName");
            String email = request.getParameter("email");
            String telephone = request.getParameter("TelephoneNumber");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!password.equals(confirmPassword) && confirmPassword == null) {
                request.setAttribute("error","Passwords do not match");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            String roleParam = request.getParameter("role");
            RoleUtilisateur roleUtilisateur = null;
            try {
                roleUtilisateur = RoleUtilisateur.valueOf(roleParam);
            } catch (IllegalArgumentException e) {
                System.out.println(e.getMessage());
                request.setAttribute("error", "Invalid role selected");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            UtilisateurDTO dto = (UtilisateurDTO) request.getServletContext().getAttribute("utilisateurDTO");
            UserService userService = (UserService) request.getServletContext().getAttribute("userService");

            dto.setNom(nom);
            dto.setPrenom(prenom);
            dto.setEmail(email);
            dto.setMotDePasse(password);
            dto.setTelephone(telephone);
            dto.setRole(roleUtilisateur);

            String result = userService.save(dto);
            if (result == null) {
                request.setAttribute("message", "Utilisateur créé avec succès !");
                request.getRequestDispatcher("/Login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", result);
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
        }

    }

