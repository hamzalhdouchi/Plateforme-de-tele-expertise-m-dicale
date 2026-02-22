package tele_expertise.servise;

import tele_expertise.dao.PatientImpl;
import tele_expertise.dto.PatientDTO;
import tele_expertise.entity.Patient;
import tele_expertise.enums.StatusPatient;
import tele_expertise.mapper.patientMapper;

import java.sql.Time;
import java.time.LocalDateTime;
import java.util.ArrayList;
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

    public List<LocalDateTime> getAllPatients() {
        List<Patient> patients = patientDAO.getAllPatientsWithSignesVitaux();
        List<LocalDateTime> localDateTimeList = new ArrayList<>();
         localDateTimeList = patients.stream().filter(patients)

                return patients;
    }

    public void UpadateStatus(int id, StatusPatient status) {
        patientDAO.updatePatientStatus(id,status);
    }
}
