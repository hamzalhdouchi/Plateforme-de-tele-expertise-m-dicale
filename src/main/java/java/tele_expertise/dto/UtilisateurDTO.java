package java.tele_expertise.dto;

import enums.RoleUtilisateur;

import java.time.LocalDateTime;

public class UtilisateurDTO {

        private Long id;
        private String nom;
        private String prenom;
        private String email;
        private RoleUtilisateur role;
        private String telephone;
        private LocalDateTime dateCreation;
        private Boolean actif;
}
