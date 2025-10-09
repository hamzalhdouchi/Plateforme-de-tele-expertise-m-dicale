package tele_expertise.servise;

import tele_expertise.dao.SignesVitauxImpl;
import tele_expertise.dto.SignesVitauxDTO;
import tele_expertise.entity.Patient;
import tele_expertise.entity.SignesVitaux;
import tele_expertise.mapper.SignesVitauxMapper;

public class SignesVitauxService {

    private SignesVitauxImpl dao;

    public SignesVitauxService(SignesVitauxImpl dao) {
        this.dao = dao;
    }

    public SignesVitauxDTO createForPatient(Patient patient, double temperature,
                                            double tensionSystolique, double tensionDiastolique, int frequenceRespiratoire,
                                            int saturation) {

        SignesVitaux sv = new SignesVitaux();
        sv.setPatient(patient); // Link with patient
        sv.setTemperature(temperature);
        sv.setTensionsystolique(tensionSystolique);
        sv.setTensiondiastolique(tensionDiastolique);
        sv.setFrequencerespiratoire(frequenceRespiratoire);
        sv.setSaturation(saturation);

        dao.save(sv);

        return SignesVitauxMapper.toDTO(sv);
    }
}
