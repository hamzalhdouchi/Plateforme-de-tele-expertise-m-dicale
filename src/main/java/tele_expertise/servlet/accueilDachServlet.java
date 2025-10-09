package tele_expertise.servlet;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/Home-Infirmier")
public class accueilDachServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws  IOException, ServletException {
        HttpSession session = request.getSession(false); // ne crée pas de nouvelle session
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
        } else {
            request.getRequestDispatcher("/patient/accueilDach.jsp").forward(request, response);
        }

    }
}
