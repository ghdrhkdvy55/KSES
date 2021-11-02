<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no;" />
    <title>경륜경정 스마트입장 관리자</title>
    <link rel="stylesheet" href="../css/reset.css">
	<link rel="stylesheet" href="../css/paragraph.css">
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap" />
    <script src="../js/jquery-3.5.1.min.js"></script>
    <script src="../js/bpopup.js"></script>
    <link href="../css/magic-check.min.css" rel="stylesheet" />
</head>
<body>
    <form name="regist" method="post" action="/backoffice/SecurityLogin.do" autocomplete="off">
    <div class="wrapper loginBack ">
        <div class="logoImg"><img src="../img/logo1.png" alt="logo"></div>
        
        <div class="loginBox">
            <h2 class="title">관리자 로그인</h2><div class="clear"></div>
            <div class="log_box">
                <h1 class="logo"></h1>
            </div>
            <div class="loginArea">
                <ul>
                    <li>
                        <span class="id_icon"><spring:message code='page.login.id' /></span>                    
                        <input type="text" name="adminId" id="adminId" placeholder="<spring:message code='page.login.id' />" class="form-control">	
                                                                    
                    </li>
                    <li>
                        <span class="pw_icon"><spring:message code='page.login.password' /></span>
                        <input type="password" name="adminPassword" id="adminPassword" placeholder="<spring:message code='page.login.password' />"    autocomplete="off"/>	
                    </li>
                </ul>
            <div class="check_wrap">
                <ul>
                    <li>
                        <input class="magic-checkbox" type="checkbox" name="layout" id="1" value="option">
                        <label for="">사번 기억하기</label>
                    </li>

                </ul>                
            </div>
            <div class="clear"></div>
            <div>
                <button type="button" data-popup-open="savePage" onClick='form_check();' class="no_login loginBtn">로그인</button>
            </div>
        </div>
        
        <!-- popup //-->
    </div>
    </form>
    <!-- //popup -->
    <!--저장확인팝업-->
    <div data-popup="savePage" class="popup m_pop">
      <div class="pop_con">
        <a href="javascript:;" class="button b-close">X</a>
        <p class="pop_tit">관리자 화면 로그인</p>
        <p class="pop_wrap">재시도 해주세요.</p>
      </div>
    </div>
    <script src="/resources/js/common.js"></script>
    <script type="text/javascript">
    function form_check(){
       if (any_empt_line_id("adminId", "<spring:message code='page.common.alert01' />") == false) return;
 	   if (any_empt_line_id("adminPassword", "<spring:message code='page.common.alert02' />") == false) return; 
 	   $("form[name=regist]").attr("action", "/backoffice/SecurityLogin.do").submit(); 	   
    }       
    $(document).ready(function() {
	    	if ("${message}" != "") {
	    		  if ("${message}" == "login_ok"){
	    			  alert("2")
	    			  location.href="/backoffice/resManage/resList.do?searchRoomType=swc_gubun_1";  
	    		  }else {
	    			  alert("<spring:message code='page.common.alert03' />");
		    		  $("#admin_id").focus() ;	    			  
	    		  }				
	    	}    	           	    	
    });  
    </script>
</body>
</html>