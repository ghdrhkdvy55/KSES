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
    <!-- popup-->    
    <script src="/resources/js/front/bpopup.js"></script>
    <!--<style>body{background:#f4f4f4 ;}</style>-->
</head>
<body>
    <form:form name="regist" commandName="regist" method="post" action="/front/notice.do">
	<input type="hidden" name="userDvsn" id="userDvsn" value="${sessionScope.userLoginInfo.userDvsn}">
	<input type="hidden" name="userId" id="userId" value="${sessionScope.userLoginInfo.userId}">
    
    <input type="hidden" id="pageIndex" name="pageIndex" value="1">
    <input type="hidden" id="pageSize" name="pageSize" value="10">
    <input type="hidden" id="totalPageCount" name="totalPageCount" value="10">
    <input type="hidden" id="centerCd" name="centerCd" value="Not">
  
    <div class="wrapper">
        <!--// header -->
        <div class="my_wrap">
            <div class="contents my_box hd_wrapper">
                <div class="navi_left">
                    <a href="/front/main.do" class="before_close"></a>
                </div>
                <h1>공지사항<a href="" class="close"><img src="/resources/img/front/x_box.svg" alt="닫기"></a></h1>
                <button class="noti_h_icon ui-dropper" data-drop="notice_view_de"">필터</button>              
                <div class="clear"></div>
            </div>           
        </div>
        <!-- header //-->
        <!--// contents-->
        <div id="container">
            <!-- // 공지사항 -->
            <div class="contents cotents_wrap">
                <!-- 공지사항 데이터 -->
                <div>
                    <div class="notice_con">
                        <p class="notice_cat">전체공지</p>
                        <p class="notice_date">11.30 수</p>
                        <p class="notice_tit"><span>코로나 19 방역에 따라 경기 일정이 변경 되었습니다.</span></p>
                    </div>
                    <!--공지사항 내용 -->
                    <div class="notice_inner">코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나코로나 19 방역 수칙에 따른 이용자 명부 작성 필수 코로나
                    </div>
                </div>
                                 
            </div>
        </div>
        <!--contents //-->
    </div>  
    <!-- 공지사항 필더 -->
    <div id="notice_view_de" class="ui-dropdown order_op_pop">
        <ul>
        
            <li><a href="javascript:notice.fn_boardCng('NOT')">전체 공지</a></li>
            <c:forEach items="${centerInfo}" var="centerInfo">
				 <li><a href="javascript:notice.fn_boardCng('${centerInfo.center_cd}')">${centerInfo.center_nm}</a></li>
			</c:forEach>
            
        </ul>
    </div>
    </form:form>
	<c:import url="/front/inc/popup_common.do" />
    <script src="/resources/js/front/common.js"></script>
	<script src="/resources/js/front/front_common.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            //ui- dropdown
            $('.ui-dropdown').menu().hide();
            $('.ui-dropper').click(function () {
                // data-drop value and create ID to target dropdown
                var menu = $('#' + $(this).attr('data-drop'));

                // hide all OTHER dropdowns when we open one
                $('.ui-menu:visible').not('#' + $(this).attr('data-drop')).hide();

                // position the dropdown to the right, so it works on all buttons
                // buttons at far right of screen will have menus flipped inward to avoid viewport collision
                menu.toggle().position({
                    my: " top bottom",
                    at: "top bottom",
                    of: this
                });
                // on click of the document, close the menus
                $(document).one("click", function () {
                    //menu.hide();
                    $('.ui-menu:visible').hide();
                });
                return false;
            });
        });
        $(document).ready(function() {
        	$("#centerCd").val("NOT");
        	notice.fn_boardInfo("New");
        	
        });
        $(window).scroll(function(){            
            if($(window).scrollTop() >= ($(document).height() - $(window).height() - 10)){
            	  if( parseInt( $("#pageIndex").val()) < parseInt( $("#totalPageCount").val()) ) {
            		  var pageIndex =  parseInt( parseInt($("#pageIndex").val()) + 1 );
            		  $("#pageIndex").val( pageIndex);
                	  notice.fn_boardInfo("page");
                  }
            }
        });
        
        var notice = {
        		fn_boardInfo  : function (emptyGubun){
        			var url = "/front/boardInfo.do";
        	    	var params = {
           	    			"boardCd" : "Not",
           	    			"pageIndex" : $("#pageIndex").val(),
           	    			"pageSize" : $("#pageSize").val(),
           	    			"searchCenterCd" : $("#centerCd").val()
           	    	}
           	    	fn_Ajax 
           	    	(
           	    			url,
           	    			"POST",
           	    			params,
           	    			false,
           	    			function(result){
           	    				if (result.status == "SUCCESS") {
           	    					$("#totalPageCount").val(result.paginationInfo.totalPageCount);
           	    					
           	    					if (result.resultlist.length>0){
           	    						var sHTML = "";
           	    						if (emptyGubun == "New"){
           	    							$("#container > div> div").empty();
           	    						}
           	    						
           	    						for (var i in result.resultlist){
           	    							var obj = result.resultlist[i];
           	    							sHTML += "<div>"
           	    		                          +  "  <div class='notice_con' id='n_"+obj.board_seq+"'> "                           
           	    		                          +  "     <p class='notice_date'>'"+obj.last_updt_dtm+"'</p>"
           	    		                          +  "     <p class='notice_tit'><span>'"+obj.board_title+"'</span></p>"
           	    		                          +  "	</div>"
           	    		                          +  "	<div class='notice_inner' id='c_"+obj.board_seq+"'>1231313121</div>"
           	    		                          +  "</div>"; 
           	    							$("#container > div> div:last").append(sHTML);
           	    							console.log(sHTML);
           	    							sHTML = "";
           	    						}
           	    						
           	    						 $('.notice_con').click(function(e) {
           	    					         e.preventDefault();
           	    					         var $this = $(this);
           	    					         var id = $(this).attr("id");
           	    					         
           	    					         if ($this.next().hasClass('show')) {
           	    					        	 $("#c_"+ id.replace("n_", "") ).html("");
           	    					             $this.next().removeClass('show');
           	    					             $this.next().slideUp(350);
           	    					         } else {
           	    					        	
           	    					        	 $this.parent().parent().find('.notice_inner').removeClass('show');
           	    					             $this.parent().parent().find('.notice_inner').slideUp(350);
           	    					             $this.next().toggleClass('show');
           	    					             $this.next().slideToggle(350);
           	    					            
           	    					        	 fn_Ajax
          	    									 (
          	    										"/front/boardInfoDetail.do",
          	    										"GET",
          	    										{boardSeq : id.replace("n_", "")},
          	    										false,
          	    										function(result) {
          	    											if (result.status == "SUCCESS") {
          	    												var obj = result.result;
          	    				    	    					$("#c_"+ id.replace("n_", "") ).html(obj.board_cn);
          	    				    	    					if (result.resultlist != undefined){
          	    				    	    						//파일 리스트 표출 
          	    				    	    					}
          	    								            }
          	    								         },
          	    								         function(request) {
          	    								        	 fn_openPopup("ERROR : " + request.status, "red", "ERROR", "확인", "");	
          	    								         }
          	    								     );
           	    					         }
           	    					     });
           	    					}	
           	    				}else{
           	    					fn_openPopup("ERROR : " + request.status, "red", "ERROR", "확인", "");	
           	    				} 
           	    				
           	    			}
           	    	)
        		}, 
        		fn_boardCng : function(centerCd){
        			$("#centerCd").val(centerCd);
        			console.log(centerCd);
        			$("#pageIndex").val("1");
        			notice.fn_boardInfo("New");
        		}
        }
    </script>
</body>
</html>