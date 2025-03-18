# Skille - Student Skill Exchange Platform

## About Skille

Skille is a mobile application designed to connect University of Technology Malaysia (UTM) students who offer services with those who need them. The platform facilitates a skill exchange marketplace exclusively for UTM students, allowing them to find, connect with, and hire skilled peers for various services.

This project was developed during the Mobile Application Programming (SECJ3623) course at UTM Malaysia for the 2024/2025-1 session, conducted by Dr. Jumail Bin Taliba.

## Development Team

- **Zuhayer Adnan Siddique**
- **Kevin Fachrezy**
- **Ghathfa Muhammad**
- **Adam Hadeed**

## Features

### 1. User Authentication

- Student-specific login/registration
- Profile management

<div align="center">
  <div style="display: inline-block; border: 12px solid #333333; border-radius: 36px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.2);">
    <img src="assets/login.PNG" width="300" alt="Login Screen" />
    <div style="background: #333333; height: 20px; margin-top: -4px;"></div>
  </div>
  <p><em>Login Screen</em></p>
</div>

### 2. Interactive Home Screen

- Service category browsing with an icon-based interface
- Featured service providers
- Quick access to all platform features

<div align="center">
  <div style="display: inline-block; border: 12px solid #333333; border-radius: 36px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.2);">
    <img src="assets/home.PNG" width="300" alt="Home Screen" />
    <div style="background: #333333; height: 20px; margin-top: -4px;"></div>
  </div>
  <p><em>Home Screen</em></p>
</div>

### 3. Comprehensive Search

- Search by service category
- Search by username
- Filter results based on specific criteria

<div align="center">
  <div style="display: inline-block; border: 12px solid #333333; border-radius: 36px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.2);">
    <img src="assets/search.PNG" width="300" alt="Search Screen" />
    <div style="background: #333333; height: 20px; margin-top: -4px;"></div>
  </div>
  <p><em>Search Screen</em></p>
</div>

### 4. Instagram-Style Profile Pages

- Grid view of posted content
- List view option
- Image upload functionality
- Bio and contact information
- Friend connection management

<div align="center">
  <div style="display: inline-block; border: 12px solid #333333; border-radius: 36px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.2);">
    <img src="assets/profile.PNG" width="300" alt="Profile Screen" />
    <div style="background: #333333; height: 20px; margin-top: -4px;"></div>
  </div>
  <p><em>Profile Screen</em></p>
</div>

### 5. Friend Management

- Send/receive friend requests
- Accept/decline requests through notifications
- View friend list

<div align="center">
  <div style="display: inline-block; border: 12px solid #333333; border-radius: 36px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.2);">
    <img src="assets/friends.PNG" width="300" alt="Friends List" />
    <div style="background: #333333; height: 20px; margin-top: -4px;"></div>
  </div>
  <p><em>Friends List Screen</em></p>
</div>

## System Architecture

The application is built using the MVVM (Model-View-ViewModel) architecture pattern, which provides a clean separation of concerns:

```mermaid
flowchart LR
    M[Model] <--> VM[ViewModel] <--> V[View]

    subgraph "Data Binding"
        M --- VM --- V
    end
```

### MVVM Implementation

- **Models**: Data structures representing entities like User, Service, and Post
- **Views**: Flutter UI components (screens, widgets)
- **ViewModels**: Service providers and state management that connect the UI with data sources
- **Services**: Authentication, API communication, and local storage management

### Detailed System Architecture

```mermaid
flowchart TD
    subgraph "Flutter Application (Skille)"
        subgraph UI["UI Layer (Views)"]
            Home["HomeScreen"]
            Profile["ProfileScreen"]
            Search["SearchScreen"]
            Notifications["NotificationsScreen"]
            Friends["FriendsListScreen"]
            Services["ServiceListScreen"]
        end

        subgraph BL["Business Logic Layer (ViewModels)"]
            Auth["AuthProvider"]
            SP["ServiceProvider"]
            PP["ProfileProvider"]
            NP["NotificationProvider"]
            FP["FriendsProvider"]
            SearchP["SearchProvider"]
        end

        subgraph DL["Data Layer (Models)"]
            User["User"]
            Service["Service"]
            Post["Post"]
            Friend["Friend"]
        end

        subgraph SL["Services Layer"]
            AS["Authentication Service"]
            MS["Mock API Service"]
            LS["Local Storage Service"]
            IS["Image Upload Service"]
        end
    end

    UI <--> BL
    BL <--> DL
    BL <--> SL

    subgraph External
        UI_Comp["UI Components (Material Design)"]
        SM["State Management (Provider)"]
        MB["Mock Backend (Future: Real API)"]
    end

    UI --- UI_Comp
    BL --- SM
    SL --- MB
```

### Class Diagram

```mermaid
classDiagram
    class User {
        -id: String
        -name: String
        -email: String
        -phoneNumber: String
        -bio: String
        -isServiceProvider: bool
        +toJson()
        +fromJson()
    }

    class Service {
        -id: String
        -name: String
        -price: double
        -rating: double
        -description: String
        -imageUrl: String
        +toJson()
        +fromJson()
    }

    class Post {
        -id: String
        -imageUrl: String
        -caption: String
        -likes: int
        -comments: int
        -date: String
        -userId: String
        +toJson()
        +fromJson()
    }

    class AuthProvider {
        -_user: User
        -_isLoggedIn: bool
        +login()
        +register()
        +logout()
        +getCurrentUser()
        +updateProfile()
    }

    class ServiceProvider {
        -_services: List~Service~
        -_loading: bool
        +getServices()
        +getServiceById()
        +filterByCategory()
        +searchServices()
    }

    class PostProvider {
        -_posts: List~Post~
        -_loading: bool
        +getPosts()
        +createPost()
        +likePost()
        +commentOnPost()
    }

    class FriendsProvider {
        -_friends: List
        -_requests: List
        +getFriends()
        +sendRequest()
        +acceptRequest()
        +declineRequest()
        +removeFriend()
    }

    class NotificationProvider {
        -_notifications: List
        -_unreadCount: int
        +getNotifications()
        +markAsRead()
        +acceptFriendRequest()
        +declineFriendRequest()
    }

    class ProfileProvider {
        -_userPosts: List
        -_userProfile: User
        -_loading: bool
        +getUserPosts()
        +getUserProfile()
        +updateProfile()
        +uploadImage()
    }

    class SearchProvider {
        -_results: List
        -_loading: bool
        -_filter: String
        +search()
        +setFilter()
        +clearFilter()
        +searchByUsername()
        +searchByService()
    }

    User <|-- AuthProvider
    User <|-- ProfileProvider
    Service <|-- ServiceProvider
    Post <|-- PostProvider
```

## Technical Details

### Stack

- **Frontend**: Flutter/Dart
- **State Management**: Provider pattern
- **UI Components**: Material Design
- **Mock API**: Simulated backend services for demonstration

### Project Structure

```
lib/
  ├── models/          # Data models
  ├── services/        # Service classes for API and business logic
  ├── views/           # UI screens and components
  │   ├── home/        # Home screen components
  │   ├── profile/     # Profile related screens
  │   ├── search/      # Search functionality
  │   └── ...          # Other UI modules
  ├── utils/           # Utility functions and constants
  └── main.dart        # Application entry point
```

## Running the Project

### Prerequisites

- Flutter SDK (2.5.0 or higher)
- Dart SDK (2.14.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android emulator or physical device / iOS simulator

### Setup Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/skille.git
   ```

2. Navigate to the project directory:

   ```bash
   cd skille
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

## Notes

This project is forked from the original repository and currently uses mock API implementations for demonstration purposes. All data shown in the application is simulated and does not represent real services or users.

## Potential Future Enhancements

- Real backend integration
- Payment processing
- In-app messaging
- Service booking system
- Reviews and ratings
- Location-based service discovery
