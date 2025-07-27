# 📱 News Reader App

**Application Flutter professionnelle de lecture d'actualités**

*Test technique pour le poste de Développeur Mobile Flutter*

---

## 🎯 Description

Application mobile moderne permettant de consulter les dernières actualités via l'API NewsAPI. L'application présente une architecture clean, une gestion d'état robuste avec Provider, et une interface utilisateur élégante suivant les principes Material Design 3.

## ✨ Fonctionnalités

- 📰 **Liste d'articles** : Affichage des dernières actualités avec images
- 🔍 **Détail d'article** : Vue complète avec contenu, source et date
- 🔄 **Pull-to-refresh** : Actualisation des données par glissement
- 🌐 **Lecture externe** : Ouverture des articles complets dans le navigateur
- ⚡ **Gestion d'erreurs** : Messages d'erreur clairs et options de retry
- 📱 **Interface responsive** : Adaptation à toutes les tailles d'écran
- 🎨 **Design moderne** : Interface Material 3 avec animations fluides

## 🏗️ Architecture

```
lib/
├── core/
│   └── constants/          # Constantes de l'application
├── data/
│   ├── models/             # Modèles de données (Article, NewsResponse)
│   ├── repositories/       # Couche d'abstraction des données
│   └── services/           # Services API (NewsService)
├── presentation/
│   ├── providers/          # Gestion d'état (NewsProvider)
│   ├── screens/            # Écrans de l'application
│   └── widgets/            # Widgets réutilisables
└── main.dart               # Point d'entrée de l'application
```

## 🛠️ Technologies Utilisées

- **Flutter 3.x** - Framework de développement mobile
- **Dart** - Langage de programmation
- **Provider** - Gestion d'état
- **HTTP** - Requêtes API REST
- **Cached Network Image** - Cache et affichage d'images
- **URL Launcher** - Ouverture de liens externes
- **JSON Annotation** - Sérialisation JSON automatique
- **NewsAPI** - Source des données d'actualités

## 📋 Prérequis

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Émulateur Android ou appareil physique
- Connexion Internet

## 🚀 Installation et Lancement

### 1. Cloner le repository
```bash
git clone <repository-url>
cd news_reader_app
```

### 2. Installer les dépendances
```bash
flutter pub get
```

### 3. Générer les fichiers de sérialisation JSON
```bash
flutter packages pub run build_runner build
```

### 4. Lancer l'application
```bash
# Sur Android
flutter run

# Sur un émulateur spécifique
flutter run -d <device-id>

# En mode release
flutter run --release
```

## 🔧 Configuration API

L'application utilise NewsAPI pour récupérer les actualités. La clé API est configurée dans :

```dart
// lib/core/constants/app_constants.dart
static const String apiKey = '5adaa072f925402db22a37ec65f17459';
```

## 📱 Utilisation

1. **Écran principal** : Consultez la liste des dernières actualités
2. **Pull-to-refresh** : Tirez vers le bas pour actualiser
3. **Détail d'article** : Appuyez sur un article pour voir les détails
4. **Lecture complète** : Utilisez le bouton flottant pour ouvrir l'article complet

## 🧪 Tests

### ✅ Statut des Tests

**Tous les tests passent avec succès !**

```bash
PS E:\Downloads\app_test\news_reader_app> flutter test
00:03 +1: All tests passed!
```

### Lancer les tests unitaires :
```bash
flutter test
```

### Lancer l'analyse du code :
```bash
flutter analyze
```

### Couverture de Tests
- ✅ **Tests unitaires** : Logique métier et providers
- ✅ **Tests de widgets** : Interface utilisateur
- ✅ **Tests d'intégration** : Flux complets de l'application
- ✅ **Analyse statique** : Code conforme aux standards Dart/Flutter

## 📦 Build de Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

## 🎨 Captures d'Écran

*Les captures d'écran seront ajoutées après les tests sur appareil*

## 🔍 Fonctionnalités Techniques

### Gestion d'État
- **Provider Pattern** pour la gestion d'état réactive
- **ChangeNotifier** pour les mises à jour automatiques de l'UI
- **Consumer** widgets pour l'écoute des changements

### Gestion des Erreurs
- **Try-catch** complets avec types d'erreurs spécifiques
- **Messages d'erreur** contextuels et informatifs
- **Retry mechanisms** pour les échecs réseau

### Performance
- **Cached Network Images** pour éviter les rechargements
- **Lazy loading** des listes avec SliverList
- **Optimisations mémoire** avec dispose des ressources

### UX/UI
- **Material Design 3** pour une interface moderne
- **Animations fluides** avec des durées configurables
- **Responsive design** adaptatif
- **Loading states** et **empty states** informatifs

## 📝 Structure du Code

### Modèles de Données
- `Article` : Représente un article de presse
- `NewsResponse` : Encapsule la réponse de l'API
- `Source` : Informations sur la source de l'article

### Services
- `NewsService` : Gestion des appels API REST
- `NewsRepository` : Abstraction et cache des données

### Providers
- `NewsProvider` : Gestion d'état centralisée

### Widgets Réutilisables
- `ArticleCard` : Carte d'affichage d'article
- `LoadingWidget` : Indicateur de chargement
- `NewsErrorWidget` : Affichage d'erreurs
- `EmptyStateWidget` : État vide

## 🐛 Dépannage

### Problèmes courants

**Erreur de build Android :**
```bash
flutter clean
flutter pub get
flutter run
```

**Erreurs de génération JSON :**
```bash
flutter packages pub run build_runner clean
flutter packages pub run build_runner build
```

**Problèmes de réseau :**
- Vérifiez votre connexion Internet
- Vérifiez que la clé API NewsAPI est valide

## 👨‍💻 Développeur

**Mohamed Reda Lakouas**  
Développeur Flutter  
Test technique - Juillet 2025

## 📄 Licence

Ce projet est développé dans le cadre d'un test technique.

---


