package tele_expertise.dao;

import jakarta.persistence.*;
import tele_expertise.entity.Specialite;
import java.util.List;

public class SpecialiteDaoImpl {

    private final EntityManagerFactory emf;

    public SpecialiteDaoImpl(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public List<Specialite> getAllSpecialites() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Specialite> query = em.createQuery(
                    "SELECT s FROM Specialite s WHERE s.isDeleted = false ORDER BY s.nom ASC",
                    Specialite.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Specialite getSpecialiteById(Long id) {
        if (id == null || id <= 0) return null;
        EntityManager em = emf.createEntityManager();
        try {
            Specialite specialite = em.find(Specialite.class, id);
            return specialite != null && !specialite.getIsDeleted() ? specialite : null;
        } finally {
            em.close();
        }
    }

    public Specialite getSpecialiteByNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) return null;
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Specialite> query = em.createQuery(
                            "SELECT s FROM Specialite s WHERE LOWER(s.nom) = LOWER(:nom) AND s.isDeleted = false",
                            Specialite.class)
                    .setParameter("nom", nom.trim());
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

    public void saveSpecialite(Specialite specialite) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (specialite.getId() == null) {
                em.persist(specialite);
            } else {
                em.merge(specialite);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur sauvegarde spécialité", e);
        } finally {
            em.close();
        }
    }

    public Specialite updateSpecialite(Specialite specialite) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Specialite updated = em.merge(specialite);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur mise à jour spécialité", e);
        } finally {
            em.close();
        }
    }

    public boolean deleteSpecialite(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Specialite specialite = em.find(Specialite.class, id);
            if (specialite != null) {
                specialite.setIsDeleted(true);
                em.merge(specialite);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().commit();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        } finally {
            em.close();
        }
    }

    public boolean specialiteExists(String nom) {
        return getSpecialiteByNom(nom) != null;
    }

    public List<Specialite> getTopSpecialites(int limit) {
        if (limit <= 0) limit = 5;
        // Simplifié - retourne les premières spécialités
        List<Specialite> all = getAllSpecialites();
        return all.subList(0, Math.min(limit, all.size()));
    }
}