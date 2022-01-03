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
    <!-- Zoom CSS -->
    <script src="/resources/js/front/pinch-zoom.umd.js"></script>
    
    <!-- popup-->    
    <script src="/resources/js/front/bpopup.js"></script>
	<link rel="stylesheet" href="/resources/css/section.css">   
 
	<script type="text/javascript" src="/resources/js/modernizr.custom.js"></script>
	<script type="text/javascript" src="/resources/js/classie.js"></script>
	<script type="text/javascript" src="/resources/js/dragmove.js"></script>
	<script type="text/javascript" src="/resources/js/modernizr.custom.js"></script>
    
	<link href="/resources/css/front/widescreen_temp.css" rel="stylesheet" media="only screen and (min-width : 1080px)">
	<link href="/resources/css/front/mobile_temp.css" rel="stylesheet" media="only screen and (max-width:1079px)">
</head>

<body>
	<form:form name="regist" commandName="regist" method="post" action="/front/rsvSeat.do">
	<input type="hidden" name="userDvsn" id="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" name="userId" id="userId" value="${sessionScope.userLoginInfo.userId}">
	
	<input type="hidden" name="isReSeat" id="isReSeat" value="${resvInfo.isReSeat}">
	<input type="hidden" name="resvUserNm" id="resvUserNm" value="">
	<input type="hidden" name="resvSeq" id="resvSeq" value="">
	<input type="hidden" name="resvDate" id="resvDate" value="${resvInfo.resvDate}">	
	
	<!-- 예약정보 sessionStorage검토 -->
	<input type="hidden" name="seasonCd" id="seasonCd">
	<input type="hidden" name="centerCd" id="centerCd" value="${resvInfo.centerCd}">
	<input type="hidden" name="partCd" id="partCd" value="">
	<input type="hidden" name="floorCd" id="floorCd" value="">
	<input type="hidden" name="seatCd" id="seatCd" value="">
	<input type="hidden" name="entryDvsn" id="entryDvsn" value="">
	
	<!-- 좌석 다시 앉기 sessionStorage검토 -->
	<input type="hidden" name="reSeatCenterCd" id="reSeatCenterCd" value="${resvInfo.centerCd}">
	<input type="hidden" name="rePartCd" id="rePartCd" value="${resvInfo.partCd}">
	<input type="hidden" name="reFloorCd" id="reFloorCd" value="${resvInfo.floorCd}">
	<input type="hidden" name="reSeatCd" id="reSeatCd" value="${resvInfo.seatCd}">
	<input type="hidden" name="reEnterDvsn" id="reEnterDvsn" value="${resvInfo.entryDvsn}">

    <div class="wrapper rsvBack">
        <!--// header -->
        <div id="rsv_header">
            <ul class="rsv_info rsv_prsc">
                <li class="backImg"></li>
                <li class="rsv_branch">
                	<span class="sel_center_nm">${resvInfo.center_nm}</span>
                	<span class="sel_floor_nm"></span> 
                	<span class="sel_part_nm"></span>
                	<span class="sel_seat_nm"></span>
				</li>	
                <li class="rsv_state"><span class="date"></span> 좌석 예약 중 입니다.</li>
                <li></li>
            </ul>             
        </div>
        <!-- header //-->
        <!--// contents-->
        <div id="container">
            <div>
                <div class="contents">                  
                    <h3>
						선택한 지점 
                        <span class="change_br">
                            <a href="/front/rsvCenter.do"><img src="/resources/img/front/refresh.svg" alt="change">지점변경</a>
                        </span>
                    </h3>
                    <div class="branch">
                        <p>${resvInfo.center_nm}</p>
                    </div>
                    <div class="null"></div>

                    <!--입장유형 선택-->
                    <h4>입장 유형을 선택하세요.</h4>
                    <div class="enter_type">
                        <ul>
							<li id="ENTRY_DVSN_1" onclick="seatService.fn_enterTypeChange('ENTRY_DVSN_1');">
								<ul>
									<li>입석</li>
								</ul>
							</li>
							<li id="ENTRY_DVSN_2" onclick="seatService.fn_enterTypeChange('ENTRY_DVSN_2');">
								<ul>
									<li>좌석</li>
								</ul>
							</li>
                        </ul>
                    </div>

                    <div id="showHide" align="middle">
                        <section>
                        <!--예약 정보 입력-->
                            <h4>예약 정보 입력</h4>
                            <ul id="standing_resv_area">
                                <li><input type="text" id="ENTRY_DVSN_1_resvUserNm" class="nonMemberArea" placeholder="이름을 입력해주세요."></li>
                                <li><input type="text" id="ENTRY_DVSN_1_resvUserClphn" class="nonMemberArea" onkeypress="onlyNum(this);" placeholder="전화번호를 '-'없이 입력해주세요."></li>
                                <li class="certify nonMemberArea sub_number" onclick="javascript:seatService.fn_SmsCertifi();">
                                	<a href="javascript:void(0);"><img src="/resources/img/front/certify.svg" alt="">인증번호 받기</a>
                                </li>
								
								<li class="nonMemberArea"><input type="text" id="ENTRY_DVSN_1_resvCertifiCode" placeholder="인증번호를 입력하세요."></li>
								<li class="certify nonMemberArea" onclick="javascript:seatService.fn_checkCertifiCode();">
									<a href="javascript:void(0);"><img src="/resources/img/front/certify.svg" alt="">인증 하기</a>
								</li>
                                
                                <!--전자문진표-->
                                <li class="covid19_qna">
                                    <p>
                                        <span>&lt;전자문진표 작성&gt;</span>
                                        <ol>
                                            <li>확진자/자가격리자 접촉</li>
                                            <li>해외 및 코로나19 감염 위험지역 방문</li>
                                            <li>발열(37.5도 이상), 근육통, 기침, 인후통 등 호흡기 증상</li>
                                            <li>지자체(기관)로부터 코로나19 검사 요청(능동감시자)</li>
                                            <li class="check_impnt">
                                                <input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_1_qna_check" value="Y">
                                                <label for="ENTRY_DVSN_1_qna_check">
                                               	 최근14일 이내 위 사항에 해당사항이 없으며, 허위기재로 문제발생시 본인에게 책임이 있음을 확인합니다.
                                                </label>     
                                            </li>
                                        </ol>
                                    </p>
                                </li>
                                
								<!--개인정보동의-->
								<li class="person_check nonMemberArea">
									<p>
										<span>&lt;개인정보 수집 이용 동의 안내 &gt;(필수)</span>																															
						                <h5 class="notiCon">스피드온 회원정보를 활용하여 스마트 입장시스템을 통해 경륜경정 본장 및 지점의 입장신청, 출입관리를 목적으로 개인정보를 처리(수집·이용)합니다.</h5>
										<p class="prsn_agree"><a data-popup-open="person_agree">자세히 &gt;</a></p>
									
										<ul>									
						                   	<li class="agreeBtn">개인정보 수집 및 이용에 동의하시겠습니까?</li>
						                   	<li class="check_impnt">
												<input class="cash_radio" type="radio" checked name="ENTRY_DVSN_1_person_agree" id="ENTRY_DVSN_1_person_agree" value="person_agreeN_1">
                                    			<label for="ENTRY_DVSN_1_person_agree"><span></span>동의함</label>
                                    				
                                    			<input class="cash_radio" type="radio" name="ENTRY_DVSN_2_person_agree" id="ENTRY_DVSN_2_person_agree" value="person_agreeN_2">
                                    			<label for="ENTRY_DVSN_2_person_agree"><span></span>동의안함</label>                                    
											</li>
										</ul>									
									</p>
								</li>
								
								
								<!--홍보마케팅동의-->
								<li class="person_check nonMemberArea">
									<p>									
										<span>&lt;홍보 및 마케팅 활용 동의 &gt;(선택)</span>																															

						                
										<p class="prsn_agree"><a data-popup-open="mktg_agree">자세히 &gt;</a></p>
										<ul>									
						                   	<li class="agreeBtn">스마트 입장 시스템에서 보내는 본장 및 지점별 마케팅 문자 수신에 동의 하시겠습니까?</li>
						                   	<li class="check_impnt">
												<input class="cash_radio" type="radio" checked name="ENTRY_DVSN_1_person_agree" id="ENTRY_DVSN_1_person_agree" value="person_agreeN_1">
                                    			<label for="ENTRY_DVSN_1_person_agree"><span></span>동의함</label>
                                    				
                                    			<input class="cash_radio" type="radio" name="ENTRY_DVSN_2_person_agree" id="ENTRY_DVSN_2_person_agree" value="person_agreeN_2">
                                    			<label for="ENTRY_DVSN_2_person_agree"><span></span>동의안함</label>                                    
											</li>											
										</ul>																			
									</p>
								</li>  
								
								<!--기타고지사항-->
								<li class="person_check nonMemberArea">
									<p>	
										<span>&lt;기타 고지 사항 &gt;</span>																															
						                <h5 class="notiCon">개인정보 보호법 제15조 제1항 제2호에 따라 정보주체의 동의 없이 개인정보를 수집·이용합니다.</h5>																																						
										<p class="prsn_agree"><a data-popup-open="ect_agree">자세히 &gt;</a></p>									
									</p>
								</li>    
                            </ul>

                            <!--현금 영수증 발급-->
<!--                             <h4>현금 영수증 발급</h4>
                            <ul class="bill_confirm">
                                <li class="check_impnt">
                                    <input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_1_bill_confirm" value="Y" onclick="seatService.fn_billConfirmChange();">
                                    <label for="ENTRY_DVSN_1_bill_confirm">현금 영수증 발급</label>     
                                </li>
                            </ul>
                            <ul id="ENTRY_DVSN_1_cash_area" class="cash_refund">
                                <li>
                                    <input class="cash_radio" type="radio" checked name="ENTRY_DVSN_1_rcpt_dvsn" id="ENTRY_DVSN_1_rcpt_dvsn1" value="RCPT_DVSN_1">
                                    <label for="ENTRY_DVSN_1_rcpt_dvsn1"><span></span>소득 공제용</label>
                                </li>
                                <li>
                                    <input class="cash_radio" type="radio" name="ENTRY_DVSN_1_rcpt_dvsn" id="ENTRY_DVSN_1_rcpt_dvsn2" value="RCPT_DVSN_2">
                                    <label for="ENTRY_DVSN_1_rcpt_dvsn2"><span></span>지출 증빙용</label>
                                </li>
                                <li><input type="number" id="ENTRY_DVSN_1_cash_number" onkeypress="onlyNum(this);" placeholder="'-'없이 입력해 주세요."></li>
                            </ul> -->
                            <ul class="rsv_btn">
                                <li><a href="javascript:seatService.fn_checkForm();">예약하기</a></li>
                                <li><a data-popup-open="rsv_cancel">취소</a></li>
                            </ul> 
                        </section>
                    </div>
                    
                    <!--show2 좌석 예약-->
                    <div id="showHide_seat" align="middle">
                        <!--층선택-->
                        <section>
                            <h4>층을 선택하세요.</h4>
                            <div id="floor_sel" class="floor_sel">
                                <select id="selectFloorCd" class="select_box" onchange="seatService.fn_floorChange();">
                                    <option value="">층 선택</option>
									<c:forEach items="${floorList}" var="floorList">
										<option value="${floorList.floor_cd}">${floorList.floor_nm}</option>
									</c:forEach>
                                </select>
                            </div>

                            <!--구역선택-->
                            <div id="section_sel" > 
                                <h4>구역을 선택하세요.</h4>
                                <h5>좌석 이용료 <span>(입장료 별도)</span></h5>
                                <!--요금안내-->
                                <div id="price" class="price">
                                    <table>
                                        <tbody>
											<c:forEach var="item" items="${seatClass}" begin="0" step="1" varStatus="status">
												<c:if test="${(status.index + 1)%2 != 0}"><tr></c:if>
													<td>
														<img src="${item.codeetc2}">${item.codenm}
													<c:if test="${item.codeetc1 ne 0}">
														<span>${item.codeetc1}원</span>
													</c:if>
													<c:if test="${item.codeetc1 eq 0}">
														<span>무료</span>
													</c:if>
													</td>
											    <c:if test="${(status.index + 1)%2 == 0}"><tr></c:if>
											</c:forEach>
                                        </tbody>                                          
                                    </table>
                                </div>
                                <!--구역선택 맵-->
								<div id="part_select" class="seat_select">

								</div>

                                <!--구역선택 메뉴-->
                                <div id="part_area" class="section_menu">                                                                         
                            		<div id="part_sel" class="part_sel">
                                		<select id="selectPartCd" class="select_box" onchange="seatService.fn_partChange();">
                                    		
                                		</select>
                            		</div>                                             
                                </div>
                                <!--좌석선택-->
                                <div id="tab-a" class="tab-content">
                                    <div id="seat_tit" class="seat_tit">
                                       <h4>좌석선택</h4>
                                       <ul>
                                           <li><span class="disable"></span>신청불가</li>
                                           <li><span class="possible"></span>신청가능</li>
                                           <li><span class="select_Seat"></span>선택좌석</li>
                                       </ul> 
                                    </div>
                                    <div id="seat_select" class="seat_select test_sel">
                                        <div>
                                   			
                                        </div>
									</div>

                                    <!--예약 정보 입력-->
                                    <h4>예약 정보 입력</h4>
                                    <ul id="ENTRY_DVSN_2_resv_area">
                                        <li class="nonMemberArea"><input type="text" id="ENTRY_DVSN_2_resvUserNm" placeholder="이름을 입력해주세요."></li>
                                        <li class="nonMemberArea"><input type="text" id="ENTRY_DVSN_2_resvUserClphn" onkeypress="onlyNum(this);" placeholder="전화번호를 '-'없이 입력해주세요."></li>
										<li class="certify nonMemberArea sub_number" onclick="javascript:seatService.fn_SmsCertifi();">
											<a href="javascript:void(0);"><img src="/resources/img/front/certify.svg" alt="">인증번호 받기</a>
										</li>
										
                                		<li class="nonMemberArea"><input type="text" id="ENTRY_DVSN_2_resvCertifiCode" placeholder="인증번호를 입력하세요."></li>
                                        <li class="certify nonMemberArea" onclick="javascript:seatService.fn_checkCertifiCode();">
                                        	<a href="javascript:void(0);"><img src="/resources/img/front/certify.svg" alt="">인증 하기</a>
                                        </li>
                                        
                                        <!--전자문진표-->
                                        <li class="covid19_qna">
                                            <p>
                                                <span>&lt;전자문진표 작성&gt;</span>
                                                <ol>
                                                    <li>확진자/자가격리자 접촉</li>
                                                    <li>해외 및 코로나19 감염 위험지역 방문</li>
                                                    <li>발열(37.5도 이상), 근육통, 기침, 인후통 등 호흡기 증상</li>
                                                    <li>지자체(기관)로부터 코로나19 검사 요청(능동감시자)</li>
                                                    <li class="check_impnt">
                                                        <input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_2_qna_check" value="Y">
                                                        <label for="ENTRY_DVSN_2_qna_check">
                                                        	최근14일 이내 위 사항에 해당사항이 없으며, 허위기재로 문제발생시 본인에게 책임이 있음을 확인합니다.
                                                        </label>     
                                                    </li>
                                                </ol>
                                            </p>
                                        </li>
										<!--개인정보동의-->
										<li class="person_check nonMemberArea">
											<p>
												<span>&lt;개인정보 수집 이용 동의 안내 &gt;(필수)</span>																															
								                <h5 class="notiCon">스피드온 회원정보를 활용하여 스마트 입장시스템을 통해 경륜경정 본장 및 지점의 입장신청, 출입관리를 목적으로 개인정보를 처리(수집·이용)합니다.</h5>
												<p class="prsn_agree"><a data-popup-open="person_agree">자세히 &gt;</a></p>
											
												<ul>									
								                   	<li class="agreeBtn">개인정보 수집 및 이용에 동의하시겠습니까?</li>
								                   	<li class="check_impnt">
														<input class="cash_radio" type="radio" checked name="ENTRY_DVSN_1_person_agree" id="ENTRY_DVSN_1_person_agree" value="person_agreeN_1">
		                                    			<label for="ENTRY_DVSN_1_person_agree"><span></span>동의함</label>
		                                    				
		                                    			<input class="cash_radio" type="radio" name="ENTRY_DVSN_2_person_agree" id="ENTRY_DVSN_2_person_agree" value="person_agreeN_2">
		                                    			<label for="ENTRY_DVSN_2_person_agree"><span></span>동의안함</label>                                    
													</li>
												</ul>									
											</p>
										</li>
										
										
										<!--홍보마케팅동의-->
										<li class="person_check nonMemberArea">
											<p>									
												<span>&lt;홍보 및 마케팅 활용 동의 &gt;(선택)</span>																															
		
								                
												<p class="prsn_agree"><a data-popup-open="mktg_agree">자세히 &gt;</a></p>
												<ul>									
								                   	<li class="agreeBtn">스마트 입장 시스템에서 보내는 본장 및 지점별 마케팅 문자 수신에 동의 하시겠습니까?</li>
								                   	<li class="check_impnt">
														<input class="cash_radio" type="radio" checked name="ENTRY_DVSN_1_person_agree" id="ENTRY_DVSN_1_person_agree" value="person_agreeN_1">
		                                    			<label for="ENTRY_DVSN_1_person_agree"><span></span>동의함</label>
		                                    				
		                                    			<input class="cash_radio" type="radio" name="ENTRY_DVSN_2_person_agree" id="ENTRY_DVSN_2_person_agree" value="person_agreeN_2">
		                                    			<label for="ENTRY_DVSN_2_person_agree"><span></span>동의안함</label>                                    
													</li>											
												</ul>																			
											</p>
										</li>  
										
										<!--기타고지사항-->
										<li class="person_check nonMemberArea">
											<p>	
												<span>&lt;기타 고지 사항 &gt;</span>																															
								                <h5 class="notiCon">개인정보 보호법 제15조 제1항 제2호에 따라 정보주체의 동의 없이 개인정보를 수집·이용합니다.</h5>																																						
												<p class="prsn_agree"><a data-popup-open="ect_agree">자세히 &gt;</a></p>									
											</p>
										</li>                                               
                                    </ul>

		                            <!--현금 영수증 발급-->
<!-- 		                            <h4>현금 영수증 발급</h4>
		                            <ul class="bill_confirm">
		                                <li class="check_impnt">
		                                    <input class="magic-checkbox qna_check" type="checkbox" name="layout" id="ENTRY_DVSN_2_bill_confirm" value="Y" onclick="seatService.fn_billConfirmChange();">
		                                    <label for="ENTRY_DVSN_2_bill_confirm">현금 영수증 발급</label>     
		                                </li>
		                            </ul>
                                    <ul id="ENTRY_DVSN_2_cash_area" class="cash_refund">
                                        <li>
                                            <input class="cash_radio" type="radio" checked name="ENTRY_DVSN_2_rcpt_dvsn" id="ENTRY_DVSN_2_rcpt_dvsn1" value="RCPT_DVSN_1">
                                            <label for="ENTRY_DVSN_2_rcpt_dvsn1"><span></span>소득 공제용</label>
                                        </li>
                                        <li>
                                            <input class="cash_radio" type="radio" name="ENTRY_DVSN_2_rcpt_dvsn" id="ENTRY_DVSN_2_rcpt_dvsn2" value="RCPT_DVSN_2">
                                            <label for="ENTRY_DVSN_2_rcpt_dvsn2"><span></span>지출 증빙용</label>
                                        </li>
                                        <li><input type="number" id="ENTRY_DVSN_2_cash_number" onkeypress="onlyNum(this);" placeholder="'-'없이 입력해 주세요."></li>
                                    </ul>      -->   
                                    <ul class="rsv_btn">
                                        <li><a href="javascript:seatService.fn_checkForm();">예약하기</a></li>
                                        <li><a data-popup-open="rsv_cancel">취소</a></li>
                                    </ul>                         
                                </div>
                            </div>
                        </section>
                    </div>
                </div>                
            </div>
        </div>
        <!--contents //-->

        <div id="foot_btn">
            <div class="contents">
                <ul>
                    <li class="home"><a href="javascript:fn_pageMove('regist','/front/main.do');">home</a><span>HOME</span></li>
                    <li class="rsv active"><a href="/front/rsvCenter.do">rsv</a><span>입장예약</span></li>
                    <li class="my"><a href="/front/mypage.do">my</a><span>마이페이지</span></li>
                </ul>
                <div class="clear"></div>
            </div>
        </div>
    </div>  

    <!-- // 예약완료 팝업 -->
    <div id="rsv_done" class="popup">
      <div class="pop_con rsv_popup">
          <!-- <a class="button b-close">X</a> -->
          <div class="pop_wrap">
              <h4><img src="/resources/img/front/done.svg" alt="예약확인">해당 정보로 예약하시겠습니까?</h4>
               <ul class="rsv_list">
					<li>
                        <ol>
                            <li>경주일</li>
                            <li><span id="rsv_date" class="rsv_date"></span></li>
                        </ol>
                    </li> 
                    <li>
                        <ol>
                            <li>지점</li>
                            <li><span id="rsv_center" class="rsv_center"></span></li>
                        </ol>
                    </li>
					<li>
                        <ol>
                            <li>층</li>
                            <li><span id="rsv_floor" class="rsv_floor"></span></li>
                        </ol>
                    </li>
					<li>
                        <ol>
                            <li>구역</li>
                            <li><span id="rsv_part" class="rsv_part"></span></li>
                        </ol>
                    </li>
                    <li>
                        <ol>
                            <li>좌석</li>
                            <li><span id="rsv_seat" class="rsv_seat"></span></li>
                        </ol>
                    </li>
               </ul>
          </div>
          <div class="summit_btn">
              <a href="javascript:seatService.fn_setResvInfo();" class="mintBtn">확인</a>
              <a href="javascript:bPopupClose('rsv_done');">취소</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>
    <!-- 예약완료 팝업 // -->

    <!-- // 예약취소 팝업 -->
    <div data-popup="rsv_cancel" class="popup">
      <div class="pop_con rsv_popup">
          <div class="pop_wrap">
              <h4><img src="/resources/img/front/cancle.svg" alt="예약취소">예약이 취소 되었습니다.</h4>
          </div>
          <div class="cancel_btn">
              <a href="/front/main.do" class="grayBtn">처음으로</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>
    <!-- 예약취소 팝업 // -->
    
	<!-- // 개인정보 수집이용 약관 팝업-->
    <div id="person_agree" data-popup="person_agree" class="popup">
    	<div class="pop_con rsv_popup">
          	<div class="pop_wrap">
            	<div class="text privacy_text">
                	<p class="font14 mg_l20">개인정보 수집·이용 및  제 3자 제공 동의서</p><br>                
                	<p class="font13 mg_l20">코로나19 확산방지를 위하여 경주사업총괄본부에서는 다음과 같이 개인정보 수집·이용 및 제 3자 제공에 대한 동의를 얻고자 합니다.</p>
                
                	<div class="tablet_wrap">                		
						<ol class="person_cont">
							<li>1. 수집 이용하려는 개인정보의 항목
						        <ul>
						           <li>스피드온 회원정보의 ID, 카드ID, 이름, 휴대전화번호, 성별, 나이, 백신접종정보, 방문지점</li>
						        </ul>
						    </li>
						    <li>2. 개인정보 이용기간
						        <ul>
						            <li>개인정보 동의일로부터 3년</li>
						        </ul>
						    </li>
						    <li>3. 개인정보 수집이용 거부 및 불이익
						        <ul>
						           <li>이용자는 해당 개인정보 수집 및 이용 동의에 대한 거부할 권리가 있습니다. 그러나 동의하지 않을경우 스피드온 회원정보를 통한 스마트입장시스템 서비스 이용이 불가능합니다.</li>
						        </ul>
						    </li>						                   			
						</ol>
                   	</div>

                   		                    
                    <p class="font13 mg_l20">※위의 개인정보 수집·이용 및 3자 제공에 대한 동의를 거부할 권리가 있습니다. 그러나 동의를 거부할 경우 출입이 제한될 수 있습니다. </p><br>
                </div>                
            </div>
          </div>
          <div class="cancel_btn">
              <a href="javascript:bPopupClose('person_agree');" class="grayBtn">닫기</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>
    <!-- 개인정보 수집이용 약관 팝업 // -->
    
	<!-- // 홍보 및 마케팅 활용 동의 팝업-->
    <div id="person_agree" data-popup="mktg_agree" class="popup">
    	<div class="pop_con rsv_popup">
          	<div class="pop_wrap">
            	<div class="text privacy_text">
                	<p class="font14 mg_l20">개인정보 수집·이용 및  제 3자 제공 동의서</p><br>                
                	<p class="font13 mg_l20">코로나19 확산방지를 위하여 경주사업총괄본부에서는 다음과 같이 개인정보 수집·이용 및 제 3자 제공에 대한 동의를 얻고자 합니다.</p>
                
                	<div class="tablet_wrap">
						<ol class="person_cont">
							<li>1. 활용 목적 : 본장 및 지점별 마케팅 문자 발송</li>
						    <li>2. 활용 항목 : 휴대전화번호</li>
						    <li>3. 활용 및 보관기간 : 개인정보 동의일로부터 3년</li>
						    <li>4. 동의를 거부할 권리 및 거부 시 불이익 : 이용자는 해당 개인정보의 마케팅 활용 동의를 거부할 권리가 있으며, 거부 시 불이익은 없습니다.</li>						                   			
						</ol>
                   	</div>

                   		                    
                    <p class="font13 mg_l20">※ 코로나 방역, 천재지변 등으로 인한 긴급알림 문자는 동의가 없어도 해당 영업장 입장신청자들을 대상으로 발송됩니다. </p><br>
                </div>                
            </div>
          </div>
          <div class="cancel_btn">
              <a href="javascript:bPopupClose('person_agree');" class="grayBtn">닫기</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>
    <!-- 홍보 및 마케팅 활용 동의 팝업 // -->    
    
	<!-- // 기타고지사항 팝업-->
    <div id="person_agree" data-popup="ect_agree" class="popup">
    	<div class="pop_con rsv_popup">
          	<div class="pop_wrap">
            	<div class="text privacy_text">
                	<p class="font14 mg_l20">기타고지사항</p><br>                                
						<table class="tb3" summary="">                            	
			            	<colgroup>
				            	<col width="27%">
				                <col width="29%">
				                <col width="26%">
				                <col width="18%">
			                </colgroup>
							<thead>
				                <tr>
				                   <th scope="col">개인정보 처리사유</th>
				                   <th scope="col">개인정보 항목</th>
				                   <th scope="col">보유기간</th>
				                   <th scope="col">수집근거</th>
				                </tr>
				             </thead>
				             <tbody>             
				                <tr>
				                   <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">레저세<br>납부</td>
				                   <td class="text_center" style="color:red; font-size:11px; font-weight:bold;">휴대전화번호, <br>방문지점, <br>입장시간</td>
				                   <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">5년</td>
				                   <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">지방세법』제43조 <br>동법 시행령 제58조</td>
				                 </tr>
				             </tbody>
				         </table>                    		                    
                    <p class="font13 mg_l20">※ 코로나 방역, 천재지변 등으로 인한 긴급알림 문자는 동의가 없어도 해당 영업장 입장신청자들을 대상으로 발송됩니다. </p><br>
                </div>                
            </div>
          </div>
          <div class="cancel_btn">
              <a href="javascript:bPopupClose('person_agree');" class="grayBtn">닫기</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>
    <!-- 기타고지사항 팝업 // -->    
    
   						                

    <!--층 선택 시 show/hide-->
    <script>
    	var isMember = "${sessionScope.userLoginInfo.userDvsn}" == "USER_DVSN_1" ? true : false;

    	var certifiYn = false;
    	var certifiCode = "";
    	var resvUserNm = isMember ? "${sessionScope.userLoginInfo.userNm}" : "";
    	var resvUserClphn = isMember ? "${sessionScope.userLoginInfo.userPhone}" : "";
    	
//    	var userRcptYn = isMember ? "${sessionScope.userLoginInfo.userRcptYn}" : "";
//    	var userRcptDvsn = isMember ? "${sessionScope.userLoginInfo.userRcptDvsn}" : "";
//    	var userRcptNumber = isMember ? "${sessionScope.userLoginInfo.userRcptNumber}" : "";
    	
    	var pinchzoom = "";
    	var pinchInit = true;
    	var center ="";
    	
		$(document).ready(function() {
			if(sessionStorage.getItem("accessCheck") != "1") {
				location.href = "/front/main.do";
			}
			
		    $(window).on("beforeunload", function(){
		    	sessionStorage.removeItem("accessCheck");
		    });

			
			//입석 좌석 버튼 이벤트 정의
			$(function(){
				var sBtn = $(".section_menu ul > li, .enter_type ul > li");   //  ul > li 이를 sBtn으로 칭한다. (클릭이벤트는 li에 적용 된다.)
				sBtn.find("ul").click(function(){   // sBtn에 속해 있는  ul 찾아 클릭 하면.
					sBtn.removeClass("active");     // sBtn 속에 (active) 클래스를 삭제 한다.
					$(this).parent().addClass("active"); // 클릭한 a에 (active)클래스를 넣는다.
				})
			});
			
			$('.section_menu ul.tabs li').click(function(){
            	var tab_id = $(this).attr('data-tab');

            	$('.section ul.tabs li').removeClass('current');
            	$('.tab-content').removeClass('current');

            	$(this).addClass('current');
            	$("#"+tab_id).addClass('current');
    		});
			

			$(".date").html(fn_resvDateFormat($("#resvDate").val()));
			resvUsingTimeCheck(sessionStorage.getItem("resvUsingTime"));
			
			if($("#isReSeat").val() == "Y") {
				seatService.fn_reSeat();
			}
			
			if($("#centerCd").val() == null) {
				fn_openPopup("지점정보가 존재하지 않습니다.\n처음부터 예약을 진행해주세요", "red", "ERROR", "확인", "/front/main.do");
			}
		});
		
		var seatService =
		{ 
			fn_makeResvArea: function(centerCd) {
				var url = "/front/rsvSeatAjax.do";
				
				var parmas = {"resvDate" : $("resvDate").val()};
				
				fn_Ajax
				(
				    url,
				    "GET",
				    parmas,
					false,
					function(result) {
						if (result.status == "SUCCESS") {
							if(result.resultlist != null) {
								$(".branch_list").empty();
								$.each(result.resultlist, function(index, item) {
									var setHtml = "";
									setHtml += "<li><ul id='" + item.center_cd + "'><li><span>" 
									+ item.center_nm + "</span></li><li></li><li>잔여석 <em>" 
									+ (item.center_seat_max_count - item.center_seat_use_count) 
									+ "</em>석</li></ul></li>";
									$(".branch_list").append(setHtml);
								});
								centerService.fn_centerButtonSetting();
							}
						}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);
			},
			fn_reSeat : function() {
				$("#" + $("#reEnterDvsn").val()).addClass("active");
				$("#" + $("#reEnterDvsn").val()).trigger("click");
				$("#selectFloorCd").val($("#reFloorCd").val()).trigger("change");
				$("#selectPartCd").val($("#rePartCd").val()).trigger("change");
				$("#" + $("#reSeatCd").val()).trigger("click");
				
				$("#mask").trigger("click");
			},
			fn_enterTypeChange : function(entryDvsn) {
				if($("#entryDvsn").val() != entryDvsn) {
					if(entryDvsn == "ENTRY_DVSN_1") {
						$("#showHide").show();
						$("#showHide_seat").hide();
						
						$(".rsv_list").children("li").eq(2).hide();
						$(".rsv_list").children("li").eq(3).hide();
					} else {
						$("#section_sel").hide();
						$("#selectFloorCd").val("");

						$("#showHide").hide();
						$("#showHide_seat").show();
						$(".rsv_list").children("li").eq(2).show();
						$(".rsv_list").children("li").eq(3).show();
					}
					
					seatService.fn_initializing("ALL");
					$("#entryDvsn").val(entryDvsn);
										
					$("#" + entryDvsn + "_resvUserNm").val("");
					$("#" + entryDvsn + "_resvUserClphn").val("");
					$("#" + entryDvsn + "_resvCertifiCode").val("");
					
					$("input:checkbox[id='" + entryDvsn + "_qna_check']").prop("checked", false);
					$("input:checkbox[id='" + entryDvsn + "_person_agree']").prop("checked", false);
					
//					$("#" + entryDvsn + "_cash_area").hide();
//					$("input:radio[name='" + entryDvsn + "_rcpt_dvsn']").eq(0).prop("checked", true);
//					$("input:checkbox[id='" + entryDvsn + "_bill_confirm']").prop("checked", false);
//					$("#" + entryDvsn + "_cash_number").val("");
//					$("input:radio[name='" + entryDvsn + "_rcpt_dvsn']").eq(0).prop("checked", true);					
					
					if(isMember) {
// 						if(userRcptYn == "Y") {
//							$("input:checkbox[id='" + entryDvsn + "_bill_confirm']").trigger("click");
//							$("input:radio[name='" + entryDvsn + "_rcpt_dvsn'][value='" + userRcptDvsn +"']").prop("checked", true);	  
//							$("#" + entryDvsn + "_cash_number").val(userRcptNumber);							
//						}

						$(".nonMemberArea").hide();
					} else {
						certifiYn = false;
						certifiCode = "";
				    	resvUserNm = "";
				    	resvUserClphn = "";
						$(".nonMemberArea").show();
					}
				}
			},
			fn_floorChange : function() {
				if($("#selectFloorCd").val() != "" && $("#selectFloorCd").val() != $("#floorCd")) {
					seatService.fn_initializing("FLOOR");
					$("#floorCd").val($("#selectFloorCd").val());
					$(".sel_floor_nm").html($("#selectFloorCd option:checked").text());
					$("#section_sel").show();
				} else {
					return;
				}
				
				var url = "/front/rsvPartListAjax.do";
				var params = 
				{
					"floorCd" : $("#floorCd").val(),
					"resvDate" : $("#resvDate").val()
				}
				
				fn_Ajax
				(
				    url,
				    "POST",
				    params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS"){
							seatService.fn_initPinch("floor");
				    		if (result.seatMapInfo != null) {
				    		    var img = result.seatMapInfo.floor_map1;
				    		    $('.floor_map').css({
				    		        "background": "#fff url(/upload/" + img + ")",
				    		        'background-repeat': 'no-repeat',
				    		        'background-position': ' center'
				    		    });
				    		} else {
				    		    $('.floor_map').css({
				    		        "background": "#fff url()",
				    		        'background-repeat': 'no-repeat',
				    		        'background-position': ' center'
				    		    });
				    		}
				            
							if (result.resultlist.length > 0) {
								$("#selectPartCd").empty();
								$("#selectPartCd").append("<option value=''>구역 선택</option>");
								
								var setHtml = "";

								//층 도면 구역 아이콘 영역
								$.each(result.resultlist, function(index, item) {
									$("#selectPartCd").append("<option value='" + item.part_cd + "'>" + item.part_nm + "</option>");
									
									setHtml = '<div class="box-wrapper"><li id="s' + trim(fn_NVL(item.part_cd)) + '" class="seat" seat-id="' + item.part_cd + '" style="opacity: 0.7;text-align: center; display: inline-block;" name="' + item.part_cd + '" >' 
	                                  		+  '<div class="section">'
	                                  		+  '   <div class="circle">'
	                                  		+  '       <span class=' + fn_NVL(item.part_css) + '>' + fn_NVL(item.part_nm);
									
								setHtml += item.part_class != "SEAT_CLASS_1" ? '<em class="circle_class">(' + fn_NVL(item.part_class_text) + ')</em>' : "";
	                                  
								setHtml +=  '</div></div></li></div>';
	                             
	                            	$('#floor_area_Map').append(setHtml);
								});
								
                            	$.each(result.resultlist, function(index, item) {
	 	                            $('.floor_map ul li#s' + trim(fn_NVL(item.part_cd))).css({
	 	                                "top": fn_NVL(item.part_mini_top) + "px",
	 	                                "left": fn_NVL(item.part_mini_left) + "px",
	 	                                "width": fn_NVL(item.part_mini_width) + "px",
	 	                                "height": fn_NVL(item.part_mini_height) + "px",
	 	                                '-moz-transform': 'rotate(' + fn_NVL(item.part_mini_rotate) + 'deg)',
	 	                                '-webkit-transform': 'rotate(' + fn_NVL(item.part_mini_rotate) + 'deg)',
	 	                            });
                            	});
                            	
	 		 	                   
 		 	                    $('.seat').draggable({
 		 	                      	stop : function(e, ui){
										var obj = e.target;
	 				 	                var get_id = obj.id;
	 				 	                var top_id = 'top_' + $('#'+get_id)[0].attributes.name.value;
	 				 	                var left_id ='left_' + $('#'+get_id)[0].attributes.name.value;
	 				 	                $('#'+top_id).val(item.part_mini_top);
	 				 	                $('#'+left_id).val(item.part_mini_left);
 		 	                    	}
 		 	                    });
								$('.seat').draggable("option", "disabled", true );
								$(".box-wrapper li").click(function () {
									var partCd = $(this).attr("id").substring(1);
									$("#selectPartCd").val(partCd).trigger("change");
								});
								
								fn_scrollMove($("#section_sel"));
							} else {
								fn_openPopup("해당층은 현재 예약 가능한 구역이 존재하지 않습니다.");
							}
				    	}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
					}    		
				);
			},
			fn_partChange : function() {
				if($("#selectPartCd").val() != "" && $("#selectPartCd").val() != $("#partCd")) {
					seatService.fn_initializing("PART");
					$("#partCd").val($("#selectPartCd").val());
					$(".sel_part_nm").html($("#selectPartCd option:selected").html() + "구역");
				} else {
					return;
				} 
									
				var url = "/front/rsvSeatListAjax.do";
				var params = 
				{	
					"centerCd" : $("#centerCd").val(),
					"partCd" : $("#partCd").val(),
					"resvDate" : $("#resvDate").val()
				}
				
				fn_Ajax
				(
				    url,
				    "POST",
				    params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS"){
				    		// 좌석 GUI HTML세팅(PinchZoom)
				    		seatService.fn_initPinch("seat");
				    		
				    		// 시즌유무확인
				    		result.seasonCd != null ? $("#seasonCd").val(result.seasonCd) : $("#seasonCd").val("");
				    		
				    		if (result.seatMapInfo != null) {
				    		    var img = result.seatMapInfo.part_map1;
				    		    $('.part_map').css({
				    		        "background": "#fff url(/upload/" + img + ")",
				    		        'background-repeat': 'no-repeat',
				    		        'background-position': ' center'
				    		    });
				    		} else {
				    		    $('.part_map').css({
				    		        "background": "#fff url()",
				    		        'background-repeat': 'no-repeat',
				    		        'background-position': ' center'
				    		    });
				    		}
								
							if (result.resultlist.length > 0) {
				    		    var shtml = "";
				    		    var obj = result.resultlist;
				    		    for (var i in result.resultlist) {
				    		        var addClass = (obj[i].status == "0") ? "seatUse" : "none";
				    		        var onClick = "seatService.fn_seatChange(this);"; 
				    		        shtml += '<li id="' + fn_NVL(obj[i].seat_cd) + '" class="' + addClass + '" seat-id="' + obj[i].seat_cd + '" name="' + obj[i].seat_nm + '" >' + obj[i].seat_number + '</li>';
				    		    }
				    		    
				    		    $('#area_Map').html(shtml);
				    		    
				    		    for (var i in result.resultlist) {
				    		        $("#" + fn_NVL(obj[i].seat_cd)).css({
				    		            "top": fn_NVL(obj[i].seat_top) + "px",
				    		            "left": fn_NVL(obj[i].seat_left) + "px"
				    		        });
				    		        
				    		        $("#" + fn_NVL(obj[i].seat_cd)).data("seat-paycost", obj[i].pay_cost);
				    		        $("#" + fn_NVL(obj[i].seat_cd)).data("seat_class", obj[i].seat_class);
				    		    }
				    		    
				    		    var seatList = $("#area_Map li");
				    		    $(seatList).click(function() {
				    		    	if($(this).attr("id") == $("#seatCd").val()){
				    		    		$("#seatCd").val("");
				    		    		$(".sel_seat_nm").html("");
				    		    		$(this).removeClass("select");
				    		    		$(this).addClass("seatUse");
				    		    		return;
				    		    	};

				    		    	if(!$(this).hasClass("none")) {
				    		    		var oldSel = $("#area_Map li.select");
				    		    		
				    		    		oldSel.removeClass("select");
				    		    		oldSel.addClass("seatUse");
				    		    		
				    		    		$(this).removeClass("seatUse");
										$(this).addClass("select");
										
										var seatCd = $(this).attr("id");
										$("#seatCd").val(seatCd);
										
 										var seatNm = $(this).attr("name");
										$(".sel_seat_nm").html(seatNm);
				    		    	}
								});
				    		    
				    		    fn_scrollMove($("#tab-a"));
				    		}
				    	}
					},
					function(request) {
						fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");       						
					}    		
				);	
			},
			fn_initPinch : function(dvsn) {
				if(dvsn == "seat") {
					var seat_select = $("#seat_select");
					seat_select.empty();
					
					var setHtml = '';
					setHtml += '<div class="window"></div>';
					setHtml += '<div id="gui_seat" class="gui_seat mapbottom pinch-zoom-parent">';

					setHtml += '    <div id="mask">';
					setHtml += '        <div class="info_img">';
					setHtml += '            <img src="/resources/img/front/finger.png" alt="">';
					setHtml += '            <p>손가락으로 펼쳐 확대해보세요.</p>';
					setHtml += '        </div>';
					setHtml += '    </div>';
			         
					//닫기 버튼을 눌렀을 때
					$(document).on("click",".window .close",function() { 
						//링크 기본동작은 작동하지 않도록 한다.
						e.preventDefault();
						$('#mask, .window').hide();
		 			});
			            
					//검은 막을 눌렀을 때
					$(document).on("click","#mask",function() { 
						$(this).hide();
						$('.window').hide();
		 			});
	                	
	
					setHtml += '    <div class="part_map pinch-zoom" style="background-repeat: no-repeat; background-position: center center">';
					setHtml += '        <div class="seat">';
					setHtml += '            <ul id="area_Map">';
					setHtml += '            </ul>';
					setHtml += '        </div>';
					setHtml += '    </div>';
					setHtml += '</div>';
					
					seat_select.append(setHtml);

					var el = document.querySelector('.part_map');
					var pinchzoom = new PinchZoom.default(el, {});
				} else {
					var part_select = $("#part_select");
					part_select.empty();
					
					var setHtml = '';
					setHtml += '<div id="floor_gui_seat" class="gui_seat mapbottom pinch-zoom-parent">';
					setHtml += '    <div class="floor_map pinch-zoom" style="background-repeat: no-repeat; background-position: center center">';
					setHtml += '        <div class="floor">';
					setHtml += '            <ul id="floor_area_Map">';
					setHtml += '            </ul>';
					setHtml += '        </div>';
					setHtml += '    </div>';
					setHtml += '</div>';
					
					part_select.append(setHtml);
					
					var partSelect = document.querySelector('#part_select');
					var el = document.querySelector('.pinch-zoom');
					var pinchzoom = new PinchZoom.default(el, {});
				}
			},
			fn_seatSearch : function() {
				var searchSeatCd = $("#searchSeatCd").val();
				$("#" + searchSeatCd).attr("tabindex", -1).focus();
			},
			fn_SmsCertifi : function() {
				var entryDvsn = $("#entryDvsn").val();
				var certifiNm = $("#" + entryDvsn + "_resvUserNm").val();
				var certifiNum = $("#" + entryDvsn + "_resvUserClphn").val();
				
				if(certifiYn) {
					fn_openPopup("이미 인증을 진행하였습니다.", "red", "ERROR", "확인", "");
					return;
				} else {
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
						    	resvUserNm = certifiNm;
						    	resvUserClphn = certifiNum;
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
				}
			},
			fn_checkCertifiCode : function() {
				var entryDvsn = $("#entryDvsn").val();
				var inCertifiCode = $("#" + entryDvsn + "_resvCertifiCode").val();
				
				if(inCertifiCode == "") {fn_openPopup("인증번호를 입력해주세요", "red", "ERROR", "확인", ""); return;}
				if(inCertifiCode != certifiCode) {fn_openPopup("인증번호가 일치하지 않습니다.", "red", "ERROR", "확인", ""); return;}
				
		    	fn_openPopup("정상적으로 인증되었습니다.", "blue", "SUCCESS", "확인", "");
		    	certifiYn = true;
			},
			fn_checkForm : function() {
				var entryDvsn = $("#entryDvsn").val();
				var url = "/front/updateUserResvInfo.do";
				
				if(entryDvsn != "ENTRY_DVSN_1" && $("#seatCd").val() == "") {fn_openPopup("좌석을 선택해주세요", "red", "ERROR", "확인", ""); return;}
				if(!isMember && !certifiYn) {fn_openPopup("본인인증을 진행해주세요", "red", "ERROR", "확인", ""); return;}					
				if(!$("input:checkbox[id='" + entryDvsn + "_qna_check']").is(":checked")) {fn_openPopup("전자문진표 작성여부에 동의해주세요", "red", "ERROR", "확인", ""); return;}
				if(!$("input:checkbox[id='" + entryDvsn + "_person_agree']").is(":checked") && !isMember) {fn_openPopup("개인정보 수집 이용여부에 대하여 동의해주세요", "red", "ERROR", "확인", ""); return;}
				
				var resvDate = $("#resvDate").val().substring(0,4) + "-" + $("#resvDate").val().substring(4,6) + "-" + $("#resvDate").val().substring(6,8);
				$("#rsv_date").html(resvDate);
				$("#rsv_center").html($(".sel_center_nm").html());
				
				if(entryDvsn != "ENTRY_DVSN_1") {
					$("#rsv_part").html($(".sel_part_nm").html());
					$("#rsv_floor").html($(".sel_floor_nm").html());
					$("#rsv_seat").html($(".sel_seat_nm").html());
				} else {
					$("#rsv_seat").html("입석").show();					
				}
				
				$("#rsv_done").bPopup();
			},
			fn_setResvInfo : function() {
				var entryDvsn = $("#entryDvsn").val();
				var url = "/front/updateUserResvInfo.do";
				var params = {};
				
				// 동일자 예약 중복 체크
				params = {
					"userDvsn" : $("#userDvsn").val(), 
					"userId" : $("#userId").val(), 
					"userPhone" : resvUserClphn,
					"resvDate" : $("#resvDate").val()
				};
				
				if(fn_resvDuplicateCheck(params)) {fn_openPopup("현재 예약일자에 이미 예약정보가 존재합니다.", "red", "ERROR", "확인", ""); return;}
						
				// 예약 유효성 검사
				var checkDvsn = entryDvsn == "ENTRY_DVSN_1" ? "STANDING" : "SEAT";
				params = {
					"checkDvsn" : checkDvsn,
					"entryDvsn" : entryDvsn,
					"centerCd" : $("#centerCd").val(),
					"floorCd" : $("#floorCd").val(),
					"partCd" : $("#partCd").val(),
					"seatCd" : $("#seatCd").val(),
					"userId" : $("#userId").val()
				}
					
				var result = fn_resvVaildCheck(params);
				if(result.resultCode != "SUCCESS") {return;}
				
				params = {
					"mode" : "Ins",
					"resvDate" : $("#resvDate").val(),
					"resvUserDvsn" : $("#userDvsn").val(),
					"resvEntryDvsn" : entryDvsn,
					"seasonCd" : $("#seasonCd").val(),
					"centerCd" : $("#centerCd").val(),
					"floorCd" : $("#floorCd").val(),
					"partCd" : $("#partCd").val(),
					"seatCd" : $("#seatCd").val(),
					"resvUserNm" : resvUserNm,
					"resvUserClphn" : resvUserClphn,
					"resvUserAskYn" : $("input:checkbox[id='" + entryDvsn + "_qna_check']").val(),
					"resvIndvdlinfoAgreYn" : $("#" + entryDvsn + "_person_agree").val()
				}
				
				params.resvPayCost = entryDvsn == "ENTRY_DVSN_2" ? $("#" + $("#seatCd").val()).data("seat-paycost") : 0;
/* 				if($("input:checkbox[id='" + entryDvsn + "_bill_confirm']").is(":checked")) {
					params.resvRcptYn == "Y"
					params.resvRcptDvsn = $("input[name='" + entryDvsn + "_rcpt_dvsn']:checked").val(); 
					params.resvRcptNumber = $("#" + entryDvsn + "_cash_number").val();
					
					if(params.resvRcptNumber == "") {
						fn_openPopup("현금 영수증 번호를 입력해주세요", "red", "ERROR", "확인", "");
						return;
					}
				} else {
					params.resvRcptYn == "N"
					params.resvRcptDvsn = "";
					params.resvRcptNumber =  "";
				} */

				fn_Ajax
				(
				    url,
				    "POST",
				    params,
					false,
					function(result) {
				    	if (result.status == "SUCCESS"){
				    		if(result.resvInfo != null) {	
				    			bPopupClose('rsv_done');
				    			fn_openPopup("예약정보가 정상적으로 등록되었습니다.", "blue", "SUCCESS", "확인", "javascript:location.replace('/front/main.do');");
				    			setTimeout("location.replace('/front/main.do')", 5000);
				    		}
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
			fn_billConfirmChange : function() {
				var entryDvsn = $("#entryDvsn").val();
				if($("input:checkbox[id='" + entryDvsn + "_bill_confirm']").is(":checked")) {
					$("#" + entryDvsn  + "_cash_area").show();
					$("input:radio[name='" + entryDvsn + "_rcpt_dvsn']").eq(0).prop("checked", true);
					$("#" + entryDvsn + "_cash_number").val("");
				} else {
					$("#" + entryDvsn  + "_cash_area").hide();
				}
			},
			fn_initializing : function(division) {
				if(division == "ALL") {
					$("#section_sel, #tab-a").hide();
					$("#floorCd, #partCd, #seatCd").val("");
					$(".sel_floor_nm, .sel_part_nm, .sel_seat_nm").html("");
				} else if (division == "FLOOR") {
					$("#section_sel").show();
					$("#tab-a").hide();
					$("#partCd, #seatCd").val("");
					$(".sel_part_nm, .sel_seat_nm").html("");
				} else if (division == "PART") {
					$("#tab-a").show();
					$("#seatCd").val("");
					$(".sel_seat_nm").html("");
				}
				
				$("#seasonCd").val("");
			}
		}
    </script>
 
 	<c:import url="/front/inc/popup_common.do" />
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>
	</form:form>
</body>
</html>