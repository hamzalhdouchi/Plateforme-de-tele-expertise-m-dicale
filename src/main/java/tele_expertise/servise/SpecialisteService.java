package tele_expertise.servise;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import tele_expertise.entity.Utilisateur;

import java.util.List;

public class SpecialisteService {
    private EntityManagerFactory emf;

    public SpecialisteService(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public Utilisateur findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            Utilisateur user = em.find(Utilisateur.class, id);
            if (user != null && "SPECIALISTE".equals(user.getRole())) {
                return user;
            }
            return null;
        } finally {
            em.close();
        }
    }

    public List<Utilisateur> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM Utilisateur u WHERE u.role = 'SPECIALISTE'",
                            Utilisateur.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Utilisateur> findBySpecialiteId(Long specialiteId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM Utilisateur u WHERE u.role = 'SPECIALISTE' AND u.specialite.id = :specialiteId",
                            Utilisateur.class)
                    .setParameter("specialiteId", specialiteId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public void update(Utilisateur specialiste) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(specialiste);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
