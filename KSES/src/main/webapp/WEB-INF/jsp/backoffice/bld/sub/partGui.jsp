<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/css/backoffice/cbp-spmenu.css">
<script type="text/javascript" src="/resources/js/classie.js"></script>
<!-- Xlsx -->
<script type="text/javascript" src="/resources/js/xlsx.full.min.js"></script>
<!-- FileSaver -->
<script src="/resources/js/FileSaver.min.js"></script>
<div class="title">
    <h3><span id="centerNm"></span>점 <span name="floorNm"></span> <span id="partNm"></span> 구역 GUI 화면</h3>
</div>
<div class="back_map">
    <div class="box_shadow" style="width:1000px;">
        <div class="page">
            <div class="map_box_sizing">
                <div class="mapArea">
                    <ul id="partLayer"></ul>
                </div>
            </div>
        </div>
    </div>
    <div class="box_shadow" style="width:680px;">
        <div class="custom_bg">
            <div class="txt_con">
                <p>층 선택</p>
            </div>
            <table class="search_tab">
                <tr>
                    <th>층</th>
                    <td><b><span name="floorNm"></span></b></td>
                    <th>구역</th>
                    <td><select id="searchPart"></select></td>
                </tr>
            </table>
        </div>
        <div class="gui_text">
            <div class="txt_con">
                <p>좌석 설정</p>
                <a href="javascript:PartGui.save();" class="defaultBtn">저장</a>
                <a href="javascript:PartGui.excelDownload();" class="defaultBtn" style="margin-right:10px;">엑셀다운로드</a>
                <a href="javascript:$('[data-popup=seat_excel_upload]').bPopup();" class="defaultBtn" style="margin-right:10px;">엑셀업로드</a>
                <a href="javascript:$('[data-popup=bld_seat_add]').bPopup()" class="defaultBtn" style="margin-right:10px;">좌석일괄등록</a>
               
            </div>
            <div class="scroll_table" style="width:650px;height:508px;padding-top:0px;">
                <div style="width:650px;">
                    <table id="guiPartGrid"></table>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
</div>
<div class="title" style="padding:12px 40px;">
    <div style="float:right;padding-right:56px;">
        <a href="javascript:PartGui.open();" class="grayBtn">닫기</a>
    </div>
</div>
<script type="text/javascript">
    const PartGuiGridId = 'guiPartGrid';
    const PartGuiGridSelector = '#'+ PartGuiGridId;
    $.PartGui = function() {
        EgovJqGridApi.defaultGrid(PartGuiGridId, [
            { label: '좌석코드', name: 'seat_cd', key: true, hidden: true },
            { label: '좌석번호', name: 'seat_number', align: 'center', sortable: false },
            { label: '좌석명', name: 'seat_nm', align: 'center', sortable: false },
            { label: 'TOP', name: 'seat_top', align: 'center', sortable: false, editable: true, editoptions: EgovJqGridApi.getGridEditOption(4) },
            { label: 'LEFT', name: 'seat_left', align: 'center', sortable: false, editable: true, editoptions: EgovJqGridApi.getGridEditOption(4) },
            { label: '정렬순서', name: 'seat_order', hidden: true },
        ], false).jqGrid('setGridParam', {
            cellEdit: true,
            cellsubmit: 'clientArray',
            beforeSaveCell: function(rowId, name, val) {
                switch (name) {
                    case 'seat_top':
                    case 'seat_left':
                        if (val < 0) {
                            return 0;
                        }
                    default:
                }
            },
            afterSaveCell: function(rowId, name, val) {
                PartGui.setPartSeat(rowId, name, val);
            }
        });
    };
    $.PartGui.prototype = Object.create(ParentGUI);
    $.PartGui.prototype.getGui = function() {
        return $('nav#cbp-spmenu-part');
    };
    $.PartGui.prototype.open = function(floorCd, floorName) {
        classie.toggle(this.getGui()[0], 'cbp-spmenu-open');
    };
    
    $.PartGui.prototype.initialize = function(partCd, floorCd) {
    	$('#floorCd').val(floorCd);
    	$('#partCd').val(partCd);    	
    	let $panel = this.getGui();
        let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
        let rowData = EgovJqGridApi.getGridRowData('centerGrid', rowId);
        $('#centerNm', $panel).text(rowData.center_nm);
        this.initMap($panel);
        this.setComboList(floorCd, partCd);
        this.getDetail('/backoffice/bld/partDetail.do', { partCd: partCd }, function(data) {
            $('span[name=floorNm]', $panel).text(data.floor_nm);
            $('#partNm', $panel).text(data.part_nm);
            PartGui.setMap($panel, data.part_map1);
        });
        this.initLayer($panel);
        EgovJqGridApi.defaultGridAjax(PartGuiGridId, '/backoffice/bld/seatListAjax.do', {
            searchCenter: rowId,
            searchFloorCd: floorCd,
            searchPartCd: partCd,
            useYn: 'Y',
            pageIndex: '1',
            pageUnit: '500'
        }, 500, this.drawPartSeat);
    	this.open();
    };

    $.PartGui.prototype.setComboList = function(floorCd, partCd) {
        let $panel = this.getGui();
        let $select = $('#searchPart', $panel);
        EgovIndexApi.apiExecuteJson(
            'GET',
            '/backoffice/bld/partInfoComboList.do', {
                floorCd: floorCd
            },
            function(xhr) {
                $select.empty();
            },
            function(json) {
                let list = json.resultlist;
                for (let item of list) {
                    let $option = $('<option value="'+ item.part_cd +'">'+ item.part_nm +'</option>').data('item', item).appendTo($select);
                    if (partCd === item.part_cd) {
                        $option.prop('selected', true);
                    }
                }
                $select.off('change').on('change', function() {
                    let data = $(this).find('option:selected').data('item');
                    PartGui.initialize(data.part_cd, data.floor_cd);
                    PartGui.open();
                });
            },
            function(json) {
                toastr.error(json.message);
            }
        );
    };

    $.PartGui.prototype.setPartSeat = function(rowId, type, val) {
        let $panel = PartGui.getGui();
        $.each($('#partLayer', $panel).find('li'), function() {
            let data = $(this).data('item');
            if (data.seat_cd === rowId) {
                switch (type) {
                    case 'seat_top':
                        $(this).css('top', val+'px');
                        break;
                    case 'seat_left':
                        $(this).css('left', val+'px');
                        break;
                    default:
                }
                return false;
            }
        });
    };

    $.PartGui.prototype.drawPartSeat = function(list) {
        let $panel = PartGui.getGui();
        for (let item of list) {
            let seat = $(
                '<li class="seat" style="opacity:0.7;display:inline-block;width:30px;height:30px;cursor:default;"></li>'
            ).data('item', item).css({
                top: item.seat_top +'px',
                left: item.seat_left +'px',
            }).appendTo($('#partLayer', $panel));
            $(seat).draggable({
                containment: '#cbp-spmenu-part .mapArea',
                start: function() {
                    EgovJqGridApi.selection(PartGuiGridId, $(this).data('item').seat_cd);
                    let rowId = EgovJqGridApi.getGridSelectionId(PartGuiGridId);
                    $(PartGuiGridSelector).closest('.scroll_table').scrollTop($('#'+$.jgrid.jqID(rowId))[0].offsetTop);
                },
                stop: function() {
                    EgovJqGridApi.selection(PartGuiGridId);
                },
                drag: function(e, ui) {
                    let rowId = EgovJqGridApi.getGridSelectionId(PartGuiGridId);
                    $(PartGuiGridSelector).jqGrid('setRowData', rowId, {
                        seat_top: Math.floor(ui.position.top),
                        seat_left: Math.floor(ui.position.left)
                    });
                    PartGui.gridCellEdited(rowId);
                }
            }).append(
                '<div class="section">'+ (item.seat_number === undefined ? '' : item.seat_number) +'</div>'
            );
        }
    };

    $.PartGui.prototype.save = function() {
        let changedArr = $(PartGuiGridSelector).jqGrid('getChangedCells', 'all');
        if (changedArr.length === 0) {
            toastr.info('변경된 좌석이 없습니다.');
            return;
        }
        let params = new Array();
        changedArr.forEach(x =>
            params.push({
                seatCd: x.seat_cd,
                seatTop: x.seat_top,
                seatLeft: x.seat_left
            })
        );
        bPopupConfirm('좌석 위치 변경', changedArr.length +'건에 대해 수정 하시겠습니까?', function() {
            EgovIndexApi.apiExecuteJson(
                'POST',
                '/backoffice/bld/seatGuiUpdate.do',
                params,
                null,
                function(json) {
                    toastr.success(json.message);
                },
                function(json) {
                    toastr.error(json.message);
                }
            );
        });
    };

    $.PartGui.prototype.excelDownload = function() {
        if ($(PartGuiGridSelector).getGridParam("reccount") === 0) {
            toastr.warning('다운받으실 데이터가 없습니다.');
            return;
        }
        let list = $(PartGuiGridSelector).jqGrid('getRowData');
        let excelData = new Array();
        excelData.push(['좌석코드', '좌석번호', '좌석명', 'TOP', 'LEFT', '정렬순서']);
        for (let idx in list) {
            let arr = new Array();
            arr.push(list[idx].seat_cd);
            arr.push(list[idx].seat_number);
            arr.push(list[idx].seat_nm);
            arr.push(list[idx].seat_top);
            arr.push(list[idx].seat_left);
            arr.push(list[idx].seat_order);
            excelData.push(arr);
        }
        let wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(excelData), 'sheet1');
        saveAs(new Blob([EgovIndexApi.s2ab(
            XLSX.write(wb, { bookType: 'xlsx', type: 'binary' })
        )],{ type: 'application/octet-stream' }), '구역GUI_좌석목록.xlsx');
	};
	
	/* $.PartGui.prototype.fnSeatExcelUpload = function() {
		// 엑셀업로드
		bPopupConfirm('좌석 엑셀 업로드', '엑셀 업로드를 좌석 설정을 진행하시겠습니까?', function() {
			let $popup = $('[data-popup=seat_excel_upload]');
			let $input = $popup.find(':file')[0];
			let reader = new FileReader();
			reader.onload = function() {
				let wb = XLSX.read(reader.result, {type: 'binary'});
				let sheet = wb.Sheets[wb.SheetNames[0]];
				let json = XLSX.utils.sheet_to_json(sheet);
				for (let row of json) {
					Object.keys(row).forEach(k => {
						switch (k) {
							case '좌석코드':
								row['seatCd'] = row[k];
								break;
							case '좌석번호':
								row['seatNumber'] = row[k]
								break;
							case '좌석명':
								row['seatNm'] = row[k];
								break;
							case 'TOP':
								row['seatTop'] = row[k];
								break;
							case 'LEFT':
								row['seatLeft'] = row[k];
								break;
							case '정렬순서':
								row['seat_order'] = row[k];
								break;
							default:
						}
						delete row[k];
					});
				}
				EgovIndexApi.apiExecuteJson(
					'POST',
					'/backoffice/bld/SeatExcelUpload.do', {
						data: JSON.stringify(json),
					},
					null,
					function(json) {
						toastr.success(json.message);
						$popup.bPopup().close();
						fnSearch(1);
					},
					function(json) {
						toastr.error(json.message);
					}
				);
			};
			reader.readAsBinaryString($input.files[0]);
		});
	}; */
    

    const PartGui = new $.PartGui();
</script>