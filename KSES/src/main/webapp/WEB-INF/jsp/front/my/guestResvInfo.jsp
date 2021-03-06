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
                        <li><input id="resvUserNm" name="resvUserNm" type="text" placeholder="이름" autocomplete="off"></li>
                        <li><input id="resvUserClphn" name="resvUserClphn" type="number" onkeyup="onlyNum(this);" placeholder="휴대폰 번호('-'없이 숫자만 입력" autocomplete="off"></li>
                    </ul>

                    <div class="inquiry_btn">
                        <a href="javascript:guestResvService.fn_getGuestResvInfo(false);">인증번호 요청</a>
                    </div>
                    
                    <div class="ok_sumit">
                    	<ul>
                    		<li></li>
                    		<li class="ok_input"><input type="number" id="resvCertifiCode" placeholder="인증번호를 입력하세요." autocomplete="off"></li>
                    		<li><a href="javascript:guestResvService.fn_checkform();">확인</a></li>
                    	</ul>
                    </div>
                </div>
            </div>
        </div>
        
        <!--contents //-->
		<div id="container" class="result" style="display:none;">
            <div>
                <div class="contents resv_contents"> 
                    <!--지점선택-->                 
                    <h3>예약 정보 조회</h3>

                </div>
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
                        	<li><span id="cancel_rsv_req_date"></span></li>
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
	
	<!-- // 현금영수증 팝업 -->
	<div id="cash_receipt" class="popup">
	  <div class="pop_con">
	      <a class="button b-close">X</a>
	      
	      <div class="pop_wrap">                                                
	            <h4>현금영수증 발급 신청</h4>
	            <ul class="cash_refund">
	                <li>
	                    <input type="radio" name="refund" id="refund1" value="RESV_RCPT_DVSN_1">
	                    <label for="refund1"><span></span>소득 공제용</label>
	                </li>
	                <li>
	                    <input type="radio" name="refund" id="refund2" value="RESV_RCPT_DVSN_2">
	                    <label for="refund2"><span></span>지출 증빙용</label>
	                </li>
	                <li><input type="text" onkeyup="onlyNum(this);" placeholder="'-'없이 입력해 주세요."></li>
	            </ul>                      
	        </div>
	        <div class="summit_btn">
	            <a href="" class="mintBtn">신청</a>
	            <a href="javascript:bPopupClose('cash_receipt');">취소</a>
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
		
		var setIntervalId = "";
		var reCertifiTime = 180;
		var reCertifiEndTime = 0;
		var reCertifiYn = true;
		
		var resvInfoList = new Object();
    
		var guestResvService = {
			fn_getGuestResvInfo : function(isRefresh) {
				if($("#resvUserNm").val() == "") {
					fn_openPopup("이름을 입력해주세요.", "red", "ERROR", "확인", ""); return;
				} else if ($("#resvUserClphn").val() == "") {
					fn_openPopup("휴대폰번호를 입력해주세요.", "red", "ERROR", "확인", ""); return;
				} else if (!validPhNum($("#resvUserClphn").val())) {
					fn_openPopup("올바른 휴대폰번호를 입력해주세요.", "red", "ERROR", "확인", ""); return;
				} else if (!reCertifiYn) {
					fn_openPopup("이미 인증번호가 발송되었습니다.<br>" + reCertfiEndTime + "초 후 다시 시도해주세요.", "red", "ERROR", "확인", ""); return;
				}
				
				var url = "/front/guestMyResvInfo.do";
				var params = {
					"resvUserNm" : $("#resvUserNm").val(),
					"resvUserClphn" : $("#resvUserClphn").val()
				}

				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
						if(result.status == "SUCCESS") {
							if(result.guestResvInfo.length > 0) {
								resvInfoList = result.guestResvInfo;
								if(isRefresh) {
									$(".resv_contents > .my_rsv, .non_memBtn").remove();
									guestResvService.fn_checkform(resvInfoList);
								} else {
									guestResvService.fn_SmsCertifi();
								}
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
			fn_SmsCertifi : function() {
				var url = "/front/resvCertifiSms.do";
				var params = {
					"certifiNm" : $("#resvUserNm").val(),
					"certifiNum" : $("#resvUserClphn").val()
				}
					
				fn_Ajax
				(
					url,
					"POST",
					params,
					false,
					function(result) {
				    	if(result.status == "SUCCESS") {
				    		// 인증요청 3분 인터벌 적용
				    		reCertifiYn = false;
				    		reCertfiEndTime = reCertifiTime;
							setIntervalId = setInterval(function () {
								if (reCertfiEndTime == 0) {
									reCertifiYn = true;
									clearInterval(setIntervalId);
								} else {
									reCertfiEndTime --;	
								}
							},1000);
				    		
				    		fn_openPopup("인증번호가 발송 되었습니다.", "blue", "SUCCESS", "확인", "");
				    		
							certifiNm = $("#resvUserNm").val();
							certifiNum = $("#resvUserClphn").val();
							certifiCode = result.certifiCode;
							
							$(".rsvInfo").hide();
							$(".inquiry_btn a").attr("href","javascript:guestResvService.fn_reSmsCertifi();").html("인증번호 재요청");
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
			fn_reSmsCertifi : function() {
				$(".rsvInfo").show();
				$(".rsvInfo input").val("");
				$(".inquiry_btn a").attr("href","javascript:guestResvService.fn_getGuestResvInfo();").html("인증번호 요청");
				
				certifiCode = "";
				certifiNm = "";
				certifiNum = "";
				certifiYn = false;
			},
			fn_checkform : function() {
				if (certifiCode == "") {
					fn_openPopup("인증번호를 요청해주세요", "red", "ERROR", "확인", "");
					return;
				} else if($("#resvCertifiCode").val() != certifiCode) {
					fn_openPopup("인증번호가 일치하지 않습니다.", "red", "ERROR", "확인", "");
					return;
				}

				$.each(resvInfoList, function(index, resvInfo) {
					let $resvInfoUl = $('<ul class="my_rsv"><ul>').attr('id', resvInfo.resv_seq);
					
					$.each(resvInfo, function(index, item) {
						let name = '';
						
						switch(index) {
							case 'resv_seq' 	 : name = '예약번호';	item = fn_resvSeqFormat(item);  break;
							case 'resv_end_dt' 	 : name = '경주일'; 	item = fn_resvDateFormat(item); break;
							case 'resv_user_nm'  : name = '이름'; 	break;
							case 'center_nm' 	 : name = '지점'; 	break;
							case 'floor_nm' 	 : name = '층';	 	break;
							case 'part_nm' 		 : name = '구역'; 	break;
							case 'seat_nm' 		 : name = '좌석'; 	break;
							case 'resv_req_date' : name = '신청일'; 	break;
						}
						
						if(name != '') {
							if(!(resvInfo.resv_entry_dvsn == "ENTRY_DVSN_1" && (index == 'floor_nm' || index == 'part_nm'))) {
								let $li = $('<li></li>').append('<ol><li>' + name + '</li>' + '<li class="' + index +'">' + item + '</li></ol>');
								
								if(index == 'resv_seq') {
									$li.find('li').eq(1).addClass('rsv_num');	
								}
								$resvInfoUl.append($li);	
							}
						}
					});
					
 					//if((resvInfo.resv_state == "RESV_STATE_1" ||  resvInfo.resv_state == "RESV_STATE_2") && resvInfo.center_pilot_yn == "N") {
 						$resvInfoUl.append('<li class="qrEnter_code"><p><a href="javascript:void(0);"><img src="/resources/img/front/qr_code.svg" alt="qr코드"></a></p><p>입장 QR코드</p></li>');
 						$resvInfoUl.find(".qrEnter_code a").attr("href","javascript:fn_moveQrPage('" + resvInfo.resv_seq +"');");
					//} 
					
 					let $btnUl = $('<ul class="non_memBtn"></ul>'); 
 					if(resvInfo.resv_state == "RESV_STATE_1" && resvInfo.resv_ticket_dvsn != "RESV_TICKET_DVSN_2") {
 						let $cancelBtnLi = $('<li class="cancelBtn"></li>');
 						let $cancelBtnA = $('<a href="javascript:void(0);">예약취소</a>').click(function () {
 							guestResvService.fn_resvCancelPop(resvInfo.resv_seq);
						}).appendTo($cancelBtnLi);
 						
 						$btnUl.append($cancelBtnLi);
					}
 					
 					if(resvInfo.resv_pay_dvsn == "RESV_PAY_DVSN_2") {
 						$btnUl.append("<li class='close_btn'><a href='javascript:guestResvService.fn_openRcptPopup(\"" + resvInfo.resv_seq +"\",\"" +  resvInfo.resv_rcpt_yn +"\")'>현금 영수증</a></li>");
 					}
 					
					$(".resv_contents").append($resvInfoUl);
					$(".resv_contents").append($btnUl);
				});
				
				$(".search").hide();
				$(".result").show();
			},
			fn_openRcptPopup : function(resvSeq,resvRcptYn) {
				if(resvRcptYn != "N") {
					fn_openPopup("이미 현금영수증 신청 완료된 <br>예약정보 입니다.", "red", "ERROR", "확인", "");
					return;
				}
				
				$("input:radio[name='refund']").eq(0).prop("checked", true);
				$("#cash_receipt .summit_btn a").eq(0).attr("href","javascript:guestResvService.fn_setRcptInfo('" + resvSeq + "');");
				$("#cash_receipt input[type='text']").val("");
				bPopupOpen('cash_receipt');
			},
			fn_setRcptInfo : function(resvSeq) {
				if($("#cash_receipt input[type='text']").val() == "") {
					fn_openPopup("현금영수증 발행번호를 입력해주세요", "red", "ERROR", "확인", "");
					return;
				}
				
				var url = "/front/updateResvRcptInfo.do";
				var params = {
					"resvSeq" : resvSeq,
					"resvRcptTel" : $("#cash_receipt input[type='text']").val(),
					"resvRcptDvsn" : $("input[name='refund']:checked").val()
				}
				
				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
						if(result.status == "SUCCESS") {
							bPopupClose("cash_receipt");
							fn_openPopup("현금영수증 신청이 정상적으로 이뤄졌습니다.", "blue", "SUCCESS", "확인", "");
							guestResvService.fn_getGuestResvInfo(true);
						} else if(result.status == "LOGIN FAIL") {
							fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/main.do");	
						} else {
							fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "/front/main.do");
						}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "/front/main.do");	       						
					}    		
				);
			},
			fn_resvCancelPop : function(resvSeq) {
				$('#cancel_rsv_num').html($('#' + resvSeq + ' .resv_seq').html());
				$('#cancel_rsv_date').html($('#' + resvSeq + ' .resv_end_dt').html());
				$('#cancel_rsv_center').html($('#' + resvSeq + ' .center_nm').html());
				$('#cancel_rsv_seat').html($('#' + resvSeq + ' .seat_nm').html());
				$('#cancel_rsv_req_date').html($('#' + resvSeq + ' .resv_req_date').html());
				
				$("#resvCancleBtn").attr("href","javascript:guestResvService.fn_resvCancel('" + resvSeq + "');");
				$('#cancel_rsv_info').bPopup();
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
			},
		}
    </script>
</body>  
</html>