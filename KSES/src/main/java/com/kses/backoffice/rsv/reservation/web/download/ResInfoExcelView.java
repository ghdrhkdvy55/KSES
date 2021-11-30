package com.kses.backoffice.rsv.reservation.web.download;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import com.kses.backoffice.util.SmartUtil;

@SuppressWarnings("deprecation")
public class ResInfoExcelView extends AbstractExcelView{

	private static final Logger LOGGER = LoggerFactory.getLogger(ResInfoExcelView.class);
	
	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> model,
										HSSFWorkbook workbook, 
										HttpServletRequest request,
										HttpServletResponse response) throws Exception {
		
		try{
			response.setHeader("Content-Disposition", "attachment; filename=\"" + getClass().getSimpleName() + ".xls\"");
	
			HSSFCell cell = null;
	
			HSSFSheet sheet = workbook.createSheet("예약현황");
			sheet.setDefaultColumnWidth(9);
			
			// put text in first cell
			cell = getCell(sheet, 0, 0);
			setText(cell, "예약관리");
			setText(getCell(sheet, 2, 0), "No.");
			setText(getCell(sheet, 2, 1), "부서");
			setText(getCell(sheet, 2, 2), "이름");
			setText(getCell(sheet, 2, 3), "사번");
			setText(getCell(sheet, 2, 4), "연락처");
			setText(getCell(sheet, 2, 5), "메일");
			setText(getCell(sheet, 2, 6), "지점");
			setText(getCell(sheet, 2, 7), "층수");
			setText(getCell(sheet, 2, 8), "예약구분");
			setText(getCell(sheet, 2, 9), "시설명");
			setText(getCell(sheet, 2, 10), "제목");
			setText(getCell(sheet, 2, 11), "신청일");
			setText(getCell(sheet, 2, 12), "예약일자");
			setText(getCell(sheet, 2, 13), "사용크레딧");
			setText(getCell(sheet, 2, 14), "결제상태");
			setText(getCell(sheet, 2, 15), "요청사항");
			setText(getCell(sheet, 2, 16), "행사규모");
			setText(getCell(sheet, 2, 17), "승인자");
			setText(getCell(sheet, 2, 18), "최종승인일자");
			setText(getCell(sheet, 2, 19), "반려사유유형");
			setText(getCell(sheet, 2, 20), "반려사유");
			
			
			List<Map<String, Object>> goods = (List<Map<String, Object>>) model.get("resReport");
			for (int i = 0; i < goods.size(); i++) {
				Map<String, Object> resVO = goods.get(i);
	
				cell = getCell(sheet, 3 + i, 0);
				setText(cell, Integer.toString(i + 1));
				cell = getCell(sheet, 3 + i, 1);
				setText(cell, SmartUtil.NVL(resVO.get("deptname"), "").toString());
				cell = getCell(sheet, 3 + i, 2);
				setText(cell, SmartUtil.NVL(resVO.get("empname"), "").toString());
				cell = getCell(sheet, 3 + i, 3);
				setText(cell, SmartUtil.NVL(resVO.get("empno"), "").toString());
				cell = getCell(sheet, 3 + i, 4);
				setText(cell, SmartUtil.NVL(resVO.get("emphandphone"), "").toString());
				cell = getCell(sheet, 3 + i, 5);
				setText(cell, SmartUtil.NVL(resVO.get("empmail"), "").toString());
				cell = getCell(sheet, 3 + i, 6);				
				setText(cell, SmartUtil.NVL(resVO.get("center_nm"), "").toString());
				cell = getCell(sheet, 3 + i, 7);				
				setText(cell, SmartUtil.NVL(resVO.get("floor_name"), "").toString());
				cell = getCell(sheet, 3 + i, 8);
				setText(cell, SmartUtil.NVL(resVO.get("item_gubun_t"), "").toString());
				cell = getCell(sheet, 3 + i, 9);
				setText(cell, SmartUtil.NVL(resVO.get("item_name"), "").toString());
				cell = getCell(sheet, 3 + i, 10);
				setText(cell, SmartUtil.NVL(resVO.get("res_title"), "").toString());
				cell = getCell(sheet, 3 + i, 11);
				String resdayinfo = (SmartUtil.NVL(resVO.get("item_gubun"), "").toString().equals("ITEM_GUBUN_3")) ? 
						SmartUtil.NVL(resVO.get("resstartday"), "") +"일 " + SmartUtil.NVL(resVO.get("resstarttime"), "") + " 부터 ~" + SmartUtil.NVL(resVO.get("resendday"), "") +"일 " + SmartUtil.NVL(resVO.get("resendtime"), "")  + "까지"
                        : SmartUtil.NVL(resVO.get("resstartday"), "")+"일 "+ SmartUtil.NVL(resVO.get("resstarttime"), "")+ "~"+ SmartUtil.NVL(resVO.get("resendtime"), "");
				setText(cell, resdayinfo );
				cell = getCell(sheet, 3 + i, 12);
				setText(cell, SmartUtil.NVL(resVO.get("reg_date"), "").toString());
				cell = getCell(sheet, 3 + i, 13);
				setText(cell, SmartUtil.NVL(resVO.get("tenn_cnt"), "").toString());	
				cell = getCell(sheet, 3 + i, 14);
				setText(cell, SmartUtil.NVL(resVO.get("reservprocessgubuntxt"), "").toString() );
				cell = getCell(sheet, 3 + i, 15);
				setText(cell, SmartUtil.NVL(resVO.get("res_remark"), "").toString());
				cell = getCell(sheet, 3 + i, 16);
				setText(cell, SmartUtil.NVL(resVO.get("res_person"), "").toString());
				cell = getCell(sheet, 3 + i, 17);
				setText(cell, SmartUtil.NVL(resVO.get("proxyyntxt"), "").toString());
				cell = getCell(sheet, 3 + i, 18);
				setText(cell, SmartUtil.NVL(resVO.get("updatedate"), "").toString());
				cell = getCell(sheet, 3 + i, 19);
				setText(cell, SmartUtil.NVL(resVO.get("cancelcodetxt"), "").toString());
				cell = getCell(sheet, 3 + i, 20);
				setText(cell, SmartUtil.NVL(resVO.get("cancel_reason"), "").toString());
				
				
			}
		}catch(Exception e){
			LOGGER.info("error:" + e.toString());
		}
	}
}

