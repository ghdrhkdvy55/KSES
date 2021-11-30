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
                    <div id="qr_code" class="qr_code">
                        
                    </div>

                    <div class="qr_info">
                        <ul>
                            <li class="timer">남은시간<span id="timeStamp">02:00</span></li>
                            <li class="qr_tit">입장을 위한 QR코드</li>
                            <li>
                                <p> QR코드 유출(양도)로 인한 책임은 본인에게 있으며, <br>  해당 QR코드는 인식 시 즉시 폐기됩니다. <br>    타인에게 양도시 본인의 출입이 금지될 수 있습니다.
                                </p>
                            </li>
                        </ul>
                    </div>

                    <div class="pay_btn">
                        <ul>
                            <!-- <li class="mintBtn"><a href="">결제</a></li> -->
                            <li class="grayBtn"><a href="javascript:history.back();">닫기</a></li>
                        </ul>  
                    </div>
                </div>
            </div>
        </div>
        <!--contents //-->
    </div>  

	<script src="/resources/js/front/jquery-spinner.min.js"></script>
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>

    <!--메뉴버튼 속성-->
    <script>
    	var qrTime = 120;
    
		$(document).ready(function() {
			qrService.createQrCode();
		});
		
		var qrService = {
			createQrCode : function() {
				var url = "/front/resvQrInfo.do";
				var params = {"resvSeq" : $("#resvSeq").val()}
				
				fn_Ajax
				(
				    url,
				    "GET",
					params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS") {
				    		$("#qr_code").empty();
				    		
				    		console.log(JSON.stringify(result.resvQrInfo));
				    		
							var qrcode = new QRCode("qr_code", {
							    text: JSON.stringify(result.resvQrInfo),
							    width: 256,
							    height: 256,
							    colorDark : "#000000",
							    colorLight : "#ffffff",
							    correctLevel : QRCode.CorrectLevel.H
							});
							
							$("#qr_code > img").css({"margin":"auto"});
							
							qrTime = 120;
							setInterval(function () {
								if (qrTime == 0) {
/* 									$("qrImageDiv").style.display="none";
									$("reloadGuide").style.display="block"; */
									return;
								} else {
									qrTime --;
									console.log(qrTime);
									$("#timeStamp").html("0" + parseInt(qrTime/60) + ":" +(((qrTime%60)>9)?(qrTime%60):"0"+(qrTime%60)));	
								}
							},1000);
							
						} else {
							alert("QR코드 생성에 실패하였습니다.");
						}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);	
			}
		}
    </script>
</body>  
</html>