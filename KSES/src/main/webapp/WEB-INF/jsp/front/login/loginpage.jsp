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
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" >
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
	<input type="hidden" id="login_type" name="login_type" value="1">
    
    <div class="wrapper">
        <div class="login_wrap">
            <div class="log_box">
                <h1 class="login_tit"><a href="javascript:history.back();" class="back_ico"><img src="/resources/img/front/back.svg" alt="뒤로가기"></a>로그인</h1>
            </div>
            
            <div class="loginArea">
                <div id="tab-menu">
                    <div class="login_num_info" id="tab_btn">
                        <ul>
                          <li id="id_login_tab"><a href="javascript:;" onclick="loginService.changeLoginType('1')">아이디 로그인</a></li>
                          <li id="card_login_tab" class="active"><a href="javascript:;" onclick="loginService.changeLoginType('2')">카드번호 로그인</a></li>
                        </ul>
                    </div>
                    <div id="tab_cont">
                        <div>
                            <ul>
                                <li>
                                <%-- <form id="idForm" class="checkNo"> --%>
                                    <form id="idForm" onsubmit="return false;">
                                        <input type="text" id="id" name="id" placeholder="아이디를 입력해주세요." class="login-form " value="" />
                                          
                                        <input type="reset" class="input_reset hidden">
                                        <span class="checkNo_icon" style="display : none;"></span>
                                        <p class="check_noti" style="display : none;"></p>
                                    </form>
									<form id="cardNoForm" onsubmit="return false;" style="display:none;">
                                        <input type="text" id="cardNo" name="cardNo" placeholder="카드번호를 입력해주세요." class="login-form " value=""/>
                                        <input type="reset" class="input_reset hidden">
                                        <span class="checkNo_icon" style="display : none;"></span>
                                        <p class="check_noti" style="display : none;"></p>
                                    </form>
                                    
                                </li>
                                <li>
                                    <form id="pwForm" onsubmit="return false;">
                                        <input type="password" id="pw" name="pw" placeholder="비밀번호를 입력해 주세요." class="login-form " value=""/> 
                                        <input type="reset" class="input_reset hidden">
                                        <span class="checkNo_icon" style="display : none;"></span>
                                        <p class="check_noti" style="display : none;"></p>
                                    </form>
									<form id="cardPwForm" onsubmit="return false;" style="display:none;">
                                        <input type="password" id="cardPw" name="cardPw" placeholder="비밀번호를 입력해 주세요." class="login-form " value=""/> 
                                        <input type="reset" class="input_reset hidden">
                                        <span class="checkNo_icon" style="display : none;"></span>
                                        <p class="check_noti" style="display : none;"></p>
                                    </form>                                    
                                </li>
                            </ul>
                            <div class="check_wrap">
                                <ul>
                                    <li id="saveIdArea">
                                        <input class="magic-checkbox" type="checkbox" name="layout" id="saveId" value="option" class="pass-form ">
                                        <label for="saveId"></label>
                                        <label class="text" for="saveId">
                                           	아이디 저장
                                        </label>
                                    </li>
									<li id="saveCardNoArea" style="display:none;">
                                        <input class="magic-checkbox" type="checkbox" name="layout" id="saveCardNo" value="option" class="pass-form ">
                                        <label for="saveCardNo"></label>
                                        <label class="text" for="saveCardNo">
                                           	카드번호 저장
                                        </label>
                                    </li>                           
                                </ul>
                                <div class="clear"></div>
                            </div>               
                            <button type="button" id="Login-btn" onclick="loginService.checkForm()" class="loginBtn">로그인</button> 
                        </div>
                    </div>
                </div>
            </div>
		</div>        
        <div id="loading" class="loading"></div>
    </div>
    
	<!-- //1214 개인정보동의 팝업 -->
	<div id="agreeCheck" class="popup">
		<div class="pop_con rsv_popup">
			<a class="button b-close">X</a>
          	<div class="pop_wrap">
				<h4>&lt;개인정보 수집 이용 동의 안내&gt;</h4>
              	<!--개인정보동의-->
				<div class="person_check nonMemberArea">
					<p>										
						<ol>
							<li>코로나 19 확산 방지를 위하여 다음과 같이 개인정보 수집 이용 및 제 3자 제공에 대한 동의를 얻고자 합니다.</li>
							<li class="prsn_agree"><a data-popup-open="person_agree">자세히 ></a></li>
							<br>
							<li class="check_impnt">
								<input class="magic-checkbox qna_check" type="checkbox" name="layout" id="person_agree_yn" value="Y">
								<label for="person_agree_yn">동의합니다.</label>     
							</li>
						</ol>
					</p>
				</div>
			</div>
			<div class="cancel_btn">
              	<a href="javascript:void(0);" class="grayBtn">확인</a>
          	</div>
			<div class="clear"></div>
		</div>
    </div>		
    				
	<!-- // 개인정보 수집이용 약관 팝업 -->
    <div id="person_agree" data-popup="person_agree" class="popup">
    	<div class="pop_con rsv_popup">
          	<a class="button b-close">X</a>
          	<div class="pop_wrap">
            	<div class="text privacy_text">
                	<p class="font14 mg_l20">개인정보 수집·이용 및  제 3자 제공 동의서</p><br>                
                	<p class="font13 mg_l20">코로나19 확산방지를 위하여 경주사업총괄본부에서는 다음과 같이 개인정보 수집·이용 및 제 3자 제공에 대한 동의를 얻고자 합니다.</p>
                
                	<div class="tablet_wrap">
                         <div class="pd_l10 pd_r10">
                        	<p class="font13 mg_l10">▶ 개인정보수집·이용 동의</p>
                        	<table class="tb3" summary="개인정보수집·이용 동의">
                            	<caption>개인정보수집·이용 동의</caption>
                            	<colgroup>
                                	<col width="34%">
                                	<col width="33%">
                                	<col width="33%">
                            	</colgroup>
                            	<thead>
                                	<tr>
                                    	<th scope="col">항목</th>
                                    	<th scope="col">수집목적</th>
                                    	<th scope="col">보유기간</th>
                                	</tr>
                            	</thead>
                            	<tbody>             
	                                <tr>
	                                    <td>성명,전화번호,<br>출입시설,출입시간</td>
	                                    <td>코로나19 확진자<br>발생시 역학조사 및 <br>안내문자 발송</td>
	                                    <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">4주</td>
	                                </tr>                                              
                            	</tbody>
                        	</table><br>
                        
                        	<p class="font13 mg_l10">▶ 개인정보 제3자 제공 동의</p>
                        	<table class="tb3" summary="개인정보 제3자 제공 동의">
                            	<caption>개인정보 제3자 제공 동의</caption>
                            	<colgroup>
	                                <col width="27%">
	                                <col width="29%">
	                                <col width="26%">
	                                <col width="18%">
                            	</colgroup>
								<thead>
                                <tr>
                                    <th scope="col">제공받는 기관</th>
                                    <th scope="col">제공목적</th>
                                    <th scope="col">제공항목</th>
                                    <th scope="col">보유기간</th>
                                </tr>
                            </thead>
                            <tbody>             
                                <tr>
                                    <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">보건복지부,<br>질병관리청,<br>지자체</td>
                                    <td class="text_center" style="color:red; font-size:11px; font-weight:bold;">코로나19<br>확진자 발생 시<br>역학조사</td>
                                    <td>성명,전화번호,<br>출입시설,출입시간</td>
                                    <td class="text_center" style="color:red; font-size:12px; font-weight:bold;">4주</td>
                                </tr>
                            </tbody>
                        </table>
                    </div><br>
                    
                    <p class="font13 mg_l20">※위의 개인정보 수집·이용 및 3자 제공에 대한 동의를 거부할 권리가 있습니다. 그러나 동의를 거부할 경우 출입이 제한될 수 있습니다. </p><br>
                </div>                
            </div>
          </div>
          <div class="cancel_btn">
              <a href="" class="grayBtn">닫기</a>
          </div>
          <div class="clear"></div>
      </div>
    </div>				
    				
	<script type="text/javascript">
		var loginService = 
		{
			// 로그인 방식 변경
			// 1 : 아이디&비밀번호  / 2 : 카드번호&비밀번호 
			changeLoginType: function(loginType) {
				if($("#login_type").val() == loginType) {
					return;
				} else {
					$("#idForm, #pwForm, #cardNoForm, #cardPwForm").removeClass("checkNo");
					$("#idForm p,span, #pwForm p,span, #cardNoForm p,span, #cardPwForm p,span").hide();		
					
					$("#login_type").val(loginType);

					if(loginType == "1"){
						$("#idForm, #pwForm, #saveIdArea").show();
						$("#cardNoForm, #cardPwForm, #saveCardNoArea").hide();
					} else {
						$("#idForm, #pwForm, #saveIdArea").hide();
						$("#cardNoForm, #cardPwForm, #saveCardNoArea").show();
					}					
				}
			},
			// 로그인 유효성 검사
			checkForm : function() {
				var idNotiText = $("#login_type").val() == 1 ? "*아이디를 입력해주세요" : "*카드번호를 입력해주세요"; 
				var pwNotiText = $("#login_type").val() == 1 ? "*비밀번호를 입력해주세요" : "*카드 비밀번호를 입력해주세요";
				var idTag = $("#login_type").val() == 1 ? "#id" : "#cardNo";
				var pwTag = $("#login_type").val() == 1 ? "#pw" : "#cardPw";
				
				var checkList = 
				[
					{
						"tag" : idTag,
						"noti" : idNotiText
					},
					{
						"tag" : pwTag,
						"noti" : idNotiText
					}
				];
				
				// 기존 noti관련 class&tag 제거 및 hide처리
				$("#idForm, #pwForm").removeClass("checkNo");
				$("#idForm p,span, #pwForm p,span").hide();
				
				var valid = true;
				$.each(checkList, function(index, item) {
					if($(item.tag).val() == "") {
						$(item.tag + "Form").addClass("checkNo");
						$(item.tag + "Form p,span").show();
						$(item.tag + "Form p").html(idNotiText);	
						return valid = false;
					} else {
						$(item.tag + "Form").removeClass("checkNo");
						$(item.tag + "Form p,span").hide();
					} 
				});
				
				if(valid){
					loginService.actionLogin();	
				}
			}, 
			// 로그인 시작
			actionLogin : function() {
				var url = "/backoffice/rsv/speedCheck.do";
				var params = {
					"gubun" : "login",
					"sendInfo" : {
						"Login_Type" : $("#login_type").val(),
						"User_Id" : $("#id").val(),
						"User_Pw" : $("#pw").val(),
						"Card_No" : $("#cardNo").val(),
						"Card_Id" : $("#cardNo").val(),
						"Card_Pw" : $("#cardPw").val(),
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
							if (result.regist.Error_Msg == "SUCCESS" || result.userInfo != null) {
								console.log(result.userInfo.indvdlinfoAgreDt);
								if(result.userInfo.indvdlinfoAgreDt != null && result.userInfo.indvdlinfoAgreDt != "") {
									loginService.createUserSession(result.userInfo);									
								} else {
									$("#agreeCheck .cancel_btn a:eq(0)").click(function () {
										loginService.indvdlinfoAgre(result.userInfo);	
									});
									
									$("#agreeCheck").bPopup();	
								}
							} else {
								fn_openPopup(result.regist.Error_Msg, "red", "ERROR", "확인", "");
							}
				    	} else {
				    		fn_openPopup("로그인중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");
				    	}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);	
			},
			// 로그인 유저 세션 생성
			createUserSession : function(userInfo) {
				var url = "/front/userSessionCreate.do";
				
				fn_Ajax
				(
				    url,
				    "POST",
				    userInfo,
					false,
					function(result) {
				    	if (result == "SUCCESS") {
				    		if($("#login_type").val() == "1") {
				    			$("input:checkbox[id='saveId']").is(":checked") ? 
				    					localStorage.setItem("saveId", $("#id").val()) :
										localStorage.removeItem("saveId");
				    		} else if($("#login_type").val() == "2") {
				    			$("input:checkbox[id='saveCardNo']").is(":checked") ? 
				    					localStorage.setItem("saveCardNo", $("#cardNo").val()) :
										localStorage.removeItem("saveCardNo");				    			
				    		}

				    		location.href = "/front/main.do";
				    	} else {
				    		alert("ERROR : " + result.status);	
				    	}
					},
					function(request) {
						alert("ERROR : " + request.status);	       						
					}    		
				);	
			},
			indvdlinfoAgre : function(userInfo) {
				if(!$("input:checkbox[id='person_agree_yn']").is(":checked")) {
					fn_openPopup("개인정보 수집 이용여부에 대하여 동의해주세요", "red", "ERROR", "확인", "");
					return;
				}
				
				userInfo.indvdlinfoAgreYn = $("#person_agree_yn").val();
				loginService.createUserSession(userInfo);
			}
		}	
	</script>
	<!--loading -->
	<c:import url="/front/inc/popup_common.do" />
	<script src="/resources/js/front/jquery-spinner.min.js"></script>
	<script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>
	<script type="text/javascript">
		window.onload = function() {
			var saveList = ["saveId", "saveCardNo"];
			
			$.each(saveList, function(index, item) {
				if(localStorage.getItem(item) != null) {
					var tag = item == "saveId" ? "#id" : "#cardNo";
					$(tag).val(localStorage.getItem(item));
					$("input:checkbox[id='" + item + "']").prop("checked", true);
				}
			});
			
		    $("input[name=id],input[name=pw],input[name=cardPw],input[name=cardNo]").keydown(function (key) {
		        if(key.keyCode == 13){
		        	loginService.checkForm();
		        }
		    });
			
			var spinner = new jQuerySpinner({
				parentId: 'loading'
			});
	    	
			document.getElementById("loading").addEventListener("click", function(evt) {
				spinner.show();
				setTimeout(function() {
					spinner.hide();
				}, 2000);
			});
		}
	</script>
</body>  
</html>