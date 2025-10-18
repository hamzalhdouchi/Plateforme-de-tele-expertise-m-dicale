package tele_expertise.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tele_expertise.entity.DemandeExpertise;
import tele_expertise.entity.Utilisateur;
import tele_expertise.servise.DemandeExpertiseService;
import tele_expertise.servise.UserServiceImpl;


import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/specialiste/repondre-expertise")
public class RepondreExpertiseServlet extends HttpServlet {
    private DemandeExpertiseService demandeExpertiseService;
    private UserServiceImpl userService;

    @Override
    public void init() {
        demandeExpertiseService = (DemandeExpertiseService) getServletContext().getAttribute("demandeExpertiseService");
        userService = (UserServiceImpl) getServletContext().getAttribute("userService");
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
            String demandeIdParam = req.getParameter("demandeId");
            if (demandeIdParam == null || demandeIdParam.isEmpty()) {
                session.setAttribute("error", "ID de demande manquant");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            Long demandeId = Long.parseLong(demandeIdParam);
            DemandeExpertise demande = demandeExpertiseService.findById(demandeId);

            if (demande == null) {
                session.setAttribute("error", "Demande d'expertise introuvable");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            Utilisateur username = (Utilisateur) session.getAttribute("loggedUser");
            Utilisateur specialiste = userService.getUserByEmail(username.getEmail());

            if (!demande.getSpecialiste().getId().equals(specialiste.getId())) {
                session.setAttribute("error", "Cette demande n'est pas pour vous");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            if (!"EN_ATTENTE".equals(demande.getStatut())) {
                session.setAttribute("error", "Cette demande a déjà été traitée");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            if (demande.getConsultation() != null) {
                demande.getConsultation().getMotif();
                demande.getConsultation().getObservations();
                if (demande.getConsultation().getPatient() != null) {
                    demande.getConsultation().getPatient().getId();
                }
            }
            if (demande.getCreneau() != null) {
                demande.getCreneau().getDateHeure();
            }

            req.setAttribute("demande", demande);
            req.setAttribute("specialiste", specialiste);

            req.getRequestDispatcher("/specialiste/repondre-expertise.jsp")
                    .forward(req, resp);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "ID de demande invalide");
            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur : " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null ||
                !"SPECIALISTE".equals(session.getAttribute("role").toString())) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        try {
            Long demandeId = Long.parseLong(req.getParameter("demandeId"));
            String avisMedical = req.getParameter("avisMedical");
            String recommandations = req.getParameter("recommandations");

            // Validation
            if (avisMedical == null || avisMedical.trim().isEmpty()) {
                session.setAttribute("error", "L'avis médical est obligatoire");
                resp.sendRedirect(req.getContextPath() +
                        "/specialiste/repondre-expertise?demandeId=" + demandeId);
                return;
            }

            DemandeExpertise demande = demandeExpertiseService.findById(demandeId);

            if (demande == null) {
                session.setAttribute("error", "Demande introuvable");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            // Verify it's for the current specialist
            Utilisateur username = (Utilisateur) session.getAttribute("loggedUser");
            Utilisateur specialiste = userService.getUserByEmail(username.getEmail());

            if (!demande.getSpecialiste().getId().equals(specialiste.getId())) {
                session.setAttribute("error", "Cette demande n'est pas pour vous");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            // Update the demande
            demande.setAvisMedical(avisMedical);
            demande.setRecommandations(recommandations);
            demande.setStatut("TERMINEE");
            demande.setDateReponse(LocalDateTime.now());

            demandeExpertiseService.update(demande);

            session.setAttribute("success",
                    "Avis médical envoyé avec succès pour le patient #" +
                            demande.getConsultation().getPatient().getId());

            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Données invalides");
            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
        }
    }

}