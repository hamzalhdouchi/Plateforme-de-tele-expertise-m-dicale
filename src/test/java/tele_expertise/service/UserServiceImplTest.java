package tele_expertise.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mindrot.jbcrypt.BCrypt;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import tele_expertise.dao.UtilisateurDaoImpl;
import tele_expertise.entity.Specialite;
import tele_expertise.entity.Utilisateur;
import tele_expertise.enums.RoleUtilisateur;
import tele_expertise.servise.SpecialiteServiceImpl;
import tele_expertise.servise.UserServiceImpl;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceImplTest {

    @Mock
    private UtilisateurDaoImpl utilisateurDao;

    @Mock
    private SpecialiteServiceImpl specialiteService;

    private UserServiceImpl userService;

    private Utilisateur utilisateur;
    private Specialite specialite;

    @BeforeEach
    void setUp() {
        userService = new UserServiceImpl(utilisateurDao, specialiteService);

        specialite = new Specialite();
        specialite.setId(1L);
        specialite.setNom("Cardiologie");

        utilisateur = new Utilisateur();
        utilisateur.setId(1L);
        utilisateur.setNom("Doe");
        utilisateur.setPrenom("John");
        utilisateur.setEmail("john.doe@example.com");
        utilisateur.setMotDePasse("password123");
        utilisateur.setActif(true);
        utilisateur.setDisponible(true);
    }

    @Test
    public boolean registerUtilisateur(Utilisateur utilisateur, RoleUtilisateur role) {
        try {
            if (userService.emailExists(utilisateur.getEmail())) {
                return false;
            }

            // Hachage mot de passe
            utilisateur.setMotDePasse(BCrypt.hashpw(utilisateur.getMotDePasse(), BCrypt.gensalt()));
            utilisateur.setRole(role);
            utilisateur.setActif(true);
            utilisateur.setDisponible(true);

            // Gestion spécialité pour SPECIALISTE
            if (role == RoleUtilisateur.SPECIALISTE) {
                // Vérifier d'abord si une spécialité est définie
                if (utilisateur.getSpecialite() == null || utilisateur.getSpecialite().getId() == null) {
                    return false;
                }

                Specialite specialite = specialiteService.getSpecialiteById(
                        utilisateur.getSpecialite().getId());
                if (specialite == null || utilisateur.getTarif() == null || utilisateur.getTarif() <= 0) {
                    return false;
                }
                utilisateur.setSpecialite(specialite);
            } else {
                utilisateur.setSpecialite(null);
                utilisateur.setTarif(null);
            }

            return utilisateurDao.saveUtilisateur(utilisateur);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Test
    void registerUtilisateur_AsInfirmier_ShouldSuccess() {
        // Arrange
        when(utilisateurDao.getUserByEmail(anyString())).thenReturn(null);
        when(utilisateurDao.saveUtilisateur(any(Utilisateur.class))).thenReturn(true);

        // Act
        boolean result = userService.registerUtilisateur(utilisateur, RoleUtilisateur.INFIRMIER);

        // Assert
        assertTrue(result);
        verify(utilisateurDao).saveUtilisateur(any(Utilisateur.class));
        assertNull(utilisateur.getSpecialite());
        assertNull(utilisateur.getTarif());
        assertEquals(RoleUtilisateur.INFIRMIER, utilisateur.getRole());
    }

    @Test
    void registerUtilisateur_AsGeneraliste_ShouldSuccess() {
        // Arrange
        when(utilisateurDao.getUserByEmail(anyString())).thenReturn(null);
        when(utilisateurDao.saveUtilisateur(any(Utilisateur.class))).thenReturn(true);

        // Act
        boolean result = userService.registerUtilisateur(utilisateur, RoleUtilisateur.GENERALISTE);

        // Assert
        assertTrue(result);
        verify(utilisateurDao).saveUtilisateur(any(Utilisateur.class));
        assertNull(utilisateur.getSpecialite());
        assertNull(utilisateur.getTarif());
        assertEquals(RoleUtilisateur.GENERALISTE, utilisateur.getRole());
    }

    @Test
    void registerUtilisateur_AsSpecialistWithoutSpecialite_ShouldReturnFalse() {
        // Arrange
        when(utilisateurDao.getUserByEmail(anyString())).thenReturn(null);
        utilisateur.setSpecialite(null);

        // Act
        boolean result = userService.registerUtilisateur(utilisateur, RoleUtilisateur.SPECIALISTE);

        // Assert
        assertFalse(result);
        verify(utilisateurDao, never()).saveUtilisateur(any(Utilisateur.class));
    }

    @Test
    void registerUtilisateur_AsSpecialistWithInvalidSpecialite_ShouldReturnFalse() {
        // Arrange
        when(utilisateurDao.getUserByEmail(anyString())).thenReturn(null);
        when(specialiteService.getSpecialiteById(1L)).thenReturn(null);
        utilisateur.setSpecialite(specialite);
        utilisateur.setTarif(100.0);

        // Act
        boolean result = userService.registerUtilisateur(utilisateur, RoleUtilisateur.SPECIALISTE);

        // Assert
        assertFalse(result);
        verify(utilisateurDao, never()).saveUtilisateur(any(Utilisateur.class));
    }

    @Test
    void registerUtilisateur_AsSpecialistWithZeroTarif_ShouldReturnFalse() {
        // Arrange
        when(utilisateurDao.getUserByEmail(anyString())).thenReturn(null);
        when(specialiteService.getSpecialiteById(1L)).thenReturn(specialite);
        utilisateur.setSpecialite(specialite);
        utilisateur.setTarif(0.0);

        // Act
        boolean result = userService.registerUtilisateur(utilisateur, RoleUtilisateur.SPECIALISTE);

        // Assert
        assertFalse(result);
        verify(utilisateurDao, never()).saveUtilisateur(any(Utilisateur.class));
    }

    @Test
    void registerUtilisateur_AsSpecialistWithNegativeTarif_ShouldReturnFalse() {
        // Arrange
        when(utilisateurDao.getUserByEmail(anyString())).thenReturn(null);
        when(specialiteService.getSpecialiteById(1L)).thenReturn(specialite);
        utilisateur.setSpecialite(specialite);
        utilisateur.setTarif(-50.0);

        // Act
        boolean result = userService.registerUtilisateur(utilisateur, RoleUtilisateur.SPECIALISTE);

        // Assert
        assertFalse(result);
        verify(utilisateurDao, never()).saveUtilisateur(any(Utilisateur.class));
    }

    @Test
    void registerUtilisateur_AsSpecialistWithValidData_ShouldSuccess() {
        // Arrange
        when(utilisateurDao.getUserByEmail(anyString())).thenReturn(null);
        when(specialiteService.getSpecialiteById(1L)).thenReturn(specialite);
        when(utilisateurDao.saveUtilisateur(any(Utilisateur.class))).thenReturn(true);
        utilisateur.setSpecialite(specialite);
        utilisateur.setTarif(150.0);

        // Act
        boolean result = userService.registerUtilisateur(utilisateur, RoleUtilisateur.SPECIALISTE);

        // Assert
        assertTrue(result);
        verify(utilisateurDao).saveUtilisateur(any(Utilisateur.class));
        assertEquals(RoleUtilisateur.SPECIALISTE, utilisateur.getRole());
        assertEquals(specialite, utilisateur.getSpecialite());
    }

    @Test
    void registerUtilisateur_WhenDaoThrowsException_ShouldReturnFalse() {
        // Arrange
        when(utilisateurDao.getUserByEmail(anyString())).thenReturn(null);
        when(utilisateurDao.saveUtilisateur(any(Utilisateur.class))).thenThrow(new RuntimeException("Database error"));

        // Act
        boolean result = userService.registerUtilisateur(utilisateur, RoleUtilisateur.INFIRMIER);

        // Assert
        assertFalse(result);
    }

    @Test
    void saveUtilisateur_ShouldCallDao() {
        // Arrange
        when(utilisateurDao.saveUtilisateur(utilisateur)).thenReturn(true);

        // Act
        boolean result = userService.saveUtilisateur(utilisateur);

        // Assert
        assertTrue(result);
        verify(utilisateurDao).saveUtilisateur(utilisateur);
    }

    @Test
    void getUserByEmail_ShouldReturnUser() {
        // Arrange
        when(utilisateurDao.getUserByEmail("test@example.com")).thenReturn(utilisateur);

        // Act
        Utilisateur result = userService.getUserByEmail("test@example.com");

        // Assert
        assertNotNull(result);
        assertEquals(utilisateur, result);
        verify(utilisateurDao).getUserByEmail("test@example.com");
    }

    @Test
    void login_WithValidCredentials_ShouldReturnUser() {
        // Arrange
        String hashedPassword = "$2a$10$xyz123"; // BCrypt hash example
        utilisateur.setMotDePasse(hashedPassword);
        when(utilisateurDao.getUserByEmail("john.doe@example.com")).thenReturn(utilisateur);

        // Act
        Utilisateur result = userService.login("john.doe@example.com", "password123");

        // Assert
        assertNotNull(result);
        assertEquals(utilisateur, result);
    }

    @Test
    void login_WithInvalidPassword_ShouldReturnNull() {
        // Arrange
        String hashedPassword = "$2a$10$xyz123"; // BCrypt hash for different password
        utilisateur.setMotDePasse(hashedPassword);
        when(utilisateurDao.getUserByEmail("john.doe@example.com")).thenReturn(utilisateur);

        // Act
        Utilisateur result = userService.login("john.doe@example.com", "wrongpassword");

        // Assert
        assertNull(result);
    }

    @Test
    void login_WithNonExistentEmail_ShouldReturnNull() {
        // Arrange
        when(utilisateurDao.getUserByEmail("nonexistent@example.com")).thenReturn(null);

        // Act
        Utilisateur result = userService.login("nonexistent@example.com", "password123");

        // Assert
        assertNull(result);
    }

    @Test
    void getUserById_ShouldReturnUser() {
        // Arrange
        when(utilisateurDao.getUserById(1L)).thenReturn(utilisateur);

        // Act
        Utilisateur result = userService.getUserById(1L);

        // Assert
        assertNotNull(result);
        assertEquals(utilisateur, result);
        verify(utilisateurDao).getUserById(1L);
    }

    @Test
    void emailExists_ShouldReturnTrueWhenEmailExists() {
        // Arrange
        when(utilisateurDao.getUserByEmail("existing@example.com")).thenReturn(utilisateur);

        // Act
        boolean result = userService.emailExists("existing@example.com");

        // Assert
        assertTrue(result);
    }

    @Test
    void emailExists_ShouldReturnFalseWhenEmailNotExists() {
        // Arrange
        when(utilisateurDao.getUserByEmail("nonexistent@example.com")).thenReturn(null);

        // Act
        boolean result = userService.emailExists("nonexistent@example.com");

        // Assert
        assertFalse(result);
    }

    @Test
    void getAllSpecialist_ShouldReturnOnlySpecialistsWithSpecialite() {
        // Arrange
        Utilisateur specialist1 = new Utilisateur();
        specialist1.setRole(RoleUtilisateur.SPECIALISTE);
        specialist1.setSpecialite(specialite);

        Utilisateur specialist2 = new Utilisateur();
        specialist2.setRole(RoleUtilisateur.SPECIALISTE);
        specialist2.setSpecialite(new Specialite());

        Utilisateur infirmier = new Utilisateur();
        infirmier.setRole(RoleUtilisateur.INFIRMIER);

        Utilisateur generaliste = new Utilisateur();
        generaliste.setRole(RoleUtilisateur.GENERALISTE);

        Utilisateur specialistWithoutSpecialite = new Utilisateur();
        specialistWithoutSpecialite.setRole(RoleUtilisateur.SPECIALISTE);
        specialistWithoutSpecialite.setSpecialite(null);

        List<Utilisateur> allUsers = Arrays.asList(
                specialist1, specialist2, infirmier, generaliste, specialistWithoutSpecialite
        );

        when(utilisateurDao.getAll()).thenReturn(allUsers);

        // Act
        List<Utilisateur> result = userService.getAllSpecialist();

        // Assert
        assertEquals(2, result.size());
        assertTrue(result.stream().allMatch(u ->
                u.getRole() == RoleUtilisateur.SPECIALISTE && u.getSpecialite() != null));
        verify(utilisateurDao).getAll();
    }

    @Test
    void getSpecialiteById_ShouldCallSpecialiteService() {
        // Arrange
        when(specialiteService.getSpecialiteById(1L)).thenReturn(specialite);

        // Act
        Specialite result = userService.getSpecialiteById(1L);

        // Assert
        assertNotNull(result);
        assertEquals(specialite, result);
        verify(specialiteService).getSpecialiteById(1L);
    }

    @Test
    void getAllUsers_ShouldReturnAllUsers() {
        // Arrange
        List<Utilisateur> expectedUsers = Arrays.asList(utilisateur, new Utilisateur());
        when(utilisateurDao.getAll()).thenReturn(expectedUsers);

        // Act
        List<Utilisateur> result = userService.getAllUsers();

        // Assert
        assertEquals(expectedUsers, result);
        verify(utilisateurDao).getAll();
    }
}