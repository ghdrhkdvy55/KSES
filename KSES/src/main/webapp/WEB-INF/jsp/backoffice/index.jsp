<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <title>경륜경정 스마트입장 관리자</title>
    <link rel="stylesheet" href="/resources/css/reset.css">
	<link rel="stylesheet" href="/resources/css/paragraph.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <link rel="stylesheet" href="/resources/css/toggle.css">
    <!-- JQuery -->
    <script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
    <!-- JQuery UI -->
    <link rel="stylesheet" type="text/css" href="/resources/css/jquery-ui.css">
    <script type="text/javascript" src="/resources/js/jquery-ui.js"></script>
    <!-- bPopup -->
    <script src="/resources/js/bpopup.js"></script>
</head>
<body>
<input type="hidden" id="loginAuthorCd" name="loginAuthorCd" value="${LoginVO.authorCd}">
<input type="hidden" id="loginCenterCd" name="loginCenterCd" value="${LoginVO.centerCd}">
<div class="wrapper">
	<div class="header_wrap">
		<header>
			<ul id="header" class="contents">
				<li class="logo"><h1>경륜경정 스마트 입장시스템</h1></li>
	        	<li class="toggle"><a href="#" onclick="toggleNav();" class="menu"></a></li>
	        	<li class="logo1"><img src="/resources/img/logo1.png" alt=""></li>
	        	<li class="logout"><img src="/resources/img/logout.png" alt="로그아웃"><a href="/backoffie/actionLogout.do">로그아웃</a></li>
	        	<li class="member"><img src="/resources/img/login.png" alt=""><span>${LoginVO.empNm}</span> 님</li>
			</ul>
		</header>
		<div id="mySidenav" class="sidenav">
			<ul></ul>
		</div>
	</div>
	<div id="contents"></div>
</div>
<script type="text/javascript" src="/resources/js/common.js"></script>
<script type="text/javascript" src="/resources/js/back_common.js"></script>
<script type="text/javascript">
	jQuery.browser = {};
	(function () {
	    jQuery.browser.msie = false;
	    jQuery.browser.version = 0;
	    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
	        jQuery.browser.msie = true;
	        jQuery.browser.version = RegExp.$1;
	    }
	})();
	$(document).ready(function() {
		var menu = uniAjaxReturn("/backoffice/inc/user_menu.do", "POST", false, null,  "lst");
		for (let m of menu) {
			switch (m.level) {
				case 2:
					let $li = $('<li></li>').appendTo('#mySidenav ul');
					$('<button type="button" class="sub_menu toggle_off">'+ m.menu_nm +'</button>').click(function() {
						var hasClass = $(this).hasClass('toggle_on');
						$('#mySidenav button').removeClass('toggle_on toggle_off').addClass('toggle_off');
						$('#mySidenav div').css('display', 'none');
						if (hasClass) {
							$(this).removeClass('toggle_on').addClass('toggle_off');
							$(this).next().css('display', 'none');
						} else {
							$(this).removeClass('toggle_off').addClass('toggle_on');
							$(this).next().css('display', 'block');
						}
					}).appendTo($li);
					$li.append('<div class="panel" style="display:none;"></div>');
					break;
				case 3:
					$('<a href="/backoffice/actionMain.do?menuId='+ m.menu_no +'" id="'+ m.menu_no +'">'+ m.menu_nm + '</a>').data('menu', m).appendTo('#mySidenav div.panel:last');
					break;
				default:
			}
		}
		let menuId = fnGetUrlParameter('menuId');
		$('#mySidenav a').removeAttr('class');
		if (menuId === undefined || menuId === null) {
			$('#mySidenav a:first').addClass('active');
			$('#mySidenav a:first').closest('div').css('display', 'block');
		} else {
			$('#mySidenav a#'+ menuId).addClass('active');
			$('#mySidenav a#'+ menuId).closest('div').css('display', 'block');
			$('#mySidenav a#'+ menuId).closest('div').prev().removeClass('toggle_off').addClass('toggle_on');
		}
		fnSetActiveContent();
	});

	function fnGetUrlParameter (sParam) {
		var sPageURL = decodeURIComponent(window.location.search.substring(1)), sURLVariables = sPageURL.split('&'), sParameterName, i;
		for (i = 0; i < sURLVariables.length; i++) {
			sParameterName = sURLVariables[i].split('=');
			if (sParameterName[0] === sParam) {
				return sParameterName[1] === undefined ? true : sParameterName[1];
			}
		}
	}

	function fnSetActiveContent() {
		let menu = $('#mySidenav a.active').data('menu');
		$('#contents').load(menu.url);
	}
</script>
</body>
</html>