package tele_expertise.servlet;

import tele_expertise.entity.Consultation;
import tele_expertise.entity.Patient;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.ActeTechnique;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.enums.StatusPatient;
import tele_expertise.enums.StatutConsultation;
import tele_expertise.servise.ConsultationService;
import tele_expertise.servise.PatientService;
import tele_expertise.servise.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@WebServlet(urlPatterns = {"/medecin/creer-consultation", "/historique-consultations","/Toutes_Consultations"})
public class CreerConsultationGenerServlet extends HttpServlet {

    private String generateCsrfToken() {
        return UUID.randomUUID().toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PatientService patientService = (PatientService) getServletContext().getAttribute("patientService");
        ConsultationService consultationService = (ConsultationService) getServletContext().getAttribute("consultationService");

        HttpSession session = request.getSession(false);

        // Vérification de session
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Utilisateur user = (Utilisateur) session.getAttribute("loggedUser");

        if (user.getRole() != RoleUtilisateur.GENERALISTE) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }

        try {
            String uri = request.getRequestURI();
            String patientIdParam = request.getParameter("patientId");

            // Génération du CSRF token pour la page de création
            if (uri.endsWith("creer-consultation") && patientIdParam != null) {
                session.setAttribute("csrfToken", generateCsrfToken());
            }

            if (uri.endsWith("Toutes_Consultations")) {
                List<Consultation> consultations = consultationService.getAllConsultationsBymidsan(user.getId());
                request.setAttribute("consultations", consultations);
                request.getRequestDispatcher("/generaliste/toutesConsultations.jsp").forward(request, response);
                return;
            }

            if (patientIdParam == null || patientIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/generaliste/creer-consultationGeneraliste.jsp");
                return;
            }

            int patientId;
            try {
                patientId = Integer.parseInt(patientIdParam);
            } catch (NumberFormatException e) {
                String redirectUrl = request.getContextPath() + "/generaliste/creer-consultationGeneraliste.jsp?error=invalid_patient_id";
                response.sendRedirect(redirectUrl);
                return;
            }

            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                String redirectUrl = request.getContextPath() + "/generaliste/creer-consultationGeneraliste.jsp?error=patient_not_found";
                response.sendRedirect(redirectUrl);
                return;
            }

            if (uri.endsWith("historique-consultations")) {
                Consultation consultation = consultationService.getConsultationByPatient(patient);
                if (consultation != null) {
                    if (consultation.getDateConsultation() != null) {
                        Date dateConsultation = Date.from(
                                consultation.getDateConsultation().atZone(ZoneId.systemDefault()).toInstant()
                        );
                        request.setAttribute("dateConsultation", dateConsultation);
                    }

                    if (consultation.getDateCloture() != null) {
                        Date dateCloture = Date.from(
                                consultation.getDateCloture().atZone(ZoneId.systemDefault()).toInstant()
                        );
                        request.setAttribute("dateCloture", dateCloture);
                    }

                    if (consultation.getPatient().getDateDeNaissance() != null) {
                        LocalDate localDate = consultation.getPatient().getDateDeNaissance();
                        Date dateNaissance = Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
                        request.setAttribute("dateNaissance", dateNaissance);
                    }
                    request.setAttribute("consultation", consultation);
                }
                request.getRequestDispatcher("/generaliste/historiqueDesConsultations.jsp").forward(request, response);
                return;
            }

            // Envoi des données au JSP de création de consultation
            request.setAttribute("patient", patient);
            request.setAttribute("actesTechniques", ActeTechnique.values());
            request.getRequestDispatcher("/generaliste/creer-consultationGeneraliste.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            String redirectUrl = request.getContextPath() + "/generaliste/creer-consultationGeneraliste.jsp?error=loading_failed";
            response.sendRedirect(redirectUrl);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PatientService patientService = (PatientService) getServletContext().getAttribute("patientService");
        UserServiceImpl userService = (UserServiceImpl) getServletContext().getAttribute("userService");
        ConsultationService consultationService = (ConsultationService) getServletContext().getAttribute("consultationService");

        String patientIdStr = request.getParameter("patientId");
        String redirectUrl = request.getContextPath() + "/generaliste/creer-consultationGeneraliste.jsp?patientId=" +
                (patientIdStr != null ? patientIdStr : "");

        try {
            // Vérification CSRF Token
            String csrfToken = request.getParameter("csrfToken");
            HttpSession session = request.getSession(false);
            if (session == null || csrfToken == null || !csrfToken.equals(session.getAttribute("csrfToken"))) {
                redirectUrl += "&error=csrf_invalid";
                response.sendRedirect(redirectUrl);
                return;
            }

            // Régénération du token CSRF
            session.setAttribute("csrfToken", generateCsrfToken());

            String motif = request.getParameter("motif");
            String diagnostic = request.getParameter("diagnostic");
            String traitement = request.getParameter("traitement");
            String observations = request.getParameter("observations");
            String statutStr = request.getParameter("statut");
            String[] actesSelectionnes = request.getParameterValues("actesTechniques");

            // Validation des champs obligatoires
            if (patientIdStr == null || patientIdStr.isEmpty()) {
                redirectUrl += "&error=missing_patient";
                response.sendRedirect(redirectUrl);
                return;
            }

            if (motif == null || motif.trim().isEmpty()) {
                redirectUrl += "&error=missing_motif";
                response.sendRedirect(redirectUrl);
                return;
            }

            if (statutStr == null || statutStr.trim().isEmpty()) {
                redirectUrl += "&error=missing_statut";
                response.sendRedirect(redirectUrl);
                return;
            }

            StatutConsultation status;
            try {
                status = StatutConsultation.valueOf(statutStr);
            } catch (IllegalArgumentException e) {
                redirectUrl += "&error=invalid_statut";
                response.sendRedirect(redirectUrl);
                return;
            }

            int patientId;
            try {
                patientId = Integer.parseInt(patientIdStr);
            } catch (NumberFormatException e) {
                redirectUrl += "&error=invalid_patient_id";
                response.sendRedirect(redirectUrl);
                return;
            }

            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                redirectUrl += "&error=patient_not_found";
                response.sendRedirect(redirectUrl);
                return;
            }

            // Vérification session utilisateur
            Utilisateur user = (Utilisateur) session.getAttribute("loggedUser");
            if (user == null || user.getRole() != RoleUtilisateur.GENERALISTE) {
                redirectUrl += "&error=unauthorized";
                response.sendRedirect(redirectUrl);
                return;
            }

            Utilisateur medecinGeneraliste = userService.getUserByEmail(user.getEmail());
            if (medecinGeneraliste == null) {
                redirectUrl += "&error=medecin_not_found";
                response.sendRedirect(redirectUrl);
                return;
            }

            // Traitement des actes techniques
            List<ActeTechnique> actes = new ArrayList<>();
            double coutTotalActes = 0;
            if (actesSelectionnes != null) {
                for (String acteName : actesSelectionnes) {
                    if (acteName != null && !acteName.trim().isEmpty()) {
                        try {
                            ActeTechnique acte = ActeTechnique.valueOf(acteName);
                            actes.add(acte);
                            coutTotalActes += acte.getCout();
                            System.out.println("Acte sélectionné : " + acte.getLibelle() + " (" + acte.getCout() + "€)");
                        } catch (IllegalArgumentException e) {
                            System.out.println("Acte inconnu : " + acteName);
                        }
                    }
                }
            }

            // Création de la consultation
            Consultation consultation = new Consultation();
            consultation.setPatient(patient);
            consultation.setMedecinGeneraliste(medecinGeneraliste);
            consultation.setMotif(motif.trim());
            consultation.setDiagnostic(diagnostic != null ? diagnostic.trim() : null);
            consultation.setTraitement(traitement != null ? traitement.trim() : null);
            consultation.setObservations(observations != null ? observations.trim() : null);
            consultation.setDateConsultation(LocalDateTime.now());
            consultation.setStatut(status);
            consultation.setActesTechniques(actes);
            consultation.setCoutActesTechniques(coutTotalActes);
            consultation.setCoutConsultation(150.0); // Coût fixe de consultation
            consultation.setCoutTotal(coutTotalActes + 150.0);

            // Mise à jour statut patient si consultation terminée
            if (status == StatutConsultation.TERMINEE) {
                patientService.UpadateStatus(patientId, StatusPatient.TERMINE);
            }

            // Sauvegarde de la consultation
            consultationService.updateConsultationForPatient(consultation);

            // Succès - Redirection avec message de succès
            String successUrl = request.getContextPath() + "/medecin/dashboard?patientId=" + patientId + "&success=true";
            response.sendRedirect(successUrl);

        } catch (Exception e) {
            e.printStackTrace();
            redirectUrl += "&error=creation_failed&message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
            response.sendRedirect(redirectUrl);
        }
    }
}