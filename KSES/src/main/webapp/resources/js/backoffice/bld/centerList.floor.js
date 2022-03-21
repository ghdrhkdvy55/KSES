$.Floor = function() {};

$.Floor.prototype.mainGridSettings = function() {
    MainGridAjaxUrl = '/backoffice/bld/floorListAjax.do';
    EgovJqGridApi.mainGrid([
        { label: '지점층코드', name: 'floor_cd', key: true, hidden: true },
        { label: '도면이미지', name: 'floor_map1', align: 'center', sortable: false, formatter: (c, o, row) =>
            '<img src="'+ (row.floor_map1 === 'no_image.png' ? '/resources/img/no_image.png'
                    : '/upload/'+ row.floor_map1) +'" style="width:120px;"/>'
        },
        { label: '층이름', name: 'floor_nm', align: 'center', sortable: false },
        { label: '사용여부', name:'use_yn', align: 'center', sortable: false, formatter: (c, o, row) =>
            c === 'Y' ? '사용' : '사용안함'
        },
        { label: '좌석수', name:'floor_seat_cnt', align: 'center', sortable: false },
        { label: '구역사용구분', name:'floor_part_dvsn', hidden: true },
        { label: '수정', align:'center', sortable: false, width: 50, fixed: true, formatter: (c, o, row) =>
            '<a href="javascript:Floor.popupFloorInfo(\''+ row.floor_cd + '\');" class="edt_icon"></a>'
        },
        { label: 'GUI', align:'center', sortable: false, width: 50, fixed: true, formatter: (c, o, row) =>
            row.floor_map1 === null || row.floor_map1 === 'no_image.png' ? ''
                : '<a href="javascript:Floor.guiFloor(\'' + row.floor_cd + '\');" class="gui_icon"></a>'
        }
    ], false, true, fnSearch, false).jqGrid('setGridParam', {
        isHasSubGrid: function(rowId) {
            let rowData = EgovJqGridApi.getMainGridRowData(rowId);
            if (rowData.floor_part_dvsn === 'FLOOR_PART_2') {
                return false;
            }
            return true;
        }
    });
    $('#rightAreaUqBtn').html(
        '<a href="javascript:Floor.popupPartInfo();" class="orangeBtn">구역등록</a>'
    ).show();
};

$.Floor.prototype.subFloorPartGrid = function(parentId, rowId) {
    EgovJqGridApi.subGrid(parentId, [
        { label: '구역코드', name:'part_cd', key: true, hidden: true },
        { label: '도면이미지', name: 'part_map1', align: 'center', sortable: false, formatter: (c, o, row) =>
            '<img src="'+ (row.part_map1 === 'no_image.png' || row.part_map1 === undefined ? '/resources/img/no_image.png'
                : '/upload/'+ row.part_map1) +'" style="width:120px;"/>'
        },
        { label: '구역명', name: 'part_nm', align: 'center' },
        { label: '좌석수', name: 'seat_cnt', align: 'center' },
        { label: '사용여부', name: 'use_yn', align: 'center' },
        { label: '수정', align: 'center', width: 50, fixed: true, formatter: (c, o, row) =>
            '<a href="javascript:Floor.popupPartInfo(\'' + row.part_cd + '\');" class="edt_icon"></a>'
        },
        { label: 'GUI', align:'center', sortable: false, width: 50, fixed: true, formatter: (c, o, row) =>
        	row.part_map1 === null || row.part_map1 === 'no_image.png' ? '' :
            	'<a href="javascript:Floor.guiPart(\'' + row.part_cd + '\', \'' + row.floor_cd + '\');" class="gui_icon"></a>'
        }
    ], 'POST', '/backoffice/bld/partListAjax.do', {
        floorCd: rowId
    });
};

$.Floor.prototype.updateSettings = function(ajaxUpdate, changedArr) {
    ajaxUpdate.title = '층정보 수정';
    ajaxUpdate.url = '/backoffice/bld/floorInfoListUpdate.do';
    changedArr.forEach(x => ajaxUpdate.params.push({
        floorCd: x.floor_cd,
        floorNm: x.floor_nm,
        useYn: x.use_yn
    }));
};

$.Floor.prototype.popupFloorInfo = function(rowId) {
    FloorInfo.bPopup(rowId);
};

$.Floor.prototype.popupPartInfo = function(rowId) {
    if (rowId === undefined || rowId === null) {
        if (EgovJqGridApi.getMainGridSingleSelectionId() === null) {
            toastr.warning('층 목록을 선택하여 주세요.');
            return false;
        }
    }
    PartInfo.bPopup(rowId);
};

$.Floor.prototype.guiFloor = function(rowId) {
    FloorGui.initialize(rowId);
};

$.Floor.prototype.guiPart = function(rowId, parentId) {
	PartGui.initialize(rowId, parentId);
}

const Floor = new $.Floor();
const ParentGUI = {
    initMap: function(_panel) {
        $('.mapArea', _panel).css({
            'background': 'url(/resources/img/no_map.png)',
            'background-repeat': 'no-repeat',
            'background-position': 'center'
        });
    },
    setMap: function(_panel, _fileNm) {
        $('.mapArea', _panel).css({
            'background': 'url(/upload/'+ _fileNm +')',
            'background-repeat': 'no-repeat',
            'background-position': 'center'
        });
    },
    initLayer: function(_panel) {
        $('#partLayer', _panel).empty();
    },
    getDetail: function(_url, _params, callback) {
        EgovIndexApi.apiExecuteJson(
            'GET',
            _url,
            _params,
            null,
            function(json) {
                callback(json.result);
            },
            function(json) {
                toastr.error(json.message);
            }
        );
    },
    gridCellEdited: function(rowId) {
        $("#"+$.jgrid.jqID(rowId)).removeClass('edited').addClass('edited');
    },
};