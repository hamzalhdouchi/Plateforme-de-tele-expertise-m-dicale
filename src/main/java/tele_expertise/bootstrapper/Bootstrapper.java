package tele_expertise.bootstrapper;
import tele_expertise.dao.UtlistaeurImpl;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.servise.UserService;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

    @WebListener
    public class Bootstrapper implements ServletContextListener {

        @Override
        public void contextInitialized(ServletContextEvent sce) {
            System.out.println("Bootstrapping dependencies...");

            // Example: create your "services" and inject dependencies manually
            UtlistaeurImpl UtlistaeurImpl = new UtlistaeurImpl();
            UserService userService = new UserService(UtlistaeurImpl);
            UtilisateurDTO  utilisateurDTO = new UtilisateurDTO();
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

