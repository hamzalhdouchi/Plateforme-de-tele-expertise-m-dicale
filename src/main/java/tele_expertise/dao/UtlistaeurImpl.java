package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.entity.Utilisateur;

public class UtlistaeurImpl {

    public void creerUtilisateur(Utilisateur user){
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("utlistaeurPU");
        EntityManager em = emf.createEntityManager();
        em.persist(user);
    }

}
