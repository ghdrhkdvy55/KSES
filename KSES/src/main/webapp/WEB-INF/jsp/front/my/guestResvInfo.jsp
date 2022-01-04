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

    <!-- popup-->    
    <script src="/resources/js/front/bpopup.js"></script>
</head>

<body>
	<form:form name="regist" commandName="regist" method="post" action="/front/guestResvInfo.do">
	<input type="hidden" name="userDvsn" id="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" name="userId" id="userId" value="${sessionScope.userLoginInfo.userId}">
	
	<div class="wrapper rsvBack">
		<!--// header -->
        <div id="rsv_header">
            <ul class="rsv_info info_header">
                <li>빠르고 편리하게 입장신청 하세요.</li>
                <li class="leftImg"></li>
                <li class="backImg"></li>
            </ul>             
        </div>
        <!-- header //-->
        
        <!--// contents-->
        <div id="container" class="search">
            <div>
                <div class="contents" class="search"> 
                    <!--지점선택-->                 
                    <h4>예약 정보 조회</h4>
                    <ul class="rsvInfo">
                        <li><input id="resvUserNm" name="resvUserNm" type="text" placeholder="이름"></li>
                        <li><input id="resvUserClphn" name="resvUserClphn" type="text" onkeyup="onlyNum(this);" placeholder="휴대폰 번호('-'없이 숫자만 입력"></li>
                    </ul>

                    <div class="inquiry_btn">
                        <a href="javascript:guestResvService.fn_SmsCertifi();">인증번호 요청</a>
                    </div>
                    
                    <div class="ok_sumit">
                    	<ul>
                    		<li>인증번호</li>
                    		<li class="ok_input"><input type="text" id="resvCertifiCode" placeholder="인증번호를 입력하세요."></li>
                    		<li><a href="javascript:guestResvService.fn_checkform();">확인</a></li>
                    	</ul>
                    </div>
                </div>
            </div>
        </div>
        
        <!--contents //-->
		<div id="container" class="result" style="display:none;">
            <div>
                <div class="contents"> 
                    <!--지점선택-->                 
                    <h3>예약 정보 조회</h3>
                    <ul class="my_rsv rsvInfo_result">                        
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
                                <li>이름</li>
                                <li><span id="rsv_name"></span></li>
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
                                <li>신청일</li>
                                <li><span id="rsv_req_date"></span></li>
                            </ol>
                        </li>
                        
                        <!-- 비회원 입장 QR코드 -->
                        <li class="qrEnter_code">
                            <p>
    							<a href=" javascript:mainservice.fn_moveqrpage('100000000692');"=""><img src="/resources/img/front/qr_code.svg" alt="qr코드">
    						</p>
    						<P>입장 QR코드</p>
                        </li>
                        <!-- 비회원 입장 QR코드// -->
                        
                    </ul>
                    <ul class="non_memBtn">
                        <li class="cancelBtn"><a href="javascript:$('#cancel_rsv_info').bPopup();">예약취소</a></li>
                        <li class="close_btn"><a href="javascript:location.reload();">닫기</a></li>
                    </ul>
                </div>
            </div>
        </div>

		<div id="foot_btn">
				<div class="contents">
					<ul>
						<li class="home"><a href="javascript:fn_pageMove('regist','/front/main.do');">home</a><span>HOME</span></li>
						<li class="rsv"><a href="/front/rsvCenter.do">rsv</a><span>입장예약</span></li>
						<li class="my active"><a href="javascript:fn_pageMove('regist','/front/mypage.do');">my</a><span>마이페이지</span></li>
		            </ul>
				<div class="clear"></div>
			</div>
		</div>
	</div>
	</form:form>
	
	<c:import url="/front/inc/popup_common.do" />
	<script src="/resources/js/front/jquery-spinner.min.js"></script>
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>
	
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
                        	<li>좌석</li>
                        	<li><span id="cancel_rsv_seat"></span></li>
                    	</ol>
                	</li>
                	<li>
                    	<ol>
                        	<li>신청일</li>
                        	<li><span id="cancel_rsv_date"></span></li>
                    	</ol>
                	</li> 
               	</ul>
          	</div>
          	<div class="cancel_btn">
              	<a href="" id="resvCancleBtn" class="grayBtn">예약취소</a>
          	</div>
          	<div class="clear"></div>
      	</div>
	</div>

    <!--메뉴버튼 속성-->
    <script>
		var certifiYn = false;
		var certifiCode = "";
		var certifiNm = "";
		var certifiNum = "";
    
		var guestResvService = {
			fn_SmsCertifi : function() {
				certifiNm = $("#resvUserNm").val();
				certifiNum = $("#resvUserClphn").val();
					

				if(certifiNm == "") {
					fn_openPopup("이름을 입력해주세요.", "red", "ERROR", "확인", ""); return;
				} else if (certifiNum == "") {
					fn_openPopup("휴대폰번호를 입력해주세요.", "red", "ERROR", "확인", ""); return;
				} else if (!validPhNum(certifiNum)) {
					fn_openPopup("올바른 휴대폰번호를 입력해주세요.", "red", "ERROR", "확인", ""); return;
				}
						
				var url = "/front/resvCertifiSms.do";
				var params = {
					"certifiNm" : certifiNm,
					"certifiNum" : certifiNum
				}
					
				fn_Ajax
				(
					url,
					"POST",
					params,
					false,
					function(result) {
				    	if(result.status == "SUCCESS") {
				    		fn_openPopup("인증번호가 발송 되었습니다.(" +  result.certifiCode + ")", "blue", "SUCCESS", "확인", "");
							certifiCode = result.certifiCode;
				    	} else if(result.status == "LOGIN FAIL") {
				    		fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/main.do");
				    	} else {
				    		fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");
				    	}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
					}    		
				);
			},
			fn_checkform : function() {
				if (certifiCode == "") {
					fn_openPopup("인증번호를 요청해주세요", "red", "ERROR", "확인", "");
					return;
				} else if($("#resvCertifiCode").val() != certifiCode) {
					fn_openPopup("인증번호가 일치하지 않습니다.", "red", "ERROR", "확인", "");
					return;
				}
				
				var url = "/front/guestMyResvInfo.do";
				var params = {
					"resvUserNm" : certifiNm,
					"resvUserClphn" : certifiNum
				}

				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
						if(result.status == "SUCCESS") {
							if(result.guestResvInfo != null) {
								var guestResvInfo = result.guestResvInfo;
								
								$("#rsv_num, #cancel_rsv_num").html(guestResvInfo.resv_seq);
								$("#rsv_date, #cancel_rsv_date").html(fn_resvDateFormat(guestResvInfo.resv_end_dt));
								$("#rsv_name").html(guestResvInfo.resv_user_nm);
								$("#rsv_center, #cancel_rsv_center").html(guestResvInfo.center_nm);
								
								if(guestResvInfo.resv_entry_dvsn == "ENTRY_DVSN_1") {									
									$(".rsvInfo_result").children().eq(4).hide();
									$(".rsvInfo_result").children().eq(5).hide();
									$("#cancel_rsv_info ul > li:eq(3)").hide();
									$("#cancel_rsv_info ul > li:eq(4)").hide();
								} else {
									$(".rsvInfo_result").children().eq(4).show();
									$(".rsvInfo_result").children().eq(5).show();
									$("#cancel_rsv_info ul > li:eq(3)").show();
									$("#cancel_rsv_info ul > li:eq(4)").show();
									$("#rsv_floor, #cancel_rsv_floor").html(guestResvInfo.floor_nm);
									$("#rsv_part, #cancel_rsv_part").html(guestResvInfo.part_nm);										
								}
								
								$("#rsv_seat, #cancel_rsv_seat").html(guestResvInfo.seat_nm);
								$("#rsv_req_date, #cancel_rsv_req_date").html(guestResvInfo.resv_req_date);
								
								if(guestResvInfo.resv_state == "RESV_STATE_1" && guestResvInfo.resv_ticket_dvsn != "RESV_TICKET_DVSN_2") {
									$(".non_memBtn .cancelBtn").show();
									$("#resvCancleBtn").attr("href","javascript:guestResvService.fn_resvCancel('" + guestResvInfo.resv_seq + "');");
								} else {
									$(".non_memBtn .cancelBtn").hide();
								}
								
								$(".search").hide();
								$(".result").show();
							} else {
								fn_openPopup("해당 정보로 예약된 정보가 존재하지 않습니다.", "red", "ERROR", "확인", "");
							}
						} 
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
					}    		
				);
			},
			fn_resvCancel : function(resvSeq) {
				var resvInfo = fn_getResvInfo(resvSeq);
				
				if(resvInfo.isSuccess) {
					var url = "/front/resvInfoCancel.do";
					
					resvInfo.resv_cancel_id = resvInfo.user_id;
					resvInfo.resv_cancel_cd = "RESV_CANCEL_CD_2";
					
					fn_Ajax
					(
					    url,
					    "POST",
					    resvInfo,
						false,
						function(result) {
							if (result.status == "SUCCESS") {
								fn_openPopup("예약이 정상적으로 취소되었습니다.", "blue", "SUCCESS", "확인", "/front/main.do");
							} else {
								fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");
							}
						},
						function(request) {
							fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
						}    		
					);
				}
			}
		}
    </script>
</body>  
</html>