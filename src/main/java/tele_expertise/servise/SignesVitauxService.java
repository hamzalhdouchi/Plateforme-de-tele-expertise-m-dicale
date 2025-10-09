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


    public SignesVitauxDTO getSignesVitauxByPatientId(int patientId) {
        SignesVitaux sv = dao.findByPatientId(patientId);
        if (sv == null) return null;

        SignesVitauxDTO dto = new SignesVitauxDTO();
        dto.setId(patientId);
        dto.setTemperature(sv.getTemperature());
        dto.setTensionSystolique(sv.getTensionsystolique());
        dto.setTensionDiastolique(sv.getTensiondiastolique());
        dto.setFrequenceRespiratoire(sv.getFrequencerespiratoire());
        dto.setSaturation(sv.getSaturation());
        return dto;
    }

    public void updateSignesVitaux(SignesVitauxDTO dto, Patient patient) {
        SignesVitaux sv = dao.findByPatientId(dto.getId());
        if (sv == null) {
            sv = new SignesVitaux();
            sv.setPatient(patient);
        }

        sv.setTemperature(dto.getTemperature());
        sv.setTensionsystolique(dto.getTensionSystolique());
        sv.setTensiondiastolique(dto.getTensionDiastolique());
        sv.setFrequencerespiratoire(dto.getFrequenceRespiratoire());
        sv.setSaturation(dto.getSaturation());

        dao.saveOrUpdate(sv);
    }
}
