<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- JQuery Grid -->
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
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
<!-- //contents -->
<div class="breadcrumb">
  <ol class="breadcrumb-item">
    <li>시스템 관리&nbsp;&gt;&nbsp;</li>
    <li class="active">시스템 로그</li>
  </ol>
</div>
<h2 class="title">시스템 로그</h2>
<div class="clear"></div>
<div class="dashboard">
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
                <a href="javascript:jqGridFunc.fn_search()" class="grayBtn">검색</a>
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
<!-- contents//-->
<!-- //popup -->
<!--권한분류 추가 팝업-->
<div id="bas_sys_add" class="popup">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">시스템 상세</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>발생일자</th>
                        <td><span id="sp_Odate"></span></td>
                        <th>요청자ID</th>
                        <td><span id="sp_ReqId"></span></td>
                    </tr>
                    <tr>
                        <th>서비스명</th>
                        <td><span id="sp_Service"></span></td>
                        <th>메소드명</th>
                        <td><span id="sp_Method"></span></td>
                    </tr>
                    <tr>
                        <th>업무구분</th>
                        <td><span id="sp_ProcessN"></span></td>
                        <th>처리시간</th>
                        <td><span id="sp_ProcessT"></span></td>
                        
                    </tr>
                    <tr>
                        <th>애러구분</th>
                        <td><span id="sp_Error"></span></td>
                        <th>애러코드</th>
                        <td><span id="sp_ErrorCd"></span></td>
                    </tr>
                    
                    
                    <tr>
                        <th>요청 파라미터</th>
                        <td colspan="3">
                           <span id="sp_Params"></span>
                        </td>
                    </tr>
                    <tr>
                        <th>요청 파라미터</th>
                        <td colspan="3">
                           <span id="sp_Result"></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="right_box">
            <a href="javascript:common_modelClose('bas_sys_add')" class="grayBtn">닫기</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- popup// -->
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
		   buttonImageOnly: false, //이미지표시
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
    		    	url : '/backoffice/sys/selectlogListAjax.do' ,
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
	    		 	                { label: '업무구분', name:'process_se_code', index:'process_se_code', align:'left',   width:'10%',
	    		 	                  formatter:jqGridFunc.result	},
	    		 	                { label: '서비스명', name:'srvc_nm', index:'srvc_nm', align:'center', width:'10%' },
	      			                { label: '매서드명', name:'method_nm', index:'method_nm', align:'center', width:'10%' },
		      			            { label: '처리시간', name:'process_time', index:'process_time', align:'center', width:'10%'},
		      			            { label: '애러코드', name:'error_code', index:'error_code', align:'center', width:'10%'},
		      			            { label: '요청자IP', name:'rqester_ip', index:'rqester_ip', align:'center', width:'10%'},
		      			            { label: '요청자', name:'rqester_id', index:'rqester_id', align:'center', width:'10%'},
		      			            { label: '실행일자', name: 'occrrnc_date',  index:'occrrnc_date',      align:'center',  width: '8%', 
						            	sortable: 'date' ,formatter: "date",formatoptions: { srcformat: 'Y-m-d H:i:s', newformat: 'm/d/Y h:i:s' } }
		      			          
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
							    							"searchFrom" : $("#searchFrom").val(),
							    							"searchTo" : $("#searchTo").val(),
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
    	                	jqGridFunc.fn_sysInfo($(this).jqGrid('getCell', rowid, 'requst_id'));
            		    }
    	            }
    		    });
    		}, result : function(cellvalue, options, rowObject){
    			var resultTxt = "";
    			switch (rowObject.process_se_code ){
	    		    case "S" :
	    		    	resultTxt = "조회";
	    		        break;
	    		    case "I" :
	    		    	resultTxt = "입력";
	    		        break;
	    		    case "U" :
	    		    	resultTxt = "수정";
	    		        break;
	    		    case "D" :
	    		    	resultTxt = "삭제";
	    		        break;
	    		}
    			return resultTxt;
    		},
    		fn_search: function(){
				//검색 
				$("#mainGrid").setGridParam
				({
					datatype : "json",
					postData : JSON.stringify
					({
						"pageIndex": $("#pager .ui-pg-input").val(),
						"searchFrom" : $("#searchFrom").val(),
						"searchTo" : $("#searchTo").val(),
    	          		"searchKeyword" : $("#searchKeyword").val(),
    	         		"pageUnit":$('.ui-pg-selbox option:selected').val()
    	         	}),
    	    	    loadComplete : function(data) {
    	    	    	$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
    	    	    }
				}).trigger("reloadGrid");
    		}, fn_sysInfo : function (requstId){
    			var url = "/backoffice/sys/selectlogInfoDetail.do";
 		       
 		        var params = {'requstId' : requstId}; 
 		        fn_Ajax(url, "GET", params, false,
 		      			function(result) {
 		 				       if (result.status == "LOGIN FAIL"){
 		 				    	   location.href="/backoffice/login.do";
 		   					   }else if (result.status == "SUCCESS"){
 		   						   //총 게시물 정리 하기'
 		   							   var obj = result.regist;
 		   						   $("#sp_Odate").html(obj.occrrnc_date);  //발생 일자
 		   						   $("#sp_ReqId").html(obj.emp_nm); //요청자
 		   					   	   $("#sp_Service").html(obj.srvc_nm);
 		   						   $("#sp_Method").html(obj.method_nm);
 		   						   $("#sp_ProcessN").html(obj.process_se_code_txt);
 		   						   $("#sp_ProcessT").html(obj.process_time);
 		   		                   $("#sp_Params").html(obj.sql_param);
 		   	                       $("#sp_Result").html(obj.method_result);
 		   	                       $("#sp_Error").html(obj.error_se);
 		   	                       $("#sp_ErrorCd").html(obj.error_code);
 		   	        			   $("#bas_sys_add").bPopup();
 		   					   }else if (result.status == "FAIL"){
 		   						   common_modelCloseM(result.message, "");
 		   						   
 		   					   }
 		 				    },
 		 				    function(request){
 		 				    	common_modelCloseM("Error:" + request.status, "Y", "");
 		 				    }    		
 		        );
    		}
    }
</script>
<c:import url="/backoffice/inc/popup_common.do" />
