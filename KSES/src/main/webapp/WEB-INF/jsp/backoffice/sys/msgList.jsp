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
    	<li>고객 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">메시지 전송 현황 관리</li>
  	</ol>
</div>
<h2 class="title">메시지 전송 현황 관리</h2>
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
        <p>검색 구분</p>
        <select>
          <option value="0">선택</option>
        </select>
        <input type="text" placeholder="검색어를 입력하세요.">
      </div>
      <div class="inlineBtn">
        <a href=""class="grayBtn">검색</a>
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
<!-- contents//-->
<!-- //popup -->
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
    		    var postData = {};
    		    grid.jqGrid({
    		    	url : '/backoffice/sys/msgListAjax.do' ,
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
	    		 	                { label: '문자 시쿼스', key: true,  name:'seqno',    index:'seqno', align:'left', hidden:true},
	    		 	                { label: '담당자',  name:'reqname', index:'reqname', align:'left'},
	    		 	                { label: '발신 전화번호',  name:'reqphone',  index:'reqphone',        align:'left'},
	    		 	                { label: '수신자', name:'callname', index:'callname', align:'center'},
	      			                { label: '수신 전화번호', name:'callphone', index:'callphone', align:'center'},
		      			            { label: '전송구분', name:'result', index:'result', align:'center', 
	      			                  formatter:jqGridFunc.result},
			      			        { label: '문자구분', name:'kind', index:'kind', align:'center', 
	      			                  formatter:jqGridFunc.kind},
	      			                { label: '전송시간',  name:'senttime',         index:'senttime',        align:'left'},
	      			                { label: '애러코드', name: 'errcode',  index:'errcode',      align:'center', fixed:true}
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
    	                	jqGridFunc.fn_mmsInfo($(this).jqGrid('getCell', rowid, 'seqno'));
            		    }
    	            }
    		    });
    		}, result : function(cellvalue, options, rowObject){
    			var resultTxt = "";
    			switch (rowObject.result ){
	    		    case "O" :
	    		    	resultTxt = "즉시전송";
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
    		}, kind : function (cellvalue, options, rowObject){
    			return (rowObject.kind == "S") ? "SMS" : "MMS";
    		}, fn_mmsInfo : function(seq){
    			
    		}
    }
</script>
<c:import url="/backoffice/inc/popup_common.do" />