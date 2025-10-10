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

@WebServlet("/Home-Infirmier")
public class accueilDachServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws  IOException, ServletException {
        HttpSession session = request.getSession(false); // ne crée pas de nouvelle session
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
        } else {
            PatientImpl dao =(PatientImpl) getServletContext().getAttribute("patientImpl");

            List<Patient> ps = dao.getAllPatientsWithSignesVitaux();
            request.setAttribute("ps", ps);
            System.out.println("Patients trouvés: " + ps.size()); // Debug

            request.getRequestDispatcher("/patient/accueilDach.jsp").forward(request, response);
        }

    }

}
