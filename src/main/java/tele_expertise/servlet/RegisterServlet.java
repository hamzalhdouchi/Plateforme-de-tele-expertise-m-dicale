package tele_expertise.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import tele_expertise.entity.Specialite;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.servise.UserServiceImpl;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/Register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        session.setAttribute("csrfToken", UUID.randomUUID().toString());

        UserServiceImpl userService = (UserServiceImpl) getServletContext().getAttribute("userService");
        if (userService != null) {
            request.setAttribute("specialites", userService.getAllSpecialites());
        }

        request.getRequestDispatcher("/Register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String csrfToken = request.getParameter("csrfToken");
        String sessionCsrfToken = (String) session.getAttribute("csrfToken");

        if (csrfToken == null || !csrfToken.equals(sessionCsrfToken)) {
            response.sendRedirect(request.getContextPath() + "/Register?error=csrf");
            return;
        }

        session.setAttribute("csrfToken", UUID.randomUUID().toString());

        UserServiceImpl userService = (UserServiceImpl) getServletContext().getAttribute("userService");

        try {
            String nom = request.getParameter("firstName").trim();
            String prenom = request.getParameter("lastName").trim();
            String email = request.getParameter("email").trim().toLowerCase();
            String telephone = request.getParameter("telephone").trim();
            String password = request.getParameter("password");
            String roleParam = request.getParameter("role");

            if (nom.isEmpty() || prenom.isEmpty() || email.isEmpty() || password.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/Register?error=missing");
                return;
            }

            if (password.length() < 8) {
                response.sendRedirect(request.getContextPath() + "/Register?error=password");
                return;
            }

            RoleUtilisateur role;
            try {
                role = RoleUtilisateur.valueOf(roleParam);
            } catch (IllegalArgumentException e) {
                response.sendRedirect(request.getContextPath() + "/Register?error=role");
                return;
            }

            if (userService.emailExists(email)) {
                response.sendRedirect(request.getContextPath() + "/Register?error=email");
                return;
            }

            Utilisateur utilisateur = new Utilisateur();
            utilisateur.setNom(nom);
            utilisateur.setPrenom(prenom);
            utilisateur.setEmail(email);
            utilisateur.setMotDePasse(password);
            utilisateur.setTelephone(telephone.isEmpty() ? null : telephone);

            if (role == RoleUtilisateur.SPECIALISTE) {
                String specialiteIdStr = request.getParameter("specialiteId");
                String tarifStr = request.getParameter("tarif");

                if (specialiteIdStr == null || tarifStr == null || tarifStr.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/Register?error=specialite");
                    return;
                }

                Long specialiteId = Long.parseLong(specialiteIdStr);
                Double tarif = Double.parseDouble(tarifStr);

                Specialite specialite = userService.getSpecialiteById(specialiteId);
                if (specialite == null || tarif <= 0) {
                    response.sendRedirect(request.getContextPath() + "/Register?error=specialite");
                    return;
                }

                utilisateur.setSpecialite(specialite);
                utilisateur.setTarif(tarif);
            }

            boolean success = userService.registerUtilisateur(utilisateur, role);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/Login?success=registered");
            } else {
                response.sendRedirect(request.getContextPath() + "/Register?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Register?error=server");
        }
    }
}