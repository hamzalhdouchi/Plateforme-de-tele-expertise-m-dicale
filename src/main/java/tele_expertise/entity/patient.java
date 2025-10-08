package tele_expertise.entity;


import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "patient")
@Inheritance(strategy = InheritanceType.JOINED)
public class patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String nom;

    @Column(nullable = false)
    private String prenom;

    @Column(nullable = false)
    private LocalDate dateDeNaissance;

    @Column(nullable = false)
    private String NSecuriteSociale;

    @Column(nullable = false)
    private String Telephone;

    @Column(nullable = true)
    private String Adresse;


    public patient(int id, String nom, String prenom, LocalDate dateDeNaissance, String NSecuriteSociale, String telephone, String adresse) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.dateDeNaissance = dateDeNaissance;
        this.NSecuriteSociale = NSecuriteSociale;
        Telephone = telephone;
        Adresse = adresse;
    }

    public patient() {
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

    public String getTelephone() {
        return Telephone;
    }

    public void setTelephone(String telephone) {
        Telephone = telephone;
    }

    public String getAdresse() {
        return Adresse;
    }

    public void setAdresse(String adresse) {
        Adresse = adresse;
    }
}

