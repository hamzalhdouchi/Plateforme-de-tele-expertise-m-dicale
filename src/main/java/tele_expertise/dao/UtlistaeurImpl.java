package tele_expertise.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.mindrot.jbcrypt.BCrypt;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.entity.Utilisateur;
import tele_expertise.mapper.UtilisateurMapper;

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


}
