package tele_expertise.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import tele_expertise.dao.PatientImpl;
import tele_expertise.dao.SignesVitauxImpl;
import tele_expertise.entity.Patient;
import tele_expertise.entity.SignesVitaux;

import java.io.IOException;

@WebServlet("/update-vitals")
public class UpdateVitalsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("loggedUser") == null ||
                !"INFIRMIER".equals(session.getAttribute("role").toString())) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        String patientIdStr = request.getParameter("patientId");
        int patientId = Integer.parseInt(patientIdStr);

        SignesVitauxImpl dao = (SignesVitauxImpl) getServletContext().getAttribute("Sign");
        SignesVitaux sv = dao.findByPatientId(patientId); // méthode à créer dans DAO

        request.setAttribute("signesVitaux", sv);
        request.setAttribute("patientId", patientId);
        request.getRequestDispatcher("/patient/update-vitals.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int patientId = Integer.parseInt(request.getParameter("patientId"));
        double temperature = Double.parseDouble(request.getParameter("temperature"));
        double tensionS = Double.parseDouble(request.getParameter("tensionSystolique"));
        double tensionD = Double.parseDouble(request.getParameter("tensionDiastolique"));
        int frequenceResp = Integer.parseInt(request.getParameter("frequenceRespiratoire"));
        double saturation = Double.parseDouble(request.getParameter("saturation"));
        SignesVitauxImpl dao = (SignesVitauxImpl) getServletContext().getAttribute("Sign");
        SignesVitaux sv = dao.findByPatientId(patientId);

        PatientImpl pl = (PatientImpl) request.getServletContext().getAttribute("patientImpl");
        if (sv == null) {
            sv = new SignesVitaux();

            Patient patient = pl.findById(patientId);
            sv.setPatient(patient);
        }

        sv.setTemperature(temperature);
        sv.setTensionsystolique(tensionS);
        sv.setTensiondiastolique(tensionD);
        sv.setFrequencerespiratoire(frequenceResp);
        sv.setSaturation(saturation);

        dao.saveOrUpdate(sv); // méthode à implémenter pour insert/update

        response.sendRedirect(request.getContextPath() + "/Home-Infirmier"); // ou page de retour
    }
}
