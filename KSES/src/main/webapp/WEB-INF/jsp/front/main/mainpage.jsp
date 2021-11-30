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
    <link href="/resources/css/front/common.css" rel="stylesheet" />
    <link rel="stylesheet" href="/resources/css/front/mobile.css">
    <!--check box _ css-->
    <link href="/resources/css/front/magic-check.min.css" rel="stylesheet" />
    <title>경륜경정 스마트 입장예약</title>
    <!-- DatePicker-->
    <script src="/resources/js/front/jquery-ui.js"></script>
    <link rel="stylesheet" href="/resources/css/front/jquery-ui.css">
    <!-- Link Swiper's CSS -->
    <link rel="stylesheet" href="/resources/css/front/swiper.min.css">
    <!-- popup-->    
    <script src="/resources/js/front/bpopup.js"></script>
</head>
<body>
	<form:form name="regist" commandName="regist" method="post" action="/front/main.do">
	<input type="hidden" id="userDvsn" name="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" name="userId" id="userId" value="${sessionScope.userLoginInfo.userId}">
	<input type="hidden" name="resvSeq" id="resvSeq" value="">

	<div class="wrapper mainBack">
		<!--// header -->
        <div id="header"></div>
        <!-- header //-->
        <!--// contents-->
        <div id="container">
            <div class="contents">
                <div class="mo_user_info">
                    <ul>
                        <li class="slogan">빠르고 편리하게 입장 신청하세요!</li>
                        <li class="headerImg"></li>
                        <li class="topImg"></li>
                    </ul>                
                </div>

                <div class="main_user">                  
                    <div class="main_user_info no-reser">
                        <div class="main_user_pad">
                            <div class="mo_user_info_txt">
                                <ul id="user_info_top_area">

                                </ul>
                            </div>                            

                            <div class="clear"></div>
                            <div id="user_rsv_area">
                                <ul id="user_info_bottom_area">

                                    <li class="rsv_cancle"><a data-popup-open="rsv_cancle_pop">예약취소</a></li>

                                </ul>
                            </div>
                        </div>
                        <div class="clear"></div>
                    </div>
                    
                </div>

                <div id="qr_enter_area" class="qr_enter" style="display:none;">
                    <ul>
                        <li>QR 입장</li>
                        <li class="qr_code"><a href=""><img src="/resources/img/front/qr_code.svg" alt="qr코드"></a></li>
                    </ul>
                </div>
				<div id="rsv_reset_area" class="rsv_reset" style="display:none;">
                    <ul>
                        <li>처음부터 예약하시려면</li>
                        <li class="reservation"><a href="javascript:fn_moveReservation();">예약하기</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <!--contents //-->
        <!--// footer -->
        <div id="footer">
            <div class="contents">
                <div class="main_notice">
                    <div class="footer_tit">
                        <h2><span class="branch">분당지점</span>공지사항</h2>
                        <a href="" class="main_noti_link">더보기</a>
                        <div class="clear"></div>
                    </div>

                    <!-- 공지사항 데이터 -->
                    <div class="main_noti_list">
                        <div class="notice_con">                            
                            <p class="notice_date">2021.12.01</p>
                            <p class="notice_tit"><span>코로나 19 방역에 따라 경기 일정이 변경 되었습니다.</span></p>
                        </div>
                        <!--공지사항 내용 -->
                        <div class="notice_inner">
                            	코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나
                        </div>
                    </div>
                    <div>
                        <div class="notice_con">                           
                            <p class="notice_date">2021.12.01</p>
                            <p class="notice_tit"><span>[공지] 코로나 19 방역수칙에 따른 이용자 명부 작성을 의무화합니다.</span></p>
                        </div>
                        <!--공지사항 내용 -->
                        <div class="notice_inner">내용 
                        </div>
                    </div>   
                    <div>
                        <div class="notice_con">                            
                            <p class="notice_date">2021.12.01</p>
                            <p class="notice_tit"><span>[공지] 시스템 개선 및 점검 안내</span></p>
                        </div>
                        <!--공지사항 내용 -->
                        <div class="notice_inner">내용
                        </div>
                    </div>                     
                </div>
            </div>
            <div class="f_logo_box">
                <div class="contents">
                    <p class="f_copy">Copyright</p>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
        <!-- footer //-->

        <div id="foot_btn">
            <div class="contents">
                <ul>
                    <li class="home active"><a href="/front/main.do">home</a><span>HOME</span></li>
                    <li class="rsv"><a href="javascript:fn_moveReservation();">rsv</a><span>입장예약</span></li>
                    <li class="my"><a href="javascript:fn_pageMove('regist','/front/mypage.do');">my</a><span>마이페이지</span></li>
                </ul>
                <div class="clear"></div>
            </div>
        </div>
    </div>
    </form:form>  

    <!-- // 예약취소 팝업 -->
    <div data-popup="rsv_cancle_pop" class="popup">
      <div class="pop_con rsv_popup">
          <a class="button b-close">X</a>
          <div class="pop_wrap">
              <h4>예약 취소 하시겠습니까?</h4>
              <p>(재예약 시 동일한 좌석으로 예약이 불가할 수 있습니다.)</p>

               <ul class="rsv_list">
                   <li>
                        <ol>
                            <li>예약번호</li>
                            <li><span class="rsv_num">123458960</span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>지점</li>
                            <li><span class="rsv_brch">대전지점</span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>좌석</li>
                            <li><span class="rsv_seat">A-3F-001</span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>일시</li>
                            <li><span class="rsv_date">2021-12-01 12:00</span></li>
                        </ol>
                    </li> 
               </ul>
          </div>
		  <div class="cancel_btn">
              <a href="" class="grayBtn">예약취소</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>
	<!-- 최근입장정보 팝업 // -->
	
	<!-- // 예약정보 팝업 -->
	<div id="rsv_info" class="popup">
		<div class="pop_con rsv_popup">
			<a class="button b-close">X</a>
          	<div class="pop_wrap">
				<h4><span class="name"></span>님의 예약 정보 입니다.</h4>
              	<p>15시 까지 미 입장시 입장예약이 취소됩니다.</p>

               	<ul class="rsv_list">
					<li>
						<ol>
                            <li>지점</li>
                            <li><span id="rsv_center" class="rsv_brch">대전지점</span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>좌석</li>
                            <li><span id="rsv_seat" class="rsv_seat">A-3F-001</span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>일시</li>
                            <li><span id="rsv_date" class="rsv_date">2021-12-01 12:00</span></li>
						</ol>
					</li> 
				</ul>
			</div>
			<div class="cancel_btn">
              	<a href="javascript:common_modelClose('rsv_info');" class="grayBtn">확인</a>
          	</div>
			<div class="clear"></div>
		</div>
    </div>
    <!-- 예약정보 팝업 // -->
	
	<!-- // 예약취소 팝업 -->
    <div id="cancel_rsv_info" class="popup">
      <div class="pop_con rsv_popup">
          <a class="button b-close">X</a>
          <div class="pop_wrap">
              <h4>예약 취소 하시겠습니까?</h4>
              <p>15시 까지 미 입장시 입장예약이 취소됩니다.</p>

               <ul class="rsv_list">
                   <li>
                        <ol>
                            <li>예약번호</li>
                            <li><span id="cancel_rsv_num" class="rsv_num">123458960</span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>지점</li>
                            <li><span id="cancel_rsv_brch" class="rsv_brch">대전지점</span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>좌석</li>
                            <li><span id="cancel_rsv_seat" class="rsv_seat">A-3F-001</span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>일시</li>
                            <li><span id="cancel_rsv_date" class="rsv_date">2021-12-01 12:00</span></li>
                        </ol>
                    </li> 
               </ul>
          </div>
          <div class="cancle_btn">
              <a href="" id="resvCancleBtn" class="grayBtn">예약취소</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>
    <!-- 최근입장정보 팝업 // -->
    
	<!-- // 최근입장정보 팝업 -->
	<div id="re_rsv_info" data-popup="re_seat" class="popup">
		<div class="pop_con rsv_popup">
			<a class="button b-close">X</a>
          	<div class="pop_wrap">
				<h4><span class="name"></span>님 최근 입장 정보 입니다.</h4>
              	<p>(다른 고객님이 선 예약 시 예약이 불가능합니다.)</p>

               	<ul class="rsv_list">
					<li>
						<ol>
                            <li>지점</li>
                            <li><span id="re_rsv_center" class="rsv_brch">대전지점</span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>좌석</li>
                            <li><span id="re_rsv_seat" class="rsv_seat">A-3F-001</span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>일시</li>
                            <li><span id="re_rsv_date" class="rsv_date">2021-12-01 12:00</span></li>
						</ol>
					</li> 
				</ul>
			</div>
			<div class="summit_btn">
				<a href="" id="rebookBtn" class="mintBtn">최근 좌석으로 예약하기</a>
          	</div>
			<div class="clear"></div>
		</div>
    </div>
    <!-- 최근입장정보 팝업 // -->

    <!-- // 최근입장불가 팝업 -->
	<div data-popup="none_seat" class="popup">
		<div class="pop_con rsv_popup">
			<a class="button b-close">X</a>
          	<div class="pop_wrap">
              	<h4><span class="name">홍길동</span>님의</h4>
              	<p>최근 입장 좌석은 예약이 불가능 합니다. <br> 처음부터 예약 부탁드립니다.</p>
          	</div>
          	<div class="summit_btn">
              	<a href="" class="mintBtn">새로 예약하기</a>
          	</div>
          	<div class="clear"></div>
      	</div>
    </div>
    <!-- 최근입장불가 팝업 // -->
    
    
    <!-- mainpage.jsp script -->
    <script>
    	$(document).ready(function() {

			// 예약일자생성
			var test_time = "1700";
			
			var date = new Date();
			
			var time = date.format("HHmm");
			var today = date.format("yyyyMMdd");
			
			date.setDate(date.getDate() +1);
			var tomorrow = date.format("yyyyMMdd")
			
			var resvDate = (time < test_time) ? today : tomorrow;
			
			sessionStorage.setItem("resvDate",resvDate);

			// 메인영역생성
    		var userId = $("#userId").val();
    		mainService.fn_makeUserInfoArea(userId, mainService.fn_makeNoticeArea);
    	});
    	
    	var mainService =
		{ 
			fn_makeUserInfoArea: function(userId, callback) {
				var userInfoTopArea = $("#user_info_top_area");
				var userInfoBottomArea = $("#user_info_bottom_area");
				var qrEnterArea = $("#qr_enter_area");
				
				userInfoTopArea.empty();
				userInfoBottomArea.empty();
				qrEnterArea.hide();
				
				// 회원일 경우
				if(userId != "") {
					// 로그인 상태(회원)
					var url = "/front/userInfo.do";
					var params = { "userId" : userId }
					
					// 예약 단계별 화면처리를 위한 sessionStorage
					// loginType : 회원 -> 1  비회원 -> 2 
					sessionStorage.setItem("loginType","1");
					
					fn_Ajax
					(
					    url,
					    "GET",
						params,
						false,
						function(result) {
							if (result.status == "SUCCESS") {
								var today = new Date().format("yyyy-MM-dd");
								var reservationInfo = result.reservationInfo;
								var userLoginInfo = result.userLoginInfo;
								
								// 마지막 예약정보가 존재할 경우
								if(result.reservationInfo != null) {
									var obj = result.reservationInfo;
									$("#user_rsv_area").addClass("main_user_rsv");
									
									if(obj.resv_info_type == "NOW") {
										$("#user_rsv_area ul").addClass("member_rsv");			
										
										// 유저정보상단 HTML생성
										var setHtml = "";
										setHtml += "<li><em class='user_name'>" + userLoginInfo.userNm + "</em>님 입장예약 현황. <span class='thvac'></span></li>";
										setHtml += "<li><span class='today_date'>" + today + "</span></li>";  
										
										userInfoTopArea.append(setHtml);
										
										// 유저정보하단 HTML생성
										setHtml = "";
										setHtml += "<li><span><a href='javascript:mainService.fn_userResvInfo(&#39;NOW&#39;, &#39;" + obj.resv_seq + "&#39;, &#39;rsv_info&#39;);' >" + obj.center_nm + " " + obj.seat_nm + "</a></span></li>";
										setHtml += "<li class='rsv_cancle'><a href='javascript:mainService.fn_userResvInfo(&#39;CANCEL&#39;, &#39;" + obj.resv_seq + "&#39;, &#39;cancel_rsv_info&#39;);'>예약취소</a></li>";
										setHtml += "<li><em><img src='/resources/img/front/alert_icon.svg' alt='알림'>15시 까지 미 입장시 입장예약이 취소됩니다.</em></li>";
										userInfoBottomArea.append(setHtml);
										
										// 현재 예약정보 팝업창 정보 입력
										$("#rsv_info .name").html(userLoginInfo.userNm);
										$("#rsv_center").html(obj.center_nm);
										$("#rsv_seat").html(obj.seat_nm);
										$("#rsv_date").html(obj.frst_regist_dtm);
										
										// 처음부터 예약하기 영역 비활성화
										$("#rsv_reset_area").hide();
										
										// QR코드 영역 활성화
										$(qrEnterArea).show();
										$(qrEnterArea).find("a").attr("href","javascript:mainService.fn_moveQrPage('" + obj.resv_seq + "');");
									} else {								
										// 유저정보상단 HTML생성
										var setHtml = "";
										setHtml += "<li><em class='user_name'>" + userLoginInfo.userNm + "</em>님 예약내역이 없습니다. <span class='thvac'></span></li>";
										setHtml += "<li><span class='today_date'>" + today + "</span></li>";  
										
										userInfoTopArea.append(setHtml);
										
										// 유저정보하단 HTML생성
										setHtml = "";
										setHtml += "<li><span><a href='javascript:mainService.fn_userResvInfo(&#39;PRE&#39;, &#39;" + obj.resv_seq + "&#39;,&#39;re_rsv_info&#39;);' >다시 앉기<img src='/resources/img/front/arrow.png' alt='예약하기'></a></span></li>";
										setHtml += "<li><em><img src='/resources/img/front/alert_icon.svg' alt='알림'>과거 예약한 정보로 다시 앉으실 수 있습니다.</em></li>";
										userInfoBottomArea.append(setHtml);
										
										// 다시앉기 팝업창 정보 입력
										// TODO 추후 제거
										$("#re_rsv_info .name").html(userLoginInfo.userNm);
										$("#re_rsv_center").html(obj.center_nm);
										$("#re_rsv_seat").html(obj.seat_nm);
										$("#re_rsv_date").html(obj.resv_req_date);
										
										// 처음부터 예약하기 영역 활성화
										$("#rsv_reset_area").show();
									}
								} else {
									$("#user_rsv_area").addClass("main_user_rsv");
									// 유저정보상단 HTML생성
									var setHtml = "";
									setHtml += "<li><em class='user_name'>" + userLoginInfo.userNm + "</em>님 예약내역이 없습니다. <span class='thvac'></span></li>";
									setHtml += "<li><span class='today_date'>" + today + "</span></li>";  
									
									userInfoTopArea.append(setHtml);
									
									// 유저정보하단 HTML생성
									setHtml = "";
									setHtml += "<li><span><a href='/front/rsvCenter.do'>빠르게 예약하기<img src='/resources/img/front/arrow.png' alt='예약하기'></a></span></li>";
									userInfoBottomArea.append(setHtml);

									// 처음부터 예약하기 영역 활성화
									$("#rsv_reset_area").hide();
								}
							} else if(result.status == "LOGINFAIL"){
								
							}
						},
						function(request) {
							alert("ERROR : " +request.status);	       						
						}    		
					);	
					
				} else {
					// 비로그인 상태(비회원)
					$("#user_rsv_area").addClass("main_user_rsv");
					$(".main_user_pad").addClass("non_mem");
					$(".mo_user_info_txt").addClass("non_border");
					$(userInfoBottomArea).addClass("non_member");
					
					// 유저정보상단 HTML생성
					var setHtml = "";
					setHtml += "<li>오늘도 즐거운 하루 보내세요!</li>";
					userInfoTopArea.append(setHtml);
					
					// 유저정보하단 HTML생성
					setHtml = "";
					setHtml += "<li><a href='/front/login.do'>로그인</a></li>";
					setHtml += "<li><a href='javascript:fn_moveReservation();'>비회원 예약</a></li>";
					userInfoBottomArea.append(setHtml);
				}
			},
			fn_userResvInfo : function(division, resvSeq, popup) {				
				var url = "/front/userResvInfo.do";
				var params = {
					"resvSeq" : resvSeq,
					"resvDate" : sessionStorage.getItem("resvDate"),
				}
				
				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
				    	console.log(result);
				    	if (result.status == "SUCCESS") {
				    		if(result.resultlist != null) {
				    			var obj = result.resultlist;
				    			var userLoginInfo = result.userLoginInfo;
				    			
								if(division == "NOW") {
									$("#rsv_info .name").html(userLoginInfo.userNm);
									$("#rsv_center").html(obj.center_nm);
									$("#rsv_seat").html(obj.seat_nm);
									$("#rsv_date").html(obj.frst_regist_dtm);
								} else if(division == "PRE"){
									$("#re_rsv_info .name").html(userLoginInfo.userNm);
									$("#re_rsv_center").html(obj.center_nm);
									$("#re_rsv_seat").html(obj.seat_nm);
									$("#re_rsv_date").html(obj.resv_req_date);
									
									var rebookBtnText = obj.re_resv_yn == "Y" ? "최근 좌석으로 예약하기" : "현재 예약할수 없는 좌석입니다.";
									var rebookBtnHref = obj.re_resv_yn == "Y" ? "mainService.fn_rebook('" + obj.resv_seq + "');" : "void(0);"
									var rebookBtnColor = obj.re_resv_yn == "Y" ? "#47D6BE" : "#808080";
									
									$("#rebookBtn").css("background",rebookBtnColor);
									$("#rebookBtn").html(rebookBtnText)
									$("#rebookBtn").attr("href","javascript:" + rebookBtnHref);
								} else {
									$("#cancel_rsv_info .name").html(userLoginInfo.userNm);
									$("#cancel_rsv_num").html(obj.resv_seq);
									$("#cancel_rsv_center").html(obj.center_nm);
									$("#cancel_rsv_seat").html(obj.seat_nm);
									$("#cancel_rsv_date").html(obj.resv_req_date);
									$("#resvCancleBtn").attr("href","javascript:mainService.fn_resvCancel('" + obj.resv_seq + "');");
								}
				    		}
				    		
							$("#resvSeq").val(resvSeq);
							$("#" + popup).bPopup();
						} else {
							alert("error")
						}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);	
			},
			fn_resvCancel : function(resvSeq) {
				var url = "/front/resvInfoCancel.do";
				var params = {
					"userDvsn" : $("#userDvsn").val(),
					"resvSeq" : resvSeq
				}
				
				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
				    	console.log(result);
						if (result.status == "SUCCESS") {
							alert("예약이 정상적으로 취소되었습니다.");
							location.reload();
						} else if (result.status == "LOGIN FAIL"){
							alert(result.message);
							locataion.href = "/front/main.do";
						}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);	
			},
			fn_rebook : function(resvSeq) {
				
			},
			fn_moveQrPage : function(resvSeq) {
				location.href = "/front/qrEnter.do?resvSeq=" + resvSeq;
			}
		}
    </script>

    <script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>
</body>
</html>