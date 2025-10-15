package tele_expertise.dao;

import jakarta.persistence.*;
import tele_expertise.entity.Utilisateur;
import java.util.List;

public class UtilisateurDaoImpl {

    private final EntityManagerFactory emf;

    public UtilisateurDaoImpl(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public void creerUtilisateur(Utilisateur user) {
        saveUtilisateur(user);
    }

    public boolean saveUtilisateur(Utilisateur utilisateur) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (utilisateur.getId() == null) {
                em.persist(utilisateur);
            } else {
                em.merge(utilisateur);
            }
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public Utilisateur getUserByEmail(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                            "SELECT u FROM Utilisateur u WHERE LOWER(u.email) = LOWER(:email) AND u.actif = true",
                            Utilisateur.class)
                    .setParameter("email", email);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public Utilisateur getUserById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Utilisateur.class, id);
        } finally {
            em.close();
        }
    }



    public List<Utilisateur> getAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                    "SELECT u FROM Utilisateur u WHERE u.actif = true ORDER BY u.dateCreation DESC",
                    Utilisateur.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    public boolean emailExists(String email) {
        return getUserByEmail(email) != null;
    }
}