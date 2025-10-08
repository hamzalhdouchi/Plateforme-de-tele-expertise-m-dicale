package tele_expertise.dao;

import jakarta.persistence.EntityManagerFactory;

public class SignesVitauxImpl {

    private EntityManagerFactory emf;

    public SignesVitauxImpl(EntityManagerFactory emf) {
        this.emf = emf;
    }
}
