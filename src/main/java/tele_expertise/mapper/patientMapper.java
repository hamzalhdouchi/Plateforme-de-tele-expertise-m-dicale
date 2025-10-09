package tele_expertise.mapper;

import tele_expertise.dto.PatientDTO;
import tele_expertise.entity.Patient;

import java.util.List;

public class patientMapper{



    public static PatientDTO toDTO(Patient patient) {
        if (patient == null) return null;
        PatientDTO dto = new PatientDTO();
        dto.setId(patient.getId());
        dto.setNom(patient.getNom());
        dto.setPrenom(patient.getPrenom());
        dto.setDateDeNaissance(patient.getDateDeNaissance());
        dto.setNSecuriteSociale(patient.getNSecuriteSociale());
        dto.setTelephone(patient.getTelephone());
        dto.setAdresse(patient.getAdresse());
        return dto;
    }

    public static Patient toEntity(PatientDTO dto) {
        if (dto == null) return null;
        Patient patient = new Patient();
        patient.setId(dto.getId());
        patient.setNom(dto.getNom());
        patient.setPrenom(dto.getPrenom());
        patient.setDateDeNaissance(dto.getDateDeNaissance());
        patient.setNSecuriteSociale(dto.getNSecuriteSociale());
        patient.setTelephone(dto.getTelephone());
        patient.setAdresse(dto.getAdresse());
        return patient;
    }



}
