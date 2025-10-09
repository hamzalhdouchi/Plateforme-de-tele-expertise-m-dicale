package tele_expertise.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
        request.getRequestDispatcher("/patient/NouveauPatient.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- 1. Patient parameters ---
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        LocalDate dateDeNaissance = LocalDate.parse(request.getParameter("dateNaissance"));
        String nss = request.getParameter("numeroSecuriteSociale");
        String telephone = request.getParameter("telephone");
        String adresse = request.getParameter("adresse");

        // --- 2. Vital signs parameters ---
        double tensionSystolique = Integer.parseInt(request.getParameter("tensionSystolique"));
        double tensionDiastolique = Integer.parseInt(request.getParameter("tensionDiastolique"));
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
                nom,
                prenom,
                dateDeNaissance.toString(),
                nss,
                telephone,
                adresse,
                temperature,
                frequenceRespiratoire,
                tensionSystolique,
                tensionDiastolique,
                saturationOxygene
        );
        if (messageErreur != null) {
            request.setAttribute("error", messageErreur);
            request.getRequestDispatcher("/patient/NouveauPatient.jsp").forward(request, response);
        }
        PatientDTO savedPatientDTO = patientService.createPatient(patientDTO);
        if (savedPatientDTO == null) {
            request.setAttribute("error", "Patient n'existe pas");
            request.getRequestDispatcher("/patient/NouveauPatient.jsp").forward(request, response);
        }

        Patient patientEntity = new Patient();
        patientEntity.setId(savedPatientDTO.getId());
        SignesVitauxDTO sv= svService.createForPatient(patientEntity, temperature, tensionSystolique, tensionDiastolique, frequenceRespiratoire, saturationOxygene);

        if (sv == null) {
            request.setAttribute("error", "Patient n'existe pas");
            request.getRequestDispatcher("/patient/NouveauPatient.jsp").forward(request, response);
        }
        request.setAttribute("message", "Patient et signes vitaux créés avec succès !");
        request.getRequestDispatcher("/patient/NouveauPatient.jsp").forward(request, response);
    }



}
