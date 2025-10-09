package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import tele_expertise.entity.SignesVitaux;

public class SignesVitauxImpl {

    private EntityManagerFactory emf;

    public SignesVitauxImpl(EntityManagerFactory emf) {
        this.emf = emf;
    }

//    public boolean enregistrer(SignesVitaux sv){
//
//        try{
//            EntityManager em = emf.createEntityManager();
//            em.getTransaction().begin();
//            em.persist(sv);
//            em.getTransaction().commit();
//            em.close();
//        }catch(Exception e){
//            System.out.println("gjdfgjjgdjgkfd"+ e.getMessage());
//            return false;
//        }
//    }
}
