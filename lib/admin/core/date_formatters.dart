import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatFirestoreDate(dynamic value) {
  if (value == null) return '—';

  DateTime? date;
  if (value is Timestamp) {
    date = value.toDate();
  } else if (value is DateTime) {
    date = value;
  }

  if (date == null) return '—';

  return DateFormat('MMM d, yyyy').format(date);
}