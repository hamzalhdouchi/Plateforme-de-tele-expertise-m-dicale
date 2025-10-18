package tele_expertise.entity;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "specialite")
public class Specialite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String nom;

    @Column(length = 255)
    private String description;

    @Column(name = "is_deleted", nullable = false)
    private Boolean isDeleted = false;

    @OneToMany(mappedBy = "specialite", fetch = FetchType.EAGER)
    private List<Utilisateur> specialistes;

    public Specialite() {
    }
    public Specialite(String nom, String description) {
        this.nom = nom;
        this.description = description;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public List<Utilisateur> getSpecialistes() {
        return specialistes;
    }

    public void setSpecialistes(List<Utilisateur> specialistes) {
        this.specialistes = specialistes;
    }
}