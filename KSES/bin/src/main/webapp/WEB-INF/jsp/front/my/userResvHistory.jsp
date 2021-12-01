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
	<form:form name="regist" commandName="regist" method="post" action="/front/userResvHistory.do">
	<input type="hidden" id="userDvsn" name="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" id="userId" name="userId" value="${sessionScope.userLoginInfo.userId}">
	<input type="hidden" id="userNm" name="userNm" value="${sessionScope.userLoginInfo.userNm}">
	
	<input type="hidden" id="searchDay" name="searchDay" value="7">
	
    <div class="wrapper">
        <!--// header -->
        <div class="my_wrap">
            <div class="contents my_box rsv_history">
                <div class="navi_left">
                    <a href="javascript:history.back();" class="before_close"></a>
                </div>
                <h1>나의 입장예약 내역 <a href="javascript:history.back();" class="close"><img src="/resources/img/front/x_box.svg" alt="닫기"></a></h1>
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
                        <table> 
                            <tbody> 
                            	<tr>
	                                <td><a href="javascript:userResvService.fn_userResvInfo('7');">1주일</a></td>
	                                <td><a href="javascript:userResvService.fn_userResvInfo('30');">1개월</a></td>
	                                <td><a href="javascript:userResvService.fn_userResvInfo('90');">3개월</a></td>
	                                <td><a href="javascript:void(0);">상세조회</a></td>
                                </tr>
                            </tbody>                            
                        </table>
                    </div>         
                    <div id="my_rsv_stat" class="my_rsv_stat">
                        <ul class="my_rsv">
                            <li>
                                <ol>
                                    <li>예약번호</li>
                                    <li><span id="rsv_num" class="rsv_num">123458960</span></li>
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

                        <ul class="rsv_stat_btn">
                            <li><a href="">QR코드 발행</a></li>
                            <li><a href="">예약 취소</a></li>
                        </ul>
                    </div>
                </div>
                <div id="my_rsv_stat_list">
                    <div class="notice_con list_con">
                        <p class="notice_date">2021.12.01 12:00</p>
                        <p class="notice_stat"><span class="cancle">취소됨</span></p>
                        <p class="notice_tit">대전지점 A-3F-001</p>
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
        <!--contents //-->
    </div>  
	</form:form>

	<script src="/resources/js/front/jquery-spinner.min.js"></script>
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>

    <!--메뉴버튼 속성-->
    <script>
 		$(document).ready(function() {
 			userResvService.fn_userResvInfo('7');
		});

		var userResvService = {
			fn_userResvInfo : function(searchDay) {
				$("searchDay").val(searchDay);
				
				var url = "/front/userMyResvInfo.do";
				var params = {
					"userId" : $("#userId").val(),
					"searchDay" : searchDay
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
							if(result.userResvInfo != null) {
								var userResvInfo = result.userResvInfo;
								$("#my_rsv_stat").empty();
								$("#my_rsv_stat_list").empty();
								
								$.each(userResvInfo, function(index, item) {
									if(item.resv_state == "RESV_STATE_1") {
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
			                            setHtml += "    <li><a href='/front/qrEnter.do?resvSeq=" + item.resv_seq + "'>QR코드 발행</a></li>";
			                            setHtml += "	<li><a href='javascript:userResvService.fn_resvCancel(&#39;" + item.resv_seq +"&#39;)'>예약 취소</a></li>";
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
					case "RESV_STATE_3" : className = "cancle"; 
						break;
					case "RESV_STATE_4" : className = "noshow"; 
						break;
					default : className = "done" 
						break;
				}
				
				return className;
			},
			fn_resvCancel : function(resvSeq) {
				if(confirm("해당 예약정보를 취소하시겠습니까?") == true) {
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
								userResvService.fn_userResvInfo($("#searchDay").val());
							} else if (result.status == "LOGIN FAIL"){
								alert(result.message);
								locataion.href = "/front/main.do";
							}
						},
						function(request) {
							alert("ERROR : " + request.status);	       						
						}    		
					);
				}
			}
		}
    </script>
</body>  
</html>