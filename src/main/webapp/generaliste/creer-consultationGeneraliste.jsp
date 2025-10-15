<%@ page import="tele_expertise.enums.RoleUtilisateur" %>
<%@ page import="tele_expertise.enums.StatutConsultation" %>
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
        switch(error) {
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
                <span class="text-sm">Connecté en tant que: <span class="font-semibold">${sessionScope.loggedUser}</span></span>
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
    <div class="container mx-auto px-4">
        <div class="flex space-x-1 overflow-x-auto">
            <a href="${pageContext.request.contextPath}/dashboard" class="px-4 py-3 text-muted-foreground hover:text-foreground transition-colors whitespace-nowrap">
                <i class="fas fa-tachometer-alt mr-2"></i>Tableau de bord
            </a>
            <a href="#" class="px-4 py-3 text-primary border-b-2 border-primary font-medium whitespace-nowrap">
                <i class="fas fa-plus-circle mr-2"></i>Nouvelle consultation
            </a>
            <a href="${pageContext.request.contextPath}/medecin/historique-consultations" class="px-4 py-3 text-muted-foreground hover:text-foreground transition-colors whitespace-nowrap">
                <i class="fas fa-history mr-2"></i>Historique
            </a>
            <a href="${pageContext.request.contextPath}/patients" class="px-4 py-3 text-muted-foreground hover:text-foreground transition-colors whitespace-nowrap">
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
            <p class="text-muted-foreground">Remplissez les informations nécessaires pour créer une nouvelle demande de télé-expertise</p>

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
            <form action="${pageContext.request.contextPath}/medecin/creer-consultation" method="post" class="p-8">
                <input type="hidden" name="csrfToken" value="<%= csrf != null ? csrf : "" %>">
                <input type="hidden" name="patientId" value="${patient.id}">

                <!-- Consultation Status Section -->
                <div class="mb-10">
                    <h2 class="text-xl font-semibold text-foreground mb-6 flex items-center">
                        <i class="fas fa-info-circle text-primary mr-3"></i> Statut de la consultation
                    </h2>
                    <div class="space-y-4">
                        <div class="max-w-md">
                            <label for="statut" class="block text-sm font-medium text-foreground mb-2">Statut *</label>
                            <select id="statut" name="statut" class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input" required>
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

                <div class="mb-10">
                    <h2 class="text-xl font-semibold text-foreground mb-6 flex items-center">
                        <i class="fas fa-file-medical text-primary mr-3"></i> Informations cliniques
                    </h2>
                    <div class="space-y-6">
                        <div>
                            <label for="motif" class="block text-sm font-medium text-foreground mb-2">Motif de la consultation *</label>
                            <textarea id="motif" name="motif" rows="4" class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input" placeholder="Décrivez le motif de la consultation..." required maxlength="1000"></textarea>
                            <p class="text-xs text-muted-foreground mt-1">Maximum 1000 caractères</p>
                        </div>
                        <div>
                            <label for="diagnostic" class="block text-sm font-medium text-foreground mb-2">Diagnostic médicaux</label>
                            <textarea id="diagnostic" name="diagnostic" rows="3" class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input" placeholder="Antécédents médicaux du patient..." maxlength="500"></textarea>
                            <p class="text-xs text-muted-foreground mt-1">Maximum 500 caractères</p>
                        </div>
                        <div>
                            <label for="traitement" class="block text-sm font-medium text-foreground mb-2">Traitement en cours</label>
                            <textarea id="traitement" name="traitement" rows="3" class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input" placeholder="Traitement actuel du patient..." maxlength="500"></textarea>
                            <p class="text-xs text-muted-foreground mt-1">Maximum 500 caractères</p>
                        </div>
                        <div>
                            <label for="observations" class="block text-sm font-medium text-foreground mb-2">Observations</label>
                            <textarea id="observations" name="observations" rows="3" class="w-full px-4 py-3 border border-border rounded-xl bg-input focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all form-input" placeholder="Observations complémentaires..." maxlength="500"></textarea>
                            <p class="text-xs text-muted-foreground mt-1">Maximum 500 caractères</p>
                        </div>
                    </div>
                </div>

                <!-- Technical Acts Section -->
                <div class="mb-10">
                    <h2 class="text-xl font-semibold text-foreground mb-6 flex items-center">
                        <i class="fas fa-microscope text-primary mr-3"></i> Actes techniques
                    </h2>
                    <p class="text-muted-foreground mb-6">Sélectionnez un ou plusieurs actes techniques si nécessaire pour cette consultation.</p>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
                        <c:forEach var="acte" items="${actesTechniques}" varStatus="status">
                            <label class="checkbox-card border border-border rounded-xl p-5 cursor-pointer bg-input hover:bg-muted transition-all relative">
                                <input type="checkbox" name="actesTechniques" value="${acte.name()}" class="absolute opacity-0">
                                <div class="custom-checkbox absolute top-5 right-5"></div>
                                <div class="pr-6">
                                    <div class="font-semibold text-foreground">${acte.libelle}</div>
                                    <p class="text-base font-bold text-primary mt-3">${acte.cout} €</p>
                                </div>
                            </label>
                        </c:forEach>
                    </div>

                    <div class="flex items-center text-sm text-muted-foreground bg-muted p-4 rounded-xl">
                        <i class="fas fa-info-circle mr-3 text-primary"></i>
                        <span>Vous pouvez sélectionner plusieurs actes techniques. Le coût total sera calculé automatiquement.</span>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="flex flex-col sm:flex-row justify-between items-center pt-6 border-t border-border gap-4">
                    <button type="button" onclick="window.history.back()" class="w-full sm:w-auto px-8 py-3 border border-border rounded-xl text-foreground hover:bg-muted transition-colors font-medium">
                        <i class="fas fa-arrow-left mr-2"></i> Retour
                    </button>
                    <button type="submit" class="w-full sm:w-auto px-8 py-3 bg-primary text-primary-foreground rounded-xl font-semibold hover:bg-opacity-90 transition-colors shadow-md flex items-center justify-center">
                        <i class="fas fa-paper-plane mr-2"></i> Envoyer la demande
                    </button>
                </div>
            </form>
        </div>
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

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Script pour gérer la sélection visuelle des checkboxes
        const checkboxes = document.querySelectorAll('.checkbox-card input[type="checkbox"]');

        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                if (this.checked) {
                    this.closest('.checkbox-card').classList.add('selected');
                } else {
                    this.closest('.checkbox-card').classList.remove('selected');
                }
            });
        });

        // Gestion du changement de statut pour afficher/masquer des informations supplémentaires
        const statutSelect = document.getElementById('statut');
        if (statutSelect) {
            statutSelect.addEventListener('change', function() {
                console.log('Statut changé:', this.value);
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

        // Validation du formulaire avant soumission
        const form = document.querySelector('form');
        if (form) {
            form.addEventListener('submit', function(e) {
                const motif = document.getElementById('motif');
                const statut = document.getElementById('statut');

                if (!motif.value.trim()) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'warning',
                        title: 'Champ manquant',
                        text: 'Le motif de consultation est obligatoire',
                        confirmButtonText: 'OK'
                    });
                    motif.focus();
                    return false;
                }

                if (!statut.value.trim()) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'warning',
                        title: 'Champ manquant',
                        text: 'Veuillez sélectionner un statut',
                        confirmButtonText: 'OK'
                    });
                    statut.focus();
                    return false;
                }
            });
        }
    });
</script>

<script>
    // Gestion des messages de succès et d'erreur avec SweetAlert2
    <% if (request.getAttribute("successMessage") != null) { %>
    Swal.fire({
        icon: 'success',
        title: 'Opération réussie !',
        text: '<%= request.getAttribute("successMessage") %>',
        confirmButtonText: 'Continuer',
        confirmButtonColor: '#10b981',
        timer: 4000,
        timerProgressBar: true,
        showClass: {
            popup: 'animate__animated animate__fadeInDown'
        },
        hideClass: {
            popup: 'animate__animated animate__fadeOutUp'
        }
    }).then((result) => {
        if (result.isConfirmed) {
            // Redirection optionnelle après succès
            // window.location.href = '${pageContext.request.contextPath}/dashboard';
        }
    });
    <% } else if (request.getAttribute("errorMessage") != null) { %>
    Swal.fire({
        icon: 'error',
        title: 'Erreur',
        text: '<%= request.getAttribute("errorMessage") %>',
        confirmButtonText: 'Fermer',
        confirmButtonColor: '#ef4444',
        allowOutsideClick: true,
        allowEscapeKey: true,
        showClass: {
            popup: 'animate__animated animate__shakeX'
        },
        hideClass: {
            popup: 'animate__animated animate__fadeOut'
        }
    });
    <% } %>

    // Nettoyage des paramètres URL après affichage
    if (window.history.replaceState) {
        window.history.replaceState(null, null, window.location.pathname + window.location.search.replace(/[?&](error|success|message)=[^&]*/g, ''));
    }
</script>

</body>
</html>