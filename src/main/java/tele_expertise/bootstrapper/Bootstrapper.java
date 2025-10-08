package tele_expertise.bootstrapper;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import tele_expertise.dao.PatientImpl;
import tele_expertise.dao.UtlistaeurImpl;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.servise.UserService;

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
            PatientImpl pl =  new PatientImpl(emf);
//
            sce.getServletContext().setAttribute("utilisateurDTO", utilisateurDTO);
//            // Store in ServletContext so servlets/filters can access
            sce.getServletContext().setAttribute("userService", userService);
        }

        @Override
        public void contextDestroyed(ServletContextEvent sce) {
            // Optional cleanup
        }
    }

