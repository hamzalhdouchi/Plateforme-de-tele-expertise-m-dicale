package tele_expertise.servise;

import tele_expertise.dao.UtlistaeurImpl;
import tele_expertise.dto.UtilisateurDTO;

public class UserService {

    private UtlistaeurImpl UtlistaeurImpl;

    public UserService(UtlistaeurImpl UtlistaeurImpl) {
        this.UtlistaeurImpl = UtlistaeurImpl;
    }

    public void save(UtilisateurDTO utilisateurDTO) {

        String nom = utilisateurDTO.getNom();
        String prenom = utilisateurDTO.getPrenom();
        String email = utilisateurDTO.getEmail();
        String telephone = utilisateurDTO.getTelephone();
        String motDePasse = utilisateurDTO.getMotDePasse();


    }
}
