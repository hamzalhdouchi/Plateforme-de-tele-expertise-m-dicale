package tele_expertise.servise;

import tele_expertise.dao.PatientImpl;
import tele_expertise.dto.PatientDTO;
import tele_expertise.entity.Patient;
import tele_expertise.enums.StatusPatient;
import tele_expertise.mapper.patientMapper;

import java.util.List;

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

    public Patient getPatientById(int id) {
        Patient patient = patientDAO.findById(id);
        return patient;
    }

    public List<Patient> getAllPatients() {
        List<Patient> patients = patientDAO.getAllPatientsWithSignesVitaux();
                return patients;
    }

    public void UpadateStatus(int id, StatusPatient status) {
        Patient patient = patientDAO.findById(id);
    }
}
