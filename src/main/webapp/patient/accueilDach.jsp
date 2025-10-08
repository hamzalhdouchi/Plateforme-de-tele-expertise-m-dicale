<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Infirmier</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#eff6ff',
                            100: '#dbeafe',
                            200: '#bfdbfe',
                            300: '#93c5fd',
                            400: '#60a5fa',
                            500: '#3b82f6',
                            600: '#2563eb',
                            700: '#1d4ed8',
                            800: '#1e40af',
                            900: '#1e3a8a',
                        }
                    }
                }
            }
        }
    </script>
    <style>
        .glass-effect {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .dashboard-card {
            transition: all 0.3s ease;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px -5px rgba(59, 130, 246, 0.4);
        }
    </style>
</head>
<body class="bg-gradient-to-br from-blue-50 to-blue-100 min-h-screen">
<div class="container mx-auto px-4 py-8">
    <!-- Header -->
    <header class="mb-10">
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-3xl font-bold text-blue-800">Module Infirmier</h1>
                <p class="text-blue-600">Accueil Patient</p>
            </div>
            <div class="flex items-center space-x-4">
                <div class="relative">
                    <i class="fas fa-bell text-blue-600 text-xl"></i>
                    <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">3</span>
                </div>
                <div class="flex items-center space-x-2">
                    <div class="h-10 w-10 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold">ID</div>
                    <span class="text-blue-800 font-medium">Infirmier Dupont</span>
                </div>
            </div>
        </div>

        <!-- Navigation principale -->
        <nav class="flex space-x-4 mb-8">
            <a href="${pageContext.request.contextPath}/search-patient"
               class="px-4 py-2 bg-blue-600 text-white rounded-lg flex items-center space-x-2 hover:bg-blue-700 transition-colors">
                <i class="fas fa-search"></i>
                <span>Rechercher / Enregistrer Patient</span>
            </a>
            <a href="${pageContext.request.contextPath}/patient-list"
               class="px-4 py-2 bg-white text-blue-600 border border-blue-600 rounded-lg flex items-center space-x-2 hover:bg-blue-50 transition-colors">
                <i class="fas fa-list"></i>
                <span>Liste des Patients du Jour</span>
            </a>
        </nav>
    </header>

    <!-- Section de bienvenue et statistiques -->
    <div class="mb-10">
        <div class="glass-effect rounded-xl p-6 shadow-lg mb-8">
            <h2 class="text-2xl font-bold text-blue-800 mb-2">Bienvenue dans le système de gestion des patients</h2>
            <p class="text-blue-600 mb-6">Sélectionnez une option ci-dessus pour commencer.</p>

            <!-- Statistiques rapides -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="bg-white rounded-lg p-4 shadow-md border-l-4 border-blue-500">
                    <div class="flex justify-between items-center">
                        <div>
                            <p class="text-blue-500 text-sm font-medium">Patients aujourd'hui</p>
                            <p class="text-2xl font-bold text-blue-800">24</p>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center">
                            <i class="fas fa-user-injured text-blue-500 text-xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg p-4 shadow-md border-l-4 border-green-500">
                    <div class="flex justify-between items-center">
                        <div>
                            <p class="text-green-500 text-sm font-medium">En attente</p>
                            <p class="text-2xl font-bold text-blue-800">8</p>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-green-100 flex items-center justify-center">
                            <i class="fas fa-clock text-green-500 text-xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg p-4 shadow-md border-l-4 border-purple-500">
                    <div class="flex justify-between items-center">
                        <div>
                            <p class="text-purple-500 text-sm font-medium">Soins urgents</p>
                            <p class="text-2xl font-bold text-blue-800">3</p>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-purple-100 flex items-center justify-center">
                            <i class="fas fa-exclamation-triangle text-purple-500 text-xl"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Section des fonctionnalités principales -->
    <div class="mb-10">
        <h2 class="text-xl font-bold text-blue-800 mb-6">Fonctionnalités principales</h2>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <!-- Carte 1 -->
            <div class="dashboard-card bg-white rounded-xl p-6 shadow-md border border-blue-100">
                <div class="h-12 w-12 rounded-lg bg-blue-100 flex items-center justify-center mb-4">
                    <i class="fas fa-user-plus text-blue-600 text-xl"></i>
                </div>
                <h3 class="text-lg font-bold text-blue-800 mb-2">Nouveau Patient</h3>
                <p class="text-blue-600 text-sm mb-4">Enregistrez un nouveau patient dans le système.</p>
                <a href="#" class="text-blue-500 font-medium text-sm flex items-center">
                    Accéder <i class="fas fa-arrow-right ml-2"></i>
                </a>
            </div>

            <!-- Carte 2 -->
            <div class="dashboard-card bg-white rounded-xl p-6 shadow-md border border-blue-100">
                <div class="h-12 w-12 rounded-lg bg-blue-100 flex items-center justify-center mb-4">
                    <i class="fas fa-search text-blue-600 text-xl"></i>
                </div>
                <h3 class="text-lg font-bold text-blue-800 mb-2">Recherche Avancée</h3>
                <p class="text-blue-600 text-sm mb-4">Trouvez rapidement un patient par nom, ID ou date.</p>
                <a href="#" class="text-blue-500 font-medium text-sm flex items-center">
                    Accéder <i class="fas fa-arrow-right ml-2"></i>
                </a>
            </div>

            <!-- Carte 3 -->
            <div class="dashboard-card bg-white rounded-xl p-6 shadow-md border border-blue-100">
                <div class="h-12 w-12 rounded-lg bg-blue-100 flex items-center justify-center mb-4">
                    <i class="fas fa-file-medical text-blue-600 text-xl"></i>
                </div>
                <h3 class="text-lg font-bold text-blue-800 mb-2">Dossiers Médicaux</h3>
                <p class="text-blue-600 text-sm mb-4">Accédez et gérez les dossiers médicaux des patients.</p>
                <a href="#" class="text-blue-500 font-medium text-sm flex items-center">
                    Accéder <i class="fas fa-arrow-right ml-2"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Section des patients récents -->
    <div class="mb-10">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-xl font-bold text-blue-800">Patients récents</h2>
            <a href="#" class="text-blue-500 text-sm font-medium flex items-center">
                Voir tout <i class="fas fa-chevron-right ml-1"></i>
            </a>
        </div>

        <div class="bg-white rounded-xl shadow-md overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-blue-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-blue-500 uppercase tracking-wider">Patient</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-blue-500 uppercase tracking-wider">Heure d'arrivée</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-blue-500 uppercase tracking-wider">Statut</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-blue-500 uppercase tracking-wider">Actions</th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <tr>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center">
                            <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-800 font-bold mr-3">MJ</div>
                            <div>
                                <div class="text-sm font-medium text-blue-800">Martin Jean</div>
                                <div class="text-sm text-blue-600">ID: 45872</div>
                            </div>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-blue-800">08:45</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                    En attente
                                </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-blue-500">
                        <a href="#" class="hover:text-blue-700 mr-3"><i class="fas fa-eye"></i></a>
                        <a href="#" class="hover:text-blue-700"><i class="fas fa-edit"></i></a>
                    </td>
                </tr>
                <tr>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center">
                            <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-800 font-bold mr-3">SD</div>
                            <div>
                                <div class="text-sm font-medium text-blue-800">Sophie Dubois</div>
                                <div class="text-sm text-blue-600">ID: 45873</div>
                            </div>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-blue-800">09:20</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                    En cours
                                </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-blue-500">
                        <a href="#" class="hover:text-blue-700 mr-3"><i class="fas fa-eye"></i></a>
                        <a href="#" class="hover:text-blue-700"><i class="fas fa-edit"></i></a>
                    </td>
                </tr>
                <tr>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center">
                            <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-800 font-bold mr-3">PL</div>
                            <div>
                                <div class="text-sm font-medium text-blue-800">Pierre Lambert</div>
                                <div class="text-sm text-blue-600">ID: 45874</div>
                            </div>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-blue-800">10:05</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                    Urgent
                                </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-blue-500">
                        <a href="#" class="hover:text-blue-700 mr-3"><i class="fas fa-eye"></i></a>
                        <a href="#" class="hover:text-blue-700"><i class="fas fa-edit"></i></a>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pied de page -->
    <footer class="mt-12 pt-6 border-t border-blue-200 text-center text-blue-600 text-sm">
        <p>© 2023 Module Infirmier - Système de gestion des patients</p>
    </footer>
</div>
</body>
</html>