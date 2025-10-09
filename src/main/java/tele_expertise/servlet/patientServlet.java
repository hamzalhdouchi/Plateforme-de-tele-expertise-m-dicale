package tele_expertise.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tele_expertise.dto.PatientDTO;
import tele_expertise.mapper.patientMapper;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/patient")
public class patientServlet extends HttpServlet {


    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String patient = req.getParameter("action");


    }

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String csrfP = req.getParameter("csrf");
        String csrfS=  req.getSession().getAttribute("csrf").toString();

        if (!csrfS.equals(csrfP)) {
            req.setAttribute("error","Csrf invalid");
        }

        String nom =  req.getParameter("nom");
        String prenom =  req.getParameter("prenom");
        String adres =  req.getParameter("adres");
        String telephone =  req.getParameter("telephone");
        String Nsocial =  req.getParameter("Nsocial");
        LocalDate dateDeNaissance = LocalDate.parse(req.getParameter("dateDeNaissance"));

        PatientDTO p = (PatientDTO) req.getServletContext().getAttribute("patientDTO");

        p.setNom(nom);
        p.setPrenom(prenom);
        p.setAdresse(adres);
        p.setTelephone(telephone);
        p.setDateDeNaissance(dateDeNaissance);
        p.setNSecuriteSociale(Nsocial);



    }
}
