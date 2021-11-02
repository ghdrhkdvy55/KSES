<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import ="egovframework.com.cmm.LoginVO" %>
<%
LoginVO loginVO = (LoginVO)session.getAttribute("LoginVO");
   
if(loginVO == null ){
	
	%>
	<script type="text/javascript">
	location.href="/backoffice/login.do";
	</script>
	<%        
}else{ 
	%> 
<!--// top -->
  <div class="header_wrap">
    <header>
      <ul id="header" class="contents">
        <li class="logo"><h1>경륜경정 스마트 입장시스템</h1></li>
        <li class="toggle"><a href="#" onclick="toggleNav()" class="menu"></a></li>
        <li class="logo1"><img src="/resources/img/logo1.png" alt=""></li>
        <li class="member"><img src="/resources/img/login.png" alt=""><span><%=loginVO.getEmpNm() %></span> 님</li>
      </ul>
    </header>
    <!--top //-->
    <!--// menu list -->
    <div id="mySidenav" class="sidenav">
      <ul>
        <!--// 통합관리 -->
        <li>
          <button class="sub_menu">통합 관리</button>
          <div class="panel">
            <a href="../stt/stt_dashboard.html">통합이용 현황</a>
            <a href="../stt/stt_sales.html">매출현황</a>
          </div>
        </li>
        <!-- 통합관리 //-->
        <!--// 기초관리 -->
        <li>
          <button class="sub_menu">기초 관리</button>
          <div class="panel open">
            <a href="bas_code.html" class="active">공통코드 관리</a>
            <a href="bas_auth.html">권한관리</a>
            <a href="bas_program.html">프로그램 관리</a>
            <a href="bas_menu.html">메뉴 관리</a>
            <a href="bas_holiday.html">휴일관리</a>
            <a href="bas_kiosk.html">무인발권기 관리</a>
            <a href="bas_set_envir.html">환경설정</a>         
          </div>
        </li>
        <!-- 기초관리//-->
        <!--// 인사관리 -->
        <li>
          <button class="sub_menu">인사 관리</button>
          <div class="panel">
            <a href="../mng/mng_admin.html">관리자 관리</a>      
            <a href="../mng/mng_user.html">사용자 관리</a>
          </div>
        </li>
        <!-- 인사관리//-->
        <!--// 고객관리 -->
        <li>
          <button class="sub_menu">고객 관리</button>
          <div class="panel">
            <a href="../rsv/rsv_custom_info.html">예약 현황</a>
            <a href="../rsv/rsv_info_enter.html">출입통제 관리</a>
            <a href="../rsv/rsv_covid19qna.html">문진표 관리</a> 
            <a href="../rsv/rsv_vaccin_mng.html">백신 접종자 관리</a>
            <a href="../rsv/rsv_mms_mng.html">메시지 전송 관리</a>
            <a href="../rsv/rsv_mms_state.html">메시지 전송 현황 관리</a>
          </div>
        </li>
        <!-- 고객관리//-->  
        <!--// 시설관리 -->
        <li>
          <button class="sub_menu">시설 관리</button>
          <div class="panel">
            <a href="../bld/bld_branch_office.html">지점 시설 관리</a>
            <a href="../bld/bld_seat.html">좌석 추가</a>
            <a href="../bld/bld_season.html">시즌 관리</a>   
          </div>
        </li>
        <!-- 시설관리//-->  
        <!--// 시스템 현황 -->
        <li>
          <button class="sub_menu">시스템 관리</button>
          <div class="panel">
            <a href="../sys/sys_board_mng.html">게시판 등록 관리</a>
            <a href="../sys/sys_log.html">시스템 로그 현황</a>  
            <a href="../sys/sys_adm_login.html">관리자 로그인 현황</a>
          </div>
        </li>
        <!-- 시스템 현황//-->                                   
      </ul>
    </div>
    <!-- menu list //-->
  </div>
 <%
     }
 %>
 