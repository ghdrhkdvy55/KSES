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
	<input type="hidden" name="userDvsn" id="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" name="userId" id="userId" value="${sessionScope.userLoginInfo.userId}">
	<input type="hidden" id="accessType" name="accessType" value="${accessType}">
	<input type="hidden" id="resvSeq" name="resvSeq" value="${resvSeq}">
    
    <div class="wrapper rsvBack">
        <!--// contents-->
        <div id="container" style="padding: 7rem 0;">
            <div>
                <div class="contents qrEnter"> 
                    <!--qr코드-->
                    <!-- 결제 완료 시 qr표출 -->
                    <div id="qr_enter_code" class="qr_enter_code">
						<div id="mask_qr">
							<div class="info_img">
								<a href="javascript:qrService.fn_createQrCode();"><img src="/resources/img/front/refresh.svg" alt="재발급"> <br>재발급</a>
							</div>        
						</div>
                    </div>

                    <div class="qr_info" style="display:none;">
                        <ul>
                            <li class="timer">남은시간<span id="timeStamp">00:00</span></li>
                            <!--//접종완료-->
                            <!--접종완료//-->
                            <!--//백신패스 만료-->
                            <!-- <li class="vacState"><span class="vacNon"><img alt="" src="/resources/img/front/error_outline_black_24dp.svg">백신패스 만료</span></li> -->
                            <li class="vacState"><span class="vacNon">백신패스 만료</span></li>
                            <!--백신패스 만료//-->
                            <li class="qr_tit">스마트입장시스템 QR코드</li>
                            <li>
                                <p> QR코드 유출(양도)로 인한 책임은 본인에게 있으며, <br>  해당 QR코드는 인식 시 즉시 폐기됩니다. <br>    타인에게 양도시 본인의 출입이 금지될 수 있습니다.
                                </p>
                            </li>
                        </ul>
                    </div>
					<!-- //결제 완료 시 qr표출 -->
					<!-- 미 결제 시 표출 -->
					<div class="pay_noti" style="display:none;">
						<p><img src="/resources/img/front/credit_score_black_24dp.svg" alt="결제하기"></p>
						<p>스마트 입장을 위한 <br>결제를 진행 해주세요.</p>
					</div>
                    <!--// 미 결제 시 표출 -->
                    <div class="pay_btn">
                        <ul>
                            <li class="mintBtn"><a href="javascript:qrService.fn_payment();">결제</a></li>
                            <li class="grayBtn"><a href="javascript:history.back();">닫기</a></li>
                        </ul>  
                    </div>
                </div>
            </div>
        </div>
        <!--contents //-->
    </div>
	
	<c:import url="/front/inc/popup_common.do" />
	<script src="/resources/js/front/jquery-spinner.min.js"></script>
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>

    <!--메뉴버튼 속성-->
    <script>
    	var qrTime = 30;
    	var qrEndTime;
    	var setIntervalId;
    	var qrAutoRefresh = true;
    	var isFirst = true;
    
		$(document).ready(function() {
			qrService.fn_createQrCode();
		});
		
		var qrService = {
			fn_createQrCode : function() {
				var url = "/backoffice/rsv/qrSend.do";
				var params = {
					"resvSeq" : $("#resvSeq").val(),
					"tickPlace" : "ONLINE"
				}
				
				fn_Ajax
				(
				    url,
				    "GET",
					params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS") {
				    		var qrCode = result.QRCODE;
				    		var resvInfo = result.resvInfo;
				    		var vacntnInfo = result.vacntnInfo;
				    		
				    		if(isFirst) {
				    			isFirst = false;
				    		} else {
				    			$("#qr_enter_code img").last().remove();
				    			$("#qr_enter_code canvas").remove();
				    		}
				    		
							$(".vacState span").removeClass()
				    		switch (vacntnInfo.pass_yn) {
								case "Y" : $(".vacState span").addClass("vacDone").html("접종 완료"); $("#qr_enter_code").css("border-color","#1ba100"); break;
								case "N" : $(".vacState span").addClass("vacNon").html("백신패스 만료"); $("#qr_enter_code").css("border-color","#f72626"); break;  
								default: $(".vacState span").addClass("vacNon").html("접종정보 없음"); $("#qr_enter_code").css("border-color","#cfcfcf"); break;
							}				    			
				    		
							
				    		if(resvInfo.resv_pay_dvsn == "RESV_PAY_DVSN_2" || resvInfo.center_pilot_yn == "N") {
				    			$(".pay_btn li:eq(0)").hide();
								$(".qr_enter_code").show();
								$(".qr_info").show();
								$(".pay_noti").hide();
								

								var qrcode = new QRCode("qr_enter_code", {
								    text: qrCode,
								    width: 200,
								    height: 200,
								    colorDark : "#000000",
								    colorLight : "#ffffff",
								    correctLevel : QRCode.CorrectLevel.M
								});
								
								$("#qr_enter_code > img").css("margin", "auto");
								qrService.fn_qrTimer();
				    		} else {
				    			$(".classCost").html(resvInfo.resv_pay_cost);
				    			$(".pay_btn li:eq(0)").show();
								$(".qr_enter_code").hide();
								$(".qr_info").hide();
								var payHtml = resvInfo.resv_user_dvsn == "USER_DVSN_1" ? "스마트 입장을 위한 <br>결제를 진행 해주세요." : "무인발권기를 통한 결제를 진행 해주세요. <br>결제가 완료되면 QR이 생성됩니다.";
								var userCheck = resvInfo.resv_user_dvsn == "USER_DVSN_1" ? $(".pay_btn li:eq(0)").show() : $(".pay_btn li:eq(0)").hide();
								$(".pay_noti p:eq(1)").html(payHtml);
								$(".pay_noti").show();
				    		}
				    		$("#accessType").val() == "BUTTON" ? $(".pay_btn li:eq(1)").hide() : $(".pay_btn li:eq(1)").show();
						} else {
							fn_openPopup(result.message, "red", "ERROR", "확인", "/front/main.do");
						}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
					}    		
				);	
			},
			fn_qrTimer : function() {
				$("#timeStamp").css("color", "#0094DB");
				$("#mask_qr").hide();
				
				clearInterval(setIntervalId);
				qrEndTime = qrTime;
				setIntervalId = setInterval(function () {
					if (qrEndTime == 0) {
						if(qrAutoRefresh) {
							qrService.fn_createQrCode();
							qrAutoRefresh = false;
						} else {
							$("#timeStamp").css("color","red");
							$("#mask_qr").show();
						}
					} else {
						qrEndTime --;
						$("#timeStamp").html("0" + parseInt(qrEndTime/60) + ":" +(((qrEndTime%60)>9)?(qrEndTime%60):"0"+(qrEndTime%60)));	
					}
				},1000);
			},
			fn_payment : function(division) {
				var url = "/backoffice/rsv/speedCheck.do";
				var params = {
					"gubun" : "fep",
					"sendInfo" : {
						"resvSeq" : $("#resvSeq").val()
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
								var payResult = result.regist.result;
								fn_openPopup(
									"결제가 완료되었습니다." + "<br>" +
									"출금금액 : " + fn_cashFormat(payResult.occurVal) + "<br>" +
									"잔액 : " + fn_cashFormat(payResult.balan), 
									"blue", "SUCCESS", "확인", "javascript:location.reload();"
								);
							} else {
								fn_openPopup(result.regist.Error_Msg, "red", "ERROR", "확인", "javascript:location.reload();");
							}
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
    </script>
</body>  
</html>