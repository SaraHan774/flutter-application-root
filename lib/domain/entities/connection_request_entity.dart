import 'package:equatable/equatable.dart';

/// 연결 요청(ConnectionRequest) 엔티티
/// Firestore: connectionRequests/{chatRoomId}
class ConnectionRequestEntity extends Equatable {
  /// 연결 요청 고유 ID (chatRoomId)
  final String connectionRequestId;

  /// 사용자 A 요청 여부
  final bool userARequest;

  /// 사용자 B 요청 여부
  final bool userBRequest;

  /// 연결 상태 (pending/connected)
  final String status;

  /// 연결 성사 시각
  final DateTime? connectedAt;

  const ConnectionRequestEntity({
    required this.connectionRequestId,
    required this.userARequest,
    required this.userBRequest,
    required this.status,
    this.connectedAt,
  });

  factory ConnectionRequestEntity.fromMap(Map<String, dynamic> map, String connectionRequestId) {
    return ConnectionRequestEntity(
      connectionRequestId: connectionRequestId,
      userARequest: map['userARequest'] ?? false,
      userBRequest: map['userBRequest'] ?? false,
      status: map['status'] ?? 'pending',
      connectedAt: map['connectedAt'] != null ? DateTime.tryParse(map['connectedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userARequest': userARequest,
      'userBRequest': userBRequest,
      'status': status,
      if (connectedAt != null) 'connectedAt': connectedAt!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [connectionRequestId, userARequest, userBRequest, status, connectedAt];
} 