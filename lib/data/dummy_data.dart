import '../models/service_model.dart';
import '../components/carousel_banner.dart'; 


final List<CarouselItem> carouselItems = [
  CarouselItem(
    imageUrl: 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    title: 'Advanced Healthcare',
    subtitle: 'Experience world-class medical care with cutting-edge technology',
  ),
  CarouselItem(
    imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    title: 'Expert Diagnostics',
    subtitle: 'Accurate lab results with fast turnaround times',
  ),
  CarouselItem(
    imageUrl: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    title: 'Professional Care',
    subtitle: 'Trusted doctors and specialists at your service',
  ),
  CarouselItem(
    imageUrl: 'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
    title: '24/7 Emergency',
    subtitle: 'Round-the-clock medical assistance when you need it most',
  ),
];

final List<String> carouselImages = [
  'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  'https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  'https://images.unsplash.com/photo-1579684385127-1ef15d508118?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
  'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
];

final List<Service> pathologyServices = [
  Service(
    id: 'p1',
    name: 'Metropolis Labs',
    imageUrl: 'https://images.unsplash.com/photo-1579165466741-7f35e4755182?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
    distance: 1.2,
    bookings: 1240,
    location: '123 Main Street, Downtown',
    type: ServiceType.pathology,
  ),
  Service(
    id: 'p2',
    name: 'City Health Diagnostics',
    imageUrl: 'https://images.unsplash.com/photo-1581595220892-b0739db3ba8c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    distance: 2.5,
    bookings: 987,
    location: '456 Park Avenue, Uptown',
    type: ServiceType.pathology,
  ),
  Service(
    id: 'p3',
    name: 'Quick Diagnostics',
    imageUrl: 'https://images.unsplash.com/photo-1582719471384-894fbb16e074?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    distance: 3.7,
    bookings: 756,
    location: '789 Central Road, Midtown',
    type: ServiceType.pathology,
  ),
  Service(
    id: 'p4',
    name: 'Premium PathLabs',
    imageUrl: 'https://images.unsplash.com/photo-1576671414101-d3e5ce1eb766?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    distance: 4.3,
    bookings: 1452,
    location: '101 West Street, Westside',
    type: ServiceType.pathology,
  ),
];

final List<Service> doctors = [
  Service(
    id: 'd1',
    name: 'Dr. Sarah Johnson',
    imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    distance: 1.8,
    bookings: 1560,
    location: 'City General Hospital, Downtown',
    type: ServiceType.doctor,
  ),
  Service(
    id: 'd2',
    name: 'Dr. Robert Williams',
    imageUrl: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    distance: 3.2,
    bookings: 1230,
    location: 'Wellness Medical Center, Uptown',
    type: ServiceType.doctor,
  ),
  Service(
    id: 'd3',
    name: 'Dr. Emily Parker',
    imageUrl: 'https://images.unsplash.com/photo-1594824476967-48c8b964273f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    distance: 2.6,
    bookings: 876,
    location: 'Community Health Clinic, Eastside',
    type: ServiceType.doctor,
  ),
  Service(
    id: 'd4',
    name: 'Dr. Michael Chen',
    imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
    distance: 5.1,
    bookings: 992,
    location: 'Specialty Medical Group, Northside',
    type: ServiceType.doctor,
  ),
];