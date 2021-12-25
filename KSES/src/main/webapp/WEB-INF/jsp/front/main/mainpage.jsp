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
    <style>body{background:#f4f4f4 ;}</style>
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

                                    <li class="rsv_cancel"><a data-popup-open="rsv_cancel_pop">예약취소</a></li>

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
                        <li class="reservation"><a href="/front/rsvCenter.do">예약하기</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <!--contents //-->
        <!--// footer -->
        <div id="footer">
            <div class="contents">
                <div class="main_notice" id="main_notice">
                    <div class="footer_tit">
                        <h2><span class="branch" id="sp_centerBoard"></span>공지사항</h2>
                        <a href="/front/notice.do" class="main_noti_link">더보기</a>
                        <div class="clear"></div>
                    </div>
                    <!-- 공지사항 데이터 -->
                                                           
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
                    <li class="rsv"><a href="/front/rsvCenter.do">rsv</a><span>입장예약</span></li>
                    <li class="my"><a href="javascript:fn_pageMove('regist','/front/mypage.do');">my</a><span>마이페이지</span></li>
                </ul>
                <div class="clear"></div>
            </div>
        </div>
    </div>
    </form:form>  

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
                        	<li>예약번호</li>
                        	<li><span id="rsv_num" class="rsv_num"></span></li>
                    	</ol>
                	</li>
					<li>
                    	<ol>
                        	<li>경주일</li>
                        	<li><span id="rsv_date"></span></li>
                    	</ol>
                	</li>
					<li>
						<ol>
                            <li>지점</li>
                            <li><span id="rsv_center"></span></li>
                        </ol>
                    </li>
					<li>
                        <ol>
                            <li>층</li>
                            <li><span id="rsv_floor"></span></li>
                        </ol>
                    </li>
					<li>
                        <ol>
                            <li>구역</li>
                            <li><span id="rsv_part"></span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>좌석</li>
                            <li><span id="rsv_seat"></span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>예약일</li>
                            <li><span id="rsv_req_date"></span></li>
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
          	<!-- 닫기버튼으로 대체 <a class="button b-close">X</a>-->
          	<div class="pop_wrap">
              	<h4>예약 취소 하시겠습니까?</h4>
              	<p>15시 까지 미 입장시 입장예약이 취소됩니다.</p>
				<ul class="rsv_list">
                	<li>
                    	<ol>
                        	<li>예약번호</li>
                        	<li><span id="cancel_rsv_num" class="rsv_num"></span></li>
                    	</ol>
                	</li>
					<li>
                    	<ol>
                        	<li>경주일</li>
                        	<li><span id="cancel_rsv_date"></span></li>
                    	</ol>
                	</li>
                	<li>
                    	<ol>
                        	<li>지점</li>
                        	<li><span id="cancel_rsv_center"></span></li>
                    	</ol>
                	</li>
					<li>
                        <ol>
                            <li>층</li>
                            <li><span id="cancel_rsv_floor"></span></li>
                        </ol>
                    </li>
					<li>
                        <ol>
                            <li>구역</li>
                            <li><span id="cancel_rsv_part"></span></li>
                        </ol>
                    </li>
                	<li>
                    	<ol>
                        	<li>좌석</li>
                        	<li><span id="cancel_rsv_seat"></span></li>
                    	</ol>
                	</li>
                	<li>
                    	<ol>
                        	<li>예약일</li>
                        	<li><span id="cancel_rsv_req_date"></span></li>
                    	</ol>
                	</li> 
               	</ul>
          	</div>
          	<!--1215 닫기버튼 추가 -->
          	<div class="cancel_btn">
          		<ul>
          			<li><a href="" id="resvCancleBtn" class="grayBtn">예약취소</a></li>
          			<li><a href="javascript:bPopupClose('cancel_rsv_info');" id="resvCancleBtn" class="dislBtn">닫기</a></li>
          		</ul>              	
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
                        	<li>예약번호</li>
                        	<li><span id="re_rsv_num" class="rsv_num"></span></li>
                    	</ol>
                	</li>
					<li>
                    	<ol>
                        	<li>경주일</li>
                        	<li><span id="re_rsv_date"></span></li>
                    	</ol>
                	</li>
					<li>
						<ol>
                            <li>지점</li>
                            <li><span id="re_rsv_center"></span></li>
                        </ol>
                    </li>
					<li>
                        <ol>
                            <li>층</li>
                            <li><span id="re_rsv_floor"></span></li>
                        </ol>
                    </li>
					<li>
                        <ol>
                            <li>구역</li>
                            <li><span id="re_rsv_part"></span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>좌석</li>
                            <li><span id="re_rsv_seat"></span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>신청일</li>
                            <li><span id="re_rsv_req_date"></span></li>
						</ol>
					</li> 
				</ul>
			</div>
			<div class="summit_btn">
				<a href="javascript:void(0);" id="rebookBtn" class="mintBtn">최근 좌석으로 예약하기</a>
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
    
	<!-- // 결제인증 팝업 -->
    <div id="pay_number" class="popup">
		<div class="pop_con rsv_popup">
			<a class="button b-close">X</a>
          	<div class="pop_wrap">
            	<h4>결제 비밀번호를 입력해주세요.</h4>
            	<ul class="pay_passWord">
                	<li><input type="password" id="Card_Pw" placeholder="비밀번호를 입력하세요."></li>
                	<li><a href="javascript:void(0);" class="mintBtn">확인</a></li>
            	</ul>
          	</div>
      	</div>
    </div>
    <!-- 결제인증 팝업 // -->
    
    
    <!-- mainpage.jsp script -->
    <script>
    	$(document).ready(function() {
			// 메인영역생성
    		var userId = $("#userId").val();
    		mainService.fn_makeUserInfoArea(userId, mainService.fn_makeNoticeArea);
    	});
    	
    	var mainService =
		{ 
			fn_makeUserInfoArea : function(userId, callback) {
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
					var params = {"userId" : userId}
					
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
										setHtml += "<li class='vacStat'><em class='user_name'>" + userLoginInfo.userNm + "</em>님 입장예약 현황. <span class=''></span></li>";
										setHtml += "<li><span class='today_date'>" + fn_resvDateFormat(obj.resv_end_dt) + "</span></li>";
										
										userInfoTopArea.append(setHtml);
										
										// 유저정보하단 HTML생성
										setHtml = "";
										setHtml += "<li><span><a href='javascript:mainService.fn_userResvInfo(&#39;NOW&#39;, &#39;" + obj.resv_seq + "&#39;, &#39;rsv_info&#39;);' >" + obj.center_nm + " " + obj.seat_nm + "</a></span></li>";
										setHtml += "<li class='rsv_cancel'><a href='javascript:mainService.fn_userResvInfo(&#39;CANCEL&#39;, &#39;" + obj.resv_seq + "&#39;, &#39;cancel_rsv_info&#39;);'>예약취소</a></li>";
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
										setHtml += "<li class='vacStat'><em class='user_name'>" + userLoginInfo.userNm + "</em>님 예약내역이 없습니다. <span class=''></span></li>";
										setHtml += "<li><span class='today_date'>" + today + "</span></li>";  
										
										userInfoTopArea.append(setHtml);
										
										// 유저정보하단 HTML생성
										setHtml = "";
										setHtml += "<li><span><a href='javascript:mainService.fn_userResvInfo(&#39;PRE&#39;, &#39;" + obj.resv_seq + "&#39;,&#39;re_rsv_info&#39;);' >최근 좌석으로 다시 앉기<img src='/resources/img/front/arrow.png' alt='예약하기'></a></span></li>";
										setHtml += "<li><em><img src='/resources/img/front/alert_icon.svg' alt='알림'>과거 예약한 정보로 다시 앉으실 수 있습니다.</em></li>";
										userInfoBottomArea.append(setHtml);
										
										// 다시앉기 팝업창 정보 입력
										// TODO 추후 제거
										$("#re_rsv_info .name").html(userLoginInfo.userNm);
										
										// 처음부터 예약하기 영역 활성화
										$("#rsv_reset_area").show();
									}
								} else {
									$("#user_rsv_area").addClass("main_user_rsv");
									// 유저정보상단 HTML생성
									var setHtml = "";
									setHtml += "<li class='vacStat'><em class='user_name'>" + userLoginInfo.userNm + "</em>님 예약내역이 없습니다. <span class=''></span></li>";
									setHtml += "<li><span class='today_date'>" + today + "</span></li>";  
									
									userInfoTopArea.append(setHtml);
									
									// 유저정보하단 HTML생성
									setHtml = "";
									setHtml += "<li><span><a href='/front/rsvCenter.do'>빠르게 예약하기<img src='/resources/img/front/arrow.png' alt='예약하기'></a></span></li>";
									userInfoBottomArea.append(setHtml);

									// 처음부터 예약하기 영역 활성화
									$("#rsv_reset_area").hide();
								}
								
								//백신접종정보 표출
								if(result.vacntnInfo != null) {
						    		switch (result.vacntnInfo.pass_yn) {
										case "Y" : $(".vacStat span").addClass("thVac").html("접종 완료상태"); break;
										case "N" : $(".vacStat span").addClass("nonVac").html("백신패스 만료상태"); break;  
										default: $(".vacStat span").addClass("nonVac").html("접종정보 없음"); break;
									}	
								}
							} else if(result.status == "LOGINFAIL"){
								
							}
						},
						function(request) {
							fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
						}    		
					);
					
					//여기 부분 공지 사항 들어가는 자리 
					
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
					setHtml += "<li><a href='/front/rsvCenter.do'>비회원 예약</a></li>";
					userInfoBottomArea.append(setHtml);
					//일반 공지 정리 하기 
				}
				// 공지값 넣기 
				mainService.fn_boardINfo("NOT");
				
			},
    	    fn_boardINfo  : function (centerCd){
    	    	
    	    	var url = "/front/boardInfo.do";
    	    	var params = {
    	    			"boardCd" : "Not",
    	    			"firstIndex" : "0",
    	    			"pageSize" : "5",
    	    			"pageUnit" : "5",
    	    			"searchCenterCd" : centerCd
    	    	}
    	    	fn_Ajax 
    	    	(
    	    			url,
    	    			"POST",
    	    			params,
    	    			false,
    	    			function(result){
    	    				if (result.status == "SUCCESS") {
    	    					if (result.resultlist.length>0){
    	    						var sHTML = "";
    	    						
    	    						for (var i in result.resultlist){
    	    							var cssClass = (i == 0) ? "class='main_noti_list'":"";
    	    							var obj = result.resultlist[i];
    	    							sHTML += "<div "+cssClass+">"
    	    		                          +  "  <div class='notice_con' id='n_"+obj.board_seq+"'> "                           
    	    		                          +  "     <p class='notice_date'>'"+obj.last_updt_dtm+"'</p>"
    	    		                          +  "     <p class='notice_tit'><span>'"+obj.board_title+"'</span></p>"
    	    		                          +  "	</div>"
    	    		                          +  "	<div class='notice_inner' id='c_"+obj.board_seq+"'>1231313121</div>"
    	    		                          +  "</div>"; 
    	    							$("#main_notice:last").append(sHTML);
    	    							sHTML = "";
    	    						}
    	    						
    	    						 $('.notice_con').click(function(e) {
    	    					         e.preventDefault();
    	    					         var $this = $(this);
    	    					         var id = $(this).attr("id");
    	    					         
    	    					         if ($this.next().hasClass('show')) {
    	    					        	 $("#c_"+ id.replace("n_", "") ).html("");
    	    					             $this.next().removeClass('show');
    	    					             $this.next().slideUp(350);
    	    					         } else {
    	    					        	
    	    					        	 $this.parent().parent().find('.notice_inner').removeClass('show');
    	    					             $this.parent().parent().find('.notice_inner').slideUp(350);
    	    					             $this.next().toggleClass('show');
    	    					             $this.next().slideToggle(350);
    	    					            
    	    					        	 fn_Ajax
   	    									 (
   	    										"/front/boardInfoDetail.do",
   	    										"GET",
   	    										{boardSeq : id.replace("n_", "")},
   	    										false,
   	    										function(result) {
   	    											if (result.status == "SUCCESS") {
   	    												var obj = result.result;
   	    				    	    					$("#c_"+ id.replace("n_", "") ).html(obj.board_cn);
   	    				    	    					if (result.resultlist != undefined){
   	    				    	    						//파일 리스트 표출 
   	    				    	    					}
   	    								            }
   	    								         },
   	    								         function(request) {
   	    								        	 fn_openPopup("ERROR : " + request.status, "red", "ERROR", "확인", "");	
   	    								         }
   	    								     );
    	    					        	
    	    					             
    	    					         }
    	    					     });
    	    						
    	    						
    	    					}	
    	    				}else{
    	    					fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");
    	    				} 
    	    				
    	    			}
    	    	)
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
				    	if (result.status == "SUCCESS") {
				    		if(result.resultlist != null) {
				    			var obj = result.resultlist;
				    			var userLoginInfo = result.userLoginInfo;
				    			
								if(division == "NOW") {
									$("#rsv_info .name").html(userLoginInfo.userNm);
									$("#rsv_num").html(obj.resv_seq);
									$("#rsv_date").html(fn_resvDateFormat(obj.resv_end_dt));
									$("#rsv_center").html(obj.center_nm);
												
									if(obj.resv_entry_dvsn == "ENTRY_DVSN_1") {
										$("#rsv_info ul > li:eq(3)").hide();
										$("#rsv_info ul > li:eq(4)").hide();
									} else {
										$("#rsv_info ul > li:eq(3)").show();
										$("#rsv_info ul > li:eq(4)").show();
										$("#rsv_floor").html(obj.floor_nm);
										$("#rsv_part").html(obj.part_nm);										
									}
									
									$("#rsv_seat").html(obj.seat_nm);
									$("#rsv_req_date").html(obj.resv_req_date);
								} else if(division == "PRE"){
									$("#re_rsv_info .name").html(userLoginInfo.userNm);
									$("#re_rsv_num").html(obj.resv_seq);
									$("#re_rsv_date").html(fn_resvDateFormat(obj.resv_end_dt));
									$("#re_rsv_center").html(obj.center_nm);
									
									if(obj.resv_entry_dvsn == "ENTRY_DVSN_1") {
										$("#re_rsv_info ul > li:eq(3)").hide();
										$("#re_rsv_info ul > li:eq(4)").hide();
									} else {
										$("#re_rsv_info ul > li:eq(3)").show();
										$("#re_rsv_info ul > li:eq(4)").show();
										$("#re_rsv_floor").html(obj.floor_nm);
										$("#re_rsv_part").html(obj.part_nm);										
									}
									
									$("#re_rsv_seat").html(obj.seat_nm);
									$("#re_rsv_req_date").html(obj.resv_req_date);
									
									if(obj.re_resv_yn == "Y") {
										$("#rebookBtn").css("background","#47D6BE");
										$("#rebookBtn").html("최근 좌석으로 예약하기")
										$("#rebookBtn").click(function (e) {
											mainService.fn_reSeat(obj);
										});										
									} else {
										$("#rebookBtn").css("background","#808080");
										$("#rebookBtn").html("현재 예약할수 없는 좌석입니다.")
									}
								} else {
									$("#cancel_rsv_info .name").html(userLoginInfo.userNm);
									$("#cancel_rsv_num").html(obj.resv_seq);
									$("#cancel_rsv_date").html(fn_resvDateFormat(obj.resv_end_dt));
									$("#cancel_rsv_center").html(obj.center_nm);
									
									if(obj.resv_entry_dvsn == "ENTRY_DVSN_1") {
										$("#cancel_rsv_info ul > li:eq(3)").hide();
										$("#cancel_rsv_info ul > li:eq(4)").hide();
									} else {
										$("#cancel_rsv_info ul > li:eq(3)").show();
										$("#cancel_rsv_info ul > li:eq(4)").show();
										$("#cancel_rsv_floor").html(obj.floor_nm);
										$("#cancel_rsv_part").html(obj.part_nm);										
									}

									$("#cancel_rsv_seat").html(obj.seat_nm);
									$("#cancel_rsv_req_date").html(obj.resv_req_date);
									$("#resvCancleBtn").attr("href","javascript:mainService.fn_resvCancelCheck('" + obj.resv_seq + "');");
								}
				    		}
				    		
							$("#resvSeq").val(resvSeq);
							$("#" + popup).bPopup();
						} else {
							fn_openPopup("error")
						}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
					}    		
				);	
			},
			fn_resvCancelCheck : function(resvSeq) {
				var resvInfo = fn_getResvInfo(resvSeq);
				
				if(resvInfo.isSuccess) {
					if(resvInfo.resv_pay_dvsn == "RESV_PAY_DVSN_1") {
						mainService.fn_resvCancel(resvInfo);
					} else {
						$("#pay_number").bPopup();
						$("#Card_Pw").val("");
						$("#pay_number a:eq(1)").click(function(resvSeq) {
							mainService.fn_payment(resvInfo);	
						});
					}
				}
			},
			fn_resvCancel : function(resvInfo, payResult) {
				var url = "/front/resvInfoCancel.do";
				
				var params = {
					"resvSeq" : resvInfo.resv_seq,
					"resvUserDvsn" : resvInfo.resv_user_dvsn,
					"resvCancelId" : resvInfo.user_id,
					"resvCancelCd" : "RESV_CANCEL_CD_2"
				}
				
				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
						if (result.status == "SUCCESS") {
							payResult != null ?
								fn_openPopup(
									"예약이 정상적으로 취소되었습니다." + "<br>" +
									"입금금액 : " + payResult.occurVal + "<br>" +
									"잔액 : " + payResult.balan, 
									"blue", "SUCCESS", "확인", "javascript:location.reload();"
								) :
								fn_openPopup("예약이 정상적으로 취소되었습니다.", "blue", "SUCCESS", "확인", "javascript:location.reload();");
						} else if (result.status == "LOGIN FAIL"){
							fn_openPopup(result.message, "blue", "SUCCESS", "확인", "javascript:location.reload();");
						}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
					}
				);	
			},
			fn_payment : function(resvInfo) {
				var url = "/backoffice/rsv/speedCheck.do";
				var params = {
					"gubun" : "dep",
					"sendInfo" : {
						"resvSeq" : resvInfo.resv_seq,
						"Card_Pw" : $("#Card_Pw").val(),
						"System_Type" : "E"
					}
				}
				
				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
				    	if(result.regist != null) {
							if(result.regist.Error_Msg == "SUCCESS") {
								mainService.fn_resvCancel(resvInfo, result.regist.result);
							} else {
								fn_openPopup(result.regist.Error_Msg, "red", "ERROR", "확인", "javascript:location.reload();");
							}
				    	} else {
				    		fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "");
				    	}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
					}    		
				);	
			}, 
			fn_reSeat : function(resvInfo) {
				var params = {
					"isReSeat" : "Y",
					"entryDvsn" : resvInfo.resv_entry_dvsn,
					"centerCd" : resvInfo.center_cd,
					"floorCd" : resvInfo.floor_cd,
					"partCd" : resvInfo.part_cd,
					"seatCd" : resvInfo.seat_cd,
					"userId" : resvInfo.user_id,
					"checkDvsn" : "ALL"
				}
				
				var result = mainService.fn_resvVaildCheck(params);
				
				if(result != ""){
					params.resvDate = result.resvDate;;
					$.each(result, function(index, item) {
						$("form[name=regist]").append($('<input/>', {type: 'hidden', name: index, value:item }));
						$("form[name=regist]").attr("action", "/front/rsvSeat.do").attr("method","get").submit();
					});
				}
			},
			fn_resvVaildCheck : function(params) {
				var url = "/front/resvValidCheck.do";
				var validResult;
				
				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
						if (result.status == "SUCCESS") {
							if(result.validResult.resultCode != "SUCCESS") {
								fn_openPopup(result.validResult.resultMessage, "red", "ERROR", "확인", "");
							} else {
								validResult = result.validResult;
							}
						} else if (result.status == "LOGIN FAIL"){
							fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/login.do'");
						}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
					}    		
				);	
				
				return validResult;
			},
			fn_moveQrPage : function(resvSeq) {
				location.href = "/front/qrEnter.do?resvSeq=" + resvSeq + "&accessType=WEB";
			}
		}
    </script>
	<c:import url="/front/inc/popup_common.do" />
    <script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>
</body>
</html>