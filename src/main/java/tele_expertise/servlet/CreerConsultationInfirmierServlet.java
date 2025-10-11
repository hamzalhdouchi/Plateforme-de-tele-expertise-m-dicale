package tele_expertise.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tele_expertise.dto.PatientDTO;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.entity.Consultation;
import tele_expertise.entity.Patient;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.enums.StatusPatient;
import tele_expertise.servise.ConsultationService;
import tele_expertise.servise.PatientService;
import tele_expertise.servise.UserService;


import java.io.IOException;
import java.util.List;

@WebServlet("/infirmier/creer-consultation")
public class CreerConsultationInfirmierServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        UserService userService = (UserService) req.getServletContext().getAttribute("userService");

        HttpSession session = req.getSession(false);
        String role = session.getAttribute("role").toString();

        if (session == null || session.getAttribute("loggedUser") == null ||
                !"INFIRMIER".equals(session.getAttribute("role").toString())) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }
        try {
            String patientIdParam = req.getParameter("patientId");
            if (patientIdParam == null || patientIdParam.isEmpty()) {
                session.setAttribute("error", "ID du patient manquant");
                resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");
                return;
            }

            int patientId = Integer.parseInt(patientIdParam);
            PatientService serviceP =(PatientService) getServletContext().getAttribute("patientService");
            Patient patient = serviceP.getPatientById(patientId);

            if (patient.getStatus().equals(StatusPatient.EN_COURS)){
                session.setAttribute("error", "Patient déga consulté");
                resp.sendRedirect(req.getContextPath() + "/Home-Infirmier");
                return;
            }

            if (patient == null) {
                session.setAttribute("error", "Patient introuvable");
                resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");
                return;
            }

            List<Utilisateur> users = userService.getUsers();
            List<Utilisateur> generalistes = users.stream().filter(u -> u.getRole().equals(RoleUtilisateur.GENERALISTE)).toList();
            System.out.println("the generalistes are: " + patient.getSignesVitaux());
            req.setAttribute("patient", patient);
            req.setAttribute("generalistes", generalistes);


            req.getRequestDispatcher("/patient/creer-consultation.jsp")
                    .forward(req, resp);

        } catch (NumberFormatException e) {
            session = req.getSession();
            session.setAttribute("error", "ID du patient invalide");
            resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Erreur lors du chargement : " + e.getMessage());
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        PatientService serviceP =(PatientService) getServletContext().getAttribute("patientService");
        UserService userService = (UserService) req.getServletContext().getAttribute("userService");
        ConsultationService consultationService = (ConsultationService) getServletContext().getAttribute("consultationService");
        HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("loggedUser") == null ||
                    !"INFIRMIER".equals(session.getAttribute("role").toString())) {
                resp.sendRedirect(req.getContextPath() + "/Login");
                return;
            }
        try {
            String patientIdParam = req.getParameter("patientId");
            String generalisteIdParam = req.getParameter("generalisteId");

            if (patientIdParam == null || patientIdParam.isEmpty() ||
                    generalisteIdParam == null || generalisteIdParam.isEmpty()) {
                session.setAttribute("error", "Paramètres manquants pour créer la consultation");
                resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");
                return;
            }

            int patientId = Integer.parseInt(patientIdParam);
            Long generalisteId = Long.parseLong(generalisteIdParam);
            Patient patient = serviceP.getPatientById(patientId);



            List<Utilisateur> generalisteListe = userService.getUsers();

            Utilisateur generaliste = generalisteListe.stream().filter(g -> g.getId().equals(generalisteId)).findFirst().get();

            if (patient == null) {
                session.setAttribute("error", "Patient introuvable");
                resp.sendRedirect(req.getContextPath() + "/Home-Infirmier");
                return;
            }

            if (patient.getStatus().equals(StatusPatient.EN_COURS)){
                session.setAttribute("error", "Patient déga consulté");
                resp.sendRedirect(req.getContextPath() + "/Home-Infirmier");
                return;
            }
            if (generaliste == null) {
                session.setAttribute("error", "Médecin généraliste introuvable");
                resp.sendRedirect(req.getContextPath() + "/Home-Infirmier");
                return;
            }

            Consultation consultation = new Consultation();
            consultation.setPatient(patient);
            consultation.setMedecinGeneraliste(generaliste);
                String name = ((UtilisateurDTO) session.getAttribute("loggedUser")).getNom();
                System.out.println("Utilisateur connecté : " + name);
                    consultation.setMotif("Consultation créée par l'infirmier " +name);


            consultation.setObservations("En attente d'examen par le médecin généraliste");


            consultationService.save(consultation);


            serviceP.UpadateStatus(patient.getId(),StatusPatient.EN_COURS);

            session.setAttribute("success",
                    "Consultation créée avec succès pour " + patient.getNom() + " " + patient.getPrenom() +
                            " avec Dr. " + generaliste.getNom());

            resp.sendRedirect(req.getContextPath() + "/Home-Infirmier");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Format d'ID invalide");
            resp.sendRedirect(req.getContextPath() + "/Home-Infirmier");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de la création de la consultation : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/Home-Infirmier");
        }
    }

}
