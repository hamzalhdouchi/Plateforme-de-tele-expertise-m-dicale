package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.entity.Utilisateur;
import tele_expertise.mapper.mappers.UtilisateurMapper;

public class UtlistaeurImpl {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("tele_expertisePU");
    public void creerUtilisateur(Utilisateur user){
        try {
            EntityManager em = emf.createEntityManager();
            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public UtilisateurDTO loginutilisateur(Utilisateur utilisateur) {
        EntityManager em = emf.createEntityManager();
        Utilisateur user = null;

        try {
            user = em.createQuery(
                            "SELECT u FROM Utilisateur u WHERE u.email = :email", Utilisateur.class)
                    .setParameter("email", utilisateur.getEmail())
                    .getSingleResult();

            if (!user.getMotDePasse().equals(utilisateur.getMotDePasse())) {
                return null; 
            }

             UtilisateurDTO userloged =  UtilisateurMapper.toDTO(user);
            return userloged;

        } catch (jakarta.persistence.NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }



}
