package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import tele_expertise.entity.Consultation;

import java.util.List;

public class ConsultationDAO {
    private EntityManagerFactory emf;

    public ConsultationDAO(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public Consultation findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Consultation.class, id);
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByPatientId(int patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT c FROM Consultation c WHERE c.patient.id = :patientId", Consultation.class)
                    .setParameter("patientId", patientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Consultation save(Consultation consultation) {
        EntityManager em = emf.createEntityManager();
        Consultation managedConsultation = consultation; // Initialisation pour la fusion

        try {
            em.getTransaction().begin();

            if (consultation.getId() == null) {
                em.persist(consultation);
                managedConsultation = consultation;
            } else {
                managedConsultation = em.merge(consultation);
            }

            em.getTransaction().commit();

            // On retourne l'entité gérée, qui contient l'ID (soit généré, soit existant)
            return managedConsultation;

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde de la consultation", e);
        } finally {
            em.close();
        }
    }

//    public void close() {
//        if (emf != null && emf.isOpen()) {
//            emf.close();
//        }
//    }

    public List<Consultation> getConsultationsRecentes(Long medecinId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT c FROM Consultation c " +
                    "JOIN FETCH c.patient p " +
                    "WHERE c.medecinGeneraliste.id = :idMedecin " +
                    "ORDER BY c.dateConsultation DESC";

            TypedQuery<Consultation> query = em.createQuery(jpql, Consultation.class);
            query.setParameter("idMedecin", medecinId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public void update(Consultation consultation) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(consultation);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour de la consultation", e);
        } finally {
            em.close();
        }
    }

    public List<Consultation> getAll() {
        EntityManager em = emf.createEntityManager();
        try {
            List<Consultation> list = em.createQuery(
                            "SELECT c FROM Consultation c LEFT JOIN FETCH c.patient", Consultation.class)
                    .getResultList();
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}