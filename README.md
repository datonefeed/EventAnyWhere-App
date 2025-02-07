# Event Any Where

Event Any Where is a comprehensive platform for managing and participating in online and offline events. Designed to enhance user experience for both organizers and attendees, it offers intelligent features and seamless management tools.

# Video Demo

https://github.com/user-attachments/assets/0f481eb5-e652-4c00-909c-862373908b29

# UX/UI Design

![image](https://github.com/user-attachments/assets/18c64d91-a691-4c01-80f6-41068006c97f)

link figma: https://www.figma.com/design/P2LKL66XWctofT5v4Xog0l/Event-AnyWhere?node-id=0-1&t=3otMM7LQq96i3FgM-1

# Key Features

Event Management

Create, edit, and delete events.

Manage multiple sessions within an event.

Track participants and registrations.

Livestream Support

Multiple livestream rooms for simultaneous sessions.

Interactive tools: Q&A, comments, and surveys.

Smart Recommendations

Personalized event suggestions based on preferences, age, search history.

Push Notifications(no realtime)

Seamless Login

Quick login with Google/Facebook.

Secure authentication via Node.js backend.

System Requirements

Backend
Node.js (v14 or higher, recommended v16+)
npm (v6 or higher, recommended v8+)
MongoDB (local or cloud)

Frontend
Flutter SDK (v3.10 or higher)  
Repository: EventAnywhere-FE (https://github.com/datonefeed/EventAnywhere-FE.git)

Admin Panel
.NET Core SDK (v6.0 or higher)  
Repository: AdminDashboard (https://github.com/tuanphana2/AdminDashboard.git)

Additional Tools
ZEGOCLOUD SDK (for livestreaming)
Git / SourceTree (optional)
Postman (for API testing)

Installation Guide

1. Clone Repositories

# Backend
git clone https://github.com/thinhcao232/EvenAnyWhere-BE.git
cd EventAnywhere-BE

# Frontend
git clone https://github.com/datonefeed/EventAnywhere-FE.git
cd EventAnywhere-FE

# Admin Panel
git clone https://github.com/tuanphana2/AdminDashboard.git
cd AdminDashboard

2. Backend Setup

cd backend
npm install

Create a .env file in backend:

PORT=3000
ACCESS_TOKEN="ACCESS_TOKEN_147"
REFRESH_TOKEN="REFRESH_TOKEN_147"
EMAIL_USER="poroll2k3@gmail.com"
EMAIL_PASSWORD="ckpmasdnidfcfvzg"
GOOGLE_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID
FACEBOOK_APP_ID=YOUR_FACEBOOK_APP_ID
FACEBOOK_APP_SECRET=YOUR_FACEBOOK_APP_SECRET
MONGO_URI=YOUR_MONGO_URI
JWT_SECRET=your_jwt_secret

Run the server:

npm start

The server listens at http://localhost:3000.

3. Python-Based AI Recommendation System

cd recommendation-system
pip install pandas scikit-learn surprise shap requests flask
python server.py

The recommendation system uses port 9000.

4. Frontend Setup

cd EventAnywhere-FE
flutter pub get

Create a keys.dart file in the frontend directory:

int appId = 176893353;
String appSign = 'b9c65ca01ab90d48957dce35a355b2f46b8cc0b2a7b547021bfff4a1082bf6ca';

flutter run

5. Admin Panel Setup

cd AdminDashboard
dotnet restore
dotnet run

Admin panel runs at http://localhost:5001. Configure appsettings.json with MongoDB and JWT settings.

ZEGOCLOUD Configuration

Add App ID and App Secret to .env in frontend. Include in pubspec.yaml:

dependencies:
zego_uikit_prebuilt_live_streaming: ^latest_version

Follow ZEGOCLOUD Docs (https://docs.zegocloud.com/).

Usage

1. Register as an organizer or attendee.
2. Get personalized event recommendations.
3. Livestream events and interact with participants.
4. Admin panel for managing events and users.

Troubleshooting

- Ensure MongoDB is running.
- Check environment variables.
- Verify ZEGOCLOUD SDK setup.


