<%@ page import="tele_expertise.enums.RoleUtilisateur" %>
<%@ page import="tele_expertise.enums.StatutConsultation" %>
<%@ page import="tele_expertise.entity.Specialite" %>
<%@ page import="tele_expertise.entity.Utilisateur" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<%
    if (session == null || session.getAttribute("loggedUser") == null || session.getAttribute("role") != RoleUtilisateur.GENERALISTE) {
        request.setAttribute("error", "Session expired");
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }

    // Gestion des paramètres d'erreur et de succès depuis l'URL
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    String message = request.getParameter("message");

    // Messages d'erreur prédéfinis
    if (error != null) {
        String errorMsg = "";
        switch (error) {
            case "missing_patient":
                errorMsg = "L'identifiant du patient est obligatoire";
                break;
            case "missing_motif":
                errorMsg = "Le motif de consultation est obligatoire";
                break;
            case "missing_statut":
                errorMsg = "Le statut de la consultation est obligatoire";
                break;
            case "csrf_invalid":
                errorMsg = "Sécurité compromise. Veuillez réessayer votre action";
                break;
            case "patient_not_found":
                errorMsg = "Patient non trouvé";
                break;
            case "invalid_patient_id":
                errorMsg = "Identifiant patient invalide";
                break;
            case "invalid_statut":
                errorMsg = "Statut de consultation invalide";
                break;
            case "medecin_not_found":
                errorMsg = "Médecin généraliste non trouvé";
                break;
            case "unauthorized":
                errorMsg = "Vous n'êtes pas autorisé à effectuer cette action";
                break;
            case "creation_failed":
                errorMsg = message != null ? "Erreur lors de la création : " + java.net.URLDecoder.decode(message, "UTF-8") : "Erreur lors de la création de la consultation";
                break;
            case "loading_failed":
                errorMsg = "Erreur lors du chargement du formulaire";
                break;
            default:
                errorMsg = "Une erreur s'est produite";
        }
        request.setAttribute("errorMessage", errorMsg);
    }

    if ("true".equals(success)) {
        request.setAttribute("successMessage", message != null ?
                java.net.URLDecoder.decode(message, "UTF-8") : "Consultation créée avec succès");
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle Consultation - Télé-Expertise</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/fr.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/fr.js"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: 'oklch(0.55 0.15 240)',
                        'primary-foreground': 'oklch(0.99 0 0)',
                        secondary: 'oklch(0.65 0.12 200)',
                        background: 'oklch(0.99 0.005 240)',
                        foreground: 'oklch(0.25 0.015 240)',
                        muted: 'oklch(0.96 0.01 240)',
                        'muted-foreground': 'oklch(0.55 0.015 240)',
                        border: 'oklch(0.90 0.01 240)',
                        input: 'oklch(0.95 0.01 240)',
                    }
                }
            }
        }
    </script>
    <style>

        /* Styles pour les créneaux */
        .creneau-disponible {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
        }

        .creneau-indisponible {
            background: #f3f4f6;
            color: #9ca3af;
            cursor: not-allowed;
        }

        /* Scrollbar personnalisée */
        .creneaux-list::-webkit-scrollbar {
            width: 4px;
        }

        .creneaux-list::-webkit-scrollbar-track {
            background: #f1f5f9;
            border-radius: 10px;
        }

        .creneaux-list::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 10px;
        }

        .creneaux-list::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
        }

        .step-indicator {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: oklch(0.96 0.01 240);
            border: 2px solid oklch(0.90 0.01 240);
            color: oklch(0.55 0.015 240);
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .step-indicator.active {
            background: oklch(0.55 0.15 240);
            border-color: oklch(0.55 0.15 240);
            color: white;
        }

        .step-indicator.completed {
            background: oklch(0.65 0.12 200);
            border-color: oklch(0.65 0.12 200);
            color: white;
        }

        .checkbox-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .checkbox-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .checkbox-card.selected {
            border-color: oklch(0.55 0.15 240);
            background-color: rgba(66, 153, 225, 0.05);
        }

        .form-input:focus {
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.15);
            border-color: oklch(0.55 0.15 240);
        }

        /* Masquer la checkbox par défaut */
        .checkbox-card input[type="checkbox"] {
            position: absolute;
            opacity: 0;
        }

        /* Style personnalisé pour la checkbox */
        .custom-checkbox {
            width: 20px;
            height: 20px;
            border: 2px solid oklch(0.90 0.01 240);
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }

        .checkbox-card input[type="checkbox"]:checked + .custom-checkbox {
            background: oklch(0.55 0.15 240);
            border-color: oklch(0.55 0.15 240);
        }

        .checkbox-card input[type="checkbox"]:checked + .custom-checkbox::after {
            content: "✓";
            color: white;
            font-size: 14px;
            font-weight: bold;
        }

        /* Style pour les boutons de spécialiste */
        .specialiste-card {
            transition: all 0.2s ease;
        }

        .specialiste-card:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .custom-radio {
            width: 18px;
            height: 18px;
            border: 2px solid oklch(0.90 0.01 240);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }

        .specialiste-card input[type="radio"]:checked + .custom-radio {
            border-color: oklch(0.55 0.15 240);
            background: oklch(0.55 0.15 240);
        }

        .specialiste-card input[type="radio"]:checked + .custom-radio::after {
            content: "";
            width: 8px;
            height: 8px;
            background: white;
            border-radius: 50%;
        }

        /* Animation pour les alertes */
        .alert-slide {
            animation: slideDown 0.3s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Loading state */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .fade-in {
            animation: fadeIn 0.3s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Styles pour le popup de calendrier */
        .calendar-popup {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            backdrop-filter: blur(5px);
        }

        .calendar-content {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            max-width: 500px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        /* Personnalisation de Flatpickr */
        .flatpickr-calendar {
            border-radius: 12px;
            border: 1px solid oklch(0.90 0.01 240);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .flatpickr-day.selected {
            background: oklch(0.55 0.15 240);
            border-color: oklch(0.55 0.15 240);
        }

        .flatpickr-day.today {
            border-color: oklch(0.65 0.12 200);
        }

        .flatpickr-day.today:hover {
            background: oklch(0.65 0.12 200);
            border-color: oklch(0.65 0.12 200);
            color: white;
        }
    </style>
</head>
<body class="bg-background text-foreground min-h-screen">
<!-- Header -->
<header class="bg-primary text-primary-foreground shadow-lg">
    <div class="container mx-auto px-4 py-4">
        <div class="flex justify-between items-center">
            <div class="flex items-center space-x-3">
                <i class="fas fa-stethoscope text-2xl"></i>
                <h1 class="text-2xl font-bold">Télé-Expertise</h1>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-sm">Connecté en tant que: <span
                        class="font-semibold">${sessionScope.loggedUser}</span></span>
                <button onclick="window.location.href='${pageContext.request.contextPath}/logout'"
                        class="bg-primary-foreground text-primary px-4 py-2 rounded-lg font-medium hover:bg-opacity-90 transition-colors">
                    <i class="fas fa-sign-out-alt mr-2"></i>Déconnexion
                </button>
            </div>
        </div>
    </div>
</header>

<!-- Navigation -->
<nav class="bg-white border-b border-border shadow-sm">


    <!-- Ajoutez cette section de débogage temporairement -->
    <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4 mb-4">
        <h3 class="text-lg font-semibold text-yellow-800">Debug Info:</h3>
        <p><strong>Specialites size:</strong> ${specialites.size()}</p>
        <p><strong>SpecialistesParSpecialite size:</strong> ${specialistesParSpecialite.size()}</p>
        <p><strong>CreneauxParSpecialiste size:</strong> ${creneauxParSpecialiste.size()}</p>

        <c:forEach var="entry" items="${specialistesParSpecialite}">
            <div class="mt-2">
                <strong>Specialite:</strong> ${entry.key.nom} -
                <strong>Specialistes:</strong> ${entry.value.size()}
                <c:forEach var="specialiste" items="${entry.value}">
                    <div class="ml-4">
                            ${specialiste.prenom} ${specialiste.nom} -
                        Créneaux: ${creneauxParSpecialiste[specialiste].size()}
                    </div>
                </c:forEach>
            </div>
        </c:forEach>
    </div>
    <div class="container mx-auto px-4">
        <div class="flex space-x-1 overflow-x-auto">
            <a href="${pageContext.request.contextPath}/dashboard"
               class="px-4 py-3 text-muted-foreground hover:text-foreground transition-colors whitespace-nowrap">
                <i class="fas fa-tachometer-alt mr-2"></i>Tableau de bord
            </a>
            <a href="#" class="px-4 py-3 text-primary border-b-2 border-primary font-medium whitespace-nowrap">
                <i class="fas fa-plus-circle mr-2"></i>Nouvelle consultation
            </a>
            <a href="${pageContext.request.contextPath}/medecin/historique-consultations"
               class="px-4 py-3 text-muted-foreground hover:text-foreground transition-colors whitespace-nowrap">
                <i class="fas fa-history mr-2"></i>Historique
            </a>
            <a href="${pageContext.request.contextPath}/patients"
               class="px-4 py-3 text-muted-foreground hover:text-foreground transition-colors whitespace-nowrap">
                <i class="fas fa-user-injured mr-2"></i>Patients
            </a>
        </div>
    </div>
</nav>

<!-- Main Content -->
<main class="container mx-auto px-4 py-8">
    <div class="max-w-4xl mx-auto">
        <!-- Progress Steps -->
        <div class="mb-8">
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center space-x-2">
                    <div class="step-indicator completed">
                        <i class="fas fa-check text-xs"></i>
                    </div>
                    <span class="text-sm font-medium text-foreground">Informations patient</span>
                </div>
                <div class="h-1 flex-1 bg-border mx-2"></div>
                <div class="flex items-center space-x-2">
                    <div class="step-indicator active">2</div>
                    <span class="text-sm font-medium text-foreground">Détails consultation</span>
                </div>
                <div class="h-1 flex-1 bg-border mx-2"></div>
                <div class="flex items-center space-x-2">
                    <div class="step-indicator">3</div>
                    <span class="text-sm font-medium text-muted-foreground">Validation</span>
                </div>
            </div>
        </div>

        <!-- Page Header -->
        <div class="mb-8 text-center">
            <h1 class="text-3xl font-bold text-foreground mb-2">Nouvelle Consultation</h1>
            <p class="text-muted-foreground">Remplissez les informations nécessaires pour créer une nouvelle demande de
                télé-expertise</p>

            <!-- Affichage du patient actuel -->
            <c:if test="${not empty patient}">
                <div class="mt-4 p-4 bg-primary/10 text-primary rounded-lg">
                    <i class="fas fa-user-md mr-2"></i>
                    <span class="font-medium">Patient: ${patient.nom} ${patient.prenom} (${patient.id})</span>
                </div>
            </c:if>
        </div>

        <!-- Form Container -->
        <div class="bg-white rounded-2xl shadow-soft overflow-hidden border border-border">

            <%
                String csrf = (String) session.getAttribute("csrfToken");
            %>
            <form action="${pageContext.request.contextPath}/medecin/creer-consultation" method="post" class="p-8" id="consultationForm">
                <input type="hidden" name="csrfToken" value="<%= csrf != null ? csrf : "" %>">
                <input type="hidden" id="idSpicialiste"  name="idSpicialiste">
                >

                <input type="hidden" id="crenaeuId"  name="crenaeuId">

                <input type="text" name="selectedCreneauId" id="selectedCreneauId" value="">


                <input type="hidden" id="calendarTime" name="heure">

                <input type="hidden" id="Date" name="date">
                <input type="hidden" name="patientId" value="${patient.id}">


                <input type="hidden" name="selectedDateTime" id="selectedDateTime" value="">
                <div class="mb-10">
                    <h2 class="text-xl font-semibold text-foreground mb-6 flex items-center">
                        <i class="fas fa-info-circle text-primary mr-3"></i> Statut de la consultation
                    </h2>
                    <div class="space-y-4">
                        <div class="max-w-md">
                            <label for="statut" class="block text-sm font-medium text-foreground mb-2">Statut *</label>
                            <select id="statut" name="statut"
                                    class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input"
                                    required>
                                <option value="">Sélectionnez un statut</option>
                                <option value="EN_ATTENTE_AVIS_SPECIALISTE">En attente d'avis spécialiste</option>
                                <option value="TERMINEE">Terminée</option>
                            </select>
                        </div>
                        <div class="flex items-center text-sm text-muted-foreground bg-muted p-4 rounded-xl">
                            <i class="fas fa-info-circle mr-3 text-primary"></i>
                            <span>Le statut "En attente d'avis spécialiste" nécessitera l'assignation d'un spécialiste pour avis.</span>
                        </div>
                    </div>
                </div>

                <div id="specialistSection" class="mb-10 hidden">
                    <h2 class="text-xl font-semibold text-foreground mb-6 flex items-center">
                        <i class="fas fa-user-md text-primary mr-3"></i> Sélection du spécialiste
                    </h2>
                    <div class="space-y-6">
                        <div class="max-w-md">
                            <label for="specialiteFilter" class="block text-sm font-medium text-foreground mb-2">
                                Choisir une spécialité *
                            </label>
                            <select id="specialiteFilter" required
                                    class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input">
                                <option value="">Sélectionnez une spécialité</option>
                                <c:forEach var="specialite" items="${specialites}">
                                    <option value="${specialite.nom}">${specialite.nom}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div id="specialistesContainer" class="hidden">
                            <div class="border border-border rounded-2xl overflow-hidden shadow-sm bg-white fade-in">
                                <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
                                    <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                                        <i class="fas fa-stethoscope text-primary mr-2"></i>
                                        <span id="selectedSpecialiteName"></span>
                                    </h3>
                                    <p class="text-sm text-gray-600 mt-1" id="selectedSpecialiteDescription"></p>
                                </div>

                                <div class="p-6 bg-white">
                                    <div id="specialistesList" class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="timePopup" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
                            <div class="bg-white rounded-lg shadow-xl w-full max-w-md max-h-[90vh] overflow-hidden">
                                <div class="flex justify-between items-center border-b border-gray-200 px-6 py-4">
                                    <h3 class="text-lg font-semibold text-gray-800">Choisir un horaire</h3>
                                    <button id="closePopup" class="text-gray-400 hover:text-gray-600 text-2xl font-bold">
                                        &times;
                                    </button>
                                </div>

                                <div class="p-6">
                                    <p id="selectedDateText" class="text-gray-600 mb-4 text-center"></p>

                                    <div id="availableTimes" class="grid grid-cols-2 sm:grid-cols-3 gap-3 max-h-96 overflow-y-auto">
                                    </div>

                                    <div id="noSlotsMessage" class="hidden text-center py-8">
                                        <p class="text-gray-500">Aucun créneau disponible pour cette date</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="noSpecialistes" class="hidden text-center py-8">
                            <div class="text-gray-400 mb-4">
                                <i class="fas fa-user-md text-4xl"></i>
                            </div>
                            <p class="text-gray-500">Veuillez sélectionner une spécialité pour afficher les spécialistes disponibles</p>
                        </div>

                        <div id="emptySpecialistes" class="hidden text-center py-8">
                            <div class="text-gray-400 mb-4">
                                <i class="fas fa-user-slash text-4xl"></i>
                            </div>
                            <p class="text-gray-500">Aucun spécialiste disponible pour cette spécialité</p>
                        </div>

                        <div class="flex items-center text-sm text-muted-foreground bg-muted p-4 rounded-xl">
                            <i class="fas fa-info-circle mr-3 text-primary"></i>
                            <span>Sélectionnez d'abord une spécialité pour voir les spécialistes disponibles.</span>
                        </div>
                    </div>
                </div>

                <div class="mb-10">
                    <h2 class="text-xl font-semibold text-foreground mb-6 flex items-center">
                        <i class="fas fa-file-medical text-primary mr-3"></i> Informations cliniques
                    </h2>
                    <div class="space-y-6">

                        <div id="question" class="hidden">
                            <label for="question" class="block text-sm font-medium text-foreground mb-2">Question au spécialiste *</label>
                            <textarea id="question" name="question" rows="4"
                                      class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input"
                                      placeholder="Formulez la question spécifique à adresser au spécialiste..." required
                                      maxlength="1000"></textarea>
                            <p class="text-xs text-muted-foreground mt-1">Maximum 1000 caractères</p>
                        </div>

                        <div>
                            <label for="motif" class="block text-sm font-medium text-foreground mb-2">Motif de la
                                consultation *</label>
                            <textarea id="motif" name="motif" rows="4"
                                      class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input"
                                      placeholder="Décrivez le motif de la consultation..." required
                                      maxlength="1000"></textarea>
                            <p class="text-xs text-muted-foreground mt-1">Maximum 1000 caractères</p>
                        </div>

                        <div id="donneesAnalyses" class="hidden">
                            <label for="donneesAnalyses" class="block text-sm font-medium text-foreground mb-2">Données d'analyses / Examens complémentaires</label>
                            <textarea id="donneesAnalyses" name="donneesAnalyses" rows="3"
                                      class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input"
                                      placeholder="Détails des résultats d'analyses ou d'examens complémentaires..."
                                      maxlength="1000"></textarea>
                            <p class="text-xs text-muted-foreground mt-1">Maximum 1000 caractères</p>
                        </div>

                        <div id="priorite" class="hidden max-w-md hidden">
                            <label for="priorite" class="block text-sm font-medium text-foreground mb-2">Priorité de l'avis *</label>
                            <select id="priorite" name="priorite"
                                    class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input"
                                    required>
                                <option value="">Sélectionnez la priorité</option>
                                <option value="URGENTE">URGENTE</option>
                                <option value="NORMALE">NORMALE</option>
                                <option value="NON_URGENTE">NON URGENTE</option>
                            </select>
                        </div>

                        <div>
                            <label for="diagnostic" class="block text-sm font-medium text-foreground mb-2">Diagnostic
                                médicaux</label>
                            <textarea id="diagnostic" name="diagnostic" rows="3"
                                      class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input"
                                      placeholder="Antécédents médicaux du patient..." maxlength="500"></textarea>
                            <p class="text-xs text-muted-foreground mt-1">Maximum 500 caractères</p>
                        </div>

                        <div>
                            <label for="traitement" class="block text-sm font-medium text-foreground mb-2">Traitement en
                                cours</label>
                            <textarea id="traitement" name="traitement" rows="3"
                                      class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input"
                                      placeholder="Traitement actuel du patient..." maxlength="500"></textarea>
                            <p class="text-xs text-muted-foreground mt-1">Maximum 500 caractères</p>
                        </div>

                        <div>
                            <label for="observations" class="block text-sm font-medium text-foreground mb-2">Observations</label>
                            <textarea id="observations" name="observations" rows="3"
                                      class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input"
                                      placeholder="Observations complémentaires..." maxlength="500"></textarea>
                            <p class="text-xs text-muted-foreground mt-1">Maximum 500 caractères</p>
                        </div>
                    </div>
                </div>

                <div class="mb-10">
                    <h2 class="text-xl font-semibold text-foreground mb-6 flex items-center">
                        <i class="fas fa-microscope text-primary mr-3"></i> Actes techniques
                    </h2>
                    <p class="text-muted-foreground mb-6">Sélectionnez un ou plusieurs actes techniques si nécessaire
                        pour cette consultation.</p>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
                        <c:forEach var="acte" items="${actesTechniques}" varStatus="status">
                            <label class="checkbox-card border border-border rounded-xl p-5 cursor-pointer bg-input hover:bg-muted transition-all relative">
                                <input type="checkbox" name="actesTechniques" value="${acte.name()}"
                                       class="absolute opacity-0">
                                <div class="custom-checkbox absolute top-5 right-5"></div>
                                <div class="pr-6">
                                    <div class="font-semibold text-foreground">${acte.libelle}</div>
                                    <p class="text-base font-bold text-primary mt-3">${acte.cout} DH</p>
                                </div>
                            </label>
                        </c:forEach>
                    </div>

                    <div class="flex items-center text-sm text-muted-foreground bg-muted p-4 rounded-xl">
                        <i class="fas fa-info-circle mr-3 text-primary"></i>
                        <span>Vous pouvez sélectionner plusieurs actes techniques. Le coût total sera calculé automatiquement.</span>
                    </div>
                </div>

                <div class="flex flex-col sm:flex-row justify-between items-center pt-6 border-t border-border gap-4">
                    <button type="button" onclick="window.history.back()"
                            class="w-full sm:w-auto px-8 py-3 border border-border rounded-xl text-foreground hover:bg-muted transition-colors font-medium">
                        <i class="fas fa-arrow-left mr-2"></i> Retour
                    </button>
                    <button type="submit"
                            class="w-full sm:w-auto px-8 py-3 bg-primary text-primary-foreground rounded-xl font-semibold hover:bg-opacity-90 transition-colors shadow-md flex items-center justify-center">
                        <i class="fas fa-paper-plane mr-2"></i> Envoyer la demande
                    </button>
                </div>
            </form>        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-muted border-t border-border mt-12">
    <div class="container mx-auto px-4 py-6">
        <div class="flex flex-col md:flex-row justify-between items-center">
            <div class="flex items-center space-x-2 mb-4 md:mb-0">
                <i class="fas fa-stethoscope text-primary"></i>
                <span class="font-semibold">Télé-Expertise</span>
            </div>
            <div class="text-sm text-muted-foreground">
                &copy; 2023 Télé-Expertise. Tous droits réservés.
            </div>
        </div>
    </div>
</footer>

<!-- Popup de calendrier -->
<div id="calendarPopup" class="calendar-popup hidden">
    <div class="calendar-content">
        <div class="text-center mb-6">
            <h3 class="text-xl font-bold text-foreground mb-2">Choisir une date</h3>
            <p id="specialistName" class="text-muted-foreground">Dr. Spécialiste</p>
        </div>

        <div class="mb-6">
            <label for="calendarDate" class="block text-sm font-medium text-foreground mb-3">
                Sélectionnez la date de consultation *
            </label>
            <input type="text" id="calendarDate"
                   class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                   placeholder="Choisir une date...">
        </div>


        <div class="flex space-x-3">
            <button type="button" id="cancelCalendar"
                    class="flex-1 px-4 py-3 border border-border rounded-xl text-foreground hover:bg-muted transition-colors font-medium">
                Annuler
            </button>

        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    // Structure de données pour stocker les spécialistes et leurs créneaux
    const specialistesData = {
        <c:forEach var="entry" items="${specialistesParSpecialite}" varStatus="loop">
        '${entry.key.nom}': {
            description: '${entry.key.description}',
            specialistes: [
                <c:forEach var="specialiste" items="${entry.value}" varStatus="innerLoop">
                {
                    id: ${specialiste.id},
                    nom: '${specialiste.nom}',
                    prenom: '${specialiste.prenom}',
                    email: '${specialiste.email}',
                    telephone: '${specialiste.telephone != null ? specialiste.telephone : ''}',
                    tarif: ${specialiste.tarif != null ? specialiste.tarif : 0},
                    creneaux: [
                        <c:forEach var="creneau" items="${creneauxParSpecialiste[specialiste]}" varStatus="creneauLoop">
                        {
                            id: ${creneau.id},
                            dateHeure: '${creneau.dateHeure}',
                            disponible: ${creneau.disponible},
                            dureeMinutes: ${creneau.dureeMinutes != null ? creneau.dureeMinutes : 30}
                        }${!creneauLoop.last ? ',' : ''}
                        </c:forEach>
                    ]
                }${!innerLoop.last ? ',' : ''}
                </c:forEach>
            ]
        }${!loop.last ? ',' : ''}
        </c:forEach>
    };

    // Variables globales
    let selectedSpecialiste = null;
    let datePicker = null; // Instance de Flatpickr pour la date
    let selectedDateTimeString = null; // ISO format (YYYY-MM-DDTXX:XX:00)
    let heuresParDateCache = {}; // Cache pour stocker les heures par date [YYYY-MM-DD]

    // DÉPLACER LA FONCTION createSpecialisteCard EN DEHORS DE DOMContentLoaded
    function createSpecialisteCard(specialiste) {
        const card = document.createElement('div');
        card.className = 'specialiste-card border border-gray-200 rounded-xl p-4 cursor-pointer bg-white hover:bg-gray-50 transition-all';
        // ... (Logique d'affichage de la carte du spécialiste) ...

        const content = document.createElement('div');
        content.className = 'flex flex-col';

        // Informations du spécialiste
        const info = document.createElement('div');
        info.className = 'flex-1';
        let nom = specialiste.nom;
        let prenom = specialiste.prenom;
        const name = document.createElement('div');
        name.className = 'font-semibold text-gray-900 text-lg';
        let emailuser = specialiste.email
        name.textContent = `Dr : `+ nom + ` `+ prenom  ;

        const email = document.createElement('div');
        email.className = 'text-sm text-gray-600 mt-1';
        email.innerHTML = `<i class="fas fa-envelope mr-2"></i>`;
        email.append(document.createTextNode(emailuser));

        const tarif = document.createElement('div');
        tarif.className = 'text-sm font-semibold text-primary mt-1';
        tarif.innerHTML = `<i class="fas fa-euro-sign mr-2"></i>`+ ' ' + specialiste.tarif + ' ' + `DH`;

        info.appendChild(name);
        info.appendChild(email);
        info.appendChild(tarif);

        // Affichage des créneaux disponibles
        const creneauxSection = document.createElement('div');
        creneauxSection.className = 'mt-4';

        const creneauxTitle = document.createElement('div');
        creneauxTitle.className = 'text-sm font-medium text-gray-700 mb-2';
        const creneauxList = document.createElement('div');

        // Filtrer les créneaux disponibles (qui sont dans le futur)
        const creneauxDisponibles = specialiste.creneaux.filter(creneau => {
            const creneauDate = new Date(creneau.dateHeure);
            // Si creneauDate est "Invalid Date", elle échoue la comparaison, ce qui est correct.
            return creneau.disponible && creneauDate > new Date();
        });


        creneauxSection.appendChild(creneauxTitle);
        creneauxSection.appendChild(creneauxList);

        // Bouton de sélection
        const selectButton = document.createElement('button');
        selectButton.type = 'button';
        selectButton.className = 'mt-3 w-full bg-primary text-white py-2 px-4 rounded-lg hover:bg-opacity-90 transition-colors font-medium disabled:bg-gray-400 disabled:cursor-not-allowed';
        selectButton.innerHTML = '<i class="fas fa-calendar-check mr-2"></i>Choisir ce spécialiste';
        selectButton.disabled = creneauxDisponibles.length === 0;

        selectButton.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            if (creneauxDisponibles.length === 0) return;

            // Réinitialiser la sélection de l'heure précédente
            selectedDateTimeString = null;

            // Sélectionner le spécialiste
            selectedSpecialiste = specialiste;

            // Mettre à jour l'apparence visuelle
            // document.querySelectorAll('.specialiste-card').forEach(card => {
            //     card.classList.remove('border-primary', 'bg-primary/5', 'ring-2', 'ring-primary');
            // });
            card.classList.add('border-primary', 'bg-primary/5', 'ring-2', 'ring-primary');

            // Afficher le popup de calendrier avec les créneaux disponibles
            showCalendarPopup(specialiste, creneauxDisponibles);
        });

        content.appendChild(info);
        content.appendChild(creneauxSection);
        content.appendChild(selectButton);
        card.appendChild(content);

        return card;
    }

    // DÉPLACER loadSpecialistes AUSSI EN DEHORS
    function loadSpecialistes(specialiteNom) {
        const specialiteData = specialistesData[specialiteNom];

        if (!specialiteData) {
            showEmptyState();
            return;
        }

        const specialistes = specialiteData.specialistes;
        const specialistesList = document.getElementById('specialistesList');
        const selectedSpecialiteName = document.getElementById('selectedSpecialiteName');
        const selectedSpecialiteDescription = document.getElementById('selectedSpecialiteDescription');

        // Mettre à jour l'en-tête
        selectedSpecialiteName.textContent = specialiteNom;
        selectedSpecialiteDescription.textContent = specialiteData.description;

        // Vider la liste actuelle
        specialistesList.innerHTML = '';

        if (specialistes.length === 0) {
            showEmptySpecialistes();
            return;
        }

        // Ajouter les spécialistes
        specialistes.forEach(specialiste => {
            const specialisteCard = createSpecialisteCard(specialiste);
            specialistesList.appendChild(specialisteCard);
        });

        // Afficher le container
        specialistesContainer.classList.remove('hidden');
        noSpecialistes.classList.add('hidden');
        emptySpecialistes.classList.add('hidden');
    }

    // DÉPLACER CES FONCTIONS AUSSI
    function showEmptyState() {
        const specialistesContainer = document.getElementById('specialistesContainer');
        const noSpecialistes = document.getElementById('noSpecialistes');
        const emptySpecialistes = document.getElementById('emptySpecialistes');

        specialistesContainer.classList.add('hidden');
        noSpecialistes.classList.remove('hidden');
        emptySpecialistes.classList.add('hidden');
    }

    function showEmptySpecialistes() {
        const specialistesContainer = document.getElementById('specialistesContainer');
        const noSpecialistes = document.getElementById('noSpecialistes');
        const emptySpecialistes = document.getElementById('emptySpecialistes');

        specialistesContainer.classList.add('hidden');
        noSpecialistes.classList.add('hidden');
        emptySpecialistes.classList.remove('hidden');
    }

    function showCalendarPopup(specialiste, creneauxDisponibles) {
        const popup = document.getElementById('calendarPopup');
        const specialistName = document.getElementById('specialistName');

        // Mettre à jour le nom du spécialiste
        specialistName.textContent = `Dr. `+  specialiste.nom +' '+ specialiste.prenom;

        // Afficher le popup
        popup.classList.remove('hidden');

        // Initialiser les sélecteurs de date et heure avec les créneaux disponibles
        initializeDatePickers(creneauxDisponibles,specialiste);
    }

    function initializeDatePickers(creneauxDisponibles,specialiste) {
        // Extraire les dates et heures disponibles
        const datesDisponibles = creneauxDisponibles.map(creneau => new Date(creneau.dateHeure));
        const allDateStrings = datesDisponibles.map(date => {
            if (isNaN(date.getTime())) return null;
            return date.toISOString().split('T')[0];
        });

        const validDateStrings = allDateStrings.filter(dateStr => dateStr !== null);

        const datesUniques = [...new Set(validDateStrings)];

        // Vider le cache des heures et le remplir à nouveau
        heuresParDateCache = {};
        creneauxDisponibles.forEach(creneau => {
            const date = new Date(creneau.dateHeure);
            if (isNaN(date.getTime())) return; // Ignorer les créneaux invalides

            // *** CORRECTION 1: Utiliser la même clé ISO pour le cache ***
            const dateStrISO = date.toISOString().split('T')[0];

            // Format HH:MM
            const timeStr = date.toLocaleTimeString('fr-FR', {
                hour: '2-digit',
                minute: '2-digit'
            });

            if (!heuresParDateCache[dateStrISO]) {
                heuresParDateCache[dateStrISO] = [];
            }
            heuresParDateCache[dateStrISO].push(timeStr);
        });

        // Initialiser/Mettre à jour le date picker
        if (!datePicker) {
            datePicker = flatpickr("#calendarDate", {
                locale: "fr",
                minDate: new Date(),
                dateFormat: "d/m/Y",
                disableMobile: true,
                // S'assurer que Flatpickr est configuré pour n'activer que les jours avec des créneaux valides
                enable: datesUniques.map(dateStr => new Date(dateStr)),
                onChange: function(selectedDates) {
                    if (selectedDates.length > 0) {
                        // Réinitialiser la sélection d'heure à chaque changement de date
                        selectedDateTimeString = null;

                        // *** CORRECTION 2: Utiliser la même extraction ISO pour l'appel à showTimePopup ***
                        const selectedDateISO = selectedDates[0].toISOString().split('T')[0];

                        // Masquer le calendrier principal et afficher le popup de temps
                        document.getElementById('calendarPopup').classList.add('hidden');
                        showTimePopup(selectedDateISO, heuresParDateCache,specialiste,creneauxDisponibles);
                    }
                }
            });
        } else {
            // Mettre à jour les dates si le datePicker existe déjà
            datePicker.set('enable', datesUniques.map(dateStr => new Date(dateStr)));
            datePicker.setDate(null);
        }
    }

    function showTimePopup(selectedDateISO, heuresParDate,specialiste,creneauxDisponibles) {
        // Utiliser selectedDateISO (YYYY-MM-DD) pour la recherche des heures
        const heuresDisponibles = heuresParDate[selectedDateISO] || [];
        const popup = document.getElementById('timePopup');
        const selectedDateText = document.getElementById('selectedDateText');
        const availableTimes = document.getElementById('availableTimes');
        const noSlotsMessage = document.getElementById('noSlotsMessage');

        // Formater la date en français pour l'affichage dans le popup
        // Note: Créer une nouvelle date en utilisant le format YYYY-MM-DD est sûr.
        const dateObj = new Date(selectedDateISO);
        const formattedDate = dateObj.toLocaleDateString('fr-FR', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });

        // Mettre à jour le texte de la date sélectionnée
        selectedDateText.textContent = `Pour le `+formattedDate;

        // Vider le conteneur des créneaux
        availableTimes.innerHTML = '';

        if (heuresDisponibles.length > 0) {

            noSlotsMessage.classList.add('hidden');
            availableTimes.classList.remove('hidden');

            heuresDisponibles.sort().forEach(time => {
                const timeButton = document.createElement('button');
                timeButton.type = 'button';
                timeButton.className = 'time-slot bg-white border-2 border-blue-500 text-blue-600 rounded-lg py-3 px-4 text-sm font-medium hover:bg-blue-500 hover:text-white transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50';
                timeButton.textContent = time;
                timeButton.dataset.time = time;

                const fullDateTimeString = selectedDateISO+'T'+time;
                // *** RECHERCHE DE L'ID DU CRÉNEAU CORRESPONDANT (DÉFINITION CORRECTE DE matchingCreneau) ***
                const matchingCreneau = creneauxDisponibles.find(c =>
                    c.dateHeure.startsWith(fullDateTimeString) // Utilisation de startsWith pour la sécurité
                );

                console.log(matchingCreneau);

                const creneauId = matchingCreneau ? matchingCreneau.id : null;
                timeButton.dataset.creneauId = creneauId;

                if (creneauId === null) {
                    timeButton.disabled = true;
                    timeButton.textContent = time + " (Indisponible)";
                    timeButton.classList.remove('bg-white', 'border-blue-500', 'text-blue-600', 'hover:bg-blue-500', 'hover:text-white', 'focus:ring-2', 'focus:ring-blue-300', 'focus:ring-opacity-50');
                    timeButton.classList.add('bg-gray-200', 'text-gray-500', 'cursor-not-allowed', 'border-gray-300'); // Ajout de bordure grise pour le style
                }

                timeButton.addEventListener('click', function() {
                    selectTime(time, selectedDateISO,specialiste,creneauId);
                });

                availableTimes.appendChild(timeButton);
            });
        } else {
            // Aucun créneau disponible
            availableTimes.classList.add('hidden');
            noSlotsMessage.classList.remove('hidden');
        }

        // Afficher la popup de temps
        popup.classList.remove('hidden');
        popup.classList.add('flex');
    }

    function selectTime(time, date,specialiste,creneauId) {

        const dateTimeString = `${date}T${time}:00`;
        console.log(time,date);

        if (creneauId === null) {
            console.error('ERREUR: ID de créneau non trouvé pour cette heure.');
            return;
        }

        // 4. Affichage dans la console
        console.log('Créneau sélectionné (Affichage Formatté) :', time);
        console.log('Créneau sélectionné (Format ISO pour envoi serveur) :', date);
        console.log(specialiste.id);

        console.log('Créneau ID (pour DB) :', creneauId);

        selectedDateTimeString = dateTimeString;
        document.getElementById('calendarTime').value = time;
        document.getElementById('Date').value = date;
        document.getElementById("idSpicialiste").value = specialiste.id;
        document.getElementById("crenaeuId").value = creneauId;
        closeTimePopup();
        document.getElementById('calendarPopup').classList.add('hidden');
        showConfirmation(`Créneau sélectionné: `+ time+ '  '+ date);
    }

    function closeTimePopup() {
        const popup = document.getElementById('timePopup');
        popup.classList.add('hidden');
        popup.classList.remove('flex');
    }

    function showConfirmation(text) {
        Swal.fire({
            icon: 'info',
            title: 'Créneau sélectionné',
            text: text,
            confirmButtonText: 'OK',
            confirmButtonColor: '#10b981',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });
    }

    function showValidationError(message) {
        Swal.fire({
            icon: 'warning',
            title: 'Champ manquant',
            text: message,
            confirmButtonText: 'OK',
            confirmButtonColor: '#f59e0b'
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        // Gestion des checkboxes
        const checkboxes = document.querySelectorAll('.checkbox-card input[type="checkbox"]');
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function () {
                if (this.checked) {
                    this.closest('.checkbox-card').classList.add('selected');
                } else {
                    this.closest('.checkbox-card').classList.remove('selected');
                }
            });
        });

        // Gestion du statut pour afficher/masquer la section spécialiste
        const statutSelect = document.getElementById('statut');
        const specialistSection = document.getElementById('specialistSection');
        const specialiteFilter = document.getElementById('specialiteFilter');

        // Déclarer ces variables globalement pour qu'elles soient accessibles partout
        window.specialistesContainer = document.getElementById('specialistesContainer');
        window.noSpecialistes = document.getElementById('noSpecialistes');
        window.emptySpecialistes = document.getElementById('emptySpecialistes');

        function toggleSpecialistSection() {
            if (statutSelect.value === 'EN_ATTENTE_AVIS_SPECIALISTE') {
                specialistSection.classList.remove('hidden');
                document.getElementById('priorite').classList.remove('hidden')
                document.getElementById('donneesAnalyses').classList.remove('hidden')
                document.getElementById('question').classList.remove('hidden')
                specialiteFilter.required = true;
                resetSpecialistesSection();
            } else {
                specialistSection.classList.add('hidden');
                specialiteFilter.required = false;
                selectedDateTimeString = null; // Réinitialiser l'heure
            }
        }

        function resetSpecialistesSection() {
            window.specialistesContainer.classList.add('hidden');
            window.noSpecialistes.classList.remove('hidden');
            window.emptySpecialistes.classList.add('hidden');
            specialiteFilter.value = '';
            selectedDateTimeString = null;
        }

        // Gestion des boutons du popup de calendrier
        document.getElementById('cancelCalendar').addEventListener('click', function() {
            document.getElementById('calendarPopup').classList.add('hidden');
            selectedSpecialiste = null;
            selectedDateTimeString = null; // Réinitialiser la date/heure
            // document.getElementById('calendarTime').value = '';
        });

        // Fermer le popup de temps en cliquant sur la croix
        document.getElementById('closePopup').addEventListener('click', closeTimePopup);

        // Fermer la popup de temps en cliquant à l'extérieur
        document.getElementById('timePopup').addEventListener('click', function(e) {
            if (e.target.id === 'timePopup') {
                closeTimePopup();
            }
        });


        // GESTIONNAIRE DE CONFIRMATION FINAL DANS LE POPUP DU CALENDRIER

        // Événements
        if (statutSelect && specialistSection) {
            statutSelect.addEventListener('change', toggleSpecialistSection);
            toggleSpecialistSection();
        }

        if (specialiteFilter) {
            specialiteFilter.addEventListener('change', function() {
                if (this.value) {
                    loadSpecialistes(this.value);
                } else {
                    resetSpecialistesSection();
                }
            });
        }

        // Compteur de caractères pour les textarea
        const textareas = document.querySelectorAll('textarea[maxlength]');
        textareas.forEach(textarea => {
            const maxLength = parseInt(textarea.getAttribute('maxlength'));
            const counter = document.createElement('div');
            counter.className = 'text-xs text-muted-foreground mt-1 text-right';
            counter.textContent = `0 / ${maxLength}`;
            textarea.parentNode.appendChild(counter);

            textarea.addEventListener('input', function() {
                const currentLength = this.value.length;
                counter.textContent = `${currentLength} / ${maxLength}`;

                if (currentLength > maxLength * 0.9) {
                    counter.classList.add('text-red-500');
                } else {
                    counter.classList.remove('text-red-500');
                }
            });
        });

        // Validation du formulaire
        const form = document.getElementById('consultationForm');
        if (form) {
            form.addEventListener('submit', function(e) {
                const motif = document.getElementById('motif');
                const statut = document.getElementById('statut');
                let isValid = true;

                if (!motif.value.trim()) {
                    e.preventDefault();
                    showValidationError('Le motif de consultation est obligatoire');
                    motif.focus();
                    isValid = false;
                }

                if (isValid && !statut.value.trim()) {
                    e.preventDefault();
                    showValidationError('Veuillez sélectionner un statut');
                    statut.focus();
                    isValid = false;
                }


                return isValid;
            });
        }

        // Affichage des alertes d'erreur/succès au chargement
        <% if (request.getAttribute("successMessage") != null) { %>
        Swal.fire({
            icon: 'success',
            title: 'Opération réussie !',
            text: '<%= request.getAttribute("successMessage") %>',
            confirmButtonText: 'Continuer',
            confirmButtonColor: '#10b981',
            timer: 4000,
            timerProgressBar: true
        });
        <% } else if (request.getAttribute("errorMessage") != null) { %>
        Swal.fire({
            icon: 'error',
            title: 'Erreur',
            text: '<%= request.getAttribute("errorMessage") %>',
            confirmButtonText: 'Fermer',
            confirmButtonColor: '#ef4444'
        });
        <% } %>

        if (window.history.replaceState) {
            const cleanURL = window.location.pathname + window.location.search.replace(/[?&](error|success|message)=[^&]*/g, '');
            window.history.replaceState(null, null, cleanURL);
        }
    });
</script>
</body>
</html>