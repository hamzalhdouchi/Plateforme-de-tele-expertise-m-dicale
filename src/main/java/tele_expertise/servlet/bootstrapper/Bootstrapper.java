package tele_expertise.servlet.bootstrapper;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

    @WebListener
    public class Bootstrapper implements ServletContextListener {

        @Override
        public void contextInitialized(ServletContextEvent sce) {
            System.out.println("Bootstrapping dependencies...");

            // Example: create your "services" and inject dependencies manually

            // Store in ServletContext so servlets/filters can access
            sce.getServletContext().setAttribute("userService", );
        }

        @Override
        public void contextDestroyed(ServletContextEvent sce) {
            // Optional cleanup
        }
    }

