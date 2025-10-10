package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.mindrot.jbcrypt.BCrypt;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.entity.Utilisateur;
import tele_expertise.mapper.UtilisateurMapper;

import java.util.List;

public class UtlistaeurImpl {

    private  EntityManagerFactory emf;

    public UtlistaeurImpl(EntityManagerFactory emf){
        this.emf = emf;
    }
    public void creerUtilisateur(Utilisateur user){
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
        }catch(Exception e){
            e.printStackTrace();
        }finally {
            em.close();
        }
    }

    public UtilisateurDTO loginutilisateur(UtilisateurDTO dto) {
        EntityManager em = emf.createEntityManager();
        try {
            Utilisateur user = em.createQuery(
                            "SELECT u FROM Utilisateur u WHERE u.email = :email", Utilisateur.class)
                    .setParameter("email", dto.getEmail())
                    .getSingleResult();

            if (BCrypt.checkpw(dto.getMotDePasse(), user.getMotDePasse())) {
                return UtilisateurMapper.toDTO(user);
            } else {
                System.out.println("Le mot de passe est incorrect");
                return null;
            }

        } catch (jakarta.persistence.NoResultException e) {
            System.out.println("Utilisateur non trouvé avec cet email");
            return null;
        } catch (Exception e) {
            System.out.println("Erreur lors de la connexion : " + e.getMessage());
            return null;
        } finally {
            em.close();
        }
    }

    public List<Utilisateur> getAll(){
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM Utilisateur u", Utilisateur.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }


}
