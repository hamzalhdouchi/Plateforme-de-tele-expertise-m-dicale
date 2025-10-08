package tele_expertise.dto;

import java.time.LocalDate;

public class PatientDTO {

    private int id;
    private String nom;
    private String prenom;
    private String adresse;
    private String telephone;
    private LocalDate dateDeNaissance;
    private String NSecuriteSociale;

    public PatientDTO() {}

    public PatientDTO(int id, String nom, String prenom, String adresse, String telephone, LocalDate dateDeNaissance, String NSecuriteSociale) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.adresse = adresse;
        this.telephone = telephone;
        this.dateDeNaissance = dateDeNaissance;
        this.NSecuriteSociale = NSecuriteSociale;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
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

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public LocalDate getDateDeNaissance() {
        return dateDeNaissance;
    }

    public void setDateDeNaissance(LocalDate dateDeNaissance) {
        this.dateDeNaissance = dateDeNaissance;
    }

    public String getNSecuriteSociale() {
        return NSecuriteSociale;
    }

    public void setNSecuriteSociale(String NSecuriteSociale) {
        this.NSecuriteSociale = NSecuriteSociale;
    }
}
