package tele_expertise.servlet;

import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.servise.UserService;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/patient-list")
public class patientListServlet extends HttpServlet {


    public void init(){

    }
}
