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
	<input type="hidden" id="userDvsn" name="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" id="resvSeq" name="resvSeq" value="${resvSeq}">
    
    <div class="wrapper rsvBack">
        <!--// contents-->
        <div id="container">
            <div>
                <div class="contents qrEnter"> 
                    <!--qr코드-->
                    <div id="qr_enter_code" class="qr_enter_code">
						<div id="mask_qr">
							<div class="info_img">
								<a href="javascript:qrService.fn_createQrCode();"><img src="/resources/img/front/refresh.svg" alt=""> <br>재발급</a>
							</div>        
						</div>
                    </div>

                    <div class="qr_info">
                        <ul>
                            <li class="timer">남은시간<span id="timeStamp">00:00</span></li>
                            <li class="qr_tit">입장을 위한 QR코드</li>
                            <li>
                                <p> QR코드 유출(양도)로 인한 책임은 본인에게 있으며, <br>  해당 QR코드는 인식 시 즉시 폐기됩니다. <br>    타인에게 양도시 본인의 출입이 금지될 수 있습니다.
                                </p>
                            </li>
                        </ul>
                    </div>

                    <div class="pay_btn">
                        <ul>
                            <li class="mintBtn"><a data-popup-open="pay_number">결제</a></li>
                            <li class="grayBtn"><a href="javascript:history.back();">닫기</a></li>
                        </ul>  
                    </div>
                </div>
            </div>
        </div>
        <!--contents //-->
    </div>  

	<!-- // 결제인증 팝업 -->
    <div data-popup="pay_number" class="popup">
		<div class="pop_con rsv_popup">
			<a class="button b-close">X</a>
          	<div class="pop_wrap">
            	<h4>결제 비밀번호를 입력해주세요.</h4>
            	<ul class="pay_passWord">
                	<li><input type="password" placeholder="비밀번호를 입력하세요."></li>
                	<li><a href="" class="mintBtn">확인</a></li>
            	</ul>
          	</div>
      	</div>
    </div>
    <!-- 결제인증 팝업 // -->

	<script src="/resources/js/front/jquery-spinner.min.js"></script>
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>

    <!--메뉴버튼 속성-->
    <script>
    	var qrTime = 30;
    	var isFirst = true;
    
		$(document).ready(function() {
			qrService.fn_createQrCode();
		});
		
		var qrService = {
			fn_createQrCode : function() {
				var url = "/backoffice/rsv/qrSend.do";
				var params = {"resvSeq" : $("#resvSeq").val(),
								"tickPlace" : "ONLINE"}
				
				fn_Ajax
				(
				    url,
				    "GET",
					params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS") {
				    		if(isFirst){
				    			isFirst = false;
				    		} else {
				    			$("#qr_enter_code img").last().remove();
				    			$("#qr_enter_code canvas").remove();
				    		}
				    		
							var qrcode = new QRCode("qr_enter_code", {
							    text: result.QRCODE,
							    width: 256,
							    height: 256,
							    colorDark : "#000000",
							    colorLight : "#ffffff",
							    correctLevel : QRCode.CorrectLevel.M
							});
							
							$("#qr_enter_code > img").css("margin", "auto");
							qrService.fn_qrTimer();
						} else {
							alert("QR코드 생성에 실패하였습니다.");
						}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);	
			},
			fn_qrTimer : function() {
				$("#timeStamp").css("color", "#0094DB");
				$("#mask_qr").hide();
				var qrEndTime = qrTime;
				setInterval(function () {
					if (qrEndTime == 0) {
						$("#timeStamp").css("color","red");
						$("#mask_qr").show();
						return;
					} else {
						qrEndTime --;
						console.log(qrEndTime);
						$("#timeStamp").html("0" + parseInt(qrEndTime/60) + ":" +(((qrEndTime%60)>9)?(qrEndTime%60):"0"+(qrEndTime%60)));	
					}
				},1000);
			},
			fn_payment : function() {
				var url = "/backoffice/rsv/speedCheck.do";
				var params = {
					"gubun" : "fep",
					"sendInfo" : {
						"resvSeq" : $("#resvSeq").val(),
						"Login_Type" : $("#login_type").val(),
						"User_Id" : $("#id").val(),
						"User_Pw" : $("#pw").val(),
						"Card_Id" : $("#cardNo").val(),
						"Card_Pw" : $("#cardPw").val(),
						"System_Type" : "E"
					}
				}
			}
		}
    </script>
</body>  
</html>