package tele_expertise.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tele_expertise.entity.DemandeExpertise;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.enums.StatusPatient;
import tele_expertise.servise.CreneauService;
import tele_expertise.servise.DemandeExpertiseService;
import tele_expertise.servise.UserServiceImpl;


import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/specialiste/dashboard-specialiste")
public class DashboardSpecialisteServlet extends HttpServlet {
    private UserServiceImpl userService;
    private DemandeExpertiseService demandeExpertiseService;
    private CreneauService creneauService;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @Override
    public void init() {
        userService = (UserServiceImpl)  getServletContext().getAttribute("userService") ;
        demandeExpertiseService = (DemandeExpertiseService)   getServletContext().getAttribute("demandeExpertiseService") ;
        creneauService = (CreneauService)    getServletContext().getAttribute("creneauService") ;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null ||
                !"SPECIALISTE".equals(session.getAttribute("role").toString())) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        try {
            Utilisateur user = (Utilisateur) session.getAttribute("loggedUser");
//            Utilisateur specialiste = userService.getAllUsers();

            if (user == null) {
                session.setAttribute("error", "Utilisateur introuvable");
                resp.sendRedirect(req.getContextPath() + "/Login");
                return;
            }

            if (user.getSpecialite() != null) {
                user.getSpecialite().getNom();
            }

            List<DemandeExpertise> allDemandes = demandeExpertiseService.findBySpecialisteId(user.getId());

            for (DemandeExpertise demande : allDemandes) {
                if (demande.getConsultation() != null) {
                    demande.getConsultation().getMotif(); // Force load
                    if (demande.getConsultation().getPatient() != null) {
                        demande.getConsultation().getPatient().getId(); // Force load
                    }
                }
                if (demande.getCreneau() != null) {
                    demande.getCreneau().getDateHeure();
                }
            }

            // Filter based on user selection (US7: Stream API filtering)
            String filter = req.getParameter("filter");
            List<DemandeExpertise> demandes;

            if ("EN_ATTENTE".equals(filter)) {
                demandes = allDemandes.stream()
                        .filter(d -> "EN_ATTENTE".equals(d.getStatut()))
                        .sorted((d1, d2) -> {
                            int priority1 = getPriorityOrder(d1.getPriorite());
                            int priority2 = getPriorityOrder(d2.getPriorite());
                            return Integer.compare(priority1, priority2);
                        })
                        .collect(Collectors.toList());
            } else if ("TERMINEE".equals(filter)) {
                demandes = allDemandes.stream()
                        .filter(d -> "TERMINEE".equals(d.getStatut()))
                        .collect(Collectors.toList());
            } else {
                demandes = allDemandes;
            }

            // Statistics
            long enAttenteCount = allDemandes.stream()
                    .filter(d -> "EN_ATTENTE".equals(d.getStatut()))
                    .count();

            long termineesCount = allDemandes.stream()
                    .filter(d -> "TERMINEE".equals(d.getStatut()))
                    .count();

            // Count available future créneaux
            long creneauxLibres = creneauService.findBySpecialisteId(user.getId())
                    .stream()
                    .filter(c -> c.getDisponible() && c.getDateHeure().isAfter(LocalDateTime.now()))
                    .count();

            req.setAttribute("specialiste", user);
            req.setAttribute("demandes", demandes);
            req.setAttribute("totalDemandes", allDemandes.size());
            req.setAttribute("enAttenteCount", enAttenteCount);
            req.setAttribute("termineesCount", termineesCount);
            req.setAttribute("creneauxLibres", creneauxLibres);
            req.setAttribute("dateFormatter", DATE_FORMATTER); // Pass formatter to JSP

            req.getRequestDispatcher("/specialiste/dashboard-specialiste.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur : " + e.getMessage());
        }
    }

    private int getPriorityOrder(String priorite) {
        switch (priorite) {
            case "URGENTE": return 1;
            case "NORMALE": return 2;
            case "NON_URGENTE": return 3;
            default: return 4;
        }
    }

    @Override
    public void destroy() {
        if (demandeExpertiseService != null) demandeExpertiseService.close();
        if (creneauService != null) creneauService.close();
    }
}
