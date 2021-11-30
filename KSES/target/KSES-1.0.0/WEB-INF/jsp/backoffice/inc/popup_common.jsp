<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div data-popup="savePage" id="savePage" class="popup m_pop">
      <div class="pop_con">
        <a id="a_closePop" class="button b-close">X</a>
        <p class="pop_tit">메세지</p>
        <p class="pop_wrap"><span id="sp_Message"></span></p>
        <div class="right_box" id="db_closePop">
            <a href="#" onClick="fn_BeforePop()" class="grayBtn">확인</a>
        </div>
      </div>
</div>
<div data-popup="confirmPage" id="confirmPage" class="popup m_pop">
      <div class="pop_con">
        <a id="a_closePop" class="button b-close">X</a>
        <p class="pop_tit">메세지</p>
        <p class="pop_wrap"><span id="sp_MessageAlert"></span></p>
        <div class="left_box">
          <a href="" id="id_ConfirmInfo" class="blueBtn">예</a>
          <a href="javascript:fn_ConfirmClose()" class="grayBtn">아니요</a>
      </div>
      </div>
</div>

<div  id="dv_excelUpload" class="popup m_pop">
      <div class="pop_con">
        <a id="a_closePop" class="button b-close">X</a>
        <p class="pop_tit">엑셀 업로드</p>
        <p class="pop_wrap"><input type="file" id="excel_file_input" accept="xlsx/*"></p>
        <div class="left_box">
        <div class="right_box" id="db_closePop">
            <a href="#" id="aUploadId" class="grayBtn">확인</a>
        </div>  
      </div>
      </div>
</div>

<button type="button" id="btn_Message" style="display:none" data-popup-open="savePage"></button>
<input type="hidden" id="btn_ClickId" style="display:none" />
<!--  삭제 코드 -->
<input type="hidden" id="hid_DelCode" name="hid_DelCode" style="display:none" />

<script type="text/javascript">
   function fn_BeforePop(){
	   $("#savePage").bPopup().close();
	   var btn_ClickId =  $("#btn_ClickId").val();
	   if (btn_ClickId != "")
	       $("#"+ btn_ClickId).bPopup();
   }
   function fn_ConfirmPop(alertMessage){
	   $("#sp_MessageAlert").html(alertMessage);
	   $("#confirmPage").bPopup();
   }
   function fn_ConfirmClose(){ 
	   $("#hid_DelCode").val('')
	   $("#id_ConfirmInfo").attr("href","");
	   $("#confirmPage").bPopup().close();
   }
   function fn_Upload (){
		$("#dv_excelUpload").bPopup();
		$("#aUploadId").attr("href", "javascript:fn_excelUpload()");
   }
   function fn_excelUpload (_sheetInt, callback){
		var input = $("#excel_file_input")[0]; //event.target;
	    var reader = new FileReader();
	    reader.onload = function(){
	        var fileData = reader.result;
	        var wb = XLSX.read(fileData, {type : 'binary'});
	        var sheetNameList = wb.SheetNames; // 시트 이름 목록 가져오기 
	        var sheetName = sheetNameList[parseInt(_sheetInt)]; //  시트명
	        var jsonSheet = wb.Sheets[sheetName]; // 첫번째 시트 
	        callback(sheetNameList, sheetName, JSON.stringify(XLSX.utils.sheet_to_json (jsonSheet)));      
	    };
	    reader.readAsBinaryString(input.files[0]);
   }
   function handleExcelDataAll(sheet){
		handleExcelDataHeader(sheet); // header 정보 
		handleExcelDataJson(sheet); // json 형태
		handleExcelDataCsv(sheet); // csv 형태
		handleExcelDataHtml(sheet); // html 형태
	}
	function handleExcelDataHeader(sheet){
	    var headers = get_header_row(sheet);
	    $("#displayHeaders").html(JSON.stringify(headers));
	}
	function handleExcelDataJson(sheet){
	    $("#displayExcelJson").html(JSON.stringify(XLSX.utils.sheet_to_json (sheet)));
	}
	function handleExcelDataCsv(sheet){
	    $("#displayExcelCsv").html(XLSX.utils.sheet_to_csv (sheet));
	}
	function handleExcelDataHtml(sheet){
	    $("#displayExcelHtml").html(XLSX.utils.sheet_to_html (sheet));
	}
	// 출처 : https://github.com/SheetJS/js-xlsx/issues/214
	function get_header_row(sheet) {
	    var headers = [];
	    var range = XLSX.utils.decode_range(sheet['!ref']);
	    var C, R = range.s.r; /* start in the first row */
	    /* walk every column in the range */
	    for(C = range.s.c; C <= range.e.c; ++C) {
	        var cell = sheet[XLSX.utils.encode_cell({c:C, r:R})] /* find the cell in the first row */
	        var hdr = "UNKNOWN " + C; // <-- replace with your desired default 
	        if(cell && cell.t) hdr = XLSX.utils.format_cell(cell);
	        headers.push(hdr);
	    }
	    return headers;
	}

 
</script>