package tele_expertise.entity;


import jakarta.persistence.*;
import tele_expertise.enums.StatusPatient;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "patient")
@Inheritance(strategy = InheritanceType.JOINED)
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String nom;

    @Column(nullable = false)
    private String prenom;

    @Column(nullable = false)
        private LocalDate dateDeNaissance;

    @Column(nullable = false, unique = true)
    private String NSecuriteSociale;

    @Column(nullable = false)
    private String Telephone;

    private String Adresse;


    @Column(columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime dateCreation = LocalDateTime.now();


    @Column(columnDefinition = " VARCHAR(25) DEFAULT 'EN_ATTENTE'")
    @Enumerated(EnumType.STRING)
    private StatusPatient status = StatusPatient.EN_ATTENTE;

    @OneToOne(mappedBy = "patient", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private SignesVitaux signesVitaux;

    public Patient() {
    }


    public Patient(int id, String nom, String prenom, LocalDate dateDeNaissance, String NSecuriteSociale, String telephone, String adresse, StatusPatient status) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.dateDeNaissance = dateDeNaissance;
        this.NSecuriteSociale = NSecuriteSociale;
        Telephone = telephone;
        Adresse = adresse;
        this.status = status;
    }

    public StatusPatient getStatus() {
        return status;
    }

    public void setStatus(StatusPatient status) {
        this.status = status;
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

    public SignesVitaux getSignesVitaux() { return signesVitaux; }
    public void setSignesVitaux(SignesVitaux signesVitaux) { this.signesVitaux = signesVitaux; }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }
}

