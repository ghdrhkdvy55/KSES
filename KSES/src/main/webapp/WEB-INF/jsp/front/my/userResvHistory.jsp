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
	
	<link href="/resources/css/front/jquery-ui.css" rel="stylesheet" />
	<link href="/resources/css/front/smart.css" rel="stylesheet" />
	<script src="/resources/js/front/jquery-ui.js"></script>
    <!--check box _ css-->
    <link href="/resources/css/front/magic-check.min.css" rel="stylesheet" />
    
    <title>경륜경정 스마트 입장예약</title>

	<!-- qrcode -->
	<script src="/resources/js/front/qrcode.js"></script>

    <!-- popup-->    
    <script src="/resources/js/front/bpopup.js"></script>
</head>

<body>
	<form:form name="regist" commandName="regist" method="post" action="/front/userResvHistory.do">
	<input type="hidden" id="userDvsn" name="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" id="userId" name="userId" value="${sessionScope.userLoginInfo.userId}">
	<input type="hidden" id="userNm" name="userNm" value="${sessionScope.userLoginInfo.userNm}">
	
    <div class="wrapper">
        <!--// header -->
        <div class="my_wrap">
            <div class="contents my_box rsv_history">
                <div class="navi_left">
                    <a href="javascript:history.back();" class="before_close"></a>
                </div>
                <h1>나의 입장예약 내역</h1>
            </div>           
        </div>
        <!-- header //-->
        <!--// contents-->
        <div id="container">
            <!-- // 공지사항 -->
            <div class="contents cotents_wrap history_list">
                <!-- 공지사항 데이터 -->
                <div>
                    <div id="date_search" class="date_srch"> 
                    	<h4>조회기간 선택</h4>
						<div class="detail_srch">
                            <ul>
                                <li>
                                    <select id="searchDayCondition" class="select_box_srch">
                                        <option value="RESV_REQ_DATE">예약일</option>
                                        <option value="RESV_START_DT">경주일</option>
                                    </select>
                                </li>
                                
                                <li><input type="text" id="searchDayFrom" class="cal_icon" name="date_from" autocomplete=off><span>~</span></li> 
                                <li><input type="text" id="searchDayTo" class="cal_icon" name="date_to" autocomplete=off></li>
                                
                                <li><a href="javascript:userResvService.fn_userResvInfo(true);" class="srchBtn">검색</a></li>
                            </ul>
                        </div> 
                    </div>         
					<div class="srch_opt">
                        <ul>
                            <li>
                                <input class="cash_radio" type="radio" checked name="searchStateCondition" id="ALL" value="ALL" onclick="userResvService.fn_userResvInfo();">
                                <label for="ALL"><span></span>전체</label>
                            </li>
                            <li>
                                <input class="cash_radio" type="radio" name="searchStateCondition" id="RESV" value="RESV" onclick="userResvService.fn_userResvInfo();">
                                <label for="RESV"><span></span>예약</label>
                            </li>
                            <li>
                                <input class="cash_radio" type="radio" name="searchStateCondition" id="CANCEL" value="CANCEL" onclick="userResvService.fn_userResvInfo();">
                                <label for="CANCEL"><span></span>취소</label>
                            </li>
                        </ul>    
                    </div>   
                    <div id="my_rsv_stat" class="my_rsv_stat">
                        <ul class="my_rsv">
                                                                                                           
                        </ul>

                        <ul class="rsv_stat_btn">

                        </ul>
                    </div>
                </div>
                <div id="my_rsv_stat_list">
                    <div class="notice_con list_con">

                    </div>
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
        <!--contents //-->
    </div>
    
	<!-- // 결제인증 팝업 -->
    <div id="pay_number" data-popup="pay_number" class="popup">
		<div class="pop_con rsv_popup">
			<a class="button b-close">X</a>
          	<div class="pop_wrap">
            	<h4>결제 비밀번호를 입력해주세요.</h4>
            	<ul class="pay_passWord">
                	<li><input type="password" id="Card_Pw" placeholder="비밀번호를 입력하세요."></li>
                	<li><a href="javascript:qrService.fn_payment();" class="mintBtn">확인</a></li>
            	</ul>
          	</div>
      	</div>
    </div>
    <!-- 결제인증 팝업 // -->
      
	</form:form>
	
	<c:import url="/front/inc/popup_common.do" />
	<script src="/resources/js/front/jquery-spinner.min.js"></script>
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>

    <!--메뉴버튼 속성-->
    <script>
 		$(document).ready(function() { 
	 		var clareCalendar = {
	 			monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	 			dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
	 			weekHeader: 'Wk',
	 			dateFormat: 'yymmdd', //형식(20120303)
	 			autoSize: false, //오토리사이즈(body등 상위태그의 설정에 따른다)
	 			changeMonth: true, //월변경가능
	 			changeYear: true, //년변경가능
	 			showMonthAfterYear: true, //년 뒤에 월 표시
	 			buttonImageOnly: true, //이미지표시
	 			buttonText: '달력선택', //버튼 텍스트 표시
	 			buttonImage: '/images/invisible_image.png', //이미지주소
	 			yearRange: '1970:2030', //1990년부터 2020년까지
	 			currentText: "Today"
	 		};	       

	 		$("#searchDayFrom, #searchDayTo").datepicker(clareCalendar);
	 		var today = new Date();
	 		$("#searchDayFrom").val(today.format("yyyyMMdd"));
	 		
	 		
	 		var day7 = new Date(today.getTime() + 604800000);
	 		$("#searchDayTo").val(day7.format("yyyyMMdd"));	 		
 			
 			userResvService.fn_userResvInfo();
		});

		var userResvService = {
			fn_userResvInfo : function(isSearch) {
				if(isSearch){
					$("input[name='searchStateCondition']:checked").val()
				}
				
				/* alert($("input[name='searchStateCondition']:checked").val()); */
				
				var url = "/front/userMyResvInfo.do";
				var params = {
					"userId" : $("#userId").val(),
					"searchDayCondition" : $("#searchDayCondition").val(),
					"searchDayFrom" : $("#searchDayFrom").val(),
					"searchDayTo" : $("#searchDayTo").val(),
					"searchStateCondition" : $("input[name='searchStateCondition']:checked").val()
				}

				fn_Ajax
				(
				    url,
				    "POST",
					params,
					false,
					function(result) {
						if(result.status == "SUCCESS") {
							if(result.userResvInfo != null) {
								var userResvInfo = result.userResvInfo;
								$("#my_rsv_stat").empty();
								$("#my_rsv_stat_list").empty();
								
								$.each(userResvInfo, function(index, item) {
									if(item.resv_state == "RESV_STATE_1" || item.resv_state == "RESV_STATE_2") {
										var setHtml = "";
					                	setHtml += "<ul class='my_rsv'>";
					                    setHtml += "    <li>";
					                    setHtml += "        <ol>";
					                    setHtml += "            <li>예약번호</li>";
					                    setHtml += "            <li><span id='rsv_num' class='rsv_num'>" + item.resv_seq +"</span></li>";
					                    setHtml += "        </ol>";
					                    setHtml += "    </li>";
					                    setHtml += "    <li>";
					                    setHtml += "        <ol>";
					                    setHtml += "            <li>지점</li>";
					                    setHtml += "            <li><span id='rsv_brch' class='rsv_brch'>" + item.center_nm +"</span></li>";
					                    setHtml += "        </ol>";
					                    setHtml += "    </li>";
					                    setHtml += "    <li>";
					                    setHtml += "        <ol>";
					                    setHtml += "           <li>좌석</li>";
					                    setHtml += "           <li><span id='rsv_seat' class='rsv_seat'>" + item.seat_nm + "</span></li>";
					                    setHtml += "        </ol>";
					                    setHtml += "    </li>";
					                    setHtml += "    <li>";
					                    setHtml += "        <ol>";
					                    setHtml += "            <li>일시</li>";
					                    setHtml += "            <li><span id='rsv_date' class='rsv_date'>" + item.resv_req_date + "</span></li>";
					                    setHtml += "        </ol>";
					                    setHtml += "    </li>";                                                                                    
				                        setHtml += "</ul>";
				                        
				                        setHtml += "<ul class='rsv_stat_btn'>";
				                        if(item.resv_state == "RESV_STATE_1") {
			                            	setHtml += "<li><a href='javascript:userResvService.fn_resvCancelDvsn(&#39;" + item.resv_seq +"&#39;,&#39;" + item.resv_pay_dvsn +"&#39;)'>예약 취소</a></li>";
				                        }
			                            setHtml += "</ul>";
				                        
			                            $("#my_rsv_stat").append(setHtml);
									} else {
										var setHtml = "";
					                    setHtml += "<div class='notice_con list_con'>";
				                        setHtml += "    <p class='notice_date'>" + item.resv_req_date + "</p>";
				                        setHtml += "    <p class='notice_stat'><span class='" + userResvService.fn_resvStateClass(item.resv_state) + "'>" + item.resv_state_text + "</span></p>";
				                        setHtml += "    <p class='notice_tit'>" + item.center_nm + " "  + item.seat_nm + "</p>";
				                    	setHtml += "</div>";
				                    	$("#my_rsv_stat_list").append(setHtml);
									}
								});
							} else {
								alert("예약된 정보가 존재하지 않습니다.");
							}
						} else if(result.status == "LOGIN FAIL") {
							
						}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);
			},
			fn_resvStateClass : function(resvState) {
				var className = "";
				
				switch(resvState) {
					case "RESV_STATE_2" : className = "done"; 
						break;
					case "RESV_STATE_3" : className = "done"; 
						break;
					case "RESV_STATE_4" : className = "cancel"; 
						break;
					default : className = "done" 
						break;
				}
				
				return className;
			},
 			fn_resvCancelDvsn : function(resvSeq, resvPayDvsn) {
 				resvPayDvsn == 
	    			"RESV_PAY_DVSN_1" ? 
	    				userResvService.fn_resvCancel(resvSeq) : 
						$("#pay_number").bPopup().find("a").attr("href", "javascript:userResvService.fn_payment('" + resvSeq + "')"); 
			},
			fn_resvCancel : function(resvSeq, payResult) {
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
						if (result.status == "SUCCESS") {
							payResult != null ?
									fn_openPopup("예약이 정상적으로 취소되었습니다.<br>잔액 : " + payResult.Balance, "blue", "SUCCESS", "확인", "javascript:location.reload();") :
									fn_openPopup("예약이 정상적으로 취소되었습니다.", "blue", "SUCCESS", "확인", "javascript:location.reload();");									
							/* userResvService.fn_userResvInfo(); */
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
			fn_payment : function(resvSeq, division) {
				var url = "/backoffice/rsv/speedCheck.do";
				var params = {
					"gubun" : "dep",
					"sendInfo" : {
						"resvSeq" : resvSeq,
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
								userResvService.fn_resvCancel(resvSeq, result.regist);
							} else {
								fn_openPopup(result.regist.Error_Msg, "red", "ERROR", "확인", "javascript:location.reload();");
							}
				    	} else {
				    		fn_openPopup("로그인중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");
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