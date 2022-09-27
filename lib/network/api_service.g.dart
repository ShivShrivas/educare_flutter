// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://allenp.superhouseerp.com/api/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<ConnectionConnector>> getconnection(branchUrl) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'BranchUrl': branchUrl};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ConnectionConnector>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'LoginApi/ConnectionConnector',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            ConnectionConnector.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<LoginResponse>> getLogin(
      UserName,
      Password,
      DisplayCode,
      GroupCode,
      SocietyCode,
      SchoolCode,
      BranchCode,
      GSMID,
      LastLoginWith) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'UserName': UserName,
      'Password': Password,
      'DisplayCode': DisplayCode,
      'GroupCode': GroupCode,
      'SocietyCode': SocietyCode,
      'SchoolCode': SchoolCode,
      'BranchCode': BranchCode,
      'GSMID': GSMID,
      'LastLoginWith': LastLoginWith
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<LoginResponse>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'LoginApi/UserAuthentication',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => LoginResponse.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<ClassData>> getClassList(
      action, RelationshipId, SessionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': RelationshipId,
      'SessionId': SessionId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ClassData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'digitalDiaryApi/getclasslist',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => ClassData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<ClassDataList>> getClassListdiscussion(
      action, relationshipId, sessionId, code, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'CreatedBy': code,
      'FYId': fYId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ClassDataList>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'getMasterApi/GetClass',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => ClassDataList.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<SectionDataList>> getSectionListdiscussion(
      action, relationshipId, sessionId, code, fYId, classCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'CreatedBy': code,
      'FYId': fYId,
      'ClassCode': classCode
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<SectionDataList>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'getMasterApi/GetSection',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => SectionDataList.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<SubjectData>> getSubjectList(action, relationshipId, sessionId,
      code, fYId, classCode, sectionCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'CreatedBy': code,
      'FYId': fYId,
      'ClassCode': classCode,
      'SectionCode': sectionCode
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<SubjectData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, 'GetMasterApi/GetSubjectListUsingLoginId',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => SubjectData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<StudentData>> listuserData(
      action, studentCode, relationshipId, sessionId, fYid) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'StudentCode': studentCode,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYid': fYid
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<StudentData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, 'AdmissionTransactionApi/GetStudentDetails',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => StudentData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<LeaveTypeMaster>> getLeaveMasterList(
      action, RelationshipId, SessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': RelationshipId,
      'SessionId': SessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<LeaveTypeMaster>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'AttendanceMasterApi/GetLeaveTypeMaster',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => LeaveTypeMaster.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<UserType>> getUserList(action) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Action': action};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<UserType>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'digitalnoticeboardApi/getsendby',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => UserType.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<TeacherListData>> getEmpList(
      action, relationshipId, sessionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<TeacherListData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'employeemasterapi/getemployeeList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => TeacherListData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<RoleData>> getRoleTypeUserList(action, roleId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Action': action, 'RoleId': roleId};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<RoleData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'DigitalComplainApi/GetSearchingList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => RoleData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<NoticeData>> listNotice(action, relationshipId, sessionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NoticeData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, 'DigitalNoticeBoardApi/GetDigitalNoticeBoard',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => NoticeData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<Notificationdata>> listNotification(action, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Action': action, 'UserId': userId};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<Notificationdata>>(Options(
                method: 'POST', headers: _headers, extra: _extra)
            .compose(
                _dio.options, 'NotificationApi/GetAllTimeTableNotifications',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map(
            (dynamic i) => Notificationdata.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<String> listpermission(
      action, relationshipId, sessionId, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'UserId': userId
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(
                _dio.options, 'UserMobileMasterApi/GetUserMobileRolePermission',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<List<MenuPermissionData>> listmenupermission(
      action, relationshipId, sessionId, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'UserId': userId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<MenuPermissionData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'UserMobileMasterApi/mGetUserMobileRolePermission',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            MenuPermissionData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<String> leaveApprovals(
      action,
      remarks,
      isApproved,
      approvedFrom,
      approvedTo,
      employeeCode,
      transID,
      approvedByEmployeCode,
      approvedBy,
      leaveTypeCode,
      leaveApprovalStatusByDates,
      sessionId,
      relationshipId,
      fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'Remarks': remarks,
      'IsApproved': isApproved,
      'ApprovedFrom': approvedFrom,
      'ApprovedTo': approvedTo,
      'EmployeeCode': employeeCode,
      'TransID': transID,
      'ApprovedByEmployeCode': approvedByEmployeCode,
      'ApprovedBy': approvedBy,
      'LeaveTypeCode': leaveTypeCode,
      'LeaveApprovalStatusByDates': leaveApprovalStatusByDates,
      'SessionId': sessionId,
      'RelationshipId': relationshipId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(_dio.options,
            'AttendanceTransactionApi/InsertUpdateDeleteEmployeeLeaveApplication',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<List<LeaveList>> listLeave(
      employeeCode, action, relationshipId, sessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'EmployeeCode': employeeCode,
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<LeaveList>>(Options(
                method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                'AttendanceTransactionApi/EmployeeAttendanceLeaveMasterList',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => LeaveList.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<ChapterData>> listChapter(classCode, sectionCode, subjectCode,
      action, academicSessionID, relationshipId, sessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'ClassCode': classCode,
      'SectionCode': sectionCode,
      'SubjectCode': subjectCode,
      'Action': action,
      'AcademicSessionID': academicSessionID,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ChapterData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'AssessmentApi/GetChapterTopicMapping',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => ChapterData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<OdLeaveData>> listODLeave(
      action, relationshipId, sessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<OdLeaveData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'NotificationApi/GetNotificationsList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => OdLeaveData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<FeeInstallmentData> listFee(
      employeeCode, action, relationshipId, sessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'StudentCode': employeeCode,
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FeeInstallmentData>(Options(
                method: 'POST', headers: _headers, extra: _extra)
            .compose(
                _dio.options, 'FeeTransactionApi/mGetStudentWiseFeeStructure',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FeeInstallmentData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<ClassSectionData>> listclass(
      action, relationshipId, sessionId, fYId, createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId,
      'CreatedBy': createdBy
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ClassSectionData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'GetMasterApi/GetSection',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map(
            (dynamic i) => ClassSectionData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<EmployeData> listemployee(
      action, relationshipId, sessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<EmployeData>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'EmployeeMasterApi/GetEmployeeList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = EmployeData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<LeaveChartData>> listLeaveChart(
      employeeCode, action, relationshipId, sessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'EmployeeCode': employeeCode,
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<LeaveChartData>>(Options(
                method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                'AttendanceTransactionApi/EmployeeAttendanceLeaveMasterList',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => LeaveChartData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<LeaveTypeData>> listtypeChart(action) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Action': action};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<LeaveTypeData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'GetMasterApi/GetDDLs',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => LeaveTypeData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<EmpleaveData>> listStatusChart(
      action, transID, relationshipId, sessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'TransID': transID,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<EmpleaveData>>(Options(
                method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                'AttendanceTransactionApi/EmployeeAttendanceLeaveMasterList',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => EmpleaveData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<ChapterStatusData>> chapterStatusList(action, status) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Action': action, 'Status': status};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ChapterStatusData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, 'AssessmentTransactionApi/GetChapterStatus',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            ChapterStatusData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<ChapterStatusList>> getchapterStatusList(
      action, chapterCode, relationshipId, sessionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'ChapterCode': chapterCode,
      'RelationshipId': relationshipId,
      'SessionId': sessionId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ChapterStatusList>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, 'AssessmentTransactionApi/GetChapterStatus',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            ChapterStatusList.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<String> saveStatus(
      action,
      classCode,
      sectionCode,
      subjectCode,
      chapterCode,
      employeeCode,
      statusDate,
      status,
      remark,
      createdBy,
      relationshipId,
      sessionId,
      fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'ClassCode': classCode,
      'SectionCode': sectionCode,
      'SubjectCode': subjectCode,
      'ChapterCode': chapterCode,
      'EmployeeCode': employeeCode,
      'StatusDate': statusDate,
      'Status': status,
      'Remark': remark,
      'CreatedBy': createdBy,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                'AssessmentTransactionApi/InsertUpdateDeleteChapterStatus',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<String> leaveCancel(
      action, transID, relationshipId, sessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'TransID': transID,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(_dio.options,
            'AttendanceTransactionApi/InsertUpdateDeleteEmployeeLeaveApplication',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<String> oDCancel(
      action, isApproved, updatedBy, allEmployeeApprovalList) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'IsApproved': isApproved,
      'UpdatedBy': updatedBy,
      'AllEmployeeApprovalList': allEmployeeApprovalList
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(
                _dio.options, 'NotificationApi/InsertUpdateDeleteNotifications',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<List<CircularData>> getCircular(
      action, relationshipId, sessionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<CircularData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'DigitalCircularApi/GetDigitalCircular',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => CircularData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<ComplainData>> getComplains(
      action, relationshipId, sessionId, createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'CreatedBy': createdBy
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ComplainData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'DigitalComplainApi/GetComplains',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => ComplainData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<StudentListData>> getStudentList(
      action, relationshipId, sessionId, classCode, sectionCode, fyID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'ClassCode': classCode,
      'SectionCode': sectionCode,
      'FYId': fyID
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<StudentListData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'DigitalNoticeBoardApi/GetStudentsList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => StudentListData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<StudentAttData>> getStudentListforAtt(action, relationshipId,
      sessionId, classCode, sectionCode, fyID, att) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'ClassCode': classCode,
      'SectionCode': sectionCode,
      'FYId': fyID,
      'AttendanceDate': att
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<StudentAttData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'StudentAttendanceApi/GetStudentAttendanceDateWiseList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => StudentAttData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<StudentAttData>> getStudentListSubject(
      action,
      relationshipId,
      sessionId,
      classCode,
      sectionCode,
      subject,
      fyID,
      att,
      createdBy,
      updatedBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'ClassCode': classCode,
      'SectionCode': sectionCode,
      'Subject': subject,
      'FYId': fyID,
      'AttendanceDate': att,
      'CreatedBy': createdBy,
      'UpdatedBy': updatedBy
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<StudentAttData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'StudentAttendanceApi/GetStudentAttendanceSubjectWiseList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => StudentAttData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<String> saveStudentListforAtt(
      action,
      relationshipId,
      sessionId,
      classCode,
      sectionCode,
      fyID,
      att,
      updatedBy,
      createdBy,
      studentList) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'ClassCode': classCode,
      'SectionCode': sectionCode,
      'FYid': fyID,
      'AttendanceDate': att,
      'UpdatedBy': updatedBy,
      'CreatedBy': createdBy,
      'StudentList': studentList
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                'StudentAttendanceApi/InsertEditStudentAttendanceDateWise',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<String> saveStudentSubjectAtt(
      action,
      relationshipId,
      sessionId,
      classCode,
      sectionCode,
      fyID,
      att,
      subject,
      updatedBy,
      createdBy,
      studentList) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'ClassCode': classCode,
      'SectionCode': sectionCode,
      'FYid': fyID,
      'AttendanceDate': att,
      'Subject': subject,
      'UpdatedBy': updatedBy,
      'CreatedBy': createdBy,
      'StudentList': studentList
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                'StudentAttendanceApi/InsertEditStudentAttendanceSubjectWise',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<List<TeacherDataList>> getTeacherDiscussionList(
      action, relationshipId, sessionId, classCode, fyID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'ClassCode': classCode,
      'FYId': fyID
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<TeacherDataList>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, 'timeTableApi/GetDefineClassTeacherMaster',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => TeacherDataList.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<StudentListData>> getTeacherList(
      action, relationshipId, sessionId, classCode, sectionCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'ClassCode': classCode,
      'SectionCode': sectionCode
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<StudentListData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'ComplainRegisterApi/GetTeacherList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => StudentListData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<ComplainData>> getComplainsAdmin(
      action, relationshipId, sessionId, createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'ReceivedBy': createdBy
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ComplainData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'DigitalComplainApi/GetComplains',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => ComplainData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<ChatBox>> getChatBox(
      action, transId, relationshipId, sessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'TransId': transId,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ChatBox>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'DigitalComplainApi/getComplainChatBox',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => ChatBox.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<DiscussData>> getDiscussChatBox(action, code, classCode,
      createdBy, complainAgainest, relationshipId, sessionId, fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'Code': code,
      'ClassCode': classCode,
      'CreatedBy': createdBy,
      'ComplainAgainest': complainAgainest,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<DiscussData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, 'ComplainRegisterApi/ComplainRegisterList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => DiscussData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<DiaryData>> listDiary(action, relationshipId, sessionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'RelationshipId': relationshipId,
      'SessionId': sessionId
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<DiaryData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'DigitalDiaryApi/GetDigitalDiary',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => DiaryData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<AttendanceDataOd>> empAttendance(
      action, code, relationshipId, sessionId, fYid, month, year) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'Code': code,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYid': fYid,
      'Month': month,
      'Year': year
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<AttendanceDataOd>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'AttendanceTransactionApi/EmployeeAttendanceDateWiseList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map(
            (dynamic i) => AttendanceDataOd.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<String> addODRemark(action, code, relationshipId, sessionId, fYid,
      remark, attendanceTransId, type, date, createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'EmployeeCode': code,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYid': fYid,
      'EmployeeRemarks': remark,
      'AttendanceTransId': attendanceTransId,
      'Type': type,
      'VDate': date,
      'CreatedBy': createdBy
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(
                _dio.options, 'NotificationApi/InsertUpdateDeleteNotifications',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<List<AttendanceData>> studentAttendance(
      action, code, relationshipId, sessionId, fYid, month, year) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'StudentCode': code,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYid': fYid,
      'Month': month,
      'Year': year
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<AttendanceData>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'StudentAttendanceApi/GetStudentAttendanceDateWiseList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => AttendanceData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<SessionMinMax>> sessionMinMax(action, sessionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Action': action, 'SessionId': sessionId};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<SessionMinMax>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'GetMasterApi/GetSessionMinMaxDate',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => SessionMinMax.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<NoticeSaveResponse>> createNotice(
      action,
      sendBy,
      createNoticeFor,
      noticeFor,
      studentlist,
      code,
      noticeHeadline,
      description,
      showDate,
      endDate,
      relationshipId,
      sessionId,
      fYId,
      createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'SendBy': sendBy,
      'CreateNoticeFor': createNoticeFor,
      'NoticeFor': noticeFor,
      'StudentList': studentlist,
      'ClassCode': code,
      'NoticeHeadline': noticeHeadline,
      'Description': description,
      'ShowDate': showDate,
      'EndDate': endDate,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId,
      'CreatedBy': createdBy
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NoticeSaveResponse>>(Options(
                method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                'DigitalNoticeBoardApi/InsertUpdateDeleteDigitalNoticeBoard',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            NoticeSaveResponse.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<String> createLeave(
      employeeCode,
      leaveTypeCode,
      designationCode,
      departmentCode,
      leaveFrom,
      leaveTo,
      leaveReason,
      remarks,
      leaveFor,
      communicationPrefferedMode,
      onLeaveContactNo,
      onLeaveAddress,
      isLeaveRecieved,
      inAbsenceResponsibleEmployeeId,
      approvedFrom,
      approvedTo,
      relationshipId,
      fYId,
      sessionId,
      createdBy,
      action,
      leaveApprovalStatusByDates) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'EmployeeCode': employeeCode,
      'LeaveTypeCode': leaveTypeCode,
      'DesignationCode': designationCode,
      'DepartmentCode': departmentCode,
      'LeaveFrom': leaveFrom,
      'LeaveTo': leaveTo,
      'LeaveReason': leaveReason,
      'Remarks': remarks,
      'LeaveFor': leaveFor,
      'CommunicationPrefferedMode': communicationPrefferedMode,
      'OnLeaveContactNo': onLeaveContactNo,
      'OnLeaveAddress': onLeaveAddress,
      'IsLeaveRecieved': isLeaveRecieved,
      'InAbsenceResponsibleEmployeeId': inAbsenceResponsibleEmployeeId,
      'ApprovedFrom': approvedFrom,
      'ApprovedTo': approvedTo,
      'RelationshipId': relationshipId,
      'FYId': fYId,
      'SessionId': sessionId,
      'CreatedBy': createdBy,
      'Action': action,
      'LeaveApprovalStatusByDates': leaveApprovalStatusByDates
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(_dio.options,
            'AttendanceTransactionApi/InsertUpdateDeleteEmployeeLeaveApplication',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<String> updateLeave(
      TransID,
      employeeCode,
      leaveTypeCode,
      designationCode,
      departmentCode,
      leaveFrom,
      leaveTo,
      leaveReason,
      remarks,
      leaveFor,
      communicationPrefferedMode,
      onLeaveContactNo,
      onLeaveAddress,
      isLeaveRecieved,
      inAbsenceResponsibleEmployeeId,
      approvedFrom,
      approvedTo,
      relationshipId,
      fYId,
      sessionId,
      createdBy,
      action,
      leaveApprovalStatusByDates) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'TransID': TransID,
      'EmployeeCode': employeeCode,
      'LeaveTypeCode': leaveTypeCode,
      'DesignationCode': designationCode,
      'DepartmentCode': departmentCode,
      'LeaveFrom': leaveFrom,
      'LeaveTo': leaveTo,
      'LeaveReason': leaveReason,
      'Remarks': remarks,
      'LeaveFor': leaveFor,
      'CommunicationPrefferedMode': communicationPrefferedMode,
      'OnLeaveContactNo': onLeaveContactNo,
      'OnLeaveAddress': onLeaveAddress,
      'IsLeaveRecieved': isLeaveRecieved,
      'InAbsenceResponsibleEmployeeId': inAbsenceResponsibleEmployeeId,
      'ApprovedFrom': approvedFrom,
      'ApprovedTo': approvedTo,
      'RelationshipId': relationshipId,
      'FYId': fYId,
      'SessionId': sessionId,
      'CreatedBy': createdBy,
      'Action': action,
      'LeaveApprovalStatusByDates': leaveApprovalStatusByDates
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(_dio.options,
            'AttendanceTransactionApi/InsertUpdateDeleteEmployeeLeaveApplication',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<String> createHomeWork(
      communicationPrefferedMode,
      onLeaveContactNo,
      onLeaveAddress,
      isLeaveRecieved,
      inAbsenceResponsibleEmployeeId,
      approvedFrom,
      approvedTo,
      relationshipId,
      fYId,
      sessionId,
      createdBy,
      action,
      isActive) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'ClassCode': communicationPrefferedMode,
      'SectionCode': onLeaveContactNo,
      'SubjectCode': onLeaveAddress,
      'ShowDate': isLeaveRecieved,
      'EndDate': inAbsenceResponsibleEmployeeId,
      'Title': approvedFrom,
      'Description': approvedTo,
      'RelationshipId': relationshipId,
      'FYId': fYId,
      'SessionId': sessionId,
      'CreatedBy': createdBy,
      'Action': action,
      'IsActive': isActive
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, 'HomeworkApi/InsertUpdateDeleteHomeworks',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<String> markAttendance(action, employeeCode, sessionId, relationshipId,
      fYId, attendanceDate, abbreviationCode, createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'EmployeeCode': employeeCode,
      'SessionId': sessionId,
      'RelationshipId': relationshipId,
      'FYid': fYId,
      'AttendanceDate': attendanceDate,
      'AbbreviationCode': abbreviationCode,
      'CreatedBy': createdBy
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                'AttendanceTransactionApi/InsertEditEmployeeAttendanceDateWise',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<List<NoticeSaveResponse>> createCircular(
      action,
      sendBy,
      createNoticeFor,
      noticeFor,
      studentlist,
      code,
      noticeHeadline,
      description,
      showDate,
      endDate,
      relationshipId,
      sessionId,
      fYId,
      createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'SendBy': sendBy,
      'CreateCircularFor': createNoticeFor,
      'CircularFor': noticeFor,
      'StudentList': studentlist,
      'ClassCode': code,
      'CircularHeadline': noticeHeadline,
      'Description': description,
      'ShowDate': showDate,
      'EndDate': endDate,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId,
      'CreatedBy': createdBy
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NoticeSaveResponse>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'DigitalCircularApi/InsertUpdateDeleteDigitalCircular',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            NoticeSaveResponse.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<ComplainResponse>> createComplain(action, complainTo, receivedBy,
      subject, description, relationshipId, sessionId, fYId, createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'ComplainTo': complainTo,
      'ReceivedBy': receivedBy,
      'Subject': subject,
      'Description': description,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId,
      'CreatedBy': createdBy
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ComplainResponse>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'DigitalComplainApi/InsertUpdateDeleteDigitalComplain',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map(
            (dynamic i) => ComplainResponse.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<String> sendMessage(action, senderID, receiverID, transId, message,
      relationshipId, sessionId, fYId, createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'SenderID': senderID,
      'ReceiverID': receiverID,
      'TransId': transId,
      'Message': message,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId,
      'CreatedBy': createdBy
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                'DigitalComplainApi/InsertUpdateDeleteDigitalComplainChatBox',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<String> sendMessageDiscussion(
      action,
      senderID,
      receiverID,
      message,
      relationshipId,
      sessionId,
      createdBy,
      classCode,
      sectionCode,
      fYId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'ComplainBy': senderID,
      'ComplainAgainest': receiverID,
      'ComplainText': message,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'CreatedBy': createdBy,
      'ClassCode': classCode,
      'SectionCode': sectionCode,
      'FYId': fYId
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(
            _dio.options, 'ComplainRegisterApi/InsertDeleteComplainRegister',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<String> updateStatus(action, transId, status, relationshipId,
      sessionId, fYId, createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'TransId': transId,
      'Status': status,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId,
      'UpdatedBy': createdBy
    };
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                'DigitalComplainApi/InsertUpdateDeleteDigitalComplain',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<List<NoticeSaveResponse>> createDialry(
      action,
      students,
      messageFor,
      classCode,
      sectionCode,
      wantToRevertMessage,
      messageTitle,
      message,
      relationshipId,
      sessionId,
      fYId,
      createdBy) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'Action': action,
      'StudentsList': students,
      'MessageFor': messageFor,
      'ClassCode': classCode,
      'SectionCode': sectionCode,
      'WantToRevertMessage': wantToRevertMessage,
      'MessageTitle': messageTitle,
      'Message': message,
      'RelationshipId': relationshipId,
      'SessionId': sessionId,
      'FYId': fYId,
      'CreatedBy': createdBy
    };
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NoticeSaveResponse>>(Options(
                method: 'POST', headers: _headers, extra: _extra)
            .compose(
                _dio.options, 'DigitalDiaryApi/InsertUpdateDeleteDigitalDiary',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            NoticeSaveResponse.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<TimeTableData> gettimetableList(
      empid, studentCode, relationshipId, sessionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'EmployeeCode': empid,
      'StudentCode': studentCode,
      'RelationshipId': relationshipId,
      'SessionId': sessionId
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TimeTableData>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'TimeTableReportApi/GETMobileClassTimeTableDayWise',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TimeTableData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TimeTableData> timetableClassWiseList(
      empid, studentCode, relationshipId, sessionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'ClassCode': empid,
      'SectionCode': studentCode,
      'RelationshipId': relationshipId,
      'SessionId': sessionId
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TimeTableData>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'TimeTableReportApi/GETMobileClassTimeTableDayWise',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TimeTableData.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
