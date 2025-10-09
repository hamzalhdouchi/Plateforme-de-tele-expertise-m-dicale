<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Infirmier</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
<div class="container mx-auto px-4 py-6">
    <!-- Header simple -->
    <header class="mb-8">
        <div class="flex justify-between items-center mb-4">

            <div>
                <h1 class="text-2xl font-bold text-gray-800">Module Infirmier</h1>
                <p class="text-gray-600">Accueil Patient</p>
            </div>
            <div class="flex items-center space-x-4">
                <div class="flex items-center space-x-2">
                    <div class="h-8 w-8 rounded-full bg-blue-500 flex items-center justify-center text-white text-sm font-bold">ID</div>
                    <c:if test="${not empty sessionScope.loggedUser.nom and not empty sessionScope.loggedUser.prenom}">
                        <span class="text-gray-700">
                            ${sessionScope.loggedUser.nom} ${sessionScope.loggedUser.prenom}
                        </span>
                    </c:if>

                </div>
            </div>
        </div>

        <!-- Navigation principale -->
        <nav class="flex space-x-4">
            <a href="RecherchePatient.jsp"
               class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600">
                Rechercher / Enregistrer Patient
            </a>
            <a href="listPatients.jsp"
               class="bg-white text-blue-500 border border-blue-500 px-4 py-2 rounded-lg hover:bg-blue-50">
                Liste des Patients
            </a>
        </nav>
    </header>


    <!-- Fonctionnalités principales -->
    <div class="mb-8">
        <h2 class="text-lg font-bold text-gray-800 mb-4">Fonctionnalités</h2>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div class="bg-white rounded-lg shadow p-4 border border-gray-200">
                <h3 class="font-bold text-gray-800 mb-2">Nouveau Patient</h3>
                <p class="text-gray-600 text-sm mb-3">Enregistrez un nouveau patient dans le système.</p>
                <a href="#" class="text-blue-500 text-sm font-medium">
                    Accéder →
                </a>
            </div>

            <div class="bg-white rounded-lg shadow p-4 border border-gray-200">
                <h3 class="font-bold text-gray-800 mb-2">Recherche</h3>
                <p class="text-gray-600 text-sm mb-3">Trouvez rapidement un patient.</p>
                <a href="#" class="text-blue-500 text-sm font-medium">
                    Accéder →
                </a>
            </div>

            <div class="bg-white rounded-lg shadow p-4 border border-gray-200">
                <h3 class="font-bold text-gray-800 mb-2">Dossiers Médicaux</h3>
                <p class="text-gray-600 text-sm mb-3">Gérez les dossiers des patients.</p>
                <a href="#" class="text-blue-500 text-sm font-medium">
                    Accéder →
                </a>
            </div>
        </div>
    </div>

    <!-- Patients récents -->
    <div class="bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-200">
            <h2 class="text-lg font-bold text-gray-800">Patients récents</h2>
        </div>

        <div class="overflow-x-auto">
            <table class="min-w-full">
                <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-sm font-medium text-gray-700">Patient</th>
                    <th class="px-6 py-3 text-left text-sm font-medium text-gray-700">Heure</th>
                    <th class="px-6 py-3 text-left text-sm font-medium text-gray-700">Statut</th>
                    <th class="px-6 py-3 text-left text-sm font-medium text-gray-700">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4">
                        <div class="text-sm font-medium text-gray-900">Martin Jean</div>
                        <div class="text-sm text-gray-500">ID: 45872</div>
                    </td>
                    <td class="px-6 py-4">
                        <div class="text-sm text-gray-900">08:45</div>
                    </td>
                    <td class="px-6 py-4">
                                <span class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded">
                                    En attente
                                </span>
                    </td>
                    <td class="px-6 py-4">
                        <a href="#" class="text-blue-500 hover:text-blue-700 mr-3">Voir</a>
                        <a href="#" class="text-blue-500 hover:text-blue-700">Modifier</a>
                    </td>
                </tr>

                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4">
                        <div class="text-sm font-medium text-gray-900">Sophie Dubois</div>
                        <div class="text-sm text-gray-500">ID: 45873</div>
                    </td>
                    <td class="px-6 py-4">
                        <div class="text-sm text-gray-900">09:20</div>
                    </td>
                    <td class="px-6 py-4">
                                <span class="bg-yellow-100 text-yellow-800 text-xs px-2 py-1 rounded">
                                    En cours
                                </span>
                    </td>
                    <td class="px-6 py-4">
                        <a href="#" class="text-blue-500 hover:text-blue-700 mr-3">Voir</a>
                        <a href="#" class="text-blue-500 hover:text-blue-700">Modifier</a>
                    </td>
                </tr>

                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4">
                        <div class="text-sm font-medium text-gray-900">Pierre Lambert</div>
                        <div class="text-sm text-gray-500">ID: 45874</div>
                    </td>
                    <td class="px-6 py-4">
                        <div class="text-sm text-gray-900">10:05</div>
                    </td>
                    <td class="px-6 py-4">
                                <span class="bg-red-100 text-red-800 text-xs px-2 py-1 rounded">
                                    Urgent
                                </span>
                    </td>
                    <td class="px-6 py-4">
                        <a href="#" class="text-blue-500 hover:text-blue-700 mr-3">Voir</a>
                        <a href="#" class="text-blue-500 hover:text-blue-700">Modifier</a>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pied de page simple -->
    <footer class="mt-8 pt-4 border-t border-gray-200 text-center text-gray-500 text-sm">
        <p>© 2023 Module Infirmier - Système de gestion des patients</p>
    </footer>
</div>
</body>
</html>