package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import tele_expertise.entity.SignesVitaux;

public class SignesVitauxImpl {

    private EntityManagerFactory emf;

    public SignesVitauxImpl(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public SignesVitaux save(SignesVitaux sv) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(sv);
            em.getTransaction().commit();
            return sv;
        } finally {
            em.close();
        }
    }

}
