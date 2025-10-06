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

    public UtilisateurDTO() {}

    public UtilisateurDTO(Long id, String nom, String prenom, String email,
                          RoleUtilisateur role, String telephone,
                          LocalDateTime dateCreation, Boolean actif) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.role = role;
        this.telephone = telephone;
        this.dateCreation = dateCreation;
        this.actif = actif;
    }
}
