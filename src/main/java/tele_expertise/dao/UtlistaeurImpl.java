package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import tele_expertise.dto.UtilisateurDTO;

public class UtlistaeurImpl {

    public void creerUtilisateur(UtilisateurDTO dto){
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("utlistaeurPU");
        EntityManager em = emf.createEntityManager();

        em.getTransaction().begin();
        em.persist(dto);
        em.getTransaction().commit();
        em.close();
    }
}
