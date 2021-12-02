<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no;" />
    <title>경륜경정 스마트입장 관리자</title>
    <link rel="stylesheet" href="/resources/css/reset.css">
	<link rel="stylesheet" href="/resources/css/paragraph.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <link rel="stylesheet" href="/resources/css/toggle.css">
    <script src="/resources/js/jquery-3.5.1.min.js"></script>
    <script src="/resources/js/bpopup.js"></script>
    <script>
	jQuery.browser = {};
	(function () {
	    jQuery.browser.msie = false;
	    jQuery.browser.version = 0;
	    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
	        jQuery.browser.msie = true;
	        jQuery.browser.version = RegExp.$1;
	    }
	})();
	</script>
    <link rel="stylesheet" type="text/css" href="/resources/css/jquery-ui.css">
    <link rel="stylesheet" type="text/css" href="/resources/jqgrid/src/css/ui.jqgrid.css">
    <script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
    <script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
    <style type="text/css">
     .ui-jqgrid .ui-jqgrid-htable th div{
		outline-style: none;
		height: 30px;
	 }
     .ui-jqgrid tr.jqgrow {
		outline-style: none;
		height: 30px;
	}
    </style>
    <!-- datepicker-->
    <script src="/resources/js/jquery-ui.js"></script>
    <script type="text/javascript">
	$(document).ready(function() { 
		   jqGridFunc.setGrid("mainGrid");
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
		   yearRange: '2021:2999' //1990년부터 2020년까지
			    };	       
				$("#searchFrom").datepicker(clareCalendar);
				$("#searchTo").datepicker(clareCalendar);
				$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;"); //이미지버튼 style적용
		 $("#ui-datepicker-div").hide(); //자동으로 생성되는 div객체 숨김
	 });
	
	
    var jqGridFunc  = {
    		
    		setGrid : function(gridOption){
    			var grid = $('#'+gridOption);
    		    var postData = {"pageIndex": "1"};
    		    grid.jqGrid({
    		    	url : '/backoffice/sys/selectInterfaceListAjax.do' ,
    		        mtype :  'POST',
    		        datatype :'json',
    		        pager: $('#pager'),  
    		        ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
    		        ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
    		        ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
    		        postData :  JSON.stringify( postData ),
    		        jsonReader : {
	   		             root : 'resultlist',
	   		             "page":"paginationInfo.currentPageNo",
	   		             "total":"paginationInfo.totalPageCount",
	   		             "records":"paginationInfo.totalRecordCount",
	   		             repeatitems:false
   		            },
    		        colModel :  [
	    		 	                { label: '아이디', key: true,  name:'requst_id',    index:'requst_id', align:'left', hidden:true},
	    		 	                { label: '업무구분', name:'job_se_code', index:'job_se_code', align:'left',   width:'10%'},
	    		 	                { label: '서비스명', name:'srvc_nm', index:'srvc_nm', align:'center', width:'10%' },
	      			                { label: '매서드명', name:'method_nm', index:'method_nm', align:'center', width:'10%' },
		      			            { label: '처리시간', name:'process_time', index:'process_time', align:'center', width:'10%'},
		      			            { label: '애러코드', name:'error_code', index:'error_code', align:'center', width:'10%'},
		      			            { label: '요청자IP', name:'rqester_ip', index:'rqester_ip', align:'center', width:'10%'},
		      			            { label: '요청자', name:'rqester_id', index:'rqester_id', align:'center', width:'10%'},
		      			            { label: '실행일자', name: 'occrrnc_date',  index:'occrrnc_date',      align:'center',  width: '8%', 
						            	sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d H:i:s"} }
		      			          
    			                ],  //상단면 
    		        rowNum : 10,  //레코드 수
    		        rowList : [10,20,30,40,50,100],  // 페이징 수
    		        pager : pager,
    		        refresh : true,
    	            rownumbers : false, // 리스트 순번
    		        viewrecord : true,    // 하단 레코드 수 표기 유무
    		        //loadonce : false,     // true 데이터 한번만 받아옴 
    		        loadui : "enable",
    		        loadtext:'데이터를 가져오는 중...',
    		        emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
    		        height : "100%",
    		        autowidth:true,
    		        shrinkToFit : true,
    		        refresh : true,
    		        loadonce: true,
    				viewrecords: true,
                    footerrow: true,
                    loadComplete : function (data){
    		        	 $("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
    		        }, loadError:function(xhr, status, error) {
    		            alert(error); 
    		        }, onPaging: function(pgButton){
    		        	  var gridPage = grid.getGridParam('page'); //get current  page
    		        	  var lastPage = grid.getGridParam("lastpage"); //get last page 
    		        	  var totalPage = grid.getGridParam("total");
    		              if (pgButton == "next"){
    		            	  if (gridPage < lastPage ){
    		            		  gridPage += 1;
    		            	  }else{
    		            		  gridPage = gridPage;
    		            	  }
    		              }else if (pgButton == "prev"){
    		            	  if (gridPage > 1 ){
    		            		  gridPage -= 1;
    		            	  }else{
    		            		  gridPage = gridPage;
    		            	  }
    		              }else if (pgButton == "first"){
    		            	  gridPage = 1;
    		              }else if  ( pgButton == "last"){
    		            	  gridPage = lastPage;
    		              } else if (pgButton == "user"){
    		            	  var nowPage = Number($("#pager .ui-pg-input").val());
    		            	  
    		            	  if (totalPage >= nowPage && nowPage > 0 ){
    		            		  gridPage = nowPage;
    		            	  }else {
    		            		  $("#pager .ui-pg-input").val(nowPage);
    		            		  gridPage = nowPage;
    		            	  }
    		              }else if (pgButton == "records"){
    		            	  gridPage = 1;
    		              }
    		              grid.setGridParam({
		    		          	  page : gridPage,
		    		          	  rowNum : $('.ui-pg-selbox option:selected').val(),
		    		          	  postData : JSON.stringify(  {
							    		          			"pageIndex": gridPage,
							    		          			"searchKeyword" : $("#searchKeyword").val(),
							    		          			"pageUnit":$('.ui-pg-selbox option:selected').val()
							    		          		})
    		          		}).trigger("reloadGrid");
    		        },onSelectRow: function(rowId){
    	                if(rowId != null) {  }// 체크 할떄
    	            },ondblClickRow : function(rowid, iRow, iCol, e){
    	            	grid.jqGrid('editRow', rowid, {keys: true});
    	            },onCellSelect : function (rowid, index, contents, action){
    	            	var cm = $(this).jqGrid('getGridParam', 'colModel');
    	                if (cm[index].name != 'cb'){
    	                	jqGridFunc.fn_interfaceInfo($(this).jqGrid('getCell', rowid, 'requst_id'));
            		    }
    	            }
    		    });
    		}, result : function(cellvalue, options, rowObject){
    			var resultTxt = "";
    			switch (rowObject.result ){
	    		    case "S" :
	    		    	resultTxt = "조회";
	    		        break;
	    		    case "R" :
	    		    	resultTxt = "예약전송";
	    		        break;
	    		    case "Y" :
	    		    	resultTxt = "정상발송";
	    		        break;
	    		    default :
	    		    	resultTxt = "애러";
	    		}
    			return resultTxt;
    		}, fn_interfaceInfo : function (requstId){
    			var url = "/backoffice/sys/selectInterfaceDetail.do";
 		       
 		        var params = {'requstId' : requstId}; 
 		        fn_Ajax(url, "GET", params, false,
 		      			function(result) {
 		 				       if (result.status == "LOGIN FAIL"){
 		 				    	   common_popup(result.meesage, "Y","bas_menu_add");
 		   						   location.href="/backoffice/login.do";
 		   					   }else if (result.status == "SUCCESS"){
 		   						   //총 게시물 정리 하기'
 		   						   var obj = result.regist;
 		   						   $("#sp_reqId").html(obj.requst_id);
 		   						   $("#sp_trsmrcv").html(obj.trsmrcv_se_code);
 		   					   	   $("#sp_reqInsttId").html(obj.provd_instt_id);
 		   						   $("#sp_proInsttId").html(obj.requst_instt_id);
 		   						   $("#sp_reqTrnTm").html(obj.requst_trnsmit_tm);
 		   		                   $("#sp_rspTrnTm").html(obj.rspns_trnsmit_tm);
 		   	                       $("#sp_resultCode").html(obj.result_code);
 		   	                       $("#sp_resultMessage").html(obj.result_message);
 		   	                       $("#sp_sendtMessage").html(obj.send_message);
 		   	                       
 		   	                   
 		   						   $("#bas_interfaceinfo").bPopup();
 		   					   }else if (result.status == "FAIL"){
 		   						   common_modelCloseM(result.message, "");
 		   						   
 		   					   }
 		 				    },
 		 				    function(request){
 		 				    	common_modelCloseM("Error:" + request.status, "Y", "bas_menu_add");
 		 				    }    		
 		        );
    		    
    		    
    		}
    }
  </script>
</head>
<body>
<div class="wrapper">
  <!--// header -->
  <c:import url="/backoffice/inc/top_inc.do" />
  <!-- header //-->
  <!--// contents-->
  <div id="contents">
    <div class="breadcrumb">
      <ol class="breadcrumb-item">
        <li>기초 관리</li>
        <li class="active">　> 시스템 로그</li>
      </ol>
    </div>

    <h2 class="title">시스템 로그</h2><div class="clear"></div>
    <!--// dashboard -->
    <div class="dashboard">
        <!--contents-->
        <div class="boardlist">
            <div class="whiteBox searchBox">
                <div class="sName">
                  <h3>검색 옵션</h3>
                </div>
                <div class="top">
                    <p>기간</p>
		            <input type="text" id="searchFrom" class="cal_icon"> ~
		            <input type="text" id="searchTo" class="cal_icon">
                    <p>검색어</p>
                    <input type="text" name="searchKeyword" id="searchKeyword"  placeholder="검색어를 입력하새요.">
                </div>
                <div class="inlineBtn ">
                    <a href="javascript:jqGridFunc.fn_Search()" class="grayBtn">검색</a>
                </div>
            </div>
            <div class="left_box mng_countInfo">
                <p>총 : <span id="sp_totcnt"></span>건</p>
            </div>
            <div class="clear"></div>
            <div class="whiteBox">
                <table id="mainGrid"></table>
                <div id="pager" class="scroll" style="text-align:center;"></div>  
            </div>
            
        </div>

    </div>
    
  </div>
  <!-- contents//-->
</div>
<!-- wrapper_end-->
<!--권한분류 추가 팝업-->
<div data-popup="bas_auth_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">권한 분류 추가</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>권한 코드</th>
                        <td>
                            <input type="text">
                            <a href="" class="blueBtn">중복확인</a>
                        </td>
                    </tr>
                    <tr>
                        <th>권한명</th>
                        <td>
                            <input type="text">
                        </td>
                    </tr>
                    <tr>
                        <th>상세설명</th>
                        <td>
                            <input type="text">
                        </td>
                    </tr>
                    <tr>
                        <th>사용 유무</th>
                        <td>
                            <span>
                                <input type="radio" value="y" id="y">
                                <label for="y">사용</label>
                            </span>
                            <span>
                                <input type="radio" value="n" id="n">
                                <label for="n">사용 안함</label>
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="right_box">
            <a href="" class="grayBtn">취소</a>
            <a href="" class="blueBtn">저장</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
     <c:import url="/backoffice/inc/popup_common.do" />
    <script type="text/javascript" src="/resources/js/common.js"></script>
    <script type="text/javascript" src="/resources/js/back_common.js"></script>
</body>
</html>