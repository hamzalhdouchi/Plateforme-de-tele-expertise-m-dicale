package tele_expertise.servise;

import org.mindrot.jbcrypt.BCrypt;
import tele_expertise.dao.UtlistaeurImpl;
import tele_expertise.dto.UtilisateurDTO;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.mapper.mappers.UtilisateurMapper;
import tele_expertise.util.userValidPattern;

import java.time.LocalDateTime;

public class UserService {

    private UtlistaeurImpl utlistaeurImpl;

    public UserService(UtlistaeurImpl UtlistaeurImpl) {
        this.utlistaeurImpl = UtlistaeurImpl;
    }

    public String save(UtilisateurDTO utilisateurDTO) {


        String userValid = userValidPattern.validerUtilisateur(utilisateurDTO);
        if (userValid == null)
        {

            String mp = BCrypt.hashpw(utilisateurDTO.getMotDePasse(), BCrypt.gensalt(12));
            utilisateurDTO.setMotDePasse(mp);
            Utilisateur user = UtilisateurMapper.toEntity(utilisateurDTO);
            utlistaeurImpl.creerUtilisateur(user);
        }
        return userValid;
    }
    public UtilisateurDTO getUser(Utilisateur utilisateur) {
        try {
            if (userValidPattern.estEmailValide(utilisateur.getEmail())) {
                UtilisateurDTO dto = utlistaeurImpl.loginutilisateur(utilisateur);
                if (dto != null) {
                    System.out.println("Login réussi pour : " + dto.getNom());
                    return dto;
                } else {
                    System.out.println("Email ou mot de passe incorrect");
                }
            } else {
                System.out.println("L'email n'est pas valide");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
