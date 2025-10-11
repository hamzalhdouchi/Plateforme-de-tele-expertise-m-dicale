package tele_expertise.servlet;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tele_expertise.dao.PatientImpl;
import tele_expertise.entity.Patient;

import java.io.IOException;
import java.util.List;

@WebServlet("/RecherchePatient")
public class RecherchePatientServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException , IOException{


        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("loggedUser") == null ||
                !"INFIRMIER".equals(session.getAttribute("role").toString())) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        request.getRequestDispatcher("/patient/RecherchePatient.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchTerm = request.getParameter("searchTerm");

        try {
            PatientImpl dao =(PatientImpl) getServletContext().getAttribute("patientImpl");
            List<Patient> patients = dao.rechercherPatients(searchTerm);

            request.setAttribute("patients", patients);
            request.setAttribute("searchTerm", searchTerm);
            request.getRequestDispatcher("/patient/RecherchePatient.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la recherche : " + e.getMessage());
            request.getRequestDispatcher("/patient/RecherchePatient.jsp").forward(request, response);
        }
    }
}


