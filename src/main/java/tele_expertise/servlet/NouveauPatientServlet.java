package tele_expertise.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tele_expertise.dto.PatientDTO;
import tele_expertise.dto.SignesVitauxDTO;
import tele_expertise.entity.Patient;
import tele_expertise.entity.SignesVitaux;
import tele_expertise.servise.PatientService;
import tele_expertise.servise.SignesVitauxService;
import tele_expertise.util.PatientValidPattern;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/NouveauPatient")
public class NouveauPatientServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException{


        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("loggedUser") == null ||
                !"INFIRMIER".equals(session.getAttribute("role").toString())) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        request.getRequestDispatcher("/infirmier/NouveauPatient.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        LocalDate dateDeNaissance = LocalDate.parse(request.getParameter("dateNaissance"));
        String nss = request.getParameter("numeroSecuriteSociale");
        String telephone = request.getParameter("telephone");
        String adresse = request.getParameter("adresse");

        double tensionSystolique = Double.parseDouble(request.getParameter("tensionSystolique"));
        double tensionDiastolique = Double.parseDouble(request.getParameter("tensionDiastolique"));
        int saturationOxygene = Integer.parseInt(request.getParameter("saturationOxygene"));
        double temperature = Double.parseDouble(request.getParameter("temperature"));
        int frequenceRespiratoire = Integer.parseInt(request.getParameter("frequenceRespiratoire"));

        PatientDTO patientDTO = new PatientDTO();
        patientDTO.setNom(nom);
        patientDTO.setPrenom(prenom);
        patientDTO.setDateDeNaissance(dateDeNaissance);
        patientDTO.setNSecuriteSociale(nss);
        patientDTO.setTelephone(telephone);
        patientDTO.setAdresse(adresse);

        PatientService patientService = (PatientService) getServletContext().getAttribute("patientService");
        SignesVitauxService svService = (SignesVitauxService) getServletContext().getAttribute("servicsSinng");

        String messageErreur = PatientValidPattern.validerPatient(
                nom, prenom, dateDeNaissance.toString(), nss, telephone, adresse,
                temperature, frequenceRespiratoire, tensionSystolique, tensionDiastolique, saturationOxygene
        );

        if (messageErreur != null) {
            request.setAttribute("error", messageErreur);
            request.getRequestDispatcher("/infirmier/NouveauPatient.jsp").forward(request, response);
            return;
        }

        PatientDTO savedPatientDTO = patientService.createPatient(patientDTO);
        if (savedPatientDTO == null) {
            request.setAttribute("error", "Erreur lors de la création du patient");
            request.getRequestDispatcher("/infirmier/NouveauPatient.jsp").forward(request, response);
            return;
        }

        Patient patientEntity = new Patient();
        patientEntity.setId(savedPatientDTO.getId());

        SignesVitauxDTO sv = svService.createForPatient(
                patientEntity, temperature, tensionSystolique, tensionDiastolique, frequenceRespiratoire, saturationOxygene
        );

        if (sv == null) {
            request.setAttribute("error", "Erreur lors de la création des signes vitaux");
            request.getRequestDispatcher("/infirmier/NouveauPatient.jsp").forward(request, response);
            return;
        }

        request.setAttribute("message", "insertion is successful");
        response.sendRedirect(request.getContextPath()+"/Home-Infirmier");
    }



}
