package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import tele_expertise.entity.Patient;

public class PatientImpl {

    private static EntityManagerFactory rmf;

    public PatientImpl(EntityManagerFactory rmf) {
        this.rmf = rmf;
    }


    public boolean enregistrerPatient (Patient p) {
        try {
            EntityManager em = rmf.createEntityManager();
            em.getTransaction().begin();
            em.persist(p);
            em.getTransaction().commit();
            em.close();
            return true;
        }catch (Exception e){
            System.out.println("gjdfgjjgdjgkfd"+ e.getMessage());
            return false;
        }
    }

}
