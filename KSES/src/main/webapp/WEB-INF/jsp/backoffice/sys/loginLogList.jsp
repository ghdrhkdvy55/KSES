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
<input type="hidden" name="mode" id="mode" >
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>시스템 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">사용자 로그인 현황</li>
	</ol>
</div>
<h2 class="title">사용자 로그인 현황</h2>
<div class="clear">
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
                <a href="javascript:jqGridFunc.fn_Search()" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
          <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
       
        <div class="clear"></div>
        <div class="whiteBox"></div>
	</div>
</div>
<div class="Swrap tableArea">
	<table id="mainGrid">
	</table>
	<div id="pager" class="scroll" style="text-align:center;"></div>     
	<br />
	<div id="paginate"></div>   
</div>
<!-- contents// -->
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
    		    	url : '/backoffice/sys/selectLoginLogListAjax.do' ,
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
			   		                { label: '로그인 아이디', key: true,  name:'log_id',    index:'log_id', align:'left',   width:'8%'},
				 	                { label: '아이디',  name:'conect_id', index:'conect_id', align:'left',   width:'8%'},
				 	                { label: '이름',  name:'login_nm',  index:'login_nm',        align:'left',   width:'8%'},
				 	                { label: '구분', name:'conect_mthd', index:'conect_mthd', align:'center', width:'8%',
				 	                  formatter:jqGridFunc.mthd},
					                { label: 'IP', name:'conect_ip', index:'conect_ip', align:'center', width:'8%'},
						            { label: '발생일자', name: 'creat_dt',  index:'creat_dt',      align:'center',  width: '8%', 
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
    	                	jqGridFunc.fn_mmsInfo($(this).jqGrid('getCell', rowid, 'seqno'));
            		    }
    	            }
    		    });
    		},
    		refreshGrid : function() {
				$('#mainGrid').jqGrid().trigger("reloadGrid");
	       	},
	       	clearGrid : function() {
				$("#mainGrid").clearGridData();
			}
	       	, mthd : function(cellvalue, options, rowObject){
	       		console.log(rowObject.conect_mthd);
	       		return $.trim(rowObject.conect_mthd) == "I" ? "로그인" : "로그아웃";
    		}
	       	, fn_Search : function(){
    			$("#mainGrid").setGridParam({
    	    	 datatype	: "json",
    	    	 postData	: JSON.stringify(  {
    	    		"pageIndex": $("#pager .ui-pg-input").val(),
    	    		"searchFrom" : $("#searchFrom").val(),
    	    		"searchTo" : $("#searchTo").val(),
          			"searchKeyword" : $("#searchKeyword").val(),
         			"pageUnit":$('.ui-pg-selbox option:selected').val()
	         		}),
	    	    	loadComplete	: function(data) {$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);}
	    	     }).trigger("reloadGrid");
    		}
    }
</script>
<c:import url="/backoffice/inc/popup_common.do" />
