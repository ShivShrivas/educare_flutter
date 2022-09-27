import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SFData{



  ///////////////////////// TOKEN ////////////
  Future<void> saveToken(BuildContext context,String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Token', token);
  }

  Future<String> getToken(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("Token")?? "0");
  }



  ///////////////////////// MENU /////////////////////////////////

  Future<void> saveModules(BuildContext context,bool communication,bool academics,bool assessment,bool fee) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('Communication', communication);
    prefs.setBool('Academics', academics);
    prefs.setBool('Assessment', assessment);
    prefs.setBool('Fee', fee);
  }

  Future<bool> getModulesCommStatus(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool("Communication")?? false);
  }
  Future<bool> getModulesAcademicsStatus(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool("Academics")?? false);
  }
  Future<bool> getModulesAssessmentStatus(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool("Assessment")?? false);
  }

  /////////////////////// Communication Menus .......//////////////////

  Future<void> saveMenuCommunication(BuildContext context,bool notice,bool circular,bool diary,bool notification,bool thoughts,bool menuComplaints,bool menuFeedback,bool menuDiscussion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('Notice', notice);
    prefs.setBool('Circular', circular);
    prefs.setBool('Diary', diary);
    prefs.setBool('Notification', notification);
    prefs.setBool('Thoughts', thoughts);
    prefs.setBool('Complaints', menuComplaints);
    prefs.setBool('Feedback', menuFeedback);
    prefs.setBool('Discussion', menuDiscussion);
  }

  Future<bool> getNoticePerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Notice')?? false);
  }
  Future<bool> getCircularPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Circular')?? false);
  }
  Future<bool> getDiaryPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Diary')?? false);
  }
  Future<bool> getNotificationPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Notification')?? false);
  }
  Future<bool> getThoughtsPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Thoughts')?? false);
  }

  Future<bool> getComplaintsPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Complaints')?? false);
  }
  Future<bool> getFeedbackPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Feedback')?? false);
  }
  Future<bool> getDiscussionPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Discussion')?? false);
  }


    //////////////////////// Academics /////////////////////////////
  Future<void> saveMenuAcademics(BuildContext context,bool timeTable,bool assignment,bool homeWork,bool lessonPlan,bool menuSyllabus,bool menuAttendance,bool menuLeave,bool menuLeaveApprova,bool menuODApprova) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('TimeTable', timeTable);
    prefs.setBool('Assignment', assignment);
    prefs.setBool('HomeWork', homeWork);
    prefs.setBool('LessonPlan', lessonPlan);
    prefs.setBool('Syllabus', menuSyllabus);
    prefs.setBool('Attendance', menuAttendance);
    prefs.setBool('Leave', menuLeave);
    prefs.setBool('LeaveApproval', menuLeaveApprova);
    prefs.setBool('ODApproval', menuODApprova);

  }

  Future<bool> getTimeTablePerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('TimeTable')?? false);
  }
  Future<bool> getAssignmentPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Assignment')?? false);
  }
  Future<bool> getHomeWorkPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('HomeWork')?? false);
  }
  Future<bool> getLessonPlanPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('LessonPlan')?? false);
  }
  Future<bool> getSyllabusPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Syllabus')?? false);
  }
  Future<bool> getAttendancePerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Attendance')?? false);
  }
  Future<bool> getLeavePerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('Leave')?? false);
  }
  Future<bool> getLeaveApprovalPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('LeaveApproval')?? false);
  }
  Future<bool> getODApprovalPerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('ODApproval')?? false);
  }


  //////////////////////// FEES /////////////////////////////
  Future<void> saveMenuFee(BuildContext context,bool timeTable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('FeeCard', timeTable);
  }

  Future<bool> getFeePerMit(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('FeeCard')?? false);
  }







  Future<void> saveConnectionDataToSF(BuildContext context,String groupName,String societyName,String schoolName,String entity,String groupCode,String societyCode,String schoolCode,String branchCode,String displayCode,String branchLogo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('GroupName', groupName);
    prefs.setString('SocietyName', societyName);
    prefs.setString('SchoolName', schoolName);
    prefs.setString('Entity', entity);
    prefs.setString('GroupCode', groupCode);
    prefs.setString('SocietyCode', societyCode);
    prefs.setString('SchoolCode', schoolCode);
    prefs.setString('BranchCode', branchCode);
    prefs.setString('DisplayCode', displayCode);
    prefs.setString('BranchLogo', branchLogo);
  }

  Future<void> saveLoginDataToSF(BuildContext context,int userId,String userName,int userTypeId,String loginAs,int activeAcademicYearId,String activeAcademicYear,int activeFinancialYearId,String activeFinancialYear,int relationshipId,String lastLogin,bool isHo,String profilePic,String mobileNo,String code,String departmentCode,String designationCode,String emailId,String schoolAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('UserId', userId);
    prefs.setString('UserName', userName);
    prefs.setInt('UserTypeId', userTypeId);
    prefs.setString('loginAs', loginAs);
    prefs.setInt('ActiveAcademicYearId', activeAcademicYearId);
    prefs.setString('ActiveAcademicYear', activeAcademicYear);
    prefs.setInt('ActiveFinancialYearId', activeFinancialYearId);
    prefs.setString('ActiveFinancialYear', activeFinancialYear);
    prefs.setInt('RelationshipId', relationshipId);
    prefs.setString('LastLogin', lastLogin);
    prefs.setBool('isHo', isHo);
    prefs.setString("profilePic", profilePic);
    prefs.setString("MobileNo", mobileNo);
    prefs.setString("Code", code);
    prefs.setString("DepartmentCode", departmentCode);
    prefs.setString("DesignationCode", designationCode);
    prefs.setString("EmailId", emailId);
    prefs.setString("SchoolAddress", schoolAddress);
  }



  Future<void> saveStudentDataToSF(BuildContext context,String studentCode,String classCode,String sectionCode,String className,String sectionName,String fatherName,String motherName,String name,String mobile,String dOB,String dateOfAdmission,String studentPhoto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('StudentCode', studentCode);
    prefs.setString('ClassCode', classCode);
    prefs.setString('SectionCode', sectionCode);
    prefs.setString('ClassName', className);
    prefs.setString('SectionName', sectionName);
    prefs.setString('FatherName', fatherName);
    prefs.setString('MotherName', motherName);
    prefs.setString('Name', name);
    prefs.setString('Mobile', mobile);
    prefs.setString('DOB', dOB);
    prefs.setString('DateOfAdmission', dateOfAdmission);
    prefs.setString('StudentPhoto', studentPhoto);
  }



  Future<void> saveIsAddSchool(BuildContext context,int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('AddSchool', status);
  }
  Future<int> getIsAddSchool(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getInt('AddSchool')?? 0);
  }


  Future<void> saveNotification(BuildContext context,int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('NStatus', status);
  }
  Future<int> getIsNotification(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getInt('NStatus')?? 0);
  }

  Future<void> saveAttendanceUser(BuildContext context,String datetime,bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('DateTime', datetime);
    prefs.setBool('Status', status);
  }

  Future<String> getAttendanceTime(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("DateTime")?? "");
  }

  Future<bool> getAttendanceStatus(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool("Status")?? false);
  }

  Future<String> getStudentClassCode(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("ClassCode")?? "");
  }

  Future<String> getStudentSectionCode(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("SectionCode")?? "");
  }


  Future<void> selectClassSectionToSF(BuildContext context,String classCode,String sectionCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ClassCode',classCode);
    prefs.setString('SectionCode', sectionCode);
  }


  Future<String> getCurrentClass(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("ClassCode")?? "");
  }

  Future<String> getCurrentSection(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("SectionCode")?? "");
  }





  Future<void> saveMinMAxDateToSF(BuildContext context,String fromDate,String toDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FromDate', fromDate);
    prefs.setString('ToDate', toDate);
  }




  removeAll(context) async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
   // return myPrefs.clear();
    await myPrefs.clear();
  }

  removeUserid(context) async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    await myPrefs.remove("UserId");
  }

  Future<String> getMaxDate(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("ToDate")?? "");
  }

  Future<String> getMobile(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("MobileNo")?? "0");
  }
  Future<String> getEmailId(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("EmailId")?? "0");
  }

  Future<String> getSchoolAddress(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("SchoolAddress")?? "");
  }

  Future<String> getProfilePic(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("profilePic")?? "0");
  }

  Future<int> getUseId(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getInt("UserId")?? 0);
  }


  Future<String> getEmpCode(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("Code")?? "0");
  }

  Future<String> getDepCode(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("DepartmentCode")?? "0");
  }

  Future<String> getDesignCode(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("DesignationCode")?? "0");
  }

  Future<String> getUseName(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("UserName")?? "");
  }

  Future<int> getUserTypeId(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getInt("UserTypeId")?? 0);
  }
  Future<String> getloginAs(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("loginAs")?? "");
  }

  Future<int> getSessionId(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getInt("ActiveAcademicYearId")?? 0);
  }
  Future<int> getRelationshipId(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getInt("RelationshipId")?? 0);
  }
  Future<String> getSessionName(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("ActiveAcademicYear")?? "");
  }

  Future<int> getFyID(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getInt("ActiveFinancialYearId")?? 0);
  }

  Future<String> getFyIDName(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("ActiveFinancialYear")?? "");
  }


  Future<Object> getisHo(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool("isHo")?? "");
  }







  Future<String> getGroupName(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("GroupName")?? "");
  }
  Future<String?> getSocietyName(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getString("SocietyName")?? "");
  }
  Future<String?> getSchoolName(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(("SchoolName"));
  }
  Future<String?> getEntity(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(("Entity"));
  }
  Future<String?> getGroupCode(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(("GroupCode"));
  }
  Future<String?> getSocietyCode(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(("SocietyCode"));
  }
  Future<String?> getSchoolCode(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(("SchoolCode"));
  }
  Future<String?> getBranchCode(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(("BranchCode"));
  }
  Future<String?> getDisplayCode(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(("DisplayCode"));
  }
  Future<String?> getBranchLogo(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(("BranchLogo"));
  }




}