package tele_expertise.servlet;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tele_expertise.dao.PatientImpl;
import tele_expertise.entity.Patient;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.servise.PatientService;

import java.io.IOException;
import java.util.List;

@WebServlet("/Home-Infirmier")
public class accueilDachServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws  IOException, ServletException {
        HttpSession session = request.getSession(false);

    String role = session.getAttribute("role").toString();


        // ne crée pas de nouvelle session
        if (session == null || session.getAttribute("loggedUser") == null || session.getAttribute("role") != RoleUtilisateur.INFIRMIER) {
            request.setAttribute("error", "Session expired");
            request.getRequestDispatcher("Login.jsp").forward(request, response);


        } else {
            PatientService service =(PatientService) getServletContext().getAttribute("patientService");

            List<Patient> ps = service.getAllPatients();
            request.setAttribute("ps", ps);
            System.out.println("Patients trouvés: " + ps.size()); // Debug

            request.getRequestDispatcher("/infirmier/accueilDach.jsp").forward(request, response);
        }

    }

}
