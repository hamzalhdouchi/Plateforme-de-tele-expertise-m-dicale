package tele_expertise.mapper;

import tele_expertise.entity.SignesVitaux;
import tele_expertise.dto.SignesVitauxDTO;

public class SignesVitauxMapper {

    public static SignesVitauxDTO toDTO(SignesVitaux entity) {
        if (entity == null) {
            return null;
        }

        return new SignesVitauxDTO(
                entity.getId(),
                entity.getTemperature(),
                entity.getTensionsystolique(),
                entity.getFrequencerespiratoire(),
                entity.getTensiondiastolique(),
                entity.getSaturation()
        );
    }

    public static SignesVitaux toEntity(SignesVitauxDTO dto) {
        if (dto == null) {
            return null;
        }

        SignesVitaux entity = new SignesVitaux();
        entity.setId(dto.getId());
        entity.setTemperature(dto.getTemperature());
        entity.setTensionsystolique(dto.getTensionSystolique());
        entity.setFrequencerespiratoire(dto.getFrequenceRespiratoire());
        entity.setTensiondiastolique(dto.getTensionDiastolique());
        entity.setSaturation(dto.getSaturation());

        return entity;
    }
}
