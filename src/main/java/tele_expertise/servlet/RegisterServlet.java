package tele_expertise.servlet;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import tele_expertise.entity.Creneau;
import tele_expertise.entity.Specialite;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.servise.CreneauService;
import tele_expertise.servise.SpecialisteService;
import tele_expertise.servise.SpecialiteServiceImpl;
import tele_expertise.servise.UserServiceImpl;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

@WebServlet("/Register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        session.setAttribute("csrfToken", UUID.randomUUID().toString());

        UserServiceImpl userService = (UserServiceImpl) getServletContext().getAttribute("userService");
        SpecialiteServiceImpl specialiteService = (SpecialiteServiceImpl) getServletContext().getAttribute("specialiteService");
        if (userService != null) {
            request.setAttribute("specialites", specialiteService.getAllSpecialites());
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
        CreneauService cn = (CreneauService) getServletContext().getAttribute("creneauService");

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
            if (role == RoleUtilisateur.SPECIALISTE) {
                cn.generateCreneauxForSpecialist(utilisateur);
            }
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


    private int generateCreneauxForSpecialist(EntityManager em, Utilisateur specialist) {
        LocalDate startDate = LocalDate.now().plusDays(1); // Start from tomorrow
        int creneauxCount = 0;

        // Generate créneaux for the next 7 days
        for (int day = 0; day < 7; day++) {
            LocalDate currentDate = startDate.plusDays(day);

            // Time slots from 09:00 to 11:30 (30-minute intervals)
            LocalTime[] timeSlots = {
                    LocalTime.of(9, 0),   // 09:00
                    LocalTime.of(9, 30),  // 09:30
                    LocalTime.of(10, 0),  // 10:00
                    LocalTime.of(10, 30), // 10:30
                    LocalTime.of(11, 0),  // 11:00
                    LocalTime.of(11, 30)  // 11:30
            };

            // Create a creneau for each time slot
            for (LocalTime time : timeSlots) {
                Creneau creneau = new Creneau();
                creneau.setSpecialiste(specialist);
                creneau.setDateHeure(LocalDateTime.of(currentDate, time));
                creneau.setDisponible(true);
                creneau.setDureeMinutes(30);

                em.persist(creneau);
                creneauxCount++;
            }
        }
        return creneauxCount;
    }
}