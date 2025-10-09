package tele_expertise.servise;

import tele_expertise.dao.PatientImpl;
import tele_expertise.dto.PatientDTO;
import tele_expertise.entity.Patient;
import tele_expertise.mapper.patientMapper;

public class PatientService {

    private PatientImpl patientDAO ;

    public PatientService(PatientImpl patientDTO) {
        this.patientDAO = patientDTO;
    }

    public PatientDTO createPatient(PatientDTO dto) {
        Patient patient = patientMapper.toEntity(dto);
        patientDAO.save(patient);
        return patientMapper.toDTO(patient);
    }

    public PatientDTO getPatientById(int id) {
        Patient patient = patientDAO.findById(id);
        return patientMapper.toDTO(patient);
    }
}
