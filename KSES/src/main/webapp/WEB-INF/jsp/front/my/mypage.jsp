<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
    <link href="/resources/css/front/reset.css" rel="stylesheet" />
    <script src="/resources/js/front/jquery-3.5.1.min.js"></script>
    <link href="/resources/css/front/mobile.css" rel="stylesheet" />
    <link href="/resources/css/front/common.css" rel="stylesheet" />

    <!--check box _ css-->
    <link href="/resources/css/front/magic-check.min.css" rel="stylesheet" />
    
    <title>경륜경정 스마트 입장예약</title>

	<!-- qrcode -->
	<script src="/resources/js/front/qrcode.js"></script>

    <!-- popup-->    
    <script src="/resources/js/front/bpopup.js"></script>
</head>

<body>
	<form:form name="regist" commandName="regist" method="post" action="/front/mypage.do">
	<input type="hidden" name="userId" id="userId" value="${sessionScope.userLoginInfo.userId}">
	<input type="hidden" id="userNm" name="userNm" value="${sessionScope.userLoginInfo.userNm}">
	<input type="hidden" id="userDvsn" name="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	
    <div class="wrapper">
        <div class="my_wrap contents">
            <div id="mybox" class="my_box">

            </div>

            <div id="my_menu" class="my_menu">
                <ul id="myset" class="myset">

                </ul>

                <ul id="service" class="service">

                </ul>
            </div>
        </div>
        
        <div id="foot_btn">
            <div class="contents">
                <ul>
                    <li class="home"><a href="javascript:fn_pageMove('regist','/front/main.do');">home</a><span>HOME</span></li>
                    <li class="rsv"><a href="javascript:fn_moveReservation();">rsv</a><span>입장예약</span></li>
                    <li class="my active"><a href="javascript:fn_pageMove('regist','/front/mypage.do');">my</a><span>마이페이지</span></li>
                </ul>
                <div class="clear"></div>
            </div>
        </div>
    </div>
	</form:form>
	
	<script src="/resources/js/front/jquery-spinner.min.js"></script>
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>

    <!--메뉴버튼 속성-->
    <script>
		$(document).ready(function() {
			mypageService.createMypageArea();
		});
		
		var mypageService = {
			createMypageArea : function() {
				if($("#userDvsn").val() == "USER_DVSN_1") {
					// 마이페이지 상단
					var setHtml = "";
					setHtml += "<div class='navi_left'>";
					setHtml +=     "<a href='javascript:history.back();' class='before_close'>";
					setHtml += "</div>";
					$("#mybox").html(setHtml);
					$("#mybox").append("<h1 class='mypage_name'><span>" + $("#userNm").val() + "</span>님</h1>");
					
					// 마이페이지 서비스
					setHtml = "";
					setHtml += "<p>나의 설정</p>";
					setHtml += "<li><a href='/front/userResvHistory.do'>나의 입장신청 예약 이력</a></li>";
					setHtml += "<li><a href='/front/userRcptInfo.do'>현금 영수증 관리</a></li>";
					$("#myset").html(setHtml);
					
					setHtml = "";
					setHtml += "<p>주요 서비스</p>";
					setHtml += "<li><a href=''>공지사항</a></li>";
					setHtml += "<li><a href='/front/actionLogout.do'>로그아웃</a></li>";
					$("#service").html(setHtml);
				} else {
					$("#mybox").addClass("non_login");
					
					// 마이페이지 상단
					var setHtml = "";
					setHtml += "<ul>";
					setHtml +=     "<li>로그인 하시고 <br>빠르게 입장 예약 하세요!</li>";
					setHtml +=     "<li>";
					setHtml += 	       "<a href='/front/login.do' class='loginBtn'>로그인</button>";
					setHtml +=     "</li>";
					setHtml += "</ul>";
					$("#mybox").html(setHtml);

					// 마이페이지 서비스
					setHtml = "";
					setHtml += "<p>설정</p>";
					setHtml += "<li><a href='/front/guestResvInfo.do'>비회원 예약 조회</a></li>";
					$("#myset").html(setHtml);
					
					setHtml = "";
					setHtml += "<p>주요 서비스</p>";
					setHtml += "<li><a href='/front/notice.do'>공지사항</a></li>";
					$("#service").html(setHtml);
				}
			}
		}
    </script>
</body>  
</html>