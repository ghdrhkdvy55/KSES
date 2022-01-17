<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- JQuery Grid -->
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
<script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
<script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
<!-- //contents -->
<input type="hidden" id="mode" name="mode" />
<input type="hidden" id="pageIndex" name="pageIndex" />
<input type="hidden" id="result" name="result" />
<input type="hidden" id="authorCd" name="authorCd" value="${loginVO.authorCd}">
<div class="breadcrumb">
  	<ol class="breadcrumb-item">
    	<li>고객 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">메시지 전송 관리</li>
  	</ol>
</div>
<h2 class="title">메시지 전송 관리</h2>
<div class="clear"></div>
<div class="dashboard">
  <div class="boardlist mms_mng_container">
    <div class="mms_select whiteBox">
      <div class="mms_select_check">
        <div class="mms_title">
          <label for="user_select01"><input type="checkbox" name="user_select01" id="user_select01">수신자 선택</label>
        </div>
        <table class="detail_table">
          <tbody>
            <tr>
              <th>
                <label for="userArea"><input type="radio" name="user_SendGubn" id="userArea" value="E">지점 관리자</label>
              </th>
              <td>
                <select id="send_G">
                   	<c:choose>
						<c:when test="${loginVO.authorCd ne 'ROLE_ADMIN' && loginVO.authorCd ne 'ROLE_SYSTEM' }">
						    <option value="${loginVO.centerCd}"><c:out value='${centerInfo.center_nm}'/></option>
						</c:when>
						<c:otherwise>
						    <option value="">관리자 전체 </option>
						    <c:forEach items="${centerCombo}" var="centerCombo">
						       <option value="${centerCombo.center_cd}"><c:out value='${centerCombo.center_nm}'/></option>
							 </c:forEach>
						</c:otherwise>
					</c:choose>
                </select>
              </td>
            </tr>
            <tr>
              <th>
                <label for="userDate"><input type="radio" name="user_SendGubn" id="userDate"  value="U">예약자 일자별 </label>
              </th>
              <td>
                <select id="send_U">
                  	<c:choose>
						<c:when test="${(loginVO.authorCd ne 'ROLE_ADMIN' && loginVO.authorCd ne 'ROLE_SYSTEM') }">
						    <option value="${loginVO.centerCd}"><c:out value='${centerInfo.center_nm}'/></option>
						</c:when>
						<c:otherwise>
						    <option value="">사용자 전체 </option>
						    <c:forEach items="${centerCombo}" var="centerCombo">
						       <option value="${centerCombo.center_cd}"><c:out value='${centerCombo.center_nm}'/></option>
							 </c:forEach>
						</c:otherwise>
					</c:choose>
                </select>
                <br />
                <input type="text" id="search_from" readonly="readonly" class="cal_icon"> ~
                <input type="text" id="search_to" readonly="readonly" class="cal_icon">
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="mms_select_input">
        <div class="mms_title">
          <label for="user_select02"><input type="checkbox" name="user_select02" id="user_select02">수신자 입력</label>
          <a href="#" onClick="msgFunction.fn_userSerach()" class="grayBtn">사용자 검색</a>
        </div>
        <div class="search">
           <input type="text" name="sms_addUser" id="sms_addUser" placeholder="전화번호를 입력하세요." onChange="fn_autoHyphen(this);">
          <a href="#" onClick="msgFunction.fn_indivUser()">추가</a>
        </div>
        <table id="tb_UserSendInfo" class="detail_table srch_option">
          <tbody>
            
          </tbody>
        </table>
      </div>
      <div class="mms_select_group">
        <div class="mms_title">
          <label for="user_select03"><input type="checkbox" name="user_select03" id="user_select03">수신 그룹</label>
          <a href="#" onClick="msgFunction.fn_GroupPop()" class="grayBtn">그룹 검색</a>
          <a href="#" onClick="msgFunction.fn_MsgInfo('Ins', '')" class="grayBtn">그룹 등록</a>
        </div>
        <table class="detail_table srch_option" id="tb_GroupSendInfo">
          <tbody>
          </tbody>
        </table>
      </div>
      <a href="#" onClick="msgFunction.fn_receiver()" class="blueBtn right_box">수신 목록에 추가</a>
    </div>
    <div class="mms_selectedUserList whiteBox">
      <div class="mms_title"> ▶ 수신자 </div>
      <table class="detail_table" id="tb_receiver">
        <tbody>
          <tr>
            <th>받는 사람</th>
            <td>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="mms_message whiteBox">
      <div class="mms_title"> ▶ 메시지 </div>
      <div class="mms_messageBox">
          <textarea id="textMessage" onChange="javascript:updateInputCount('textMessage','sp_msgByte')" 
                                     onKeyUp="javascript:updateInputCount('textMessage','sp_msgByte')"></textarea>
          <span id="sp_msgByte"></span>
          <a href="#" onClick="msgFunction.fn_megReset()" class="grayBtn">새로쓰기</a>
          <a href="#" onClick="msgFunction.fn_megPop('1')" class="grayBtn">메시지 보관함</a>
          <a href="#" onClick="msgFunction.fn_megSave()" class="grayBtn">메시지 저장</a>
      </div>
      <div class="mms_title"> ▶ 발신자 </div>
      <table class="detail_table">
        <tbody>
          <tr>
            <th>보내는 사람</th>
            <td>
              <input type="text" value="${empClphn }" id="sendTel">
            </td>
          </tr>
          <tr>
            <th>전송방법</th>
            <td>
              <a href="#" onClick="msgFunction.fn_msgSendSave('D')" class="blueBtn">즉시전송</a>
              <a href="#" onClick="msgFunction.fn_msgSendSave('R')" class="blueBtn">예약전송</a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>
<!-- contents//-->
<!-- //popup -->
<!--권한분류 추가 팝업-->
<div id="dv_messageGroupSearch" class="popup">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">그룹 현황</h2>
        
        <div class="pop_wrap">
             <div class="whiteBox searchBox">
              <div class="top">
	            <div>
	              <p class="srchTxt">
	              <input type="text" id="searchGroupTxt" name="searchGroupTxt">
	              </p>
	            </div>
	          </div>
	          <div class="inlineBtn">
	              <a href="#" onClick="msgFunction.fn_GroupSearch()" class="grayBtn">검색</a>
	              <a href="#" onClick="msgFunction.fn_GroupMsgInfo('Ins', '')" class="grayBtn">그룹 등록</a>
	               <a href="#" onClick="msgFunction.fn_GroupMsgListUpdate()" class="grayBtn">수신그룹등록</a>
	              
	          </div>
	          <div class="clear"></div>
	        </div>
            
            <table class="detail_table" id='tb_groupList'>
                <thead>
                   <th style="width:200px;"><input type="checkbox" id="ck_groupAll" name="ck_groupAll" onClick="msgFunction.fn_CheckboxGroupAll()"></th>
                   <th style="width:200px;">그룹명</th>
                   <th style="width:200px;">등록인원</th>
                   <th style="width:200px;">비고</th>
                   <th style="width:200px;">최종 수정일</th>
                   <th style="width:200px;">최종 수정자</th>
                   <th style="width:200px;">삭제</th>
                </thead>
                <tbody>
                    
                </tbody>
            </table>
        </div>
        <div class="clear"></div>
    </div>
</div>
<div id="dv_messageUserSerach" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">사용자 조회</h2>
        <div class="mms_title"> ▶ 조회 </div>
          <div class="srch_bar" >
            <p class="sel_srch">
              <select id="searchUserGubun_In" name="searchUserGubun">
				  <option value="">선택</option>
				  <option value="EMP">사용자</option>
				  <option value="USR">고객</option>
			  </select>
			  <select id="searchUserCondition_In" name="searchUserCondition">
				  <option value="">선택</option>
				  <option value="USERNAME">이름</option>
				  <option value="USERID">아아디</option>
				  <option value="CELLPHNONE">전화번호</option>
			  </select> 
            </p>  
            <p class="sum_srch">
              <input type="text" id="searchUserKeyworkd_In" name="searchUserKeyworkd">
	          <a href="#" onClick="msgFunction.fn_UserSearchRes()" class="grayBtn">검색</a>
	          <a href="#" onClick="msgFunction.fn_UserMsgListUpdate()" class="grayBtn">등록</a>
            </p>
        </div>
        <div class="pop_wrap">
            <table class="detail_table" id="tb_searchT_User">
            <thead>
               <th style="width:50px;"><input type="checkbox" id="ck_userAll" name="ck_userAll" onClick="msgFunction.fn_CheckboxAll()"></th>
               <th>이름</th>
               <th>전화번호</th>
            </thead>
            <tbody>
              
            </tbody>
          </table>
        </div>
        <div class="clear"></div>
    </div>
</div>
<div id="dv_messageGroup" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">그룹 추가</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                    	<th>그룹명</th>
                    	<td>
                    	    <input type="text" id="groupTitle" name="groupTitle">
                    	    <input type="hidden" id="groupCode" name="groupCode">
                    	</td>
                	</tr>
                	<tr>
                	   <th>사용유무</th>
                    	<td>
                    	    <label for="useYn_Y"><input id="useYn_Y" type="radio" name="useYn" value="Y" checked>Y</label>
                    		<label for="useYn_N"><input id="useYn_N" type="radio" name="useYn" value="N">N</label>
                    	</td>
                	</tr>
                	<tr>
                	    <th>비고</th>
                	    <td >
                	       <input type="text" id="groupDc" name="groupDc">
                	    </td>
                	</tr>
                </tbody>
            </table>
        </div>
        <div class="right_box">
            <a href="javascript:common_modelClose('dv_messageGroup')" class="grayBtn">취소</a>
            <a href="#" onClick="msgFunction.fn_CheckForm()" class="blueBtn" id="btnUpdate">저장</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- // 메시지 보관함 팝업 -->
<div data-popup="save_mms_list" id="save_mms_list" class="popup m_pop">
  <div class="pop_con">
      <a class="button b-close">X</a>
      <h2 class="pop_tit">메시지 보관함</h2>
      <div class="pop_wrap">
        <div class="mms_sel_num">
          <p>총 <span id="sp_msgTempCnt"></span>개 <em class="point">( 적용하실 메시지를 더블클릭 해주세요. )</em></p>
        </div>
        <ul class="save_mms" id="ul_savemms"> 
        </ul>
        <p class="page_num" id="ul_savemms_page">
          
        </p>
      </div>
      <div class="center_box">
          <a href="" class="grayBtn">닫기</a>
      </div>
      <div class="clear"></div>
  </div>
</div>
<!-- // 예약전송 팝업 -->
<div data-popup="rsv_mms_sum" id="rsv_mms_sum" class="popup m_pop">
  <div class="pop_con">
      <a class="button b-close">X</a>
      <h2 class="pop_tit">예약 전송</h2>
      <div class="pop_wrap">
        <ul class="rsv_mms">
          <li class="rsv_mms_tit"><span>예약 날짜/시간 선택</span></li>
          <li><input class="datepicker" id="sendDate"  name="sendDate" ></li>
          <li>
            <select name="send_hour" id="send_hour">
              <option value="00">00시</option>
              <option value="01">01시</option>
              <option value="02">02시</option>
              <option value="03">03시</option>
              <option value="04">04시</option>
              <option value="05">05시</option>
              <option value="06">06시</option>
              <option value="07">07시</option>
              <option value="08">08시</option>
              <option value="09">09시</option>
              <option value="10">10시</option>
              <option value="11">11시</option>
              <option value="12">12시</option>
              <option value="13">13시</option>
              <option value="14">14시</option>
              <option value="15">15시</option>
              <option value="16">16시</option>
              <option value="17">17시</option>
              <option value="18">18시</option>
              <option value="19">19시</option>
              <option value="20">20시</option>
              <option value="21">21시</option>
              <option value="22">22시</option>
              <option value="23">23시</option>
            </select>
          </li>
          <li>
            <select name="send_minute" id="send_minute">
              <option value="00">00분</option>
              <option value="05">05분</option>
              <option value="10">10분</option>
              <option value="15">15분</option>
              <option value="20">20분</option>
              <option value="25">25분</option>
              <option value="30">30분</option>
              <option value="35">35분</option>
              <option value="40">40분</option>
              <option value="45">45분</option>
              <option value="50">50분</option>
              <option value="55">55분</option>
            </select>
          </li>
        </ul>
      </div>
      <div class="center_box">
          <a href="#" onClick="msgFunction.fn_ResMessage()" class="blueBtn">예약하기</a>
          <a href="#" onClick="common_modelClose('rsv_mms_sum')" class="grayBtn">닫기</a>
      </div>
      <div class="clear"></div>
  </div>
</div>
<div id="dv_messageGroup_user" class="popup">
  <div class="pop_con">
      <a class="button b-close" onClick="msgFunction.fn_MsgUserCloseInfo()">X</a>
      <h2 class="pop_tit">그룹 사용자 추가</h2>
      <div class="pop_wrap mms_mng_container">
        <div class="mms_selectedUserList whiteBox mms_con1">
          <div class="mms_title"> ▶ 조회 </div>
          <div class="srch_bar" >
            <p class="sel_srch">
              <select id="searchUserGubun" name="searchUserGubun">
				  <option value="">선택</option>
				  <option value="EMP">사용자</option>
				  <option value="USR">고객</option>
			  </select>
			  <select id="searchUserCondition" name="searchUserCondition">
				  <option value="">선택</option>
				  <option value="USERNAME">이름</option>
				  <option value="USERID">아아디</option>
				  <option value="CELLPHNONE">전화번호</option>
			  </select> 
            </p>           

            <p class="sum_srch">
              <input type="text" id="searchUserKeyworkd" name="searchUserKeyworkd">
	          <a href="#" onClick="msgFunction.fn_leftUserSearch()" class="grayBtn">검색</a>
	        </p>
          </div>
          <table class="detail_table" id="tb_searchT">
            <tbody>
              <tr>
                <td>
                   <ul>
                    
                   </ul>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="mms_selectedUserList whiteBox">
          <div class="mms_title"> ▶ 그룹사용자 </div>
          <table class="detail_table" id="tb_groupT">
            <tbody>
              <tr>
                <td>
                   <ul>
                   </ul>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

      </div>
     
      <div class="clear"></div>
  </div>
</div>
<!-- pooup// -->
<script type="text/javascript">
    $(document).ready(function() { 
		if($("#authorCd").val() != "ROLE_ADMIN" && $("#authorCd").val() != "ROLE_SYSTEM") {
			$(".hideAuthor").hide();
		}
		
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
	    $("#search_from").datepicker(clareCalendar);
	    $("#search_to").datepicker(clareCalendar);
	    $("#sendDate").datepicker(clareCalendar);
	    $("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;"); //이미지버튼 style적용
		$("#ui-datepicker-div").hide(); //자동으로 생성되는 div객체 숨김
		$("#sp_msgByte").html("0/80bytes");
		
 	});
    
    var msgFunction = {
   		 fn_CheckForm  : function (){
         	   if (any_empt_line_span("dv_messageGroup", "groupTitle", "시즌명를 입력해 주세요.","sp_message", "savePage") == false) return;
         	   var commentTxt = ($("#mode").val() == "Ins") ? "신규 그룹 정보를 등록 하시겠습니까?" : "입력한  그룹  정보를 저장 하시겠습니까?";
 			   $("#id_ConfirmInfo").attr("href", "javascript:msgFunction.fn_update()");
 	       	   fn_ConfirmPop(commentTxt);
 		 }, fn_update : function(){
 			  $("#confirmPage").bPopup().close();
 			  var url = "/backoffice/sys/msgGroupUpdate.do";
 		      var params = {    'groupCode' : $("#groupCode").val(),
 		    		            'groupTitle' : $("#groupTitle").val(),
 		    		            'groupDc' : $("#groupDc").val(),
 				    		    'groupUseyn' :fn_emptyReplace($("input[name='useYn']:checked").val(),"Y"),
 				    		    'mode' : $("#mode").val()
 		    	               }; 
 		      fn_Ajax(url, "POST", params, false,
 		      			function(result) {
 		    	               if (result.status == "LOGIN FAIL"){
 		 				    	   common_popup(result.message, "Y","dv_messageGroup");
 		   						   location.href="/backoffice/login.do";
 		   					   }else if (result.status == "SUCCESS"){
 		   						   //총 게시물 정리 하기'
 		   						   if ($("#searchGroupTxt").val() == "")
 		   		 		    	     $("#searchGroupTxt").val( $("#groupTitle").val());
 		   		 		           msgFunction.fn_GroupSearch()
 		   					   }else if (result.status == "FAIL"){
 		   						   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "dv_messageGroup");
 		   					   }
 		 				    },
 		 				    function(request){
 		 					    common_popup("Error:" + request.status, "Y", "dv_messageGroup");
 		 				    }    		
 		      );
 		      
 		      $("#dv_messageGroupSearch").bPopup();  
 		 }, fn_MsgInfo : function(mode, groupCode){
 			$("#mode").val(mode);
 			common_modelClose('dv_messageGroupSearch');
 			
	   	    if (mode == "Edt"){
	   	    	
			  	$("#groupCode").val(groupCode).prop('readonly', true);
			  	$("#btnUpdate").text("수정");
			  	var params = {"groupCode" : groupCode};
			  	
			  	var url = "/backoffice/sys/msgGroupDetail.do";
			  	fn_Ajax(url, "GET", params, false,
			     	function(result) {
			  		       if (result.status == "LOGIN FAIL"){
			 			      common_modelCloseM(result.meesage, "Y", "dv_messageGroup");
							  location.href="/backoffice/login.do";
			  		       }else if (result.status == "SUCCESS"){
	 					       var obj  = result.regist;
	 					       $("#groupTitle").val(obj.group_title);
	 					       $("#groupDc").val(obj.group_dc);
	 					       $("input:radio[name='useYn']:radio[value='"+obj.group_useyn+"']").prop('checked', true)
			 			   }else{
			  				   common_modelCloseM(result.message,"dv_messageGroup");
			  			   }
			  		},
			  		function(request){
			  		     common_modelCloseM("Error:" + request.status,"dv_messageGroup");
			  		}
			     );
			}else{
			  	$("#groupCode").val('').prop('readonly', false);
			  	$("#groupTitle").val('');
			  	$("#groupDc").val('');
			  	$("input:radio[name='useYn']:radio[value='Y']").prop('checked', true)
			  	$("#btnUpdate").text("입력");
			}
		    $("#dv_messageGroup").bPopup();  
 		}, fn_GroupPop : function (groupCode){
 			$("#groupCode").val(groupCode);
 			$("#dv_messageGroupSearch").bPopup();
 			$("#searchGroupTxt").val('');
 			$("#tb_groupList > tbody").empty();
 			
        }, fn_GroupSearch : function (){
        	if (any_empt_line_span("dv_messageGroupSearch", "searchGroupTxt", "검색어를  입력해주세요.","sp_message", "savePage") == false) return;
        	$("#dv_messageGroupSearch").bPopup().close();  
        	var params = {"searchKeyword" : $("#searchGroupTxt").val()};
			var returnval = uniAjaxReturn("/backoffice/sys/msgGroupList.do", "POST", false, params,  "lst");
			var html = "";
			if (returnval != ""){
				  
				  $("#tb_groupList > tbody").empty();
				  for (var i in returnval){		
					  html  = "<tr style='text-align:center;'>"
						    + "   <td><input type='checkbox' id='send_GroupCell' name='send_GroupCell' value='"+ returnval[i].group_code +":"+returnval[i].group_title+"'></td>"
							+ "   <td><a href=\"#\" onClick=\"msgFunction.fn_MsgInfo('Edt','"+ returnval[i].group_code+"')\">" + returnval[i].group_title + "</a></td>"
							+ "   <td><a href=\"#\" onClick=\"msgFunction.fn_MsgUserPopInfo('"+ returnval[i].group_code+"')\">" + returnval[i].group_cnt + "</a></td>"
							+ "   <td><a href=\"#\" onClick=\"msgFunction.fn_MsgInfo('Edt','"+ returnval[i].group_code+"')\">" + fn_emptyReplace(returnval[i].group_dc) + "</a></td>"
							+ "   <td>" + returnval[i].last_updt_dtm + "</td>"
							+ "   <td>" + returnval[i].last_updusr_id + "</td>"
							+ "   <td><a href=\"#\" onClick=\"msgFunction.fn_MsgDel('"+ returnval[i].group_code+"')\">삭제</a></td>"
							+ " </tr>";		   					
					  $("#tb_groupList > tbody").append(html);
					  html = "";
				  }
				 
			}else {
				 html  = "<tr><td colspan='5' style='text-align:center'>검색한 내용이 없습니다.</td></tr>"
			     $("#tb_groupList > tbody").append(html);
				 
			}
			 $("#dv_messageGroupSearch").bPopup();  
			
        }, fn_GroupMsgInfo : function (mode, groupCode){
        	$("#mode").val(mode);
        	common_modelOpen("dv_messageGroupSearch","dv_messageGroup");
        }, fn_MsgDel : function (groupCode){
        	 $("#hid_DelCode").val(groupCode)
		     $("#id_ConfirmInfo").attr("href", "javascript:msgFunction.fn_Groupdel()");
			 fn_ConfirmPop("삭제 하시겠습니까?");
        }, fn_Groupdel : function (){
        	var params = {'groupCode':$("#hid_DelCode").val() };
        	fn_uniDelAction("/backoffice/sys/msgGroupDelete.do", "GET", params, false, "msgFunction.fn_GroupSearch");
        }, fn_MsgUserInfo : function (){
        	common_modelOpen("dv_messageGroupSearch","dv_messageGroup_user");
        	//우측 그룹 사용자 리스트 나오게 하기
        	var params = {"groupCode" : $("#groupCode").val()};
			var returnval = uniAjaxReturn("/backoffice/sys/msgGroupUserList.do", "GET", false, params,  "lst");
			$("#tb_groupT > tbody> tr> td> ul").empty();
        	if (returnval.length > 0){
        		var sHtml = "";
        		$("#tb_groupT > tbody> tr> td> ul").append("<li>이름</li>");
        		for (var i in returnval){
        			var obj = returnval[i];
        			sHtml = "<li>"+ obj.group_username +"<span>&lt;"
        			      + ""+ obj.group_user_cellphone+ "&gt;</span>"
        			      + "<span class='delBtn' onClick='msgFunction.fn_GroupUserDel(\""+obj.group_userseq+"\")'>&times;</span></li>";
        			$("#tb_groupT > tbody> tr> td> ul").append(sHtml);
        		}
        	}else {
        		$("#tb_groupT > tbody> tr> td> ul").append("<li>등록된 사용자가 없습니다.</li>");
        	}	
        }, fn_MsgUserCloseInfo : function (){
        	common_modelOpen("dv_messageGroup_user","dv_messageGroupSearch");	
        	msgFunction.fn_GroupSearch();
        }, fn_GroupUserDel : function (groupUserseq){
        	var params = {'groupUserseq': groupUserseq};
        	fn_uniDelAction("/backoffice/sys/msgGroupUserDelete.do", "GET", params, false, "msgFunction.fn_GroupState()");
        	common_modelOpen("savePage","dv_messageGroup_user");
        }, fn_MsgUserPopInfo :  function (groupCode){
        	//검색창에서 그룹 등록 페이지로 이동  
        	common_modelOpen("dv_messageGroupSearch","dv_messageGroup_user");
        	$("#groupCode").val(groupCode);
        	//초기화
        	$("#searchUserGubun").val('');
        	$("#searchUserCondition").val('');
        	$("#searchUserKeyworkd").val('');
        	$("#tb_searchT > tbody> tr> td> ul").empty();
        	//우측 검색
        	msgFunction.fn_MsgUserInfo()
        	
        }, fn_leftUserSearch : function (){
        	//좌측 사용자 검색
        	if (any_empt_line_span("dv_messageGroup_user", "searchUserGubun", "검색할 고객 구분을 선택해 주세요.","sp_message", "savePage") == false) return;
        	if (any_empt_line_span("dv_messageGroup_user", "searchUserCondition", "검색할 조건을  선택해 주세요.","sp_message", "savePage") == false) return;
        	if (any_empt_line_span("dv_messageGroup_user", "searchUserKeyworkd", "검색어를 입력해 주세요.","sp_message", "savePage") == false) return;
        	var params = {
        			      "groupCode" : $("#groupCode").val(),
        			      "searchUserGubun" : $("#searchUserGubun").val(), 
        			      "searchUserCondition" : $("#searchUserCondition").val(),
        			      "searchUserKeyworkd" : $("#searchUserKeyworkd").val(),
        			      };
        	
			var returnval = uniAjaxReturn("/backoffice/sys/msgGroupUserSearchList.do", "POST", false, params,  "lst");
			$("#tb_searchT > tbody> tr> td> ul").empty();
        	if (returnval.length > 0){
        		var sHtml = "";
        		$("#tb_searchT > tbody> tr> td> ul").append("<li>이름</li>");
        		
        		for (var i in returnval){
        			var obj = returnval[i];
	        		if ($("#searchUserGubun").val() == "EMP"){
	        			sHtml = "<li>"+ obj.emp_nm +"("+ obj.dept_nm +")<span>&lt;"
		            	      + ""+ obj.emp_clphn+ "&gt;</span>"
		            	      + "<span class='delBtn' onClick='msgFunction.fn_GroupUserUpdate(\""+obj.emp_nm+"\",\""+obj.dept_nm+"\",\""+obj.emp_clphn+"\")'>&raquo;</span></li>";
		            	
	            	}else {
	        			//사용자 검색 
	        			sHtml = "<li>"+ obj.user_nm +"("+ obj.user_id +")<span>&lt;"
	        			      + ""+ obj.user_phone+ "&gt;</span><br />"
	        			      + "<span class='delBtn' onClick='msgFunction.fn_GroupUserUpdate(\""+obj.user_id+"\",\""+obj.user_nm+"\",\""+obj.user_phone+"\")'>&raquo;</span></li>";
	        		}
	        		$("#tb_searchT > tbody> tr> td> ul").append(sHtml);
	        		sHtml = "";
        		}
        		
        	}else {
        		$("#tb_searchT > tbody> tr> td> ul").append("<li>등록된 사용자가 없습니다.</li>");
        	}
        	$("#dv_messageGroup_user").bPopup();
        	
        }, fn_GroupUserUpdate : function (userId, userNm, userCellp){
       
			var url = "/backoffice/sys/msgGroupUserUpdate.do";
		    var params = {  'groupUserid' : userId,
		    	            'groupUsername' : userNm,
		    	            'groupUserCellphone' : userCellp,
		    	            'groupCode' : $("#groupCode").val(),
			    		    'groupUserGubun' : $("#searchUserGubun").val()
		                   }; 
		    fn_Ajax(url, "POST", params, false,
		    			function(result) {
		                   if (result.status == "LOGIN FAIL"){
		 			    	   common_popup(result.message, "Y","dv_messageGroup_user");
		   					   location.href="/backoffice/login.do";
		   				   }else if (result.status == "OVERLAP FAIL"){
		   					   //총 게시물 정리 하기'
		   					   common_popup(result.message, "N","dv_messageGroup_user");
		   					   msgFunction.fn_GroupState();
		   				   }else if (result.status == "SUCCESS"){
		   					   //총 게시물 정리 하기'
		   					   msgFunction.fn_MsgUserInfo()
		   				   }else if (result.status == "FAIL"){
		   					   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "dv_messageGroup_user");
		   				   }
		 			    },
		 			    function(request){
		 				    common_popup("Error:" + request.status, "Y", "dv_messageGroup_user");
		 			    }    		
		    );
        }, fn_GroupState : function (){
        	msgFunction.fn_MsgUserInfo();
			msgFunction.fn_leftUserSearch();
        }, fn_userSerach : function(){
        	//사용자 검색 페이지 
        	$("#dv_messageUserSerach").bPopup();
        	$("#searchUserGubun_In").val("");
        	$("#searchUserCondition_In").val("");
        	$("#searchUserKeyworkd_In").val("");
        	$("#tb_searchT_User > tbody").empty();
        	
        }, fn_UserSearchRes : function (){
        	$("#dv_messageUserSerach").bPopup().close();
        	if (any_empt_line_span("dv_messageUserSerach", "searchUserGubun_In", "검색할 고객 구분을 선택해 주세요.","sp_message", "savePage") == false) return;
        	if (any_empt_line_span("dv_messageUserSerach", "searchUserCondition_In", "검색할 조건을  선택해 주세요.","sp_message", "savePage") == false) return;
        	if (any_empt_line_span("dv_messageUserSerach", "searchUserKeyworkd_In", "검색어를 입력해 주세요.","sp_message", "savePage") == false) return;
        	var params = {
        			      "searchUserGubun" : $("#searchUserGubun_In").val(), 
        			      "searchUserCondition" : $("#searchUserCondition_In").val(),
        			      "searchUserKeyworkd" : $("#searchUserKeyworkd_In").val()
        			      };
        	
			var returnval = uniAjaxReturn("/backoffice/sys/msgGroupUserSearchList.do", "POST", false, params,  "lst");
			$("#tb_searchT_User > tbody").empty();
        	if (returnval.length > 0){
        		var sHtml = "";
        		if ($("#searchUserGubun_In").val() == "EMP"){
        			for (var i in returnval){
            			var obj = returnval[i];
            			sHtml = "<tr>"
            			      + "   <td><input type='checkbox' id='send_UserCell' name='send_UserCell' value='"+ obj.emp_nm+"<"+obj.emp_clphn+">'></td>"
            			      + "   <td>"+obj.emp_nm +"("+obj.emp_no+")</td>"
            			      + "   <td>"+obj.emp_clphn +"</td>"
            			      + "</tr>";
            			$("#tb_searchT_User > tbody").append(sHtml);
            		} 	
        		}else {
        			//사용자 검색 
        			for (var i in returnval){
            			var obj = returnval[i];
            			sHtml = "<tr>"
            			      + "   <td><input type='checkbox' id='send_UserCell' name='send_UserCell' value='"+ obj.user_nm+"<"+obj.user_phone+">'></td>"
            			      + "   <td>"+obj.user_nm +"("+obj.user_id+")</td>"
            			      + "   <td>"+obj.user_phone +"</td>"
            			      + "</tr>";
            			$("#tb_searchT_User > tbody").append(sHtml);
            		} 	
        		}
        		
        	}else {
        		$("tb_searchT_User > tbody").append("<tr><td colspan='3'>등록된 사용자가 없습니다.</td></tr>");
        	}
        	$("#dv_messageUserSerach").bPopup();
        }, fn_CheckboxAll : function (){
        	//사용자 전체 선택 하기 
        	fn_CheckboxAllChange("send_UserCell",  $("input[name=ck_userAll]").prop("checked"));
        }, fn_UserMsgListUpdate : function(){
           	//하위 값 가지고 오기 
           	// (message, checkboxNm, _modelPop
           	var ckCellPhones = ckeckboxValue("체크된 값이 없습니다", "send_UserCell", "dv_messageUserSerach");
           	msgFunction.fn_smsUserTable(ckCellPhones);
            $("#dv_messageUserSerach").bPopup().close();
        }, fn_indivUser : function (){
        	if (any_empt_line_span_noPop("sms_addUser", "전화번호를 입력해 주세요.") == false) return;
        	msgFunction.fn_smsUserTable( $("#sms_addUser").val() + "<" + $("#sms_addUser").val() + ">");
        	$("#sms_addUser").val('');
        	
        }, fn_smsUserTable : function(telArray){
        	var number = 1;
           	if ($("#tb_UserSendInfo tr").length >0){
           		number = parseInt($("#tb_UserSendInfo tr").length + 1);
           		var td_index = new Array();
           		$("#tb_UserSendInfo tr").each(function(){
           			var text = $(this).children().eq(1).text();
           			if (text.indexOf("<") > 0){
           				var userTelNumber = text.substring(parseInt(text.indexOf("<")) + 1, text.indexOf(">"));
           			}
           			td_index.push(userTelNumber);
               	});
           		//만약 i값이 요청 이면 공집합으로 변경 하기 
           		var new_tr = telArray.split(",").filter(x => !td_index.includes(x)); //
           	}else {
           		var new_tr = telArray.split(",");
           	}
            for (var i in new_tr){
            	var userTelNumber = new_tr[i].indexOf("<")> 0 ? new_tr[i].substring( parseInt( new_tr[i].indexOf("<")) + 1 , new_tr[i].indexOf(">")) : new_tr[i];
            	$("#tb_UserSendInfo tbody:last").append("<tr id='"+userTelNumber+"'><td>"+ parseInt(parseInt(number) + parseInt(i)) +"</td><td>"+ new_tr[i]+"</td><td><a href='javascript:msgFunction.fn_trUserDel(&#39;"+ userTelNumber+"&#39;)'>&times;</a></td></tr>");
            }
        },fn_trUserDel: function (telCode){
        	//user 삭제
        	$("#tb_UserSendInfo tr").filter("#"+telCode).remove();
        }, fn_receiver : function(){
        	//수신자 목록에 저장
        	//user_select02
        	//user_select01
        	$("#tb_receiver tbody> tr> td").empty();
        	if ($('#user_select02').is(':checked') == true){
            	
            	$("#tb_receiver tbody> tr> td").append("<ul><li>이름</li></ul>");
            	$("#tb_UserSendInfo tr").each(function(){
            		var text = $(this).children().eq(1).text();
            		var userTelNumber = text.substring(parseInt(text.indexOf("<")) + 1, text.indexOf(">"));
            		$("#tb_receiver tbody> tr> td> ul:last").append("<li id=\"U_"+userTelNumber+"\">"+text+"<span class=\"delBtn\" onClick=\"msgFunction.fn_receiverDel('U_"+userTelNumber+"')\">&times;</span></li>");
            	});
            	
        	}
			if ($('#user_select03').is(':checked') == true){
				$("#tb_receiver tbody> tr> td:last").append("<ul><li>그룹</li></ul>");
				$("#tb_GroupSendInfo tr").each(function(){
					var text = $(this).children().eq(1).text();
					var id = $(this).attr("id");
            		$("#tb_receiver tbody> tr> td> ul:last").append("<li id=\""+id+"\">"+text+"<span class=\"delBtn\" onClick=\"msgFunction.fn_receiverDel('"+id+"')\">&times;</span></li>");
            	});
			}
        }, fn_GroupMsgListUpdate : function (){
        	var ckCellPhones = ckeckboxValue("체크된 값이 없습니다", "send_GroupCell", "dv_messageGroupSearch");
        	msgFunction.fn_smsGroupTable(ckCellPhones);
        	$("#dv_messageGroupSearch").bPopup().close();
        }, fn_CheckboxGroupAll : function(){
        	fn_CheckboxAllChange("send_GroupCell",  $("input[name=ck_groupAll]").prop("checked"));
        }, fn_smsGroupTable : function(telArray){
        	//sms group 에 넣기 
        	var number = 1;
           	if ($("#tb_GroupSendInfo tr").length >0){
           		number = parseInt($("#tb_UserSendInfo tr").length + 1);
           		var td_index = new Array();
           		$("#tb_GroupSendInfo tr").each(function(){
           			var text = $(this).children().eq(1).text();
           			td_index.push(text);
               	});
           		var new_tr = telArray.split(",").filter(x => !td_index.includes(x)); //
           	}else {
           		var new_tr = telArray.split(",");
           	}
            var groupInfo = new Array();
            for (var i in new_tr){
            	groupInfo = new_tr[i].split(":");
            	$("#tb_GroupSendInfo tbody:last").append("<tr id='"+groupInfo[0]+"'><td>"+ parseInt(parseInt(number) + parseInt(i)) +"</td><td>"+ groupInfo[1]+"</td><td><a href='javascript:msgFunction.fn_trGroupDel(&#39;"+ groupInfo[0]+"&#39;)'>&times;</a></td></tr>");
            }
        }, fn_trGroupDel : function (code){
        	$("#tb_GroupSendInfo tr").filter("#"+code).remove();
        }, fn_receiverDel : function(code){
        	$("#tb_receiver li").filter("#"+code).remove();
        }, fn_megReset : function (){
        	$("#textMessage").val('');
        	$("#sp_msgByte").html("0/80bytes");
        }, fn_megPop : function(page){
        	$("#pageIndex").val(page);
        	var params = {'pageIndex': page};
        	var url = "/backoffice/sys/msgTemplateList.do"
        	fn_Ajax(url, "POST", params, false,
		    			function(result) {
		                   if (result.status == "LOGIN FAIL"){
		 			    	   common_popup(result.message, "Y","save_mms_list");
		   					   location.href="/backoffice/login.do";
		   				   }else if (result.status == "SUCCESS"){
		   					   //총 게시물 정리 하기'
		   					 $("#ul_savemms").empty();		   					 
		   					 $("#sp_msgTempCnt").html(result.totalCnt);
		   					 var sHtml = "";
        	                 for (var i in result.resultlist){
        	                	 var obj = result.resultlist[i];
        	                	 sHtml = "<li>"
        	                           + " <ul>"
        	                           + "   <li><span class=\"date\">"+ obj.last_updt_dtm +"</span>"
        	                           + "       <a href=\"#\" onClick=\"msgFunction.msgTelDel('"+obj.temp_seq+"')\">삭제</a> |"
        	                           + "       <a href=\"#\" onClick=\"msgFunction.msgTelUpdate('"+obj.temp_seq+"')\">수정</a></li>"
        	                           + "   <li><textarea ondblclick=\"msgFunction.msgTelPlay('"+obj.temp_seq+"')\" id=\"tx_"+obj.temp_seq+"\">"+obj.temp_message+"</textarea></li>"
        	                           + " </ul>"
        	                           +"</li>";
        	                	 $("#ul_savemms").append(sHtml);
        	                 }
        	                 //페이징
        	                 var pageObj  = result.paginationInfo;
        	                 var pageHtml = ajaxPaging(pageObj.currentPageNo, pageObj.firstPageNo, pageObj.recordCountPerPage, 
	                                                   pageObj.firstPageNoOnPageList, pageObj.lastPageNoOnPageList, 
	                                                   pageObj.totalRecordCount, pageObj.pageSize, "fn_megPop");
	                        $("#ul_savemms_page").html(pageHtml);
		   				   }else if (result.status == "FAIL"){
		   					   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "save_mms_list");
		   				   }
		 			    },
		 			    function(request){
		 				    common_popup("Error:" + request.status, "Y", "save_mms_list");
		 			    }    		
		    );
        	$("#save_mms_list").bPopup();
        	
        }, msgTelDel : function(tempSeq){
        	//삭제
        	fn_uniDelAction("/backoffice/sys/msgTemplatepDelete.do", "GET", {"delCd" : tempSeq}, false, "");
        	msgFunction.fn_megPop($("#pageIndex").val());
        },msgTelPlay :function (tempSeq){
        	$("#textMessage").val( $("#tx_"+ tempSeq).val());
        	$("#save_mms_list").bPopup().close();
        	updateInputCount('textMessage','sp_msgByte');
        }, msgTelUpdate : function(tempSeq){
            //수정 
            $("#save_mms_list").bPopup().close();
            
        	var url = "/backoffice/sys/msgTemplateUpdate.do";
        	var byteArray = updateInputCount("tx_"+ tempSeq, "") ;
		    var params = {  'tempMessage' : $("#tx_"+ tempSeq).val(),
		    	            'tempMessageByte' : byteArray,
		    	            'tempSeq' : tempSeq,
		    	            'mode' : "Edt"
		                  }; 
		    fn_Ajax(url, "POST", params, false,
		    			function(result) {
		                   if (result.status == "LOGIN FAIL"){
		 			    	   common_popup(result.message, "Y","");
		   					   location.href="/backoffice/login.do";
		   				   }else if (result.status == "SUCCESS"){
		   					   //총 게시물 정리 하기'
		   					  msgFunction.fn_megPop($("#pageIndex").val());
		   				   }else if (result.status == "FAIL"){
		   					   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "save_mms_list");
		   				   }
		 			    },
		 			    function(request){
		 				    common_popup("Error:" + request.status, "Y", "save_mms_list");
		 			    }    		
		    ); 
		    
        }, fn_megSave : function (){
        	if (any_empt_line_span_noPop("textMessage", "저장할 메세지를 입력해 주세요.") == false) return;
        	
        	var url = "/backoffice/sys/msgTemplateUpdate.do";
        	var byteArray = $("#sp_msgByte").html().split("/");
		    var params = {  'tempMessage' : $("#textMessage").val(),
		    	            'tempMessageByte' : byteArray[0] ,
		    	            'mode' : "Ins"
		                  }; 
		    fn_Ajax(url, "POST", params, false,
		    			function(result) {
		                   if (result.status == "LOGIN FAIL"){
		 			    	   common_popup(result.message, "Y","");
		   					   location.href="/backoffice/login.do";
		   				   }else if (result.status == "SUCCESS"){
		   					   //총 게시물 정리 하기'
		   					 common_popup("메세지 보관함에 저장 되었습니다.", "Y", "");
		   				   }else if (result.status == "FAIL"){
		   					   common_popup("저장 도중 문제가 발생 하였습니다.", "Y", "");
		   				   }
		 			    },
		 			    function(request){
		 				    common_popup("Error:" + request.status, "Y", "");
		 			    }    		
		    );
        }, fn_msgSendSave : function(gubun){
        	$("#btn_ClickId").val('');
        	if (any_empt_line_span_noPop("sendTel", "발신자 전화 번호를 입력해 주세요.") == false) return;
        	if (any_empt_line_span_noPop("textMessage", "메세지를 입력해 주세요.") == false) return;
        	
        	
        	
        	if (gubun == "D"){
        		$("#result").val("O");
        		msgFunction.fn_msgSave();
        	}else {
        		$("#rsv_mms_sum").bPopup();
        		$("#result").val("R");
        	}
        }, fn_msgSave : function (){
        	var msgArray = "";
    		if ($('#user_select01').is(':checked') == true){
        		//db 확인 후 가저오기 
        		if ($('input:radio[name=user_SendGubn]').is(':checked') == false){
        			if (any_empt_line_span_noPop("textMessage", "수신자를 선택해 주세요.") == false) return;
        		}
        		
        		if ($('input[name="user_SendGubn"]:checked').val() == "U"){
        			if (any_empt_line_span_noPop("search_from", "기간을 선택해 주세요.") == false) return;
        			if (any_empt_line_span_noPop("search_to", "기간을 선택해 주세요.") == false) return;
        			msgArray = {"step": "U", "sendCnt":  $("#send_U").val(), "from" :  $("#search_from").val(), "to" :  $("#search_to").val()};
        			
        		}else {
        			msgArray = {"step": "E", "sendCnt":  $("#send_G").val()};
        		}
        	}
    		var sendArray = new Array();
    		if ($('#user_select02').is(':checked') == true || $('#user_select03').is(':checked') == true){
        	//구분값 가지고 오기 
            	var sendGubun = ""
            	
            	$("#tb_receiver td > ul >li").each(function(){
            		var messageInfo = new Object();
            		
            		if (typeof  $(this).attr("id") != "undefined"){
            			if ( $(this).attr("id") != "" && $(this).attr("id").indexOf("U_") < 0){
	       		    		messageInfo.groupGubun = "G";
	       		    		messageInfo.groupCode =  $(this).attr("id");
	       		    	}else {
	       		    		messageInfo.groupGubun = "S";
	       		    		messageInfo.groupCode = $(this).text().replace("×", "");
	       		    	}
            			sendArray.push(messageInfo);	
            		}
            	});
            	if (sendArray.length < 1){
            		  $("#sp_Message").html("수신한 전화번호가 없습니다.");
               		  $("#sp_Message").attr("style", "color:red");
               		  $("#savePage").bPopup();
               		  return;
            	}
    		}
    		
    		var params = {"msgArray" : JSON.stringify(msgArray), "sendArray" : JSON.stringify(sendArray), 
    				      "sendTel" : $("#sendTel").val(), "result" : $('#result').val(),
    				      "byte" :  $("#sp_msgByte").html(), "Message": $("#textMessage").val(),
    				      "sendDate" : $("#sendDate").val(), "send_hour" : $("#send_hour").val(), 
    				      "send_minute" : $("#send_minute").val()  
    				      };
    		var url = "/backoffice/sys/msgUpdate.do"
    		fn_Ajax(url, "POST", params, false,
	    			function(result) {
	                   if (result.status == "LOGIN FAIL"){
	 			    	   common_popup(result.message, "Y","");
	   					   location.href="/backoffice/login.do";
	   				   }else if (result.status == "SUCCESS"){
	   					   //총 게시물 정리 하기'
	   					common_popup(result.message, "Y", "");
	   				   }else if (result.status == "FAIL"){
	   					   common_popup("저장 도중 문제가 발생 하였습니다.", "N", "");
	   				   }
	 			    },
	 			    function(request){
	 				    common_popup("Error:" + request.status, "N", "");
	 			    }    		
	        );
        }, fn_ResMessage : function(){
        	if (any_empt_line_span("rsv_mms_sum", "sendDate", "예약일자를  선택해 주세요.","sp_message", "savePage") == false) return;
        	if (any_empt_line_span("rsv_mms_sum", "send_hour", "예약시간를  선택해 주세요.","sp_message", "savePage") == false) return;
        	if (any_empt_line_span("rsv_mms_sum", "send_minute", "예약시간를 선택해 주세요.","sp_message", "savePage") == false) return;
        	msgFunction.fn_msgSave();
        }
    }
    function updateInputCount(_textarea, _span) {

    	var str = $("#"+_textarea).val();
        var str_len = str.length;

        var rbyte = 0;
        var rlen = 0;
        var one_char = "";
        var str2 = "";
        for(var i=0; i<str_len; i++){
            one_char = str.charAt(i);
            if(escape(one_char).length > 4) {
                rbyte += 2;                                         //한글2Byte
            }else{
                rbyte++;                                            //영문 등 나머지 1Byte
            }
            rlen = i+1;  
         }
         if (_span != ""){
        	 if(rbyte > 80){
                 $("#"+_span).html("mms Send") 
             }else{
            	 $("#"+_span).html(rbyte+ "/80bytes");
             }
         }
    }
    
</script>
<c:import url="/backoffice/inc/popup_common.do" />