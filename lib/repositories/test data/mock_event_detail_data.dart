import '../../models/event_detail_model.dart';
import '../../models/session_model.dart';
import '../../models/speaker_model.dart';
import '../../models/organizer_model.dart';

final mockEventDetail = EventDetail(
  id: '1',
  title: 'DevDay 2024',
  image: 'assets/images/devday.png',
  description:
      'DevDay 2024 will be held on June 8, 2024, in Da Nang, focusing on AI-driven innovation...',
  date: '10 Jun, 2024',
  location: '03 Quang Trung Street',
  organizer: Organizer(
    id: '1',
    name: 'Thanh Dat',
    image:
        'https://thunao.com/wp-content/uploads/2023/02/Anh-con-meo-deo-kinh-sang-chanh.jpeg',
  ),
  sessions: [
    Session(
      id: '1',
      title: 'Building the Semi-conductor and AI Hub',
      startTime: '7:30 AM',
      endTime: '9:30 AM',
      location: '123',
      sessionSpeakers: [
        Speaker(
          id: '1',
          name: 'Binh Nguyen',
          position: 'CEO',
          bio: 'CEO',
          profileImageUrl: 'assets/images/profile_img1.png',
        ),
        Speaker(
          id: '2',
          name: 'Trang Nguyen',
          position: 'CEO',
          bio: 'President',
          profileImageUrl: 'assets/images/profile_img2.png',
        ),
      ],
      description:
          'This session focuses on building an AI-driven semiconductor hub. Experts will share insights on advancements in AI and semiconductor technologies.', // Thêm mô tả
    ),
    Session(
      id: '2',
      title: 'Security and AI in an Agile World',
      startTime: '10:00 AM',
      endTime: '11:30 AM',
      location: '123',
      sessionSpeakers: [
        Speaker(
          id: '3',
          name: 'Philip Cao',
          position: 'CEO',
          bio: 'Advisor',
          profileImageUrl: 'assets/images/profile_img3.png',
        ),
        Speaker(
          id: '2',
          name: 'Trang Nguyen',
          position: 'CEO',
          bio: 'President',
          profileImageUrl: 'assets/images/profile_img2.png',
        ),
      ],
      description:
          'Explore the intersection of security and AI in agile development. Discussions will cover best practices and challenges in securing AI applications.', // Thêm mô tả
    ),
  ],
  speakers: [
    Speaker(
      id: '1',
      name: 'Binh Nguyen',
      position: 'CEO',
      bio: 'CEO',
      profileImageUrl: 'assets/images/profile_img1.png',
    ),
    Speaker(
      id: '2',
      name: 'Trang Nguyen',
      position: 'CEO',
      bio: 'President',
      profileImageUrl: 'assets/images/profile_img2.png',
    ),
    Speaker(
      id: '3',
      name: 'Philip Cao',
      position: 'CEO',
      bio: 'Advisor',
      profileImageUrl: 'assets/images/profile_img3.png',
    ),
  ],
);
