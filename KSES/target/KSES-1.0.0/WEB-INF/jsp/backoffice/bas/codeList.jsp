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

    <script src="/resources/js/jquery-3.5.1.min.js"></script>
    <script src="/resources/js/bpopup.js"></script>
    <!-- chart.js -->
    <script src="/resources/js/chart.min.js"></script>
    <script src="/resources/js/utils.js"></script>
    <script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
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
    <script type="text/javascript" src="/resources/js/common.js"></script>
    <script type="text/javascript" src="/resources/js/back_common.js"></script>
    <script src="/js/popup.js"></script>
    
    
    <link rel="stylesheet" type="text/css" href="/resources/css/jquery-ui.css">
    <link rel="stylesheet" type="text/css" href="/resources/jqgrid/src/css/ui.jqgrid.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/toggle.css">
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
    <script type="text/javascript">
	$(document).ready(function() { 
		   jqGridFunc.setGrid("mainGrid");
	 });
    var jqGridFunc  = {
    		
    		setGrid : function(gridOption){
    			 var grid = $('#'+gridOption);
    		    //ajax 관련 내용 정리 하기 
    		
                var postData = {};
    		    grid.jqGrid({
    		    	url : '/backoffice/bas/codeListAjax.do' ,
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
	    		 	                { label: 'code_id', key: true, name:'code_id',       index:'code_id',      align:'center', hidden:true},
	    		 	                { label: '코드ID',  name:'cl_code',         index:'cl_code',        align:'left',   width:'10%'},
	    		 	                { label: '코드명',  name:'floor_name',         index:'floor_name',        align:'left',   width:'10%'},
	    		 	                { label: '수정자', name:'update_id',      index:'update_id',     align:'center', width:'14%'},
	    			                { label: '수정 일자', name:'update_date', index:'update_date', align:'center', width:'12%', 
	    			                  sortable: 'date' ,formatter: "date", formatoptions: { newformat: "Y-m-d"}},
	    			                { label: '삭제', name: 'btn',  index:'btn',      align:'center',  width: 50, fixed:true, sortable : 
	    			                  false, formatter:jqGridFunc.rowBtn}
    			                ],  //상단면 
    		        rowNum : 10,  //레코드 수
    		        rowList : [10,20,30,40,50,100],  // 페이징 수
    		        pager : pager,
    		        refresh : true,
    	            rownumbers : true, // 리스트 순번
    		        viewrecord : true,    // 하단 레코드 수 표기 유무
    		        //loadonce : false,     // true 데이터 한번만 받아옴 
    		        loadui : "enable",
    		        loadtext:'데이터를 가져오는 중...',
    		        emptyrecords : "조회된 데이터가 없습니다", //빈값일때 표시 
    		        height : "100%",
    		        autowidth:true,
    		        shrinkToFit : true,
    		        refresh : true,
    		        multiselect:true, 
    		        loadComplete : function (data){
    		        	$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);
    		        },loadError:function(xhr, status, error) {
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
							    		          			"searchCenter" :  $("#searchCenter").val(),
							    		          			"searchFloorSeq" : $("#searchFloorSeq").val(),
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
    	                //console.log(cm);
    	                if (cm[index].name=='seat_name' || cm[index].name=='code_nm'){
    	                	jqGridFunc.fn_SeatInfo("Edt", $(this).jqGrid('getCell', rowid, 'seat_id'));
            		    }
    	            }
    		    });
    		},rowBtn: function (cellvalue, options, rowObject){
            	if (rowObject.seat_id != "")
            	     return "<a href='javascript:jqGridFunc.delRow(\""+rowObject.seat_id+"\");'>삭제</a>";
            },fixGubun: function (cellvalue, options, rowObject){
           	    return rowObject.seat_fix_useryn == "Y" ? "고정석: [" +  CommonJsUtil.NVL(rowObject.user_name) + "]": "일반";
     	    },refreshGrid : function(){
     	    	$('#mainGrid').jqGrid().trigger("reloadGrid");
	        },fn_delCheck  : function(){                        
		    	 var ids = $('#mainGrid').jqGrid('getGridParam','selarrrow'); //체크된 row id들을 배열로 반환
		    	 if (ids.length < 1) {
		    		 alert("선택한 값이 없습니다.");
		    		 return false;
		    	 }
		    	 var SeatsArray = new Array();
		    	 for(var i=0; i <ids.length; i++){
		    	        var rowObject = ids[i]; //체크된 id의 row 데이터 정보를 Object 형태로 반환
		    	        SeatsArray.push(ids[i]);
		    	 } 
		    	 var params = {'seatId':SeatsArray.join(',')};
      		     fn_uniDelAction("/backoffice/basicManage/officeSeatDelete.do",params, "jqGridFunc.fn_search");
		    },delRow : function (seat_id){
		    	if(seat_id != "") {
        		   var params = {'seatId':seat_id };
        		   fn_uniDelAction("/backoffice/basicManage/officeSeatDelete.do",params, "jqGridFunc.fn_search");
		        }
           },fn_SeatInfo : function (mode, seat_id){
        	    $("#btn_message").trigger("click");
			    $("#mode").val(mode);
		        $("#seatId").val(seat_id);
		        jqGridFunc.fn_seatChoic("V");
		        if (mode == "Edt"){
		        	$("#btnUpdate").text("수정");
		        	var params = {"seatId" : seat_id};
		     	    var url = "/backoffice/basicManage/officeSeatDetail.do";
		     	    uniAjaxSerial(url, params, 
		          			function(result) {
		     				       if (result.status == "LOGIN FAIL"){
		     				    	   alert(result.meesage);
		       						   location.href="/backoffice/login.do";
		       					   }else if (result.status == "SUCCESS"){
	       						       //총 게시물 정리 하기
	       						       var obj  = result.regist;
	       						       $("#centerId").val(obj.center_id);
	       						       jqGridFunc.fn_floorState(obj.floor_seq);
	       						       if (obj.part_seq != "0"){
	       						    	  jqGridFunc.fn_partState(obj.part_seq);
	       						       }
	       						       $("#payClassification").val( obj.pay_classification);
						    		   jqGridFunc.fn_payClassGubun(obj.pay_gubun, obj.pay_cost)
						    		   $("#seatName").val( obj.seat_name);
						    		   $("#seatTop").val( obj.seat_top);
						    		   $("#seatLeft").val( obj.seat_left);
						    		   $("#seatOrder").val( obj.seat_order);
						    		   $("#seatGubun").val( obj.seat_gubun);
						    		   $("#seatNumber").val( obj.seat_number);
						    		   $("#orgCd").val(obj.org_cd);
						    		   $("#seatFixGubun").val(obj.seat_fix_gubun);
						    		   $("#seatFixUserId").val(obj.seat_fix_user_id);
						    		   $('#resReqday').val(obj.res_reqday);
						    		   $("#seatLabelTemplate").val(obj.seat_label_template);
						    		   $("#seatLabelCode").val(obj.seat_label_code);
						    		   
						    		   if (obj.empname !== ""){
						    			   $("#sp_fixUser").html(obj.empname + "<a href='#' onClick='jqGridFunc.fn_seatChoic(\"S\")'>[변경]</a>");
						    		   }else {
						    			   $("#sp_fixUser").html("<a href='#' onClick='jqGridFunc.fn_seatChoic(\"S\")'>[선택]</a>");
						    		   }
						    		   toggleClick("qrPlayyn", obj.qr_playyn);
						    		   toggleClick("seatFixUseryn", obj.seat_fix_useryn);
						    		   toggleClick("seatUseyn", obj.seat_useyn);
						    		   toggleClick("seatConfirmgubun", obj.seat_confirmgubun);
						    		   toggleClick("seatLabelUseyn", obj.seat_label_useyn);
						    		   
						    		   //좌석 관리 세팅으로 이동
						    		   jqGridFunc.fn_seatChoic("V");
						    		   jqGridFunc.fn_Label(obj.seat_label_useyn);
		       					   }else{
		       						   alert(result.meesage);
		       					   }
		     				    },
		     				    function(request){
		     					    alert("Error:" +request.status );	       						
		     				    }    		
		               );
		        }else{
		        	$('input:text[name^=seat]').val("");
		        	$("#centerId").val("");
		        	$("#orgCd").val("");
		        	$('#resReqday').val("")
                    $('#seatOrder').val("")
                    $("#seatLabelCode").val("");
        		    $("#seatLabelTemplate").val("");
					$("#sp_fixUser").html("");
		        	$("#floorSeq").remove();
		        	$("#partSeq").remove();
		        	$("#tb_userInfo > tbody").empty();
		        	toggleDefault("seatFixUseryn");
		        	toggleDefault("seatConfirmgubun");
		        	toggleDefault("seatUseyn");
		        	toggleDefault("qrPlayyn");
		        	toggleDefault("seatLabelUseyn");
		        	jqGridFunc.fn_Label('N');
		        }
           },clearGrid : function() {
                $("#mainGrid").clearGridData();
           },fn_CheckForm:function (){
			    if (any_empt_line_id("centerId", "지점을 선택해주세요.") == false) return;
			    if (any_empt_line_id("floorSeq", "층수을 선택해주세요.") == false) return;
		    	if (any_empt_line_id("seatName", "좌석명 입력해 주세요.") == false) return;	
		    	
		    	
		    	//확인 
		    	
		    	var url = "/backoffice/basicManage/officeSeatUpdate.do";
		    	var params = {   'centerId' : $("#centerId").val(),
				    		     'floorSeq' : $("#floorSeq").val(),
				    		     'partSeq' : fn_emptyReplace($("#partSeq").val(),"0"),
				    			 'seatId' : $("#seatId").val(),
				    			 'seatName' : $("#seatName").val(),
				    			 'seatTop' : fn_emptyReplace($("#seatTop").val(),"0"),
				    			 'seatLeft' : fn_emptyReplace($("#seatLeft").val(),"0"),
				    			 'seatOrder' : fn_emptyReplace($("#seatOrder").val(),"0"),
				    			 'seatFixUseryn' : fn_emptyReplace($("#seatFixUseryn").val(),"Y"),
				    			 'seatGubun' : $("#seatGubun").val(),
				    			 'payClassification' : fn_emptyReplace($("#payClassification").val(),"PAY_CLASSIFICATION_2"),
				     			 'payGubun' : fn_emptyReplace($("#payGubun").val(),""),
				     			 'payCost' : fn_emptyReplace($("#payCost").val(),"0"),
				    			 'orgCd' : $("#orgCd").val(),
				    			 'seatUseyn' :  $('#seatUseyn').val(),
				    			 'seatConfirmgubun' :  fn_emptyReplace($('#seatConfirmgubun').val(),"N"),
				    			 'seatNumber' :  $('#seatNumber').val(),
				    			 'qrPlayyn' :  $('#qrPlayyn').val(),
				    			 'seatLabelUseyn' :  $('#seatLabelUseyn').val(),
				    			 'seatLabelTemplate' : $('#seatLabelTemplate').val(),
				    			 'seatLabelCode' : $('#seatLabelCode').val(),
				    			 'seatFixGubun' :  $('#seatFixGubun').val(),
				    			 'seatFixUserId' :  $('#seatFixUserId').val(),
				    			 'resReqday' :  $('#resReqday').val(),
				    			 'mode' : $("#mode").val()
		    	               }; 
		    	uniAjax(url, params, 
		      			function(result) {
		 				       if (result.status == "LOGIN FAIL"){
		 				    	   alert(result.meesage);
		   						   location.href="/backoffice/login.do";
		   					   }else if (result.status == "SUCCESS"){
		   						   //총 게시물 정리 하기'
		   						   need_close();
		   						   jqGridFunc.fn_search();
		   					   }else if (result.status == "FAIL"){
		   						   alert("저장 도중 문제가 발생 하였습니다.");
		   						   need_close();
		   						   jqGridFunc.fn_search();
		   					   }
		 				    },
		 				    function(request){
		 					    alert("Error:" +request.status );	   
		 					    $("#btn_needPopHide").trigger("click");
		 				    }    		
		        );
		  },fn_search: function(){
			  //검색 
	    	  $("#mainGrid").setGridParam({
	    	    	datatype	: "json",
	    	    	postData	: JSON.stringify({
	          			"pageIndex": $("#pager .ui-pg-input").val(),
	          			"searchCenter" :  $("#searchCenter").val(),
	          			"searchFloorSeq" : $("#searchFloorSeq").val(),
	         			"searchKeyword" : $("#searchKeyword").val(),
	         			"pageUnit":$('.ui-pg-selbox option:selected').val()
	         		}),
	    	    	loadComplete	: function(data) {$("#sp_totcnt").text(data.paginationInfo.totalRecordCount);}
	    	  }).trigger("reloadGrid");
		 }, fn_floorState : function (floorSeq){
	    	 var _url = "/backoffice/basicManage/floorListAjax.do";
	    	 var _params = {"centerId" : $("#centerId").val(), "floorUseyn": "Y"};
	    	 fn_comboListPost("sp_floor", "floorSeq",_url, _params, "jqGridFunc.fn_partState()", "120px", floorSeq);  
	     }, fn_partState : function (partSeq){
	    	 var _url = "/backoffice/basicManage/partListAjax.do";
	    	 var _params = {"floorSeq" : $("#floorSeq").val(), "partUseyn": "Y"};
	    	 fn_comboListPost("sp_part", "partSeq",_url, _params, "", "120px", partSeq);  
	     }, fn_payClassGubun : function(payGubun, payCost){
	    	 //유료 무료 구분 PAY_CLASSIFICATION_1 -> 유료 
	    	  var payHtml = "";
	    	  if ( $("#payClassification").val() == "PAY_CLASSIFICATION_1"){
	        	 var _url = "/backoffice/basicManage/CmmnDetailAjax.do"
		    	 var _params = {"codeId" : "PAY_GUBUN"}
	        	 fn_comboList("sp_PayInfo", "payGubun",_url, _params, "", "120px", payGubun);
	        	 payHtml = $("#sp_PayInfo").html() + "<input type='number' id='payCost' name='payCost' value='"+payCost+"' onkeypress='only_num();' style='width:120px;'>";
	         }else {
	        	 payHtml = "";
	         }	 
	    	  $("#sp_PayInfo").html(payHtml);
	     }, fn_adminChoic : function (empId){
	    	 var empTxt =  $("#seatConfirmgubun").val() == "Y" ? "[관리자 선택]" : "";
	    	 $("#sp_empView").html(empTxt);
	     },classinfo : function(cellvalue, options, rowObject){
             var costInfo  = rowObject.pay_classification === "PAY_CLASSIFICATION_2" ? rowObject.pay_classification_txt : rowObject.pay_classification_txt 
       		      + ":" + rowObject.pay_gubun_txt +": 사용 크레딧:" + rowObject.pay_cost;
             return costInfo;
        }, fn_seatChoic : function (viewGubun){
             //고정석 일때 사용자 정보 선택 
             if (viewGubun === "S" && $("#seatFixUseryn").val() === "Y" ){
            	 $("#tb_seatInfo").hide();
                 $("#tb_userInfo").show();
             }else {
            	 $("#searchUserGubun").val("");
            	 $("#searchUserKeyword").val("");
            	 $("#tb_seatInfo").show();
                 $("#tb_userInfo").hide();
             }
        }, fn_Label : function (){
        	if ($("#seatLabelUseyn").val() === "Y"){
        		$("#seatLabelCode").show();
        		$("#seatLabelTemplate").show();
        	}else {
        		$("#seatLabelCode").hide();
        		$("#seatLabelTemplate").hide();
        		
        	}
        } , fn_LabelRest : function(){
        	uniAjax("/backoffice/basicManage/seatLabel.do", null, 
	      			function(result) {
	 				       if (result.status == "LOGIN FAIL"){
	 				    	   alert(result.meesage);
	   						   location.href="/backoffice/login.do";
	   					   }else if (result.status == "SUCCESS"){
	   						   //총 게시물 정리 하기'
	   						   alert(result.message);
	   					   }else if (result.status == "FAIL"){
	   						   alert("저장 도중 문제가 발생 하였습니다.");
	   					   }
	 				    },
	 				    function(request){
	 					    alert("Error:" +request.status );	   
	 					    $("#btn_needPopHide").trigger("click");
	 				    }    		
	        );
        }
    }
  </script>
</head>
<body>
<form:form name="regist" commandName="regist" method="post" action="/backoffice/basicManage/msgList.do">
<div class="wrapper">
<div class="wrapper">
  <!--// header -->
  <c:import url="/backoffice/inc/top_inc.do" />
  <!-- header //-->
  <!--// contents-->
  <div id="contents">
    <div class="breadcrumb">
      <ol class="breadcrumb-item">
        <li>기초 관리</li>
        <li class="active">　> 공통코드 관리</li>
      </ol>
    </div>

    <h2 class="title">공통코드 관리</h2><div class="clear"></div>
    <!--// dashboard -->
    <div class="dashboard">
        <!--contents-->
        <div class="boardlist">
       <!--// search -->
            <div class="whiteBox searchBox">
                <div class="sName">
                  <h3>옵션 선택</h3>
                </div>
                <div class="top">                    
                    <p>검색어</p>
                    <select>
                        <option value="0">지점명</option>
                    </select>
                    <input type="text" placeholder="검색어를 입력하새요.">
                </div>
                <div class="inlineBtn">
                    <a href="" class="grayBtn">검색</a>
                </div>
            </div>
            <div class="left_box mng_countInfo">
              <p>총 : 100건</p>
              <select>
                  <option value="0">10개씩 보기</option>
                  <option value="1">20개씩 보기</option>
              </select>
            </div>
            <div class="right_box">
                <a data-popup-open="bas_code_add" class="right_box blueBtn">분류코드추가</a> 
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
<!-- popup -->
<!--분류코드 추가 팝업-->
<div data-popup="bas_code_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">분류 코드 추가</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>코드 ID</th>
                        <td>
                            <input type="text">
                            <a href="" class="blueBtn">중복확인</a>
                        </td>
                    </tr>
                    <tr>
                        <th>코드명</th>
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
<!-- 상세코드 추가 팝업 -->
<div data-popup="bas_detailcode_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">상세 코드 등록</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>코드</th>
                        <td>
                            <input type="text">
                        </td>
                    </tr>
                    <tr>
                        <th>코드명</th>
                        <td>
                            <input type="text">
                        </td>
                    </tr>
                    <tr>
                        <th>설명</th>
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
<script src="/resources/js/common.js"></script>
</form:form>
</body>
</html>