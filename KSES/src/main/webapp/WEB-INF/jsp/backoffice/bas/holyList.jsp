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
<!-- Xlsx -->
<script type="text/javascript" src="/resources/js/xlsx.js"></script>
<script type="text/javascript" src="/resources/js/xlsx.full.min.js"></script>
<!-- jszip -->
<script type="text/javascript" src="/resources/js/jszip.min.js"></script>
<!-- //contents -->
<input type="hidden" name="mode" id="mode" >
<input type="hidden" name="holySeq" id="holySeq" >
<input type="hidden" name="targetHolyDt" id="targetHolyDt">
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>기초 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">휴일 관리</li>
	</ol>
</div>
<h2 class="title">휴일 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
      	<div class="whiteBox searchBox">
            <div class="sName">
              <h3>옵션 선택</h3>
            </div>
            <div class="top">
                <p>검색어</p>
                <select id="searchCondition" name="searchCondition">
                    <option value="ALL">전체</option>
					<option value="HOLY_DT">휴일 일자</option>
					<option value="HOLY_NM">휴일명</option>
                </select>
                <input type="text" name="searchKeyword" id="searchKeyword" placeholder="검색어를 입력하새요.">
            </div>
            <div class="inlineBtn ">
                <a href="javascript:jqGridFunc.fn_search();" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
          <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">	            	
            <a href="#" class="blueBtn" onclick="jqGridFunc.fn_holyInfoApply()">전체 지점 등록</a>
            <a href="#" class="blueBtn" onclick="jqGridFunc.fn_Upload()">Excel Upload</a>
            <a href="#" class="blueBtn" onclick="jqGridFunc.fn_holyInfo('Ins','')">휴일 등록</a>
            <a id="export" onClick="jqGridFunc.fn_excelDown()" class="blueBtn">엑셀 다운로드</a> 
            <a href="#" onClick="jqGridFunc.fn_delCheck()" class="grayBtn">삭제</a>
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
<!-- //popup -->
<!-- 휴일 정보 팝업 -->
<div id='bas_holiday_add' class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
    	<h2 class="pop_tit">휴일 등록</h2>
    	<div class="pop_wrap">
    		<table class="detail_table">
           		<tbody>
               		<tr>
						<th>휴일 일자</th>
	                    <td>
	                    	<input type="text" name="holyDt" id="holyDt" class="cal_icon">
	                    </td>
					</tr>
					<tr>
				        <th>휴일명</th>
			            <td>
		                    <input type="text" name="holyNm" id="holyNm">
						</td>
					</tr>
					<tr>
						<th>사용 유무</th>
					    <td>
				            <span>
			                    <input type="radio" name="useYn" id="useY" value="Y" checked="checked">
			                    <label for="y">사용</label>
							</span>
						    <span>
					            <input type="radio" name="useYn" id="useN" value="N">
				                <label for="n">사용 안함</label>
			                </span>
		                </td>
	                </tr>
				</tbody>
			</table>
		</div>
	    <div class="right_box">
        	<a href="#" onClick="common_modelClose('bas_holiday_add')" class="grayBtn b-close">취소</a>
		    <a href="javascript:jqGridFunc.fn_CheckForm();" class="blueBtn">저장</a>
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
		buttonImageOnly: true, //이미지표시
		buttonText: '달력선택', //버튼 텍스트 표시
		buttonImage: '/images/invisible_image.png', //이미지주소
		yearRange: '1970:2030' //1990년부터 2020년까지
        };	       
	    $("#holyDt").datepicker(clareCalendar);
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;"); //이미지버튼 style적용
		$("#ui-datepicker-div").hide(); //자동으로 생성되는 div객체 숨김
		
 	});
   	
	var jqGridFunc  = 
	{
   		setGrid : function(gridOption) {
   			var grid = $('#'+gridOption);
   		    //ajax 관련 내용 정리 하기 
   			
               var postData = {};
   		    grid.jqGrid({
   		    	url : '/backoffice/bas/holyListAjax.do' ,
   		        mtype :  'POST',
   		        datatype :'json',
   		        pager: $('#pager'),  
   		        ajaxGridOptions: { contentType: "application/json; charset=UTF-8" },
   		        ajaxRowOptions: { contentType: "application/json; charset=UTF-8", async: true },
   		        ajaxSelectOptions: { contentType: "application/json; charset=UTF-8", dataType: "JSON" }, 
   		       
   		        postData :  JSON.stringify(postData),
   		        jsonReader : 
   		        {
					root : 'resultlist',
					"page":"paginationInfo.currentPageNo",
					"total":"paginationInfo.totalPageCount",
					"records":"paginationInfo.totalRecordCount",
					repeatitems:false
  		            },
  		         	//상단면
   		        colModel :  
				[
					{ label: '휴일 코드',  name:'holy_seq', index:'holy_seq', align:'center', hidden:true, key:true},
					{ label: '휴일 일자',  name:'holy_dt', index:'holy_dt', align:'center', width:'20%'},
					{ label: '휴일명', name:'holy_nm', index:'holy_nm', align:'center', width:'15%'},
					{ label: '사용 유무', name:'use_yn', index:'use_yn', align:'center', width:'18%'},
					{ label: '수정일자', name:'last_updt_dtm', index:'last_updt_dtm', align:'center', width:'20%'},
					{ label: '수정자', name: 'last_updusr_id',  index:'last_updusr_id', align:'center', width: '18%'}
				],
				//레코드 수
   		        rowNum : 10,
   		     	// 페이징 수
   		        rowList : [10,20,30,40,50,100],  
   		        pager : pager,
   		        refresh : true,
   		     	// 리스트 순번
   	            rownumbers : false,
   	         	// 하단 레코R드 수 표기 유무
   		        viewrecord : true,
   		     	// true 데이터 한번만 받아옴
   		        loadonce : false,      
   		        loadui : "enable",
   		        loadtext:'데이터를 가져오는 중...',
   		      	//빈값일때 표시
   		        emptyrecords : "조회된 데이터가 없습니다", 
   		        height : "100%",
   		        autowidth:true,
   		        shrinkToFit : true,
   		        refresh : true,
   		        multiselect: true,
   				viewrecords: true,
                   footerrow: true,
   		        userDataOnFooter: true, // use the userData parameter of the JSON response to display data on footer
   		        
   		        loadComplete : function (data){
   		        	$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
   		        },
   		        beforeSelectRow: function (rowid, e) {
   		            var $myGrid = $(this);
   		            var i = $.jgrid.getCellIndex($(e.target).closest('td')[0]);
   		            var cm = $myGrid.jqGrid('getGridParam', 'colModel');
   		            return (cm[i].name == 'cb'); // 선택된 컬럼이 cb가 아닌 경우 false를 리턴하여 체크선택을 방지
   		        },
   		        loadError:function(xhr, status, error) {
   		            alert(error); 
   		        }, 
   		        onPaging: function(pgButton){
					var gridPage = grid.getGridParam('page'); //get current  page
					var lastPage = grid.getGridParam("lastpage"); //get last page 
					var totalPage = grid.getGridParam("total");
   		              
					if (pgButton == "next"){
						/* gridPage = gridPage < lastPage ? gridPage +=1 : gridPage; */
						if (gridPage < lastPage ){
							gridPage += 1;
						} else {
							gridPage = gridPage;
						}
					} else if (pgButton == "prev") {
						/* gridPage = gridPage > 1 ? gridPage -=1 : gridPage; */
						if (gridPage > 1 ) {
							gridPage -= 1;
						} else {
							gridPage = gridPage;
						}
					} else if (pgButton == "first"){
						gridPage = 1;
					} else if (pgButton == "last") {
						gridPage = lastPage;
					} else if (pgButton == "user"){
						var nowPage = Number($("#pager .ui-pg-input").val());
   		            	  
						if (totalPage >= nowPage && nowPage > 0 ){
							gridPage = nowPage;
   		            	} else {
   		            		$("#pager .ui-pg-input").val(nowPage);
   		            		gridPage = nowPage;
   		            	}
					} else if (pgButton == "records") {
   		            	  gridPage = 1;
					}
					
					grid.setGridParam
					({
						page : gridPage,
						rowNum : $('.ui-pg-selbox option:selected').val(),
						postData : JSON.stringify
						({
							"pageIndex": gridPage,
							"searchKeyword" : $("#searchKeyword").val(),
							"pageUnit":$('.ui-pg-selbox option:selected').val()
						})
					}).trigger("reloadGrid");
				},
				onSelectRow: function(rowId){
   	                if(rowId != null) {  }// 체크 할떄
   	            },
   	            ondblClickRow : function(rowid, iRow, iCol, e){
   	            	grid.jqGrid('editRow', rowid, {keys: true});
   	            },
   	            //셀 선택시 이벤트 등록
   	            onCellSelect : function (rowid, index, contents, action) {
   	            	var cm = $(this).jqGrid('getGridParam', 'colModel');
   	                if (cm[index].name != 'cb'){
   	                	jqGridFunc.fn_holyInfo("Edt", $(this).jqGrid('getCell', rowid, 'holy_seq'));
           		    }
   	            }
   		    });
   		},
   		refreshGrid : function() {
			$('#mainGrid').jqGrid().trigger("reloadGrid");
       	},
       	clearGrid : function() {
			$("#mainGrid").clearGridData();
		}, 
       	fn_del : function (){
           	var params = {'holySeq':$("#hid_DelCode").val() };
           	fn_uniDelAction("/backoffice/bas/holyDelete.do", "GET", params, false, "jqGridFunc.fn_search");
          	},
          	fn_delCheck  : function(){
  	    	    //체크값 삭제 
          		var menuArray = new Array();
 			    getEquipArray("mainGrid", menuArray);
 			    if (menuArray.length > 0){
 				  $("#hid_DelCode").val(menuArray.join(","))
 				  $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_del()");
 				  menuArray = null;
        		      fn_ConfirmPop("삭제 하시겠습니까?");
 			    }else {
 				  menuArray = null;
 				  common_modelCloseM("체크된 값이 없습니다.", "savePage");
 			    }
  	        },
          	fn_holyInfoApply  : function(){
 	    	    var ids = $('#mainGrid').jqGrid('getGridParam', 'selarrrow'); //체크된 row id들을 배열로 반환
 	    
   	    	if (ids.length < 1) {
   	    		alert("선택한 값이 없습니다.");
   	    		return false;
   	    	}
 	    	    
   	   
   	    	var params = new Array();
   	    	for(var i=0; i < ids.length; i++) {
   	    		var param = new Object();
   	    		var rowObject = $("#mainGrid").getRowData(ids[i]);
   	    		param['holyDt'] = rowObject.holy_dt; 
   	    		param['holyNm'] = rowObject.holy_nm; 
   	    		params.push(param);
   	    	}
          		
          		fn_Ajax
          		(
				"/backoffice/bas/holyInfoCenterApply.do",
				"POST",
				params,
				false, 
          	 		function(result) {
          		    	if (result.status == "LOGIN FAIL"){
          		    	   common_popup(result.message, "Y","bas_holiday_add");
			    	   location.href="/backoffice/login.do";
          				} else if (result.status == "SUCCESS"){
   						   //총 게시물 정리 하기'
   						   common_modelCloseM(result.message, "bas_holiday_add");
   						   jqGridFunc.fn_search();
   					 }else if (result.status == "FAIL"){
   						   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "bas_holiday_add");
   						   jqGridFunc.fn_search();
   					 }
				},
          			function(request){
          				common_modelCloseM("Error:" + request.status,"bas_holiday_add");
          			}    		
          	     );
   	    	
   	    	
  	        },
          	fn_holyInfo : function (mode, holySeq) {
          		$("#mode").val(mode);
	        $("#holySeq").val(holySeq);
			if (mode == "Edt") {
	           	var params = {"holySeq" : holySeq};
	     	   	var url = "/backoffice/bas/holyInfoDetail.do";
	     	    fn_Ajax
	     	   	(
					url, 
					"GET",
					params, 
					false,
					function(result) {
						if (result.status == "LOGIN FAIL"){
							common_modelCloseM(result.message, "bas_holiday_add");
							location.href="/backoffice/login.do";
						} else if (result.status == "SUCCESS") {
							//총 게시물 정리 하기
							var obj = result.regist;
							$("#holySeq").val(obj.holy_seq);
							$("#holyDt").val(obj.holy_dt);
							$("#targetHolyDt").val(obj.holy_dt);								
							$("#holyNm").val(obj.holy_nm);
							$("input:radio[name='useYn']:radio[value='"+obj.use_yn+"']").prop('checked', true)
						}else {
						    common_modelCloseM(result.message, "bas_holiday_add");
						}

					},
					function(request){
						common_modelCloseM("ERROR : " +request.status, "bas_holiday_add");
					}    		
				);
			} else {
				$("#bas_holiday_add input[type='text']").val("");
				$("#useY").prop("checked", true);
	        }
			$("#bas_holiday_add").bPopup();
          	},
		fn_CheckForm  : function () {
			if (any_empt_line_span("bas_holiday_add", "holyDt", "휴일 일자를 입력해주세요.","sp_message", "savePage") == false) return;
			if (any_empt_line_span("bas_holiday_add", "holyNm", "휴일명을 입력해주세요.","sp_message", "savePage") == false) return;
			var commentTxt = ($("#mode").val() == "Ins") ?  "등록 하시겠습니까?" : "수정 하시겠습니까?" ;
		    $("#id_ConfirmInfo").attr("href", "javascript:jqGridFunc.fn_update()");
       		fn_ConfirmPop(commentTxt);
		}, fn_update : function (){
			//확인 
			$("#confirmPage").bPopup().close();
			var url = "/backoffice/bas/holyUpdate.do";
			var params = 
			{ 	
				'holySeq' : $("#holySeq").val(),
				'holyDt' : $("#holyDt").val(),
				'targetHolyDt' : $("#targetHolyDt").val(),
				'holyNm' : $("#holyNm").val(),
				'useYN' : fn_emptyReplace($("input[name='useYn']:checked").val(),"Y"),
				'useYn' : $("input:radio[name='useYn']:checked").val(),
				'mode' : $("#mode").val()
			}; 
			fn_Ajax(url, "POST", params, true,
	      			function(result) {
	 				       if (result.status == "LOGIN FAIL"){
	 				    	   common_popup(result.meesage, "Y","bas_holiday_add");
	   						   location.href="/backoffice/login.do";
	   					   }else if (result.status == "SUCCESS"){
	   						   //총 게시물 정리 하기'
	   						   common_modelCloseM(result.message, "bas_holiday_add");
	   						   jqGridFunc.fn_search();
	   					   }else if (result.status == "FAIL"){
	   						   common_modelCloseM("저장 도중 문제가 발생 하였습니다.", "bas_holiday_add");
	   						   jqGridFunc.fn_search();
	   					   }
	 				    },
	 				    function(request){
	 				    	common_modelCloseM("Error:" + request.status,"bas_holiday_add");
	 				    }    		
	        );
		},
	  	fn_search: function(){
			//검색 
    	  	$("#mainGrid").setGridParam({
    	    	datatype : "json",
    	    	postData : JSON.stringify
    	    	({
          			"pageIndex": $("#pager .ui-pg-input").val(),
          			"searchCondition" : $("#searchCondition").val(),
          			"searchKeyword" : $("#searchKeyword").val(),
         			"pageUnit":$('.ui-pg-selbox option:selected').val()
         		}),
    	    	loadComplete : function(data) {
    	    		$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
    	    	}
    	  }).trigger("reloadGrid");
		},
		fn_Upload : function (){
			$("#dv_excelUpload").bPopup();
			$("#aUploadId").attr("href", "javascript:fn_excelUpload('0',jqGridFunc.fn_holyUpload)");
			
		}, 
		fn_holyUpload : function (sheetNameList, sheetName, jsonResult){
			var params = {"data": jsonResult};
			var url = "/backoffice/bas/holyInfoExcelUpload.do";
			fn_Ajax(url, "POST", params, true,
	      			function(result) {
				           if (result.status == "LOGIN FAIL"){
	 				    	   common_popup(result.meesage, "Y","dv_excelUpload");
	   						   location.href="/backoffice/login.do";
	   					   }else if (result.status == "SUCCESS"){
	   						   //총 게시물 정리 하기'
	   						   common_modelClose("dv_excelUpload");
	   						   jqGridFunc.fn_search();
	   					   }else if (result.status == "FAIL"){
	   						   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "dv_excelUpload");
	   						   jqGridFunc.fn_search();
	   					   }
	 				    },
	 				    function(request){
	 				    	common_modelCloseM("Error:" + request.status,"dv_excelUpload");
	 				    }    		
	        ); 
		},
		fn_excelDown : function (){
			$("#mainGrid").jqGrid("exportToExcel",{
				includeLabels : true,
				includeGroupHeader : true,
				includeFooter: true,
				fileName : "jqGridExport.xlsx",
				maxlength : 40 // maxlength for visible string data 
			})
		}
   	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />