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