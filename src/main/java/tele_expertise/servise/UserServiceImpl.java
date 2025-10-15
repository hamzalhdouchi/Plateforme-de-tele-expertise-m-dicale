package tele_expertise.servise;

import org.mindrot.jbcrypt.BCrypt;
import tele_expertise.dao.UtilisateurDaoImpl;
import tele_expertise.dao.UtilisateurDaoImpl;
import tele_expertise.entity.Specialite;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.servise.SpecialiteServiceImpl;

import java.util.List;

public class UserServiceImpl {

    private final UtilisateurDaoImpl utilisateurDao;
    private final SpecialiteServiceImpl specialiteService;

    public UserServiceImpl(UtilisateurDaoImpl utilisateurDao, SpecialiteServiceImpl specialiteService) {
        this.utilisateurDao = utilisateurDao;
        this.specialiteService = specialiteService;
    }

    public boolean registerUtilisateur(Utilisateur utilisateur, RoleUtilisateur role) {
        try {
            if (emailExists(utilisateur.getEmail())) return false;

            // Hachage mot de passe
            utilisateur.setMotDePasse(BCrypt.hashpw(utilisateur.getMotDePasse(), BCrypt.gensalt()));
            utilisateur.setRole(role);
            utilisateur.setActif(true);
            utilisateur.setDisponible(true);

            // Gestion spécialité pour SPECIALISTE
            if (role == RoleUtilisateur.SPECIALISTE) {
                Specialite specialite = specialiteService.getSpecialiteById(
                        utilisateur.getSpecialite().getId());
                if (specialite == null || utilisateur.getTarif() <= 0) return false;
                utilisateur.setSpecialite(specialite);
            } else {
                utilisateur.setSpecialite(null);
                utilisateur.setTarif(null);
            }

            return utilisateurDao.saveUtilisateur(utilisateur);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveUtilisateur(Utilisateur utilisateur) {
        return utilisateurDao.saveUtilisateur(utilisateur);
    }

    public Utilisateur getUserByEmail(String email) {
        return utilisateurDao.getUserByEmail(email);
    }

    public Utilisateur login(String email, String rawPassword) {
        Utilisateur user = getUserByEmail(email);
        if (user != null && BCrypt.checkpw(rawPassword, user.getMotDePasse())) {
            return user;
        }
        return null;
    }

    public Utilisateur getUserById(Long id) {
        return utilisateurDao.getUserById(id);
    }

    public boolean emailExists(String email) {
        return utilisateurDao.emailExists(email);
    }

    public List<Specialite> getAllSpecialites() {
        return specialiteService.getAllSpecialites();
    }

    public Specialite getSpecialiteById(Long id) {
        return specialiteService.getSpecialiteById(id);
    }

    public List<Utilisateur> getAllUsers()
    {
        return utilisateurDao.getAll();
    }
}