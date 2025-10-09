package tele_expertise.mapper;

import tele_expertise.dto.PatientDTO;
import tele_expertise.entity.Patient;

public class patientMapper{



    public  PatientDTO toDTO(Patient p) {

        if (p == null) {
            return null;
        }
        PatientDTO dto = new PatientDTO();
        dto.setNom((p.getNom()));
        dto.setPrenom((p.getPrenom()));
        dto.setAdresse((p.getAdresse()));
        dto.setDateDeNaissance((p.getDateDeNaissance()));
        dto.setTelephone(p.getTelephone());
        return dto;
    }

    public static Patient toEntity(PatientDTO dto) {
        if (dto == null) {
            return null;
        }

        Patient p = new Patient();
        p.setNom(dto.getNom());
        p.setPrenom(dto.getPrenom());
        p.setAdresse(dto.getAdresse());
        p.setDateDeNaissance(dto.getDateDeNaissance());
        p.setTelephone(dto.getTelephone());
        p.setNSecuriteSociale(dto.getNSecuriteSociale());

        return p;
    }

//    public List toDTOList(List entities) {
//        return List.of();
//    }
//
//    public List toEntityList(List dtos) {
//        return List.of();
//    }
}
