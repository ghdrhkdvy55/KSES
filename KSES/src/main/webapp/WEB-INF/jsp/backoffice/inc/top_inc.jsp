<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import ="egovframework.com.cmm.LoginVO" %>
<%@ page import ="java.util.List" %>
<%@ page import ="java.util.Map" %>
<%
LoginVO loginVO = (LoginVO)session.getAttribute("LoginVO");
if(loginVO == null ){
	
	%>
	<script type="text/javascript">
	location.href="/backoffice/login.do";
	</script>
	<%        
}else{ 
	
	String referer = request.getHeader("referer");
	referer = referer.replaceAll("(?i:https?://([^/]+)/.*)", "$1");
	
	
	%> 
    
<div class="header_wrap">
	<!--// top -->
	<%=referer %><br/>
	<%=request.getRequestURL() %>
	<br/>
	<%=request.getRequestURI() %>
	<br/>
	<%=request.getServletPath() %>
	<br/>
    <header>
		<ul id="header" class="contents">
        	<li class="logo"><h1>경륜경정 스마트 입장시스템</h1></li>
        	<li class="toggle"><a href="#" onclick="toggleNav()" class="menu"></a></li>
        	<li class="logo1"><img src="/resources/img/logo1.png" alt=""></li>
        	<li class="member"><img src="/resources/img/login.png" alt=""><span><%=loginVO.getAdminId() %></span> 님</li>
      	</ul>
    </header>
    <!--top //-->
    <!--// menu list -->
    <script type="text/javascript">
    $(document).ready(function() { 
    	    
		   fn_menuCreate();
	});
	function fn_menuCreate (){
		
		var menu = uniAjaxReturn("/backoffice/inc/user_menu.do", "POST", false, null,  "lst");
		for (var i in menu){	
			 if  (menu[i].level == "2"){
				 var ul_list = $("#ul_menu"); //ul_list선언
				 ul_list.append("<li id='"+menu[i].menu_no+"'></li>");
				 $("#"+menu[i].menu_no+"").append("<button type='button' onClick='fn_menuClick("+menu[i].menu_no+")' class='sub_menu' id='bn_"+menu[i].menu_no+"'>"+menu[i].menu_nm+"</button>");
				 $("#bn_"+menu[i].menu_no +"").after("<div id='dv_"+menu[i].menu_no+"' class='panel'></div>");
			 }else {
				 var dv_list = $("#dv_"+menu[i].upper_menu_no+""); //ul_list선언
				 dv_list.append("<a href='"+menu[i].url+"' id='"+menu[i].menu_no+"'>"+menu[i].menu_nm+"</a>");
			 }
		 }
		toggleNav();
	}
	/* menu */
	function toggleNav() {
	    if (document.getElementById("mySidenav").style.width == "0") {
	        closeNav(); 
	    } else { 
	        openNav(); 
	    }
	}
	function openNav() {
	  document.getElementById("mySidenav").style.width = "200px";
	  document.getElementById("contents").style.marginLeft = "200px";
	}
	function closeNav() {
	  document.getElementById("mySidenav").style.width = "0";
	  document.getElementById("contents").style.marginLeft= "0";
	}
    function fn_menuClick(id){
    	var acc = document.getElementsByClassName("sub_menu");
    	var i;
    	for (i = 0; i < acc.length; i++) {
    		acc[i].classList.toggle("toggle_off");
    		var panel = acc[i].nextElementSibling;
    		panel.style.display = "none";
    		
    	}
    	var block_pn = ($("#dv_"+id).prop('style') == "block") ? "display:none" : "display:block";
    	$("#bn_"+id).prop('class','sub_menu toggle_on');
    	$("#dv_"+id).prop('style', block_pn); 
    	
    }
	
    </script>
    
    
    <div id="mySidenav" class="sidenav">
		<ul id="ul_menu">
			                                
		</ul>
	</div>
    <!-- menu list //-->
</div>
 <%
     }
 %>
 