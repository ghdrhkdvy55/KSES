var backoffice_common = {
     //유료 무료 구분 확인 
     fn_payClassGubun : function(payGubun, payCost, sp_id){
	    	 //유료 무료 구분 PAY_CLASSIFICATION_1 -> 유료 
	    	  var payHtml = "";
	    	  if ( $("#payClassification").val() == "PAY_CLASSIFICATION_1"){
	        	 var _url = "/backoffice/basicManage/CmmnDetailAjax.do"
		    	 var _params = {"codeId" : "PAY_GUBUN"}
	        	 fn_comboList("sp_PayInfo", "payGubun",_url, _params, "", "120px", payGubun);
	        	 payHtml = $("#sp_PayInfo").html() + "<input type='number' id='payCost' name='payCost' value='"+payCost+"' onkeypress='only_num();' style='width:120px;'>";
	         }else { payHtml = "";}	 
             $("#"+sp_id).html(payHtml);
     }, fn_floorSearch : function (floorSeq, span_id, comboboxId){
             var _url = "/backoffice/basicManage/floorListAjax.do";
			 var _params = {"centerId" : $("#searchCenter").val(), "floorUseyn": "Y"};
		     fn_comboListPost(span_id, comboboxId,_url, _params, "", "120px", floorSeq);  
	 }, uniAjax : function(_url, _data, _sendGubun){
	        var returnData = "";
	        $.ajax({
			        type : _sendGubun,
			        url : url,
			        async: false,
			        beforeSend:function(jxFax, settings){
		        	   jxFax.setRequestHeader('AJAX', true);
		            }, 
			        contentType : "application/json; charset=utf-8",
			        data : JSON.stringify(_data),
			        success :function (data, textStatus, jqXHR){
						 if (data.status == "SUCCESS"){
				    		 returnData = data;
						 }else if (data.status == "LOGIN FAIL"){
							 location.href="/backoffice/login.do";
						 }else {
							 alert(data.status);
							 alert(data.message);
						 }
					},
					error: function (jqXHR, textStatus, errorThrown){
						alert(textStatus + ":" + errorThrown);
					}
		    });
	        return returnData;
	        
	 }, fn_floorPlayState : function (floorPlaySeq, span_id, checkboxField){
		  var _url = "/backoffice/basicManage/floorListAjax.do";
	      var _params = {"centerId" : $("#centerId").val(), "floorUseyn": "Y"};
	      fn_checkListPost(span_id, checkboxField,_url, _params, floorPlaySeq, "");
	 }, fn_floorInfo : function (floorSeq, span_id, comboboxId){
			  var _url = "/backoffice/basicManage/floorListAjax.do";
			  var _params = {"centerId" : $("#centerId").val(), "floorUseyn": "Y"};
		      fn_comboListPost(span_id, comboboxId,_url, _params, "", "120px", floorSeq);  
	 } , fn_adminForm : function(gubun){
	        if (gubun == "admin"){
	            $("#tb_formInfo").hide();
	            $("#tb_searchform").show();
	        }else{
	            $("#tb_formInfo").show();
	            $("#tb_searchform").hide();
	        }
	 
	 },  fn_empSearch : function(){
			  //직원 조회
			  var params = {"searchCondition" : $("#emSearchCondition").val(), "searchKeyword" : $("#emSearchKeyword").val(), "mode" : "pop" };
			  uniAjax("/backoffice/orgManage/empListAjax.do", params, 
		     			function(result) {
				               if (result.status == "LOGIN FAIL"){
						    	   alert(result.message);
		  						   location.href="/backoffice/login.do";
		  					   }else if (result.status == "SUCCESS"){
								   $("#tb_searchform > tbody").empty();
								   var obj = result.resultlist;
								   var shtml = ""
								   for (var i in obj){
									   shtml= "<tr onclick=\"backoffice_common.fn_empChoice('meetingAdminid','"+obj[i].empno+"','sp_empView','"+obj[i].empname+"')\">"
										    + " <td>" + obj[i].deptname +"</td>"
										    + " <td>" + obj[i].empname +"</td>"
										    + " <td>" + obj[i].empno +"</td>"
									        + "</tr>";
									   $("#tb_searchform > tbody").append(shtml);
		  						       sHtml = "";  
								   }
							   }else {
									alert("업데이트 도중 문제가 발생 하였습니다.");
							   }	
						 },
						 function(request){
							    alert("Error:" +request.status );	       						
						 }    		
		     );    
	}, fn_empChoice : function (_returnFrom, _returnVal, _returnView, _viewNm){
	    $("#"+_returnFrom).val(_returnVal);
	    $("#"+_returnView).text(_viewNm);
	    backoffice_common.fn_adminForm('form');
	} 
}

