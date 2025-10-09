package tele_expertise.mapper;

import tele_expertise.dto.SignesVitauxDTO;
import tele_expertise.entity.SignesVitaux;

public class SignesVitauxMapper {

    public static SignesVitauxDTO toDTO(SignesVitaux sv) {
        if (sv == null) return null;
        SignesVitauxDTO dto = new SignesVitauxDTO();
        dto.setId(sv.getId());
        dto.setTemperature(sv.getTemperature());
        dto.setTensionSystolique(sv.getTensionsystolique());
        dto.setFrequenceRespiratoire(sv.getFrequencerespiratoire());
        dto.setTensionDiastolique(sv.getTensiondiastolique());
        dto.setSaturation(sv.getSaturation());
        return dto;
    }

    public static SignesVitaux toEntity(SignesVitauxDTO dto) {
        if (dto == null) return null;
        SignesVitaux sv = new SignesVitaux();
        sv.setId(dto.getId());
        sv.setTemperature(dto.getTemperature());
        sv.setTensionsystolique(dto.getTensionSystolique());
        sv.setFrequencerespiratoire(dto.getFrequenceRespiratoire());
        sv.setTensiondiastolique(dto.getTensionDiastolique());
        sv.setSaturation(dto.getSaturation());
        return sv;
    }
}
