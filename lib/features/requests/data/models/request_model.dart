import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/service_request.dart';


class RequestModel {
  RequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    this.createdAt,
});

   final String id;
   final String userId;
   final String userName;
   final String userEmail;
   final String title;
   final String description;
   final String category;
   final String status;
   final DateTime? createdAt;

   factory RequestModel.fromFirestore(
        DocumentSnapshot<Map<String, dynamic>> doc,
       ){
     final data = doc.data() ?? {}  ;
     final timestamp = data['createdAt'];
     return RequestModel(
         id: doc.id,
         userId: (data['userId'] ?? '').toString(),
         userName: (data['userName'] ?? '').toString(),
         userEmail: (data['userEmail'] ?? '').toString(),
         title: (data['title'] ?? '').toString(),
         description: (data['description'] ?? '').toString(),
         category:(data['category'] ?? 'General').toString(),
         status: (data['status'] ?? 'pending').toString(),
       createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
     );
   }

   Map<String, dynamic> toFirestore(){
     return{
       'userId':userId,
       'userName':userName,
       'userEmail':userEmail,
       'title':title,
       'description':description,
       'category':category,
       'status':status,
       'createdAt':FieldValue.serverTimestamp(),
     };
   }

   ServiceRequest toEntity(){
     return ServiceRequest(
         id: id,
         userId: userId,
         userName: userName,
         userEmail: userEmail,
         title: title,
         description: description,
         category: category,
         status: _statusFromString(status),
       createdAt: createdAt,
     );
   }

   static RequestStatus _statusFromString(String value){
     switch(value){
       case 'accepted':
         return RequestStatus.accepted;

       case 'pending':
         return RequestStatus.pending;

       default :
         return RequestStatus.declined;
     }
   }
}