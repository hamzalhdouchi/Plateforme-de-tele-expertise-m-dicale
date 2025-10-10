package tele_expertise.bootstrapper;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import tele_expertise.dao.ConsultationDAO;
import tele_expertise.dao.PatientImpl;
import tele_expertise.dao.SignesVitauxImpl;
import tele_expertise.dao.UtlistaeurImpl;
import tele_expertise.dto.PatientDTO;
import tele_expertise.dto.SignesVitauxDTO;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.mapper.patientMapper;
import tele_expertise.servise.*;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

    @WebListener
    public class Bootstrapper implements ServletContextListener {

        @Override
        public void contextInitialized(ServletContextEvent sce) {
            System.out.println("Bootstrapping dependencies...");

            EntityManagerFactory emf = Persistence.createEntityManagerFactory("tele_expertisePU");
            UtlistaeurImpl UtlistaeurImpl = new UtlistaeurImpl(emf);
            UserService userService = new UserService(UtlistaeurImpl);
            UtilisateurDTO  utilisateurDTO = new UtilisateurDTO();
            SignesVitauxImpl  sv = new SignesVitauxImpl(emf);
            SignesVitauxService servicsSinng = new  SignesVitauxService(sv);
            PatientImpl patient = new PatientImpl(emf);
            ConsultationDAO consultationDAO = new ConsultationDAO(emf);
            ConsultationService consultationService = new ConsultationService(consultationDAO);
            PatientService service = new PatientService(patient);


            sce.getServletContext().setAttribute("Sign", sv);
            sce.getServletContext().setAttribute("patientService", service);
            sce.getServletContext().setAttribute("servicsSinng", servicsSinng);
            sce.getServletContext().setAttribute("patientImpl", patient);


            PatientDTO p = new PatientDTO();
            sce.getServletContext().setAttribute("patientDTO", p);
            sce.getServletContext().setAttribute("utilisateurDTO", utilisateurDTO);
//            // Store in ServletContext so servlets/filters can access
            sce.getServletContext().setAttribute("userService", userService);
            sce.getServletContext().setAttribute("consultationService", consultationService);
        }

        @Override
        public void contextDestroyed(ServletContextEvent sce) {
            // Optional cleanup
        }
    }

