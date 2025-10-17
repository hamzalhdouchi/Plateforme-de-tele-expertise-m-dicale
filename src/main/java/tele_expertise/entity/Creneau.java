package tele_expertise.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "creneaux")
public class Creneau {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "specialiste_id", nullable = false)
    private Utilisateur specialiste;

    @Column(name = "date_heure", nullable = false)
    private LocalDateTime dateHeure;

    @Column(nullable = false)
    private Boolean disponible = true;

    @Column(name = "duree_minutes")
    private Integer dureeMinutes = 30;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Utilisateur getSpecialiste() { return specialiste; }
    public void setSpecialiste(Utilisateur specialiste) { this.specialiste = specialiste; }

    public LocalDateTime getDateHeure() { return dateHeure; }
    public void setDateHeure(LocalDateTime dateHeure) { this.dateHeure = dateHeure; }

    public Boolean getDisponible() { return disponible; }
    public void setDisponible(Boolean disponible) { this.disponible = disponible; }

    public Integer getDureeMinutes() { return dureeMinutes; }
    public void setDureeMinutes(Integer dureeMinutes) { this.dureeMinutes = dureeMinutes; }
}
