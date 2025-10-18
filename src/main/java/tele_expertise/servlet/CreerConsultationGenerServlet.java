package tele_expertise.servlet;

import tele_expertise.entity.*;
import tele_expertise.enums.ActeTechnique;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.enums.StatusPatient;
import tele_expertise.enums.StatutConsultation;
import tele_expertise.servise.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = {"/medecin/creer-consultation", "/historique-consultations","/Toutes_Consultations"})
public class CreerConsultationGenerServlet extends HttpServlet {
    private  PatientService patientService;
    private  ConsultationService consultationService;
    private  SpecialiteServiceImpl specialiteService;
    private  UserServiceImpl userService;
    private CreneauService creneauService;

    public void init(){
        this.patientService =  (PatientService) getServletContext().getAttribute("patientService");
        this.consultationService = (ConsultationService) getServletContext().getAttribute("consultationService");
        this.specialiteService = (SpecialiteServiceImpl) getServletContext().getAttribute("specialiteService");
        this.userService = (UserServiceImpl) getServletContext().getAttribute("userService");
        this.creneauService = (CreneauService) getServletContext().getAttribute("creneauService");


    }

    private String generateCsrfToken() {
        return UUID.randomUUID().toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

            // Génération du CSRF token
            if (uri.endsWith("creer-consultation") && patientIdParam != null) {
                session.setAttribute("csrfToken", generateCsrfToken());
            }

            // Liste des consultations
            if (uri.endsWith("Toutes_Consultations")) {
                List<Consultation> consultations = consultationService.getAllConsultationsBymidsan(user.getId());
                request.setAttribute("consultations", consultations);
                request.getRequestDispatcher("/generaliste/toutesConsultations.jsp").forward(request, response);
                return;
            }

            // Vérification du paramètre patientId
            if (patientIdParam == null || patientIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/generaliste/creer-consultationGeneraliste.jsp");
                return;
            }

            int patientId;
            try {
                patientId = Integer.parseInt(patientIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/generaliste/creer-consultationGeneraliste.jsp?error=invalid_patient_id");
                return;
            }

            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                response.sendRedirect(request.getContextPath() + "/generaliste/creer-consultationGeneraliste.jsp?error=patient_not_found");
                return;
            }

            // Historique des consultations
            if (uri.endsWith("historique-consultations")) {
                Consultation consultation = consultationService.getConsultationByPatient(patient);
                if (consultation != null) {
                    if (consultation.getDateConsultation() != null) {
                        Date dateConsultation = Date.from(consultation.getDateConsultation().atZone(ZoneId.systemDefault()).toInstant());
                        request.setAttribute("dateConsultation", dateConsultation);
                    }
                    if (consultation.getDateCloture() != null) {
                        Date dateCloture = Date.from(consultation.getDateCloture().atZone(ZoneId.systemDefault()).toInstant());
                        request.setAttribute("dateCloture", dateCloture);
                    }
                    if (consultation.getPatient().getDateDeNaissance() != null) {
                        Date dateNaissance = Date.from(consultation.getPatient().getDateDeNaissance().atStartOfDay(ZoneId.systemDefault()).toInstant());
                        request.setAttribute("dateNaissance", dateNaissance);
                    }
                    request.setAttribute("consultation", consultation);
                }
                request.getRequestDispatcher("/generaliste/historiqueDesConsultations.jsp").forward(request, response);
                return;
            }

            List<Specialite> specialites = specialiteService.getAllSpecialites();
            List<Utilisateur> specialistes = userService.getAllSpecialist();

            // Dans votre servlet/contrôleur
            Map<Specialite, List<Utilisateur>> specialistesParSpecialite = new LinkedHashMap<>();
            Map<Utilisateur, List<Creneau>> creneauxParSpecialiste = new HashMap<>();

            for (Utilisateur specialiste : specialistes) {
                List<Creneau> creneauxDisponibles = creneauService.getCreneauxDisponiblesBySpecialiste(specialiste);
                creneauxParSpecialiste.put(specialiste, creneauxDisponibles);
            }

            for (Specialite specialite : specialites) {
                List<Utilisateur> specialistesFiltres = specialistes.stream()
                        .filter(s -> s.getSpecialite() != null && s.getSpecialite().getId().equals(specialite.getId()))
                        .collect(Collectors.toList());

                specialistesParSpecialite.put(specialite, specialistesFiltres);
            }

            request.setAttribute("specialistesParSpecialite", specialistesParSpecialite);
            request.setAttribute("creneauxParSpecialiste", creneauxParSpecialiste);
            // Envoi des données à la JSP
            request.setAttribute("patient", patient);
            request.setAttribute("actesTechniques", ActeTechnique.values());
            request.setAttribute("specialites", specialites);
            request.getRequestDispatcher("/generaliste/creer-consultationGeneraliste.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/generaliste/creer-consultationGeneraliste.jsp?error=loading_failed");
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
            StatutConsultation status=  StatutConsultation.valueOf(statutStr);
            String[] actesSelectionnes = request.getParameterValues("actesTechniques");
            if (status == StatutConsultation.EN_ATTENTE_AVIS_SPECIALISTE) {

                Long id = Long.parseLong(request.getParameter("idSpicialiste"));
                String timeStr = request.getParameter("heure");
                String dateStr = request.getParameter("date");

                DateTimeFormatter dateFormatter = DateTimeFormatter.ISO_LOCAL_DATE;
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");


                try {
                    LocalDate localDate = LocalDate.parse(dateStr, dateFormatter);

                    LocalTime localTime = LocalTime.parse(timeStr, timeFormatter);

                    LocalDateTime dateHeure = LocalDateTime.of(localDate, localTime);

                    creneauService.changedisponiblete(id, dateHeure);

                } catch (java.time.format.DateTimeParseException e) {

                    e.printStackTrace();
                }
            }

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

//            try {
//                status = StatutConsultation.valueOf(statutStr);
//            } catch (IllegalArgumentException e) {
//                redirectUrl += "&error=invalid_statut";
//                response.sendRedirect(redirectUrl);
//                return;
//            }

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

            List<ActeTechnique> actes = new ArrayList<>();
            double coutTotalActes = 0;
            if (actesSelectionnes != null) {
                for (String acteName : actesSelectionnes) {
                    if (acteName != null && !acteName.trim().isEmpty()) {
                        try {
                            ActeTechnique acte = ActeTechnique.valueOf(acteName);
                            actes.add(acte);
                            coutTotalActes += acte.getCout();
                            System.out.println("Acte sélectionné : " + acte.getLibelle() + " (" + acte.getCout() + "(DH)");
                        } catch (IllegalArgumentException e) {
                            System.out.println("Acte inconnu : " + acteName);
                        }
                    }
                }
            }

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