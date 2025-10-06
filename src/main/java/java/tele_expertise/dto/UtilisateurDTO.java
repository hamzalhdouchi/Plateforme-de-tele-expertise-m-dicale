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

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public RoleUtilisateur getRole() {
        return role;
    }

    public void setRole(RoleUtilisateur role) {
        this.role = role;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    public Boolean getActif() {
        return actif;
    }

    public void setActif(Boolean actif) {
        this.actif = actif;
    }
}
