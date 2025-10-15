package tele_expertise.servlet;

import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.entity.Consultation;
import tele_expertise.entity.Patient;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.RoleUtilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tele_expertise.servise.ConsultationService;
import tele_expertise.servise.PatientService;

import java.io.IOException;
import java.util.List;

@WebServlet("/medecin/dashboard")
public class DashboardMedecinServlet extends HttpServlet {

    private ConsultationService consultationService;
    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        this.consultationService = (ConsultationService) getServletContext().getAttribute("consultationService");
        this.patientService = (PatientService) getServletContext().getAttribute("patientService");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Vérification de l'authentification et du rôle
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Utilisateur user = (Utilisateur) session.getAttribute("loggedUser");
        if (user.getRole() != RoleUtilisateur.GENERALISTE) {
            request.setAttribute("error", "the role is not a generaliste");
            request.getRequestDispatcher(request.getContextPath() + "/Login").forward(request,response);
            return;
        }

        try {
            Long medecinId = user.getId();

//            // Récupération des statistiques
//            int nombrePatientsAttente = patientService.getNombrePatientsEnAttente();
//            int consultationsAujourdhui = consultationService.getConsultationsAujourdhui(medecinId);
//            int consultationsMois = consultationService.getConsultationsCeMois(medecinId);
//            int actesEnAttente = consultationService.getActesEnAttente(medecinId);

            // Récupération des données détaillées
            List<Consultation> consultationsRecentes = consultationService.getConsultationsRecentes(medecinId);
//            // Passage des attributs à la JSP
//            request.setAttribute("nombrePatientsAttente", nombrePatientsAttente);
//            request.setAttribute("consultationsAujourdhui", consultationsAujourdhui);
//            request.setAttribute("consultationsMois", consultationsMois);
//            request.setAttribute("actesEnAttente", actesEnAttente);
            request.setAttribute("consultationsRecentes", consultationsRecentes);

            // Forward vers la JSP
            request.getRequestDispatcher("/generaliste/dashboardGeneraliste.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du dashboard"+ e.getMessage());
            request.getRequestDispatcher("/generaliste/dashboardGeneraliste.jsp").forward(request, response);
        }
    }
}