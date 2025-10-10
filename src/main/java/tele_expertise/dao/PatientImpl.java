package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.TypedQuery;
import tele_expertise.entity.Patient;

import java.util.List;

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

    public List<Patient> getAllPatientsWithSignesVitaux() {
        EntityManager em = rmf.createEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                    "SELECT p FROM Patient p JOIN FETCH p.signesVitaux", Patient.class);
            List<Patient> patients = query.getResultList();
            System.out.println("Patients fetched: " + patients.size()); // Debug
            for (Patient p : patients) {
                System.out.println("Patient: " + p.getNom() + ", SignesVitaux: " + p.getSignesVitaux());
            }
            return patients;
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

    public List<Patient> rechercherPatients(String searchTerm) {
        EntityManager em = rmf.createEntityManager();
        try {
            String jpql = "SELECT p FROM Patient p WHERE " +
                    "LOWER(p.nom) LIKE :term OR LOWER(p.prenom) LIKE :term OR p.NSecuriteSociale LIKE :term";

            TypedQuery<Patient> query = em.createQuery(jpql, Patient.class);
            query.setParameter("term", "%" + searchTerm.toLowerCase() + "%");


            return query.getResultList();
        } finally {
            em.close();
        }
    }

}
