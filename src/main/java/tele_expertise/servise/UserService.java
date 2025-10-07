package tele_expertise.servise;

import tele_expertise.dao.UtlistaeurImpl;
import tele_expertise.dto.UtilisateurDTO;

public class UserService {

    private UtlistaeurImpl UtlistaeurImpl;

    public UserService(UtlistaeurImpl UtlistaeurImpl) {
        this.UtlistaeurImpl = UtlistaeurImpl;
    }

    public void save(UtilisateurDTO utilisateurDTO) {


    }
}
