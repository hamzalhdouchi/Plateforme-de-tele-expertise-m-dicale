package tele_expertise.servise;

import tele_expertise.dao.UtlistaeurImpl;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.util.userValidPattern;

import java.time.LocalDateTime;

public class UserService {

    private UtlistaeurImpl UtlistaeurImpl;

    public UserService(UtlistaeurImpl UtlistaeurImpl) {
        this.UtlistaeurImpl = UtlistaeurImpl;
    }

    public String save(UtilisateurDTO utilisateurDTO) {


        String userValid = userValidPattern.validerUtilisateur(utilisateurDTO);
        LocalDateTime now = LocalDateTime.now();

        if (userValid == null)
        {
            Utilisateur  utilisateur = new Utilisateur(null,utilisateurDTO.getNom(),utilisateurDTO.getPrenom(),utilisateurDTO.getEmail(),utilisateurDTO.getMotDePasse(),utilisateurDTO.getRole(),now,"actif");
        }
        return userValid;
    }
}
