package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import tele_expertise.entity.Creneau;
import tele_expertise.entity.Utilisateur;


import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public class CreneauDAO {
    private EntityManagerFactory emf;

    public CreneauDAO() {
        this.emf = Persistence.createEntityManagerFactory("teleExpertisePU");
    }

    public Creneau save(Creneau creneau) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (creneau.getId() == null) {
                em.persist(creneau);
            } else {
                creneau = em.merge(creneau);
            }
            em.getTransaction().commit();
            return creneau;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde du créneau", e);
        } finally {
            em.close();
        }
    }

    public List<Creneau> findBySpecialisteId(Long specialisteId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT c FROM Creneau c WHERE c.specialiste.id = :specialisteId ORDER BY c.dateHeure ASC",
                            Creneau.class)
                    .setParameter("specialisteId", specialisteId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public int generateCreneauxForSpecialist(Utilisateur specialist) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            LocalDate startDate = LocalDate.now().plusDays(1);
            int creneauxCount = 0;

            for (int day = 0; day < 7; day++) {
                LocalDate currentDate = startDate.plusDays(day);

                LocalTime[] timeSlots = {
                        LocalTime.of(9, 0),
                        LocalTime.of(9, 30),
                        LocalTime.of(10, 0),
                        LocalTime.of(10, 30),
                        LocalTime.of(11, 0),
                        LocalTime.of(11, 30)
                };

                for (LocalTime time : timeSlots) {
                    Creneau creneau = new Creneau();
                    creneau.setSpecialiste(specialist);
                    creneau.setDateHeure(LocalDateTime.of(currentDate, time));
                    creneau.setDisponible(true);
                    creneau.setDureeMinutes(30);

                    em.persist(creneau);
                    creneauxCount++;
                }
            }

            em.getTransaction().commit();
            return creneauxCount;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la génération des créneaux", e);
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