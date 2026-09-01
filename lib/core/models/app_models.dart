import 'package:flutter/material.dart';

enum JobStatus {
  pendingPredecessor,
  readyToBook,
  booked,
  inProgress,
  underReview,
  completed,
  cancelled,
  blocked
}

enum WorkerVerificationStatus {
  verified,
  pending,
  rejected
}

class ReviewItem {
  final String authorName;
  final String authorAvatar;
  final double rating;
  final String date;
  final String comment;
  final String projectTitle;

  const ReviewItem({
    required this.authorName,
    required this.authorAvatar,
    required this.rating,
    required this.date,
    required this.comment,
    required this.projectTitle,
  });
}

class WorkerProfile {
  final String id;
  final String name;
  final String trade;
  final String categoryId;
  final double rating;
  final int reviewsCount;
  final int jobsCompleted;
  final int experienceYears;
  final double hourlyRate;
  final double dailyRate;
  final String location;
  final double distanceKm;
  final bool isAvailableToday;
  final WorkerVerificationStatus verificationStatus;
  final List<String> skills;
  final List<String> badges;
  final String bio;
  final String avatarInitials;
  final Color avatarColor;
  final int safetyScore;
  final List<String> portfolioTags;
  final List<ReviewItem> reviews;

  const WorkerProfile({
    required this.id,
    required this.name,
    required this.trade,
    required this.categoryId,
    required this.rating,
    required this.reviewsCount,
    required this.jobsCompleted,
    required this.experienceYears,
    required this.hourlyRate,
    required this.dailyRate,
    required this.location,
    required this.distanceKm,
    required this.isAvailableToday,
    required this.verificationStatus,
    required this.skills,
    required this.badges,
    required this.bio,
    required this.avatarInitials,
    required this.avatarColor,
    required this.safetyScore,
    this.portfolioTags = const [],
    this.reviews = const [],
  });
}

class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int workerCount;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.workerCount,
  });
}

class CustomerBooking {
  final String bookingId;
  final WorkerProfile worker;
  final String serviceTitle;
  final String categoryName;
  final String bookingDate;
  final String timeSlot;
  final String address;
  final String jobDescription;
  final double estimatedHours;
  final double laborCost;
  final double serviceFee;
  final double totalAmount;
  final JobStatus status;
  final String specialInstructions;

  const CustomerBooking({
    required this.bookingId,
    required this.worker,
    required this.serviceTitle,
    required this.categoryName,
    required this.bookingDate,
    required this.timeSlot,
    required this.address,
    required this.jobDescription,
    required this.estimatedHours,
    required this.laborCost,
    required this.serviceFee,
    required this.totalAmount,
    required this.status,
    this.specialInstructions = "",
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final IconData icon;
  final Color color;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}

class JobStep {
  final String id;
  final String title;
  final String tradeCategory;
  final int sequenceOrder;
  final List<String> dependsOnStepIds;
  final JobStatus status;
  final String estimatedDuration;
  final double estimatedCost;
  final String? assignedWorkerId;
  final String? assignedWorkerName;
  final String? assignedWorkerTrade;
  final String? assignedWorkerAvatar;
  final String scheduledDate;
  final String description;
  final List<String> checklist;
  final List<String> completionProofUrls;

  const JobStep({
    required this.id,
    required this.title,
    required this.tradeCategory,
    required this.sequenceOrder,
    required this.dependsOnStepIds,
    required this.status,
    required this.estimatedDuration,
    required this.estimatedCost,
    this.assignedWorkerId,
    this.assignedWorkerName,
    this.assignedWorkerTrade,
    this.assignedWorkerAvatar,
    required this.scheduledDate,
    required this.description,
    this.checklist = const [],
    this.completionProofUrls = const [],
  });
}

class Project {
  final String id;
  final String title;
  final String clientName;
  final String clientPhone;
  final String locationAddress;
  final String city;
  final double totalBudget;
  final double amountPaid;
  final String startDate;
  final String expectedCompletionDate;
  final double progressPercent;
  final List<JobStep> steps;

  const Project({
    required this.id,
    required this.title,
    required this.clientName,
    required this.clientPhone,
    required this.locationAddress,
    required this.city,
    required this.totalBudget,
    required this.amountPaid,
    required this.startDate,
    required this.expectedCompletionDate,
    required this.progressPercent,
    required this.steps,
  });
}

class DisputeTicket {
  final String id;
  final String projectId;
  final String projectTitle;
  final String stepTitle;
  final String raisedByName;
  final String workerName;
  final String dateRaised;
  final String reason;
  final String status;
  final double disputedAmount;

  const DisputeTicket({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.stepTitle,
    required this.raisedByName,
    required this.workerName,
    required this.dateRaised,
    required this.reason,
    required this.status,
    required this.disputedAmount,
  });
}

enum SlotStatus {
  available,
  booked,
  breakTime,
}

class TimeSlot {
  final String id;
  final String startTime;
  final String endTime;
  final SlotStatus status;
  final String? title;
  final String? subtitle;

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.title,
    this.subtitle,
  });
}

class JobRequest {
  final String id;
  final String customerName;
  final String serviceTitle;
  final String date;
  final String time;
  final String location;
  final double estimatedEarnings;
  final double distanceKm;

  const JobRequest({
    required this.id,
    required this.customerName,
    required this.serviceTitle,
    required this.date,
    required this.time,
    required this.location,
    required this.estimatedEarnings,
    required this.distanceKm,
  });
}
