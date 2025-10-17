package tele_expertise.bootstrapper;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import tele_expertise.dao.*;
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
            UtilisateurDaoImpl UtlistaeurImpl = new UtilisateurDaoImpl(emf);
            SpecialiteDaoImpl specialiteDao = new SpecialiteDaoImpl(emf);
            SpecialiteServiceImpl specialiteService = new SpecialiteServiceImpl(specialiteDao);
            UserServiceImpl userService = new UserServiceImpl(UtlistaeurImpl,specialiteService);
            UtilisateurDTO  utilisateurDTO = new UtilisateurDTO();
            SignesVitauxImpl  sv = new SignesVitauxImpl(emf);
            SignesVitauxService servicsSinng = new  SignesVitauxService(sv);
            PatientImpl patient = new PatientImpl(emf);
            ConsultationDAO consultationDAO = new ConsultationDAO(emf);
            ConsultationService consultationService = new ConsultationService(consultationDAO);
            PatientService service = new PatientService(patient);
            CreneauService creneauService = new CreneauService(emf);
            SpecialisteService specialisteService = new SpecialisteService(emf);
            DemandeExpertiseDAO demandeExpertiseDAO = new DemandeExpertiseDAO(emf);
            DemandeExpertiseService demandeExpertiseService = new DemandeExpertiseService(demandeExpertiseDAO);




            sce.getServletContext().setAttribute("specialisteService", specialisteService);
            sce.getServletContext().setAttribute("creneauService", creneauService);


            sce.getServletContext().setAttribute("demandeExpertiseService", demandeExpertiseService);
            sce.getServletContext().setAttribute("specialiteService", specialiteService);

            sce.getServletContext().setAttribute("Sign", sv);
            sce.getServletContext().setAttribute("patientService", service);
            sce.getServletContext().setAttribute("servicsSinng", servicsSinng);
            sce.getServletContext().setAttribute("patientImpl", patient);


            PatientDTO p = new PatientDTO();
            sce.getServletContext().setAttribute("patientDTO", p);
            sce.getServletContext().setAttribute("utilisateurDTO", utilisateurDTO);
            sce.getServletContext().setAttribute("UtlistaeurImpl", UtlistaeurImpl);

//            // Store in ServletContext so servlets/filters can access
            sce.getServletContext().setAttribute("userService", userService);
            sce.getServletContext().setAttribute("consultationService", consultationService);
        }

        @Override
        public void contextDestroyed(ServletContextEvent sce) {
            // Optional cleanup
        }
    }

