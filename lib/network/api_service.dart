import 'package:dio/dio.dart';
import 'package:educareadmin/models/AcademicSession.dart';
import 'package:educareadmin/models/BookDataList.dart';
import 'package:educareadmin/models/ChapterListBookWise.dart';
import 'package:educareadmin/models/LessonPlan.dart';
import 'package:educareadmin/models/LessonPlanInnerData.dart';
import 'package:educareadmin/models/ResourcesTypeView.dart';
import 'package:educareadmin/models/SubjectList.dart';
import 'package:educareadmin/models/alldatateacher.dart';
import 'package:educareadmin/models/attendancedata.dart';
import 'package:educareadmin/models/calendardata.dart';
import 'package:educareadmin/models/chapterdata.dart';
import 'package:educareadmin/models/chapterstatusdata.dart';
import 'package:educareadmin/models/chapterstatuslist.dart';
import 'package:educareadmin/models/chatbox.dart';
import 'package:educareadmin/models/circulardata.dart';
import 'package:educareadmin/models/classcode.dart';
import 'package:educareadmin/models/classdata.dart';
import 'package:educareadmin/models/classsectiondata.dart';
import 'package:educareadmin/models/complainlist.dart';
import 'package:educareadmin/models/complaintresponse.dart';
import 'package:educareadmin/models/connectionconnector.dart';
import 'package:educareadmin/models/diarydata.dart';
import 'package:educareadmin/models/discussdata.dart';
import 'package:educareadmin/models/empleavedata.dart';
import 'package:educareadmin/models/employeedata.dart';
import 'package:educareadmin/models/feestructure.dart';
import 'package:educareadmin/models/leavechartdata.dart';
import 'package:educareadmin/models/leavelist.dart';
import 'package:educareadmin/models/leavemaster.dart';
import 'package:educareadmin/models/leavetype.dart';
import 'package:educareadmin/models/loginresponse.dart';
import 'package:educareadmin/models/menupermissiondata.dart';
import 'package:educareadmin/models/noticedata.dart';
import 'package:educareadmin/models/noticesaveresponse.dart';
import 'package:educareadmin/models/notificationdata.dart';
import 'package:educareadmin/models/odleavedata.dart';
import 'package:educareadmin/models/roledata.dart';
import 'package:educareadmin/models/sectiondata.dart';
import 'package:educareadmin/models/sessiondates.dart';
import 'package:educareadmin/models/studentattdata.dart';
import 'package:educareadmin/models/studentdata.dart';
import 'package:educareadmin/models/studentlistdata.dart';
import 'package:educareadmin/models/subjectdata.dart';
import 'package:educareadmin/models/teacherdatalist.dart';
import 'package:educareadmin/models/timetabledata.dart';
import 'package:educareadmin/models/userslist.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:async';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://allenp.superhouseerp.com/api/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  static ApiService create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger( requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    return ApiService(dio);
  }


  @POST("LoginApi/ConnectionConnector")
  Future<List<ConnectionConnector>> getconnection(
      @Field("BranchUrl") branchUrl,
      );

  @POST("LoginApi/UserAuthentication")
  Future<List<LoginResponse>> getLogin(
      @Field("UserName") UserName,
      @Field("Password") Password,
      @Field("DisplayCode") DisplayCode,
      @Field("GroupCode") GroupCode,
      @Field("SocietyCode") SocietyCode,
      @Field("SchoolCode") SchoolCode,
      @Field("BranchCode") BranchCode,
      @Field("GSMID") GSMID,
      @Field("LastLoginWith") LastLoginWith,
      );

  @POST("digitalDiaryApi/getclasslist")
  Future<List<ClassData>> getClassList(
      @Field("Action") action,@Field("RelationshipId") RelationshipId,@Field("SessionId") SessionId,
      );

  @POST("getMasterApi/GetClass")
  Future<List<ClassDataList>> getClassListdiscussion(
      @Field("Action") action,@Field("RelationshipId") relationshipId,@Field("SessionId") sessionId,@Field("CreatedBy") code,@Field("FYId") fYId) ;

  @POST("getMasterApi/GetSection")
  Future<List<SectionDataList>> getSectionListdiscussion(
      @Field("Action") action,@Field("RelationshipId") relationshipId,@Field("SessionId") sessionId,@Field("CreatedBy") code ,@Field("FYId") fYId,@Field("ClassCode") classCode) ;

  @POST("GetMasterApi/GetSubjectListUsingLoginId")
  Future<List<SubjectData>> getSubjectList(
      @Field("Action") action,@Field("RelationshipId") relationshipId,@Field("SessionId") sessionId,@Field("CreatedBy") code ,@Field("FYId") fYId,@Field("ClassCode") classCode,@Field("SectionCode") sectionCode) ;



  @POST("AdmissionTransactionApi/GetStudentDetails")
  Future<List<StudentData>> listuserData(
      @Field("Action") action,
      @Field("StudentCode") studentCode,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYid") fYid,
      );

  @POST("AttendanceMasterApi/GetLeaveTypeMaster")
  Future<List<LeaveTypeMaster>> getLeaveMasterList(
      @Field("Action") action,@Field("RelationshipId") RelationshipId,@Field("SessionId") SessionId,
      @Field("FYId") String fYId);


  @POST("digitalnoticeboardApi/getsendby")
  Future<List<UserType>> getUserList(
      @Field("Action") action,
      );

  @POST("employeemasterapi/getemployeeList")
  Future<List<TeacherListData>> getEmpList(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      );

  @POST("DigitalComplainApi/GetSearchingList")
  Future<List<RoleData>> getRoleTypeUserList(
      @Field("Action") action,
      @Field("RoleId") roleId,
      );


  @POST("DigitalNoticeBoardApi/GetDigitalNoticeBoard")
  Future<List<NoticeData>> listNotice(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      );

  @POST("NotificationApi/GetAllTimeTableNotifications")
  Future<List<Notificationdata>> listNotification(
      @Field("Action") action,
      @Field("UserId") userId,
      );

  @POST("UserMobileMasterApi/GetUserMobileRolePermission")
  Future<String> listpermission(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("UserId") userId,
      );

  @POST("UserMobileMasterApi/mGetUserMobileRolePermission")
  Future<List<MenuPermissionData>> listmenupermission(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("UserId") userId,
      );



  @POST("AttendanceTransactionApi/InsertUpdateDeleteEmployeeLeaveApplication")
  Future<String> leaveApprovals(
      @Field("Action") action,
      @Field("Remarks") remarks,
      @Field("IsApproved") isApproved,
      @Field("ApprovedFrom") approvedFrom,
      @Field("ApprovedTo") approvedTo,
      @Field("EmployeeCode") employeeCode,
      @Field("TransID") transID,
      @Field("ApprovedByEmployeCode") approvedByEmployeCode,
      @Field("ApprovedBy") approvedBy,
      @Field("LeaveTypeCode") leaveTypeCode,
      @Field("LeaveApprovalStatusByDates") leaveApprovalStatusByDates,
      @Field("SessionId") sessionId,
      @Field("RelationshipId") relationshipId,
      @Field("FYId") fYId,
      );


  @POST("AttendanceTransactionApi/EmployeeAttendanceLeaveMasterList")
  Future<List<LeaveList>> listLeave(
      @Field("EmployeeCode") employeeCode,
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );

  @POST("AssessmentApi/GetChapterTopicMapping")
  Future<List<ChapterData>> listChapter(
      @Field("ClassCode") classCode,
      @Field("SectionCode") sectionCode,
      @Field("SubjectCode") subjectCode,
      @Field("Action") action,
      @Field("AcademicSessionID") academicSessionID,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );



  @POST("NotificationApi/GetNotificationsList")
  Future<List<OdLeaveData>> listODLeave(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );



  @POST("FeeTransactionApi/mGetStudentWiseFeeStructure")
  Future<FeeInstallmentData> listFee(
      @Field("StudentCode") employeeCode,
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );

  @POST("GetMasterApi/GetSection")
  Future<List<ClassSectionData>> listclass(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      @Field("CreatedBy") createdBy,
      );

  @POST("EmployeeMasterApi/GetEmployeeList")
  Future<EmployeData> listemployee(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );





  @POST("AttendanceTransactionApi/EmployeeAttendanceLeaveMasterList")
  Future<List<LeaveChartData>> listLeaveChart(
      @Field("EmployeeCode") employeeCode,
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );

  @POST("GetMasterApi/GetDDLs")
  Future<List<LeaveTypeData>> listtypeChart(
      @Field("Action") action,
      );




  @POST("AttendanceTransactionApi/EmployeeAttendanceLeaveMasterList")
  Future<List<EmpleaveData>> listStatusChart(
      @Field("Action") action,
      @Field("TransID") transID,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );


  @POST("AssessmentTransactionApi/GetChapterStatus")
  Future<List<ChapterStatusData>> chapterStatusList(
      @Field("Action") action,
      @Field("Status") status,
      );

  @POST("AssessmentTransactionApi/GetChapterStatus")
  Future<List<ChapterStatusList>> getchapterStatusList(
      @Field("Action") action,
      @Field("ChapterCode") chapterCode,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      );


  @POST("AssessmentTransactionApi/InsertUpdateDeleteChapterStatus")
  Future<String> saveStatus(
      @Field("Action") action,
      @Field("ClassCode") classCode,
      @Field("SectionCode") sectionCode,
      @Field("SubjectCode") subjectCode,
      @Field("ChapterCode") chapterCode,
      @Field("EmployeeCode") employeeCode,
      @Field("StatusDate") statusDate,
      @Field("Status") status,
      @Field("Remark") remark,
      @Field("CreatedBy") createdBy,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );

  @POST("AttendanceTransactionApi/InsertUpdateDeleteEmployeeLeaveApplication")
  Future<String> leaveCancel(
      @Field("Action") action,
      @Field("TransID") transID,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );

  @POST("NotificationApi/InsertUpdateDeleteNotifications")
  Future<String> oDCancel(
      @Field("Action") action,
      @Field("IsApproved") isApproved,
      @Field("UpdatedBy") updatedBy,
      @Field("AllEmployeeApprovalList") allEmployeeApprovalList,
      );



  @POST("DigitalCircularApi/GetDigitalCircular")
  Future<List<CircularData>> getCircular(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      );

  @POST("DigitalComplainApi/GetComplains")
  Future<List<ComplainData>> getComplains(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("CreatedBy") createdBy,
      );


  @POST("DigitalNoticeBoardApi/GetStudentsList")
  Future<List<StudentListData>> getStudentList(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("ClassCode") classCode,
      @Field("SectionCode") sectionCode,
      @Field("FYId") fyID,
      );

  @POST("StudentAttendanceApi/GetStudentAttendanceDateWiseList")
  Future<List<StudentAttData>> getStudentListforAtt(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("ClassCode") classCode,
      @Field("SectionCode") sectionCode,
      @Field("FYId") fyID,
      @Field("AttendanceDate") att,
      );

  @POST("StudentAttendanceApi/GetStudentAttendanceSubjectWiseList")
  Future<List<StudentAttData>> getStudentListSubject(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("ClassCode") classCode,
      @Field("SectionCode") sectionCode,
      @Field("Subject") subject,
      @Field("FYId") fyID,
      @Field("AttendanceDate") att,
      @Field("CreatedBy") createdBy,
      @Field("UpdatedBy") updatedBy,
      );

  @POST("StudentAttendanceApi/InsertEditStudentAttendanceDateWise")
  Future<String> saveStudentListforAtt(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("ClassCode") classCode,
      @Field("SectionCode") sectionCode,
      @Field("FYid") fyID,
      @Field("AttendanceDate") att,
      @Field("UpdatedBy") updatedBy,
      @Field("CreatedBy") createdBy,
      @Field("StudentList") studentList,
      );

  @POST("StudentAttendanceApi/InsertEditStudentAttendanceSubjectWise")
  Future<String> saveStudentSubjectAtt(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("ClassCode") classCode,
      @Field("SectionCode") sectionCode,
      @Field("FYid") fyID,
      @Field("AttendanceDate") att,
      @Field("Subject") subject,
      @Field("UpdatedBy") updatedBy,
      @Field("CreatedBy") createdBy,
      @Field("StudentList") studentList,
      );



  @POST("timeTableApi/GetDefineClassTeacherMaster")
  Future<List<TeacherDataList>> getTeacherDiscussionList(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("ClassCode") classCode,
      @Field("FYId") fyID,
      );

  @POST("ComplainRegisterApi/GetTeacherList")
  Future<List<StudentListData>> getTeacherList(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("ClassCode") classCode,
      @Field("SectionCode") sectionCode,
      );


  @POST("DigitalComplainApi/GetComplains")
  Future<List<ComplainData>> getComplainsAdmin(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("ReceivedBy") createdBy,
      );

  @POST("DigitalComplainApi/getComplainChatBox")
  Future<List<ChatBox>> getChatBox(
      @Field("Action") action,
      @Field("TransId") transId,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );

  @POST("ComplainRegisterApi/ComplainRegisterList")
  Future<List<DiscussData>> getDiscussChatBox(
      @Field("Action") action,
      @Field("Code") code,
      @Field("ClassCode") classCode,
      @Field("CreatedBy") createdBy,
      @Field("ComplainAgainest") complainAgainest,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      );


  @POST("DigitalDiaryApi/GetDigitalDiary")
  Future<List<DiaryData>> listDiary(
      @Field("Action") action,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      );


  @POST("AttendanceTransactionApi/EmployeeAttendanceDateWiseList")
  Future<List<AttendanceDataOd>> empAttendance(
      @Field("Action") action,
      @Field("Code") code,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYid") fYid,
      @Field("Month") month,
      @Field("Year") year,
      );

  @POST("NotificationApi/InsertUpdateDeleteNotifications")
  Future<String> addODRemark(
      @Field("Action") action,
      @Field("EmployeeCode") code,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYid") fYid,
      @Field("EmployeeRemarks") remark,
      @Field("AttendanceTransId") attendanceTransId,
      @Field("Type") type,
      @Field("VDate") date,
      @Field("CreatedBy") createdBy,
      );



  @POST("StudentAttendanceApi/GetStudentAttendanceDateWiseList")
  Future<List<AttendanceData>> studentAttendance(
      @Field("Action") action,
      @Field("StudentCode") code,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYid") fYid,
      @Field("Month") month,
      @Field("Year") year,
      );



  @POST("GetMasterApi/GetSessionMinMaxDate")
  Future<List<SessionMinMax>> sessionMinMax(
      @Field("Action") action,
      @Field("SessionId") sessionId,
      );


  @POST("DigitalNoticeBoardApi/InsertUpdateDeleteDigitalNoticeBoard")
  Future<List<NoticeSaveResponse>> createNotice(
      @Field("Action") action,
      @Field("SendBy") sendBy,
      @Field("CreateNoticeFor") createNoticeFor,
      @Field("NoticeFor") noticeFor,
      @Field("StudentList") studentlist,
      @Field("ClassCode") code,
      @Field("NoticeHeadline") noticeHeadline,
      @Field("Description") description,
      @Field("ShowDate") showDate,
      @Field("EndDate") endDate,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      @Field("CreatedBy") createdBy,
      );


  @POST("AttendanceTransactionApi/InsertUpdateDeleteEmployeeLeaveApplication")
  Future<String> createLeave(
      @Field("EmployeeCode") employeeCode,
      @Field("LeaveTypeCode") leaveTypeCode,
      @Field("DesignationCode") designationCode,
      @Field("DepartmentCode") departmentCode,
      @Field("LeaveFrom") leaveFrom,
      @Field("LeaveTo") leaveTo,
      @Field("LeaveReason") leaveReason,
      @Field("Remarks") remarks,
      @Field("LeaveFor") leaveFor,
      @Field("CommunicationPrefferedMode") communicationPrefferedMode,
      @Field("OnLeaveContactNo") onLeaveContactNo,
      @Field("OnLeaveAddress") onLeaveAddress,
      @Field("IsLeaveRecieved") isLeaveRecieved,
      @Field("InAbsenceResponsibleEmployeeId") inAbsenceResponsibleEmployeeId,
      @Field("ApprovedFrom") approvedFrom,
      @Field("ApprovedTo") approvedTo,
      @Field("RelationshipId") relationshipId,
      @Field("FYId") fYId,
      @Field("SessionId") sessionId,
      @Field("CreatedBy") createdBy,
      @Field("Action") action,
      @Field("LeaveApprovalStatusByDates") leaveApprovalStatusByDates,
      );


  @POST("AttendanceTransactionApi/InsertUpdateDeleteEmployeeLeaveApplication")
  Future<String> updateLeave(
      @Field("TransID") TransID,
      @Field("EmployeeCode") employeeCode,
      @Field("LeaveTypeCode") leaveTypeCode,
      @Field("DesignationCode") designationCode,
      @Field("DepartmentCode") departmentCode,
      @Field("LeaveFrom") leaveFrom,
      @Field("LeaveTo") leaveTo,
      @Field("LeaveReason") leaveReason,
      @Field("Remarks") remarks,
      @Field("LeaveFor") leaveFor,
      @Field("CommunicationPrefferedMode") communicationPrefferedMode,
      @Field("OnLeaveContactNo") onLeaveContactNo,
      @Field("OnLeaveAddress") onLeaveAddress,
      @Field("IsLeaveRecieved") isLeaveRecieved,
      @Field("InAbsenceResponsibleEmployeeId") inAbsenceResponsibleEmployeeId,
      @Field("ApprovedFrom") approvedFrom,
      @Field("ApprovedTo") approvedTo,
      @Field("RelationshipId") relationshipId,
      @Field("FYId") fYId,
      @Field("SessionId") sessionId,
      @Field("CreatedBy") createdBy,
      @Field("Action") action,
      @Field("LeaveApprovalStatusByDates") leaveApprovalStatusByDates,
      );





  @POST("HomeworkApi/InsertUpdateDeleteHomeworks")
  Future<String> createHomeWork(
      @Field("ClassCode") communicationPrefferedMode,
      @Field("SectionCode") onLeaveContactNo,
      @Field("SubjectCode") onLeaveAddress,
      @Field("ShowDate") isLeaveRecieved,
      @Field("EndDate") inAbsenceResponsibleEmployeeId,
      @Field("Title") approvedFrom,
      @Field("Description") approvedTo,
      @Field("RelationshipId") relationshipId,
      @Field("FYId") fYId,
      @Field("SessionId") sessionId,
      @Field("CreatedBy") createdBy,
      @Field("Action") action,
      @Field("IsActive") isActive,
      );




  @POST("AttendanceTransactionApi/InsertEditEmployeeAttendanceDateWise")
  Future<String> markAttendance(
      @Field("Action") action,
      @Field("EmployeeCode") employeeCode,
      @Field("SessionId") sessionId,
      @Field("RelationshipId") relationshipId,
      @Field("FYid") fYId,
      @Field("AttendanceDate") attendanceDate,
      @Field("AbbreviationCode") abbreviationCode,
      @Field("CreatedBy") createdBy,
      );



  @POST("DigitalCircularApi/InsertUpdateDeleteDigitalCircular")
  Future<List<NoticeSaveResponse>> createCircular(
      @Field("Action") action,
      @Field("SendBy") sendBy,
      @Field("CreateCircularFor") createNoticeFor,
      @Field("CircularFor") noticeFor,
      @Field("StudentList") studentlist,
      @Field("ClassCode") code,
      @Field("CircularHeadline") noticeHeadline,
      @Field("Description") description,
      @Field("ShowDate") showDate,
      @Field("EndDate") endDate,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      @Field("CreatedBy") createdBy,
      );

  @POST("DigitalComplainApi/InsertUpdateDeleteDigitalComplain")
  Future<List<ComplainResponse>> createComplain(
      @Field("Action") action,
      @Field("ComplainTo") complainTo,
      @Field("ReceivedBy") receivedBy,
      @Field("Subject") subject,
      @Field("Description") description,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      @Field("CreatedBy") createdBy,
      );

  @POST("DigitalComplainApi/InsertUpdateDeleteDigitalComplainChatBox")
  Future<String> sendMessage(
      @Field("Action") action,
      @Field("SenderID") senderID,
      @Field("ReceiverID") receiverID,
      @Field("TransId") transId,
      @Field("Message") message,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      @Field("CreatedBy") createdBy,
      );

  @POST("ComplainRegisterApi/InsertDeleteComplainRegister")
  Future<String> sendMessageDiscussion(
      @Field("Action") action,
      @Field("ComplainBy") senderID,
      @Field("ComplainAgainest") receiverID,
      @Field("ComplainText") message,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("CreatedBy") createdBy,
      @Field("ClassCode") classCode,
      @Field("SectionCode") sectionCode,
      @Field("FYId") fYId,
      );

  @POST("DigitalComplainApi/InsertUpdateDeleteDigitalComplain")
  Future<String> updateStatus(
      @Field("Action") action,
      @Field("TransId") transId,
      @Field("Status") status,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      @Field("UpdatedBy") createdBy,
      );



  @POST("DigitalDiaryApi/InsertUpdateDeleteDigitalDiary")
  Future<List<NoticeSaveResponse>> createDialry(
      @Field("Action") action,
      @Field("StudentsList") students,
      @Field("MessageFor") messageFor,
      @Field("ClassCode") classCode,
      @Field("SectionCode") sectionCode,
      @Field("WantToRevertMessage") wantToRevertMessage,
      @Field("MessageTitle") messageTitle,
      @Field("Message") message,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      @Field("FYId") fYId,
      @Field("CreatedBy") createdBy,
      );




  @POST("TimeTableReportApi/GETMobileClassTimeTableDayWise")
  Future<TimeTableData> gettimetableList(
      @Field("EmployeeCode") empid,
      @Field("StudentCode") studentCode,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      );

  @POST("TimeTableReportApi/GETMobileClassTimeTableDayWise")
  Future<TimeTableData> timetableClassWiseList(
      @Field("ClassCode") empid,
      @Field("SectionCode") studentCode,
      @Field("RelationshipId") relationshipId,
      @Field("SessionId") sessionId,
      );


  @POST("AssessmentApi/GetDefineChapterResourceMasterDetails")
  Future<List<ClassDataList>> getClassListEmployeeWise(
      @Field("Action") action,@Field("RelationshipId") relationshipId,@Field("SessionId") sessionId,@Field("CreatedBy") code,@Field("FYId") fYId
  );



  @POST("GetMasterApi/GetSessionMonths")
  Future<List<AcademicSessionDataList>> getAcademicSessionList(
      @Field("Action") action,@Field("RelationshipId") relationshipId,@Field("SessionId") sessionId,@Field("CreatedBy") code,@Field("FYId") fYId
  );




  @POST("AssessmentApi/GetDefineChapterResourceMasterDetails")
  Future<List<SubjectDataList>> getSubjectListClassWise(
      @Field("Action") action,@Field("RelationshipId") relationshipId,@Field("SessionId") sessionId,@Field("CreatedBy") code,@Field("FYId") fYId,@Field("ClassCode") classCode
  );



  @POST("AssessmentApi/GetDefineChapterResourceMasterDetails")
  Future<List<BookList>> getBookListClassWise(
      @Field("Action") action,@Field("RelationshipId") relationshipId,@Field("SessionId") sessionId,@Field("CreatedBy") code,@Field("FYId") fYId,@Field("ClassCode") classCode,@Field("SubjectCode") subjectCode
  );



  @POST("AssessmentApi/GetDefineChapterResourceMasterDetails")
  Future<List<ChapterListBookWise>> getChapterListBookWise(
      @Field("Action") action,@Field("SessionId") sessionId,@Field("FYId") fYId,@Field("BookCode") bookCode
  );





  @POST("AssessmentApi/GetChapterResourceAndLessonPlanView")
  Future<List<ResourcesTypeViewList>> getResourceTypeView(
      @Field("Action") action,@Field("ClassCode") classCode,@Field("SubjectCode") subjectCode,@Field("SessionId") sessionId,@Field("FYId") fYId,@Field("BookCode") bookCode,@Field("ChapterCode") chapterCode,@Field("TypeCode") typeCode
  );




  @POST("AssessmentApi/GetChapterResourceAndLessonPlanView")
  Future<List<LessonPlanList>> getLessonPlanView(
      @Field("Action") action,@Field("ClassCode") classCode,@Field("SubjectCode") subjectCode,@Field("SessionId") sessionId,@Field("FYId") fYId,@Field("BookCode") bookCode,@Field("ChapterCode") chapterCode,@Field("TypeCode") typeCode
  );






  @POST("AssessmentApi/GetChapterResourceAndLessonPlanView")
  Future<List<LessonPlanInnerDataList>> getLessonPlanInnerList(
      @Field("Action") action,@Field("SessionId") sessionId,@Field("FYId") fYId,@Field("Code") code,@Field("TypeCode") typeCode
  );




  //
  // @POST("AssessmentApi/GetChapterResourceAndLessonPlanView")
  // Future<List<ResourcesTypeViewList>> getLessonPlan(
  //     @Field("Action") action,@Field("SessionId") sessionId,@Field("FYId") fYId,@Field("Code") chapterCode,@Field("TypeCode") typeCode
  // );







/*@POST("/post")
  @MultiPart()
  Future<String> example(
      @Part() int foo,
      { @Part(name: "bar") String barbar,
        @Part(contentType:'application/json') File file
       }
      )*/
/*
  @MultiPart()
  @POST("upload")
  Future<ResponseBody> uploadFile(
      @Path("Action") String action,
    //@Part() MultipartFile file,

      );*/

}
