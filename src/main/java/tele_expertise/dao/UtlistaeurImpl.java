package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.entity.Utilisateur;

public class UtlistaeurImpl {

    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("utlistaeurPU");
    public void creerUtilisateur(Utilisateur user){
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("utlistaeurPU");
        EntityManager em = emf.createEntityManager();
        em.persist(user);
    }

}
