package tele_expertise.mapper.mappers;

import tele_expertise.dto.*;
import tele_expertise.entity.Utilisateur;

import tele_expertise.dto.UtilisateurDTO;

public class UtilisateurMapper {

    // Entity to DTO


    public static Utilisateur toEntity(UtilisateurDTO creationDTO) {
        if (creationDTO == null) {
            return null;
        }

        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setNom(creationDTO.getNom());
        utilisateur.setPrenom(creationDTO.getPrenom());
        utilisateur.setEmail(creationDTO.getEmail());
        utilisateur.setMotDePasse(creationDTO.getMotDePasse());
        utilisateur.setRole(creationDTO.getRole());
        utilisateur.setTelephone(creationDTO.getTelephone());
        utilisateur.setActif(true);

        return utilisateur;
    }

    public Utilisateur toDTO(Utilisateur utilisateur) {
        if (utilisateur == null) {
            return null;
        }

        UtilisateurDTO userDTO = new UtilisateurDTO();
        userDTO.setId(utilisateur.getId());
        userDTO.setNom(utilisateur.getNom());
        userDTO.setPrenom(utilisateur.getPrenom());
        userDTO.setEmail(utilisateur.getEmail());
        userDTO.setMotDePasse(utilisateur.getMotDePasse());
        userDTO.setRole(utilisateur.getRole());
        userDTO.setTelephone(utilisateur.getTelephone());
        userDTO.setDateCreation(utilisateur.getDateCreation());
        userDTO.setActif(utilisateur.getActif());

        return utilisateur;
    }
//
//    public List<UtilisateurDTO> toDTOList(List<Utilisateur> utilisateurs) {
//        if (utilisateurs == null) {
//            return List.of();
//        }
//
//        return utilisateurs.stream()
//                .map(this::toDTO)
//                .collect(Collectors.toList());
//    }


//    // Update Entity from DTO
//    public void updateEntityFromDTO(UtilisateurUpdateDTO updateDTO, Utilisateur utilisateur) {
//        if (updateDTO == null || utilisateur == null) {
//            return;
//        }
//
//        if (updateDTO.getNom() != null) {
//            utilisateur.setNom(updateDTO.getNom());
//        }
//        if (updateDTO.getPrenom() != null) {
//            utilisateur.setPrenom(updateDTO.getPrenom());
//        }
//        if (updateDTO.getTelephone() != null) {
//            utilisateur.setTelephone(updateDTO.getTelephone());
//        }
//        if (updateDTO.getActif() != null) {
//            utilisateur.setActif(updateDTO.getActif());
//        }
//    }
}