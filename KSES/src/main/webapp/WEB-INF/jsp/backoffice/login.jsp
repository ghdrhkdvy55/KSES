<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <title>경륜경정 스마트입장 관리자 로그인</title>
    <link rel="stylesheet" href="/resources/css/reset.css">
	<link rel="stylesheet" href="/resources/css/paragraph.css">    
    <link rel="stylesheet" href="/resources/css/widescreen.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <link rel="stylesheet" href="/resources/css/magic-check.min.css">
    <script src="/resources/js/jquery-3.5.1.min.js"></script>
    <!-- toastr -->
    <link rel="stylesheet" href="/resources/toastr/toastr.min.css">
    <script type="text/javascript" src="/resources/toastr/toastr.min.js"></script>
</head>
<body>
    <form name="regist" method="post" style="height:100%">
	    <div class="wrapper loginBack">
	    	<div class="loginBox">
	    		<div class="log_box">
	                <h1 class="logo"></h1>
	            </div>
	            <div class="loginArea">
	            	<ul>
	            		<li>
	            			<span class="id_icon">사번</span>
	            			<div class="text-clear">
	            				<input type="text" name="adminId" placeholder="사번을 입력해주세요." class="form-control" style="ime-mode:inactive;" autocomplete="off" tabindex="1">
	            				<label id="id_wrong" style="color:red"></label>
	            			</div>
	            		</li>
	            		<li>
	            			<span class="pw_icon">비밀번호</span>
	            			<div class="text-clear">
	            				<input type="password" name="adminPwd" placeholder="비밀번호를 입력해 주세요." tabindex="2">
	            				<label id="pw_wrong" style="color:red"></label>
	            			</div>
	            		</li>
	            	</ul>
	            	<div class="check_wrap">
	            		<ul>
	            			<li>
	            				<input type="checkbox" id="1" class="magic-checkbox">
	            				<label class="text" for="1">사번 기억하기</label>
	            			</li>
	            		</ul>
	            	</div>
	            	<div class="clear"></div>
	            	<div>
	            		<button type="button" class="no_login loginBtn">로그인</button>
	            	</div>
	            </div>
	    	</div>
	    </div>
	</form>
	<script type="text/javascript">
		const loginError = '${param.login_error}';
		$(document).ready(function() {
			switch (loginError) {
				case '1':
					toastr.warning('<spring:message code="page.common.alert03"/>');
					break;
				case '2':
					toastr.error('세션이 종료되어 로그인 페이지로 이동되었습니다.');
					break;
				default:
			}
			
			$('button').click(function() {
				fnLogin();
			});
			
			$('body').keydown(function(e) {
				if (e.keyCode === 13) {
					fnLogin();
				}
			});
		});
		
		function fnLogin() {
			let $username = $(':text[name=adminId]');
			if ($username.val() === '') {
				toastr.warning('<spring:message code="page.common.alert01"/>');
				$username.css('border-color', 'red');
				setTimeout(() => $username.focus(), 0);
				return false;
			}
			let $password = $(':password[name=adminPwd]');
			if ($password.val() === '') {
				toastr.warning('<spring:message code="page.common.alert02"/>');
				$password.css('border-color', 'red');
				setTimeout(() => $password.focus(), 0);
				return false;
			}
			document.regist.action = '<c:url value="/backoffice/actionSecurityLogin.do"/>';
			document.regist.submit();
		}
	</script>
</body>
</html>