package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import tele_expertise.entity.Patient;

public class PatientImpl {

    private static EntityManagerFactory rmf;

    public PatientImpl(EntityManagerFactory rmf) {
        this.rmf = rmf;
    }

        public Patient save(Patient patient) {
            EntityManager em = rmf.createEntityManager();
            try {
                em.getTransaction().begin();
                em.persist(patient);
                em.getTransaction().commit();
                return patient;
            } finally {
                em.close();
            }
        }

        public Patient findById(int id) {
            EntityManager em = rmf.createEntityManager();
            try {
                return em.find(Patient.class, id);
            } finally {
                em.close();
            }
        }

}
