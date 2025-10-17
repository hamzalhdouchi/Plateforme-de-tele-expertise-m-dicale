<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Digital Clinic</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
</head>
<body class="bg-background text-foreground font-sans antialiased">
<div class="min-h-screen flex">
    <!-- Sidebar -->
    <div class="hidden lg:flex lg:w-1/2 bg-primary items-center justify-center p-12">
        <div class="max-w-md text-primary-foreground">
            <div class="mb-8">
                <svg class="w-12 h-12 mb-4" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M2 17L12 22L22 17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M2 12L12 17L22 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <h1 class="text-4xl font-bold mb-2">Digital Clinic</h1>
                <p class="text-lg opacity-90">Healthcare Management System</p>
            </div>
            <p class="text-base leading-relaxed opacity-80">
                Secure access to patient records, appointments, and medical data.
                Streamline your healthcare practice with our comprehensive digital solution.
            </p>
        </div>
    </div>

    <!-- Formulaire d'inscription -->
    <div class="flex-1 flex items-center justify-center p-8">
        <div class="w-full max-w-md">
            <!-- Logo mobile -->
            <div class="lg:hidden mb-8 text-center">
                <h1 class="text-2xl font-bold text-primary">Digital Clinic</h1>
                <p class="text-sm text-muted-foreground">Healthcare Management System</p>
            </div>

            <!-- Titre -->
            <div class="mb-8">
                <h2 class="text-3xl font-bold mb-2">Créer un compte</h2>
                <p class="text-muted-foreground">Rejoignez notre plateforme médicale</p>
            </div>

            <!-- Messages d'erreur -->
            <c:if test="${not empty param.error}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-sm text-red-800">
                    <c:choose>
                        <c:when test="${param.error == 'email'}">Cet email est déjà utilisé</c:when>
                        <c:when test="${param.error == 'password'}">Le mot de passe doit contenir au moins 8 caractères</c:when>
                        <c:when test="${param.error == 'specialite'}">Veuillez sélectionner une spécialité et un tarif valide</c:when>
                        <c:when test="${param.error == 'csrf'}">Erreur de sécurité</c:when>
                        <c:when test="${param.error == 'failed'}">Échec de l'inscription. Veuillez réessayer</c:when>
                        <c:otherwise>Erreur lors de l'inscription</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- Formulaire -->
            <%
                String csrfToken = (String) session.getAttribute("csrfToken");
                if (csrfToken == null) {
                    csrfToken = java.util.UUID.randomUUID().toString();
                    session.setAttribute("csrfToken", csrfToken);
                }
            %>
            <form action="${pageContext.request.contextPath}/Register" method="post" class="space-y-6" id="registerForm">
                <input type="hidden" name="csrfToken" value="<%= csrfToken %>">

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium mb-2">Prénom *</label>
                        <input
                                type="text"
                                name="firstName"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                value="${param.firstName}"
                        />
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-2">Nom *</label>
                        <input
                                type="text"
                                name="lastName"
                                required
                                class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                value="${param.lastName}"
                        />
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium mb-2">Email *</label>
                    <input
                            type="email"
                            name="email"
                            required
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            placeholder="votre.email@exemple.com"
                            value="${param.email}"
                    />
                </div>

                <div>
                    <label class="block text-sm font-medium mb-2">Rôle *</label>
                    <select
                            name="role"
                            required
                            id="roleSelect"
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                    >
                        <option value="">Choisir un rôle</option>
                        <option value="GENERALISTE" ${param.role == 'GENERALISTE' ? 'selected' : ''}>Médecin Généraliste</option>
                        <option value="SPECIALISTE" ${param.role == 'SPECIALISTE' ? 'selected' : ''}>Spécialiste</option>
                        <option value="INFIRMIER" ${param.role == 'INFIRMIER' ? 'selected' : ''}>Infirmier</option>
                    </select>
                </div>

                <!-- Champs Spécialiste (conditionnels) -->
                <div id="specialisteFields" style="display: none;">
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium mb-2">Spécialité *</label>
                            <select
                                    name="specialiteId"
                                    class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            >
                                <option value="">Choisir une spécialité</option>
                                <c:forEach var="specialite" items="${specialites}">
                                    <option value="${specialite.id}">${specialite.nom}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-2">Tarif (DH) *</label>
                            <input
                                    type="number"
                                    name="tarif"
                                    step="0.01"
                                    min="0"
                                    class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                    placeholder="50.00"
                            />
                        </div>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium mb-2">Téléphone</label>
                    <input
                            type="tel"
                            name="telephone"
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            placeholder="+33 6 12 34 56 78"
                            value="${param.telephone}"
                    />
                </div>

                <div>
                    <label class="block text-sm font-medium mb-2">Mot de passe *</label>
                    <input
                            type="password"
                            name="password"
                            required
                            minlength="8"
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            placeholder="••••••••"
                    />
                </div>

                <div>
                    <label class="block text-sm font-medium mb-2">Confirmer *</label>
                    <input
                            type="password"
                            name="confirmPassword"
                            required
                            minlength="8"
                            class="w-full px-4 py-3 bg-input border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            placeholder="••••••••"
                    />
                </div>

                <button
                        type="submit"
                        class="w-full bg-primary text-primary-foreground py-3 px-4 rounded-lg font-medium hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all"
                >
                    S'inscrire
                </button>
            </form>

            <!-- Lien connexion -->
            <div class="mt-6 text-center">
                <p class="text-sm text-muted-foreground">
                    Déjà un compte ?
                    <a href="${pageContext.request.contextPath}/Login"
                       class="text-primary font-medium hover:underline">
                        Se connecter
                    </a>
                </p>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('roleSelect').addEventListener('change', function() {
        const fields = document.getElementById('specialisteFields');
        const isSpecialiste = this.value === 'SPECIALISTE';
        fields.style.display = isSpecialiste ? 'block' : 'none';

        // Marquer les champs spécialité comme requis si spécialiste
        const specialiteSelect = fields.querySelector('select[name="specialiteId"]');
        const tarifInput = fields.querySelector('input[name="tarif"]');
        if (isSpecialiste) {
            specialiteSelect.required = true;
            tarifInput.required = true;
        } else {
            specialiteSelect.required = false;
            tarifInput.required = false;
        }
    });

    // Validation confirmation mot de passe
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const password = document.querySelector('input[name="password"]').value;
        const confirmPassword = document.querySelector('input[name="confirmPassword"]').value;

        if (password !== confirmPassword) {
            e.preventDefault();
            alert('Les mots de passe ne correspondent pas');
            return false;
        }

        // Validation tarif pour spécialiste
        const role = document.getElementById('roleSelect').value;
        if (role === 'SPECIALISTE') {
            const specialiteId = document.querySelector('select[name="specialiteId"]').value;
            const tarif = document.querySelector('input[name="tarif"]').value;

            if (!specialiteId) {
                e.preventDefault();
                alert('Veuillez sélectionner une spécialité');
                return false;
            }

            if (!tarif || parseFloat(tarif) <= 0) {
                e.preventDefault();
                alert('Le tarif doit être supérieur à 0');
                return false;
            }
        }
    });
</script>
</body>
</html>