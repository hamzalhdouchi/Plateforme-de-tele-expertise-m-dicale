package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.TypedQuery;
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


    public SignesVitaux findByPatientId(int patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<SignesVitaux> query = em.createQuery(
                    "SELECT s FROM SignesVitaux s WHERE s.patient.id = :pid", SignesVitaux.class);
            query.setParameter("pid", patientId);
            return query.getResultStream().findFirst().orElse(null);
        } finally {
            em.close();
        }
    }

    public void saveOrUpdate(SignesVitaux sv) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (sv.getId() == 0) {
                em.persist(sv);
            } else {
                em.merge(sv);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

}
