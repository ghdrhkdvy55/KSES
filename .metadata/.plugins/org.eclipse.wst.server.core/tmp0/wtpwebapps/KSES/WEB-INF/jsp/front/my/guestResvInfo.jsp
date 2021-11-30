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
	<input type="hidden" id="userDvsn" name="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	
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
                        <li><input id="resvUserClphn" name="resvUserClphn" type="text" placeholder="휴대폰 번호('-'없이 숫자만 입력"></li>
                    </ul>

                    <div class="inquiry_btn">
                        <a href="javascript:guestResvService.fn_checkform();">조회하기</a>
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
                                <li><span id="rsv_num" class="rsv_num">123458960</span></li>
                            </ol>
                        </li>
                        <li>
                            <ol>
                                <li>이름</li>
                                <li><span id="rsv_name" class="rsv_name">홍길동</span></li>
                            </ol>
                        </li>
                        <li>
                            <ol>
                                <li>지점</li>
                                <li><span id="rsv_brch" class="rsv_brch">대전지점</span></li>
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
                    <div class="close_btn">
                        <a href="javascript:location.reload();">닫기</a>
                    </div>
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
	<script src="/resources/js/front/jquery-spinner.min.js"></script>
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>

    <!--메뉴버튼 속성-->
    <script>
		var guestResvService = {
			fn_checkform : function() {  
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
				    	console.log(result);
						if(result.status == "SUCCESS") {
							if(result.guestResvInfo != null) {
								var guestResvInfo = result.guestResvInfo;
								
								console.log(guestResvInfo);
								
								$("#rsv_num").html(guestResvInfo.resv_seq);
								$("#rsv_name").html(guestResvInfo.resv_user_nm);
								$("#rsv_brch").html(guestResvInfo.resv_center_nm);
								$("#rsv_seat").html(guestResvInfo.resv_seat_nm);
								$("#rsv_date").html(guestResvInfo.resv_req_date);
								   
								$(".search").hide();
								$(".result").show();
							} else {
								alert("해당 정보로 예약된 정보가 존재하지 않습니다.")
							}
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