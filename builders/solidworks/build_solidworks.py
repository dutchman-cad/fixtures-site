# Generated from the shared SolidWorks recipe spec. Python 3 + pywin32.
# Full template paths; empty means automatic discovery.
TEMPLATE_PART = ""
TEMPLATE_ASSEMBLY = ""
TEMPLATE_DRAWING = ""

swInputDimValOnCreate = 10
swShowErrorsEveryRebuild = 77
swRebuildActiveDoc = 2
swWarnSaveUpdateErrors = 329
swRebuildErrorAction = 306
swContinueResponse_Stop = 1
swDefaultTemplatePart = 8
swDefaultTemplateAssembly = 9
swDefaultTemplateDrawing = 10
swFileLocationsDocumentTemplates = 6
swSolidBody = 0
swFmEdgeFlange = 37
swBendAllowanceKFactor = 2
swSheetMetalReliefRectangular = 1
swSheetMetalReliefObround = 3
swReliefTearTypeRip = 1
swSheetMetalReliefTear = 2
swFlangePositionTypeMaterialInside = 1
swFlangePositionTypeMaterialOutside = 2
swFlangeDimTypeOuterVirtualSharp = 1
swFlangeDimTypeInnerVirtualSharp = 2
swFlangeOffsetBlind = 1
swHemTypeOpen = 0
swHemTypeClosed = 1
swHemPositionTypeInside = 0
swBreakCornerTypeFillet = 0
swCornerReliefError_InvalidBody = 2
swMateDISTANCE = 5
swAddMateError_ErrorUknown = 0
swSuppressionChangeOk = 2
swThisConfiguration = 1
swAddMateError_NoError = 1
swFmFillet = 1
swFmBaseFlange = 34
swFmCornerRelief = 120
swFmVarFillet = 23
swFmSweep = 17
swFeatureFilletType_VariableRadius = 1
swCornerReliefBendType_TwoBend = 0
swCornerCircularRelief = 0
swCornerSquareRelief = 1
swCornerTearRelief = 3
swEndCondBlind = 0
swChamferAngleDistance = 1
swMateTANGENT = 4
swMateAlignALIGNED = 0
swMateAlignANTI_ALIGNED = 1
swMateCOINCIDENT = 0
swMateANGLE = 6
swMateAlignCLOSEST = 2
swSuppressFeature = 0
swMateCONCENTRIC = 1
swComponentHidden = 0
swComponentVisible = 1
swSpecifyDisplayState = 3
swDocASSEMBLY = 2
swOpenDocOptions_Silent = 1
swDocPART = 1
swViewEntityType_Edge = 1
swDxfVersion = 0
swDxfFormat_R2000 = 3
swHelixDefinedBy_PitchAndRevolution = 0
swHelixDefinedBy_HeightAndRevolution = 1
swHelixDefinedBy_HeightAndPitch = 2
swHelixDefinedBy_Spiral = 3
swVariablePitchHelixRegionParameter_Revolution = 0
swVariablePitchHelixRegionParameter_Pitch = 1
swVariablePitchHelixRegionParameter_Height = 2
swVariablePitchHelixRegionParameter_Diameter = 3
swRefPlaneReferenceConstraint_Perpendicular = 2
swRefPlaneReferenceConstraint_Coincident = 4
swRefPlaneReferenceConstraint_OptionOriginOnCurve = 512
swComponentRigidSolving = 0
swComponentFlexibleSolving = 1
swComponentFullyResolved = 2
swSetValue_InThisConfiguration = 1
swSetValue_InSpecificConfigurations = 3
swMirrorNameSuffix = 1
swMirrorNameCustom = 2
swFmLocalLPattern = 108
swFmLocalCirPattern = 109
swDragTransformTranslation = 0
swDragModeMinimumMove = 0
SUPPORTED_NAMES = ['app_specific', 'assembly', 'chamfer', 'drawing', 'extrude', 'fillet', 'fillet_variable', 'hole', 'loft', 'pattern_circ', 'pattern_rect', 'revolve', 'sheetmetal', 'shell', 'sketch', 'sweep']
DESIGNS = [{'id': 'P01a', 'scripted': True, 'why_not': '', 'expect': {'volume': 6000, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}]}, {'id': 'P01b', 'scripted': True, 'why_not': '', 'expect': {'volume': 7200, 'bbox': [[-10, -15, 0], [10, 15, 12]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 12, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}]}, {'id': 'P02a', 'scripted': True, 'why_not': '', 'expect': {'volume': 62831.85, 'bbox': [[-30, -30, 0], [30, 30, 40]]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'rect_2pt', 'p1': [20, 0, 0], 'p2': [30, 0, 40]}], 'dims': True, 'kind': 'sketch'}, {'type': 'revolve', 'profile': 'last', 'axis': 'Z', 'angle': 360, 'op': 'new', 'kind': 'revolve'}]}, {'id': 'P02b', 'scripted': True, 'why_not': '', 'expect': {'volume': 47123.89, 'bbox': [[None, None, 0], [None, None, 40]]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'rect_2pt', 'p1': [20, 0, 0], 'p2': [30, 0, 40]}], 'dims': True, 'kind': 'sketch'}, {'type': 'revolve', 'profile': 'last', 'axis': 'Z', 'angle': 270, 'op': 'new', 'kind': 'revolve'}]}, {'id': 'P03a', 'scripted': True, 'why_not': '', 'expect': {'volume': 5803.65, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [0, 0, 10], 'on_face': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 5, 'through_all': True, 'kind': 'hole'}]}, {'id': 'P03b', 'scripted': True, 'why_not': '', 'expect': {'volume': 5671.7, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [0, 0, 10], 'on_face': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}}, 'hole_type': 'counterbore', 'dia': 5, 'through_all': True, 'cb_dia': 9, 'cb_depth': 3, 'kind': 'hole'}]}, {'id': 'P04a', 'scripted': True, 'why_not': '', 'expect': {'volume': 5991.42, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'fillet', 'edges': [{'edge': {'through': [10, 15, 5], 'dir': 'Z'}}], 'r': 2, 'kind': 'fillet'}]}, {'id': 'P04b', 'scripted': True, 'why_not': '', 'expect': {'volume': 5980.69, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'fillet', 'edges': [{'edge': {'through': [10, 15, 5], 'dir': 'Z'}}], 'r': 3, 'kind': 'fillet'}]}, {'id': 'P04c', 'scripted': True, 'why_not': '', 'expect': {'volume': 5982.83, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'fillet', 'edges': [{'edge': {'through': [10, 15, 5], 'dir': 'Z'}}, {'edge': {'through': [-10, 15, 5], 'dir': 'Z'}}], 'r': 2, 'kind': 'fillet'}]}, {'id': 'P04d', 'scripted': True, 'why_not': '', 'expect': {'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'fillet_variable', 'edge': {'edge': {'through': [10, 15, 5], 'dir': 'Z'}}, 'r_start': {'at': [10, 15, 0], 'r': 1}, 'r_end': {'at': [10, 15, 10], 'r': 3}, 'intermediate_points': [], 'transition': 'default', 'kind': 'fillet_variable'}]}, {'id': 'P04e', 'scripted': True, 'why_not': '', 'expect': {'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'fillet_variable', 'edge': {'edge': {'through': [10, 15, 5], 'dir': 'Z'}}, 'r_start': {'at': [10, 15, 0], 'r': 3}, 'r_end': {'at': [10, 15, 10], 'r': 1}, 'intermediate_points': [], 'transition': 'default', 'kind': 'fillet_variable'}]}, {'id': 'P05a', 'scripted': True, 'why_not': '', 'expect': {'volume': 5990, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'chamfer', 'edge': {'edge': {'through': [0, 15, 10], 'dir': 'X'}}, 'mode': 'distance', 'd1': 1, 'flip': False, 'kind': 'chamfer'}]}, {'id': 'P05b', 'scripted': True, 'why_not': '', 'expect': {'volume': 5977.5, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'chamfer', 'edge': {'edge': {'through': [0, 15, 10], 'dir': 'X'}}, 'mode': 'distance', 'd1': 1.5, 'flip': False, 'kind': 'chamfer'}]}, {'id': 'P05c', 'scripted': True, 'why_not': '', 'expect': {'volume': 5980, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'chamfer', 'edge': {'edge': {'through': [0, 15, 10], 'dir': 'X'}}, 'mode': 'two_distances', 'd1': 1, 'flip': False, 'd2': 2, 'kind': 'chamfer'}]}, {'id': 'P05d', 'scripted': True, 'why_not': '', 'expect': {'volume': 5980, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'chamfer', 'edge': {'edge': {'through': [0, 15, 10], 'dir': 'X'}}, 'mode': 'two_distances', 'd1': 2, 'flip': False, 'd2': 1, 'kind': 'chamfer'}]}, {'id': 'P05e', 'scripted': True, 'why_not': '', 'expect': {'volume': 5976.91, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'chamfer', 'edge': {'edge': {'through': [0, 15, 10], 'dir': 'X'}}, 'mode': 'distance_angle', 'd1': 2, 'flip': False, 'angle': 30, 'ref_face': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}}, 'kind': 'chamfer'}]}, {'id': 'P05f', 'scripted': True, 'why_not': '', 'expect': {'volume': 5976.91, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'chamfer', 'edge': {'edge': {'through': [0, 15, 10], 'dir': 'X'}}, 'mode': 'distance_angle', 'd1': 2, 'flip': True, 'angle': 30, 'ref_face': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}}, 'kind': 'chamfer'}]}, {'id': 'P06a', 'scripted': True, 'why_not': '', 'expect': {'volume': 2098.5, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'shell', 'remove_faces': [{'face': {'contains': [0, 0, 10], 'normal': '+Z'}}], 'thickness': 1.5, 'direction': 'inside', 'kind': 'shell'}]}, {'id': 'P06b', 'scripted': True, 'why_not': '', 'expect': {'volume': 2672, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'shell', 'remove_faces': [{'face': {'contains': [0, 0, 10], 'normal': '+Z'}}], 'thickness': 2, 'direction': 'inside', 'kind': 'shell'}]}, {'id': 'P07a', 'scripted': True, 'why_not': '', 'expect': {'volume': 11623.01, 'bbox': [[0, 0, 0], [60, 40, 5]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [60, 40, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 5, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [5, 5, 5], 'on_face': {'face': {'contains': [5, 5, 5], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 4, 'through_all': True, 'name': 'hole', 'kind': 'hole'}, {'type': 'pattern_rect', 'feature': 'hole', 'dir1': {'axis': 'X', 'count': 3, 'spacing': 10}, 'dir2': {'axis': 'Y', 'count': 2, 'spacing': 10}, 'kind': 'pattern_rect'}]}, {'id': 'P07b', 'scripted': True, 'why_not': '', 'expect': {'volume': 11497.35, 'bbox': [[0, 0, 0], [60, 40, 5]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [60, 40, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 5, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [5, 5, 5], 'on_face': {'face': {'contains': [5, 5, 5], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 4, 'through_all': True, 'name': 'hole', 'kind': 'hole'}, {'type': 'pattern_rect', 'feature': 'hole', 'dir1': {'axis': 'X', 'count': 4, 'spacing': 10}, 'dir2': {'axis': 'Y', 'count': 2, 'spacing': 10}, 'kind': 'pattern_rect'}]}, {'id': 'P08a', 'scripted': True, 'why_not': '', 'expect': {'volume': 13288.94, 'bbox': [[-30, -30, 0], [30, 30, 5]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 5, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [20, 0, 5], 'on_face': {'face': {'contains': [20, 0, 5], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 6, 'through_all': True, 'name': 'hole', 'kind': 'hole'}, {'type': 'pattern_circ', 'feature': 'hole', 'axis': 'Z', 'count': 6, 'angle': 360, 'kind': 'pattern_circ'}]}, {'id': 'P08b', 'scripted': True, 'why_not': '', 'expect': {'volume': 13006.19, 'bbox': [[-30, -30, 0], [30, 30, 5]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 5, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [20, 0, 5], 'on_face': {'face': {'contains': [20, 0, 5], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 6, 'through_all': True, 'name': 'hole', 'kind': 'hole'}, {'type': 'pattern_circ', 'feature': 'hole', 'axis': 'Z', 'count': 8, 'angle': 360, 'kind': 'pattern_circ'}]}, {'id': 'P09a', 'scripted': True, 'why_not': '', 'expect': {'volume': 6250, 'bbox': [[-10, -20, 0], [10, 20, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 15, 5], 'w': 5, 'h': 5}], 'dims': True, 'name': 'boss_profile', 'on_face': {'face': {'contains': [0, 15, 5], 'normal': '+Y'}}, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 5, 'direction': '+', 'op': 'join', 'extent': 'distance', 'axis': 'Y', 'name': 'boss', 'kind': 'extrude'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'mirror', 'params': {'features': ['boss'], 'plane': 'XZ'}, 'kind': 'app_specific'}]}, {'id': 'P09b', 'scripted': True, 'why_not': '', 'expect': {'volume': 6300, 'bbox': [[-10, -20, 0], [10, 20, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 15, 5], 'w': 6, 'h': 5}], 'dims': True, 'name': 'boss_profile', 'on_face': {'face': {'contains': [0, 15, 5], 'normal': '+Y'}}, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 5, 'direction': '+', 'op': 'join', 'extent': 'distance', 'axis': 'Y', 'name': 'boss', 'kind': 'extrude'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'mirror', 'params': {'features': ['boss'], 'plane': 'XZ'}, 'kind': 'app_specific'}]}, {'id': 'P10a', 'scripted': True, 'why_not': '', 'expect': {'volume': 825.71}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'line', 'a': [0, 0, 0], 'b': [30, 0, 0]}, {'type': 'arc', 'a': [30, 0, 0], 'b': [40, 10, 0], 'c': [30, 10, 0], 'r': 10}, {'type': 'line', 'a': [40, 10, 0], 'b': [40, 30, 0]}], 'dims': True, 'name': 'path', 'kind': 'sketch'}, {'type': 'sketch', 'plane': {'normal': 'X', 'origin': [0, 0, 0]}, 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 2}], 'dims': True, 'name': 'profile', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'path', 'kind': 'sweep'}]}, {'id': 'P10b', 'scripted': True, 'why_not': '', 'expect': {'volume': 1290.17}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'line', 'a': [0, 0, 0], 'b': [30, 0, 0]}, {'type': 'arc', 'a': [30, 0, 0], 'b': [40, 10, 0], 'c': [30, 10, 0], 'r': 10}, {'type': 'line', 'a': [40, 10, 0], 'b': [40, 30, 0]}], 'dims': True, 'name': 'path', 'kind': 'sketch'}, {'type': 'sketch', 'plane': {'normal': 'X', 'origin': [0, 0, 0]}, 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 2.5}], 'dims': True, 'name': 'profile', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'path', 'kind': 'sweep'}]}, {'id': 'P11a', 'scripted': True, 'why_not': '', 'expect': {'bbox': [[-10, -10, 0], [10, 10, 30]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 20}], 'dims': True, 'name': 'bottom', 'kind': 'sketch'}, {'type': 'sketch', 'plane': {'base': 'XY', 'offset': 30}, 'entities': [{'type': 'circle', 'c': [0, 0, 30], 'r': 5}], 'dims': True, 'name': 'top', 'kind': 'sketch'}, {'type': 'loft', 'profiles': ['bottom', 'top'], 'kind': 'loft'}]}, {'id': 'P11b', 'scripted': True, 'why_not': '', 'expect': {'bbox': [[-10, -10, 0], [10, 10, 40]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 20}], 'dims': True, 'name': 'bottom', 'kind': 'sketch'}, {'type': 'sketch', 'plane': {'base': 'XY', 'offset': 40}, 'entities': [{'type': 'circle', 'c': [0, 0, 40], 'r': 5}], 'dims': True, 'name': 'top', 'kind': 'sketch'}, {'type': 'loft', 'profiles': ['bottom', 'top'], 'kind': 'loft'}]}, {'id': 'P12a', 'scripted': True, 'why_not': '', 'expect': {'volume': 6000, 'size': [20, 30, 10]}, 'ops': [{'type': 'app_specific', 'app': 'solidworks', 'op': 'parameter', 'params': {'name': 'plate_w', 'value': 20, 'units': 'mm'}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'width_expression': 'plate_w', 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'distance_expression': 'plate_w/2', 'kind': 'extrude'}]}, {'id': 'P12b', 'scripted': True, 'why_not': '', 'expect': {'volume': 9375, 'size': [25, 30, 12.5]}, 'ops': [{'type': 'app_specific', 'app': 'solidworks', 'op': 'parameter', 'params': {'name': 'plate_w', 'value': 25, 'units': 'mm'}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 25, 'h': 30}], 'dims': True, 'width_expression': 'plate_w', 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 12.5, 'direction': '+', 'op': 'new', 'extent': 'distance', 'distance_expression': 'plate_w/2', 'kind': 'extrude'}]}, {'id': 'P13a', 'scripted': True, 'why_not': '', 'expect': {'volume': 392.7, 'bbox': [[-5, -5, 15], [5, 5, 20]]}, 'ops': [{'type': 'sketch', 'plane': {'base': 'XY', 'offset': 15}, 'entities': [{'type': 'circle', 'c': [0, 0, 15], 'r': 5}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 5, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}]}, {'id': 'P13b', 'scripted': True, 'why_not': '', 'expect': {'volume': 392.7, 'bbox': [[-5, -5, 20], [5, 5, 25]]}, 'ops': [{'type': 'sketch', 'plane': {'base': 'XY', 'offset': 20}, 'entities': [{'type': 'circle', 'c': [0, 0, 20], 'r': 5}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 5, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}]}, {'id': 'P14a', 'scripted': True, 'why_not': '', 'expect': {'volume': 299.43}, 'ops': [{'type': 'app_specific', 'app': 'solidworks', 'op': 'sketch3d', 'params': {'name': 'path', 'entities': [{'type': 'line', 'a': [0, 0, 0], 'b': [20, 0, 0]}, {'type': 'line', 'a': [20, 0, 0], 'b': [20, 20, 10]}], 'dims': True}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': {'normal': 'X', 'origin': [0, 0, 0]}, 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 1.5}], 'dims': True, 'name': 'profile', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'path', 'kind': 'sweep'}]}, {'id': 'P14b', 'scripted': True, 'why_not': '', 'expect': {'volume': 318.09}, 'ops': [{'type': 'app_specific', 'app': 'solidworks', 'op': 'sketch3d', 'params': {'name': 'path', 'entities': [{'type': 'line', 'a': [0, 0, 0], 'b': [20, 0, 0]}, {'type': 'line', 'a': [20, 0, 0], 'b': [20, 20, 15]}], 'dims': True}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': {'normal': 'X', 'origin': [0, 0, 0]}, 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 1.5}], 'dims': True, 'name': 'profile', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'path', 'kind': 'sweep'}]}, {'id': 'P15a', 'scripted': True, 'why_not': '', 'expect': {'volume': 6000, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'appearance', 'params': {'target': 'part', 'color': 'red'}, 'kind': 'app_specific'}]}, {'id': 'P15b', 'scripted': True, 'why_not': '', 'expect': {'volume': 6000, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'appearance', 'params': {'target': 'part', 'color': 'red'}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'appearance', 'params': {'target': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}}, 'color': 'blue'}, 'kind': 'app_specific'}]}, {'id': 'P16a', 'scripted': True, 'why_not': '', 'expect': {'volume': 392.7, 'size': [5, 5, 20]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 2.5}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 20, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}]}, {'id': 'S01a', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 12000, 'bbox': [[0, 0, 0], [100, 60, 2]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}]}, {'id': 'S01b', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2.5, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 15000, 'bbox': [[0, 0, 0], [100, 60, 2.5]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2.5, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}]}, {'id': 'S02a', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 15428.32, 'bbox': [[0, 0, 0], [100, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default'}, 'kind': 'sheetmetal'}]}, {'id': 'S02b', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 16428.32, 'bbox': [[0, 0, 0], [100, None, 25]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 25, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default'}, 'kind': 'sheetmetal'}]}, {'id': 'S02c', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 60, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default'}, 'kind': 'sheetmetal'}]}, {'id': 'S02d', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'alternative_default_record_option', 'bend_position': 'default'}, 'kind': 'sheetmetal'}]}, {'id': 'S02e', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'alternative_default_record_option'}, 'kind': 'sheetmetal'}]}, {'id': 'S02f', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'bbox': [[0, 0, 0], [100, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'width_type': 'width', 'offset': 20, 'width': 50, 'from_corner': [0, 60, 2]}, 'kind': 'sheetmetal'}]}, {'id': 'S02g', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'bbox': [[0, 0, 0], [100, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'width_type': 'offset', 'offset1': 10, 'offset2': 30}, 'kind': 'sheetmetal'}]}, {'id': 'S02h', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 15428.32, 'bbox': [[0, 0, 0], [100, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_relief_depth': 1}, 'kind': 'sheetmetal'}]}, {'id': 'S02i', 'scripted': False, 'why_not': 'skipped in SolidWorks, no file needed (its Edge Flange has no Bend Transition; Tangent To Bend is a flange position, S02e): sheetmetal flange bend transition: IEdgeFlangeFeatureData has no bend-transition member (read from the interop: 26 members in sldworks 25.5.0 / SolidWorks 2017, 30 in 32.1.0 / 2024; the four added in 2024 are AngleReference, LockAngle, PerpendicularToFace and NormalToFlangePlane, and none is a bend transition; the others cover relief type, ratio, width and depth only); not mapped', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_transition': 'arc_unless_default_then_straight_line'}, 'kind': 'sheetmetal'}]}, {'id': 'S02j', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 2, 'k_factor': 0.3}, 'volume': 15342.48, 'bbox': [[0, 0, 0], [100, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_radius': 2, 'k_factor': 0.3}, 'kind': 'sheetmetal'}]}, {'id': 'S03a', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'bbox': [[0, 0, 0], [None, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}, {'edge': {'through': [100, 30, 2], 'dir': 'Y'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_radius': 1, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5}, 'kind': 'sheetmetal'}]}, {'id': 'S03b', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'bbox': [[0, 0, 0], [None, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}, {'edge': {'through': [100, 30, 2], 'dir': 'Y'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_radius': 1, 'corner_relief': 'square', 'corner_relief_size': 4, 'corner_gap': 0.5}, 'kind': 'sheetmetal'}]}, {'id': 'S03c', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'bbox': [[0, 0, 0], [None, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}, {'edge': {'through': [100, 30, 2], 'dir': 'Y'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_radius': 1, 'corner_relief': 'tear', 'corner_relief_size': 4, 'corner_gap': 0.5}, 'kind': 'sheetmetal'}]}, {'id': 'S03d', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'bbox': [[0, 0, 0], [None, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}, {'edge': {'through': [100, 30, 2], 'dir': 'Y'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_radius': 1, 'corner_relief': 'round', 'corner_relief_size': 5, 'corner_gap': 0.5}, 'kind': 'sheetmetal'}]}, {'id': 'S03e', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'bbox': [[0, 0, 0], [None, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}, {'edge': {'through': [100, 30, 2], 'dir': 'Y'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_radius': 1, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.8}, 'kind': 'sheetmetal'}]}, {'id': 'S03f', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'bbox': [[0, 0, 0], [None, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}, {'edge': {'through': [100, 30, 2], 'dir': 'Y'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_radius': 1, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'round', 'bend_relief_width': 'default'}, 'kind': 'sheetmetal'}]}, {'id': 'S04a', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 16970.8}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'hem', 'app': {'edge': {'edge': {'through': [50, 60, 22], 'dir': 'X'}, 'feature': 'flange_free_edge'}, 'hem_type': 'single', 'direction': '-Y', 'gap': 1, 'length': 8}, 'kind': 'sheetmetal'}]}, {'id': 'S04b', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 17027.88}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'hem', 'app': {'edge': {'edge': {'through': [50, 60, 22], 'dir': 'X'}, 'feature': 'flange_free_edge'}, 'hem_type': 'single', 'direction': '-Y', 'gap': 1.5, 'length': 8}, 'kind': 'sheetmetal'}]}, {'id': 'S04c', 'scripted': False, 'why_not': 'skipped in SolidWorks, no file needed (booklet 1.64: SolidWorks has no Double hem type)', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'hem', 'app': {'edge': {'edge': {'through': [50, 60, 22], 'dir': 'X'}, 'feature': 'flange_free_edge'}, 'hem_type': 'double', 'direction': '-Y', 'gap': 'default', 'length': 'default'}, 'kind': 'sheetmetal'}]}, {'id': 'S04d', 'scripted': False, 'why_not': 'sheetmetal hem teardrop: CreateDefinition has no hem to create (swFeatureNameID_e has no hem member: its values end at swFmCrossBreak = 86 in swconst 25.5.0 / SolidWorks 2017 and swFmMateController = 127 in 32.1.0 / 2024; swFmBaseFlange = 34 and swFmEdgeFlange = 37 are there, none is a hem), so there is no way to get the PropertyManager defaults the recipe leaves "as they come". IHemFeatureData exists in both but only as the data of a hem that is already built (IFeature.GetDefinition). The one creation call, InsertSheetMetalHem2, needs explicit length, gap, angle and radius; not guessed', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'hem', 'app': {'edge': {'edge': {'through': [50, 60, 22], 'dir': 'X'}, 'feature': 'flange_free_edge'}, 'hem_type': 'teardrop', 'direction': '-Y', 'gap': 'default', 'length': 'default'}, 'kind': 'sheetmetal'}]}, {'id': 'S04e', 'scripted': False, 'why_not': 'sheetmetal hem rolled: CreateDefinition has no hem to create (swFeatureNameID_e has no hem member: its values end at swFmCrossBreak = 86 in swconst 25.5.0 / SolidWorks 2017 and swFmMateController = 127 in 32.1.0 / 2024; swFmBaseFlange = 34 and swFmEdgeFlange = 37 are there, none is a hem), so there is no way to get the PropertyManager defaults the recipe leaves "as they come". IHemFeatureData exists in both but only as the data of a hem that is already built (IFeature.GetDefinition). The one creation call, InsertSheetMetalHem2, needs explicit length, gap, angle and radius; not guessed', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'hem', 'app': {'edge': {'edge': {'through': [50, 60, 22], 'dir': 'X'}, 'feature': 'flange_free_edge'}, 'hem_type': 'rolled', 'direction': '-Y', 'gap': 'default', 'length': 'default'}, 'kind': 'sheetmetal'}]}, {'id': 'S04f', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 16970.8}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'hem', 'app': {'edge': {'edge': {'through': [50, 60, 22], 'dir': 'X'}, 'feature': 'flange_free_edge'}, 'hem_type': 'single', 'direction': '+Y', 'gap': 1, 'length': 8}, 'kind': 'sheetmetal'}]}, {'id': 'S04g', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'hem', 'app': {'edge': {'edge': {'through': [50, 60, 22], 'dir': 'X'}, 'feature': 'flange_free_edge'}, 'hem_type': 'single', 'direction': '-Y', 'gap': 1, 'length': 12}, 'kind': 'sheetmetal'}]}, {'id': 'S05a', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'bbox': [[0, 0, 0], [None, None, 20]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}, {'edge': {'through': [100, 30, 2], 'dir': 'Y'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_radius': 1, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flat_pattern', 'app': {'save_state': 'folded'}, 'kind': 'sheetmetal'}]}, {'id': 'S06a', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 15428.32}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_relief': 'round', 'bend_relief_width': 3}, 'kind': 'sheetmetal'}]}, {'id': 'S06b', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 15428.32}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_relief': 'straight', 'bend_relief_width': 3}, 'kind': 'sheetmetal'}]}, {'id': 'S06c', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 15428.32}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_relief': 'default', 'bend_relief_width': 3}, 'kind': 'sheetmetal'}]}, {'id': 'S06d', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 15428.32}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'flange', 'app': {'edges': [{'edge': {'through': [50, 60, 2], 'dir': 'X'}}], 'height': 20, 'angle': 90, 'direction': '+Z', 'height_datum': 'default', 'bend_position': 'default', 'bend_relief': 'round', 'bend_relief_width': 'default'}, 'kind': 'sheetmetal'}]}, {'id': 'S07a', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 11996.14, 'bbox': [[0, 0, 0], [100, 60, 2]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'corner_round', 'app': {'corners': [[100, 60, 2]], 'r': 3}, 'kind': 'sheetmetal'}]}, {'id': 'S07b', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 11989.27, 'bbox': [[0, 0, 0], [100, 60, 2]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'corner_round', 'app': {'corners': [[100, 60, 2]], 'r': 5}, 'kind': 'sheetmetal'}]}, {'id': 'S07c', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 11984.55, 'bbox': [[0, 0, 0], [100, 60, 2]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'sheetmetal', 'action': 'corner_round', 'app': {'corners': [[0, 0, 2], [100, 0, 2], [100, 60, 2], [0, 60, 2]], 'r': 3}, 'kind': 'sheetmetal'}]}, {'id': 'S13a', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 11943.45, 'bbox': [[0, 0, 0], [100, 60, 2]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'hole', 'at': [10, 10, 2], 'on_face': {'face': {'contains': [10, 10, 2], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 6, 'through_all': True, 'name': 'hole', 'kind': 'hole'}]}, {'id': 'S13b', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 11830.35, 'bbox': [[0, 0, 0], [100, 60, 2]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'hole', 'at': [10, 10, 2], 'on_face': {'face': {'contains': [10, 10, 2], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 6, 'through_all': True, 'name': 'hole', 'kind': 'hole'}, {'type': 'pattern_rect', 'feature': 'hole', 'dir1': {'axis': 'X', 'count': 3, 'spacing': 15}, 'dir2': {'axis': 'Y', 'count': 1, 'spacing': 15}, 'name': 'pattern', 'kind': 'pattern_rect'}]}, {'id': 'S13c', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 11660.71, 'bbox': [[0, 0, 0], [100, 60, 2]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'hole', 'at': [10, 10, 2], 'on_face': {'face': {'contains': [10, 10, 2], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 6, 'through_all': True, 'name': 'hole', 'kind': 'hole'}, {'type': 'pattern_rect', 'feature': 'hole', 'dir1': {'axis': 'X', 'count': 3, 'spacing': 15}, 'dir2': {'axis': 'Y', 'count': 1, 'spacing': 15}, 'name': 'pattern', 'kind': 'pattern_rect'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'work_plane', 'params': {'plane': 'YZ', 'offset': 50}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'mirror', 'params': {'features': ['hole', 'pattern'], 'plane': {'base': 'YZ', 'offset': 50}}, 'kind': 'app_specific'}]}, {'id': 'S13d', 'scripted': True, 'why_not': '', 'expect': {'solidworks_sheet': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44}, 'volume': 11660.71, 'bbox': [[0, 0, 0], [100, 60, 2]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_2pt', 'p1': [0, 0, 0], 'p2': [100, 60, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'sheetmetal', 'action': 'base_flange', 'app': {'thickness': 2, 'bend_radius': 1, 'k_factor': 0.44, 'corner_relief': 'round', 'corner_relief_size': 4, 'corner_gap': 0.5, 'bend_relief': 'default', 'direction': '+Z', 'profile': 'last'}, 'kind': 'sheetmetal'}, {'type': 'hole', 'at': [10, 10, 2], 'on_face': {'face': {'contains': [10, 10, 2], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 6, 'through_all': True, 'name': 'hole', 'kind': 'hole'}, {'type': 'pattern_rect', 'feature': 'hole', 'dir1': {'axis': 'X', 'count': 3, 'spacing': 15}, 'dir2': {'axis': 'Y', 'count': 1, 'spacing': 15}, 'name': 'pattern', 'kind': 'pattern_rect'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'work_plane', 'params': {'plane': 'YZ', 'offset': 50}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'mirror', 'params': {'features': ['hole', 'pattern'], 'plane': {'base': 'YZ', 'offset': 50}}, 'kind': 'app_specific'}, {'type': 'sheetmetal', 'action': 'flat_pattern', 'app': {'save_state': 'folded'}, 'kind': 'sheetmetal'}]}, {'id': 'A01a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}]}, {'id': 'A01b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'component': 'block', 'grounded': False, 'kind': 'assembly'}]}, {'id': 'A01c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'component': 'ring', 'grounded': True, 'kind': 'assembly'}]}, {'id': 'A01d', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'component': 'ring', 'visible': False, 'kind': 'assembly'}]}, {'id': 'A01e', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'component': 'ring', 'suppressed': True, 'kind': 'assembly'}]}, {'id': 'A02a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'mate', 'a': {'face': {'contains': [25, 0, 0], 'normal': '-Z'}, 'component': 'ring'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'offset': 0}, 'kind': 'assembly'}]}, {'id': 'A02b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'mate', 'a': {'face': {'contains': [25, 0, 0], 'normal': '-Z'}, 'component': 'ring'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'offset': 5}, 'kind': 'assembly'}]}, {'id': 'A03a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'flush', 'a': {'face': {'contains': [25, 0, 0], 'normal': '-Z'}, 'component': 'ring'}, 'b': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block'}, 'offset': 0}, 'kind': 'assembly'}]}, {'id': 'A03b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'flush', 'a': {'face': {'contains': [25, 0, 0], 'normal': '-Z'}, 'component': 'ring'}, 'b': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block'}, 'offset': 5}, 'kind': 'assembly'}]}, {'id': 'A04a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'angle', 'a': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'b': {'face': {'contains': [25, 0, 40], 'normal': '+Z'}, 'component': 'ring'}, 'angle': 30}, 'kind': 'assembly'}]}, {'id': 'A04b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'angle', 'a': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'b': {'face': {'contains': [25, 0, 40], 'normal': '+Z'}, 'component': 'ring'}, 'angle': 45}, 'kind': 'assembly'}]}, {'id': 'A05a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P03a', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'at': 'default'}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'insert', 'a': {'edge': {'through': [2.5, 0, 0], 'tangent': [0, 1, 0]}, 'component': 'P16a'}, 'b': {'edge': {'through': [2.5, 0, 10], 'tangent': [0, 1, 0]}, 'component': 'P03a'}, 'offset': 0}, 'kind': 'assembly'}]}, {'id': 'A05b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P03a', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'at': 'default'}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'insert', 'a': {'edge': {'through': [2.5, 0, 0], 'tangent': [0, 1, 0]}, 'component': 'P16a'}, 'b': {'edge': {'through': [2.5, 0, 10], 'tangent': [0, 1, 0]}, 'component': 'P03a'}, 'offset': 2}, 'kind': 'assembly'}]}, {'id': 'A06a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'at': 'default'}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'tangent', 'a': {'face': {'contains': [2.5, 0, 10], 'normal': '+X'}, 'component': 'P16a'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'P01a'}, 'solution': 'outside'}, 'kind': 'assembly'}]}, {'id': 'A06b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'at': 'default'}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'tangent', 'a': {'face': {'contains': [2.5, 0, 10], 'normal': '+X'}, 'component': 'P16a'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'P01a'}, 'solution': 'inside'}, 'kind': 'assembly'}]}, {'id': 'A07a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'pattern': {'component': 'ring', 'dir1': {'axis': 'X', 'count': 3, 'spacing': 70}, 'dir2': {'axis': 'Y', 'count': 1, 'spacing': 70}}, 'kind': 'assembly'}]}, {'id': 'A07b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'assembly', 'pattern': {'component': 'ring', 'dir1': {'axis': 'X', 'count': 4, 'spacing': 70}, 'dir2': {'axis': 'Y', 'count': 1, 'spacing': 70}}, 'kind': 'assembly'}]}, {'id': 'A08a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'configuration', 'params': {'name': 'second', 'suppress': ['ring'], 'active': 'master'}, 'kind': 'app_specific'}]}, {'id': 'A08b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'configuration', 'params': {'name': 'second', 'suppress': ['ring'], 'active': 'second'}, 'kind': 'app_specific'}]}, {'id': 'A09a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'display_state', 'params': {'name': 'View1', 'hide': ['ring'], 'active': 'Default'}, 'kind': 'app_specific'}]}, {'id': 'A09b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'display_state', 'params': {'name': 'View1', 'hide': ['ring'], 'active': 'View1'}, 'kind': 'app_specific'}]}, {'id': 'A10a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'appearance', 'params': {'target': {'component': 'block'}, 'color': 'blue'}, 'kind': 'app_specific'}]}, {'id': 'A10b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'at': [0, 0, 0], 'grounded': True, 'name': 'block'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'at': 'off_to_side_default', 'grounded': False, 'name': 'ring'}, 'kind': 'assembly'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'appearance', 'params': {'target': {'component': 'block'}, 'color': 'green'}, 'kind': 'app_specific'}]}, {'id': 'A11a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [40, 0, 0], 'grounded': False, 'turn': [{'axis': 'Z', 'deg': 90}]}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [40.0, 0.0, 0.0], 'R': [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A11b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [40, 0, 20], 'grounded': False, 'turn': [{'axis': 'X', 'deg': 180}]}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [40.0, 0.0, 20.0], 'R': [[1.0, 0.0, 0.0], [0.0, -1.0, 0.0], [0.0, 0.0, -1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A11c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [40, 0, 0], 'grounded': False, 'turn': [{'axis': 'Y', 'deg': 90}]}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [40.0, 0.0, 0.0], 'R': [[0.0, 0.0, 1.0], [0.0, 1.0, 0.0], [-1.0, 0.0, 0.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A12a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A12-sub', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': True}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A12-sub', 'name': 'sub', 'at': [60, 0, 0], 'grounded': False}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'ring', 'part': 'P02a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'sub/block', 'part': 'P01a', 't': [60.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'sub/pin', 'part': 'P16a', 't': [60.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A12b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A12-sub', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': True}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A12-sub', 'name': 'sub', 'at': [60, 0, 0], 'grounded': True}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'ring', 'part': 'P02a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'sub/block', 'part': 'P01a', 't': [60.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'sub/pin', 'part': 'P16a', 't': [60.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A12c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A12-sub', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': True}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A12-sub', 'name': 'sub', 'at': [60, 0, 0], 'grounded': False, 'turn': [{'axis': 'Z', 'deg': 90}]}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'ring', 'part': 'P02a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'sub/block', 'part': 'P01a', 't': [60.0, 0.0, 0.0], 'R': [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'sub/pin', 'part': 'P16a', 't': [60.0, 0.0, 10.0], 'R': [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A13a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A13-pair', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': True}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'subassembly': {'file': 'A13-mid', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A13-pair', 'name': 'pair', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A13-mid', 'name': 'mid', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'mid/ring', 'part': 'P02a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'mid/pair/block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'mid/pair/pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A13b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A13-pair', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': True}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'subassembly': {'file': 'A13-mid', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A13-pair', 'name': 'pair', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A13-mid', 'name': 'mid', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A13-mid', 'name': 'mid2', 'at': [80, 0, 0], 'grounded': False, 'turn': [{'axis': 'Z', 'deg': 90}]}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'mid/ring', 'part': 'P02a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'mid/pair/block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'mid/pair/pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'mid2/ring', 'part': 'P02a', 't': [80.0, 0.0, 0.0], 'R': [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}, {'path': 'mid2/pair/block', 'part': 'P01a', 't': [80.0, 0.0, 0.0], 'R': [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'mid2/pair/pin', 'part': 'P16a', 't': [80.0, 0.0, 10.0], 'R': [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A14a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block2'}, 'b': {'face': {'contains': [0.0, 0.0, 10.0], 'normal': '+Z'}, 'component': 'block'}, 'moving': 'block2', 'joint': 'rigid', 'align': 'anti', 'name': 'block2-rigid-1'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block'}, 'b': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'rigid', 'align': 'aligned', 'name': 'block2-rigid-2'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block'}, 'b': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'rigid', 'align': 'aligned', 'name': 'block2-rigid-3'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A14b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [5, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block2'}, 'b': {'face': {'contains': [0.0, 0.0, 10.0], 'normal': '+Z'}, 'component': 'block'}, 'moving': 'block2', 'joint': 'rigid', 'align': 'anti', 'name': 'block2-rigid-1'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block'}, 'b': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'rigid', 'value': 5, 'align': 'aligned', 'name': 'block2-rigid-2'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block'}, 'b': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'rigid', 'align': 'aligned', 'name': 'block2-rigid-3'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [5.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A14c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [0, 0, 10], 'grounded': False, 'turn': [{'axis': 'Z', 'deg': 180}]}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block2'}, 'b': {'face': {'contains': [0.0, 0.0, 10.0], 'normal': '+Z'}, 'component': 'block'}, 'moving': 'block2', 'joint': 'rigid', 'align': 'anti', 'name': 'block2-rigid-1'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block'}, 'b': {'face': {'contains': [-10.0, 0.0, 5.0], 'normal': '-X'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'rigid', 'align': 'aligned', 'name': 'block2-rigid-2'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block'}, 'b': {'face': {'contains': [0.0, -15.0, 5.0], 'normal': '-Y'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'rigid', 'align': 'aligned', 'name': 'block2-rigid-3'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [0.0, 0.0, 10.0], 'R': [[-1.0, 0.0, 0.0], [0.0, -1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A15a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': False}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'origin': True, 'component': 'block'}, 'b': {'origin': True, 'component': 'ring'}, 'moving': 'block', 'joint': 'revolute', 'align': 'closest', 'name': 'block-revolute-1'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block'}, 'b': {'face': {'contains': [25, 0, 0], 'normal': '-Z'}, 'component': 'ring'}, 'moving': 'block', 'joint': 'revolute', 'align': 'aligned', 'name': 'block-revolute-2'}}, {'kind': 'assembly', 'constraint': {'type': 'limit_angle', 'a': {'plane': 'Right', 'component': 'block'}, 'b': {'plane': 'Right', 'component': 'ring'}, 'moving': 'block', 'joint': 'revolute', 'value': 0, 'min': -45, 'max': 90, 'name': 'block-revolute-3'}}], 'placements': {'instances': [{'path': 'ring', 'part': 'P02a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A15b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': False, 'turn': [{'axis': 'Z', 'deg': 30}]}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'origin': True, 'component': 'block'}, 'b': {'origin': True, 'component': 'ring'}, 'moving': 'block', 'joint': 'revolute', 'align': 'closest', 'name': 'block-revolute-1'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block'}, 'b': {'face': {'contains': [25, 0, 0], 'normal': '-Z'}, 'component': 'ring'}, 'moving': 'block', 'joint': 'revolute', 'align': 'aligned', 'name': 'block-revolute-2'}}, {'kind': 'assembly', 'constraint': {'type': 'limit_angle', 'a': {'plane': 'Right', 'component': 'block'}, 'b': {'plane': 'Right', 'component': 'ring'}, 'moving': 'block', 'joint': 'revolute', 'value': 30, 'min': -45, 'max': 90, 'name': 'block-revolute-3'}}], 'placements': {'instances': [{'path': 'ring', 'part': 'P02a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[0.866025, -0.5, 0.0], [0.5, 0.866025, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A15c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': False, 'turn': [{'axis': 'Z', 'deg': 90}]}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'origin': True, 'component': 'block'}, 'b': {'origin': True, 'component': 'ring'}, 'moving': 'block', 'joint': 'revolute', 'align': 'closest', 'name': 'block-revolute-1'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block'}, 'b': {'face': {'contains': [25, 0, 0], 'normal': '-Z'}, 'component': 'ring'}, 'moving': 'block', 'joint': 'revolute', 'align': 'aligned', 'name': 'block-revolute-2'}}, {'kind': 'assembly', 'constraint': {'type': 'limit_angle', 'a': {'plane': 'Right', 'component': 'block'}, 'b': {'plane': 'Right', 'component': 'ring'}, 'moving': 'block', 'joint': 'revolute', 'value': 90, 'min': 0, 'max': 180, 'name': 'block-revolute-3'}}], 'placements': {'instances': [{'path': 'ring', 'part': 'P02a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A16a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block2'}, 'b': {'face': {'contains': [0.0, 0.0, 10.0], 'normal': '+Z'}, 'component': 'block'}, 'moving': 'block2', 'joint': 'slider', 'align': 'anti', 'name': 'block2-slider-1'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block'}, 'b': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'slider', 'align': 'aligned', 'name': 'block2-slider-2'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block'}, 'b': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'slider', 'value': 0, 'min': -20, 'max': 20, 'align': 'aligned', 'name': 'block2-slider-3'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A16b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [20, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block2'}, 'b': {'face': {'contains': [0.0, 0.0, 10.0], 'normal': '+Z'}, 'component': 'block'}, 'moving': 'block2', 'joint': 'slider', 'align': 'anti', 'name': 'block2-slider-1'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block'}, 'b': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'slider', 'align': 'aligned', 'name': 'block2-slider-2'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block'}, 'b': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'slider', 'value': 20, 'min': -20, 'max': 20, 'align': 'aligned', 'name': 'block2-slider-3'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [20.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A16c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [40, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block2'}, 'b': {'face': {'contains': [0.0, 0.0, 10.0], 'normal': '+Z'}, 'component': 'block'}, 'moving': 'block2', 'joint': 'slider', 'align': 'anti', 'name': 'block2-slider-1'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block'}, 'b': {'face': {'contains': [0.0, 15.0, 5.0], 'normal': '+Y'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'slider', 'align': 'aligned', 'name': 'block2-slider-2'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block'}, 'b': {'face': {'contains': [10.0, 0.0, 5.0], 'normal': '+X'}, 'component': 'block2'}, 'moving': 'block2', 'joint': 'slider', 'value': 40, 'min': 0, 'max': 40, 'align': 'aligned', 'name': 'block2-slider-3'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [40.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A17a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': False}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'origin': True, 'component': 'block'}, 'b': {'plane': 'Right', 'component': 'ring'}, 'moving': 'block', 'joint': 'cylindrical', 'align': 'closest', 'name': 'block-cylindrical-1'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'origin': True, 'component': 'block'}, 'b': {'plane': 'Top', 'component': 'ring'}, 'moving': 'block', 'joint': 'cylindrical', 'align': 'closest', 'name': 'block-cylindrical-2'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block'}, 'b': {'face': {'contains': [25, 0, 0], 'normal': '-Z'}, 'component': 'ring'}, 'moving': 'block', 'joint': 'cylindrical', 'value': 0, 'min': 0, 'max': 40, 'align': 'aligned', 'name': 'block-cylindrical-3'}}], 'placements': {'instances': [{'path': 'ring', 'part': 'P02a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A17b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 35], 'grounded': False, 'turn': [{'axis': 'Z', 'deg': 45}]}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'origin': True, 'component': 'block'}, 'b': {'plane': 'Right', 'component': 'ring'}, 'moving': 'block', 'joint': 'cylindrical', 'align': 'closest', 'name': 'block-cylindrical-1'}}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'origin': True, 'component': 'block'}, 'b': {'plane': 'Top', 'component': 'ring'}, 'moving': 'block', 'joint': 'cylindrical', 'align': 'closest', 'name': 'block-cylindrical-2'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block'}, 'b': {'face': {'contains': [25, 0, 0], 'normal': '-Z'}, 'component': 'ring'}, 'moving': 'block', 'joint': 'cylindrical', 'value': 35, 'min': 0, 'max': 40, 'align': 'aligned', 'name': 'block-cylindrical-3'}}], 'placements': {'instances': [{'path': 'ring', 'part': 'P02a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 35.0], 'R': [[0.707107, -0.707107, 0.0], [0.707107, 0.707107, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A18a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block2'}, 'b': {'face': {'contains': [0.0, 0.0, 10.0], 'normal': '+Z'}, 'component': 'block'}, 'moving': 'block2', 'joint': 'planar', 'align': 'anti', 'name': 'block2-planar-1'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'plane': 'Right', 'component': 'block'}, 'b': {'origin': True, 'component': 'block2'}, 'moving': 'block2', 'joint': 'planar', 'value': 0, 'min': -20, 'max': 20, 'align': 'closest', 'name': 'block2-planar-2'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'plane': 'Top', 'component': 'block'}, 'b': {'origin': True, 'component': 'block2'}, 'moving': 'block2', 'joint': 'planar', 'value': 0, 'min': -20, 'max': 20, 'align': 'closest', 'name': 'block2-planar-3'}}, {'kind': 'assembly', 'constraint': {'type': 'limit_angle', 'a': {'plane': 'Right', 'component': 'block2'}, 'b': {'plane': 'Right', 'component': 'block'}, 'moving': 'block2', 'joint': 'planar', 'value': 0, 'min': -90, 'max': 90, 'name': 'block2-planar-4'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A18b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [15, 5, 10], 'grounded': False, 'turn': [{'axis': 'Z', 'deg': 30}]}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block2'}, 'b': {'face': {'contains': [0.0, 0.0, 10.0], 'normal': '+Z'}, 'component': 'block'}, 'moving': 'block2', 'joint': 'planar', 'align': 'anti', 'name': 'block2-planar-1'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'plane': 'Right', 'component': 'block'}, 'b': {'origin': True, 'component': 'block2'}, 'moving': 'block2', 'joint': 'planar', 'value': 15, 'min': -20, 'max': 20, 'align': 'closest', 'name': 'block2-planar-2'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'plane': 'Top', 'component': 'block'}, 'b': {'origin': True, 'component': 'block2'}, 'moving': 'block2', 'joint': 'planar', 'value': 5, 'min': -20, 'max': 20, 'align': 'closest', 'name': 'block2-planar-3'}}, {'kind': 'assembly', 'constraint': {'type': 'limit_angle', 'a': {'plane': 'Right', 'component': 'block2'}, 'b': {'plane': 'Right', 'component': 'block'}, 'moving': 'block2', 'joint': 'planar', 'value': 30, 'min': -90, 'max': 90, 'name': 'block2-planar-4'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [15.0, 5.0, 10.0], 'R': [[0.866025, -0.5, 0.0], [0.5, 0.866025, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A18c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block2', 'at': [20, -20, 10], 'grounded': False, 'turn': [{'axis': 'Z', 'deg': 90}]}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'block2'}, 'b': {'face': {'contains': [0.0, 0.0, 10.0], 'normal': '+Z'}, 'component': 'block'}, 'moving': 'block2', 'joint': 'planar', 'align': 'anti', 'name': 'block2-planar-1'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'plane': 'Right', 'component': 'block'}, 'b': {'origin': True, 'component': 'block2'}, 'moving': 'block2', 'joint': 'planar', 'value': 20, 'min': -20, 'max': 20, 'align': 'closest', 'name': 'block2-planar-2'}}, {'kind': 'assembly', 'constraint': {'type': 'distance', 'a': {'plane': 'Top', 'component': 'block'}, 'b': {'origin': True, 'component': 'block2'}, 'moving': 'block2', 'joint': 'planar', 'value': -20, 'min': -20, 'max': 20, 'align': 'closest', 'name': 'block2-planar-3'}}, {'kind': 'assembly', 'constraint': {'type': 'limit_angle', 'a': {'plane': 'Right', 'component': 'block2'}, 'b': {'plane': 'Right', 'component': 'block'}, 'moving': 'block2', 'joint': 'planar', 'value': 90, 'min': -90, 'max': 90, 'name': 'block2-planar-4'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'block2', 'part': 'P01a', 't': [20.0, -20.0, 10.0], 'R': [[0.0, -1.0, 0.0], [1.0, 0.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': True, 'score_t': True}}, {'id': 'A19a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, -10], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 0], 'grounded': False}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'origin': True, 'component': 'pin'}, 'b': {'origin': True}, 'moving': 'pin', 'joint': 'ball', 'align': 'closest', 'name': 'pin-ball-1'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, -10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pin', 'part': 'P16a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A19b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, -10], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 0], 'grounded': False, 'turn': [{'axis': 'X', 'deg': 30}]}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'origin': True, 'component': 'pin'}, 'b': {'origin': True}, 'moving': 'pin', 'joint': 'ball', 'align': 'closest', 'name': 'pin-ball-1'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, -10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pin', 'part': 'P16a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 0.866025, -0.5], [0.0, 0.5, 0.866025]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A19c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, -10], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 0], 'grounded': False, 'turn': [{'axis': 'Y', 'deg': 45}]}, 'kind': 'assembly'}, {'kind': 'assembly', 'constraint': {'type': 'coincident', 'a': {'origin': True, 'component': 'pin'}, 'b': {'origin': True}, 'moving': 'pin', 'joint': 'ball', 'align': 'closest', 'name': 'pin-ball-1'}}, {'kind': 'assembly', 'constraint': {'type': 'limit_angle', 'a': {'plane': 'Front', 'component': 'pin'}, 'b': {'plane': 'Front'}, 'moving': 'pin', 'joint': 'ball', 'value': 45, 'min': 0, 'max': 45, 'name': 'pin-ball-2'}}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, -10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pin', 'part': 'P16a', 't': [0.0, 0.0, 0.0], 'R': [[0.707107, 0.0, 0.707107], [0.0, 1.0, 0.0], [-0.707107, 0.0, 0.707107]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A20a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P04a', 'name': 'fillet', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'mirror': {'component': 'fillet', 'name': 'fillet_m', 'plane': {'normal': 'X', 'offset': 20}, 'mode': 'instance', 'corner': [10.0, 15.0, 5.0], 'orientations': [0, 3, 2, 1]}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'fillet', 'part': 'P04a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'fillet_m', 'part': 'P04a', 't': [40.0, 0.0, 0.0], 'R': [[-1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': False, 'score_t': False, 'bbox': [[-10.0, -15.0, 0.0], [50.0, 15.0, 10.0]]}}, {'id': 'A20b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P04a', 'name': 'fillet', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'mirror': {'component': 'fillet', 'name': 'fillet_m', 'plane': {'normal': 'Y', 'offset': 40}, 'mode': 'instance', 'corner': [10.0, 15.0, 5.0], 'orientations': [3, 0, 2, 1]}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'fillet', 'part': 'P04a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'fillet_m', 'part': 'P04a', 't': [0.0, 80.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, -1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}], 'score_R': False, 'score_t': False, 'bbox': [[-10.0, -15.0, 0.0], [10.0, 95.0, 10.0]]}}, {'id': 'A20c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P04a', 'name': 'fillet', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'mirror': {'component': 'fillet', 'name': 'fillet_m', 'plane': {'normal': 'X', 'offset': 20}, 'mode': 'new_part', 'part': 'P04a-mirrored', 'corner': [10.0, 15.0, 5.0], 'orientations': [0, 3, 2, 1]}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'fillet', 'part': 'P04a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'fillet_m', 'part': 'P04a-mirrored', 't': [40.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'mirrored_part': True, 'R_scored': False}], 'score_R': True, 'score_t': True, 'bbox': [[-10.0, -15.0, 0.0], [50.0, 15.0, 10.0]]}}, {'id': 'A21a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A21-pair', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A21-pair', 'name': 'pair', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'pattern': {'component': 'pair', 'dir1': {'axis': 'X', 'count': 3, 'spacing': 40}}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'pair#1/block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pair#1/pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'pair#2/block', 'part': 'P01a', 't': [40.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'pair#2/pin', 'part': 'P16a', 't': [40.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}, {'path': 'pair#3/block', 'part': 'P01a', 't': [80.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'pair#3/pin', 'part': 'P16a', 't': [80.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A21b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A21-pair', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A21-pair', 'name': 'pair', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'pattern': {'component': 'pair', 'dir1': {'axis': 'X', 'count': 2, 'spacing': 25}}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'pair#1/block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pair#1/pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'pair#2/block', 'part': 'P01a', 't': [25.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'pair#2/pin', 'part': 'P16a', 't': [25.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A21c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A21-pair', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A21-pair', 'name': 'pair', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'pattern': {'component': 'pair', 'dir1': {'axis': 'Y', 'count': 3, 'spacing': 40}}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'pair#1/block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pair#1/pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'pair#2/block', 'part': 'P01a', 't': [0.0, 40.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'pair#2/pin', 'part': 'P16a', 't': [0.0, 40.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}, {'path': 'pair#3/block', 'part': 'P01a', 't': [0.0, 80.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'pair#3/pin', 'part': 'P16a', 't': [0.0, 80.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A22a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A21-pair', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A21-pair', 'name': 'pair', 'at': [40, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'pattern': {'component': 'pair', 'circular': {'axis': 'Z', 'count': 3, 'angle': 360, 'rotate': True}}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'pair#1/block', 'part': 'P01a', 't': [40.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pair#1/pin', 'part': 'P16a', 't': [40.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'pair#2/block', 'part': 'P01a', 't': [-20.0, 34.641016, 0.0], 'R': [[-0.5, -0.866025, 0.0], [0.866025, -0.5, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'pair#2/pin', 'part': 'P16a', 't': [-20.0, 34.641016, 10.0], 'R': [[-0.5, -0.866025, 0.0], [0.866025, -0.5, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}, {'path': 'pair#3/block', 'part': 'P01a', 't': [-20.0, -34.641016, 0.0], 'R': [[-0.5, 0.866025, 0.0], [-0.866025, -0.5, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'pair#3/pin', 'part': 'P16a', 't': [-20.0, -34.641016, 10.0], 'R': [[-0.5, 0.866025, 0.0], [-0.866025, -0.5, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A22b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A21-pair', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A21-pair', 'name': 'pair', 'at': [40, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'pattern': {'component': 'pair', 'circular': {'axis': 'Z', 'count': 2, 'angle': 360, 'rotate': True}}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'pair#1/block', 'part': 'P01a', 't': [40.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pair#1/pin', 'part': 'P16a', 't': [40.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'R_scored': False}, {'path': 'pair#2/block', 'part': 'P01a', 't': [-40.0, 0.0, 0.0], 'R': [[-1.0, 0.0, 0.0], [0.0, -1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False}, {'path': 'pair#2/pin', 'part': 'P16a', 't': [-40.0, 0.0, 10.0], 'R': [[-1.0, 0.0, 0.0], [0.0, -1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A23a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True, 'external': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [40, 0, 0], 'grounded': False, 'external': True}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'external': True}, {'path': 'pin', 'part': 'P16a', 't': [40.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'external': True, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A23b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True, 'external': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [40, 0, 0], 'grounded': False, 'external': True}, 'kind': 'assembly'}, {'type': 'assembly', 'component': 'pin', 'make_virtual': True, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'external': True}, {'path': 'pin', 'part': 'P16a', 't': [40.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'external': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A23c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'kind': 'assembly', 'copy_part': {'recipe': 'P01a', 'file': 'A23c-P01a'}}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True, 'external': True, 'file': 'A23c-P01a'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [40, 0, 0], 'grounded': False, 'external': True}, 'kind': 'assembly'}, {'type': 'assembly', 'source_edit': {'recipe': 'P01a', 'becomes': 'P01b', 'file': 'A23c-P01a', 'original': 10.0, 'height': 12.0}, 'update_references': True, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'external': True}, {'path': 'pin', 'part': 'P16a', 't': [40.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'external': True, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A24a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A24-pair', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'mate', 'name': 'pin_top', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'pin'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'offset': 0}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A24-pair', 'name': 'pair1', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A24-pair', 'name': 'pair2', 'at': [50, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'component': 'pair2', 'flexible': True, 'kind': 'assembly'}, {'type': 'assembly', 'move': {'component': 'pair2/pin', 'by': [6, 0, 0]}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'pair1/block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'flexible': False}, {'path': 'pair1/pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'flexible': False, 'R_scored': False}, {'path': 'pair2/block', 'part': 'P01a', 't': [50.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'flexible': True}, {'path': 'pair2/pin', 'part': 'P16a', 't': [56.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'flexible': True, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A24b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'subassembly': {'file': 'A24-pair', 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'mate', 'name': 'pin_top', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'pin'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'offset': 0}, 'kind': 'assembly'}]}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A24-pair', 'name': 'pair1', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'assembly': 'A24-pair', 'name': 'pair2', 'at': [50, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'component': 'pair2', 'flexible': True, 'kind': 'assembly'}, {'type': 'assembly', 'move': {'component': 'pair2/pin', 'by': [6, 0, 0]}, 'kind': 'assembly'}, {'type': 'assembly', 'component': 'pair1', 'flexible': True, 'kind': 'assembly'}, {'type': 'assembly', 'move': {'component': 'pair1/pin', 'by': [-6, 0, 0]}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'pair1/block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'flexible': True}, {'path': 'pair1/pin', 'part': 'P16a', 't': [-6.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'flexible': True, 'R_scored': False}, {'path': 'pair2/block', 'part': 'P01a', 't': [50.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'flexible': True}, {'path': 'pair2/pin', 'part': 'P16a', 't': [56.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'flexible': True, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A25a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [60, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'mate', 'name': 'pin_top', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'pin'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'offset': 0}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'suppressed': False, 'R_scored': False}, {'path': 'ring', 'part': 'P02a', 't': [60.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'suppressed': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A25b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [60, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'mate', 'name': 'pin_top', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'pin'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'offset': 0}, 'kind': 'assembly'}, {'type': 'assembly', 'component': 'pin', 'suppressed': True, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'suppressed': True, 'R_scored': False}, {'path': 'ring', 'part': 'P02a', 't': [60.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'suppressed': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A25c', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [60, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'mate', 'name': 'pin_top', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'pin'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'offset': 0}, 'kind': 'assembly'}, {'type': 'assembly', 'component': 'ring', 'suppressed': True, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'suppressed': False, 'R_scored': False}, {'path': 'ring', 'part': 'P02a', 't': [60.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'suppressed': True, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A25d', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P02a', 'name': 'ring', 'at': [60, 0, 0], 'grounded': True}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'mate', 'name': 'pin_top', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'pin'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'offset': 0}, 'kind': 'assembly'}, {'type': 'assembly', 'mate': 'pin_top', 'suppressed': True, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True}, {'path': 'pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'suppressed': False, 'R_scored': False}, {'path': 'ring', 'part': 'P02a', 't': [60.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'suppressed': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A26a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'part_configuration': {'recipe': 'P01a', 'name': 'Tall', 'like': 'P01b', 'height': 12, 'active': 'Tall', 'file': 'A26a-P01a', 'original': 10.0}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True, 'config': 'Tall', 'file': 'A26a-P01a'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 12], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'mate', 'name': 'pin_top', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'pin'}, 'b': {'face': {'contains': [0, 0, 12], 'normal': '+Z'}, 'component': 'block'}, 'offset': 0}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01b', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'config': 'Tall'}, {'path': 'pin', 'part': 'P16a', 't': [0.0, 0.0, 12.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'A26b', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'assembly', 'part_configuration': {'recipe': 'P01a', 'name': 'Tall', 'like': 'P01b', 'height': 12, 'active': 'Default', 'file': 'A26b-P01a', 'original': 10.0}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P01a', 'name': 'block', 'at': [0, 0, 0], 'grounded': True, 'config': 'Default', 'file': 'A26b-P01a'}, 'kind': 'assembly'}, {'type': 'assembly', 'insert': {'recipe': 'P16a', 'name': 'pin', 'at': [0, 0, 10], 'grounded': False}, 'kind': 'assembly'}, {'type': 'assembly', 'constraint': {'type': 'mate', 'name': 'pin_top', 'a': {'face': {'contains': [0, 0, 0], 'normal': '-Z'}, 'component': 'pin'}, 'b': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}, 'component': 'block'}, 'offset': 0}, 'kind': 'assembly'}], 'placements': {'instances': [{'path': 'block', 'part': 'P01a', 't': [0.0, 0.0, 0.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': True, 'config': 'Default'}, {'path': 'pin', 'part': 'P16a', 't': [0.0, 0.0, 10.0], 'R': [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], 'grounded': False, 'R_scored': False}], 'score_R': True, 'score_t': True}}, {'id': 'F04a', 'scripted': True, 'why_not': '', 'expect': {'volume': 5803.65, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [0, 0, 10], 'on_face': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 5, 'through_all': True, 'kind': 'hole'}]}, {'id': 'F04b', 'scripted': True, 'why_not': '', 'expect': {'volume': 5671.7, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [0, 0, 10], 'on_face': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}}, 'hole_type': 'counterbore', 'dia': 5, 'through_all': True, 'cb_dia': 9, 'cb_depth': 3, 'kind': 'hole'}]}, {'id': 'F04c', 'scripted': True, 'why_not': '', 'expect': {'volume': 5882.19, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [0, 0, 10], 'on_face': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 5, 'through_all': False, 'depth': 6, 'tip': 'flat', 'kind': 'hole'}]}, {'id': 'F04e', 'scripted': True, 'why_not': '', 'expect': {'volume': 5872.36, 'bbox': [[-10, -15, 0], [10, 15, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'rect_center', 'c': [0, 0, 0], 'w': 20, 'h': 30}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [0, 0, 10], 'on_face': {'face': {'contains': [0, 0, 10], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 5, 'through_all': False, 'depth': 6, 'tip': 'angle', 'tip_angle': 118, 'kind': 'hole'}]}, {'id': 'W01a', 'scripted': True, 'why_not': '', 'expect': {'volume': 791.888, 'bbox': [[-11, -0.997, -11], [11, 20.997, 11]]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 10}], 'dims': True, 'name': 'axis_circle', 'kind': 'sketch'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'helix_spiral', 'params': {'name': 'curve', 'sketch': 'axis_circle', 'kind': 'helix', 'defined_by': 'pitch_revolution', 'pitch': 5, 'revolutions': 4, 'start_angle': 0, 'direction': 'clockwise', 'reverse': False, 'axis': 'Y'}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'plane_normal_to_curve', 'params': {'name': 'profile_plane', 'curve': 'curve', 'at': 'start', 'start_point': [10, 0, 0]}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': {'normal': 'Z', 'origin': [10, 0, 0]}, 'entities': [{'type': 'circle', 'c': [10, 0, 0], 'r': 1}], 'dims': True, 'name': 'profile', 'on_plane': 'profile_plane', 'pierce': 'curve', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'curve', 'kind': 'sweep'}]}, {'id': 'W01b', 'scripted': True, 'why_not': '', 'expect': {'volume': 791.888, 'bbox': [[-11, -20.997, -11], [11, 0.997, 11]]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 10}], 'dims': True, 'name': 'axis_circle', 'kind': 'sketch'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'helix_spiral', 'params': {'name': 'curve', 'sketch': 'axis_circle', 'kind': 'helix', 'defined_by': 'pitch_revolution', 'pitch': 5, 'revolutions': 4, 'start_angle': 0, 'direction': 'clockwise', 'reverse': True, 'axis': 'Y'}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'plane_normal_to_curve', 'params': {'name': 'profile_plane', 'curve': 'curve', 'at': 'start', 'start_point': [10, 0, 0]}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': {'normal': 'Z', 'origin': [10, 0, 0]}, 'entities': [{'type': 'circle', 'c': [10, 0, 0], 'r': 1}], 'dims': True, 'name': 'profile', 'on_plane': 'profile_plane', 'pierce': 'curve', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'curve', 'kind': 'sweep'}]}, {'id': 'W01c', 'scripted': True, 'why_not': '', 'expect': {'volume': 791.888, 'bbox': [[-11, -0.997, -11], [11, 20.997, 11]]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 10}], 'dims': True, 'name': 'axis_circle', 'kind': 'sketch'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'helix_spiral', 'params': {'name': 'curve', 'sketch': 'axis_circle', 'kind': 'helix', 'defined_by': 'pitch_revolution', 'pitch': 5, 'revolutions': 4, 'start_angle': 0, 'direction': 'counterclockwise', 'reverse': False, 'axis': 'Y'}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'plane_normal_to_curve', 'params': {'name': 'profile_plane', 'curve': 'curve', 'at': 'start', 'start_point': [10, 0, 0]}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': {'normal': 'Z', 'origin': [10, 0, 0]}, 'entities': [{'type': 'circle', 'c': [10, 0, 0], 'r': 1}], 'dims': True, 'name': 'profile', 'on_plane': 'profile_plane', 'pierce': 'curve', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'curve', 'kind': 'sweep'}]}, {'id': 'W01d', 'scripted': True, 'why_not': '', 'expect': {'volume': 791.888, 'bbox': [[-11, -0.997, -11], [11, 20.997, 11]]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 10}], 'dims': True, 'name': 'axis_circle', 'kind': 'sketch'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'helix_spiral', 'params': {'name': 'curve', 'sketch': 'axis_circle', 'kind': 'helix', 'defined_by': 'height_revolution', 'revolutions': 4, 'start_angle': 0, 'direction': 'clockwise', 'reverse': False, 'axis': 'Y', 'height': 20}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'plane_normal_to_curve', 'params': {'name': 'profile_plane', 'curve': 'curve', 'at': 'start', 'start_point': [10, 0, 0]}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': {'normal': 'Z', 'origin': [10, 0, 0]}, 'entities': [{'type': 'circle', 'c': [10, 0, 0], 'r': 1}], 'dims': True, 'name': 'profile', 'on_plane': 'profile_plane', 'pierce': 'curve', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'curve', 'kind': 'sweep'}]}, {'id': 'W01e', 'scripted': True, 'why_not': '', 'expect': {'volume': 791.888, 'bbox': [[-11, -0.997, -11], [11, 20.997, 11]]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 10}], 'dims': True, 'name': 'axis_circle', 'kind': 'sketch'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'helix_spiral', 'params': {'name': 'curve', 'sketch': 'axis_circle', 'kind': 'helix', 'defined_by': 'height_pitch', 'pitch': 5, 'start_angle': 0, 'direction': 'clockwise', 'reverse': False, 'axis': 'Y', 'height': 20}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'plane_normal_to_curve', 'params': {'name': 'profile_plane', 'curve': 'curve', 'at': 'start', 'start_point': [10, 0, 0]}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': {'normal': 'Z', 'origin': [10, 0, 0]}, 'entities': [{'type': 'circle', 'c': [10, 0, 0], 'r': 1}], 'dims': True, 'name': 'profile', 'on_plane': 'profile_plane', 'pierce': 'curve', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'curve', 'kind': 'sweep'}]}, {'id': 'W01f', 'scripted': True, 'why_not': '', 'expect': {'volume': 1580.51, 'bbox': [[None, -1, None], [None, 1, None]], 'size': [57.023, 2, 59.512]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 10}], 'dims': True, 'name': 'axis_circle', 'kind': 'sketch'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'helix_spiral', 'params': {'name': 'curve', 'sketch': 'axis_circle', 'kind': 'spiral', 'defined_by': 'pitch_revolution', 'pitch': 5, 'revolutions': 4, 'start_angle': 0, 'direction': 'clockwise', 'reverse': False, 'axis': 'Y'}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'plane_normal_to_curve', 'params': {'name': 'profile_plane', 'curve': 'curve', 'at': 'start', 'start_point': [10, 0, 0]}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': {'normal': 'Z', 'origin': [10, 0, 0]}, 'entities': [{'type': 'circle', 'c': [10, 0, 0], 'r': 1}], 'dims': True, 'name': 'profile', 'on_plane': 'profile_plane', 'pierce': 'curve', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'curve', 'kind': 'sweep'}]}, {'id': 'W01g', 'scripted': True, 'why_not': '', 'expect': {'bbox': [[None, -0.997, None], [None, 20.998, None]], 'size': [28.173, 21.995, 28.612]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 10}], 'dims': True, 'name': 'axis_circle', 'kind': 'sketch'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'helix_spiral', 'params': {'name': 'curve', 'sketch': 'axis_circle', 'kind': 'helix', 'defined_by': 'pitch_revolution', 'pitch': 5, 'revolutions': 4, 'start_angle': 0, 'direction': 'clockwise', 'reverse': False, 'axis': 'Y', 'taper_angle': 10, 'taper': 'outward'}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'plane_normal_to_curve', 'params': {'name': 'profile_plane', 'curve': 'curve', 'at': 'start', 'start_point': [10, 0, 0]}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': {'normal': 'Z', 'origin': [10, 0, 0]}, 'entities': [{'type': 'circle', 'c': [10, 0, 0], 'r': 1}], 'dims': True, 'name': 'profile', 'on_plane': 'profile_plane', 'pierce': 'curve', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'curve', 'kind': 'sweep'}]}, {'id': 'W01h', 'scripted': True, 'why_not': '', 'expect': {'bbox': [[-11, -0.997, -11], [11, None, 11]]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'circle', 'c': [0, 0, 0], 'r': 10}], 'dims': True, 'name': 'axis_circle', 'kind': 'sketch'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'helix_spiral', 'params': {'name': 'curve', 'sketch': 'axis_circle', 'kind': 'helix', 'defined_by': 'variable_pitch', 'revolutions': 4, 'start_angle': 0, 'direction': 'clockwise', 'reverse': False, 'axis': 'Y', 'regions': [{'revolutions': 0, 'pitch': 5, 'diameter': 20}, {'revolutions': 4, 'pitch': 8, 'diameter': 20}]}, 'kind': 'app_specific'}, {'type': 'app_specific', 'app': 'solidworks', 'op': 'plane_normal_to_curve', 'params': {'name': 'profile_plane', 'curve': 'curve', 'at': 'start', 'start_point': [10, 0, 0]}, 'kind': 'app_specific'}, {'type': 'sketch', 'plane': {'normal': 'Z', 'origin': [10, 0, 0]}, 'entities': [{'type': 'circle', 'c': [10, 0, 0], 'r': 1}], 'dims': True, 'name': 'profile', 'on_plane': 'profile_plane', 'pierce': 'curve', 'kind': 'sketch'}, {'type': 'sweep', 'profile': 'profile', 'path': 'curve', 'kind': 'sweep'}]}, {'id': 'D04a', 'scripted': True, 'why_not': '', 'expect': {'volume': 9608.63, 'bbox': [[0, 0, 0], [40, 30, 30]]}, 'ops': [{'type': 'sketch', 'plane': 'XZ', 'entities': [{'type': 'line', 'a': [0, 0, 0], 'b': [40, 0, 0]}, {'type': 'line', 'a': [40, 0, 0], 'b': [40, 0, 5]}, {'type': 'line', 'a': [40, 0, 5], 'b': [5, 0, 5]}, {'type': 'line', 'a': [5, 0, 5], 'b': [5, 0, 30]}, {'type': 'line', 'a': [5, 0, 30], 'b': [0, 0, 30]}, {'type': 'line', 'a': [0, 0, 30], 'b': [0, 0, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 30, 'direction': '+', 'op': 'new', 'extent': 'distance', 'axis': 'Y', 'kind': 'extrude'}, {'type': 'hole', 'at': [25, 15, 5], 'on_face': {'face': {'contains': [25, 15, 5], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 6, 'through_all': True, 'kind': 'hole'}]}, {'id': 'D05a', 'scripted': True, 'why_not': '', 'expect': {}, 'ops': [{'type': 'drawing', 'model': 'D04a', 'template': 'default_metric', 'title_block': 'default', 'views': [{'type': 'base', 'orientation': 'show_L', 'scale': '1:1'}, {'type': 'projected', 'direction': 'vertical'}, {'type': 'projected', 'direction': 'beside'}], 'dims': True, 'dimensions': [{'type': 'linear', 'value': 40, 'between': [[0, 0, 0], [40, 0, 0]]}, {'type': 'linear', 'value': 30, 'between': [[0, 0, 0], [0, 0, 30]]}, {'type': 'linear', 'value': 5, 'between': [[40, 0, 0], [40, 0, 5]]}, {'type': 'linear', 'value': 25, 'between': [[0, 15, 5], [25, 15, 5]]}], 'export': {'format': 'DXF', 'version': [2018, 2000], 'scale': '1:1', 'text': 'not_exploded'}, 'kind': 'drawing'}]}, {'id': 'D06a', 'scripted': True, 'why_not': '', 'expect': {'volume': 21214.6, 'bbox': [[0, 0, 0], [60, 40, 10]]}, 'ops': [{'type': 'sketch', 'plane': 'XY', 'entities': [{'type': 'line', 'a': [0, 0, 0], 'b': [60, 0, 0]}, {'type': 'line', 'a': [60, 0, 0], 'b': [60, 20, 0]}, {'type': 'line', 'a': [60, 20, 0], 'b': [40, 40, 0]}, {'type': 'line', 'a': [40, 40, 0], 'b': [0, 40, 0]}, {'type': 'line', 'a': [0, 40, 0], 'b': [0, 0, 0]}], 'dims': True, 'kind': 'sketch'}, {'type': 'extrude', 'profile': 'last', 'distance': 10, 'direction': '+', 'op': 'new', 'extent': 'distance', 'kind': 'extrude'}, {'type': 'hole', 'at': [20, 20, 10], 'on_face': {'face': {'contains': [20, 20, 10], 'normal': '+Z'}}, 'hole_type': 'simple', 'dia': 10, 'through_all': True, 'kind': 'hole'}]}, {'id': 'D10a', 'scripted': False, 'why_not': 'made by the drawings package (FixtureDrawings.bas)', 'expect': {}, 'ops': [{'type': 'drawing', 'model': 'F04a', 'standard': 'ISO', 'units': 'mm', 'sheet': 'A4', 'orientation': 'landscape', 'title_block': {'title': 'F04a drawing', 'designer': 'Fixture Builder'}, 'views': [{'type': 'base', 'orientation': 'Front', 'scale': '1:1'}, {'type': 'projected', 'orientation': 'Right'}, {'type': 'projected', 'orientation': 'Top'}, {'type': 'iso', 'scale': '1:2'}, {'type': 'section', 'label': 'A-A', 'line': {'x': 0, 'direction': 'vertical'}}], 'dims': True, 'dimensions': [{'type': 'linear', 'value': 20, 'expect': 20, 'between': [[-10, -15, 10], [10, -15, 10]]}, {'type': 'linear', 'value': 30, 'expect': 30, 'between': [[-10, -15, 10], [-10, 15, 10]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[10, -15, 0], [10, -15, 10]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[-10, 0, 10], [0, 0, 10]]}, {'type': 'linear', 'value': 15, 'expect': 15, 'between': [[0, -15, 10], [0, 0, 10]]}], 'export': {'format': 'DXF', 'pdf': True, 'version': [2018, 2000], 'scale': '1:1', 'text': 'not_exploded'}, 'kind': 'drawing'}]}, {'id': 'D11a', 'scripted': False, 'why_not': 'made by the drawings package (FixtureDrawings.bas)', 'expect': {}, 'ops': [{'type': 'drawing', 'model': 'D04a', 'standard': 'ISO', 'units': 'mm', 'sheet': 'A4', 'orientation': 'landscape', 'title_block': {'title': 'D04a drawing', 'designer': 'Fixture Builder'}, 'views': [{'type': 'base', 'orientation': 'Front', 'scale': '1:1'}, {'type': 'projected', 'orientation': 'Right'}, {'type': 'projected', 'orientation': 'Top'}, {'type': 'iso', 'scale': '1:2'}, {'type': 'section', 'label': 'A-A', 'line': {'x': 25, 'direction': 'vertical'}}], 'dims': True, 'dimensions': [{'type': 'linear', 'value': 40, 'expect': 40, 'between': [[0, 0, 0], [40, 0, 0]]}, {'type': 'linear', 'value': 30, 'expect': 30, 'between': [[0, 0, 0], [0, 0, 30]]}, {'type': 'linear', 'value': 5, 'expect': 5, 'between': [[40, 0, 0], [40, 0, 5]]}, {'type': 'linear', 'value': 25, 'expect': 25, 'between': [[0, 15, 5], [25, 15, 5]]}], 'export': {'format': 'DXF', 'pdf': True, 'version': [2018, 2000], 'scale': '1:1', 'text': 'not_exploded'}, 'kind': 'drawing'}]}, {'id': 'D12a', 'scripted': False, 'why_not': 'made by the drawings package (FixtureDrawings.bas)', 'expect': {}, 'ops': [{'type': 'drawing', 'model': 'D06a', 'standard': 'ISO', 'units': 'mm', 'sheet': 'A4', 'orientation': 'landscape', 'title_block': {'title': 'D06a drawing', 'designer': 'Fixture Builder'}, 'views': [{'type': 'base', 'orientation': 'Front', 'scale': '1:1'}, {'type': 'projected', 'orientation': 'Right'}, {'type': 'projected', 'orientation': 'Top'}, {'type': 'iso', 'scale': '1:2'}, {'type': 'section', 'label': 'A-A', 'line': {'x': 20, 'direction': 'vertical'}}], 'dims': True, 'dimensions': [{'type': 'linear', 'value': 60, 'expect': 60, 'between': [[0, 0, 0], [60, 0, 0]]}, {'type': 'linear', 'value': 40, 'expect': 40, 'between': [[0, 0, 10], [0, 40, 10]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[60, 0, 0], [60, 0, 10]]}, {'type': 'linear', 'value': 20, 'expect': 20, 'between': [[0, 20, 10], [20, 20, 10]]}, {'type': 'linear', 'value': 20, 'expect': 20, 'between': [[60, 0, 10], [60, 20, 10]]}], 'export': {'format': 'DXF', 'pdf': True, 'version': [2018, 2000], 'scale': '1:1', 'text': 'not_exploded'}, 'kind': 'drawing'}]}, {'id': 'D13a', 'scripted': False, 'why_not': 'made by the drawings package (FixtureDrawings.bas)', 'expect': {}, 'ops': [{'type': 'drawing', 'model': 'P03a', 'standard': 'ISO', 'units': 'mm', 'sheet': 'A4', 'orientation': 'landscape', 'title_block': {'title': 'P03a drawing', 'designer': 'Fixture Builder'}, 'views': [{'type': 'base', 'orientation': 'Front', 'scale': '1:1'}, {'type': 'projected', 'orientation': 'Right'}, {'type': 'projected', 'orientation': 'Top'}, {'type': 'iso', 'scale': '1:2'}, {'type': 'section', 'label': 'A-A', 'line': {'x': 0, 'direction': 'vertical'}}], 'dims': True, 'dimensions': [{'type': 'linear', 'value': 20, 'expect': 20, 'between': [[-10, -15, 10], [10, -15, 10]]}, {'type': 'linear', 'value': 30, 'expect': 30, 'between': [[-10, -15, 10], [-10, 15, 10]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[10, -15, 0], [10, -15, 10]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[-10, 0, 10], [0, 0, 10]]}, {'type': 'linear', 'value': 15, 'expect': 15, 'between': [[0, -15, 10], [0, 0, 10]]}], 'export': {'format': 'DXF', 'pdf': True, 'version': [2018, 2000], 'scale': '1:1', 'text': 'not_exploded'}, 'kind': 'drawing'}]}, {'id': 'D14a', 'scripted': False, 'why_not': 'made by the drawings package (FixtureDrawings.bas)', 'expect': {}, 'ops': [{'type': 'drawing', 'model': 'P03b', 'standard': 'ISO', 'units': 'mm', 'sheet': 'A4', 'orientation': 'landscape', 'title_block': {'title': 'P03b drawing', 'designer': 'Fixture Builder'}, 'views': [{'type': 'base', 'orientation': 'Front', 'scale': '1:1'}, {'type': 'projected', 'orientation': 'Right'}, {'type': 'projected', 'orientation': 'Top'}, {'type': 'iso', 'scale': '1:2'}, {'type': 'section', 'label': 'A-A', 'line': {'x': 0, 'direction': 'vertical'}}], 'dims': True, 'dimensions': [{'type': 'linear', 'value': 20, 'expect': 20, 'between': [[-10, -15, 10], [10, -15, 10]]}, {'type': 'linear', 'value': 30, 'expect': 30, 'between': [[-10, -15, 10], [-10, 15, 10]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[10, -15, 0], [10, -15, 10]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[-10, 0, 10], [0, 0, 10]]}, {'type': 'linear', 'value': 15, 'expect': 15, 'between': [[0, -15, 10], [0, 0, 10]]}], 'export': {'format': 'DXF', 'pdf': True, 'version': [2018, 2000], 'scale': '1:1', 'text': 'not_exploded'}, 'kind': 'drawing'}]}, {'id': 'D15a', 'scripted': False, 'why_not': 'made by the drawings package (FixtureDrawings.bas)', 'expect': {}, 'ops': [{'type': 'drawing', 'model': 'P07a', 'standard': 'ISO', 'units': 'mm', 'sheet': 'A4', 'orientation': 'landscape', 'title_block': {'title': 'P07a drawing', 'designer': 'Fixture Builder'}, 'views': [{'type': 'base', 'orientation': 'Front', 'scale': '1:1'}, {'type': 'projected', 'orientation': 'Right'}, {'type': 'projected', 'orientation': 'Top'}, {'type': 'iso', 'scale': '1:2'}, {'type': 'section', 'label': 'A-A', 'line': {'x': 5, 'direction': 'vertical'}}], 'dims': True, 'dimensions': [{'type': 'linear', 'value': 60, 'expect': 60, 'between': [[0, 0, 5], [60, 0, 5]]}, {'type': 'linear', 'value': 40, 'expect': 40, 'between': [[0, 0, 5], [0, 40, 5]]}, {'type': 'linear', 'value': 5, 'expect': 5, 'between': [[60, 0, 0], [60, 0, 5]]}, {'type': 'linear', 'value': 5, 'expect': 5, 'between': [[0, 5, 5], [5, 5, 5]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[5, 5, 5], [15, 5, 5]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[5, 5, 5], [5, 15, 5]]}], 'export': {'format': 'DXF', 'pdf': True, 'version': [2018, 2000], 'scale': '1:1', 'text': 'not_exploded'}, 'kind': 'drawing'}]}, {'id': 'D16a', 'scripted': False, 'why_not': 'made by the drawings package (FixtureDrawings.bas)', 'expect': {}, 'ops': [{'type': 'drawing', 'model': 'P08a', 'standard': 'ISO', 'units': 'mm', 'sheet': 'A4', 'orientation': 'landscape', 'title_block': {'title': 'P08a drawing', 'designer': 'Fixture Builder'}, 'views': [{'type': 'base', 'orientation': 'Front', 'scale': '1:1'}, {'type': 'projected', 'orientation': 'Right'}, {'type': 'projected', 'orientation': 'Top'}, {'type': 'iso', 'scale': '1:2'}, {'type': 'section', 'label': 'A-A', 'line': {'x': 20, 'direction': 'vertical'}}], 'dims': True, 'dimensions': [{'type': 'linear', 'value': 60, 'expect': 60, 'between': [[-30, 0, 5], [30, 0, 5]]}, {'type': 'linear', 'value': 5, 'expect': 5, 'between': [[30, 0, 0], [30, 0, 5]]}, {'type': 'linear', 'value': 20, 'expect': 20, 'between': [[0, 0, 5], [20, 0, 5]]}, {'type': 'linear', 'value': 40, 'expect': 40, 'between': [[-20, 0, 5], [20, 0, 5]]}], 'export': {'format': 'DXF', 'pdf': True, 'version': [2018, 2000], 'scale': '1:1', 'text': 'not_exploded'}, 'kind': 'drawing'}]}, {'id': 'D17a', 'scripted': False, 'why_not': 'made by the drawings package (FixtureDrawings.bas)', 'expect': {}, 'ops': [{'type': 'drawing', 'model': 'P06a', 'standard': 'ISO', 'units': 'mm', 'sheet': 'A4', 'orientation': 'landscape', 'title_block': {'title': 'P06a drawing', 'designer': 'Fixture Builder'}, 'views': [{'type': 'base', 'orientation': 'Front', 'scale': '1:1'}, {'type': 'projected', 'orientation': 'Right'}, {'type': 'projected', 'orientation': 'Top'}, {'type': 'iso', 'scale': '1:2'}, {'type': 'section', 'label': 'A-A', 'line': {'x': 0, 'direction': 'vertical'}}], 'dims': True, 'dimensions': [{'type': 'linear', 'value': 20, 'expect': 20, 'between': [[-10, -15, 10], [10, -15, 10]]}, {'type': 'linear', 'value': 30, 'expect': 30, 'between': [[-10, -15, 10], [-10, 15, 10]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[10, -15, 0], [10, -15, 10]]}, {'type': 'linear', 'value': 1.5, 'expect': 1.5, 'between': [[-10, 0, 10], [-8.5, 0, 10]]}, {'type': 'linear', 'value': 1.5, 'expect': 1.5, 'between': [[0, -15, 10], [0, -13.5, 10]]}], 'export': {'format': 'DXF', 'pdf': True, 'version': [2018, 2000], 'scale': '1:1', 'text': 'not_exploded'}, 'kind': 'drawing'}]}, {'id': 'D18a', 'scripted': False, 'why_not': 'made by the drawings package (FixtureDrawings.bas)', 'expect': {}, 'ops': [{'type': 'drawing', 'model': 'P06b', 'standard': 'ISO', 'units': 'mm', 'sheet': 'A4', 'orientation': 'landscape', 'title_block': {'title': 'P06b drawing', 'designer': 'Fixture Builder'}, 'views': [{'type': 'base', 'orientation': 'Front', 'scale': '1:1'}, {'type': 'projected', 'orientation': 'Right'}, {'type': 'projected', 'orientation': 'Top'}, {'type': 'iso', 'scale': '1:2'}, {'type': 'section', 'label': 'A-A', 'line': {'x': 0, 'direction': 'vertical'}}], 'dims': True, 'dimensions': [{'type': 'linear', 'value': 20, 'expect': 20, 'between': [[-10, -15, 10], [10, -15, 10]]}, {'type': 'linear', 'value': 30, 'expect': 30, 'between': [[-10, -15, 10], [-10, 15, 10]]}, {'type': 'linear', 'value': 10, 'expect': 10, 'between': [[10, -15, 0], [10, -15, 10]]}, {'type': 'linear', 'value': 2, 'expect': 2, 'between': [[-10, 0, 10], [-8, 0, 10]]}, {'type': 'linear', 'value': 2, 'expect': 2, 'between': [[0, -15, 10], [0, -13, 10]]}], 'export': {'format': 'DXF', 'pdf': True, 'version': [2018, 2000], 'scale': '1:1', 'text': 'not_exploded'}, 'kind': 'drawing'}]}]
import json
import math
import os
import pathlib
import re
import sys
import time
import zipfile
MM = 0.001
TOL = 1e-07
SUPPORTED = set(SUPPORTED_NAMES)
step = 'setup'
current_identity = 'setup'
LAST_ZIP = []
LAST_FINISH = []
LAST_FOLDER = []
BUILDER_VERSION = '2026.11.26.2'
sw_major = 26
BASEFLANGE_INITIALIZE_FROM = 30
api_inputs = ''
call_inputs = ''
mitigations = {}
variable_fillet_dead = ''
probe_candidate = ''
PROBE_MAX_CANDIDATES = 6
PROBE_SECONDS = 120
HEM_CANDIDATES = ['reverse-false', 'reverse-true', 'edge-other-face-reverse-false', 'edge-other-face-reverse-true']
CORNER_CANDIDATES = ['length-less-thickness', 'profile-less-thickness', 'offset-less-thickness', 'unchanged-length']
PLANE_CANDIDATES = ['edge-start-vertex+no-pierce', 'edge-end-vertex+no-pierce', 'edge-start-vertex+no-pierce+featuredata', 'edge-start-vertex+no-pierce+circular-profile', 'edge-start-vertex+no-pierce+path-segments', 'edge-start-vertex+no-pierce+path-by-name', 'edge-start-vertex', 'curve-start-vertex', 'edge-end-vertex']
PLANE_PROBE_MAX = 20
PLANE_BASES = ('edge-start-vertex', 'edge-end-vertex', 'curve-start-vertex', 'origin-on-curve', '3d-sketch-point')
PLANE_MODIFIERS = ('no-pierce', 'featuredata', 'circular-profile', 'path-segments', 'path-by-name')

def plane_probe(name):
    """(is a plane candidate, base, modifiers) of a probe candidate name: the base before the first plus sign, the modifiers after it."""
    base, _, rest = str(name).partition('+')
    return (name in PLANE_CANDIDATES, base, frozenset(rest.split('+')) if rest else frozenset())
VARIABLE_HELIX_CANDIDATES = ['segments-only-height-pitch', 'first-pitch-before-insert', 'height-revolution-rebuild']
VARIABLE_FILLET_CANDIDATES = ['fillet3-help-sized-arrays', 'fillet3-edge-plus-control-point', 'featurefillet-edge-plus-control-point', 'createfeature-varfillet-data']
MATE_CANDIDATES = ['edge-distance-align1', 'edge-distance-align2', 'face-distance-align1', 'face-distance-align2', 'face-distance-flip']

def probe_entry(name, ok, error='', note=''):
    """One results.json probes entry, inside the portal's limits: name 60, error 300 characters (note 300 too)."""
    entry = dict(name=str(name)[:60], ok=bool(ok), error=str(error)[:300])
    if note:
        entry['note'] = str(note)[:300]
    return entry

def probe_candidates(design):
    """Names of the candidate approaches of this recipe, in the order they are tried; [] for an ordinary recipe."""
    for op in design['ops']:
        if op['kind'] == 'app_specific' and op.get('op') == 'helix_spiral' and (op['params'].get('defined_by') == 'variable_pitch'):
            return VARIABLE_HELIX_CANDIDATES[:PROBE_MAX_CANDIDATES]
        if op['kind'] == 'app_specific' and op.get('op') == 'plane_normal_to_curve':
            return PLANE_CANDIDATES[:PLANE_PROBE_MAX]
        if op['kind'] == 'fillet_variable':
            return VARIABLE_FILLET_CANDIDATES[:PROBE_MAX_CANDIDATES]
        if op['kind'] == 'sheetmetal' and op.get('action') == 'hem':
            return HEM_CANDIDATES[:PROBE_MAX_CANDIDATES]
        if op['kind'] == 'sheetmetal' and op.get('action') == 'flange' and (len(op.get('app', {}).get('edges', ())) > 1):
            return CORNER_CANDIDATES[:PROBE_MAX_CANDIDATES]
        constraint = op.get('constraint') or {}
        if op['kind'] == 'assembly' and constraint.get('type') == 'insert' and constraint.get('offset', 0) and ('edge' in constraint['a']) and ('edge' in constraint['b']):
            return MATE_CANDIDATES[:PROBE_MAX_CANDIDATES]
    return []

def multi_edge_lengths(candidate, height, thickness):
    """(profile sketch height, OffsetDistance) of a several-edge flange for a probe candidate; same unit as the arguments."""
    name = candidate or CORNER_CANDIDATES[0]
    return (height - thickness if name in ('length-less-thickness', 'profile-less-thickness') else height, height - thickness if name in ('length-less-thickness', 'offset-less-thickness') else height)
CORNER_SIZE_MEMBER = {0: 'SlotWidth', 1: 'SlotLength'}

def record_mitigation(name, primary_failed=False, always=False):
    counts = mitigations.setdefault(name, dict(count=0))
    counts['count'] += 1
    if primary_failed:
        counts['primary_failed'] = counts.get('primary_failed', 0) + 1
        counts.setdefault('fallback_ok', 0)

def mitigation_text():
    entries = []
    for name, counts in mitigations.items():
        entry = name + '=' + str(counts['count'])
        for key in ('primary_failed', 'fallback_ok'):
            if key in counts:
                entry += ',' + key.replace('_', '-') + '=' + str(counts[key])
        entries.append(entry)
    return 'mitigations: ' + (' '.join(entries) or 'none')

def log_mitigations(folder):
    entry = dict(time=time.strftime('%Y-%m-%dT%H:%M:%S%z'), builder=BUILDER_VERSION, recipe=current_identity, step='recipe complete', Erl=0, **{'Err.Number': 0, 'Err.Description': mitigation_text()})
    with (folder / 'FixtureBuilder.log').open('a', encoding='utf-8') as stream:
        stream.write(dump_json(entry) + '\n')

def set_step(label, procedure=''):
    global step
    step = current_identity + ': ' + (procedure + ' ' if procedure else '') + label
    geometric_call = label.startswith(('Create', 'Select', 'MultiSelect', 'InsertSketch', 'Insert3DSketch', 'InsertSheetMetal', 'AddEdges', 'SketchUseEdge')) or label in ('ActiveSketch', 'MultiplyTransform')
    if api_inputs and geometric_call:
        step += ' inputs(mm)=' + api_inputs
    if call_inputs and geometric_call:
        step += ' call(m)=' + call_inputs

def create_entity(sm, method, *args):
    global call_inputs, step
    call_inputs = repr(args)
    set_step(method, 'create_entity')
    set_step('AddToDB', 'create_entity')
    previous = sm.AddToDB
    try:
        set_step('AddToDB', 'create_entity')
        sm.AddToDB = True
        record_mitigation('addtodb-always')
        call_inputs += ' AddToDB=True previous=' + str(previous)
        set_step(method, 'create_entity')
        return getattr(sm, method)(*args)
    finally:
        saved_step = step
        set_step('AddToDB', 'create_entity')
        sm.AddToDB = previous
        step = saved_step

class KFactorFailed(Exception):
    """Round 23, kfactor-continue-diagnostic: the K-factor could not be set, the recipe was carried on to the end (nothing saved); the text starts with
    the K-factor error and ends with what the later features did."""

def diagnostic_error(exc):
    if isinstance(exc, KFactorFailed):
        return safe_error(exc)
    return step + ': ' + safe_error(exc)

class NotScripted(Exception):
    pass

class TemplateError(RuntimeError):
    pass

def resolve_template(app, kind):
    override, preference, filename = {'part': (TEMPLATE_PART, swDefaultTemplatePart, 'part.prtdot'), 'assembly': (TEMPLATE_ASSEMBLY, swDefaultTemplateAssembly, 'assem.asmdot'), 'drawing': (TEMPLATE_DRAWING, swDefaultTemplateDrawing, 'drawing.drwdot')}[kind]
    tried = []

    def existing(path):
        tried.append(str(path))
        return pathlib.Path(path).is_file()
    if override:
        if existing(override):
            return override
    set_step('GetUserPreferenceStringValue', 'resolve_template')
    default = app.GetUserPreferenceStringValue(preference)
    if default and existing(default):
        return default
    set_step('GetUserPreferenceStringValue', 'resolve_template')
    folders = [p.strip() for p in app.GetUserPreferenceStringValue(swFileLocationsDocumentTemplates).split(';') if p.strip()]
    install = pathlib.Path(app.GetExecutablePath())
    if install.suffix.lower() == '.exe':
        install = install.parent
    set_step('GetCurrentLanguage', 'resolve_template')
    language = install / 'lang' / app.GetCurrentLanguage()
    folders += [language, language / 'Tutorial']
    for folder in folders:
        folder = pathlib.Path(folder)
        canonical = folder / filename
        if existing(canonical):
            return str(canonical)
        pattern = '*' + pathlib.Path(filename).suffix
        tried.append(str(folder / pattern))
        for path in sorted(folder.glob(pattern)):
            if path != canonical and existing(path):
                return str(path)
    raise TemplateError(kind.capitalize() + ' template unavailable. Paths tried: ' + '; '.join(tried))

def xyz(p):
    return tuple((float(x) * MM for x in (list(p) + [0, 0, 0])[:3]))

def check(value, message):
    if value is None or value is False:
        raise RuntimeError(message)
    return value

def axis(value):
    sign = -1 if value.startswith('-') else 1
    return tuple((sign if c == value[-1] else 0 for c in 'XYZ'))

def opposite_axis(value):
    """'X' -> '-X', '-X' -> 'X': the same world axis the other way."""
    return value[1:] if value.startswith('-') else '-' + value

def plane_parameters(plane):
    if isinstance(plane, str):
        return (plane, 0)
    if 'base' in plane:
        return (plane['base'], plane.get('offset', 0))
    normal = plane.get('normal')
    if normal not in ('X', 'Y', 'Z'):
        raise NotScripted('only axis-aligned reference planes are implemented')
    origin = plane.get('origin', [0, 0, 0])
    return ({'X': 'YZ', 'Y': 'XZ', 'Z': 'XY'}[normal], origin['XYZ'.index(normal)])
PLANE_MAP = {'XY': ((0, 1), (1, 1)), 'XZ': ((0, 1), (2, -1)), 'YZ': ((2, -1), (1, 1))}

def plane_map(plane, model):
    return tuple((model[index] * sign + 0.0 for index, sign in PLANE_MAP[plane])) + (0.0,)

def matrix_usable(m):
    """IMathTransform.ArrayData: rotation 0-8, translation 9-11, scale 12."""
    if m is None or len(m) < 13 or (not all((math.isfinite(v) for v in m[:13]))):
        return False
    rows = [m[0:3], m[3:6], m[6:9]]
    for i in range(3):
        for j in range(3):
            dot = sum((a * b for a, b in zip(rows[i], rows[j])))
            if abs(dot - (1 if i == j else 0)) > 1e-06:
                return False
    return abs(m[12]) > 1e-09

def matrix_point(m, p):
    """Row-vector convention: local = (p x R) * scale + translation."""
    return tuple(((p[0] * m[j] + p[1] * m[3 + j] + p[2] * m[6 + j]) * m[12] + m[9 + j] for j in range(3)))

def matrix_inverse_point(m, local):
    """Round 13: the model point of a sketch point, the inverse of matrix_point (the rotation is orthonormal)."""
    shifted = [(local[j] - m[9 + j]) / m[12] for j in range(3)]
    return tuple((sum((shifted[j] * m[3 * i + j] for j in range(3))) for i in range(3)))

def mm_list(values):
    """Compact millimeters for a probe note: 5 significant digits, no negative zero."""
    return ','.join(('%.5g' % (0.0 if abs(v) < 1e-09 else v) for v in values))

def unit_list(values):
    return ','.join(('%.4g' % (0.0 if abs(v) < 1e-09 else v) for v in values))

def arc_middle(ent):
    if 'through' in ent:
        return ent['through']
    if not all((k in ent for k in ('a', 'b', 'c', 'r'))):
        raise NotScripted('arc needs endpoints and through-point or centre/radius')
    a, b, c = (ent['a'], ent['b'], ent['c'])
    u = [a[i] - c[i] for i in range(3)]
    v = [b[i] - c[i] for i in range(3)]
    mid = [u[i] + v[i] for i in range(3)]
    length = math.sqrt(sum((x * x for x in mid)))
    if length < TOL:
        raise NotScripted('semicircular arc requires a through-point')
    return [c[i] + mid[i] * ent['r'] / length for i in range(3)]
HELIX_DEFINED = {'pitch_revolution': swHelixDefinedBy_PitchAndRevolution, 'height_revolution': swHelixDefinedBy_HeightAndRevolution, 'height_pitch': swHelixDefinedBy_HeightAndPitch}
HELIX_KEYS = {'name', 'sketch', 'kind', 'defined_by', 'pitch', 'revolutions', 'height', 'start_angle', 'direction', 'reverse', 'axis', 'taper', 'taper_angle', 'regions'}

def helix_plan(p):
    """Everything InsertHelix or the variable-pitch calls need (meters, radians), and what the definition must read back as.

    The recipe's numbers are millimeters, degrees and revolutions. Anything this adapter cannot build faithfully is NotScripted."""
    unknown = sorted(set(p) - HELIX_KEYS)
    if unknown:
        raise NotScripted('helix_spiral: unsupported parameter ' + ', '.join(unknown))
    kind, defined = (p.get('kind'), p.get('defined_by'))
    if kind not in ('helix', 'spiral'):
        raise NotScripted('helix_spiral: kind must be helix or spiral, got ' + repr(kind))
    if p.get('direction') not in ('clockwise', 'counterclockwise'):
        raise NotScripted('helix_spiral: direction must be clockwise or counterclockwise, got ' + repr(p.get('direction')))
    number = lambda key: float(p[key]) if isinstance(p.get(key), (int, float)) and (not isinstance(p.get(key), bool)) else None
    plan = dict(kind=kind, reverse=bool(p.get('reverse', False)), clockwise=p['direction'] == 'clockwise', start=math.radians(number('start_angle') or 0.0), tapered=False, outward=False, taper=0.0, height=0.0, pitch=0.0, revolutions=0.0, regions=[], expect={})
    if kind == 'spiral':
        if defined != 'pitch_revolution' or p.get('taper_angle') is not None or p.get('taper') is not None:
            raise NotScripted('helix_spiral: a spiral is defined by pitch and revolution, without taper')
        if not (number('pitch') or 0) > 0 or not (number('revolutions') or 0) > 0:
            raise NotScripted('helix_spiral: a spiral needs a positive pitch and revolutions')
        plan.update(defined=swHelixDefinedBy_Spiral, pitch=number('pitch') * MM, revolutions=number('revolutions'))
        plan['expect'] = dict(Pitch=plan['pitch'], Revolution=plan['revolutions'])
        return plan
    if defined == 'variable_pitch':
        regions = p.get('regions')
        if p.get('taper_angle') is not None or p.get('taper') is not None:
            raise NotScripted('helix_spiral: a variable-pitch helix with taper is not implemented')
        if not isinstance(regions, list) or len(regions) < 2 or any((not isinstance(r, dict) or any((not isinstance(r.get(k), (int, float)) or isinstance(r.get(k), bool) for k in ('revolutions', 'pitch', 'diameter'))) for r in regions)):
            raise NotScripted('helix_spiral: variable pitch needs at least two regions with revolutions, pitch and diameter')
        revolutions = [float(r['revolutions']) for r in regions]
        if number('revolutions') not in (None, revolutions[-1]):
            raise NotScripted('helix_spiral: variable pitch revolutions must equal the last region revolutions')
        if revolutions[0] != 0 or any((b <= a for a, b in zip(revolutions, revolutions[1:]))) or any((float(r['pitch']) <= 0 or float(r['diameter']) <= 0 for r in regions)):
            raise NotScripted('helix_spiral: variable-pitch regions must start at revolutions 0, rise, and have positive pitch and diameter')
        plan.update(defined=swHelixDefinedBy_PitchAndRevolution, revolutions=revolutions[-1], regions=[(float(r['revolutions']), float(r['pitch']) * MM, float(r['diameter']) * MM) for r in regions])
        return plan
    if defined not in HELIX_DEFINED:
        raise NotScripted('helix_spiral: defined_by ' + repr(defined) + ' is not implemented')
    height, pitch, revolutions = (number('height'), number('pitch'), number('revolutions'))
    if defined == 'pitch_revolution':
        needed = (pitch, revolutions)
    elif defined == 'height_revolution':
        needed = (height, revolutions)
    else:
        needed = (height, pitch)
    if any((v is None or v <= 0 for v in needed)):
        raise NotScripted('helix_spiral: ' + defined + ' needs positive ' + ' and '.join({'pitch_revolution': ('pitch', 'revolutions'), 'height_revolution': ('height', 'revolutions'), 'height_pitch': ('height', 'pitch')}[defined]))
    if defined == 'pitch_revolution':
        height = pitch * revolutions
    elif defined == 'height_revolution':
        pitch = height / revolutions
    else:
        revolutions = height / pitch
    plan.update(defined=HELIX_DEFINED[defined], height=height * MM, pitch=pitch * MM, revolutions=revolutions)
    plan['expect'] = dict(Height=plan['height'], Pitch=plan['pitch'], Revolution=revolutions)
    if p.get('taper_angle') is not None or p.get('taper') is not None:
        angle = number('taper_angle')
        if p.get('taper') not in ('outward', 'inward') or angle is None or (not 0 < angle < 90):
            raise NotScripted('helix_spiral: taper needs taper outward or inward and a taper_angle between 0 and 90 degrees')
        plan.update(tapered=True, outward=p['taper'] == 'outward', taper=math.radians(angle))
    return plan

def api_interface(obj, name):
    """Query the documented COM interface using the installed type library's IID."""
    import pythoncom
    from win32com.client import dynamic
    set_step('GetContainingTypeLib', 'api_interface')
    library, _ = obj._oleobj_.GetTypeInfo().GetContainingTypeLib()
    for candidate in ('I' + name, name):
        set_step('GetTypeInfoCount', 'api_interface')
        for index in range(library.GetTypeInfoCount()):
            set_step('GetDocumentation', 'api_interface')
            if library.GetDocumentation(index)[0] != candidate:
                continue
            set_step('GetTypeAttr', 'api_interface')
            attributes = library.GetTypeInfo(index).GetTypeAttr()
            if attributes.typekind == 4:
                set_step('Dispatch', 'api_interface')
                return dynamic.Dispatch(obj._oleobj_.QueryInterface(attributes[0], pythoncom.IID_IDispatch))
    raise RuntimeError('SolidWorks interface unavailable: ' + name)

def cylinder_radial(entity, point):
    """The unit radial direction of a cylindrical face at a point on it, or None for any other face.

    ISurface.IsCylinder / ISurface.CylinderParams (origin xyz, axis xyz, radius). A cylinder's
    IFace2.Normal is not a single vector, so a cylindrical selector is matched by this instead."""
    set_step('GetSurface', 'cylinder_radial')
    surface = entity.GetSurface()
    set_step('IsCylinder', 'cylinder_radial')
    if surface is None or not surface.IsCylinder():
        return None
    set_step('CylinderParams', 'cylinder_radial')
    params = surface.CylinderParams
    if not params or len(params) < 7:
        return None
    origin, direction = (params[0:3], params[3:6])
    length = math.sqrt(sum((c * c for c in direction)))
    if length == 0:
        return None
    unit = [c / length for c in direction]
    offset = [p - o for p, o in zip(point, origin)]
    along = sum((a * b for a, b in zip(offset, unit)))
    radial = [o - along * u for o, u in zip(offset, unit)]
    size = math.sqrt(sum((c * c for c in radial)))
    return [c / size for c in radial] if size > 1e-09 else None

def resolve(doc, selector, cylindrical=False):
    """Search actual body topology; names, selection IDs and traversal order are irrelevant.

    cylindrical=True (a tangent mate's cylinder) matches cylindrical faces only, by the radial
    direction at the point, and ignores the sense of the face: ABS(dot) = 1."""
    hits = []
    part = api_interface(doc, 'PartDoc')
    set_step('GetBodies2', 'resolve')
    for body in part.GetBodies2(0, False) or ():
        if 'face' in selector and cylindrical:
            query = selector['face']
            point = xyz(query['contains'])
            desired = axis(query['normal'])
            set_step('GetFaces', 'resolve')
            for entity in body.GetFaces() or ():
                set_step('GetClosestPointOn', 'resolve')
                close = entity.GetClosestPointOn(*point)
                if not close or math.dist(close[:3], point) > TOL:
                    continue
                radial = cylinder_radial(entity, point)
                if radial and abs(sum((a * b for a, b in zip(radial, desired)))) >= 1 - 1e-06:
                    hits.append(entity)
        elif 'face' in selector:
            query = selector['face']
            point = xyz(query['contains'])
            desired = axis(query['normal'])
            set_step('GetFaces', 'resolve')
            for entity in body.GetFaces() or ():
                set_step('GetClosestPointOn', 'resolve')
                close = entity.GetClosestPointOn(*point)
                set_step('Normal', 'resolve')
                normal = entity.Normal
                if close and normal and (math.dist(close[:3], point) <= TOL) and (math.dist(normal, desired) <= 1e-06):
                    hits.append(entity)
        elif 'edge' in selector:
            query = selector['edge']
            point = xyz(query['through'])
            desired = query.get('tangent') or axis(query['dir'])
            set_step('GetEdges', 'resolve')
            for entity in body.GetEdges() or ():
                set_step('GetClosestPointOn', 'resolve')
                close = entity.GetClosestPointOn(*point)
                if not close or math.dist(close[:3], point) > TOL:
                    continue
                set_step('GetCurve', 'resolve')
                curve = entity.GetCurve()
                set_step('Evaluate2', 'resolve')
                tangent = curve.Evaluate2(close[3], 1)[3:6]
                length = math.sqrt(sum((t * t for t in tangent)))
                if length and abs(sum((a * b for a, b in zip(tangent, desired))) / length) >= 1 - 1e-06:
                    hits.append(entity)
        elif 'vertex' in selector:
            point = xyz(selector['vertex'])
            seen = set()
            set_step('GetEdges', 'resolve')
            for edge in body.GetEdges() or ():
                set_step('GetStartVertex', 'resolve')
                for entity in (edge.GetStartVertex(), edge.GetEndVertex()):
                    set_step('GetPoint', 'resolve')
                    if entity is not None and tuple(entity.GetPoint()) not in seen:
                        set_step('GetPoint', 'resolve')
                        seen.add(tuple(entity.GetPoint()))
                        set_step('GetPoint', 'resolve')
                        if math.dist(entity.GetPoint(), point) <= TOL:
                            hits.append(entity)
    if len(hits) != 1:
        raise RuntimeError('geometric selector matched %d entities%s' % (len(hits), ' (cylindrical faces only)' if cylindrical else ''))
    return hits[0]

def select(doc, entity, append=False, mark=0, topology=True, view=None):
    global call_inputs
    if topology:
        entity = api_interface(entity, 'Entity')
    set_step('CreateSelectData', 'select')
    data = doc.SelectionManager.CreateSelectData()
    set_step('Mark', 'select')
    data.Mark = mark
    if view is not None:
        set_step('View', 'select')
        data.View = view
    modern = topology
    set_step('GetSelectedObjectCount2', 'select')
    before = doc.SelectionManager.GetSelectedObjectCount2(-1) if modern else 0
    try:
        set_step('Select4', 'select')
        selected = entity.Select4(append, data)
    except Exception:
        if not modern:
            raise
        selected = False
    after_select4 = before
    if not selected and modern:
        set_step('GetSelectedObjectCount2', 'select')
        after_select4 = doc.SelectionManager.GetSelectedObjectCount2(-1)
        call_inputs += ' select4=False selected-before=%d after-select4=%d' % (before, after_select4)
        if select4_grew(append, before, after_select4):
            record_mitigation('select4-false-but-selected', primary_failed=True)
            mitigations['select4-false-but-selected']['fallback_ok'] += 1
            selected = True
    if not selected and modern:
        import pythoncom
        from win32com.client import VARIANT
        record_mitigation('select4->multiselect2', primary_failed=True)
        set_step('MultiSelect2', 'select')
        selected = doc.Extension.MultiSelect2(VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, (entity,)), append, data) == 1
        if not selected and append:
            selected = append_count_confirms(doc, before, after_select4)
        if selected:
            mitigations['select4->multiselect2']['fallback_ok'] += 1
    check(selected, 'entity selection failed: append=%s mark=%s' % (append, mark))

def select4_grew(append, before, after):
    """Did a Select4 that returned False select the entity anyway?

    Appending: the selection grew by exactly one. Replacing: only from an empty
    selection to exactly one; otherwise the count cannot tell, so fall back."""
    return after == before + 1 if append else before == 0 and after == 1

def append_count_confirms(doc, before, after_select4=None):
    """An appending MultiSelect2 may report the whole selection count, not 1.

    Field evidence (revision 34.4.0): the first entity (append=False) returned 1,
    every appended second entity failed the "== 1" test. Accept it when the
    selection grew by exactly the one entity since before Select4."""
    global call_inputs
    record_mitigation('multiselect2-append-count', primary_failed=True)
    set_step('GetSelectedObjectCount2', 'append_count_confirms')
    after = doc.SelectionManager.GetSelectedObjectCount2(-1)
    call_inputs += ' selected-before=%d after-select4=%s after=%d' % (before, '-' if after_select4 is None else after_select4, after)
    set_step('MultiSelect2', 'append_count_confirms')
    if after != before + 1:
        return False
    mitigations['multiselect2-append-count']['fallback_ok'] += 1
    return True

def selection_summary(doc):
    """What the feature call saw, for a feature API that returns nothing."""
    global step
    saved = step
    set_step('SelectionManager', 'selection_summary')
    manager = doc.SelectionManager
    set_step('GetSelectedObjectCount2', 'selection_summary')
    summary = ' (selected=%d mark0=%d mark1=%d)' % tuple((manager.GetSelectedObjectCount2(m) for m in (-1, 0, 1)))
    step = saved
    return summary

def selection_detail(doc):
    """Every selected object as a type letter and its mark (E edge, V vertex, S sketch, R ref curve, ? other), for the probe notes."""
    letters = {1: 'E', 3: 'V', 9: 'S', 23: 'R', 22: 'F', 2: 'A'}
    try:
        set_step('SelectionManager', 'selection_detail')
        manager = doc.SelectionManager
        set_step('GetSelectedObjectCount2', 'selection_detail')
        count = manager.GetSelectedObjectCount2(-1)
        shown = []
        for i in range(1, min(count, 6) + 1):
            set_step('GetSelectedObjectType3', 'selection_detail')
            shown.append('%s%d' % (letters.get(manager.GetSelectedObjectType3(i, -1), '?'), manager.GetSelectedObjectMark(i)))
        return 'sel=%d:%s' % (count, ','.join(shown))
    except Exception as exc:
        return 'sel=?%s' % type(exc).__name__

def vertex_text(vertex):
    """A vertex as (x,y,z) in millimeters, for probe notes."""
    try:
        set_step('GetPoint', 'vertex_text')
        return '(%s)mm' % ','.join(('%.1f' % (float(v) * 1000.0) for v in vertex.GetPoint()[:3]))
    except Exception as exc:
        return '?' + type(exc).__name__

def item_kind(item):
    """V when the object has a point (a vertex), E when it has a curve (an edge), else ?."""
    for method, letter in (('GetPoint', 'V'), ('GetCurve', 'E')):
        try:
            getattr(item, method)()
            return letter
        except Exception:
            pass
    return '?'

def newest_feature(doc):
    """The newest feature. A sheet-metal part keeps Flat-Pattern last in the
    tree and inserts new features above it, so skip it."""
    set_step('FeatureByPositionReverse', 'newest_feature')
    feature = doc.FeatureByPositionReverse(0)
    set_step('GetTypeName2', 'newest_feature')
    if feature is not None and feature.GetTypeName2() == 'FlatPattern':
        set_step('FeatureByPositionReverse', 'newest_feature')
        feature = doc.FeatureByPositionReverse(1)
    return feature

def newest_of_type(doc, wanted):
    """The last feature of this type in the tree. In an assembly the Mates folder (MateGroup) is always last, so the newest
    feature is never a plane just inserted (field 2026.11.25.1, A20: the mirror was handed the Mates folder as its plane)."""
    set_step('FirstFeature', 'newest_of_type')
    feature, found = (doc.FirstFeature(), None)
    while feature is not None:
        set_step('GetTypeName2', 'newest_of_type')
        if feature.GetTypeName2() == wanted:
            found = feature
        set_step('GetNextFeature', 'newest_of_type')
        feature = feature.GetNextFeature()
    return found

def find_feature(doc, wanted):
    set_step('FirstFeature', 'find_feature')
    feature = doc.FirstFeature()
    while feature is not None:
        set_step('GetTypeName2', 'find_feature')
        if feature.GetTypeName2() == wanted:
            return feature
        set_step('GetNextFeature', 'find_feature')
        feature = feature.GetNextFeature()
    return None

def solid_bodies(doc):
    set_step('GetBodies2', 'solid_bodies')
    bodies = list(api_interface(doc, 'PartDoc').GetBodies2(swSolidBody, False) or ())
    if not bodies:
        raise RuntimeError('no solid body to check')
    return bodies
LAST_VOLUME = {}

def accurate_volume(doc):
    """mm3, or 0.0 when the route gave nothing. Round 15: IModelDocExtension.CreateMassProperty2() -> IMassProperty2 with AccuracyLevel
    set to the maximum (swMassPropertyAccuracyLevel_Higher = 2; Lower 0, Medium 1) and UseSystemUnits True (Volume in m3). Never fatal.
    https://help.solidworks.com/2025/english/api/sldworksapi/SolidWorks.Interop.sldworks~SolidWorks.Interop.sldworks.IMassProperty2.html"""
    try:
        set_step('CreateMassProperty2', 'accurate_volume')
        properties = doc.Extension.CreateMassProperty2()
        if properties is None:
            return 0.0
        set_step('UseSystemUnits', 'accurate_volume')
        properties.UseSystemUnits = True
        set_step('AccuracyLevel', 'accurate_volume')
        properties.AccuracyLevel = 2
        try:
            set_step('IncludeHiddenBodiesOrComponents', 'accurate_volume')
            properties.IncludeHiddenBodiesOrComponents = True
        except Exception:
            pass
        set_step('Recalculate', 'accurate_volume')
        properties.Recalculate()
        set_step('Volume', 'accurate_volume')
        volume = float(properties.Volume) * 1000000000.0
        return volume if volume > 0 else 0.0
    except Exception as exc:
        LAST_VOLUME['failure'] = safe_error(exc)
        return 0.0

def measured_volume(doc):
    """mm3. The most accurate route first: IMassProperty2 at the highest accuracy level; failing that, IBody2.GetMassProperties
    (index 3 is the volume, m3, of a solid body) summed over the solid bodies. The route and both values go to LAST_VOLUME."""
    set_step('GetMassProperties', 'measured_volume')
    body_sum = sum((float(body.GetMassProperties(1.0)[3]) for body in solid_bodies(doc))) * 1000000000.0
    LAST_VOLUME.clear()
    accurate = accurate_volume(doc)
    route = 'IMassProperty2.AccuracyLevel=2' if accurate > 0 else 'body-sum'
    LAST_VOLUME.update(route=route, value=accurate if accurate > 0 else body_sum, body_sum=body_sum)
    return LAST_VOLUME['value']

def volume_log_text():
    """The run-log line of the last volume measurement."""
    if not LAST_VOLUME:
        return None
    text = 'volume route=%s value=%.6f body-sum=%.6f' % (LAST_VOLUME['route'], LAST_VOLUME['value'], LAST_VOLUME['body_sum'])
    return text + (' (accurate route failed: %s)' % LAST_VOLUME['failure'] if LAST_VOLUME.get('failure') else '')

def measured_center(doc):
    """mm. Volume-weighted center of mass (x, y, z) of all solid bodies: IBody2.GetMassProperties indexes 0-2 are the center (m), 3 the volume."""
    total, weighted = (0.0, [0.0, 0.0, 0.0])
    for body in solid_bodies(doc):
        set_step('GetMassProperties', 'measured_center')
        properties = body.GetMassProperties(1.0)
        volume = float(properties[3])
        total += volume
        for i in range(3):
            weighted[i] += float(properties[i]) * volume
    if total <= 0:
        raise RuntimeError('no volume to take a center of mass of')
    return tuple((w / total * 1000 for w in weighted))

def hem_side_verdict(axis_index, hem_sign, flange_outer, thickness, volume_before, volume_after, com_before, com_after):
    """(ok, text). Which side of the flange the hem's material lies on, from the center of mass before and after.

    The whole body's center moves the same way for either side (the hem is far from the body's centre, so its material pulls the
    centre toward the flange whichever way it folds). The added material's own centroid, (V1*C1 - V0*C0) / (V1 - V0), is compared with
    the flange's mid-plane along the flange normal instead: a hem folded toward +axis lies above it, toward -axis below it."""
    added = volume_after - volume_before
    label = 'XYZ'[axis_index]
    numbers = 'COM (%.4f, %.4f, %.4f) -> (%.4f, %.4f, %.4f) mm, added volume %.4f mm3' % (com_before + com_after + (added,))
    if added < 0.001:
        return (False, 'the hem added no material (%s)' % numbers)
    centroid = (volume_after * com_after[axis_index] - volume_before * com_before[axis_index]) / added
    middle = flange_outer - thickness / 2
    delta = centroid - middle
    text = '%s; added material centroid %s=%.4f vs flange mid-plane %.4f (%+.4f), recipe side %s' % (numbers, label, centroid, middle, delta, '+' if hem_sign > 0 else '-')
    return (delta * hem_sign > 0.001, text)

def measured_extreme(doc, axis_index, sign):
    """mm. The bodies' exact extreme along +/- a world axis (IBody2.GetExtremePoint)."""
    import pythoncom
    from win32com.client import VARIANT
    best = None
    for body in solid_bodies(doc):
        direction = [0.0, 0.0, 0.0]
        direction[axis_index] = float(sign)
        out = [VARIANT(pythoncom.VT_BYREF | pythoncom.VT_R8, 0.0) for _ in range(3)]
        set_step('GetExtremePoint', 'measured_extreme')
        if not body.GetExtremePoint(*direction, *out):
            raise RuntimeError('GetExtremePoint found no point along %s%s' % ('+' if sign > 0 else '-', 'XYZ'[axis_index]))
        value = float(out[axis_index].value) * 1000
        if best is None or value * sign > best * sign:
            best = value
    return best

def sheet_metal_data(doc):
    feature = check(find_feature(doc, 'SheetMetal'), 'no Sheet-Metal feature in the part')
    set_step('GetDefinition', 'sheet_metal_data')
    return check(feature.GetDefinition(), 'Sheet-Metal feature data unavailable')

def flange_bend_override(doc):
    """(radius mm or None, K-factor or None) of the first Edge-Flange that has its own bend radius / bend allowance
    (UseDefaultBendRadius / UseDefaultBendAllowance False), read from the built part; the portal reads the flange's values
    the same way, so the check does too (S02j). (None, None) when every flange uses the Sheet-Metal defaults."""
    feature = find_feature(doc, 'EdgeFlange')
    set_step('GetDefinition', 'flange_bend_override')
    data = None if feature is None else feature.GetDefinition()
    if data is None:
        return (None, None)
    set_step('UseDefaultBendRadius', 'flange_bend_override')
    radius = None if data.UseDefaultBendRadius else float(data.BendRadius) * 1000
    set_step('UseDefaultBendAllowance', 'flange_bend_override')
    allowance = None if data.UseDefaultBendAllowance else data.GetCustomBendAllowance()
    return (radius, allowance)

def verify_expect(doc, expect):
    """Fail the recipe unless the built part matches expect.json; return what was measured."""
    failures, report = ([], [])
    if 'volume' in expect:
        measured, expected = (measured_volume(doc), float(expect['volume']))
        tolerance = max(0.05, 0.0001 * abs(expected))
        report.append('volume=%.4f' % measured)
        if abs(measured - expected) > tolerance:
            failures.append('volume %.4f mm3, expected %.2f (tolerance %.3g)' % (measured, expected, tolerance))
    if 'bbox' in expect:
        for side, sign in ((0, -1), (1, 1)):
            for axis_index in range(3):
                expected = expect['bbox'][side][axis_index]
                if expected is None:
                    continue
                measured = measured_extreme(doc, axis_index, sign)
                label = ('min ' if sign < 0 else 'max ') + 'XYZ'[axis_index]
                report.append('%s=%.4f' % (label.replace(' ', ''), measured))
                if abs(measured - expected) > 0.01:
                    failures.append('bbox %s %.4f mm, expected %g' % (label, measured, expected))
    if 'size' in expect:
        for axis_index, expected in enumerate(expect['size']):
            if expected is None:
                continue
            measured = measured_extreme(doc, axis_index, 1) - measured_extreme(doc, axis_index, -1)
            report.append('size%s=%.4f' % ('XYZ'[axis_index], measured))
            if abs(measured - expected) > 0.01:
                failures.append('size %s %.4f mm, expected %g' % ('XYZ'[axis_index], measured, expected))
    if 'solidworks_sheet' in expect:
        data = sheet_metal_data(doc)
        for key, expected in sorted(expect['solidworks_sheet'].items()):
            if key == 'thickness':
                set_step('Thickness', 'verify_expect')
                measured = float(data.Thickness) * 1000
            elif key == 'bend_radius':
                flange_radius, _ = flange_bend_override(doc)
                set_step('BendRadius', 'verify_expect')
                measured = float(data.BendRadius) * 1000 if flange_radius is None else flange_radius
            elif key == 'k_factor':
                _, flange_allowance = flange_bend_override(doc)
                set_step('GetCustomBendAllowance', 'verify_expect')
                allowance = flange_allowance or check(data.GetCustomBendAllowance(), 'Sheet-Metal bend allowance unavailable')
                set_step('Type', 'verify_expect')
                if allowance.Type != swBendAllowanceKFactor:
                    set_step('Type', 'verify_expect')
                    failures.append('bend allowance type %s, expected K-factor (%d)' % (allowance.Type, swBendAllowanceKFactor))
                set_step('KFactor', 'verify_expect')
                measured = float(allowance.KFactor)
            else:
                continue
            report.append('%s=%.6g' % (key, measured))
            if abs(measured - expected) > 0.0001:
                failures.append('sheet %s %.6g, expected %g' % (key, measured, expected))
    if failures:
        raise RuntimeError('result differs from expect.json: ' + '; '.join(failures))
    return ' '.join(report)
CHILD_ROUTES = ('GetChildren of the instance from the build', 'GetChildren of the top-level instance found again by name', 'GetComponentByName with the path form', "the top assembly's component tree")

def log_line(folder, label, text):
    entry = dict(time=time.strftime('%Y-%m-%dT%H:%M:%S%z'), builder=BUILDER_VERSION, recipe=current_identity, step=label, Erl=0, **{'Err.Number': 0, 'Err.Description': scrub_text(text)})
    with (folder / 'FixtureBuilder.log').open('a', encoding='utf-8') as stream:
        stream.write(dump_json(entry) + '\n')

def finish_message(rows, zip_path, zip_made=True, folder=None):
    """The outcome and the next step, in plain words. If the zip could not be made, the person is told to zip the folder by hand."""

    def count(status):
        return sum((1 for row in rows if row['status'] == status))
    earlier = count('skipped_built')
    counts = '%d recipe%s: %d built, %d failed, %d not scripted%s (details in FixtureBuilder.log).' % (len(rows), '' if len(rows) == 1 else 's', count('ok'), count('failed'), count('not_scripted'), ', %d already built in an earlier run' % earlier if earlier else '')
    counts += emptied_line()
    if sweep_failed:
        return counts + '\nThe zip was not made because the output folder could not be checked; nothing was sent.'
    if zip_made:
        return counts + '\nNext: send this zip to Dutchy in a Discord direct message:\n' + str(zip_path)
    return counts + '\nThe zip could not be made (the reason is in FixtureBuilder.log and %s-zip-error.txt).\nNext: right-click this folder, choose Send to > Compressed (zipped) folder, and send that zip to Dutchy in a Discord direct message:\n%s' % (folder, folder)

def emptied_line():
    """'' unless the sweep had to empty or delete a text file it could not clean: then the volunteer is told the zip is incomplete."""
    if not emptied_files:
        return ''
    return '\n%d file(s) could not be cleaned and were emptied: %s' % (len(emptied_files), ', '.join(emptied_files))

def zip_ready(archive):
    """The zip exists and holds something (an empty zip is 22 bytes)."""
    try:
        return pathlib.Path(archive).is_file() and pathlib.Path(archive).stat().st_size > 22
    except OSError:
        return False

def make_zip(app, folder, results, archive):
    """The run's zip, checked by looking for the file. An old zip or error file of the same name (a manual Send to, an earlier run) is deleted first and
    before every attempt, so it never counts and is never shown; an attempt that fails part way deletes its partial zip. A second try after closing
    every document (zip-verify-retry, its error text kept in <folder>-zip-error.txt), then a stored (uncompressed) zip (zip-shell-application, the
    macro's Shell.Application route). Counted in a `mitigations:` line of its own (the recipes' lines are written before the zip). Never raises."""
    names = list(dict.fromkeys(['results.json'] + [n for r in results for n in r['files']]))
    if (folder / 'FixtureBuilder.log').exists():
        names.append('FixtureBuilder.log')
    error_file = folder.parent / (folder.name + '-zip-error.txt')
    counts = {}

    def count(name, primary_failed=False, ok=False):
        entry = counts.setdefault(name, dict(count=0, primary_failed=0, fallback_ok=0))
        entry['count'] += 0 if ok else 1
        entry['primary_failed'] += 1 if primary_failed else 0
        entry['fallback_ok'] += 1 if ok else 0

    def remove_old():
        for old in (archive, error_file):
            try:
                pathlib.Path(old).unlink()
            except OSError:
                pass

    def attempt(method):
        remove_old()
        try:
            with zipfile.ZipFile(archive, 'w', method) as bundle:
                for name in names:
                    bundle.write(folder / name, folder.name + '/' + name)
        except Exception as exc:
            try:
                pathlib.Path(archive).unlink()
            except OSError:
                pass
            try:
                error_file.write_text(safe_error(exc), encoding='ascii', errors='replace')
            except Exception:
                pass
            return False
        return zip_ready(archive)

    def error_head():
        try:
            return scrub_text(' '.join(error_file.read_text(encoding='ascii', errors='replace').split()))[:300] or 'no error text'
        except Exception:
            return 'no error text'

    def finish(made):
        if counts:
            log_line(folder, 'zip', 'mitigations: ' + ' '.join(('%s=%d,primary-failed=%d,fallback-ok=%d' % (n, c['count'], c['primary_failed'], c['fallback_ok']) for n, c in counts.items())))
        return made
    remove_old()
    if attempt(zipfile.ZIP_DEFLATED):
        return True
    log_line(folder, 'zip', 'zip: no zip was written; ' + error_head())
    count('zip-verify-retry', primary_failed=True)
    try:
        set_step('CloseAllDocuments', 'make_zip')
        app.CloseAllDocuments(True)
    except Exception:
        pass
    if attempt(zipfile.ZIP_DEFLATED):
        count('zip-verify-retry', ok=True)
        log_line(folder, 'zip', 'zip-verify-retry: the second attempt wrote the zip')
        return finish(True)
    log_line(folder, 'zip', 'zip-verify-retry: still no zip; ' + error_head())
    count('zip-shell-application', primary_failed=True)
    if attempt(zipfile.ZIP_STORED):
        count('zip-shell-application', ok=True)
        log_line(folder, 'zip', 'zip-shell-application: the stored zip was written')
        return finish(True)
    log_line(folder, 'zip', 'zip-shell-application: no zip either; the folder is complete, the person zips it by hand')
    return finish(False)

def unattended():
    """No person is watching: FIXTURE_UNATTENDED=1, or output that is not a console."""
    if os.environ.get('FIXTURE_UNATTENDED', '').strip() == '1':
        return True
    try:
        return not sys.stdout.isatty()
    except Exception:
        return True

def reveal_file(path):
    """Select the file in Explorer. Never raises, never waits."""
    try:
        import subprocess
        set_step('Popen', 'reveal_file')
        subprocess.Popen(['explorer', '/select,' + str(path)])
    except Exception:
        pass

def operation(op):
    return op.get('operation', op.get('op_type', op.get('boolean', op.get('op', 'new'))))
DRAWINGS_PACKAGE_IDS = frozenset(('D%da' % n for n in range(10, 20)))
DRAWINGS_PACKAGE_REASON = 'made by the drawings package (FixtureDrawings.bas)'

def preflight(design):
    if design.get('id') in DRAWINGS_PACKAGE_IDS:
        raise NotScripted(DRAWINGS_PACKAGE_REASON)
    if not design['scripted']:
        raise NotScripted(design['why_not'] or 'recipe marked not scripted')
    for position, op in enumerate(design['ops']):
        kind = op['kind']
        if kind == 'sheetmetal':
            sheetmetal_preflight(op, design['ops'][:position])
        if kind == 'drawing':
            drawing_preflight(op, design)
        if kind not in SUPPORTED:
            reason = {'thread': 'thread: thread-profile library and cosmetic thread callout adapter are not implemented', 'assembly': 'assembly: component document loading, scoped topology and mate solver adapter are not implemented'}
            raise NotScripted(reason.get(kind, kind + ': SolidWorks 2018 adapter is not implemented'))

        def inspect(value):
            if isinstance(value, dict):
                if ('edge' in value or 'face' in value) and ('body' in value or ('component' in value and kind != 'assembly')):
                    raise NotScripted('scoped geometric selectors are not implemented')
                if 'edge' in value and 'tangent' in value['edge'] and (kind != 'assembly'):
                    raise NotScripted('nonaxial edge tangent selectors are not implemented')
                for item in value.values():
                    inspect(item)
            elif isinstance(value, list):
                for item in value:
                    inspect(item)
        inspect(op)
        if kind == 'assembly':
            if 'subassembly' in op:
                sub = op['subassembly']
                if not re.fullmatch('[A-Za-z0-9_-]+', str(sub.get('file', ''))) or not sub.get('ops'):
                    raise NotScripted('assembly subassembly: needs a plain file name and its own ops')
                for inner in sub['ops']:
                    if inner.get('kind') != 'assembly' or not any((k in inner for k in ('insert', 'subassembly', 'component', 'constraint'))):
                        raise NotScripted('assembly subassembly: only component inserts, grounding and mates are implemented inside one')
                    if 'subassembly' in inner:
                        raise NotScripted('assembly subassembly: a subassembly is built by its own top-level op, not inside another')
                    preflight(dict(design, ops=[inner]))
            elif 'insert' in op:
                insertion = op['insert']
                if 'recipe' not in insertion and 'assembly' not in insertion:
                    raise NotScripted('assembly insert: only packaged recipe components are implemented')
                if insertion.get('config') is not None and (not re.fullmatch('[A-Za-z0-9 _-]+', str(insertion['config']))):
                    raise NotScripted('assembly insert: a configuration name is letters, digits, space, _ and -')
                position = insertion.get('at', 'default')
                if isinstance(position, str) and position not in ('default', 'off_to_side_default'):
                    raise NotScripted('assembly insert: unsupported component placement')
                if any((t.get('axis') not in ('X', 'Y', 'Z') or not isinstance(t.get('deg'), (int, float)) for t in insertion.get('turn', []))):
                    raise NotScripted('assembly insert: a turn needs a world axis X, Y or Z and an angle in degrees')
            elif 'mate' in op and 'suppressed' in op:
                pass
            elif 'mirror' in op:
                mirror = op['mirror']
                if mirror.get('mode', 'instance') not in ('instance', 'new_part') or mirror.get('plane', {}).get('normal') not in ('X', 'Y', 'Z') or (not isinstance(mirror['plane'].get('offset'), (int, float))):
                    raise NotScripted('assembly mirror: the plane is a world axis normal and an offset, the mode instance or new_part')
                if 'corner' not in mirror:
                    raise NotScripted('assembly mirror: only the part P04a has a rounded corner to check the mirror by')
                if mirror.get('mode') == 'new_part' and (not re.fullmatch('[A-Za-z0-9_-]+', str(mirror.get('part', '')))):
                    raise NotScripted('assembly mirror: a new mirrored part needs a plain file name')
            elif 'make_virtual' in op:
                if not op['make_virtual'] or 'component' not in op:
                    raise NotScripted('assembly make_virtual: names the component to make virtual')
            elif 'copy_part' in op or 'part_configuration' in op:
                p = op.get('copy_part') or op['part_configuration']
                if not re.fullmatch('[A-Za-z0-9_-]+', str(p.get('file', ''))) or p.get('recipe') not in ('P01a', 'P01b'):
                    raise NotScripted('assembly part copy: only the box parts P01a and P01b have a depth to edit')
                if 'part_configuration' in op and (not all((isinstance(p.get(k), (int, float)) for k in ('height', 'original')))):
                    raise NotScripted("assembly part_configuration: needs the configuration height and the part's own depth")
            elif 'source_edit' in op:
                if not all((isinstance(op['source_edit'].get(k), (int, float)) for k in ('height', 'original'))) or not op.get('update_references'):
                    raise NotScripted('assembly source_edit: the part becomes another box part and the references are updated')
            elif 'move' in op:
                if len(op['move'].get('by', ())) != 3 or '/' not in str(op['move'].get('component')):
                    raise NotScripted('assembly move: a part of a subassembly (path a/b) and a vector of three numbers')
            elif 'constraint' in op and op['constraint']['type'] in ('coincident', 'distance', 'limit_angle'):
                constraint = op['constraint']
                for key in ('a', 'b'):
                    selector = constraint[key]
                    if not any((k in selector for k in ('face', 'plane', 'origin'))):
                        raise NotScripted('assembly ' + constraint['type'] + ': a selector is a face, a default plane or an origin point')
                if constraint['type'] == 'limit_angle' and (not all((k in constraint for k in ('value', 'min', 'max')))):
                    raise NotScripted('assembly limit_angle: needs value, min and max')
                if constraint['type'] == 'distance' and 'value' not in constraint:
                    raise NotScripted('assembly distance: needs a value')
            elif 'constraint' in op:
                if op['constraint']['type'] not in ('mate', 'flush', 'angle', 'insert', 'tangent'):
                    raise NotScripted('assembly constraint: type ' + str(op['constraint']['type']) + ' is not implemented')
                if any(('component' not in op['constraint'][k] for k in ('a', 'b'))):
                    raise NotScripted('assembly constraint: requires two component-scoped selectors')
                if op['constraint']['type'] == 'tangent':
                    constraint = op['constraint']
                    if constraint.get('solution', 'outside') not in ('outside', 'inside'):
                        raise NotScripted('assembly tangent: solution must be outside or inside, got ' + repr(constraint.get('solution')))
                    if any(('face' not in constraint[k] for k in ('a', 'b'))):
                        raise NotScripted('assembly tangent: both selectors must be faces (a cylindrical face and a planar face)')
                    if constraint['a']['component'] == constraint['b']['component']:
                        raise NotScripted('assembly tangent: the two faces must be on different components')
                    if not re.fullmatch('[+-]?[XYZ]', str(constraint['b']['face'].get('normal'))):
                        raise NotScripted('assembly tangent: the planar face (b) needs a world-axis normal')
            elif 'pattern' in op:
                pattern = op['pattern']
                if 'circular' in pattern:
                    circle = pattern['circular']
                    if circle.get('axis') not in ('X', 'Y', 'Z') or not isinstance(circle.get('count'), int) or circle['count'] < 2 or (not isinstance(circle.get('angle'), (int, float))) or (not circle.get('rotate', True)):
                        raise NotScripted('assembly pattern: a circular component pattern needs a world axis, a count of 2 or more, an angle, and instances that turn with it')
                elif 'dir1' not in pattern or any((pattern[k].get('axis') not in ('X', 'Y', 'Z', '-X', '-Y', '-Z') for k in ('dir1', 'dir2') if k in pattern)):
                    raise NotScripted('assembly pattern: only rectangular world-axis patterns are implemented')
            elif not ('component' in op and any((k in op for k in ('grounded', 'visible', 'suppressed', 'flexible')))):
                raise NotScripted('assembly: unsupported component state action')
        if kind == 'app_specific':
            if op.get('app') == 'solidworks' and op.get('op') == 'parameter':
                params = op.get('params', {})
                if not re.fullmatch('[A-Za-z_][A-Za-z0-9_]*', str(params.get('name', ''))) or not isinstance(params.get('value'), (int, float)) or params.get('units', 'mm') != 'mm':
                    raise NotScripted('parameter: needs an identifier name, a numeric value and units mm (a global variable)')
            elif op.get('app') != 'solidworks' or op.get('op') not in ('sketch3d', 'work_plane', 'mirror', 'appearance', 'configuration', 'display_state', 'helix_spiral', 'plane_normal_to_curve'):
                raise NotScripted('app_specific ' + op.get('op', 'unknown') + ': native feature/state adapter is not implemented')
            if op['op'] in ('configuration', 'display_state'):
                state_preflight(op, design['ops'][:position])
            if op['op'] == 'appearance':
                if op['params'].get('color') not in ('red', 'green', 'blue'):
                    raise NotScripted('appearance: only explicit red, green and blue colors are implemented')
            if op['op'] == 'sketch3d':
                if any((e.get('type') not in ('line', 'point') for e in op['params']['entities'])):
                    raise NotScripted('sketch3d: only line and point entities are implemented')
            if op['op'] in ('work_plane', 'mirror'):
                plane_parameters(op['params'].get('plane', 'XY'))
            if op['op'] in ('helix_spiral', 'plane_normal_to_curve'):
                helix_preflight(op, design['ops'][:position])
        if kind == 'hole':
            if not all((k in op for k in ('at', 'on_face', 'hole_type', 'dia'))):
                raise NotScripted('hole: requires explicit positions, planar support face, type and diameter')
            if op['hole_type'] not in ('simple', 'counterbore', 'countersink'):
                raise NotScripted('hole: unsupported Hole Wizard subtype ' + op['hole_type'])
            if op.get('to_face') or not (op.get('through_all') or 'depth' in op):
                raise NotScripted('hole: only blind and through-all end conditions are implemented')
            if op.get('tip', 'flat') not in ('flat', 'angle'):
                raise NotScripted('hole: unsupported drill tip')
        if kind == 'fillet_variable':
            if not all((k in op for k in ('edge', 'r_start', 'r_end'))):
                raise NotScripted('fillet_variable: requires an edge and two endpoint radii')
            if op.get('intermediate_points'):
                raise NotScripted('fillet_variable: intermediate control-point references are not implemented')
            if op.get('transition', 'default') not in ('default', 'smooth', 'straight'):
                raise NotScripted('fillet_variable: unsupported transition type')
        if kind in ('pattern_rect', 'pattern_circ'):
            if 'feature' not in op:
                raise NotScripted(kind + ': requires a named seed feature')
            directions = [op[k] for k in ('dir1', 'dir2') if k in op] if kind == 'pattern_rect' else [op]
            if not directions or any((d.get('axis') not in ('X', 'Y', 'Z', '-X', '-Y', '-Z') for d in directions)):
                raise NotScripted(kind + ': only world-axis directions are implemented')
        driven = [key for key in op if key.endswith('_expression')]
        if driven:
            allowed = {'sketch': 'width_expression', 'extrude': 'distance_expression'}
            names = {o['params']['name'] for o in design['ops'][:position] if o['kind'] == 'app_specific' and o.get('op') == 'parameter'}
            for key in driven:
                if allowed.get(kind) != key:
                    raise NotScripted(kind + ' ' + key + ': only width_expression on a rectangle sketch and distance_expression on an extrude are implemented (IEquationMgr)')
                expression_value(op[key], {n: 1.0 for n in names}, NotScripted)
            if kind == 'sketch' and (not op.get('dims', True) or not any((e.get('type', e.get('kind', next(iter(e), ''))) in ('rect_center', 'rect_2pt') for e in op.get('entities', [])))):
                raise NotScripted('sketch width_expression: needs a dimensioned rectangle (its width dimension is driven)')
            if kind == 'extrude' and op.get('extent', 'distance') != 'distance':
                raise NotScripted('extrude distance_expression: needs a blind distance')
        if kind in ('extrude', 'revolve') and operation(op) == 'intersect':
            raise NotScripted('intersection feature operation is not implemented')
        if kind == 'extrude' and op.get('direction') == 'two_sides':
            raise NotScripted('independent two-sided extrusion distances are not implemented')
        if kind == 'fillet' and 'groups' in op:
            raise NotScripted('multiple fillet radius groups are not implemented')
        if kind == 'sketch':
            plane_parameters(op.get('plane', 'XY'))
            if op.get('on_plane') or op.get('pierce'):
                helix_sketch_preflight(op, design['ops'][:position])
            for ent in op.get('entities', []):
                typ = ent.get('type', ent.get('kind', next(iter(ent), '')))
                if typ not in ('rect_center', 'rect_2pt', 'circle', 'line', 'point', 'arc'):
                    raise NotScripted('unsupported sketch entity: ' + typ)
                if typ == 'arc':
                    arc_middle(ent.get(typ, ent))
        if kind == 'extrude' and op.get('extent', 'distance') not in ('distance', 'through_all'):
            raise NotScripted('extrude to_face requires an end-condition reference adapter')
        if kind == 'chamfer' and op.get('ref_face'):
            ref = op['ref_face'].get('face', {})
            if op.get('mode') != 'distance_angle':
                raise NotScripted('chamfer ref_face is only implemented for the distance_angle mode, not ' + str(op.get('mode')))
            if 'contains' not in ref or 'normal' not in ref or 'through' not in op['edge'].get('edge', {}):
                raise NotScripted('chamfer ref_face: needs a face {contains, normal} and an edge {through, dir}')
            face_normal, edge_direction = (axis(ref['normal']), axis(op['edge']['edge']['dir']))
            offset = [a - b for a, b in zip(op['edge']['edge']['through'], ref['contains'])]
            if abs(sum((n * o for n, o in zip(face_normal, offset)))) > 1e-09 or sum((n * d for n, d in zip(face_normal, edge_direction))) != 0:
                raise NotScripted('chamfer ref_face: the reference face does not contain the chamfer edge')
        if kind == 'revolve' and op.get('axis', 'Z') not in ('X', 'Y', 'Z'):
            raise NotScripted('revolve reference axis must be a world axis')
        if kind in ('extrude', 'revolve', 'sweep', 'loft'):
            refs = op.get('profiles', [op.get('profile', 'last'), op.get('path', 'last')])
            if any((isinstance(r, (dict, list)) for r in refs)):
                raise NotScripted('explicit sketch-region references require a contour adapter')

def named_op(previous, name, op_name):
    """The earlier app_specific op of that kind with params.name == name, or None."""
    return next((o for o in previous if o['kind'] == 'app_specific' and o.get('op') == op_name and (o.get('params', {}).get('name') == name)), None)

def helix_preflight(op, previous):
    """helix_spiral and plane_normal_to_curve: every reference is an earlier op and the geometry is one this adapter builds."""
    params = op.get('params', {})
    if not re.fullmatch('[A-Za-z_][A-Za-z0-9_]*', str(params.get('name', ''))):
        raise NotScripted(op['op'] + ': needs an identifier name')
    if op['op'] == 'helix_spiral':
        helix_plan(params)
        source = next((o for o in previous if o['kind'] == 'sketch' and o.get('name') == params.get('sketch')), None)
        if source is None:
            raise NotScripted('helix_spiral: the sketch ' + repr(params.get('sketch')) + ' is not an earlier sketch')
        base = plane_parameters(source.get('plane', 'XY'))[0] if not source.get('on_face') and (not source.get('three_d')) and (not source.get('on_plane')) else None
        circles = [e for e in source.get('entities', []) if e.get('type', e.get('kind', next(iter(e), ''))) == 'circle']
        if base is None or len(circles) != 1 or len(source.get('entities', [])) != 1:
            raise NotScripted('helix_spiral: the sketch must be one circle on a default plane')
        if params.get('axis') != 'XYZ'[PLANE_NORMAL[base]]:
            raise NotScripted('helix_spiral: the axis of a helix is the normal of its sketch plane (%s for %s), not %s' % ('XYZ'[PLANE_NORMAL[base]], base, params.get('axis')))
        return
    if named_op(previous, params.get('curve'), 'helix_spiral') is None:
        raise NotScripted('plane_normal_to_curve: the curve ' + repr(params.get('curve')) + ' is not an earlier helix_spiral')
    start = params.get('start_point')
    if params.get('at') != 'start' or not isinstance(start, list) or len(start) != 3 or any((not isinstance(v, (int, float)) or isinstance(v, bool) for v in start)):
        raise NotScripted('plane_normal_to_curve: only at start with an explicit start_point [x, y, z] is implemented')

def helix_sketch_preflight(op, previous):
    """A circle sketched on the plane normal to a helix, optionally with a Pierce relation to that helix."""
    if op.get('on_plane') and (named_op(previous, op['on_plane'], 'plane_normal_to_curve') is None or op.get('on_face') or op.get('three_d')):
        raise NotScripted('sketch on_plane: ' + repr(op['on_plane']) + ' is not an earlier plane_normal_to_curve')
    if op.get('pierce') and (not op.get('on_plane') or named_op(previous, op['pierce'], 'helix_spiral') is None):
        raise NotScripted('sketch pierce: needs on_plane and an earlier helix_spiral')
    if op.get('on_plane') and any((e.get('type', e.get('kind', next(iter(e), ''))) != 'circle' for e in op.get('entities', []))):
        raise NotScripted('sketch on_plane: only circles are implemented')
SHEET_FLANGE_KEYS = {'edges', 'height', 'angle', 'direction', 'height_datum', 'bend_position', 'bend_radius', 'corner_relief', 'corner_relief_size', 'corner_gap', 'width_type', 'offset', 'width', 'from_corner', 'offset1', 'offset2', 'bend_relief', 'bend_relief_width', 'bend_relief_depth', 'k_factor'}
CORNER_RELIEF = {'round': swCornerCircularRelief, 'square': swCornerSquareRelief, 'tear': swCornerTearRelief}
SHEET_BASE_KEYS = {'thickness', 'bend_radius', 'k_factor', 'corner_relief', 'corner_relief_size', 'corner_gap', 'bend_relief', 'direction', 'profile'}
PLANE_NORMAL = {'XY': 2, 'XZ': 1, 'YZ': 0}

def signed_axis(value):
    """'+Z' -> (2, 1); '-Y' -> (1, -1)."""
    if not isinstance(value, str) or value.lstrip('+-') not in ('X', 'Y', 'Z'):
        raise NotScripted('sheetmetal: direction must be a world axis, got ' + repr(value))
    return ('XYZ'.index(value[-1]), -1 if value.startswith('-') else 1)

def version_gate(design):
    """(minimum revision major, reason) when a design needs a newer SolidWorks than the
    2018 baseline, else None. The multi-edge corner relief feature data is 2022+ (major 30)."""
    for op in design['ops']:
        if op['kind'] == 'sheetmetal' and op.get('action') == 'flange' and (len(op.get('app', {}).get('edges', ())) > 1):
            return (30, 'sheetmetal flange on several edges: the Corner Relief feature (ICornerReliefFeatureData) needs SolidWorks 2022 (revision 30) or newer; this is revision ')
    return None
DRAWING_VIEWS = ({'type': 'base', 'orientation': 'show_L', 'scale': '1:1'}, {'type': 'projected', 'direction': 'vertical'}, {'type': 'projected', 'direction': 'beside'})
DRAWING_VIEW_POSITIONS = {'base': (0.08, 0.15), 'vertical': (0.08, 0.09), 'beside': (0.16, 0.15)}
DRAWING_TEXT_STEP = 0.012

def drawing_preflight(op, design):
    """D05a: the sheet, the three views, the four linear dimensions and the DXF, exactly as the recipe
    describes them; anything else is a precise NotScripted, never a drawing with fewer parts."""
    if len(design['ops']) != 1:
        raise NotScripted('drawing: the recipe must be a single drawing op, got %d ops' % len(design['ops']))
    model = next((d for d in DESIGNS if d['id'] == op.get('model')), None)
    if model is None or not model['scripted']:
        raise NotScripted('drawing: the model ' + repr(op.get('model')) + ' is not a scripted recipe of this builder')
    bbox = (model.get('expect') or {}).get('bbox')
    if not bbox or any((not isinstance(v, (int, float)) for row in bbox for v in row)):
        raise NotScripted('drawing: ' + str(op['model']) + ' has no complete bounding box in its expect.json; the drawing views are checked against it')
    if op.get('template') != 'default_metric' or op.get('title_block', 'default') != 'default':
        raise NotScripted('drawing: only the default drawing template and its default title block are implemented, got ' + repr(op.get('template')) + ' / ' + repr(op.get('title_block')))
    if list(op.get('views') or []) != list(DRAWING_VIEWS):
        raise NotScripted('drawing views: only a base view that shows the L at 1:1 with a vertical and a beside projected view are implemented, got ' + json.dumps(op.get('views'), sort_keys=True))
    dimensions = op.get('dimensions') or []
    if not op.get('dims') or not dimensions:
        raise NotScripted('drawing: the recipe asks for dimensions and lists none')
    for dimension in dimensions:
        between = dimension.get('between') or []
        if dimension.get('type') != 'linear' or not isinstance(dimension.get('value'), (int, float)) or dimension['value'] <= 0 or (len(between) != 2) or any((len(point) != 3 or not all((isinstance(v, (int, float)) for v in point)) for point in between)):
            raise NotScripted('drawing dimension: only linear dimensions with a positive value between two [x, y, z] points are implemented, got ' + json.dumps(dimension, sort_keys=True))
        for point in between:
            if any((not bbox[0][i] <= point[i] <= bbox[1][i] for i in range(3))):
                raise NotScripted('drawing dimension ' + str(dimension['value']) + ': the point ' + str(point) + ' is outside the model box ' + str(bbox))
    if (op.get('export') or {}).get('format') != 'DXF':
        raise NotScripted('drawing export: only DXF is implemented, got ' + repr((op.get('export') or {}).get('format')))

def base_flange_plane(previous):
    """Plane and offset (mm) of the sketch a base flange uses as its profile."""
    sketches = [o for o in previous if o['kind'] == 'sketch']
    if not sketches or sketches[-1].get('on_face') or sketches[-1].get('three_d'):
        raise NotScripted('sheetmetal base_flange: the profile must be the last sketch, on a principal or offset plane')
    return plane_parameters(sketches[-1].get('plane', 'XY'))

def sheetmetal_preflight(op, previous):
    action = op.get('action')
    p = op.get('app', {})
    if action == 'base_flange':
        extra = set(p) - SHEET_BASE_KEYS
        if extra:
            raise NotScripted('sheetmetal base_flange option mapping is not implemented: ' + ', '.join(sorted(extra)))
        if p.get('profile', 'last') != 'last' or p.get('bend_relief', 'default') != 'default':
            raise NotScripted('sheetmetal base_flange: only the last sketch and the default bend relief are implemented')
        plane, _ = base_flange_plane(previous)
        axis_index, _ = signed_axis(p.get('direction', '+Z'))
        if axis_index != PLANE_NORMAL[plane]:
            raise NotScripted('sheetmetal base_flange: thickness direction must be normal to the sketch plane')
        return
    if not any((o['kind'] == 'sheetmetal' and o.get('action') == 'base_flange' for o in previous)):
        raise NotScripted('sheetmetal ' + str(action) + ': needs a preceding base flange')
    if action == 'flange':
        if 'bend_transition' in p:
            raise NotScripted('skipped in SolidWorks, no file needed (its Edge Flange has no Bend Transition; Tangent To Bend is a flange position, S02e): sheetmetal flange bend transition: IEdgeFlangeFeatureData has no bend-transition member (read from the interop: 26 members in sldworks 25.5.0 / SolidWorks 2017, 30 in 32.1.0 / 2024; the four added in 2024 are AngleReference, LockAngle, PerpendicularToFace and NormalToFlangePlane, and none is a bend transition; the others cover relief type, ratio, width and depth only); not mapped')
        extra = set(p) - SHEET_FLANGE_KEYS
        if extra:
            raise NotScripted('sheetmetal flange option mapping is not implemented: ' + ', '.join(sorted(extra)))
        if len(p['edges']) != 1:
            if p.get('width_type', 'full') != 'full':
                raise NotScripted('sheetmetal flange on several edges: part-width flanges with corner relief are not implemented')
            if p.get('corner_relief') not in CORNER_RELIEF:
                raise NotScripted('sheetmetal flange on several edges: corner relief shape ' + str(p.get('corner_relief')) + ' is not implemented')
            for key in ('corner_relief_size', 'corner_gap'):
                if not isinstance(p.get(key), (int, float)) or p[key] < 0:
                    raise NotScripted('sheetmetal flange on several edges: ' + key + ' must be a number, got ' + repr(p.get(key)))
        for key in ('bend_radius', 'k_factor'):
            if key in p and (not (isinstance(p[key], (int, float)) and (not isinstance(p[key], bool)) and (p[key] > 0))):
                raise NotScripted('sheetmetal flange ' + key + ' must be a positive number, got ' + repr(p[key]))
        if 'k_factor' in p and p['k_factor'] >= 1:
            raise NotScripted('sheetmetal flange k_factor must be below 1, got ' + repr(p['k_factor']))
        if p.get('height_datum', 'default') not in ('default', 'alternative_default_record_option'):
            raise NotScripted('sheetmetal flange height datum ' + str(p.get('height_datum')))
        if p.get('bend_position', 'default') not in ('default', 'alternative_default_record_option'):
            raise NotScripted('sheetmetal flange bend position ' + str(p.get('bend_position')))
        if p.get('bend_relief', 'default') not in ('default', 'round', 'straight'):
            raise NotScripted('sheetmetal flange bend relief shape ' + str(p.get('bend_relief')))
        for key in ('bend_relief_width', 'bend_relief_depth'):
            if not (p.get(key, 'default') == 'default' or isinstance(p.get(key), (int, float))):
                raise NotScripted('sheetmetal flange ' + key + ' ' + str(p.get(key)))
        if p.get('width_type', 'full') not in ('full', 'width', 'offset'):
            raise NotScripted('sheetmetal flange width type ' + str(p.get('width_type')))
        if p.get('width_type') == 'width' and 'from_corner' not in p:
            raise NotScripted('sheetmetal flange width: needs the corner the offset is measured from')
        if not 0 < p['angle'] < 180:
            raise NotScripted('sheetmetal flange angle must be between 0 and 180 degrees')
        signed_axis(p.get('direction', '+Z'))
        return
    if action == 'hem':
        if p.get('hem_type') == 'double':
            raise NotScripted('skipped in SolidWorks, no file needed (booklet 1.64: SolidWorks has no Double hem type)')
        if p.get('hem_type') != 'single':
            raise NotScripted('sheetmetal hem ' + str(p.get('hem_type')) + ': CreateDefinition has no hem to create (swFeatureNameID_e has no hem member: its values end at swFmCrossBreak = 86 in swconst 25.5.0 / SolidWorks 2017 and swFmMateController = 127 in 32.1.0 / 2024; swFmBaseFlange = 34 and swFmEdgeFlange = 37 are there, none is a hem), so there is no way to get the PropertyManager defaults the recipe leaves "as they come". IHemFeatureData exists in both but only as the data of a hem that is already built (IFeature.GetDefinition). The one creation call, InsertSheetMetalHem2, needs explicit length, gap, angle and radius; not guessed')
        if not all((isinstance(p.get(k), (int, float)) for k in ('gap', 'length'))):
            raise NotScripted('sheetmetal hem: needs a numeric gap and length')
        if not any((o['kind'] == 'sheetmetal' and o.get('action') == 'flange' for o in previous)):
            raise NotScripted('sheetmetal hem: needs a preceding flange')
        signed_axis(p.get('direction'))
        return
    if action == 'corner_round':
        if not p.get('corners') or not isinstance(p.get('r'), (int, float)):
            raise NotScripted('sheetmetal corner_round: needs corner points and a radius')
        return
    if action == 'flat_pattern':
        if p.get('save_state', 'folded') != 'folded':
            raise NotScripted('sheetmetal flat pattern saved unfolded: not implemented')
        return
    raise NotScripted('sheetmetal ' + str(action) + ': SolidWorks adapter is not implemented')

def flange_settings(p, sheet):
    """Edge-flange options from the recipe, in SolidWorks terms (mm, degrees).

    SolidWorks defaults: length to the outer virtual sharp, material inside,
    the sheet's bend radius and its relief (Rectangular, ratio 0.5). The
    'alternative' twins pick inner virtual sharp and material outside."""
    t = sheet['thickness']
    dim = 2 if p.get('height_datum', 'default') != 'default' else 1
    position = 2 if p.get('bend_position', 'default') != 'default' else 1
    radius = p['bend_radius'] if 'bend_radius' in p and p['bend_radius'] != sheet.get('bend_radius', 1) else 0
    k_factor = p['k_factor'] if 'k_factor' in p and p['k_factor'] != sheet.get('k_factor', 0.44) else 0
    shape = p.get('bend_relief', 'default')
    width, depth = (p.get('bend_relief_width', 'default'), p.get('bend_relief_depth', 'default'))
    if shape == 'default' and width == 'default' and (depth == 'default'):
        relief = (0, 1, 0.0, 0.0)
    else:
        relief_type = 3 if shape == 'round' else 1
        if width == 'default' and depth == 'default':
            relief = (1, relief_type, 0.0, 0.0)
        else:
            relief = (2, relief_type, width if width != 'default' else 0.5 * t, depth if depth != 'default' else 0.5 * t)
    return dict(dim=dim, position=position, radius=radius, k_factor=k_factor, relief=relief)

def flange_span(p, a, b):
    """Model end points (mm) of a part-width flange on edge a-b, or None (full edge)."""
    kind = p.get('width_type', 'full')
    if kind == 'full':
        return None
    length = math.dist(a, b)
    if kind == 'width':
        corner = p['from_corner']
        if math.dist(corner, b) < 1e-06:
            a, b = (b, a)
        elif math.dist(corner, a) >= 1e-06:
            raise RuntimeError('flange width: from_corner %s is not an end of the flange edge' % corner)
        start, end = (p['offset'], p['offset'] + p['width'])
    else:
        axis_index = max(range(3), key=lambda i: abs(b[i] - a[i]))
        if b[axis_index] < a[axis_index]:
            a, b = (b, a)
        start, end = (p['offset1'], length - p['offset2'])
    if not 0 <= start < end <= length + 1e-09:
        raise RuntimeError('flange width: span %.6g..%.6g mm is outside the %.6g mm edge' % (start, end, length))
    unit = [(b[i] - a[i]) / length for i in range(3)]
    return ([a[i] + unit[i] * start for i in range(3)], [a[i] + unit[i] * end for i in range(3)])

def profile_offset(m, pa, pb, height, axis_index, sign):
    """In-sketch offset of the flange's far side from its base line pa-pb.

    m is the profile sketch's model-to-sketch IMathTransform.ArrayData. A sketch
    vector (u, v) is model vector u*column0 + v*column1 of the rotation; choose
    the perpendicular of pa-pb that points along the requested model axis."""
    du, dv = (pb[0] - pa[0], pb[1] - pa[1])
    length = math.hypot(du, dv)
    if length < 1e-09:
        raise RuntimeError('edge flange base line has zero length in the profile sketch')
    nu, nv = (-dv / length, du / length)
    component = nu * m[3 * axis_index] + nv * m[3 * axis_index + 1]
    if component * sign < 0:
        nu, nv, component = (-nu, -nv, -component)
    if component * sign < 1e-06:
        raise RuntimeError('edge flange profile plane has no component along the requested direction')
    return (nu * height, nv * height)

def turn_matrix(turns):
    """The 3x3 rotation R (world = R * local) of turns about the WORLD axes, applied in order, counter-clockwise seen from the
    positive end (booklet "Placement language for A11 and up")."""
    result = [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]
    for turn in turns or ():
        angle = math.radians(turn['deg'])
        c, s = (math.cos(angle), math.sin(angle))
        i = 'XYZ'.index(turn['axis'])
        j, k = ((i + 1) % 3, (i + 2) % 3)
        step = [[1.0 if a == b else 0.0 for b in range(3)] for a in range(3)]
        step[j][j], step[j][k], step[k][j], step[k][k] = (c, -s, s, c)
        result = [[sum((step[a][m] * result[m][b] for m in range(3))) for b in range(3)] for a in range(3)]
    return [[0.0 if abs(v) < 1e-12 else round(v, 12) for v in row] for row in result]

def placement(value, turn=None):
    if value == 'off_to_side_default':
        value = [100, 0, 0]
    elif value == 'default':
        value = [0, 0, 0]
    if not turn:
        return (1, 0, 0, 0, 1, 0, 0, 0, 1, *xyz(value), 1, 0, 0, 0)
    rotation = turn_matrix(turn)
    return (*[rotation[j][i] for i in range(3) for j in range(3)], *xyz(value), 1, 0, 0, 0)

def file_leaf(path):
    """The file name of a path (either separator): results.json and the log never carry a folder or a user name."""
    return re.split('[\\\\/]', str(path))[-1]

def pose_of(values):
    """(translation in mm, rotation R with world = R * local) of an IMathTransform.ArrayData."""
    values = [float(v) for v in values]
    check(len(values) >= 13, 'the component transform has no rotation and translation')
    return ([v * 1000.0 for v in values[9:12]], [[values[3 * j + i] for j in range(3)] for i in range(3)])

def mate_arguments(constraint, concentric=False):
    typ = constraint['type']
    offset = constraint.get('offset', 0) * MM
    kind = 1 if concentric else 6 if typ == 'angle' else 5 if offset else 0
    align = 0 if typ == 'flush' else 1
    if concentric or typ == 'angle':
        align = 2
    angle = math.radians(constraint.get('angle', 0))
    return (kind, align, False, offset, offset, offset, 1, 1, angle, angle, angle, False, False, 0)
SIDE_TOL = 5e-05

def tangent_arguments(align):
    return (swMateTANGENT, align, False, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, False, False, 0)
MATE_ALIGN = {'aligned': 0, 'anti': 1, 'closest': 2}

def limit_mate_frame(c):
    """The frame a limit mate is asked and read back in (mm for a distance, degrees for an angle).

    IMate2.MinimumVariation / MaximumVariation are relative to the mate's own value, not absolute (field 2026.11.24.3: -20..20 mm asked with
    the distance 20 came back -40..0). `pose` is the value passed to AddMate5, so read-back = stored + pose. AddMate5 refused a distance limit
    mate whose value is negative (A18c: -0.02 error 0, +0.02 accepted, negative lower limits accepted): then |value| is passed with Flip
    toggled and the limits [min, max] become [-max, -min] (limit-mate-negative-flip); the read-back is compared in that same frame."""
    value, low, high = (float(c['value']), float(c['min']), float(c['max']))
    if c['type'] == 'distance' and value < 0:
        return dict(pose=-value, low=-high, high=-low, negative=True)
    return dict(pose=value, low=low, high=high, negative=False)

def new_mate_plans(c, flip=False, align=None):
    """[(label, AddMate5 arguments)] for a coincident, distance or limit_angle constraint, in the order they are tried.

    AddMate5 (Type, Align, Flip, Distance, DistUpper, DistLower, GearNum, GearDen, Angle, AngleUpper, AngleLower, ForPositioning,
    LockRotation, WidthType); metres and radians. A limit mate carries Upper > Lower around the value (documented encoding, API
    doc 3.2); it is unproven (the A05b distance mate with Upper = Lower = value came back as error 0). A limit mate has ONE plan:
    a plain distance or angle mate would drive the motion the limit only bounds and lock it, so when SolidWorks refuses the limits
    no mate is made for that motion and it stays free at the saved pose (the limits are reported as not stored). `align` overrides
    the constraint's alignment (the retry of a coincident mate with the other one)."""
    align = MATE_ALIGN[c.get('align', 'anti')] if align is None else align
    plain = (1.0, 1.0, 0.0, 0.0, 0.0, False, False, 0)
    if c['type'] == 'coincident':
        return [('coincident', (swMateCOINCIDENT, align, flip, 0.0, 0.0, 0.0) + plain)]
    if c['type'] == 'distance':
        d = float(c['value']) * MM
        if 'min' in c:
            frame = limit_mate_frame(c)
            d, low, high = (frame['pose'] * MM, frame['low'] * MM, frame['high'] * MM)
            flip = flip != frame['negative']
            return [('limits %.6g..%.6g%s' % (low, high, ', |value| with Flip toggled (negative value)' if frame['negative'] else ''), (swMateDISTANCE, align, flip, d, high, low) + plain)]
        return [('Dist=Upper=Lower', (swMateDISTANCE, align, flip, d, d, d) + plain), ('limits 0', (swMateDISTANCE, align, flip, d, 0.0, 0.0) + plain)]
    angle, low, high = (math.radians(float(c[k])) for k in ('value', 'min', 'max'))
    return [('limits %.6g..%.6g' % (low, high), (swMateANGLE, swMateAlignCLOSEST, flip, 0.0, 0.0, 0.0, 1.0, 1.0, angle, high, low, False, False, 0))]
MIRROR_FORMS = (('empty arrays', None), ('Nothing for the unused arrays', 'mirror-empty-array-nothing'), ('Empty for the unused arrays', 'mirror-empty-variant'), ('empty arrays, the plane selected, ImportOptions 0, not about the center of mass', 'mirror-plane-selected'), ('the plane as the IRefPlane object', 'mirror-refplane-object'))

def mate_limit_text(c):
    unit = 'deg' if c['type'] == 'limit_angle' else 'mm'
    return '%.6g..%.6g %s' % (float(c['min']), float(c['max']), unit)

def mate_retry_plan(c):
    """The one other way to ask for a mate that may have come out wrong: Flip toggled for a distance or angle mate, the other alignment for a
    coincident mate of two faces (anti / aligned); None where there is no other way (origin to origin, closest)."""
    if c['type'] in ('distance', 'limit_angle'):
        return dict(flip=True, suffix=', flip')
    if c['type'] == 'coincident' and c.get('align', 'anti') in ('anti', 'aligned'):
        return dict(align=MATE_ALIGN['aligned' if c.get('align', 'anti') == 'anti' else 'anti'], suffix=', other alignment')
    return None

def tangent_plane(constraint):
    """(unit normal, plane point in meters, wants outside) from the planar face (selector b) of a tangent constraint."""
    face = constraint['b']['face']
    return (axis(face['normal']), xyz(face['contains']), constraint.get('solution', 'outside') == 'outside')

def tangent_side(box, normal, point, outside, radius):
    """Is a component with this IComponent2.GetBox (xmin, ymin, zmin, xmax, ymax, zmax; meters) on the wanted side?

    Round 7 (field, revision 34.4.0): GetBox is padded by about 0.44 mm, so the box edge never touches the
    plane. A cylinder tangent to the plane has its axis one radius from it, so the side is judged by the box
    CENTRE along the plane normal: +radius is outside, -radius is inside (SIDE_TOL, 0.05 mm). Returns (ok, text)."""
    index = next((i for i in range(3) if normal[i]))
    sign = normal[index]
    a, b = (sign * (float(box[index + 3 * k]) - point[index]) for k in (0, 1))
    low, high = (min(a, b), max(a, b))
    centre = (low + high) / 2
    if outside:
        ok = abs(centre - radius) <= SIDE_TOL
    else:
        ok = abs(centre + radius) <= SIDE_TOL
    text = 'component box along the plane normal %s%s is %.4f..%.4f mm from the plane, center %.4f mm, cylinder radius %.4f mm (wanted %s: center at %s%.4f mm +/- %.2f mm)' % ('+' if sign > 0 else '-', 'XYZ'[index], low * 1000, high * 1000, round(centre * 1000, 4) + 0.0, radius * 1000, 'outside' if outside else 'inside', '+' if outside else '-', radius * 1000, SIDE_TOL * 1000)
    return (ok, text)

def cylinder_radius(entity):
    """Radius (meters) of a cylindrical face: IFace2.GetSurface -> ISurface.CylinderParams (origin xyz, axis xyz, radius)."""
    set_step('GetSurface', 'cylinder_radius')
    surface = check(entity.GetSurface(), 'the cylindrical face has no surface')
    set_step('CylinderParams', 'cylinder_radius')
    params = check(surface.CylinderParams, 'the cylindrical face surface has no CylinderParams')
    return float(params[6])

def state_preflight(op, previous):
    """Preflight of a SolidWorks configuration / display state op against the components inserted before it."""
    params = op.get('params', {})
    kind = op['op']
    key, default = ('suppress', 'master') if kind == 'configuration' else ('hide', 'Default')
    names = [i['insert'].get('name', i['insert']['recipe']) for i in previous if i['kind'] == 'assembly' and 'insert' in i]
    name = params.get('name')
    if not isinstance(name, str) or not name.strip() or re.search('[\\\\/:*?"<>|;,]', name):
        raise NotScripted(kind + ': needs a plain non-empty name without path or list characters, got ' + repr(name))
    targets = params.get(key)
    if not isinstance(targets, list) or not targets or any((t not in names for t in targets)):
        raise NotScripted('%s: %s must name components inserted earlier in the recipe (%s), got %r' % (kind, key, ', '.join(names) or 'none inserted', targets))
    if params.get('active', default) not in (default, name):
        raise NotScripted('%s: active must be %r or the new name %r, got %r' % (kind, default, name, params.get('active')))

def hole_arguments(op):
    typ = op['hole_type']
    values = [-1.0] * 12
    tip = math.radians(op.get('tip_angle', 118) if op.get('tip', 'flat') == 'angle' else 180)
    if typ == 'simple':
        generic, fastener = (2, 144)
        values[:6] = [0, tip, 0, 0, 0, 0]
    elif typ == 'counterbore':
        generic, fastener = (0, 139)
        values[:11] = [op['cb_dia'] * MM, op['cb_depth'] * MM, 0, 0, tip, 0, 0, 0, 0, 0, 0]
    else:
        generic, fastener = (1, 140)
        values[:9] = [op['cs_dia'] * MM, math.radians(op['cs_angle']), 0, 0, tip, 0, 0, -1, 0]
    return (generic, 8, fastener, 'M5', 1 if op.get('through_all') else 0, op['dia'] * MM, op.get('depth', 0) * MM, -1, *values, '', False, False, True, False, False, False)

def chamfer_arguments(op):
    mode = op.get('mode', 'distance')
    options = 4 | (1 if op.get('flip') else 0)
    if mode == 'two_distances':
        return (options, 2, op['d1'] * MM, 0, op['d2'] * MM, op['d1'] * MM, op['d2'] * MM, 0)
    return (options, 1, op['d1'] * MM, math.radians(op.get('angle', 45)), 0, 0, 0, 0)

def expression_value(expression, parameters, error=RuntimeError):
    """Evaluate a driving expression (+ - * / parentheses, numbers, parameter names) in mm."""
    if not re.fullmatch('[A-Za-z0-9_+\\-*/(). ]+', expression):
        raise error('driving expression ' + repr(expression) + ' uses characters other than names, numbers and + - * / ( )')
    unknown = [n for n in re.findall('[A-Za-z_][A-Za-z0-9_]*', expression) if n not in parameters]
    if unknown:
        raise error('driving expression ' + repr(expression) + ' uses undefined parameter ' + unknown[0])
    try:
        value = eval(re.sub('[A-Za-z_][A-Za-z0-9_]*', lambda m: repr(float(parameters[m.group(0)])), expression), {'__builtins__': {}}, {})
    except Exception as exc:
        raise error('driving expression ' + repr(expression) + ' cannot be evaluated: ' + type(exc).__name__)
    return float(value)

def equation_text(target, expression):
    return '"%s" = %s' % (target, re.sub('[A-Za-z_][A-Za-z0-9_]*', lambda m: '"%s"' % m.group(0), expression))

def double_array(values):
    import pythoncom
    from win32com.client import VARIANT
    return VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, tuple(values))

def object_array(items):
    import pythoncom
    from win32com.client import VARIANT
    return VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, tuple(items))

def string_array(items):
    import pythoncom
    from win32com.client import VARIANT
    return VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_BSTR, tuple(items))

def int_array(items):
    import pythoncom
    from win32com.client import VARIANT
    return VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_I4, tuple(items))

def int16_array(items):
    import pythoncom
    from win32com.client import VARIANT
    return VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_I2, tuple(items))

def variant_array(items):
    import pythoncom
    from win32com.client import VARIANT
    return VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_VARIANT, tuple(items))

def endpoint_radii(edge, op):
    set_step('GetStartVertex', 'endpoint_radii')
    vertices = [edge.GetStartVertex(), edge.GetEndVertex()]
    if any((v is None for v in vertices)):
        raise RuntimeError('variable fillet requires two edge vertices')
    parameters = [op['r_start'], op['r_end']]
    radii = []
    for vertex in vertices:
        set_step('GetPoint', 'endpoint_radii')
        matches = [p for p in parameters if math.dist(vertex.GetPoint(), xyz(p['at'])) <= TOL]
        if len(matches) != 1:
            raise RuntimeError('variable fillet radius position must match one edge endpoint')
        radii.append(matches[0]['r'] * MM)
    set_step('GetPoint', 'endpoint_radii')
    if math.dist(vertices[0].GetPoint(), vertices[1].GetPoint()) <= TOL:
        raise RuntimeError('variable fillet needs distinct endpoints')
    return double_array(radii)

def drawing_axis(matrix):
    """The model axis a drawing view looks along (0, 1, 2), from IView.ModelToViewTransform.ArrayData.

    Row-vector convention (as every transform here): view = (model x R) * scale + t, so the view's z
    axis is column 2 of R. Round 8 (field, 34.4.0): the view projected beside the Top view has the rows
    (0,0,1), (-1,0,0), (0,-1,0), so its z column names X and its z row names Y; the old "column and row
    must agree" test failed a perfectly good Right view. The rotation must be a signed axis permutation
    (every row and every column holds exactly one +-1 and zeros, within 1e-9); anything else (a tilted or
    oblique view) fails. The convention is confirmed by the same field data: the view's origin offset
    (0.16, 0.15, 0) m is the model box centre run through the rows as row vectors, at the sheet position
    the view was placed at."""
    if not matrix_usable(matrix):
        raise RuntimeError('the drawing view transform is not a rotation: ' + repr(tuple(matrix)))
    rotation = tuple((float(v) for v in matrix[0:9]))
    for line in (rotation[0:3], rotation[3:6], rotation[6:9], rotation[0::3], rotation[1::3], rotation[2::3]):
        ones = [v for v in line if abs(abs(v) - 1) <= 1e-09]
        zeros = [v for v in line if abs(v) <= 1e-09]
        if len(ones) != 1 or len(zeros) != 2:
            raise RuntimeError('the drawing view is not an axis-aligned view: its rotation is not a signed axis permutation: %s' % (rotation,))
    return next((i for i in range(3) if abs(rotation[3 * i + 2]) > 0.5))

def view_to_model(matrix, point):
    """Undo IView.ModelToViewTransform for a point (row-vector convention, orthonormal rotation)."""
    v = [(point[j] - matrix[9 + j]) / matrix[12] for j in range(3)]
    return tuple((sum((v[j] * matrix[3 * i + j] for j in range(3))) for i in range(3)))

def flat(point, drop):
    return tuple((point[i] for i in range(3) if i != drop))

def near(a, b, tol=1e-06):
    return all((abs(x - y) <= tol for x, y in zip(a, b)))

def drawing_edges(view, bbox):
    """The visible line and circle edges of a drawing view, in model meters, flattened along the
    view's axis. Entity coordinates are taken as model coordinates; when they do not all lie inside
    the model's box they are tried as view coordinates (undoing the view transform), and when that
    fails too the recipe fails naming both. Returns (records, drop axis, space name)."""
    set_step('GetName2', 'drawing_edges')
    name = view.GetName2()
    set_step('ArrayData', 'drawing_edges')
    matrix = tuple((float(v) for v in view.ModelToViewTransform.ArrayData))
    drop = drawing_axis(matrix)
    set_step('GetVisibleEntities2', 'drawing_edges')
    raw = view.GetVisibleEntities2(None, swViewEntityType_Edge)
    entities = list(raw or ())
    if not entities:
        raise RuntimeError('%s: GetVisibleEntities2 returned no edges' % name)
    found = []
    for entity in entities:
        set_step('GetCurve', 'drawing_edges')
        curve = entity.GetCurve()
        if curve is None:
            continue
        set_step('IsLine', 'drawing_edges')
        if curve.IsLine():
            set_step('GetPoint', 'drawing_edges')
            found.append(dict(kind='line', entity=entity, points=[tuple(entity.GetStartVertex().GetPoint()), tuple(entity.GetEndVertex().GetPoint())]))
        else:
            set_step('IsCircle', 'drawing_edges')
            if curve.IsCircle():
                set_step('CircleParams', 'drawing_edges')
                parameters = tuple(curve.CircleParams)
                found.append(dict(kind='circle', entity=entity, points=[tuple(parameters[0:3])], radius=parameters[6], axis=tuple(parameters[3:6]), raw=parameters))
    if not found:
        raise RuntimeError('%s: none of its %d visible edges is a line or a circle' % (name, len(entities)))
    low, high = ([c * MM for c in row] for row in bbox)

    def inside(point):
        return all((low[i] - 1e-06 <= point[i] <= high[i] + 1e-06 for i in range(3)))
    for space, convert in (('model', lambda p: p), ('view', lambda p: view_to_model(matrix, p))):
        if all((inside(convert(p)) for record in found for p in record['points'])):
            break
    else:
        sample = found[0]['points'][0]
        raise RuntimeError('%s: the visible edge points lie outside the model box %s mm as model coordinates and as view coordinates (first point %s, transform %s)' % (name, bbox, sample, matrix))
    for record in found:
        record['flat'] = [flat(convert(p), drop) for p in record['points']]
        if record['kind'] == 'circle':
            axis = record['axis']
            if space == 'view':
                axis = tuple((sum((axis[j] * matrix[3 * i + j] for j in range(3))) for i in range(3)))
            size = math.sqrt(sum((c * c for c in axis)))
            if abs(size - 1) > 1e-06:
                record['face_on'] = None
            elif abs(abs(axis[drop]) - 1) <= 1e-06:
                record['face_on'] = True
            elif abs(axis[drop]) <= 1e-06:
                record['face_on'] = False
            else:
                record['face_on'] = None
            record['flat_axis'] = flat(axis, drop)
    return (found, drop, space)

def dimension_plan(records, first, second):
    """The one or two edges whose selection makes SolidWorks measure the distance between two points
    (flattened, metres): a line whose two ends are the points (its length), else two references, each a
    circle centred on its point or a line through it that is perpendicular to the measuring direction.
    None when the view cannot show it. This is the plan D05a has always made, and it is tried first.

    Only when it finds nothing, two more forms are tried (their records are copies marked with `rung`, the mitigation name; the axis of a
    circle, ICurve.CircleParams[3:6], decides: a zero or non-unit axis is unknown and no circle is taken for either):
    a circle seen face-on whose diameter the points are the ends of (selected alone, IModelDoc2.AddDimension2 adds a diameter dimension),
    and circles seen edge-on, each the straight line through its centre 2 x radius long, as references (SolidWorks dimensions two circle
    edges between their centres, which is the distance between the lines they show)."""
    delta = (second[0] - first[0], second[1] - first[1])
    length = math.hypot(*delta)
    if length < 1e-09:
        raise RuntimeError('the two dimension points coincide in the view: %s' % (first,))
    unit = (delta[0] / length, delta[1] / length)
    lines = [r for r in records if r['kind'] == 'line']
    for record in lines:
        a, b = record['flat']
        if near(a, first) and near(b, second) or (near(a, second) and near(b, first)):
            return [record]

    def line_reference(point):
        for record in lines:
            a, b = record['flat']
            run = (b[0] - a[0], b[1] - a[1])
            size = math.hypot(*run)
            if size < 1e-09 or abs(run[0] * unit[0] + run[1] * unit[1]) > 1e-06 * size:
                continue
            along = ((point[0] - a[0]) * run[0] + (point[1] - a[1]) * run[1]) / (size * size)
            off = abs((point[0] - a[0]) * run[1] - (point[1] - a[1]) * run[0]) / size
            if -1e-09 <= along <= 1 + 1e-09 and off <= 1e-06:
                return record
        return None

    def reference(point):
        for record in records:
            if record['kind'] == 'circle' and near(record['flat'][0], point):
                return record
        return line_reference(point)
    one, two = (reference(first), reference(second))
    if one is not None and two is not None and (one is not two):
        return [one, two]
    for record in records:
        if record['kind'] == 'circle' and record.get('face_on') is True and (abs(2 * record['radius'] - length) <= 1e-06) and near(record['flat'][0], ((first[0] + second[0]) / 2, (first[1] + second[1]) / 2)):
            return [dict(record, rung='drawing-dimension-circle-diameter')]

    def rim_reference(point):
        for record in records:
            if record['kind'] == 'circle' and record.get('face_on') is False:
                centre, axis = (record['flat'][0], record['flat_axis'])
                run = (point[0] - centre[0], point[1] - centre[1])
                if abs(-axis[1] * unit[0] + axis[0] * unit[1]) <= 1e-06 and abs(run[0] * axis[0] + run[1] * axis[1]) <= 1e-06 and (abs(-run[0] * axis[1] + run[1] * axis[0]) <= record['radius'] + 1e-09):
                    return dict(record, rung='drawing-dimension-edge-on-circles')
        return None
    one, two = (rim_reference(first), rim_reference(second))
    if one is None and two is None:
        return None
    one = one or reference(first)
    two = two or reference(second)
    return [one, two] if one is not None and two is not None and (one['entity'] is not two['entity']) else None

def drawing_dimension_values(drawing):
    """Every display dimension in the drawing, read from the drawing itself: (view name, millimeters)."""
    found = []
    set_step('GetFirstView', 'drawing_dimension_values')
    view = drawing.GetFirstView()
    while view is not None:
        set_step('GetFirstDisplayDimension5', 'drawing_dimension_values')
        display = view.GetFirstDisplayDimension5()
        while display is not None:
            set_step('GetName2', 'drawing_dimension_values')
            found.append((view.GetName2(), float(display.GetDimension2(0).SystemValue) / MM))
            set_step('GetNext3', 'drawing_dimension_values')
            display = display.GetNext3()
        set_step('GetNextView', 'drawing_dimension_values')
        view = view.GetNextView()
    return found

def part_geometry_depth(model):
    """The depth of a part from its own geometry (meters): the z extent of its first solid body, IPartDoc.GetBodies2 + IBody2.GetBodyBox
    (x low, y low, z low, x high, y high, z high); if no body gives a box, IPartDoc.GetPartBox(True). The arbiter of a configuration's depth
    (field 2026.11.24.3: a dimension handle read the last value written in every configuration)."""
    box, reason = (None, '')
    try:
        set_step('GetBodies2', 'part_geometry_depth')
        bodies = api_interface(model, 'PartDoc').GetBodies2(swSolidBody, True) or ()
        for body in bodies:
            set_step('GetBodyBox', 'part_geometry_depth')
            box = body.GetBodyBox()
            break
    except Exception as exc:
        reason = diagnostic_error(exc)
    if box is None:
        try:
            set_step('GetPartBox', 'part_geometry_depth')
            box = api_interface(model, 'PartDoc').GetPartBox(True)
        except Exception as exc:
            raise RuntimeError('the part has no box to read its depth from (GetBodyBox: %s; GetPartBox: %s)' % (reason or 'no body', diagnostic_error(exc)))
    return float(box[5]) - float(box[2])

def activate_configuration(model, name, what):
    """IModelDoc2.ShowConfiguration2 with the active configuration checked first.

    Round 8 (field, 34.4.0, A08a/A08b): ShowConfiguration2 returned False for the configuration that was already active
    (the new configuration right after AddConfiguration, and the one a reopened file starts in), though switching to
    another configuration returned True each time. So an already-active configuration is not asked for again, and a
    False return counts only when the active configuration is not the wanted one afterwards."""
    set_step('ConfigurationManager', 'activate_configuration')
    manager = model.ConfigurationManager
    set_step('Name', 'activate_configuration')
    if str(manager.ActiveConfiguration.Name) == name:
        record_mitigation('showconfiguration-already-active', always=True)
        return
    set_step('ShowConfiguration2', 'activate_configuration')
    shown = model.ShowConfiguration2(name)
    set_step('Name', 'activate_configuration')
    now = str(manager.ActiveConfiguration.Name)
    if now == name:
        if not shown:
            record_mitigation('showconfiguration-false-but-active', primary_failed=True, always=True)
            mitigations['showconfiguration-false-but-active']['fallback_ok'] += 1
        return
    raise RuntimeError('cannot activate %s %r: ShowConfiguration2 returned %s and the active configuration is %r' % (what, name, bool(shown), now))

def expected_poses(design):
    """{label: (translation mm, rotation R or None)} of the top-level components in the answer key: R only where the key scores it."""
    key = design.get('placements') or {}
    poses = {}
    for item in key.get('instances', ()):
        if '/' in item['path'] or '#' in item['path'] or item.get('suppressed'):
            continue
        scored = key.get('score_R', True) and item.get('R_scored', True)
        poses[item['path']] = ([float(v) for v in item['t']] if key.get('score_t', True) else None, [[float(v) for v in row] for row in item['R']] if scored else None)
    return {label: pose for label, pose in poses.items() if pose[0] is not None}

def final_mates(ops):
    """The names of the last constraint of each moving component: the pose is judged after it where the component was not inserted at its pose."""
    last = {}
    for op in ops:
        if op['kind'] == 'assembly' and 'constraint' in op and op['constraint'].get('moving'):
            last[op['constraint']['moving']] = op['constraint']['name']
    return set(last.values())

class Builder:

    def __init__(self, app, doc, folder=None):
        self.app, self.doc = (app, doc)
        self.folder = folder
        self.loaded = []
        self.components = {}
        self.refs = {}
        self.last = None
        self.index = 0
        self.three_d = False
        self.sketch_plane = ''
        self.matrix_logged = False
        self.profile_plane = None
        self.sheet = None
        self.k_failure = None
        self.flange_axis = None
        self.probe_note = ''
        self.parameters = {}
        self.driven = []
        self.width_dimension = None
        self.state_checks = []
        self.drawing_interface = None
        self.curves = set()
        self.helix_start = self.helix_tangent = self.helix_end = self.helix_end_tangent = None
        self.diag = {}
        self.circle_radius = 0.0
        self.poses, self.files, self.trees, self.extra_files = ({}, {}, {}, [])
        self.mate_features, self.wanted_mates = ({}, set())
        self.placement_report = ''
        self.patterns, self.config_of, self.part_files, self.recipe_of = ({}, {}, {}, {})
        self.expected, self.limit_notes, self.limit_degraded, self.final_mates = ({}, [], False, set())
        self.mirror_form = 0
        self.moved = {}
        self.child_routes = {}

    def reference(self, name):
        return self.last if name in (None, 'last') else self.refs[name]

    def dimension(self, segment, value, position):
        set_step('ClearSelection2', 'dimension')
        self.doc.ClearSelection2(True)
        set_step('Select4', 'dimension')
        check(segment.Select4(False, None), 'dimension segment selection failed')
        set_step('AddDimension2', 'dimension')
        dim = check(self.doc.AddDimension2(*position), 'dimension creation failed')
        set_step('GetDimension2', 'dimension')
        dimension = check(dim.GetDimension2(0), 'dimension value unavailable')
        set_step('SystemValue', 'dimension')
        dimension.SystemValue = value
        return dimension

    def add_equation(self, text):
        set_step('GetEquationMgr', 'add_equation')
        manager = check(self.doc.GetEquationMgr(), 'GetEquationMgr returned nothing')
        set_step('Add2', 'add_equation')
        index = manager.Add2(manager.GetCount(), text, True)
        if index < 0:
            raise RuntimeError('IEquationMgr.Add2 rejected the equation ' + text)
        return index

    def drive(self, dimension, expression, label):
        """Link a dimension to a global-variable expression and remember what it must evaluate to."""
        set_step('FullName', 'drive')
        text = equation_text(check(dimension.FullName, 'dimension name unavailable'), expression)
        self.add_equation(text)
        self.driven.append((dimension, expression_value(expression, self.parameters) * MM, label + ': ' + text))

    def verify_equations(self):
        """After the rebuild every driven dimension must hold the expression's value."""
        for dimension, expected, label in self.driven:
            set_step('SystemValue', 'verify_equations')
            measured = float(dimension.SystemValue)
            if abs(measured - expected) > 1e-09:
                raise RuntimeError('equation did not drive its dimension: %s; dimension is %.9g m, expected %.9g m' % (label, measured, expected))

    def point(self, point):
        if self.three_d:
            return xyz(point)
        set_step('ModelToSketchTransform', 'point')
        transform = self.doc.SketchManager.ActiveSketch.ModelToSketchTransform
        set_step('GetMathUtility', 'point')
        utility = self.app.GetMathUtility()
        set_step('CreatePoint', 'point')
        math_point = check(utility.CreatePoint(double_array(xyz(point))), 'math point creation failed')
        set_step('MultiplyTransform', 'point')
        transformed = check(math_point.MultiplyTransform(transform), 'math point transform failed')
        record_mitigation('arraydata-copy-always')
        set_step('ArrayData', 'point')
        values = tuple((float(v) for v in transformed.ArrayData))[:3]
        model = xyz(point)
        if values == (0.0, 0.0, 0.0) and any(model):
            return self.recover_point(model, transform)
        return self.checked_point(model, values, transform)

    def checked_point(self, model, values, transform):
        """Round 3 on revision 34.4.0: P09's sketch on the +Y end face built its boss
        centred at z = 0 instead of z = 5 with no zero detected, so a partly wrong
        transformed point gets past the all-zero test. The matrix path was right for
        all 28 recovered points: cross-check every point and trust the matrix."""
        try:
            set_step('ArrayData', 'checked_point')
            matrix = tuple((float(v) for v in transform.ArrayData))
        except Exception:
            return values
        if not matrix_usable(matrix):
            return values
        local = matrix_point(matrix, model)
        if math.dist(local[:3], values[:3]) <= 1e-09:
            return values
        record_mitigation('localpoint-arraydata-mismatch')
        fmt = lambda vs: ','.join(('%.9g' % v for v in vs))
        self.note('localpoint-arraydata-mismatch model(m)=%s plane=%s arraydata=%s matrix-result=%s matrix=%s' % (fmt(model), self.sketch_plane, fmt(values), fmt(local), fmt(matrix)))
        return local

    def recover_point(self, model, transform):
        """Revision 34.4.0 returned (0,0,0) for every transformed sketch point.

        A non-zero model point that maps to exactly zero is only genuine at the
        sketch origin. Otherwise use the transform's own matrix, then the exact
        default-plane mapping; never draw a face sketch at its origin."""
        planar = self.sketch_plane in PLANE_MAP
        mapped = plane_map(self.sketch_plane, model) if planar else None
        if planar and math.hypot(mapped[0], mapped[1]) <= 1e-12:
            return mapped
        record_mitigation('localpoint-zero-detected')
        matrix = None
        try:
            set_step('ArrayData', 'recover_point')
            matrix = tuple((float(v) for v in transform.ArrayData))
        except Exception:
            matrix = None
        note = 'model(m)=%s plane=%s' % (','.join(('%.9g' % v for v in model)), self.sketch_plane)
        if not self.matrix_logged:
            note += ' matrix=' + (','.join(('%.9g' % v for v in matrix)) if matrix else 'unavailable')
            self.matrix_logged = True
        local = matrix_point(matrix, model) if matrix_usable(matrix) else None
        if local is not None and planar and (math.dist(local[:2], mapped[:2]) > 1e-09):
            record_mitigation('localpoint-matrix-mismatch')
            note += ' matrix-result=%s planemap=%s' % (','.join(('%.9g' % v for v in local)), ','.join(('%.9g' % v for v in mapped)))
            local = None
        if local is not None:
            record_mitigation('localpoint-matrix')
            self.note('localpoint-matrix ' + note)
            return local
        if planar:
            record_mitigation('localpoint-planemap')
            self.note('localpoint-planemap ' + note)
            return mapped
        self.note('localpoint-refused ' + note)
        raise RuntimeError('sketch on a model face: SolidWorks returned (0,0,0) sketch coordinates for model point ' + ','.join(('%.9g' % v for v in model)) + ' m and its ModelToSketchTransform matrix is unusable; refusing to draw at the sketch origin')

    def note(self, text):
        if self.folder is not None:
            entry = dict(time=time.strftime('%Y-%m-%dT%H:%M:%S%z'), builder=BUILDER_VERSION, recipe=current_identity, step='LocalPoint', Erl=0, **{'Err.Number': 0, 'Err.Description': text})
            with (self.folder / 'FixtureBuilder.log').open('a', encoding='utf-8') as stream:
                stream.write(dump_json(entry) + '\n')

    def log(self, label, text):
        if self.folder is not None:
            log_line(self.folder, label, text)

    def select_feature(self, feature, append, mark, label, by_name_type=None):
        """Select a tree feature and CONFIRM it by the selection count, not by Select2's return value.

        Round 9: Select2 may return False yet select (as Select4 does on SolidWorks 2026), or select nothing; the
        fallback selects the feature by name and type (for a helix, REFERENCECURVES) with SelectByID2."""
        doc = self.doc
        set_step('SelectionManager', 'select_feature')
        manager = doc.SelectionManager
        set_step('GetSelectedObjectCount2', 'select_feature')
        before = manager.GetSelectedObjectCount2(-1) if append else 0
        set_step('Select2', 'select_feature')
        selected = feature.Select2(append, mark)
        set_step('GetSelectedObjectCount2', 'select_feature')
        after = manager.GetSelectedObjectCount2(-1)
        if selected or after == before + 1:
            if not selected:
                record_mitigation('feature-select2-false-but-selected', primary_failed=True, always=True)
                mitigations['feature-select2-false-but-selected']['fallback_ok'] += 1
            return
        if by_name_type:
            record_mitigation('feature-select-by-name', primary_failed=True, always=True)
            set_step('SelectByID2', 'select_feature')
            doc.Extension.SelectByID2(feature.Name, by_name_type, 0.0, 0.0, 0.0, append, mark, None, 0)
            set_step('GetSelectedObjectCount2', 'select_feature')
            if manager.GetSelectedObjectCount2(-1) == before + 1:
                mitigations['feature-select-by-name']['fallback_ok'] += 1
                return
        raise RuntimeError(label + ' selection failed' + selection_summary(doc))

    def select_start_point(self, point):
        """Select the point at a model position (the helix start) as the second selection, confirmed by the count."""
        doc = self.doc
        set_step('SelectionManager', 'select_start_point')
        manager = doc.SelectionManager
        tried = []
        for index, kind in enumerate(('VERTEX', 'POINT', 'EXTSKETCHPOINT')):
            set_step('GetSelectedObjectCount2', 'select_start_point')
            before = manager.GetSelectedObjectCount2(-1)
            set_step('SelectByID2', 'select_start_point')
            returned = doc.Extension.SelectByID2('', kind, float(point[0]), float(point[1]), float(point[2]), True, 1, None, 0)
            set_step('GetSelectedObjectCount2', 'select_start_point')
            grew = manager.GetSelectedObjectCount2(-1) - before
            tried.append('%s returned %s, selected %d' % (kind, bool(returned), grew))
            if grew == 1:
                if index:
                    record_mitigation('start-point-select-type', primary_failed=True, always=True)
                    mitigations['start-point-select-type']['fallback_ok'] += 1
                return kind
        raise RuntimeError('the helix start point could not be selected at (%s) mm (%s)%s' % (', '.join(('%.6g' % (v / MM) for v in point)), '; '.join(tried), selection_summary(doc)))

    def new_feature_after(self, before_name, api, wanted, candidate=None, detail=''):
        """The feature an API call just created, or an explicit failure when it created none of the wanted kind."""
        feature = candidate if candidate is not None else newest_feature(self.doc)
        set_step('GetTypeName2', 'new_feature_after')
        kind = str(feature.GetTypeName2()) if feature is not None else 'nothing'
        set_step('Name', 'new_feature_after')
        name = '' if feature is None else feature.Name
        shown = repr(name)
        if feature is None or name == before_name or (not re.search(wanted, kind, re.I)):
            set_step(api, 'new_feature_after')
            raise RuntimeError('%s created no %s feature (the newest feature is %s %s)%s%s' % (api, wanted.replace('|', ' or '), kind, shown, detail, selection_summary(self.doc)))
        return feature

    def feature_name(self):
        feature = newest_feature(self.doc)
        set_step('Name', 'feature_name')
        return '' if feature is None else feature.Name

    def helix_readback(self, feature, plan, label):
        """Log the definition SolidWorks shows for the helix (Height, Pitch, Revolution ...), then fail if it differs."""
        set_step('GetDefinition', 'helix_readback')
        data = feature.GetDefinition()
        if data is None:
            self.log('helix read-back', label + ': the helix definition is unavailable (IFeature.GetDefinition returned nothing)')
            return
        values = {}
        for member in ('DefinedBy', 'Height', 'Pitch', 'Revolution', 'StartingAngle', 'ReverseDirection', 'Clockwise', 'Taper', 'TaperAngle', 'TaperOutward', 'VariablePitch'):
            try:
                values[member] = getattr(data, member)
            except Exception:
                values[member] = None
        count = 'n/a'
        if plan['regions']:
            try:
                set_step('PitchCount', 'helix_readback')
                count = str(int(data.PitchCount))
            except Exception:
                count = 'unreadable'
        number = lambda key, scale=1.0: 'unreadable' if values[key] is None else '%.9g' % (float(values[key]) * scale)
        text = '%s: DefinedBy=%s Height=%s mm Pitch=%s mm Revolution=%s StartingAngle=%s deg Clockwise=%s ReverseDirection=%s Taper=%s TaperAngle=%s deg TaperOutward=%s VariablePitch=%s PitchCount=%s' % (label, values['DefinedBy'], number('Height', 1000), number('Pitch', 1000), number('Revolution'), number('StartingAngle', 180 / math.pi), values['Clockwise'], values['ReverseDirection'], values['Taper'], number('TaperAngle', 180 / math.pi), values['TaperOutward'], values['VariablePitch'], count)
        self.log('helix read-back', text)
        problems = []
        for member, wanted in sorted(plan['expect'].items()):
            if values[member] is not None and abs(float(values[member]) - wanted) > (1e-06 if member == 'Revolution' else 1e-09):
                problems.append('%s %.9g, expected %.9g' % (member, float(values[member]) * (1 if member == 'Revolution' else 1000), wanted * (1 if member == 'Revolution' else 1000)))
        if plan['regions'] and values['VariablePitch'] is not None and (not values['VariablePitch']):
            problems.append('VariablePitch False, expected a variable-pitch helix')
        if plan['regions'] and count.isdigit() and (int(count) != len(plan['regions'])):
            problems.append('PitchCount %s, expected %d regions' % (count, len(plan['regions'])))
        if problems:
            raise RuntimeError('the %s SolidWorks built differs from the recipe: %s (%s)' % (label, '; '.join(problems), text))

    def helix_spiral(self, p):
        """IModelDoc2.InsertHelix (constant pitch, taper, spiral) or the IFeatureManager variable-pitch sequence."""
        set_step('FeatureManager', 'helix_spiral')
        doc, fm = (self.doc, self.doc.FeatureManager)
        plan = helix_plan(p)
        label = '%s %s' % (p['kind'], p['name'])
        set_step('ClearSelection2', 'helix_spiral')
        doc.ClearSelection2(True)
        self.select_feature(check(self.refs.get(p['sketch']), 'helix sketch ' + p['sketch'] + ' was not built'), False, 0, 'helix sketch')
        before_name = self.feature_name()
        if plan['regions']:
            regions = plan['regions']
            candidate = probe_candidate if probe_candidate in VARIABLE_HELIX_CANDIDATES else VARIABLE_HELIX_CANDIDATES[0]
            defined = swHelixDefinedBy_HeightAndRevolution if candidate == 'height-revolution-rebuild' else swHelixDefinedBy_HeightAndPitch
            if candidate == 'height-revolution-rebuild':
                set_step('ClearSelection2', 'helix_spiral')
                doc.ClearSelection2(True)
                set_step('Name', 'helix_spiral')
                name = check(self.refs.get(p['sketch']), 'helix sketch ' + p['sketch'] + ' was not built').Name
                set_step('SelectByID2', 'helix_spiral')
                doc.Extension.SelectByID2(name, 'SKETCH', 0.0, 0.0, 0.0, False, 0, None, 0)
                set_step('GetSelectedObjectCount2', 'helix_spiral')
                if doc.SelectionManager.GetSelectedObjectCount2(-1) != 1:
                    raise RuntimeError('the helix sketch %r could not be selected by name' % name + selection_summary(doc))
            heights, total = ([0.0], 0.0)
            for (r0, p0, _d0), (r1, p1, _d1) in zip(regions, regions[1:]):
                total += (p0 + p1) / 2 * (r1 - r0)
                heights.append(total)
            self.probe_note = ''
            self.probe_add('%s: Helixdef %d' % (candidate, defined))
            returns = []
            if candidate == 'first-pitch-before-insert':
                set_step('AddVariablePitchHelixFirstPitchAndDiameter', 'helix_spiral')
                returns.append('F=' + self.helix_call('AddVariablePitchHelixFirstPitchAndDiameter', lambda: fm.AddVariablePitchHelixFirstPitchAndDiameter(regions[0][1], regions[0][2])))
            set_step('InsertVariablePitchHelix', 'helix_spiral')
            returns.append('I=' + self.helix_call('InsertVariablePitchHelix', lambda: fm.InsertVariablePitchHelix(plan['reverse'], plan['clockwise'], defined, plan['start'])))
            if candidate == 'segments-only-height-pitch':
                set_step('AddVariablePitchHelixSegment', 'helix_spiral')
                returns.append('S0=' + self.helix_call('AddVariablePitchHelixSegment', lambda: fm.AddVariablePitchHelixSegment(0.0, regions[0][2], regions[0][1])))
            elif candidate != 'first-pitch-before-insert':
                set_step('AddVariablePitchHelixFirstPitchAndDiameter', 'helix_spiral')
                returns.append('F=' + self.helix_call('AddVariablePitchHelixFirstPitchAndDiameter', lambda: fm.AddVariablePitchHelixFirstPitchAndDiameter(regions[0][1], regions[0][2])))
            for index, (revolutions, pitch, diameter) in enumerate(regions[1:], 1):
                set_step('AddVariablePitchHelixSegment', 'helix_spiral')
                returns.append('S%d=%s' % (index, self.helix_call('AddVariablePitchHelixSegment', lambda: fm.AddVariablePitchHelixSegment(heights[index], diameter, pitch))))
            self.probe_add(' '.join(returns))
            if candidate == 'height-revolution-rebuild':
                set_step('ForceRebuild3', 'helix_spiral')
                self.probe_add('rebuild=' + str(doc.ForceRebuild3(True)))
            self.probe_add(self.helix_state(doc, before_name))
            set_step('EndVariablePitchHelix', 'helix_spiral')
            candidate_feature = fm.EndVariablePitchHelix()
            self.probe_add('End=' + ('feature' if candidate_feature is not None else 'none'))
            feature = self.new_feature_after(before_name, 'EndVariablePitchHelix', 'helix|spiral', candidate_feature)
        else:
            set_step('InsertHelix', 'helix_spiral')
            doc.InsertHelix(plan['reverse'], plan['clockwise'], plan['tapered'], plan['outward'], plan['defined'], plan['height'], plan['pitch'], plan['revolutions'], plan['taper'], plan['start'])
            feature = self.new_feature_after(before_name, 'InsertHelix', 'helix|spiral')
        self.helix_readback(feature, plan, label)
        self.curves.add(p['name'])
        self.refs[p['name']] = feature
        return feature

    def probe_add(self, text):
        """Append to the probe note (kept even when the candidate fails)."""
        self.probe_note = (self.probe_note + '; ' if self.probe_note else '') + text

    def helix_call(self, name, call):
        """One variable-pitch API call that can never be fatal: its return as T / F / '-' (nothing), or the exception class."""
        try:
            returned = call()
        except Exception as exc:
            return 'ERR(%s)' % type(exc).__name__
        self.false_call(name, returned)
        return '-' if returned is None else 'T' if returned else 'F'

    def helix_state(self, doc, before_name):
        """Selection and sketch state just before EndVariablePitchHelix: what is selected (type letter + mark), whether a sketch is open."""
        try:
            set_step('ActiveSketch', 'helix_state')
            editing = 'no' if doc.SketchManager.ActiveSketch is None else 'yes'
        except Exception:
            editing = '?'
        return '%s edit=%s newest=%s' % (selection_detail(doc), editing, self.feature_name())

    def false_call(self, name, returned):
        """A Boolean API call that returned False: note it and go on; the created feature and its read-back decide."""
        if returned is False:
            record_mitigation('variable-helix-call-returned-false', always=True)
            self.log('helix', name + ' returned False; continuing, the helix feature and its read-back decide')

    def curve_start(self, feature):
        """The start point and unit tangent (meters) of a helix or spiral, evaluated on the curve SolidWorks built: the feature's
        IReferenceCurve, its first edge's ICurve at the start parameter (ICurve.GetEndParams, ICurve.Evaluate2 with one derivative)."""
        set_step('GetSpecificFeature2', 'curve_start')
        reference = check(feature.GetSpecificFeature2(), 'the helix feature has no reference curve (GetSpecificFeature2 returned nothing)')
        set_step('GetFirstSegment', 'curve_start')
        edge = check(reference.GetFirstSegment(), 'the helix has no first segment (IReferenceCurve.GetFirstSegment returned nothing)')
        set_step('GetCurve', 'curve_start')
        curve = check(edge.GetCurve(), 'the helix edge has no curve (IEdge.GetCurve returned nothing)')
        set_step('GetEndParams', 'curve_start')
        ends = curve.GetEndParams(None, None, None, None)
        start_parameter = float(ends[1]) if isinstance(ends, (tuple, list)) and len(ends) >= 3 else 0.0
        set_step('Evaluate2', 'curve_start')
        values = tuple((float(v) for v in check(curve.Evaluate2(start_parameter, 1), 'ICurve.Evaluate2 returned nothing')))
        if len(values) < 6:
            raise RuntimeError('ICurve.Evaluate2 returned %d values at the start parameter, expected the point and its first derivative' % len(values))
        length = math.sqrt(sum((v * v for v in values[3:6])))
        if length < 1e-12:
            raise RuntimeError('the helix has no tangent at its start parameter')
        return (values[:3], tuple((v / length for v in values[3:6])))

    def curve_segments(self, feature):
        """The edges of a helix or spiral in order (IReferenceCurve.GetFirstSegment, then GetNextSegment up to GetSegmentCount)."""
        set_step('GetSpecificFeature2', 'curve_segments')
        reference = check(feature.GetSpecificFeature2(), 'the helix feature has no reference curve (GetSpecificFeature2 returned nothing)')
        set_step('GetFirstSegment', 'curve_segments')
        edges = [check(reference.GetFirstSegment(), 'the helix has no first segment (IReferenceCurve.GetFirstSegment returned nothing)')]
        try:
            set_step('GetSegmentCount', 'curve_segments')
            count = int(reference.GetSegmentCount())
        except Exception:
            count = 1
        for _ in range(count - 1):
            set_step('GetNextSegment', 'curve_segments')
            edge = reference.GetNextSegment()
            if edge is None:
                break
            edges.append(edge)
        return edges

    def curve_end(self, feature):
        """The end point and unit tangent (meters) of the last segment of a helix or spiral, at its end parameter."""
        set_step('GetCurve', 'curve_end')
        curve = check(self.curve_segments(feature)[-1].GetCurve(), 'the helix edge has no curve (IEdge.GetCurve returned nothing)')
        set_step('GetEndParams', 'curve_end')
        ends = curve.GetEndParams(None, None, None, None)
        end_parameter = float(ends[2]) if isinstance(ends, (tuple, list)) and len(ends) >= 3 else 1.0
        set_step('Evaluate2', 'curve_end')
        values = tuple((float(v) for v in check(curve.Evaluate2(end_parameter, 1), 'ICurve.Evaluate2 returned nothing at the end parameter')))
        length = math.sqrt(sum((v * v for v in values[3:6])))
        if len(values) < 6 or length < 1e-12:
            raise RuntimeError('the helix has no usable tangent at its end parameter')
        return (values[:3], tuple((v / length for v in values[3:6])))

    def select_edge_vertex(self, feature, end):
        """The start vertex of the first edge (end False) or the end vertex of the last edge (end True) of the curve, selected by object
        (IVertex.Select4, mark 1): no view ray, so it cannot pick the other end of a helix that stands over its start."""
        doc = self.doc
        edges = self.curve_segments(feature)
        edge = edges[-1] if end else edges[0]
        set_step('GetEndVertex', 'select_edge_vertex')
        vertex = check(edge.GetEndVertex() if end else edge.GetStartVertex(), 'the helix edge has no %s vertex' % ('end' if end else 'start'))
        set_step('CreateSelectData', 'select_edge_vertex')
        data = doc.SelectionManager.CreateSelectData()
        set_step('Mark', 'select_edge_vertex')
        data.Mark = 1
        set_step('GetSelectedObjectCount2', 'select_edge_vertex')
        before = doc.SelectionManager.GetSelectedObjectCount2(-1)
        set_step('Select4', 'select_edge_vertex')
        vertex.Select4(True, data)
        set_step('GetSelectedObjectCount2', 'select_edge_vertex')
        if doc.SelectionManager.GetSelectedObjectCount2(-1) != before + 1:
            raise RuntimeError('the %s vertex of the helix could not be selected' % ('end' if end else 'start') + selection_summary(doc))
        return '%s vertex of the curve edge selected by object' % ('end' if end else 'start')

    def curve_length(self, feature):
        """Round 13 diagnostic (never fatal): the number of edges of the helix and their ICurve lengths (GetLength3 over the end parameters), mm."""
        try:
            edges = self.curve_segments(feature)
            total = 0.0
            for edge in edges:
                set_step('GetCurve', 'curve_length')
                curve = check(edge.GetCurve(), 'the helix edge has no curve')
                set_step('GetEndParams', 'curve_length')
                ends = curve.GetEndParams(None, None, None, None)
                low, high = (float(ends[1]), float(ends[2])) if isinstance(ends, (tuple, list)) and len(ends) >= 3 else (0.0, 1.0)
                set_step('GetLength3', 'curve_length')
                total += float(curve.GetLength3(low, high))
            self.diag['edges'], self.diag['length'] = (len(edges), total / MM)
        except Exception as exc:
            self.log('helix length', 'unavailable (%s)' % safe_error(exc))

    def circle_centre(self, segment):
        """Round 13 diagnostic (never fatal): where the circle center is after the Pierce relation (or without it): the sketch coordinates
        (ISketchPoint.X/Y/Z, m) and the model point behind them (mm), read through the sketch's own transform."""
        try:
            set_step('GetCenterPoint2', 'circle_centre')
            point = check(segment.GetCenterPoint2(), 'the circle center point is unavailable')
            local = (float(point.X), float(point.Y), float(point.Z))
            set_step('ArrayData', 'circle_centre')
            matrix = tuple((float(v) for v in self.doc.SketchManager.ActiveSketch.ModelToSketchTransform.ArrayData))
            model = tuple((v * 1000 for v in matrix_inverse_point(matrix, local))) if matrix_usable(matrix) else None
            self.diag['centre'] = model
            self.log('circle center', 'sketch (m) = %s; model (mm) = %s' % (unit_list(local), mm_list(model) if model else 'unknown'))
        except Exception as exc:
            self.log('circle center', 'unavailable (%s)' % safe_error(exc))

    def end_faces(self):
        """Round 13 diagnostic (never fatal): the center of the bounding box of every planar face of the swept body (mm): the two end caps of a
        tube. IFace2.GetBox is the box of the face, so a flat disc has its centre there."""
        try:
            centres = []
            for body in solid_bodies(self.doc):
                set_step('GetFaces', 'end_faces')
                for face in body.GetFaces() or ():
                    set_step('IsPlane', 'end_faces')
                    if face.GetSurface().IsPlane():
                        set_step('GetBox', 'end_faces')
                        box = tuple((float(v) for v in face.GetBox()))
                        centres.append(tuple(((box[i] + box[i + 3]) / 2 * 1000 for i in range(3))))
            self.diag['faces'] = centres
            self.log('end faces', '%d planar face(s) at (mm) %s' % (len(centres), '; '.join((mm_list(c) for c in centres))))
        except Exception as exc:
            self.log('end faces', 'unavailable (%s)' % safe_error(exc))

    def diagnostics_note(self):
        """The probe note, at most 300 characters: helix length and edges, curve start/end with tangents, the profile plane (origin, normal, angle
        to the start tangent), the circle centre and the planar face centres of the sweep (all mm, tangents and normals unit)."""
        d, parts = (self.diag, [])
        if 'length' in d:
            parts.append('L=%.5g n=%d' % (d['length'], d['edges']))
        if self.helix_start is not None and 'start' in d:
            parts.append('S=%s t=%s' % (mm_list([v / MM for v in d['start']]), unit_list(d['start_tangent'])))
        if 'end' in d:
            parts.append('E=%s t=%s' % (mm_list([v / MM for v in d['end']]), unit_list(d['end_tangent'])))
        if 'plane' in d:
            origin, normal, degrees = d['plane']
            parts.append('P=%s n=%s a=%.3g' % (mm_list([v / MM for v in origin]), unit_list(normal), degrees))
        if d.get('centre'):
            parts.append('C=' + mm_list(d['centre']))
        if 'faces' in d:
            parts.append('F=' + ';'.join((mm_list(c) for c in d['faces'][:3])))
        parts.append('pierce=' + d.get('pierce', 'n/a'))
        return ' '.join(parts)[:300]

    def plane_normal_to_curve(self, p):
        """A reference plane perpendicular to the curve at its START, read from the curve (the recipe's start_point is only the
        expectation: when SolidWorks starts the helix elsewhere, the plane and the profile circle follow SolidWorks)."""
        doc = self.doc
        curve = check(self.refs.get(p['curve']), 'curve ' + p['curve'] + ' was not built')
        expected = xyz(p['start_point'])
        start, tangent = self.curve_start(curve)
        self.helix_start, self.helix_tangent = (start, tangent)
        self.diag = dict(start=start, start_tangent=tangent)
        try:
            self.helix_end, self.helix_end_tangent = self.curve_end(curve)
            self.diag.update(end=self.helix_end, end_tangent=self.helix_end_tangent)
        except Exception as exc:
            self.helix_end = self.helix_end_tangent = None
            self.log('helix end', 'the curve end is unavailable (%s)' % safe_error(exc))
        self.curve_length(curve)
        if 'length' in self.diag:
            self.log('helix length', '%d edge(s), ICurve length %.6g mm' % (self.diag['edges'], self.diag['length']))
        fmt = lambda values: ', '.join(('%.9g' % (v / MM) for v in values))
        self.log('helix start', 'curve start (mm) = %s; tangent = %s; the recipe expected %s%s' % (fmt(start), ', '.join(('%.6g' % v for v in tangent)), fmt(expected), '' if math.dist(start, expected) <= 1e-06 else '; SolidWorks starts the curve elsewhere, the plane and the profile circle use its start'))
        is_probe, base, modifiers = plane_probe(probe_candidate)
        candidate = base if is_probe else 'curve-start-vertex'
        set_step('ClearSelection2', 'plane_normal_to_curve')
        doc.ClearSelection2(True)
        self.select_feature(curve, False, 0, 'helix (curve for the plane)', 'REFERENCECURVES')
        first = swRefPlaneReferenceConstraint_Perpendicular
        second = swRefPlaneReferenceConstraint_Coincident
        if candidate == 'origin-on-curve':
            first, second = (swRefPlaneReferenceConstraint_Perpendicular | swRefPlaneReferenceConstraint_OptionOriginOnCurve, 0)
            how = 'the helix only, constraint %d' % first
        elif candidate == '3d-sketch-point':
            how = self.select_sketch_point(start)
        elif candidate in ('edge-start-vertex', 'edge-end-vertex'):
            how = self.select_edge_vertex(curve, candidate == 'edge-end-vertex')
        else:
            how = 'start point selected as %s' % self.select_start_point(start)
        self.log('plane', '%s: %s' % (candidate, how))
        if is_probe:
            self.probe_note = self.diagnostics_note()
        summary = selection_summary(doc)
        before_name = self.feature_name()
        set_step('InsertRefPlane', 'plane_normal_to_curve')
        doc.FeatureManager.InsertRefPlane(first, 0.0, second, 0.0, 0, 0.0)
        feature = self.new_feature_after(before_name, 'InsertRefPlane', 'RefPlane', None, ' (perpendicular to the helix, coincident with its start; before the call)' + summary)
        self.refs[p['name']] = feature
        return feature

    def select_sweep_path(self, curve):
        """The helix as the sweep path (mark 4): the feature (as before), by name (SelectByID2 REFERENCECURVES), or every edge segment.
        Round 11: the sweep of W01b followed half a turn of four, W01f half a turn short; the mode is the part of the probe candidate after '+'."""
        doc = self.doc
        modifiers = plane_probe(probe_candidate)[2] if plane_probe(probe_candidate)[0] else frozenset()
        mode = 'path-by-name' if 'path-by-name' in modifiers else 'path-segments' if 'path-segments' in modifiers else ''
        set_step('GetSelectedObjectCount2', 'select_sweep_path')
        before = doc.SelectionManager.GetSelectedObjectCount2(-1)
        if mode == 'path-by-name':
            set_step('SelectByID2', 'select_sweep_path')
            doc.Extension.SelectByID2(curve.Name, 'REFERENCECURVES', 0.0, 0.0, 0.0, True, 4, None, 0)
            set_step('GetSelectedObjectCount2', 'select_sweep_path')
            if doc.SelectionManager.GetSelectedObjectCount2(-1) != before + 1:
                set_step('Name', 'select_sweep_path')
                raise RuntimeError('the sweep path %r could not be selected by name' % curve.Name + selection_summary(doc))
            self.log('sweep path', 'the helix selected by name')
        elif mode == 'path-segments':
            edges = self.curve_segments(curve)
            for edge in edges:
                set_step('CreateSelectData', 'select_sweep_path')
                data = doc.SelectionManager.CreateSelectData()
                set_step('Mark', 'select_sweep_path')
                data.Mark = 4
                set_step('Select4', 'select_sweep_path')
                edge.Select4(True, data)
            set_step('GetSelectedObjectCount2', 'select_sweep_path')
            if doc.SelectionManager.GetSelectedObjectCount2(-1) != before + len(edges):
                raise RuntimeError('the %d edge segments of the sweep path could not all be selected' % len(edges) + selection_summary(doc))
            self.log('sweep path', '%d edge segment(s) of the helix selected' % len(edges))
        else:
            self.select_feature(curve, True, 4, 'sweep path', 'REFERENCECURVES')

    def select_sketch_point(self, point):
        """A 3D sketch point at the helix start, selected as the plane's second reference."""
        set_step('SketchManager', 'select_sketch_point')
        doc, sm = (self.doc, self.doc.SketchManager)
        set_step('Insert3DSketch', 'select_sketch_point')
        sm.Insert3DSketch(True)
        check(create_entity(sm, 'CreatePoint', *point), 'sketch point creation failed')
        set_step('Insert3DSketch', 'select_sketch_point')
        sm.Insert3DSketch(True)
        sketch = check(newest_feature(doc), 'the 3D sketch of the start point was not created')
        set_step('GetSelectedObjectCount2', 'select_sketch_point')
        before = doc.SelectionManager.GetSelectedObjectCount2(-1)
        set_step('SelectByID2', 'select_sketch_point')
        doc.Extension.SelectByID2('Point1@' + sketch.Name, 'EXTSKETCHPOINT', float(point[0]), float(point[1]), float(point[2]), True, 1, None, 0)
        set_step('GetSelectedObjectCount2', 'select_sketch_point')
        if doc.SelectionManager.GetSelectedObjectCount2(-1) != before + 1:
            set_step('Name', 'select_sketch_point')
            raise RuntimeError('the 3D sketch point of %s could not be selected' % sketch.Name + selection_summary(doc))
        set_step('Name', 'select_sketch_point')
        return 'start point selected as EXTSKETCHPOINT on the 3D sketch ' + sketch.Name

    def verify_profile_plane(self):
        """The sketch plane must contain the helix start and be perpendicular to the helix there (1e-6 m, 1e-4 rad), by the sketch's
        own ModelToSketchTransform: the sketch z of the start is 0 and the sketch normal (column 3 of the rotation) is the tangent."""
        if self.helix_start is None:
            return
        set_step('ArrayData', 'verify_profile_plane')
        matrix = tuple((float(v) for v in self.doc.SketchManager.ActiveSketch.ModelToSketchTransform.ArrayData))
        if not matrix_usable(matrix):
            raise RuntimeError('the profile plane transform is unusable, so the plane could not be checked against the helix start')
        local = matrix_point(matrix, self.helix_start)
        normal = (matrix[2], matrix[5], matrix[8])
        angle = math.acos(min(1.0, abs(sum((a * b for a, b in zip(normal, self.helix_tangent))))))
        self.log('profile plane', 'helix start in the sketch (m) = %.9g, %.9g, %.9g; the plane normal is %.3g rad off the helix tangent' % (local + (angle,)))
        self.diag['plane'] = (matrix_inverse_point(matrix, (0.0, 0.0, 0.0)), normal, math.degrees(angle))
        if plane_probe(probe_candidate)[0]:
            self.probe_note = self.diagnostics_note()
        if abs(local[2]) > 1e-06 and self.helix_end is not None:
            far = matrix_point(matrix, self.helix_end)
            far_angle = math.acos(min(1.0, abs(sum((a * b for a, b in zip(normal, self.helix_end_tangent))))))
            self.log('profile plane', 'helix END in the sketch (m) = %.9g, %.9g, %.9g; the plane normal is %.3g rad off the tangent there' % (far + (far_angle,)))
            if abs(far[2]) <= 1e-06:
                record_mitigation('profile-plane-through-curve-end', primary_failed=True, always=True)
                mitigations['profile-plane-through-curve-end']['fallback_ok'] += 1
                self.helix_start, self.helix_tangent, local, angle = (self.helix_end, self.helix_end_tangent, far, far_angle)
                self.log('profile plane', 'the plane passes through the curve END, so the profile circle goes there')
        if abs(local[2]) > 1e-06:
            raise RuntimeError('the profile plane does not contain the helix start: its sketch z is %.9g m at the helix start' % local[2])
        if angle > 0.0001:
            raise RuntimeError('the profile plane is not perpendicular to the helix: its normal is %.3g rad off the helix tangent at the start' % angle)

    def profile_centre(self, c):
        """The circle center in the tilted profile plane: it must lie in that plane (sketch z = 0); log where it is."""
        self.log('profile circle', 'center in the profile plane sketch (m) = %.9g, %.9g, %.9g' % tuple(c[:3]))
        if abs(c[2]) > 1e-06:
            raise RuntimeError('the profile plane does not contain the helix start: its sketch z is %.9g m at the circle center' % c[2])
        return (c[0], c[1], 0.0)

    def pierce(self, segment, curve):
        """Add a Pierce relation between the circle center and the helix. The center is already placed at the helix start by
        the plane transform, so a relation that cannot be added is logged and skipped, never fatal."""
        doc = self.doc
        try:
            set_step('ClearSelection2', 'pierce')
            doc.ClearSelection2(True)
            set_step('GetCenterPoint2', 'pierce')
            centre = check(segment.GetCenterPoint2(), 'the circle center point is unavailable')
            set_step('CreateSelectData', 'pierce')
            data = doc.SelectionManager.CreateSelectData()
            set_step('Mark', 'pierce')
            data.Mark = 0
            set_step('Select4', 'pierce')
            centre.Select4(False, data)
            set_step('Select2', 'pierce')
            curve.Select2(True, 0)
            set_step('GetSelectedObjectCount2', 'pierce')
            held = doc.SelectionManager.GetSelectedObjectCount2(-1)
            if held != 2:
                raise RuntimeError('the selection holds %d entities, expected the center and the helix' % held)
            set_step('SketchAddConstraints', 'pierce')
            doc.SketchAddConstraints('sgATPIERCE')
            self.log('pierce', 'Pierce relation added between the circle center and the helix')
        except Exception as exc:
            record_mitigation('pierce-relation-skipped', primary_failed=True, always=True)
            mitigations['pierce-relation-skipped']['fallback_ok'] += 1
            self.log('pierce', 'Pierce relation not added (%s); the center stays where the plane transform put it, on the helix start' % safe_error(exc))
        finally:
            set_step('ClearSelection2', 'pierce')
            doc.ClearSelection2(True)

    def sketch(self, op):
        doc = self.doc
        self.three_d = op.get('three_d', False)
        set_step('ClearSelection2', 'sketch')
        doc.ClearSelection2(True)
        self.sketch_plane = ''
        self.profile_plane = None
        if op.get('three_d'):
            set_step('Insert3DSketch', 'sketch')
            doc.SketchManager.Insert3DSketch(True)
        elif op.get('on_plane'):
            self.sketch_plane = 'on_plane'
            self.select_feature(check(self.refs.get(op['on_plane']), 'profile plane ' + op['on_plane'] + ' was not built'), False, 0, 'profile plane')
        elif op.get('on_face'):
            self.sketch_plane = 'face'
            select(doc, resolve(doc, op['on_face']))
        else:
            planes = []
            set_step('FirstFeature', 'sketch')
            feature = doc.FirstFeature()
            while feature is not None:
                set_step('GetTypeName2', 'sketch')
                if feature.GetTypeName2() == 'RefPlane':
                    planes.append(feature)
                set_step('GetNextFeature', 'sketch')
                feature = feature.GetNextFeature()
            plane_name, offset = plane_parameters(op.get('plane', 'XY'))
            self.sketch_plane = plane_name
            self.profile_plane = (plane_name, offset)
            plane = planes[{'XY': 0, 'XZ': 1, 'YZ': 2}[plane_name]]
            set_step('Select2', 'sketch')
            check(plane.Select2(False, 0), 'plane selection failed')
            if offset:
                set_step('InsertRefPlane', 'sketch')
                check(doc.FeatureManager.InsertRefPlane(8, offset * MM, 0, 0, 0, 0), 'reference plane creation failed')
                set_step('ClearSelection2', 'sketch')
                doc.ClearSelection2(True)
                set_step('Select2', 'sketch')
                check(newest_feature(doc).Select2(False, 0), 'offset plane selection failed')
        set_step('SketchManager', 'sketch')
        sm = doc.SketchManager
        if not op.get('three_d'):
            set_step('InsertSketch', 'sketch')
            sm.InsertSketch(True)
        set_step('ActiveSketch', 'sketch')
        active = check(sm.ActiveSketch, 'sketch creation failed')
        for ent in op.get('entities', []):
            kind = ent.get('type', ent.get('kind', next(iter(ent))))
            ent = ent.get(kind, ent)
            if kind in ('rect_center', 'rect_2pt'):
                if kind == 'rect_center':
                    c = self.point(ent['c'])
                    w = ent['w'] * MM
                    h = ent['h'] * MM
                    p, q = ((c[0] - w / 2, c[1] - h / 2, 0), (c[0] + w / 2, c[1] + h / 2, 0))
                else:
                    p, q = (self.point(ent['p1']), self.point(ent['p2']))
                segments = check(create_entity(sm, 'CreateCornerRectangle', *p, *q), 'rectangle creation failed')
                if op.get('dims', True):
                    width = self.dimension(segments[0], abs(q[0] - p[0]), (q[0], p[1] - 0.005, 0))
                    self.dimension(segments[1], abs(q[1] - p[1]), (q[0] + 0.005, q[1], 0))
                    if self.width_dimension is None:
                        self.width_dimension = width
            elif kind == 'circle':
                if op.get('on_plane'):
                    self.verify_profile_plane()
                on_plane = bool(op.get('on_plane')) and self.helix_start is not None
                c = self.point([v / MM for v in self.helix_start] if on_plane else ent['c'])
                r = ent['r'] * MM
                if op.get('on_plane'):
                    c = self.profile_centre(c)
                segment = check(create_entity(sm, 'CreateCircleByRadius', *c, r), 'circle creation failed')
                if op.get('dims', True):
                    self.dimension(segment, 2 * r, (c[0] + r, c[1] + r, c[2]))
                if op.get('pierce'):
                    if 'no-pierce' in plane_probe(probe_candidate)[2]:
                        self.diag['pierce'] = 'off'
                        self.log('pierce', 'Pierce relation left out (candidate %s): the center stays on the plane origin, the helix start' % probe_candidate)
                    else:
                        self.diag['pierce'] = 'on'
                        self.pierce(segment, check(self.refs.get(op['pierce']), 'pierce curve ' + op['pierce'] + ' was not built'))
                    self.circle_centre(segment)
                    self.circle_radius = r
                    if plane_probe(probe_candidate)[0]:
                        self.probe_note = self.diagnostics_note()
            elif kind == 'line':
                p, q = (self.point(ent['a']), self.point(ent['b']))
                segment = check(create_entity(sm, 'CreateLine', *p, *q), 'line creation failed')
                set_step('ConstructionGeometry', 'sketch')
                segment.ConstructionGeometry = ent.get('construction', False)
                if op.get('dims', True):
                    self.dimension(segment, math.dist(p, q), q)
            elif kind == 'point':
                p = self.point(ent['p'])
                check(create_entity(sm, 'CreatePoint', *p), 'point creation failed')
            elif kind == 'arc':
                a, b, middle = (self.point(ent['a']), self.point(ent['b']), self.point(arc_middle(ent)))
                segment = check(create_entity(sm, 'Create3PointArc', *a, *b, *middle), 'arc creation failed')
                if op.get('dims', True) and 'r' in ent:
                    self.dimension(segment, ent['r'] * MM, middle)
        set_step('ClearSelection2', 'sketch')
        doc.ClearSelection2(True)
        if op.get('three_d'):
            set_step('Insert3DSketch', 'sketch')
            sm.Insert3DSketch(True)
        else:
            set_step('InsertSketch', 'sketch')
            sm.InsertSketch(True)
        if op.get('width_expression'):
            self.drive(check(self.width_dimension, 'sketch has no width dimension to drive'), op['width_expression'], 'sketch width')
        self.width_dimension = None
        return check(newest_feature(doc), 'closed sketch feature missing')

    def variable_fillet_documented(self, edge, radii, op):
        """Round 3 (revision 34.4.0): the call above returned no feature with the
        edge at mark 1 (P04d/e). Retry in the shape of the API Help's variable
        radius FeatureFillet3 example: options Propagate|UniformRadius|
        AttachEdges|KeepFeatures (195) and 0, not Empty, for unused arrays."""
        global call_inputs
        doc = self.doc
        record_mitigation('fillet3-variable-doc-example', primary_failed=True, always=True)
        call_inputs = 'first call: options=%d arrays=Empty%s' % (1 | 32 | (4 if op.get('transition') == 'straight' else 0), selection_summary(doc))
        set_step('GetSelectedObjectCount2', 'variable_fillet_documented')
        if doc.SelectionManager.GetSelectedObjectCount2(1) != 1:
            set_step('ClearSelection2', 'variable_fillet_documented')
            doc.ClearSelection2(True)
            select(doc, edge, False, 1)
        options = 195 | (4 if op.get('transition') == 'straight' else 0)
        set_step('FeatureFillet3', 'variable_fillet_documented')
        feature = doc.FeatureManager.FeatureFillet3(options, 0, 0, 0, 1, 0, 0, radii, 0, 0, 0, 0, 0, 0)
        if feature is not None:
            mitigations['fillet3-variable-doc-example']['fallback_ok'] += 1
        return feature

    def chamfer_reference_face(self, op):
        """Angle-distance chamfer whose first distance must run along ref_face (flip=True: along the
        other face). Which face the distance lands on is not stated in the InsertFeatureChamfer
        Help, so it is measured: the reference face's closest point to the old edge is d1 away when
        the distance runs along it and d1*tan(angle) away otherwise. A wrong side is deleted and
        rebuilt with the Flip option toggled once; anything else fails."""
        global call_inputs
        set_step('FeatureManager', 'chamfer_reference_face')
        doc, fm = (self.doc, self.doc.FeatureManager)
        d1, angle = (op['d1'] * MM, math.radians(op.get('angle', 45)))
        want_flipped = bool(op.get('flip'))
        along, across = (d1, d1 * math.tan(angle))
        wanted = across if want_flipped else along
        point = xyz(op['edge']['edge']['through'])
        flip_bit = want_flipped
        for attempt in range(2):
            set_step('ClearSelection2', 'chamfer_reference_face')
            doc.ClearSelection2(True)
            select(doc, resolve(doc, op['edge']))
            args = chamfer_arguments(dict(op, flip=flip_bit))
            call_inputs = 'InsertFeatureChamfer%s ref_face=%s flip option=%s' % (args, op['ref_face']['face'], flip_bit)
            set_step('InsertFeatureChamfer', 'chamfer_reference_face')
            feature = check(fm.InsertFeatureChamfer(*args), 'InsertFeatureChamfer returned no feature: ' + call_inputs + selection_summary(doc))
            ref = resolve(doc, op['ref_face'])
            set_step('GetClosestPointOn', 'chamfer_reference_face')
            measured = math.dist(tuple((float(v) for v in ref.GetClosestPointOn(*point)[:3])), point)
            if abs(measured - wanted) <= 1e-06 or abs(along - across) <= 1e-09:
                break
            other = along if want_flipped else across
            if attempt or abs(measured - other) > 1e-06:
                raise RuntimeError('chamfer: the reference face is %.6g m from the chamfered edge, expected %.6g m (distance on %s face) or %.6g m (distance on the other face) (%s)' % (measured, wanted, 'the other' if want_flipped else 'the reference', other, call_inputs))
            record_mitigation('chamfer-ref-face-flip-retry', primary_failed=True, always=True)
            set_step('ClearSelection2', 'chamfer_reference_face')
            doc.ClearSelection2(True)
            set_step('Select2', 'chamfer_reference_face')
            check(feature.Select2(False, 0), 'wrong-side chamfer selection failed')
            set_step('DeleteSelection2', 'chamfer_reference_face')
            check(doc.Extension.DeleteSelection2(0), 'DeleteSelection2 could not remove the chamfer built on the wrong face')
            flip_bit = not flip_bit
        if attempt:
            mitigations['chamfer-ref-face-flip-retry']['fallback_ok'] += 1
        return feature

    def variable_fillet_featuredata(self, edge, radii, op):
        """Round 5: both FeatureFillet3 shapes returned nothing on revision 34.4.0
        (P04d/e). The feature-data route: CreateDefinition(swFmFillet) gives an
        ISimpleFilletFeatureData2; Initialize(swFeatureFilletType_VariableRadius),
        the edge, then one SetRadius per end-vertex fillet item. The mapping from
        item to vertex is checked, never assumed: an item that is not a vertex at
        an edge end fails with its count/type in the message."""
        global call_inputs
        import pythoncom
        from win32com.client import VARIANT
        set_step('FeatureManager', 'variable_fillet_featuredata')
        doc, fm = (self.doc, self.doc.FeatureManager)
        record_mitigation('fillet-variable-featuredata', primary_failed=True, always=True)
        values = tuple((float(v) for v in radii.value))
        call_inputs += '; doc-example retry (options 195, arrays 0) also returned no feature; featuredata: Type=VariableRadius edge radii(m) start,end=%s' % (values,)
        if op.get('transition') == 'straight':
            raise RuntimeError('variable fillet feature data has no transition-type member (ISimpleFilletFeatureData2); the straight transition cannot be set on this route (' + call_inputs + ')')
        set_step('ClearSelection2', 'variable_fillet_featuredata')
        doc.ClearSelection2(True)
        set_step('CreateDefinition', 'variable_fillet_featuredata')
        data = check(fm.CreateDefinition(swFmFillet), 'CreateDefinition(swFmFillet) returned nothing: ' + call_inputs)
        set_step('Initialize', 'variable_fillet_featuredata')
        check(data.Initialize(swFeatureFilletType_VariableRadius), 'ISimpleFilletFeatureData2.Initialize(VariableRadius) returned False: ' + call_inputs)
        set_step('Edges', 'variable_fillet_featuredata')
        data.Edges = VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, (edge,))
        set_step('FilletItemsCount', 'variable_fillet_featuredata')
        count = data.FilletItemsCount
        accessed = False
        if count != 2:
            record_mitigation('fillet-variable-access-selections', primary_failed=True, always=True)
            first_count = count
            call_inputs += '; FilletItemsCount=%s right after Edges' % (count,)
            global variable_fillet_dead
            try:
                set_step('AccessSelections', 'variable_fillet_featuredata')
                accessed = bool(data.AccessSelections(doc, None))
            except Exception as exc:
                variable_fillet_dead = 'ISimpleFilletFeatureData2.AccessSelections failed with "%s" after FilletItemsCount was %s right after Edges, FeatureFillet3 returned no feature in both shapes, and the feature data has no other way to reach its fillet items (%s)' % (' '.join(safe_error(exc).split()), first_count, call_inputs)
                raise RuntimeError('variable fillet cannot be built on this SolidWorks revision: ' + variable_fillet_dead)
            call_inputs += '; AccessSelections returned %s' % (accessed,)
            set_step('Edges', 'variable_fillet_featuredata')
            data.Edges = VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, (edge,))
            set_step('FilletItemsCount', 'variable_fillet_featuredata')
            count = data.FilletItemsCount
            if count != 2:
                if accessed:
                    set_step('ReleaseSelectionAccess', 'variable_fillet_featuredata')
                    data.ReleaseSelectionAccess()
                raise RuntimeError('variable fillet feature data reports %s fillet items for one edge (%s before AccessSelections); two end-vertex items expected (%s)' % (count, first_count, call_inputs))
            mitigations['fillet-variable-access-selections']['fallback_ok'] += 1
        set_step('GetStartVertex', 'variable_fillet_featuredata')
        ends = [(edge.GetStartVertex(), values[0]), (edge.GetEndVertex(), values[1])]
        assigned = set()
        for index in range(count):
            set_step('GetFilletItemAtIndex', 'variable_fillet_featuredata')
            item = check(data.GetFilletItemAtIndex(index), 'GetFilletItemAtIndex(%d) returned nothing' % index)
            try:
                set_step('GetPoint', 'variable_fillet_featuredata')
                point = tuple((float(v) for v in item.GetPoint()[:3]))
            except Exception as exc:
                raise RuntimeError('fillet item %d is not a vertex (GetPoint failed: %s); cannot assign its radius (%s)' % (index, type(exc).__name__, call_inputs))
            set_step('GetPoint', 'variable_fillet_featuredata')
            match = [i for i, (vertex, _) in enumerate(ends) if math.dist(point, tuple((float(v) for v in vertex.GetPoint()[:3]))) <= TOL]
            if len(match) != 1 or match[0] in assigned:
                raise RuntimeError('fillet item %d at %s matches no unassigned edge end (%s)' % (index, point, call_inputs))
            assigned.add(match[0])
            set_step('SetRadius', 'variable_fillet_featuredata')
            data.SetRadius(item, ends[match[0]][1])
        if accessed:
            set_step('ReleaseSelectionAccess', 'variable_fillet_featuredata')
            data.ReleaseSelectionAccess()
        set_step('CreateFeature', 'variable_fillet_featuredata')
        feature = fm.CreateFeature(data)
        if feature is not None:
            mitigations['fillet-variable-featuredata']['fallback_ok'] += 1
        else:
            call_inputs += '; CreateFeature(ISimpleFilletFeatureData2) returned no feature'
        return feature

    def variable_fillet_candidate(self, name, edge, radii, op):
        """Round 15 probe candidates for P04d/e (see VARIABLE_FILLET_CANDIDATES): FeatureFillet3 with the help example's array shapes, FeatureFillet3 and
        FeatureFillet with one control point on the edge at mark 256, and CreateDefinition(swFmVarFillet) with CreateFeature. Nothing edits existing
        feature data or reads fillet selections. Every call is guarded and every return is noted."""
        global call_inputs
        import pythoncom
        from win32com.client import VARIANT
        set_step('FeatureManager', 'variable_fillet_candidate')
        doc, fm = (self.doc, self.doc.FeatureManager)
        values = tuple((float(v) for v in radii.value))
        options = 1 | 4 | 64 | 128
        call_inputs = 'candidate=%s radii(m) start,end=%s options=%d' % (name, values, options)
        self.probe_note = ''
        set_step('GetStartVertex', 'variable_fillet_candidate')
        vertices = (edge.GetStartVertex(), edge.GetEndVertex())
        self.probe_add('%s v0=%s v1=%s' % (name, vertex_text(vertices[0]), vertex_text(vertices[1])))
        before = self.feature_name()
        set_step('ClearSelection2', 'variable_fillet_candidate')
        doc.ClearSelection2(True)
        select(doc, edge, False, 1)
        if name == 'createfeature-varfillet-data':
            return self.variable_fillet_varfilletdata(vertices, values, before)

        def doubles(*numbers):
            return VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_R8, tuple((float(n) for n in numbers)))
        middle = (values[0] + values[1]) / 2.0
        if name != 'fillet3-help-sized-arrays':
            set_step('GetPoint', 'variable_fillet_candidate')
            points = [[float(v) for v in vertex.GetPoint()[:3]] for vertex in vertices]
            mid = [(points[0][i] + points[1][i]) / 2.0 for i in range(3)]
            try:
                set_step('SelectByID2', 'variable_fillet_candidate')
                chosen = doc.Extension.SelectByID2('', 'EDGE', mid[0], mid[1], mid[2], True, 256, None, 0)
            except Exception as exc:
                chosen = type(exc).__name__
            self.probe_add('cp=%s' % chosen)
        self.probe_add('before call ' + selection_detail(doc))
        if name == 'fillet3-help-sized-arrays':
            set_step('FeatureFillet3', 'variable_fillet_candidate')
            returned = fm.FeatureFillet3(options, values[0], 1e-07, 0, 1, 0, 0, radii, doubles(0, 0), doubles(0, 0), doubles(0, 0), None, None, None)
        elif name == 'fillet3-edge-plus-control-point':
            set_step('FeatureFillet3', 'variable_fillet_candidate')
            returned = fm.FeatureFillet3(options, values[0], 1e-07, 0, 1, 0, 0, radii, doubles(0, 0), doubles(0, 0), None, doubles(middle), doubles(0), doubles(0))
        elif name == 'featurefillet-edge-plus-control-point':
            set_step('FeatureFillet', 'variable_fillet_candidate')
            returned = fm.FeatureFillet(options, values[0], 1, 0, radii, None, doubles(middle))
        else:
            raise RuntimeError('unknown variable fillet candidate ' + name)
        return self.fillet_probe_result(returned, before)

    def fillet_probe_result(self, returned, before):
        """The feature of a fillet call: its return, else the newest feature when that is a new fillet; the return is noted."""
        doc = self.doc
        feature = returned if hasattr(returned, 'GetTypeName2') else None
        self.probe_add('ret=%s' % ('feature' if feature is not None else 'none' if returned is None else returned))
        if feature is None:
            newest = newest_feature(doc)
            set_step('Name', 'fillet_probe_result')
            if newest is not None and newest.Name != before and ('fillet' in newest.GetTypeName2().lower()):
                set_step('Name', 'fillet_probe_result')
                self.probe_add('newest=' + newest.Name)
                feature = newest
        return feature

    def variable_fillet_varfilletdata(self, vertices, values, before):
        """Candidate 4: CreateDefinition(swFmVarFillet) is IVariableFilletFeatureData2 (no Edges setter: the edge is the selection, mark 1), SetRadius
        on the two END VERTICES, then IFeatureManager.CreateFeature. Never fatal."""
        set_step('FeatureManager', 'variable_fillet_varfilletdata')
        fm = self.doc.FeatureManager
        steps = []

        def step(label, call):
            try:
                value = call()
                steps.append('%s=%s' % (label, 'ok' if value is None else 'T' if value is True else 'F' if value is False else value))
            except Exception as exc:
                steps.append('%s=ERR(%s)' % (label, type(exc).__name__))
        data = None
        try:
            set_step('CreateDefinition', 'variable_fillet_varfilletdata')
            data = fm.CreateDefinition(swFmVarFillet)
        except Exception as exc:
            steps.append('def=ERR(%s)' % type(exc).__name__)
        if data is None:
            self.probe_add(' '.join(steps) or 'def=none')
            return None
        set_step('FilletEdgeCount', 'variable_fillet_varfilletdata')
        step('ne', lambda: data.FilletEdgeCount)
        step('dr', lambda: setattr(data, 'DefaultRadius', values[0]))
        set_step('SetRadius', 'variable_fillet_varfilletdata')
        step('r0', lambda: data.SetRadius(vertices[0], values[0]))
        set_step('SetRadius', 'variable_fillet_varfilletdata')
        step('r1', lambda: data.SetRadius(vertices[1], values[1]))
        set_step('GetRadius', 'variable_fillet_varfilletdata')
        step('rb', lambda: '%g/%g' % (data.GetRadius(vertices[0]) * 1000, data.GetRadius(vertices[1]) * 1000))
        self.probe_add(' '.join(steps))
        returned = None
        try:
            set_step('CreateFeature', 'variable_fillet_varfilletdata')
            returned = fm.CreateFeature(data)
        except Exception as exc:
            self.probe_add('cf=ERR(%s)' % type(exc).__name__)
            return None
        return self.fillet_probe_result(returned, before)

    def fillet_data_counts(self, edge):
        """FilletItemsCount of throw-away variable-fillet feature data after each step (the data is never used to build anything)."""
        import pythoncom
        from win32com.client import VARIANT
        steps = []
        try:
            set_step('CreateDefinition', 'fillet_data_counts')
            data = self.doc.FeatureManager.CreateDefinition(swFmFillet)
            set_step('Initialize', 'fillet_data_counts')
            steps.append('init=%s' % (data.Initialize(swFeatureFilletType_VariableRadius),))
            set_step('FilletItemsCount', 'fillet_data_counts')
            steps.append('n0=%s' % (data.FilletItemsCount,))
            set_step('IsMultipleRadius', 'fillet_data_counts')
            data.IsMultipleRadius = True
            set_step('FilletItemsCount', 'fillet_data_counts')
            steps.append('n1=%s' % (data.FilletItemsCount,))
            set_step('Edges', 'fillet_data_counts')
            data.Edges = VARIANT(pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, (edge,))
            set_step('FilletItemsCount', 'fillet_data_counts')
            steps.append('n2=%s' % (data.FilletItemsCount,))
            set_step('GetFilletItemAtIndex', 'fillet_data_counts')
            item = data.GetFilletItemAtIndex(0)
            steps.append('item0=' + ('none' if item is None else item_kind(item)))
        except Exception as exc:
            steps.append('ERR(%s)' % type(exc).__name__)
        return 'items ' + ' '.join(steps)

    def profile_note(self, profile):
        """What is selected as the base flange profile, for the log: the feature's type and name, and the sketch's segment count when readable."""
        global step
        saved = step
        try:
            try:
                set_step('GetTypeName2', 'profile_note')
                text = 'profile feature type=%s name=%s' % (profile.GetTypeName2(), profile.Name)
            except Exception as exc:
                return ' [profile feature unreadable: %s]' % exc
            try:
                set_step('GetSketchSegments', 'profile_note')
                text += ' segments=%d' % len(profile.GetSpecificFeature2().GetSketchSegments())
            except Exception:
                text += ' segments=unreadable'
            return ' [' + text + ']'
        finally:
            step = saved

    def note_attempt(self, failures, text):
        """One failed base flange attempt: kept for the final error and written to the log at once (revision 29 lost them in a 438)."""
        failures.append(text)
        if self.folder is not None:
            log_line(self.folder, 'base flange attempt failed', text)

    def k_note(self, text):
        """One K-factor step, written to the log at once (revision 29 lost the result of the Sheet-Metal ModifyDefinition: nothing was logged)."""
        if self.folder is not None:
            log_line(self.folder, 'k-factor', text)

    def read_sheet_k(self, k):
        """(True when the Sheet-Metal feature now holds the K-factor k, what was read): ISheetMetalFeatureData.GetCustomBendAllowance().Type and
        .KFactor straight from IFeature.GetDefinition."""
        try:
            data = check(sheet_metal_data(self.doc), 'Sheet-Metal feature data unavailable')
            set_step('GetCustomBendAllowance', 'read_sheet_k')
            allowance = check(data.GetCustomBendAllowance(), 'GetCustomBendAllowance returned nothing')
            set_step('Type', 'read_sheet_k')
            kind, value = (allowance.Type, float(allowance.KFactor))
        except Exception as exc:
            return (False, 'unreadable (%s: %s)' % (type(exc).__name__, exc))
        return (kind == swBendAllowanceKFactor and abs(value - k) <= 1e-06, 'Type=%s KFactor=%.6g' % (kind, value))

    def guarded(self, tried, label, call):
        """call() under its own error guard: what it returned or raised goes into `tried` and the log; the answer is (ok, value)."""
        try:
            value = call()
        except Exception as exc:
            text = '%s raised %s: %s' % (label, type(exc).__name__, exc)
            tried.append(text)
            self.k_note(text)
            return (False, None)
        self.k_note('%s returned %s' % (label, value))
        return (True, value)

    def modify_sheet_k(self, tried, label, k, use_allowance_object):
        """One try on the Sheet-Metal feature: IFeature.GetDefinition, AccessSelections, the K-factor (the members, or the allowance object
        from GetCustomBendAllowance put back with SetCustomBendAllowance), ModifyDefinition, ReleaseSelectionAccess; every return is logged and
        the K-factor is read back at once."""
        sheet = check(find_feature(self.doc, 'SheetMetal'), 'no Sheet-Metal feature')
        set_step('GetDefinition', 'modify_sheet_k')
        data = check(sheet.GetDefinition(), 'Sheet-Metal feature data unavailable')
        set_step('AccessSelections', 'modify_sheet_k')
        accessed = check(data.AccessSelections(self.doc, None), 'ISheetMetalFeatureData.AccessSelections failed')
        self.k_note('%s: AccessSelections returned %s' % (label, accessed))
        try:
            if use_allowance_object:
                set_step('GetCustomBendAllowance', 'modify_sheet_k')
                allowance = check(data.GetCustomBendAllowance(), 'GetCustomBendAllowance returned nothing')
                set_step('Type', 'modify_sheet_k')
                allowance.Type = swBendAllowanceKFactor
                set_step('KFactor', 'modify_sheet_k')
                allowance.KFactor = k
                set_step('Type', 'modify_sheet_k')
                self.k_note('%s: allowance object set to Type=%s KFactor=%.6g' % (label, allowance.Type, float(allowance.KFactor)))
                set_step('SetCustomBendAllowance', 'modify_sheet_k')
                data.SetCustomBendAllowance(allowance)
            else:
                set_step('BendAllowanceType', 'modify_sheet_k')
                data.BendAllowanceType = swBendAllowanceKFactor
                set_step('KFactor', 'modify_sheet_k')
                data.KFactor = k
            set_step('ModifyDefinition', 'modify_sheet_k')
            modified = sheet.ModifyDefinition(data, self.doc, None)
        finally:
            set_step('ReleaseSelectionAccess', 'modify_sheet_k')
            data.ReleaseSelectionAccess()
        self.k_note('%s: ModifyDefinition returned %s' % (label, modified))
        ok, text = self.read_sheet_k(k)
        self.k_note('%s: read back %s' % (label, text))
        tried.append('%s: ModifyDefinition returned %s, read back %s' % (label, modified, text))
        return ok

    def modify_flange_k(self, tried, label, k):
        """The base flange feature's own definition (IFeature.GetDefinition of the SMBaseFlange feature; on SolidWorks 2021 it may hold the
        allowance): the allowance put on it, IFeature.ModifyDefinition, the K-factor read back from the Sheet-Metal feature."""
        flange = check(find_feature(self.doc, 'SMBaseFlange'), 'no base flange feature')
        set_step('GetDefinition', 'modify_flange_k')
        data = check(flange.GetDefinition(), 'base flange feature data unavailable')
        set_step('AccessSelections', 'modify_flange_k')
        accessed = check(data.AccessSelections(self.doc, None), 'IBaseFlangeFeatureData.AccessSelections failed')
        self.k_note('%s: AccessSelections returned %s' % (label, accessed))
        try:
            set_step('CreateCustomBendAllowance', 'modify_flange_k')
            allowance = check(self.doc.FeatureManager.CreateCustomBendAllowance(), 'CreateCustomBendAllowance returned nothing')
            set_step('Type', 'modify_flange_k')
            allowance.Type = swBendAllowanceKFactor
            set_step('KFactor', 'modify_flange_k')
            allowance.KFactor = k
            set_step('SetCustomBendAllowance', 'modify_flange_k')
            put_ok, _ = self.guarded(tried, label + ': SetCustomBendAllowance', lambda: data.SetCustomBendAllowance(allowance))
            set_step('ModifyDefinition', 'modify_flange_k')
            modified = flange.ModifyDefinition(data, self.doc, None)
        finally:
            set_step('ReleaseSelectionAccess', 'modify_flange_k')
            data.ReleaseSelectionAccess()
        self.k_note('%s: ModifyDefinition returned %s' % (label, modified))
        ok, text = self.read_sheet_k(k)
        self.k_note('%s: read back %s' % (label, text))
        tried.append('%s: SetCustomBendAllowance %s, ModifyDefinition returned %s, read back %s' % (label, 'accepted' if put_ok else 'refused', modified, text))
        return ok

    def gauge_state(self, data):
        """The gauge table and the sheet-metal parameters in force on the Sheet-Metal feature, read through their own guards and logged: (UseGaugeTable
        or None when it could not be read). ISheetMetalFeatureData.GetUseGaugeTable(ByRef, ByRef) is a method pair (Help), not a property."""
        import pythoncom
        from win32com.client import VARIANT
        use = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_BOOL, False)
        name = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_BSTR, '')
        parts, gauge = ([], None)
        try:
            set_step('GetUseGaugeTable', 'gauge_state')
            answer = data.GetUseGaugeTable(use, name)
            gauge = bool(use.value)
            parts.append('UseGaugeTable=%s GaugeTableFile=%s (GetUseGaugeTable returned %s)' % (gauge, name.value or 'none', answer))
        except Exception as exc:
            parts.append('GetUseGaugeTable raised %s: %s' % (type(exc).__name__, exc))
        for member in ('UseMaterialSheetMetalParameters', 'BendRadius', 'Thickness'):
            try:
                parts.append('%s=%s' % (member, getattr(data, member)))
            except Exception as exc:
                parts.append('%s raised %s: %s' % (member, type(exc).__name__, exc))
        self.k_note('Sheet-Metal feature state: ' + ' '.join(parts))
        return gauge

    def modify_sheet_gauge_off(self, tried, label, k):
        """Round 23 (sheetmetal-kfactor-gauge-off): a gauge table, or the material's sheet-metal parameters, in force on the Sheet-Metal feature would
        keep the K-factor the table gives (0.5 read back on SolidWorks 2021 after every ModifyDefinition). The state is read and logged, then in ONE
        ModifyDefinition: SetUseGaugeTable(False), UseMaterialSheetMetalParameters False and the K-factor allowance object put back (the Help's
        ISheetMetalFeatureData.GetCustomBendAllowance / SetCustomBendAllowance; the KFactor and BendAllowanceType members are obsolete)."""
        sheet = check(find_feature(self.doc, 'SheetMetal'), 'no Sheet-Metal feature')
        set_step('GetDefinition', 'modify_sheet_gauge_off')
        data = check(sheet.GetDefinition(), 'Sheet-Metal feature data unavailable')
        set_step('AccessSelections', 'modify_sheet_gauge_off')
        accessed = check(data.AccessSelections(self.doc, None), 'ISheetMetalFeatureData.AccessSelections failed')
        self.k_note('%s: AccessSelections returned %s' % (label, accessed))
        try:
            self.gauge_state(data)
            set_step('SetUseGaugeTable', 'modify_sheet_gauge_off')
            self.guarded(tried, label + ': SetUseGaugeTable(False)', lambda: data.SetUseGaugeTable(False, ''))
            self.guarded(tried, label + ': UseMaterialSheetMetalParameters=False', lambda: setattr(data, 'UseMaterialSheetMetalParameters', False))
            set_step('GetCustomBendAllowance', 'modify_sheet_gauge_off')
            allowance = check(data.GetCustomBendAllowance(), 'GetCustomBendAllowance returned nothing')
            set_step('Type', 'modify_sheet_gauge_off')
            allowance.Type = swBendAllowanceKFactor
            set_step('KFactor', 'modify_sheet_gauge_off')
            allowance.KFactor = k
            set_step('Type', 'modify_sheet_gauge_off')
            self.k_note('%s: allowance object set to Type=%s KFactor=%.6g' % (label, allowance.Type, float(allowance.KFactor)))
            set_step('SetCustomBendAllowance', 'modify_sheet_gauge_off')
            data.SetCustomBendAllowance(allowance)
            set_step('ModifyDefinition', 'modify_sheet_gauge_off')
            modified = sheet.ModifyDefinition(data, self.doc, None)
        finally:
            set_step('ReleaseSelectionAccess', 'modify_sheet_gauge_off')
            data.ReleaseSelectionAccess()
        self.k_note('%s: ModifyDefinition returned %s' % (label, modified))
        ok, text = self.read_sheet_k(k)
        self.k_note('%s: read back %s' % (label, text))
        tried.append('%s: ModifyDefinition returned %s, read back %s' % (label, modified, text))
        return ok

    def modify_flange_members(self, tried, label, k):
        """Round 23 (baseflange-kfactor-members-modify): the base flange's own K-factor members of the releases before 2022 (IBaseFlangeFeatureData
        OverrideKFactor and KFactor, with its UseGaugeTable off), set on the built flange and put back with IFeature.ModifyDefinition."""
        flange = check(find_feature(self.doc, 'SMBaseFlange'), 'no base flange feature')
        set_step('GetDefinition', 'modify_flange_members')
        data = check(flange.GetDefinition(), 'base flange feature data unavailable')
        set_step('AccessSelections', 'modify_flange_members')
        accessed = check(data.AccessSelections(self.doc, None), 'IBaseFlangeFeatureData.AccessSelections failed')
        self.k_note('%s: AccessSelections returned %s' % (label, accessed))
        try:
            put = [self.guarded(tried, label + ': UseGaugeTable=False', lambda: setattr(data, 'UseGaugeTable', False))[0], self.guarded(tried, label + ': OverrideKFactor=True', lambda: setattr(data, 'OverrideKFactor', True))[0], self.guarded(tried, label + ': KFactor=%.6g' % k, lambda: setattr(data, 'KFactor', k))[0]]
            set_step('ModifyDefinition', 'modify_flange_members')
            modified = flange.ModifyDefinition(data, self.doc, None)
        finally:
            set_step('ReleaseSelectionAccess', 'modify_flange_members')
            data.ReleaseSelectionAccess()
        self.k_note('%s: ModifyDefinition returned %s' % (label, modified))
        ok, text = self.read_sheet_k(k)
        self.k_note('%s: read back %s' % (label, text))
        tried.append('%s: members %s, ModifyDefinition returned %s, read back %s' % (label, 'accepted' if all(put) else 'refused', modified, text))
        return ok

    def set_sheet_k_factor(self, k, what):
        """The base flange was built without a K-factor of its own (no allowance object passed, or no Initialize on SolidWorks 2021), so the
        Sheet-Metal feature holds the default 0.5. Revision 29 (field 2026.11.24.4): ModifyDefinition with BendAllowanceType and KFactor set on
        the Sheet-Metal feature data returned and changed nothing, and nothing was logged. Each try is logged with its returns and is read back
        straight away: (0) those two members, (b) the ICustomBendAllowance from GetCustomBendAllowance set and put back with
        SetCustomBendAllowance (sheetmetal-kfactor-allowance-object), (c) the base flange feature's own definition
        (baseflange-kfactor-modify). When all fail the error says which were tried and what each read back."""
        ok, text = self.read_sheet_k(k)
        self.k_note('%s: the Sheet-Metal feature reads %s, wanted K-factor %.6g' % (what, text, k))
        if ok:
            return
        tried = []
        steps = (('members of the Sheet-Metal data', None, lambda label: self.modify_sheet_k(tried, label, k, False)), ('sheetmetal-kfactor-allowance-object', 'sheetmetal-kfactor-allowance-object', lambda label: self.modify_sheet_k(tried, label, k, True)), ('baseflange-kfactor-modify', 'baseflange-kfactor-modify', lambda label: self.modify_flange_k(tried, label, k)))
        if sw_major < BASEFLANGE_INITIALIZE_FROM:
            steps += (('sheetmetal-kfactor-gauge-off', 'sheetmetal-kfactor-gauge-off', lambda label: self.modify_sheet_gauge_off(tried, label, k)), ('baseflange-kfactor-members-modify', 'baseflange-kfactor-members-modify', lambda label: self.modify_flange_members(tried, label, k)))
        for label, mitigation, run in steps:
            if mitigation:
                record_mitigation(mitigation, primary_failed=True, always=True)
            try:
                done = run(label)
            except Exception as exc:
                tried.append('%s raised %s: %s' % (label, type(exc).__name__, exc))
                self.k_note(tried[-1])
                done = False
            if done:
                if mitigation:
                    mitigations[mitigation]['fallback_ok'] += 1
                if mitigation == 'sheetmetal-kfactor-gauge-off':
                    self.k_note('sheetmetal-kfactor-gauge-off: the K-factor %.6g took with the gauge table off and UseMaterialSheetMetalParameters False; the part is saved with the gauge table off' % k)
                return
        record_mitigation('kfactor-continue-diagnostic', primary_failed=True, always=True)
        self.k_failure = 'the K-factor %.6g did not take on the Sheet-Metal feature after the %s: %s (%s)' % (k, what, '; '.join(tried), call_inputs)
        self.k_note('kfactor-continue-diagnostic: ' + self.k_failure + '; the recipe goes on to its later features and is not saved')

    def base_flange_feature(self, profile, t, r, k, reverse, member='ReverseThickness'):
        """InsertSheetMetalBaseFlange2 returned no feature for every sheet-metal
        recipe on revision 34.4.0 (round 4) and on revision 29 (SolidWorks 2021,
        field 2026.11.24.3, where IBaseFlangeFeatureData also has no Initialize).
        Four attempts, each failure kept AND logged as it happens: the corrected
        call, the API Help example's argument shape, the IBaseFlangeFeatureData
        route (CreateDefinition(swFmBaseFlange); without Initialize if that
        raises), and the corrected call again with the profile sketch selected
        by SelectByID2 instead of IFeature.Select2. InsertSheetMetalBaseFlange
        (the older, non-2 method; round 23: its sixteen arguments are the first
        sixteen of the 2 method, from the Help) is tried on revisions before 30
        only, after the corrected call and the two verified forms."""
        global call_inputs
        set_step('FeatureManager', 'base_flange_feature')
        doc, fm = (self.doc, self.doc.FeatureManager)
        failures = []
        self.base_route = None
        base = 'Thickness(m)=%g ThickenDir=%s Radius(m)=%g KFactor=%g' % (t, reverse, r, k)

        def prepare(with_allowance=True, by_id=False):
            allowance = None
            if with_allowance:
                set_step('CreateCustomBendAllowance', 'prepare')
                allowance = check(fm.CreateCustomBendAllowance(), 'CreateCustomBendAllowance returned nothing')
                set_step('Type', 'prepare')
                allowance.Type = swBendAllowanceKFactor
                set_step('KFactor', 'prepare')
                allowance.KFactor = k
            set_step('ClearSelection2', 'prepare')
            doc.ClearSelection2(True)
            if by_id:
                set_step('SelectByID2', 'prepare')
                check(doc.Extension.SelectByID2(profile.Name, 'SKETCH', 0.0, 0.0, 0.0, False, 0, None, 0), 'base flange profile selection by SelectByID2 failed')
            else:
                set_step('Select2', 'prepare')
                check(profile.Select2(False, 0), 'base flange profile selection failed')
            return allowance
        allowance = prepare()
        call_inputs = base + ' first call: EndCondition1=Blind DirToUse=1 UseDefaultRelief=True UseFeatScope=False UseAutoSelect=False'
        set_step('InsertSheetMetalBaseFlange2', 'base_flange_feature')
        feature = fm.InsertSheetMetalBaseFlange2(t, reverse, r, 0.01, 0.0, False, swEndCondBlind, swEndCondBlind, 1, allowance, True, swSheetMetalReliefRectangular, t * 0.5, t * 0.5, 0.5, True, True, False, False)
        if feature is not None:
            self.base_route = 'insert'
            return feature
        self.note_attempt(failures, 'InsertSheetMetalBaseFlange2 (corrected call) returned no feature: ' + call_inputs + selection_summary(doc) + self.profile_note(profile))
        ways = 4
        if sw_major < BASEFLANGE_INITIALIZE_FROM:
            for name, with_allowance in (('baseflange-insert-verified-form', True), ('baseflange-insert-verified-form-no-allowance', False)):
                record_mitigation(name, primary_failed=True, always=True)
                call_inputs = base + ' verified form: ExtrudeDist1=0.01 ExtrudeDist2=0 DirToUse=1 PCBA=%s UseDefaultRelief=False ReliefType=Tear ReliefWidth=0.0001 ReliefDepth=0.0001 ReliefRatio=0.5 UseReliefRatio=True Merge=False UseFeatScope=True UseAutoSelect=True' % ('K-factor allowance' if with_allowance else 'Nothing')
                try:
                    allowance = prepare(with_allowance)
                    set_step('InsertSheetMetalBaseFlange2', 'base_flange_feature')
                    feature = fm.InsertSheetMetalBaseFlange2(t, reverse, r, 0.01, 0.0, False, swEndCondBlind, swEndCondBlind, 1, allowance, False, swSheetMetalReliefTear, 0.0001, 0.0001, 0.5, True, False, True, True)
                except Exception as exc:
                    self.note_attempt(failures, 'InsertSheetMetalBaseFlange2 (%s) raised %s: %s (%s)' % (name, type(exc).__name__, exc, call_inputs) + self.profile_note(profile))
                    continue
                if feature is not None:
                    mitigations[name]['fallback_ok'] += 1
                    self.set_sheet_k_factor(k, name + ' base flange')
                    self.base_route = 'insert'
                    return feature
                self.note_attempt(failures, 'InsertSheetMetalBaseFlange2 (%s) returned no feature: ' % name + call_inputs + selection_summary(doc) + self.profile_note(profile))
            ways = 7
            record_mitigation('baseflange-insert-v1', primary_failed=True, always=True)
            call_inputs = base + ' older method InsertSheetMetalBaseFlange (16 arguments), verified form: ExtrudeDist1=0.01 ExtrudeDist2=0 DirToUse=1 PCBA=K-factor allowance UseDefaultRelief=False ReliefType=Tear ReliefWidth=0.0001 ReliefDepth=0.0001 ReliefRatio=0.5 UseReliefRatio=True'
            try:
                allowance = prepare()
                set_step('InsertSheetMetalBaseFlange', 'base_flange_feature')
                feature = fm.InsertSheetMetalBaseFlange(t, reverse, r, 0.01, 0.0, False, swEndCondBlind, swEndCondBlind, 1, allowance, False, swSheetMetalReliefTear, 0.0001, 0.0001, 0.5, True)
            except Exception as exc:
                self.note_attempt(failures, 'InsertSheetMetalBaseFlange (baseflange-insert-v1) raised %s: %s (%s)' % (type(exc).__name__, exc, call_inputs) + self.profile_note(profile))
                feature = None
            if feature is not None:
                mitigations['baseflange-insert-v1']['fallback_ok'] += 1
                self.set_sheet_k_factor(k, 'baseflange-insert-v1 base flange')
                self.base_route = 'insert'
                return feature
            if not failures[-1].startswith('InsertSheetMetalBaseFlange (baseflange-insert-v1) raised'):
                self.note_attempt(failures, 'InsertSheetMetalBaseFlange (baseflange-insert-v1) returned no feature: ' + call_inputs + selection_summary(doc) + self.profile_note(profile))
        record_mitigation('baseflange-doc-example', primary_failed=True, always=True)
        prepare(False)
        call_inputs = base + ' doc-example shape: PCBA=Nothing DirToUse=0 UseDefaultRelief=True'
        set_step('InsertSheetMetalBaseFlange2', 'base_flange_feature')
        feature = fm.InsertSheetMetalBaseFlange2(t, reverse, r, 0.01, 0.0, False, swEndCondBlind, swEndCondBlind, 0, None, True, swSheetMetalReliefRectangular, 0.0, 0.0, 0.5, False, True, False, False)
        if feature is not None:
            mitigations['baseflange-doc-example']['fallback_ok'] += 1
            self.set_sheet_k_factor(k, 'doc-example base flange')
            self.base_route = 'insert'
            return feature
        self.note_attempt(failures, 'InsertSheetMetalBaseFlange2 (doc-example shape) returned no feature: ' + call_inputs + selection_summary(doc) + self.profile_note(profile))
        record_mitigation('baseflange-featuredata', primary_failed=True, always=True)
        feature, no_initialize, on_data_ok = (None, False, False)
        try:
            allowance = prepare()
            call_inputs = base + ' feature data: Initialize(UseMaterial=False, OverrideAllowance=True, relief Rectangular ratio 0.5) UseGaugeTable=False'
            set_step('CreateDefinition', 'base_flange_feature')
            data = check(fm.CreateDefinition(swFmBaseFlange), 'CreateDefinition(swFmBaseFlange) returned nothing')
            try:
                set_step('Initialize', 'base_flange_feature')
                data.Initialize(False, True, allowance, False, swSheetMetalReliefRectangular, True, 0.5, 0.0, 0.0)
            except Exception as exc:
                no_initialize = True
                record_mitigation('baseflange-featuredata-no-initialize', primary_failed=True, always=True)
                self.note_attempt(failures, 'IBaseFlangeFeatureData.Initialize raised %s: %s' % (type(exc).__name__, exc))
                call_inputs = base + ' feature data without Initialize: members set directly, default relief, K-factor set on the Sheet-Metal feature after CreateFeature'
            set_step('Thickness', 'base_flange_feature')
            data.Thickness = t
            if member == 'ReverseDirection':
                set_step('ReverseThickness', 'base_flange_feature')
                data.ReverseThickness = False
                set_step('ReverseDirection', 'base_flange_feature')
                data.ReverseDirection = reverse
            else:
                set_step('ReverseThickness', 'base_flange_feature')
                data.ReverseThickness = reverse
            set_step('BendRadius', 'base_flange_feature')
            data.BendRadius = r
            set_step('UseGaugeTable', 'base_flange_feature')
            data.UseGaugeTable = False
            if no_initialize:
                record_mitigation('baseflange-kfactor-on-data', primary_failed=True, always=True)
                on_data = []
                set_step('SetCustomBendAllowance', 'base_flange_feature')
                on_data_ok, _ = self.guarded(on_data, 'IBaseFlangeFeatureData.SetCustomBendAllowance', lambda: data.SetCustomBendAllowance(allowance))
                set_step('Type', 'base_flange_feature')
                self.guarded(on_data, 'IBaseFlangeFeatureData.GetCustomBendAllowance', lambda: (lambda a: 'nothing' if a is None else 'Type=%s KFactor=%.6g' % (a.Type, float(a.KFactor)))(data.GetCustomBendAllowance()))
                if sw_major < BASEFLANGE_INITIALIZE_FROM:
                    override_ok, _ = self.guarded(on_data, 'IBaseFlangeFeatureData.OverrideKFactor', lambda: setattr(data, 'OverrideKFactor', True))
                    factor_ok, _ = self.guarded(on_data, 'IBaseFlangeFeatureData.KFactor', lambda: setattr(data, 'KFactor', k))
                    on_data_ok = on_data_ok or (override_ok and factor_ok)
            set_step('ReverseThickness', 'base_flange_feature')
            call_inputs += ' %s=%s (read back: ReverseThickness=%s ReverseDirection=%s)' % (member, reverse, data.ReverseThickness, data.ReverseDirection)
            set_step('CreateFeature', 'base_flange_feature')
            feature = fm.CreateFeature(data)
        except Exception as exc:
            self.note_attempt(failures, 'IBaseFlangeFeatureData route failed with %s: %s (%s)' % (type(exc).__name__, exc, call_inputs) + selection_summary(doc) + self.profile_note(profile))
        if feature is not None:
            mitigations['baseflange-featuredata']['fallback_ok'] += 1
            if no_initialize:
                if self.read_sheet_k(k)[0]:
                    if abs(k - 0.5) <= 1e-09:
                        self.k_note('base flange built without Initialize: the K-factor %.6g reads right but is unverified (k equals the default 0.5)' % k)
                    elif on_data_ok:
                        mitigations['baseflange-kfactor-on-data']['fallback_ok'] += 1
                        self.k_note('base flange built without Initialize: the K-factor %.6g was taken from the allowance put on the feature data' % k)
                    else:
                        self.k_note('base flange built without Initialize: the K-factor %.6g reads right although SetCustomBendAllowance on the data did not return' % k)
                else:
                    self.set_sheet_k_factor(k, 'base flange built without Initialize')
                mitigations['baseflange-featuredata-no-initialize']['fallback_ok'] += 1
            self.base_route = 'featuredata'
            return feature
        if not failures[-1].startswith('IBaseFlangeFeatureData route failed'):
            self.note_attempt(failures, 'CreateFeature(IBaseFlangeFeatureData) returned no feature: ' + call_inputs + selection_summary(doc) + self.profile_note(profile))
        record_mitigation('baseflange-selectbyid', primary_failed=True, always=True)
        try:
            allowance = prepare(True, True)
            call_inputs = base + ' SelectByID2 selection: corrected call'
            set_step('InsertSheetMetalBaseFlange2', 'base_flange_feature')
            feature = fm.InsertSheetMetalBaseFlange2(t, reverse, r, 0.01, 0.0, False, swEndCondBlind, swEndCondBlind, 1, allowance, True, swSheetMetalReliefRectangular, t * 0.5, t * 0.5, 0.5, True, True, False, False)
        except Exception as exc:
            feature = None
            self.note_attempt(failures, 'SelectByID2 route failed with %s: %s (%s)' % (type(exc).__name__, exc, call_inputs) + self.profile_note(profile))
        if feature is not None:
            mitigations['baseflange-selectbyid']['fallback_ok'] += 1
            self.base_route = 'insert'
            return feature
        if not failures[-1].startswith('SelectByID2 route failed'):
            self.note_attempt(failures, 'InsertSheetMetalBaseFlange2 (profile selected with SelectByID2) returned no feature: ' + call_inputs + selection_summary(doc) + self.profile_note(profile))
        raise RuntimeError('base flange failed %s ways: ' % {4: 'four', 7: 'seven'}[ways] + '; '.join(failures))

    def flip_built_base_flange(self, member, tried):
        """Toggle ReverseThickness or ReverseDirection on the built base flange: IFeature.GetDefinition,
        IBaseFlangeFeatureData.AccessSelections, the member, IFeature.ModifyDefinition."""
        doc = self.doc
        flange = check(find_feature(doc, 'SMBaseFlange'), 'no base-flange feature to modify')
        set_step('GetDefinition', 'flip_built_base_flange')
        data = check(flange.GetDefinition(), 'base flange feature data unavailable')
        set_step('AccessSelections', 'flip_built_base_flange')
        check(data.AccessSelections(doc, None), 'IBaseFlangeFeatureData.AccessSelections failed')
        try:
            before = getattr(data, member)
            setattr(data, member, not before)
            set_step('ModifyDefinition', 'flip_built_base_flange')
            modified = flange.ModifyDefinition(data, doc, None)
        finally:
            set_step('ReleaseSelectionAccess', 'flip_built_base_flange')
            data.ReleaseSelectionAccess()
        tried.append('%s %s -> %s, ModifyDefinition returned %s' % (member, before, not before, modified))
        check(modified, 'ModifyDefinition could not toggle %s on the base flange (%s)' % (member, '; '.join(tried)))

    def base_flange(self, p):
        global call_inputs
        set_step('FeatureManager', 'base_flange')
        doc, fm = (self.doc, self.doc.FeatureManager)
        plane, offset = check(self.profile_plane, 'base flange profile plane unknown')
        axis_index, sign = signed_axis(p.get('direction', '+Z'))
        t, r, k = (p['thickness'] * MM, p.get('bend_radius', 1) * MM, p.get('k_factor', 0.44))
        profile = self.reference('last')
        want_near, want_far = (offset, offset + sign * p['thickness'])

        def judge():
            near, far = (measured_extreme(doc, axis_index, -sign), measured_extreme(doc, axis_index, sign))
            if abs(near - want_near) <= 0.001 and abs(far - want_far) <= 0.001:
                return ('ok', near, far)
            if abs(far - offset) <= 0.001 and abs(near - (offset - sign * p['thickness'])) <= 0.001:
                return ('wrong', near, far)
            return ('other', near, far)

        def refuse(near, far):
            raise RuntimeError('base flange thickness is not on the %s side of its sketch: extent %.4f..%.4f mm, sketch plane at %.4f mm, thickness %.4g mm (%s)' % (p.get('direction', '+Z'), min(near, far), max(near, far), offset, p['thickness'], call_inputs))

        def undo():
            set_step('EditUndo2', 'undo')
            doc.EditUndo2(1)
            if find_feature(doc, 'SheetMetal') is not None:
                raise RuntimeError('EditUndo2 did not remove the base flange built on the wrong side (%s)' % call_inputs)
        feature = self.base_flange_feature(profile, t, r, k, False)
        verdict, near, far = judge()
        if verdict == 'other':
            refuse(near, far)
        if verdict == 'wrong':
            record_mitigation('baseflange-thicken-reverse', primary_failed=True, always=True)
            undo()
            feature = self.base_flange_feature(profile, t, r, k, True)
            verdict, near, far = judge()
            if verdict == 'ok':
                mitigations['baseflange-thicken-reverse']['fallback_ok'] += 1
            elif verdict == 'other' or (self.base_route != 'featuredata' and sw_major >= BASEFLANGE_INITIALIZE_FROM):
                refuse(near, far)
            else:
                if self.base_route == 'featuredata':
                    record_mitigation('baseflange-reverse-direction', primary_failed=True, always=True)
                    undo()
                    feature = self.base_flange_feature(profile, t, r, k, True, 'ReverseDirection')
                    verdict, near, far = judge()
                    if verdict == 'ok':
                        mitigations['baseflange-reverse-direction']['fallback_ok'] += 1
                    elif verdict == 'other':
                        refuse(near, far)
                if verdict == 'wrong':
                    record_mitigation('baseflange-modify-reverse', primary_failed=True, always=True)
                    undo()
                    feature = self.base_flange_feature(profile, t, r, k, False)
                    verdict, near, far = judge()
                    tried = []
                    for member in ('ReverseThickness', 'ReverseDirection'):
                        if verdict == 'ok':
                            break
                        if verdict == 'other':
                            refuse(near, far)
                        self.flip_built_base_flange(member, tried)
                        verdict, near, far = judge()
                        tried.append('%s -> extent %.4f..%.4f mm' % (member, min(near, far), max(near, far)))
                        if verdict == 'wrong' and member == 'ReverseThickness':
                            self.flip_built_base_flange(member, tried)
                            verdict, near, far = judge()
                    if verdict != 'ok':
                        raise RuntimeError('base flange thickness stays on the wrong side of its sketch after the reverse flag before CreateFeature, ReverseDirection and a ModifyDefinition toggle of each (%s; %s)' % (call_inputs, '; '.join(tried)))
                    mitigations['baseflange-modify-reverse']['fallback_ok'] += 1
        self.sheet = dict(p, normal=axis_index)
        if self.folder is not None:
            log_line(self.folder, 'option', 'base flange: corner_relief and corner_gap have no Sheet-Metal setting in SolidWorks; they belong to Corner Relief features and a flat base flange has no corners')
        return feature

    def flange_profile(self, p, edge, a, b, span, angle, height, axis_index, sign):
        """One edge's profile sketch (the API Help edge-flange example); returns the sketch."""
        global call_inputs
        set_step('SketchManager', 'flange_profile')
        doc, sm = (self.doc, self.doc.SketchManager)
        call_inputs = 'DAngle(rad)=%g FlipDir=False edge(mm)=%s..%s' % (angle, a, b)
        set_step('InsertSketchForEdgeFlange', 'flange_profile')
        sketch_feature = check(doc.InsertSketchForEdgeFlange(edge, angle, False), 'InsertSketchForEdgeFlange returned no sketch: ' + call_inputs)
        set_step('ClearSelection2', 'flange_profile')
        doc.ClearSelection2(True)
        set_step('Select2', 'flange_profile')
        check(sketch_feature.Select2(False, 0), 'edge flange sketch selection failed')
        set_step('EditSketch', 'flange_profile')
        doc.EditSketch()
        set_step('ActiveSketch', 'flange_profile')
        profile = check(sm.ActiveSketch, 'edge flange profile sketch is not active')
        set_step('ArrayData', 'flange_profile')
        matrix = tuple((float(v) for v in profile.ModelToSketchTransform.ArrayData))
        if not matrix_usable(matrix):
            raise RuntimeError('edge flange profile sketch: ModelToSketchTransform matrix unusable: ' + ','.join(('%.9g' % v for v in matrix)))
        if span is None:
            select(doc, edge)
            set_step('SketchUseEdge3', 'flange_profile')
            check(sm.SketchUseEdge3(False, False), 'SketchUseEdge3 did not convert the flange edge')
            set_step('GetSketchSegments', 'flange_profile')
            segments = check(profile.GetSketchSegments(), 'converted flange edge missing from the profile sketch')
            line = api_interface(segments[0], 'SketchLine')
            set_step('GetStartPoint2', 'flange_profile')
            points = [line.GetStartPoint2(), line.GetEndPoint2()]
            pa, pb = ((float(q.X), float(q.Y)) for q in points)
        else:
            pa, pb = (matrix_point(matrix, xyz(q))[:2] for q in span)
        du, dv = profile_offset(matrix, pa, pb, height, axis_index, sign)
        loop = [pa, (pa[0] + du, pa[1] + dv), (pb[0] + du, pb[1] + dv), pb] + ([pa] if span else [])
        for q0, q1 in zip(loop, loop[1:]):
            check(create_entity(sm, 'CreateLine', q0[0], q0[1], 0.0, q1[0], q1[1], 0.0), 'edge flange profile line failed')
        set_step('ClearSelection2', 'flange_profile')
        doc.ClearSelection2(True)
        set_step('InsertSketch', 'flange_profile')
        sm.InsertSketch(True)
        return profile

    def edge_flange(self, p):
        global call_inputs
        doc = self.doc
        many = len(p['edges']) > 1
        if many and sw_major < 30:
            raise NotScripted('sheetmetal flange on several edges: the Corner Relief feature (ICornerReliefFeatureData) needs SolidWorks 2022 (revision 30) or newer; this is revision ' + str(sw_major))
        edges = [resolve(doc, query) for query in p['edges']]
        settings = flange_settings(p, self.sheet)
        axis_index, sign = signed_axis(p.get('direction', '+Z'))
        angle, height = (math.radians(p['angle']), p['height'] * MM)
        profile_height, offset_height = (height, height)
        flange_reference = ''
        if many:
            flange_reference = probe_candidate or CORNER_CANDIDATES[0]
            profile_height, offset_height = multi_edge_lengths(flange_reference, height, self.sheet['thickness'] * MM)
        profiles, ends = ([], [])
        for edge in edges:
            set_step('GetPoint', 'edge_flange')
            a, b = (tuple((float(v) * 1000 for v in vertex.GetPoint()[:3])) for vertex in (edge.GetStartVertex(), edge.GetEndVertex()))
            span = flange_span(p, a, b)
            ends.append(span)
            profiles.append(self.flange_profile(p, edge, a, b, span, angle, profile_height, axis_index, sign))
        call_inputs = 'OffsetDistance(m)=%g BendAngle(rad)=%g OffsetDimType=%d PositionType=%d radius(mm)=%s k_factor=%s relief=%s span=%s edges=%d%s' % (offset_height, angle, settings['dim'], settings['position'], settings['radius'] or 'default', settings['k_factor'] or 'default', settings['relief'], ends[0] or 'full', len(edges), ' GapDistance(m)=%g profile(m)=%g flange=%s' % (p['corner_gap'] * MM, profile_height, flange_reference) if many else '')
        feature = self.edge_flange_feature(p, edges, profiles, angle, offset_height, settings, many)
        set_step('GetTypeName2', 'edge_flange')
        if feature.GetTypeName2() != 'EdgeFlange':
            set_step('GetTypeName2', 'edge_flange')
            raise RuntimeError('CreateFeature(edge flange) returned a %s feature' % feature.GetTypeName2())
        if settings['radius'] or settings['k_factor']:
            self.flange_bend_readback(feature, settings)
        if self.folder is not None and (settings['dim'] != 1 or settings['position'] != 1):
            log_line(self.folder, 'option', 'flange option chosen: length measured to the %s, position %s' % ('inner virtual sharp' if settings['dim'] == 2 else 'outer virtual sharp', 'material outside' if settings['position'] == 2 else 'material inside'))
        self.flange_axis = (axis_index, sign)
        if many:
            self.corner_relief(p, feature)
        return feature

    def edge_note(self, text):
        """One edge-flange step, written to the log at once (revision 29: CreateFeature answered Nothing and the data setup was not in the log)."""
        if self.folder is not None:
            log_line(self.folder, 'edge flange', text)

    def edge_flange_data(self, edges, profiles, angle, offset_height, settings, many, p, example_order):
        """IEdgeFlangeFeatureData for the edge flange: CreateDefinition, AddEdges and the members, each put under its own guard whose failure
        (an Err 438, a refusal) is logged and returned in `notes`, and its answer read back. There is no Initialize on this interface: the members
        are set directly. example_order puts them in the order of the API Help "Create Edge Flange" example (the radius first, the flange's own
        allowance fetched from the data with GetCustomBendAllowance); the other order is the builder's first one."""
        import pythoncom
        from win32com.client import VARIANT
        set_step('FeatureManager', 'edge_flange_data')
        fm = self.doc.FeatureManager
        set_step('CreateDefinition', 'edge_flange_data')
        data = check(fm.CreateDefinition(swFmEdgeFlange), 'CreateDefinition(swFmEdgeFlange) returned nothing')
        notes = []
        dispatch = pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH
        set_step('AddEdges', 'edge_flange_data')
        errors = data.AddEdges(VARIANT(dispatch, tuple(edges)), VARIANT(dispatch, tuple(profiles)))
        self.edge_note('IEdgeFlangeFeatureData.AddEdges returned %s for %d edge(s)' % (errors, len(edges)))
        if errors != 0:
            raise RuntimeError('IEdgeFlangeFeatureData.AddEdges returned swEdgeFlangeError_e %s' % errors)

        def put(name, value):
            try:
                setattr(data, name, value)
            except Exception as exc:
                notes.append('IEdgeFlangeFeatureData.%s raised %s: %s' % (name, type(exc).__name__, exc))
                self.edge_note(notes[-1])

        def allowance_steps():
            put('UseDefaultBendAllowance', not settings['k_factor'])
            if settings['k_factor']:
                try:
                    if example_order:
                        set_step('GetCustomBendAllowance', 'allowance_steps')
                        allowance = check(data.GetCustomBendAllowance(), 'IEdgeFlangeFeatureData.GetCustomBendAllowance returned nothing')
                    else:
                        set_step('CreateCustomBendAllowance', 'allowance_steps')
                        allowance = check(fm.CreateCustomBendAllowance(), 'CreateCustomBendAllowance returned nothing')
                    set_step('Type', 'allowance_steps')
                    allowance.Type = swBendAllowanceKFactor
                    set_step('KFactor', 'allowance_steps')
                    allowance.KFactor = settings['k_factor']
                    set_step('SetCustomBendAllowance', 'allowance_steps')
                    data.SetCustomBendAllowance(allowance)
                except Exception as exc:
                    notes.append('the flange allowance raised %s: %s' % (type(exc).__name__, exc))
                    self.edge_note(notes[-1])

        def radius_steps():
            put('UseDefaultBendRadius', not settings['radius'])
            if settings['radius']:
                put('BendRadius', settings['radius'] * MM)

        def size_steps():
            put('BendAngle', angle)
            put('OffsetType', swFlangeOffsetBlind)
            put('OffsetDistance', offset_height)
            put('OffsetDimType', settings['dim'])
            put('PositionType', settings['position'])
            put('UsePositionOffset', False)

        def relief_steps():
            mode, relief_type, width, depth = settings['relief']
            put('UseDefaultBendRelief', mode == 0)
            if mode:
                put('AutoReliefType', relief_type)
                put('UseReliefRatio', mode == 1)
                if mode == 1:
                    put('ReliefRatio', 0.5)
                else:
                    put('ReliefWidth', width * MM)
                    put('ReliefDepth', depth * MM)
        if example_order:
            radius_steps()
            if many:
                put('GapDistance', p['corner_gap'] * MM)
            size_steps()
            allowance_steps()
            relief_steps()
        else:
            size_steps()
            allowance_steps()
            radius_steps()
            relief_steps()
            if many:
                put('GapDistance', p['corner_gap'] * MM)
        return (data, notes)

    def edge_flange_feature(self, p, edges, profiles, angle, offset_height, settings, many):
        """CreateFeature(edge flange). Revision 29 (SolidWorks 2021, field 2026.11.24.4): CreateFeature answered Nothing for every edge flange
        and the data setup was not in the log. Now every member put is guarded and logged, and the flange is tried three ways, each failure
        logged as it happens: the data as built, the data again with the members set directly in the API Help example's order after a rebuild
        (edgeflange-featuredata-no-initialize: IEdgeFlangeFeatureData has no Initialize), and the older IFeatureManager.InsertSheetMetalEdgeFlange2
        (edgeflange-legacy-insert; its argument list is from SolidWorks API Help, help.solidworks.com, "InsertSheetMetalEdgeFlange2 Method
        (IFeatureManager)", obsolete since it was superseded by CreateDefinition and CreateFeature, available since SolidWorks 2007)."""
        global call_inputs
        import pythoncom
        from win32com.client import VARIANT
        set_step('FeatureManager', 'edge_flange_feature')
        doc, fm = (self.doc, self.doc.FeatureManager)
        inputs, failures = (call_inputs, [])

        def refused(label, notes):
            text = '%s returned no feature: %s%s%s' % (label, inputs, ' (%s)' % '; '.join(notes) if notes else '', selection_summary(doc))
            failures.append(text)
            self.edge_note('attempt failed: ' + text)
        data, notes = self.edge_flange_data(edges, profiles, angle, offset_height, settings, many, p, False)
        set_step('ClearSelection2', 'edge_flange_feature')
        doc.ClearSelection2(True)
        set_step('CreateFeature', 'edge_flange_feature')
        feature = fm.CreateFeature(data)
        if feature is not None:
            return feature
        refused('CreateFeature(edge flange)', notes)
        record_mitigation('edgeflange-featuredata-no-initialize', primary_failed=True, always=True)
        set_step('EditRebuild3', 'edge_flange_feature')
        rebuilt = doc.EditRebuild3()
        self.edge_note('EditRebuild3 returned %s before the second try' % rebuilt)
        data, notes = self.edge_flange_data(edges, profiles, angle, offset_height, settings, many, p, True)
        set_step('ClearSelection2', 'edge_flange_feature')
        doc.ClearSelection2(True)
        set_step('CreateFeature', 'edge_flange_feature')
        feature = fm.CreateFeature(data)
        if feature is not None:
            mitigations['edgeflange-featuredata-no-initialize']['fallback_ok'] += 1
            return feature
        refused('CreateFeature(edge flange, members set directly in the API Help example order)', notes)
        record_mitigation('edgeflange-legacy-insert', primary_failed=True, always=True)
        if many:
            failures.append('InsertSheetMetalEdgeFlange2 not tried: it has no corner gap or corner relief for several edges')
            self.edge_note('attempt skipped: ' + failures[-1])
        else:
            mode, relief_type, width, depth = settings['relief']
            options = (1 if not settings['radius'] else 0) | (128 if mode == 0 else 0) | (64 if mode == 1 else 0)
            allowance = None
            if settings['k_factor']:
                set_step('CreateCustomBendAllowance', 'edge_flange_feature')
                allowance = check(fm.CreateCustomBendAllowance(), 'CreateCustomBendAllowance returned nothing')
                set_step('Type', 'edge_flange_feature')
                allowance.Type = swBendAllowanceKFactor
                set_step('KFactor', 'edge_flange_feature')
                allowance.KFactor = settings['k_factor']
            dispatch = pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH
            set_step('ClearSelection2', 'edge_flange_feature')
            doc.ClearSelection2(True)
            inputs += ' InsertSheetMetalEdgeFlange2 options=%d radius(m)=%g ratio=0.5 width(m)=%g depth(m)=%g' % (options, settings['radius'] * MM, width * MM, depth * MM)
            set_step('InsertSheetMetalEdgeFlange2', 'edge_flange_feature')
            feature = fm.InsertSheetMetalEdgeFlange2(VARIANT(dispatch, tuple(edges)), VARIANT(dispatch, tuple(profiles)), options, angle, settings['radius'] * MM, settings['position'], offset_height, relief_type, 0.5, width * MM, depth * MM, settings['dim'], allowance)
            if feature is not None:
                mitigations['edgeflange-legacy-insert']['fallback_ok'] += 1
                return feature
            refused('InsertSheetMetalEdgeFlange2', [])
        call_inputs = inputs
        raise RuntimeError('CreateFeature(edge flange) returned no feature: ' + inputs + '; ' + '; '.join(failures))

    def flange_bend_readback(self, feature, settings):
        """S02j: IFeature.GetDefinition on the built flange; its own bend radius and K-factor must have stuck."""
        set_step('GetDefinition', 'flange_bend_readback')
        data = check(feature.GetDefinition(), 'edge flange feature data unavailable for the bend read-back')
        text, failures = ([], [])
        set_step('UseDefaultBendRadius', 'flange_bend_readback')
        use_radius, radius = (bool(data.UseDefaultBendRadius), float(data.BendRadius) * 1000)
        text.append('UseDefaultBendRadius=%s BendRadius=%.6g mm' % (use_radius, radius))
        if settings['radius'] and (use_radius or abs(radius - settings['radius']) > 0.0001):
            failures.append('bend radius %.6g mm (default %s), wanted %.6g' % (radius, use_radius, settings['radius']))
        set_step('UseDefaultBendAllowance', 'flange_bend_readback')
        use_allowance = bool(data.UseDefaultBendAllowance)
        set_step('GetCustomBendAllowance', 'flange_bend_readback')
        allowance = data.GetCustomBendAllowance()
        set_step('KFactor', 'flange_bend_readback')
        k_value = None if allowance is None else float(allowance.KFactor)
        set_step('Type', 'flange_bend_readback')
        text.append('UseDefaultBendAllowance=%s allowance type=%s KFactor=%s' % (use_allowance, None if allowance is None else allowance.Type, 'unavailable' if k_value is None else '%.6g' % k_value))
        set_step('Type', 'flange_bend_readback')
        if settings['k_factor'] and (use_allowance or allowance is None or allowance.Type != swBendAllowanceKFactor or (abs(k_value - settings['k_factor']) > 1e-06)):
            failures.append('K-factor %s (default %s), wanted %.6g' % (k_value, use_allowance, settings['k_factor']))
        text = 'edge flange bend read-back: ' + '; '.join(text)
        if self.folder is not None:
            log_line(self.folder, 'option', text)
        if failures:
            raise RuntimeError('the flange kept ' + ' and '.join(failures) + ': ' + text)

    def corner_relief(self, p, flange):
        """Two-bend Corner Relief feature (ICornerReliefFeatureData, SolidWorks 2022+) on
        the corners the multi-edge flange created. The relief type is mapped exactly;
        the size goes to ISMCornerReliefData.SlotLength/SlotWidth (see the audit: what
        SolidWorks does with those two members for each relief type is not documented),
        and is read back from the feature data so a size that did not stick fails."""
        global call_inputs
        import pythoncom
        from win32com.client import VARIANT
        set_step('FeatureManager', 'corner_relief')
        doc, fm = (self.doc, self.doc.FeatureManager)
        relief_type = CORNER_RELIEF[p['corner_relief']]
        size = p['corner_relief_size'] * MM
        call_inputs = 'Initialize(TwoBend) CollectAllCorners(ReliefType=%d) size(m)=%g relief=%s' % (relief_type, size, p['corner_relief'])
        set_step('ClearSelection2', 'corner_relief')
        doc.ClearSelection2(True)
        set_step('CreateDefinition', 'corner_relief')
        data = check(fm.CreateDefinition(swFmCornerRelief), 'CreateDefinition(swFmCornerRelief) returned nothing')
        set_step('Initialize', 'corner_relief')
        check(data.Initialize(swCornerReliefBendType_TwoBend), 'ICornerReliefFeatureData.Initialize(TwoBend) returned False: ' + call_inputs)
        corners = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_VARIANT, None)
        set_step('CollectAllCorners', 'corner_relief')
        error = data.CollectAllCorners(relief_type, corners)
        if error == swCornerReliefError_InvalidBody:
            record_mitigation('corner-relief-body-scope', primary_failed=True, always=True)
            set_step('GetBodies2', 'corner_relief')
            bodies = list(api_interface(doc, 'PartDoc').GetBodies2(swSolidBody, False) or ())
            call_inputs += '; CollectAllCorners returned swCornerReliefError_e 2 (InvalidBody); solid bodies in the part: %d' % len(bodies)
            if len(bodies) != 1:
                raise RuntimeError('ICornerReliefFeatureData.CollectAllCorners returned swCornerReliefError_e 2 (InvalidBody) and the part has %d solid bodies, so there is no one body to pass to SetBodyScope: %s' % (len(bodies), call_inputs))
            set_step('GetBodyScope', 'corner_relief')
            scope_before = data.GetBodyScope()
            set_step('SetBodyScope', 'corner_relief')
            scope_error = data.SetBodyScope(bodies[0])
            call_inputs += '; GetBodyScope before=%s; SetBodyScope(the solid body) returned %s' % ('Nothing' if scope_before is None else 'a body', scope_error)
            if scope_error != 0:
                raise RuntimeError('ICornerReliefFeatureData.SetBodyScope returned swCornerReliefError_e %s: %s' % (scope_error, call_inputs))
            corners = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_VARIANT, None)
            set_step('CollectAllCorners', 'corner_relief')
            error = data.CollectAllCorners(relief_type, corners)
            if error == swCornerReliefError_InvalidBody:
                call_inputs += '; CollectAllCorners after SetBodyScope returned 2 again, Initialize(TwoBend) once more'
                set_step('Initialize', 'corner_relief')
                check(data.Initialize(swCornerReliefBendType_TwoBend), 'ICornerReliefFeatureData.Initialize(TwoBend) returned False after SetBodyScope: ' + call_inputs)
                corners = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_VARIANT, None)
                set_step('CollectAllCorners', 'corner_relief')
                error = data.CollectAllCorners(relief_type, corners)
            if error == 0:
                mitigations['corner-relief-body-scope']['fallback_ok'] += 1
        if error != 0:
            raise RuntimeError('ICornerReliefFeatureData.CollectAllCorners returned swCornerReliefError_e %s: %s' % (error, call_inputs))
        found = tuple(corners.value or ())
        if not found:
            raise RuntimeError('ICornerReliefFeatureData.CollectAllCorners found no corners after the multi-edge flange: ' + call_inputs)
        member = CORNER_SIZE_MEMBER.get(relief_type)
        for corner in found:
            if member:
                set_step('RatioToThickness', 'corner_relief')
                corner.RatioToThickness = False
                setattr(corner, member, size)
        for index, corner in enumerate(found):
            if member and abs(float(getattr(corner, member)) - size) > 1e-09:
                raise RuntimeError('corner %d kept %s=%g, not the requested %g m: %s' % (index, member, float(getattr(corner, member)), size, call_inputs))
        set_step('CreateFeature', 'corner_relief')
        feature = check(fm.CreateFeature(data), 'CreateFeature(corner relief) returned no feature: ' + call_inputs)
        if self.folder is not None:
            log_line(self.folder, 'option', 'corner relief %s: type mapped to swCornerReliefType_e %d; corner_relief_size %g mm set as %s of each corner (%s); corner_gap %g mm set as IEdgeFlangeFeatureData.GapDistance' % (p['corner_relief'], relief_type, p['corner_relief_size'], member or 'nothing', 'tear relief has no size' if relief_type == swCornerTearRelief else 'the one slot dimension this relief type keeps', p['corner_gap']))
        return feature

    def hem(self, p):
        global call_inputs
        set_step('FeatureManager', 'hem')
        doc, fm = (self.doc, self.doc.FeatureManager)
        query = p['edge']['edge']
        point = list(query['through'])
        if p['edge'].get('feature') == 'flange_free_edge':
            axis_index, sign = check(self.flange_axis, 'hem: no flange to hem')
            top = measured_extreme(doc, axis_index, sign)
            if abs(point[axis_index] - top) > 1e-06:
                record_mitigation('hem-edge-at-flange-top', always=True)
                if self.folder is not None:
                    log_line(self.folder, 'option', 'hem edge: recipe point %s, flange free edge at %s=%.4f mm' % (point, 'XYZ'[axis_index], top))
                point[axis_index] = top
        hem_axis, hem_sign = signed_axis(p['direction'])
        before = measured_extreme(doc, hem_axis, 1)
        volume_before, com_before = (measured_volume(doc), measured_center(doc))
        hem_type = swHemTypeOpen if p['gap'] > 0 else swHemTypeClosed
        candidate = probe_candidate or HEM_CANDIDATES[0]
        reverse = candidate.endswith('reverse-true')
        if candidate.startswith('edge-other-face'):
            thickness = float(self.sheet['thickness'])
            top = measured_extreme(doc, hem_axis, 1)
            point[hem_axis] = point[hem_axis] - thickness if abs(point[hem_axis] - top) < 1e-06 else point[hem_axis] + thickness
        edge = resolve(doc, {'edge': {'through': point, 'dir': query['dir']}})
        set_step('ClearSelection2', 'hem')
        doc.ClearSelection2(True)
        select(doc, edge, False, 0)
        call_inputs = 'Type=%d Position=Inside(%d) Reverse=%s DLength(m)=%g DGap(m)=%g edge(mm)=%s candidate=%s' % (hem_type, swHemPositionTypeInside, reverse, p['length'] * MM, p['gap'] * MM, point, candidate)
        set_step('InsertSheetMetalHem2', 'hem')
        feature = fm.InsertSheetMetalHem2(hem_type, swHemPositionTypeInside, reverse, p['length'] * MM, p['gap'] * MM, 0.0, 0.0, 0.0, None, True, swSheetMetalReliefRectangular, swReliefTearTypeRip, True, 0.5, 0.0, 0.0)
        check(feature, 'InsertSheetMetalHem2 returned no feature: ' + call_inputs)
        set_step('GetTypeName2', 'hem')
        if feature.GetTypeName2() != 'Hem':
            set_step('GetTypeName2', 'hem')
            raise RuntimeError('InsertSheetMetalHem2 returned a %s feature' % feature.GetTypeName2())
        after = measured_extreme(doc, hem_axis, 1)
        volume_after, com_after = (measured_volume(doc), measured_center(doc))
        ok, detail = hem_side_verdict(hem_axis, hem_sign, before, float(self.sheet['thickness']), volume_before, volume_after, com_before, com_after)
        note = '%s+ extreme %.4f -> %.4f mm, recipe direction %s; %s' % ('XYZ'[hem_axis], before, after, p['direction'], detail)
        if self.folder is not None:
            log_line(self.folder, 'option', 'hem side: ' + note + '; ' + call_inputs)
        if not ok:
            raise RuntimeError('hem folded to the wrong side of the flange (%s): %s' % (note, call_inputs))
        self.probe_note = note
        return feature

    def drawing_view(self, drawing, path, orientation, label, source=None):
        """Create the base view (a model view by name) or a projected view of `source`, check its scale."""
        global call_inputs
        doc = self.doc
        x, y = DRAWING_VIEW_POSITIONS[label]
        set_step('ClearSelection2', 'drawing_view')
        doc.ClearSelection2(True)
        if source is None:
            call_inputs = 'model=%s view=%s at(m)=%g,%g,0' % (pathlib.Path(path).name, orientation, x, y)
            set_step('CreateDrawViewFromModelView3', 'drawing_view')
            view = drawing.CreateDrawViewFromModelView3(path, orientation, x, y, 0.0)
        else:
            set_step('GetName2', 'drawing_view')
            call_inputs = 'projected from %s at(m)=%g,%g,0' % (source.GetName2(), x, y)
            set_step('SelectByID2', 'drawing_view')
            check(doc.Extension.SelectByID2(source.GetName2(), 'DRAWINGVIEW', 0.0, 0.0, 0.0, False, 0, None, 0), 'the base view could not be selected to project from: ' + call_inputs)
            set_step('CreateUnfoldedViewAt3', 'drawing_view')
            view = drawing.CreateUnfoldedViewAt3(x, y, 0.0, False)
        check(view, 'the %s view was not created: %s' % (label, call_inputs))
        set_step('ClearSelection2', 'drawing_view')
        doc.ClearSelection2(True)
        set_step('ScaleDecimal', 'drawing_view')
        if abs(float(view.ScaleDecimal) - 1.0) > 1e-09:
            record_mitigation('drawing-view-scale-explicit', primary_failed=True, always=True)
            set_step('UseSheetScale', 'drawing_view')
            view.UseSheetScale = 0
            set_step('ScaleDecimal', 'drawing_view')
            view.ScaleDecimal = 1.0
            set_step('ScaleDecimal', 'drawing_view')
            if abs(float(view.ScaleDecimal) - 1.0) > 1e-09:
                set_step('ScaleDecimal', 'drawing_view')
                raise RuntimeError('the %s view scale is %g, not 1:1, after setting it: %s' % (label, float(view.ScaleDecimal), call_inputs))
            mitigations['drawing-view-scale-explicit']['fallback_ok'] += 1
        return view

    def drawing_dimension(self, view, plan, position, expected, label):
        """Select the planned edges in the view, add the dimension and read its value back."""
        global call_inputs
        doc = self.doc
        set_step('GetName2', 'drawing_dimension')
        call_inputs = '%s view=%s edges=%s text(m)=%g,%g expected(mm)=%g' % (label, view.GetName2(), [r['kind'] for r in plan], position[0], position[1], expected)
        set_step('ActivateView', 'drawing_dimension')
        check(self.drawing_interface.ActivateView(view.GetName2()), 'ActivateView failed: ' + call_inputs)
        set_step('ClearSelection2', 'drawing_dimension')
        doc.ClearSelection2(True)
        for index, record in enumerate(plan):
            try:
                select(doc, record['entity'], index > 0, 0, True, view)
            except RuntimeError as exc:
                record_mitigation('drawing-select-entity-via-view', primary_failed=True, always=True)
                set_step('SelectEntity', 'drawing_dimension')
                check(view.SelectEntity(record['entity'], index > 0), 'IView.SelectEntity failed after: %s: %s' % (exc, call_inputs))
                mitigations['drawing-select-entity-via-view']['fallback_ok'] += 1
        set_step('GetSelectedObjectCount2', 'drawing_dimension')
        selected = doc.SelectionManager.GetSelectedObjectCount2(-1)
        if selected != len(plan):
            raise RuntimeError('%d edges are selected, not %d: %s' % (selected, len(plan), call_inputs))
        set_step('AddDimension2', 'drawing_dimension')
        display = check(doc.AddDimension2(position[0], position[1], 0.0), 'AddDimension2 returned no dimension: ' + call_inputs)
        set_step('SystemValue', 'drawing_dimension')
        measured = float(check(display.GetDimension2(0), 'the new dimension has no value object: ' + call_inputs).SystemValue) / MM
        if abs(measured - expected) > 1e-06:
            raise RuntimeError('the drawing dimension measured %.6f mm, not %g mm: %s' % (measured, expected, call_inputs))
        set_step('ClearSelection2', 'drawing_dimension')
        doc.ClearSelection2(True)
        return measured

    def drawing(self, op):
        """D05a: sheet at 1:1 from the default drawing template, a base view of the model, two projected views,
        every linear dimension on the view edges that its model points project to, then a read-back of every
        dimension in the drawing against the recipe's values."""
        global call_inputs
        doc = self.doc
        drawing = self.drawing_interface = api_interface(doc, 'DrawingDoc')
        model = next((d for d in DESIGNS if d['id'] == op['model']))
        bbox = model['expect']['bbox']
        path = str(self.folder / (op['model'] + '.sldprt'))
        set_step('GetCurrentSheet', 'drawing')
        sheet = check(drawing.GetCurrentSheet(), 'the new drawing has no current sheet')
        call_inputs = 'Numerator=1 Denominator=1'
        set_step('SetScale', 'drawing')
        check(sheet.SetScale(1.0, 1.0, False, False), 'ISheet.SetScale(1, 1) failed: ' + call_inputs)
        base = self.drawing_view(drawing, path, '*Top', 'base')
        vertical = self.drawing_view(drawing, path, '', 'vertical', base)
        beside = self.drawing_view(drawing, path, '', 'beside', base)
        views = (('base', base), ('vertical', vertical), ('beside', beside))
        set_step('ArrayData', 'drawing')
        axes = {label: drawing_axis(tuple((float(v) for v in view.ModelToViewTransform.ArrayData))) for label, view in views}
        if axes['base'] != 1 or axes['vertical'] != 2:
            raise RuntimeError('the views look along the wrong axes (base %s, vertical %s; the L is seen along Y and the hole along Z)' % tuple(('XYZ'[axes[k]] for k in ('base', 'vertical'))))
        if self.folder is not None:
            set_step('GetName2', 'drawing')
            log_line(self.folder, 'option', 'drawing: sheet scale 1:1, views %s' % ', '.join(('%s %s looks along %s' % (label, view.GetName2(), 'XYZ'[axes[label]]) for label, view in views)))
        cache = {}
        for index, dimension in enumerate(op['dimensions']):
            first, second = (tuple((c * MM for c in point)) for point in dimension['between'])
            chosen = None
            for label, view in views:
                if label not in cache:
                    cache[label] = drawing_edges(view, bbox)
                records, drop, space = cache[label]
                plan = dimension_plan(records, flat(first, drop), flat(second, drop))
                if plan:
                    chosen = (label, view, plan, space)
                    break
            if chosen is None:
                raise RuntimeError('no view shows the edges for the %g dimension between %s and %s' % (dimension['value'], dimension['between'][0], dimension['between'][1]))
            label, view, plan, space = chosen
            set_step('GetOutline', 'drawing')
            outline = view.GetOutline()
            position = (max(outline[0], outline[2]) + DRAWING_TEXT_STEP * (index + 1), max(outline[1], outline[3]) + DRAWING_TEXT_STEP * (index + 1))
            measured = self.drawing_dimension(view, plan, position, float(dimension['value']), 'dimension %d' % (index + 1))
            if self.folder is not None:
                set_step('GetName2', 'drawing')
                log_line(self.folder, 'option', 'drawing dimension %g: %s view %s, %s, entity coordinates were %s coordinates, measured %.6f mm' % (dimension['value'], label, view.GetName2(), ' + '.join((r['kind'] for r in plan)), space, measured))
        found = drawing_dimension_values(drawing)
        want = sorted((round(float(d['value']), 4) for d in op['dimensions']))
        got = sorted((round(value, 4) for _, value in found))
        if got != want:
            raise RuntimeError("the drawing holds the dimensions %s mm, not the recipe's %s mm" % (got, want))
        if self.folder is not None:
            log_line(self.folder, 'option', 'drawing read-back: %s' % ', '.join(('%s %g mm' % pair for pair in found)))
        return doc

    def export_drawing(self, path):
        """Save a copy of the sheet as DXF (R2000, which the recipe allows) and check the file."""
        global step
        app = self.app
        set_step('GetUserPreferenceIntegerValue', 'export_drawing')
        previous = app.GetUserPreferenceIntegerValue(swDxfVersion)
        try:
            set_step('SetUserPreferenceIntegerValue', 'export_drawing')
            check(app.SetUserPreferenceIntegerValue(swDxfVersion, swDxfFormat_R2000), 'cannot set the DXF version')
            set_step('GetUserPreferenceIntegerValue', 'export_drawing')
            if app.GetUserPreferenceIntegerValue(swDxfVersion) != swDxfFormat_R2000:
                raise RuntimeError('the DXF version did not stay at R2000 (%d)' % swDxfFormat_R2000)
            save(self.doc, path)
        finally:
            failing_step = step
            set_step('SetUserPreferenceIntegerValue', 'export_drawing')
            app.SetUserPreferenceIntegerValue(swDxfVersion, previous)
            step = failing_step
        set_step('DXF file check')
        if not path.is_file() or path.stat().st_size == 0:
            raise RuntimeError('the DXF export wrote no data to ' + path.name)
        if self.folder is not None:
            log_line(self.folder, 'option', 'drawing DXF: %s, %d bytes, DXF version R2000 (3), previous setting %d restored; scale and text options left at the user defaults (the interop does not say what their values mean)' % (path.name, path.stat().st_size, previous))

    def sheetmetal(self, op):
        global call_inputs
        p, action = (op.get('app', {}), op['action'])
        doc = self.doc
        if action == 'base_flange':
            return self.base_flange(p)
        if action == 'flange':
            return self.edge_flange(p)
        if action == 'hem':
            return self.hem(p)
        if action == 'corner_round':
            set_step('ClearSelection2', 'sheetmetal')
            doc.ClearSelection2(True)
            thickness_axis = 'XYZ'[self.sheet['normal']]
            for i, corner in enumerate(p['corners']):
                select(doc, resolve(doc, {'edge': {'through': corner, 'dir': thickness_axis}}), i > 0, 0)
            call_inputs = 'Type=Fillet Distance(m)=%g corners(mm)=%s' % (p['r'] * MM, p['corners'])
            set_step('InsertSheetMetalBreakCorner', 'sheetmetal')
            doc.InsertSheetMetalBreakCorner(swBreakCornerTypeFillet, p['r'] * MM)
            feature = newest_feature(doc)
            set_step('GetTypeName2', 'sheetmetal')
            if feature is None or feature.GetTypeName2() != 'BreakCorner':
                raise RuntimeError('InsertSheetMetalBreakCorner created no BreakCorner feature (%s)' % call_inputs)
            return feature
        feature = check(find_feature(doc, 'FlatPattern'), 'no Flat-Pattern feature in the sheet-metal part')
        set_step('IsSuppressed2', 'sheetmetal')
        states = feature.IsSuppressed2(swThisConfiguration, None)
        if not states or not all(states):
            raise RuntimeError('the flat pattern is unfolded; the recipe saves the folded part')
        return feature

    def world_axis(self, direction):
        doc = self.doc
        set_step('ClearSelection2', 'world_axis')
        doc.ClearSelection2(True)
        set_step('SketchManager', 'world_axis')
        sm = doc.SketchManager
        set_step('Insert3DSketch', 'world_axis')
        sm.Insert3DSketch(True)
        set_step('CreateLine', 'world_axis')
        segment = check(sm.CreateLine(0, 0, 0, *[v * 0.01 for v in axis(direction)]), 'axis line failed')
        set_step('ConstructionGeometry', 'world_axis')
        segment.ConstructionGeometry = True
        set_step('Insert3DSketch', 'world_axis')
        sm.Insert3DSketch(True)
        set_step('ClearSelection2', 'world_axis')
        doc.ClearSelection2(True)
        select(doc, segment, topology=False)
        set_step('InsertAxis2', 'world_axis')
        check(doc.InsertAxis2(True), 'reference axis creation failed')
        return check(newest_feature(doc), 'reference axis missing')

    def reference_plane(self, value):
        plane, offset = plane_parameters(value)
        planes = []
        set_step('FirstFeature', 'reference_plane')
        feature = self.doc.FirstFeature()
        while feature is not None:
            set_step('GetTypeName2', 'reference_plane')
            if feature.GetTypeName2() == 'RefPlane':
                planes.append(feature)
            set_step('GetNextFeature', 'reference_plane')
            feature = feature.GetNextFeature()
        feature = planes[{'XY': 0, 'XZ': 1, 'YZ': 2}[plane]]
        set_step('ClearSelection2', 'reference_plane')
        self.doc.ClearSelection2(True)
        set_step('Select2', 'reference_plane')
        check(feature.Select2(False, 0), 'plane selection failed')
        if offset:
            set_step('InsertRefPlane', 'reference_plane')
            check(self.doc.FeatureManager.InsertRefPlane(8, offset * MM, 0, 0, 0, 0), 'reference plane creation failed')
            feature = check(newest_of_type(self.doc, 'RefPlane'), 'reference plane feature missing')
            if self.folder is not None:
                set_step('Name', 'reference_plane')
                log_line(self.folder, 'option', 'reference plane %g mm from %s: %s (%s)' % (offset, plane, feature.Name, feature.GetTypeName2()))
        return feature

    def component_entity(self, query, cylindrical=False):
        component = self.components[query['component']]
        set_step('GetModelDoc2', 'component_entity')
        model = check(component.GetModelDoc2(), 'component model is not loaded')
        if query['component'] in self.config_of:
            activate_configuration(model, self.config_of[query['component']], 'the part configuration')
        entity = resolve(model, {k: v for k, v in query.items() if k != 'component'}, cylindrical)
        set_step('GetCorrespondingEntity', 'component_entity')
        return check(component.GetCorrespondingEntity(entity), 'component entity mapping failed')

    def component_face(self, query):
        """The planar face, bounded by the circular edge `query`, whose normal is parallel to the circle's axis, mapped into the assembly."""
        component = self.components[query['component']]
        set_step('GetModelDoc2', 'component_face')
        model = check(component.GetModelDoc2(), 'component model is not loaded')
        edge = resolve(model, {k: v for k, v in query.items() if k != 'component'})
        set_step('CircleParams', 'component_face')
        direction = tuple((float(v) for v in edge.GetCurve().CircleParams[3:6]))
        length = math.sqrt(sum((v * v for v in direction)))
        set_step('GetTwoAdjacentFaces2', 'component_face')
        for face in edge.GetTwoAdjacentFaces2() or ():
            set_step('Normal', 'component_face')
            normal = face.Normal
            size = math.sqrt(sum((v * v for v in normal)))
            set_step('IsPlane', 'component_face')
            if face.GetSurface().IsPlane() and length and size and (abs(sum((a * b for a, b in zip(direction, normal)))) / (length * size) >= 1 - 1e-06):
                set_step('GetCorrespondingEntity', 'component_face')
                return check(component.GetCorrespondingEntity(face), 'component face mapping failed')
        raise RuntimeError('no planar face with a normal along the circle axis %s is bounded by the edge %s' % (direction, json.dumps(query, sort_keys=True)))

    def add_tangent_mate(self, constraint):
        """A tangent mate between a cylinder (a) and a plane (b) on the recipe's side.

        AddMate5 with swMateTANGENT; the alignment that puts a cylinder outside a plane is
        anti-aligned (the two face normals oppose), inside is aligned. SolidWorks decides the
        side, so the component's GetBox is measured after the mate and, when it is on the
        other side, the mate is undone and made again with the other alignment, once."""
        import pythoncom
        from win32com.client import VARIANT
        assembly = api_interface(self.doc, 'AssemblyDoc')
        normal, point, outside = tangent_plane(constraint)
        moving = self.components[constraint['a']['component']]
        first = swMateAlignANTI_ALIGNED if outside else swMateAlignALIGNED
        tried = []
        radius = cylinder_radius(self.component_entity(constraint['a'], True))
        for attempt, align in enumerate((first, swMateAlignANTI_ALIGNED + swMateAlignALIGNED - first)):
            set_step('ClearSelection2', 'add_tangent_mate')
            self.doc.ClearSelection2(True)
            select(self.doc, self.component_entity(constraint['a'], True), False, 1)
            select(self.doc, self.component_entity(constraint['b']), True, 1)
            errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
            set_step('AddMate5', 'add_tangent_mate')
            feature = assembly.AddMate5(*tangent_arguments(align), errors)
            if errors.value != swAddMateError_NoError:
                raise RuntimeError('SolidWorks AddMate5 error %s (tangent mate, alignment %d, %s on %s, solution %s)' % (errors.value, align, constraint['a']['component'], constraint['b']['component'], constraint.get('solution', 'outside')))
            check(feature, 'mate API returned no mate')
            set_step('GetBox', 'add_tangent_mate')
            box = check(moving.GetBox(False, False), 'component box unavailable after the tangent mate')
            ok, text = tangent_side(box, normal, point, outside, radius)
            tried.append('alignment %d: %s' % (align, text))
            if ok:
                if attempt:
                    mitigations['tangent-other-alignment']['fallback_ok'] += 1
                if self.folder is not None:
                    log_line(self.folder, 'option', 'tangent mate side check: ' + '; '.join(tried))
                return feature
            if attempt == 0:
                record_mitigation('tangent-other-alignment', primary_failed=True, always=True)
                set_step('EditUndo2', 'add_tangent_mate')
                self.doc.EditUndo2(1)
        raise RuntimeError('tangent mate of %s to %s is on the wrong side with both alignments, solution %s; %s' % (constraint['a']['component'], constraint['b']['component'], constraint.get('solution', 'outside'), '; '.join(tried)))

    def configuration(self, p):
        """A second configuration with some components suppressed (AddConfiguration; SetSuppression2 in it)."""
        doc = self.doc
        set_step('ConfigurationManager', 'configuration')
        manager = check(doc.ConfigurationManager, 'configuration manager unavailable')
        set_step('GetConfigurationNames', 'configuration')
        existing = [str(n) for n in doc.GetConfigurationNames() or ()]
        set_step('Name', 'configuration')
        master = str(check(manager.ActiveConfiguration, 'no active configuration').Name)
        if p['name'] in existing:
            raise RuntimeError('configuration %r already exists (existing: %s)' % (p['name'], ', '.join(existing)))
        set_step('AddConfiguration', 'configuration')
        check(manager.AddConfiguration(p['name'], '', '', 0, '', ''), 'AddConfiguration returned no configuration: name=%r existing=%s' % (p['name'], ', '.join(existing)))
        set_step('Name', 'configuration')
        active = str(manager.ActiveConfiguration.Name)
        if active != p['name']:
            record_mitigation('configuration-activate-after-add', primary_failed=True, always=True)
            activate_configuration(doc, p['name'], 'the new configuration')
            mitigations['configuration-activate-after-add']['fallback_ok'] += 1
        instances = {}
        for label, component in self.components.items():
            set_step('Name2', 'configuration')
            instances[label] = str(component.Name2)
        for target in p['suppress']:
            self.suppress_in_active_configuration(target, p['name'])
        wanted = master if p.get('active', 'master') == 'master' else p['name']
        activate_configuration(doc, wanted, 'configuration (configurations: %s)' % ', '.join(existing + [p['name']]))
        set_step('Name', 'configuration')
        if str(manager.ActiveConfiguration.Name) != wanted:
            set_step('Name', 'configuration')
            raise RuntimeError('active configuration is %r, expected %r' % (manager.ActiveConfiguration.Name, wanted))
        self.state_checks.append(dict(kind='configuration', master=master, name=p['name'], targets=list(p['suppress']), active=wanted, components=instances))
        return self.last or doc

    def display_state(self, p):
        """A display state (IConfiguration.CreateDisplayState) with some components hidden in it."""
        doc = self.doc
        set_step('ConfigurationManager', 'display_state')
        manager = check(doc.ConfigurationManager, 'configuration manager unavailable')
        set_step('ActiveConfiguration', 'display_state')
        config = check(manager.ActiveConfiguration, 'no active configuration')
        set_step('GetDisplayStates', 'display_state')
        existing = [str(n) for n in config.GetDisplayStates() or ()]
        if len(existing) != 1:
            raise RuntimeError('expected the one default display state in the new assembly, found %d: %s' % (len(existing), ', '.join(existing)))
        default = existing[0]
        if p['name'] in existing:
            raise RuntimeError('display state %r already exists (existing: %s)' % (p['name'], ', '.join(existing)))
        set_step('CreateDisplayState', 'display_state')
        check(config.CreateDisplayState(p['name']), 'CreateDisplayState(%r) failed (existing: %s)' % (p['name'], ', '.join(existing)))
        set_step('ApplyDisplayState', 'display_state')
        check(config.ApplyDisplayState(p['name']), 'ApplyDisplayState(%r) failed' % p['name'])
        for target in p['hide']:
            component = self.components[target]
            set_step('Visible', 'display_state')
            component.Visible = swComponentHidden
            set_step('Visible', 'display_state')
            if component.Visible != swComponentHidden:
                record_mitigation('displaystate-setvisibility', primary_failed=True, always=True)
                set_step('SetVisibility', 'display_state')
                component.SetVisibility(swComponentHidden, swSpecifyDisplayState, (p['name'],))
                set_step('Visible', 'display_state')
                if component.Visible != swComponentHidden:
                    raise RuntimeError('component %s is still visible in display state %r after Visible = 0 and SetVisibility(0, 3, [name])' % (target, p['name']))
                mitigations['displaystate-setvisibility']['fallback_ok'] += 1
        set_step('Name2', 'display_state')
        instances = {label: str(component.Name2) for label, component in self.components.items()}
        wanted = default if p.get('active', 'Default') == 'Default' else p['name']
        set_step('ApplyDisplayState', 'display_state')
        check(config.ApplyDisplayState(wanted), 'ApplyDisplayState(%r) failed' % wanted)
        self.state_checks.append(dict(kind='display_state', default=default, name=p['name'], targets=list(p['hide']), active=wanted, components=instances))
        return self.last or doc

    def saved_components(self, model):
        assembly = api_interface(model, 'AssemblyDoc')
        set_step('Name2', 'saved_components')
        return {str(c.Name2): c for c in assembly.GetComponents(True) or ()}

    def read_back_configuration(self, model, entry):
        set_step('GetConfigurationNames', 'read_back_configuration')
        names = sorted((str(n) for n in model.GetConfigurationNames() or ()))
        if names != sorted([entry['master'], entry['name']]):
            raise RuntimeError('saved file has configurations %s, expected %s' % (names, sorted([entry['master'], entry['name']])))
        set_step('ConfigurationManager', 'read_back_configuration')
        manager = model.ConfigurationManager
        set_step('Name', 'read_back_configuration')
        active = str(manager.ActiveConfiguration.Name)
        if active != entry['active']:
            raise RuntimeError('saved file has configuration %r active, expected %r' % (active, entry['active']))
        for config in names:
            activate_configuration(model, config, 'saved configuration')
            parts = self.saved_components(model)
            for label, instance in entry['components'].items():
                component = check(parts.get(instance), 'saved component %s (%s) not found in configuration %r' % (label, instance, config))
                expected = config == entry['name'] and label in entry['targets']
                set_step('IsSuppressed', 'read_back_configuration')
                if bool(component.IsSuppressed()) != expected:
                    raise RuntimeError('saved configuration %r: component %s suppressed=%s, expected %s' % (config, label, not expected, expected))
        activate_configuration(model, active, 'saved configuration (reactivating)')
        return 'configurations=%s active=%s suppressed-in-%s=%s' % ('/'.join(names), active, entry['name'], '/'.join(entry['targets']))

    def read_back_display_state(self, model, entry):
        set_step('ActiveConfiguration', 'read_back_display_state')
        config = check(model.ConfigurationManager.ActiveConfiguration, 'saved file has no active configuration')
        set_step('GetDisplayStates', 'read_back_display_state')
        names = sorted((str(n) for n in config.GetDisplayStates() or ()))
        wanted = sorted([entry['default'], entry['name']])
        if names != wanted:
            raise RuntimeError('saved file has display states %s, expected %s' % (names, wanted))

        def visible(state):
            parts = self.saved_components(model)
            for label, instance in entry['components'].items():
                component = check(parts.get(instance), 'saved component %s (%s) not found' % (label, instance))
                expected = swComponentVisible if not (state == entry['name'] and label in entry['targets']) else swComponentHidden
                set_step('Visible', 'visible')
                if component.Visible != expected:
                    set_step('Visible', 'visible')
                    raise RuntimeError('saved display state %r: component %s visible=%s, expected %s' % (state, label, component.Visible, expected))
        visible(entry['active'])
        for state in names:
            set_step('ApplyDisplayState', 'read_back_display_state')
            check(config.ApplyDisplayState(state), 'cannot apply saved display state %r' % state)
            visible(state)
        return 'display states=%s hidden-in-%s=%s saved-active=%s' % ('/'.join(names), entry['name'], '/'.join(entry['targets']), entry['active'])

    def check_saved_states(self, path):
        """Reopen the saved assembly and read its configurations / display states back. Returns what was read."""
        import pythoncom
        from win32com.client import VARIANT
        report = [self.read_back_part(entry) for entry in self.state_checks if entry['kind'] == 'part']
        if any((entry['kind'] != 'part' for entry in self.state_checks)):
            errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
            warnings = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
            set_step('OpenDoc6', 'check_saved_states')
            model = self.app.OpenDoc6(str(path), swDocASSEMBLY, swOpenDocOptions_Silent, '', errors, warnings)
            if errors.value:
                raise RuntimeError('SolidWorks OpenDoc6 error %s reopening the saved assembly to read its states back' % errors.value)
            model = check(model, 'the saved assembly could not be reopened to read its states back')
            try:
                for entry in self.state_checks:
                    if entry['kind'] != 'part':
                        report.append(self.read_back_configuration(model, entry) if entry['kind'] == 'configuration' else self.read_back_display_state(model, entry))
            finally:
                set_step('CloseDoc', 'check_saved_states')
                self.app.CloseDoc(model.GetTitle())
        return 'saved file read back: ' + '; '.join(report)

    def add_mate(self, constraint):
        import pythoncom
        from win32com.client import VARIANT
        if constraint['type'] == 'tangent':
            return self.add_tangent_mate(constraint)
        assembly = api_interface(self.doc, 'AssemblyDoc')
        feature = None
        for concentric in [True, False] if constraint['type'] == 'insert' else [False]:
            set_step('ClearSelection2', 'add_mate')
            self.doc.ClearSelection2(True)
            arguments = mate_arguments(constraint, concentric)
            candidate = probe_candidate if probe_candidate in MATE_CANDIDATES and (not concentric) and (arguments[0] == swMateDISTANCE) else ''
            if candidate:
                arguments = (arguments[0], 2 if 'align2' in candidate else 1, candidate.endswith('flip')) + arguments[3:]
            entities = []
            for i, key in enumerate(('a', 'b')):
                entity = self.component_face(constraint[key]) if candidate.startswith('face') else self.component_entity(constraint[key])
                entities.append(entity)
                select(self.doc, entity, i > 0, 1)
            errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
            set_step('AddMate5', 'add_mate')
            feature = assembly.AddMate5(*arguments, errors)
            retried = ''
            if errors.value == swAddMateError_ErrorUknown and arguments[0] == swMateDISTANCE:
                record_mitigation('distance-mate-no-limits', primary_failed=True, always=True)
                set_step('GetSelectedObjectCount2', 'add_mate')
                kept = self.doc.SelectionManager.GetSelectedObjectCount2(-1)
                if kept != 2:
                    raise RuntimeError('SolidWorks AddMate5 error 0 (distance mate) and the failed call left %d objects selected, not 2; no retry with limits 0: arguments %s' % (kept, ', '.join((repr(v) for v in arguments))))
                first_arguments = arguments
                arguments = arguments[:4] + (0.0, 0.0) + arguments[6:]
                errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
                set_step('AddMate5', 'add_mate')
                feature = assembly.AddMate5(*arguments, errors)
                retried = '; the same call with DistUpper = DistLower = 0 was tried after error 0 for %s' % (', '.join((repr(v) for v in first_arguments)),)
                if errors.value == swAddMateError_NoError:
                    mitigations['distance-mate-no-limits']['fallback_ok'] += 1
            if arguments[0] == swMateCOINCIDENT and errors.value in (3, 4, 5):
                first_alignment, tries = (arguments[1], 0)
                for align in (swMateAlignCLOSEST, swMateAlignALIGNED):
                    if align == first_alignment:
                        continue
                    if not tries:
                        record_mitigation('mate-align-retry', primary_failed=True, always=True)
                    tries += 1
                    set_step('ClearSelection2', 'add_mate')
                    self.doc.ClearSelection2(True)
                    for i, entity in enumerate(entities):
                        select(self.doc, entity, i > 0, 1)
                    errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
                    set_step('AddMate5', 'add_mate')
                    feature = assembly.AddMate5(arguments[0], align, *arguments[2:], errors)
                    self.note_option('mate-align-retry: AddMate5 with Align %d answered error %s' % (align, errors.value))
                    retried += '; Align %d answered error %s' % (align, errors.value)
                    if errors.value == swAddMateError_NoError:
                        mitigations['mate-align-retry']['fallback_ok'] += 1
                        break
            if errors.value != swAddMateError_NoError:
                raise RuntimeError('SolidWorks AddMate5 error %s (%s mate, concentric=%s; arguments (Type, Align, Flip, Dist, DistUpper, DistLower, GearNum, GearDen, Angle, AngleUpper, AngleLower, ForPositioning, LockRotation, WidthType) = %s; a=%s; b=%s%s%s)' % (errors.value, constraint['type'], concentric, ', '.join((repr(v) for v in arguments)), json.dumps(constraint['a'], sort_keys=True), json.dumps(constraint['b'], sort_keys=True), selection_summary(self.doc), retried))
            check(feature, 'mate API returned no mate')
        if constraint.get('name') in self.wanted_mates:
            self.mate_features[constraint['name']] = self.newest_mate()
        return feature

    def assembly(self, op):
        doc = self.doc
        assembly = api_interface(doc, 'AssemblyDoc')
        if 'subassembly' in op:
            return self.subassembly(op['subassembly'])
        if 'insert' in op:
            import pythoncom
            from win32com.client import VARIANT
            insertion = op['insert']
            file = insertion.get('assembly') or insertion.get('file') or insertion['recipe']
            name = insertion.get('name', file)
            config = insertion.get('config') or ''
            path = self.folder / (file + ('.sldasm' if 'assembly' in insertion else '.sldprt'))
            errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
            warnings = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
            set_step('OpenDoc6', 'assembly')
            model = self.app.OpenDoc6(str(path), swDocASSEMBLY if 'assembly' in insertion else swDocPART, 1, '', errors, warnings)
            if errors.value:
                raise RuntimeError('SolidWorks component OpenDoc6 error %s' % errors.value)
            model = check(model, 'component document unavailable')
            set_step('GetTitle', 'assembly')
            self.loaded.append(model.GetTitle())
            errors.value = 0
            set_step('ActivateDoc3', 'assembly')
            check(self.app.ActivateDoc3(doc.GetTitle(), False, swRebuildActiveDoc, errors), 'assembly activation failed')
            if errors.value:
                raise RuntimeError('SolidWorks ActivateDoc3 error %s' % errors.value)
            set_step('AddComponent5', 'assembly')
            component = check(assembly.AddComponent5(str(path), 0, '', False, config, 0, 0, 0), 'component insertion failed')
            pose = placement(insertion.get('at', 'default'), insertion.get('turn'))
            set_step('CreateTransform', 'assembly')
            transform = self.app.GetMathUtility().CreateTransform(double_array(pose))
            set_step('Transform2', 'assembly')
            component.Transform2 = check(transform, 'component transform creation failed')
            self.components[name] = component
            self.poses[name] = pose
            if 'assembly' in insertion:
                self.files[name] = file
            else:
                self.part_files[name], self.recipe_of[name] = (file, insertion.get('recipe'))
            if config:
                self.reference_configuration(name, config)
            if insertion.get('external'):
                self.note_option('%s is placed from its own file %s.sldprt, a linked (external) reference, not an embedded copy' % (name, file))
            self.component_state(component, {'grounded': insertion.get('grounded', False)})
            return component
        if 'constraint' in op:
            if op['constraint']['type'] in ('coincident', 'distance', 'limit_angle'):
                return self.add_assembly_mate(op['constraint'])
            return self.add_mate(op['constraint'])
        if 'mate' in op:
            return self.suppress_mate(op['mate'], op['suppressed'])
        if 'pattern' in op:
            return self.component_pattern(op['pattern'])
        if 'copy_part' in op:
            return self.copy_part(op['copy_part'])
        if 'part_configuration' in op:
            return self.part_configuration(op['part_configuration'])
        if 'source_edit' in op:
            return self.source_edit(op['source_edit'])
        if 'mirror' in op:
            return self.mirror(op['mirror'])
        if 'move' in op:
            return self.move_component(op['move'])
        if 'make_virtual' in op:
            return self.make_virtual(op['component'])
        component = self.components[op['component']]
        self.component_state(component, op)
        return component

    def subassembly(self, p):
        """Build one subassembly file first (its parts placed and grounded as the recipe says), save it under the recipe's name beside
        the top file, close it, and come back to the top document. The top then inserts it like a part."""
        import pythoncom
        from win32com.client import VARIANT
        file = p['file']
        top = self.doc
        set_step('NewDocument', 'subassembly')
        sub_doc = check(self.app.NewDocument(resolve_template(self.app, 'assembly'), 0, 0.0, 0.0), 'Template could not be opened for the subassembly ' + file)
        set_step('ShowFeatureErrorDialog', 'subassembly')
        sub_doc.ShowFeatureErrorDialog = False
        inner = Builder(self.app, sub_doc, self.folder)
        inner.trees, inner.extra_files = (self.trees, self.extra_files)
        try:
            for item in p['ops']:
                inner.apply(item)
            set_step('EditRebuild3', 'subassembly')
            check(sub_doc.EditRebuild3(), 'subassembly rebuild failed')
            privacy(sub_doc)
            save(sub_doc, self.folder / (file + '.sldasm'))
            set_step('Name2', 'subassembly')
            tree = {label: (str(c.Name2), inner.files.get(label), inner.poses.get(label)) for label, c in inner.components.items()}
        finally:
            set_step('GetTitle', 'subassembly')
            for title in [sub_doc.GetTitle()] + inner.loaded:
                set_step('CloseDoc', 'subassembly')
                self.app.CloseDoc(title)
        self.trees[file] = tree
        if file + '.sldasm' not in self.extra_files:
            self.extra_files.append(file + '.sldasm')
        errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
        set_step('ActivateDoc3', 'subassembly')
        check(self.app.ActivateDoc3(top.GetTitle(), False, swRebuildActiveDoc, errors), 'assembly activation failed')
        if errors.value:
            raise RuntimeError('SolidWorks ActivateDoc3 error %s' % errors.value)
        return top

    def reference_names(self, model):
        """(the three default plane names, the origin's name) of a part or assembly document: found by position and type, because
        the names are localised (Front, Top, Right order)."""
        planes, origin = ([], 'Origin')
        set_step('FirstFeature', 'reference_names')
        feature = model.FirstFeature()
        while feature is not None:
            set_step('GetTypeName2', 'reference_names')
            kind = feature.GetTypeName2()
            if kind == 'RefPlane' and len(planes) < 3:
                set_step('Name', 'reference_names')
                planes.append(str(feature.Name))
            elif kind == 'OriginProfileFeature':
                set_step('Name', 'reference_names')
                origin = str(feature.Name)
            set_step('GetNextFeature', 'reference_names')
            feature = feature.GetNextFeature()
        check(len(planes) == 3, 'the document has %d default reference planes, not 3' % len(planes))
        return (planes, origin)

    def select_reference(self, selector, append):
        """Select a component's origin point or default plane (or the assembly's own) by name, in the assembly's context:
        Name@Instance@Assembly with SelectByID2. The selection count must grow by one (the return value alone is not trusted)."""
        component = self.components[selector['component']] if 'component' in selector else None
        set_step('GetModelDoc2', 'select_reference')
        model = check(component.GetModelDoc2(), 'component model is not loaded') if component is not None else self.doc
        planes, origin = self.reference_names(model)
        if 'plane' in selector:
            name, kind = (planes[{'Front': 0, 'Top': 1, 'Right': 2}[selector['plane']]], 'PLANE')
        else:
            name, kind = ('Point1@' + origin, 'EXTSKETCHPOINT')
        names = [name]
        if component is not None:
            set_step('GetTitle', 'select_reference')
            title = re.sub('\\.sldasm$', '', str(self.doc.GetTitle()), flags=re.I)
            set_step('Name2', 'select_reference')
            names = [name + '@' + str(component.Name2) + '@' + title, name + '@' + str(component.Name2)]
        set_step('GetSelectedObjectCount2', 'select_reference')
        before = self.doc.SelectionManager.GetSelectedObjectCount2(-1)
        for number, full in enumerate(names):
            set_step('SelectByID2', 'select_reference')
            returned = self.doc.Extension.SelectByID2(full, kind, 0.0, 0.0, 0.0, append, 1, None, 0)
            set_step('GetSelectedObjectCount2', 'select_reference')
            after = self.doc.SelectionManager.GetSelectedObjectCount2(-1)
            if after == before + 1:
                if number:
                    record_mitigation('reference-select-without-assembly-name', primary_failed=True, always=True)
                    mitigations['reference-select-without-assembly-name']['fallback_ok'] += 1
                return
        raise RuntimeError('selecting %s (%s) in the assembly did not select it: SelectByID2 returned %s, %d selected before and %d after (names tried: %s)' % (kind, json.dumps(selector, sort_keys=True), returned, before, after, ', '.join(names)))

    def newest_mate(self):
        """The newest mate feature: the last sub-feature of the assembly's MateGroup."""
        group = None
        set_step('FirstFeature', 'newest_mate')
        feature = self.doc.FirstFeature()
        while feature is not None:
            set_step('GetTypeName2', 'newest_mate')
            if feature.GetTypeName2() == 'MateGroup':
                group = feature
            set_step('GetNextFeature', 'newest_mate')
            feature = feature.GetNextFeature()
        check(group, 'the assembly has no MateGroup feature')
        set_step('GetFirstSubFeature', 'newest_mate')
        newest, item = (None, group.GetFirstSubFeature())
        while item is not None:
            set_step('GetNextSubFeature', 'newest_mate')
            newest, item = (item, item.GetNextSubFeature())
        return check(newest, 'the MateGroup has no mate')

    def suppress_mate(self, name, suppressed):
        """Suppress (or resolve) one named mate in this configuration: IFeature.SetSuppression2(swSuppressFeature, swThisConfiguration)."""
        feature = check(self.mate_features.get(name), 'no mate named %r was made before this step' % name)
        if not suppressed:
            raise NotScripted('assembly mate: only suppressing a mate is implemented')
        set_step('SetSuppression2', 'suppress_mate')
        check(feature.SetSuppression2(swSuppressFeature, swThisConfiguration, None), 'suppressing mate %r failed' % name)
        set_step('IsSuppressed2', 'suppress_mate')
        states = feature.IsSuppressed2(swThisConfiguration, None)
        if not states or not all(states):
            raise RuntimeError('mate %r is not suppressed after SetSuppression2 (IsSuppressed2 returned %r)' % (name, states))
        return feature

    def wanted_pose(self, label):
        """(translation mm, rotation R or None) a top-level component must have: the answer key's where the run knows it (self.expected;
        R only where the key scores it), else the pose it was inserted at. None when the component was not placed by this builder."""
        if label in self.expected:
            return self.expected[label]
        if label in self.poses:
            t, rotation = pose_of(self.poses[label])
            return (t, rotation)
        return None

    def pose_deviation(self, label):
        """(mm, rotation units) of a placed component from the pose it must have (rotation 0 where it is not compared), or None."""
        wanted = self.wanted_pose(label)
        if wanted is None or label not in self.components:
            return None
        set_step('ArrayData', 'pose_deviation')
        t, rotation = pose_of(self.components[label].GetTotalTransform(True).ArrayData)
        moved = max((abs(a - b) for a, b in zip(t, wanted[0])))
        turned = 0.0 if wanted[1] is None else max((abs(rotation[i][j] - wanted[1][i][j]) for i in range(3) for j in range(3)))
        return (moved, turned)

    def pose_wrong(self, label, final):
        """Is the component off its pose, where this mate is the one to say so? Every mate counts while the component was inserted at its pose
        (the mates must not move it); a component inserted elsewhere is only judged after the last mate of its composition."""
        deviation = self.pose_deviation(label)
        if deviation is None:
            return False
        inserted = label in self.poses and self.wanted_pose(label) is not None
        if inserted and label in self.expected:
            t, rotation = pose_of(self.poses[label])
            wanted = self.expected[label]
            inserted = max((abs(a - b) for a, b in zip(t, wanted[0]))) <= 0.01 and (wanted[1] is None or max((abs(rotation[i][j] - wanted[1][i][j]) for i in range(3) for j in range(3))) <= 0.0001)
        if not (final or inserted):
            return False
        return deviation[0] > 0.01 or deviation[1] > 0.0001

    def pose_text(self, label):
        wanted = self.wanted_pose(label)
        set_step('ArrayData', 'pose_text')
        t, rotation = pose_of(self.components[label].GetTotalTransform(True).ArrayData)
        return 'at (%s) mm turned (%s), wanted (%s)%s' % (mm_list(t), mm_list([v for r in rotation for v in r]), mm_list(wanted[0]), '' if wanted[1] is None else ' turned (%s)' % mm_list([v for r in wanted[1] for v in r]))

    def mate_once(self, c, number, label, arguments):
        """One AddMate5 attempt: the selection is made again, the call, its inputs and its error code are logged. Returns the mate or None."""
        import pythoncom
        from win32com.client import VARIANT
        assembly = api_interface(self.doc, 'AssemblyDoc')
        set_step('ClearSelection2', 'mate_once')
        self.doc.ClearSelection2(True)
        for i, key in enumerate(('a', 'b')):
            if 'face' in c[key] or 'edge' in c[key]:
                select(self.doc, self.component_entity(c[key]), i > 0, 1)
            else:
                self.select_reference(c[key], i > 0)
        set_step('GetSelectedObjectCount2', 'mate_once')
        count = self.doc.SelectionManager.GetSelectedObjectCount2(-1)
        if count != 2:
            raise RuntimeError('mate %s: %d objects selected, not 2 %s' % (c['name'], count, selection_summary(self.doc)))
        errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
        set_step('AddMate5', 'mate_once')
        feature = assembly.AddMate5(*arguments, errors)
        if self.folder is not None:
            log_line(self.folder, 'option', 'mate %s plan %d (%s): AddMate5%s -> error %s, %s' % (c['name'], number, label, tuple((round(v, 9) if isinstance(v, float) else v for v in arguments)), errors.value, 'a mate' if feature is not None else 'no mate'))
        return feature if errors.value == swAddMateError_NoError else None

    def make_mate(self, c, flip=False, align=None, suffix=''):
        """One mate of a coincident, distance or limit angle constraint, by its plans in order. Returns the mate, or None for a LIMIT mate that
        SolidWorks refused: no other mate is made for it (a plain distance or angle mate would lock the motion), the limits are reported as not
        stored. Any other refusal raises."""
        plans = new_mate_plans(c, flip, align)
        limit = c['type'] == 'limit_angle' or 'min' in c
        fallback = 'limit-mate-plain' if limit else 'distance-mate-no-limits'
        if limit and limit_mate_frame(c)['negative']:
            record_mitigation('limit-mate-negative-flip')
        for number, (label, arguments) in enumerate(plans):
            feature = self.mate_once(c, number, label + suffix, arguments)
            if feature is not None:
                if number:
                    mitigations[fallback]['fallback_ok'] += 1
                return feature
            if number + 1 < len(plans) or limit:
                record_mitigation(fallback, primary_failed=True, always=True)
        if limit:
            self.limit_degraded = True
            self.limit_notes.append('%s: limits %s not stored, the motion is left free at the saved pose (no limit)' % (c['name'], mate_limit_text(c)))
            self.note_option('mate %s: SolidWorks refused the limits; no plain mate is made (it would lock the motion): limits not stored' % c['name'])
            return None
        raise RuntimeError('SolidWorks AddMate5 refused every plan of mate %s (%s): a=%s; b=%s' % (c['name'], '; '.join((label for label, _ in plans)), json.dumps(c['a'], sort_keys=True), json.dumps(c['b'], sort_keys=True)))

    def read_back_limits(self, c):
        """The limits SolidWorks stored for the mate just made: IMate2.MinimumVariation / MaximumVariation of the newest mate (via
        IFeature.GetSpecificFeature2), in metres or radians. Said on the row; "limits not read back" where the API gives none."""
        low, high = (None, None)
        try:
            set_step('GetSpecificFeature2', 'read_back_limits')
            info = self.newest_mate().GetSpecificFeature2()
            if info is not None:
                set_step('MinimumVariation', 'read_back_limits')
                low, high = (float(info.MinimumVariation), float(info.MaximumVariation))
        except Exception as exc:
            self.note_option('mate %s: IMate2 read-back failed (%s)' % (c['name'], diagnostic_error(exc)))
        angular = c['type'] == 'limit_angle'
        unit = math.degrees if angular else lambda v: v / MM
        if low is None:
            self.limit_notes.append('%s: limits %s requested, limits not read back' % (c['name'], mate_limit_text(c)))
            return
        frame = limit_mate_frame(c)
        got_low, got_high = (unit(low) + frame['pose'], unit(high) + frame['pose'])
        mine, theirs = (-got_high, -got_low) if frame['negative'] else (got_low, got_high)
        stored = '%.6g..%.6g %s' % (mine, theirs, 'deg' if angular else 'mm')
        pose = '%.6g %s' % (float(c['value']), 'deg' if angular else 'mm')
        if frame['negative']:
            pose += ', passed as %.6g mm with Flip toggled' % frame['pose']
        if abs(got_low - frame['low']) > 1e-06 or abs(got_high - frame['high']) > 1e-06:
            self.limit_degraded = True
            self.limit_notes.append('%s: limits %s requested but %s stored (read back relative to the pose %s)' % (c['name'], mate_limit_text(c), stored, pose))
            return
        self.limit_notes.append('%s: limits %s stored (read back relative to the pose %s)' % (c['name'], stored, pose))

    def add_assembly_mate(self, c):
        """A coincident, distance (with or without limits) or angle limit mate between faces, origin points and default planes.

        The documented limit encoding is tried first; if AddMate5 refuses it (error 0, API doc risk 3) NO mate is made for that motion (a plain
        mate would drive and lock it): it stays free at the saved pose and the row says "limits not stored" (limit-mate-plain, degraded).
        After the mate the component's pose is read (translation and turn): while it was inserted at its pose every mate must keep it, and a
        component inserted elsewhere is judged after the last mate of its composition. A wrong pose undoes the mate and makes it once more with
        the other Flip or alignment (mate-flip-retry); a wrong pose again undoes that and fails the recipe."""
        feature = self.make_mate(c)
        moving = c.get('moving')
        limit = c['type'] == 'limit_angle' or 'min' in c
        final = c.get('name') in self.final_mates
        if feature is not None and moving in self.components and self.pose_wrong(moving, final):
            first = self.pose_text(moving)
            retry = mate_retry_plan(c)
            record_mitigation('mate-flip-retry', primary_failed=True, always=True)
            set_step('EditUndo2', 'add_assembly_mate')
            self.doc.EditUndo2(1)
            if retry is None:
                raise RuntimeError('mate %s left %s %s; there is no other alignment to try' % (c['name'], moving, first))
            feature = self.make_mate(c, **retry)
            if feature is None:
                raise RuntimeError('mate %s left %s %s; the other way of asking was refused' % (c['name'], moving, first))
            if self.pose_wrong(moving, final):
                second = self.pose_text(moving)
                set_step('EditUndo2', 'add_assembly_mate')
                self.doc.EditUndo2(1)
                raise RuntimeError('mate %s puts %s off its pose with both alignments: first %s; then %s' % (c['name'], moving, first, second))
            mitigations['mate-flip-retry']['fallback_ok'] += 1
        if feature is not None and limit:
            self.read_back_limits(c)
        if feature is not None and c.get('name') in self.wanted_mates:
            self.mate_features[c['name']] = self.newest_mate()
        return feature if feature is not None else self.last or self.doc

    def find_children(self, component, local, route):
        """The components named `local` among the children of `component`, found by one of CHILD_ROUTES: 0 IComponent2.GetChildren of the instance
        the build kept, 1 GetChildren of the top-level instance found again in the top assembly by name, 2 IAssemblyDoc.GetComponentByName with the
        path form ("pair2-1/pin-1"), 3 the top assembly's component tree (GetComponents(False)). SolidWorks 2021 (field 2026.11.24.4): the handles of
        route 0 read the subassembly document's own LOCAL transform and box, so moving them moved nothing in the top assembly."""
        assembly = api_interface(self.doc, 'AssemblyDoc')
        set_step('Name2', 'find_children')
        name = str(component.Name2)
        if route == 0:
            set_step('GetChildren', 'find_children')
            pool = component.GetChildren() or ()
        elif route == 1:
            set_step('GetComponentByName', 'find_children')
            top = assembly.GetComponentByName(name)
            set_step('GetChildren', 'find_children')
            pool = () if top is None else top.GetChildren() or ()
        elif route == 2:
            set_step('GetComponentByName', 'find_children')
            found = assembly.GetComponentByName(name + '/' + local)
            return [] if found is None else [found]
        else:
            set_step('GetComponents', 'find_children')
            return [c for c in assembly.GetComponents(False) or () if self.name2_of(c) == (True, name + '/' + local)]
        set_step('Name2', 'find_children')
        return [c for c in pool if str(c.Name2).rsplit('/', 1)[-1] == local]

    def locate(self, path, route=None):
        """The component an answer-key path ('mid/pair/block', or 'pair#2/block' for the second instance of a component pattern) names: the
        top-level label, then each subassembly's local instance name found among the children (the names of nested components are
        not looked up by GetComponentByName). `route` is how the children are found (find_children): by default the route a dragged part was
        found by (child_routes), else 0."""
        labels = path.split('/')
        first, _, number = labels[0].partition('#')
        if route is None:
            route = self.child_routes.get(path, 0)
        if number:
            instances = self.patterns.get(first)
            if not instances or not 1 <= int(number) <= len(instances):
                raise RuntimeError('component %r has no pattern instance %s' % (first, number))
            component = instances[int(number) - 1]
        else:
            component = check(self.components.get(first), 'no component %r in the assembly' % first)
        file = self.files.get(first)
        for label in labels[1:]:
            entry = check(self.trees.get(file, {}).get(label), 'subassembly %r has no component %r' % (file, label))
            local, child_file = (entry[0], entry[1])
            matches = self.find_children(component, local, route)
            if len(matches) != 1:
                set_step('Name2', 'locate')
                raise RuntimeError('%d children of %s are named %s' % (len(matches), component.Name2, local))
            component, file = (matches[0], child_file)
        return component

    def settle_route(self, path):
        """For the placement check: a leaf of a FLEXIBLE subassembly is read through the first route (find_children) whose handle reads where the top
        assembly has the part (child_check), as the drag found it; every other leaf keeps route 0."""
        top = self.components.get(path.split('/')[0])
        set_step('Solving', 'settle_route')
        if '/' not in path or path in self.child_routes or top is None or (int(top.Solving) != swComponentFlexibleSolving):
            return
        for route in range(len(CHILD_ROUTES)):
            try:
                if self.child_check(path, self.locate(path, route), route)[0]:
                    self.child_routes[path] = route
                    if route:
                        self.note_option('locate %s: %s reads where the top assembly has the part' % (path, CHILD_ROUTES[route]))
                    return
            except Exception:
                continue

    def note_flexible_child(self, path, total):
        """Only for a part a `move` dragged: its GetTotalTransform t0 and box center b0 were recorded before the move. If GetTotalTransform now
        disagrees in X or Y by more than 0.01 mm with t0 + (box centre now - b0) (the field: it read the local position after a drag), X/Y are
        judged by that (the box moved by the same as the part; no assumption that the part is symmetric about its origin), Z stays the transform's
        (placement-flexible-box). Returns the translation to judge (mm); unchanged for any other part or where the box is unavailable."""
        if path not in self.moved:
            return total
        t0, b0 = self.moved[path]
        try:
            centre = self.box_centre(self.locate(path))
        except Exception:
            return total
        if centre is None:
            return total
        expected = [t0[i] + centre[i] - b0[i] for i in range(3)]
        self.note_option('placement %s (moved part): GetTotalTransform (%s) mm, box center (%s) mm, before the move (%s) and (%s), so the part is at (%s)' % (path, mm_list(total), mm_list(centre), mm_list(t0), mm_list(b0), mm_list(expected)))
        if max(abs(expected[0] - total[0]), abs(expected[1] - total[1])) > 0.01:
            record_mitigation('placement-flexible-box')
            self.note_option('placement %s: GetTotalTransform misreports a flexible child; X/Y judged by the box center' % path)
            return [expected[0], expected[1], total[2]]
        return total

    def state_problems(self, item):
        """What expect.json says of the instance beyond its pose: config (the configuration the component references), external (a file link
        or a virtual copy), flexible (the solving option of the subassembly instance it is in) and mirrored_part (it is the new part file)."""
        problems = []
        top = self.components.get(item['path'].split('/')[0].split('#')[0])
        if top is None:
            return problems
        direct = '/' not in item['path']
        set_step('ReferencedConfiguration', 'state_problems')
        if 'config' in item and direct and (str(top.ReferencedConfiguration) != item['config']):
            set_step('ReferencedConfiguration', 'state_problems')
            problems.append('%s: references configuration %r, expected %r' % (item['path'], str(top.ReferencedConfiguration), item['config']))
        if 'external' in item and direct:
            set_step('IsVirtual', 'state_problems')
            virtual = bool(top.IsVirtual)
            if virtual == bool(item['external']):
                problems.append('%s: %s, expected %s' % (item['path'], 'a virtual copy' if virtual else 'a link to its own file', 'a link' if item['external'] else 'a virtual copy'))
            else:
                set_step('GetPathName', 'state_problems')
                if item['external'] and (not str(top.GetPathName()).lower().endswith('.sldprt')):
                    set_step('GetPathName', 'state_problems')
                    problems.append('%s: file %s is not a part file' % (item['path'], file_leaf(top.GetPathName())))
        set_step('Solving', 'state_problems')
        if 'flexible' in item and (int(top.Solving) == swComponentFlexibleSolving) != bool(item['flexible']):
            set_step('Solving', 'state_problems')
            problems.append('%s: its subassembly is %s, expected %s' % (item['path'], 'flexible' if int(top.Solving) == swComponentFlexibleSolving else 'rigid', 'flexible' if item['flexible'] else 'rigid'))
        set_step('PureWindowsPath', 'state_problems')
        if item.get('mirrored_part') and direct and (pathlib.PureWindowsPath(str(top.GetPathName())).stem != item['part']):
            set_step('GetPathName', 'state_problems')
            problems.append('%s: made from %s, expected the new part %s' % (item['path'], file_leaf(top.GetPathName()), item['part']))
        return problems

    def box_problems(self, expected):
        """The union of the top-level components' boxes against expect.json's bbox (A20, where t and R are not scored). IComponent2.GetBox is
        padded by about 0.44 mm on every side, so the tolerance is 0.6 mm."""
        set_step('GetBox', 'box_problems')
        boxes = [check(c.GetBox(False, False), 'component box unavailable') for c in self.components.values() if not c.IsSuppressed()]
        got = [min((b[i] for b in boxes)) * 1000.0 for i in range(3)] + [max((b[i + 3] for b in boxes)) * 1000.0 for i in range(3)]
        want = list(expected['bbox'][0]) + list(expected['bbox'][1])
        if max((abs(a - b) for a, b in zip(got, want))) > 0.6:
            return ['bbox (%s) mm, expected (%s) (box padded about 0.44 mm)' % (mm_list(got), mm_list(want))]
        return []

    def check_placements(self, expected):
        """Read every leaf instance's world transform (IComponent2.GetTotalTransform) and compare it with expect.json's answer
        (t 0.01 mm, R 1e-4; 'R_scored' false skips R of that instance, score_R / score_t false skip them all; suppressed instances are
        not read), then the state keys of the instance (state_problems) and, where the answer has one to check, the bbox. The verdict goes to
        the log and to the row; it never fails the recipe, so a field run still saves its files."""
        problems, checked, skipped = ([], 0, 0)
        assembly = api_interface(self.doc, 'AssemblyDoc')
        for label, component in list(self.components.items()):
            set_step('GetComponentByName', 'check_placements')
            fresh = assembly.GetComponentByName(str(component.Name2))
            if fresh is not None:
                self.components[label] = fresh
        for label, instances in self.patterns.items():
            for index, component in enumerate(instances):
                set_step('GetComponentByName', 'check_placements')
                fresh = assembly.GetComponentByName(str(component.Name2))
                if fresh is not None:
                    instances[index] = fresh
        for item in expected['instances']:
            if item.get('suppressed'):
                skipped += 1
                continue
            try:
                self.settle_route(item['path'])
                set_step('ArrayData', 'check_placements')
                t, rotation = pose_of(self.locate(item['path']).GetTotalTransform(True).ArrayData)
            except Exception as exc:
                problems.append('%s: cannot read it (%s)' % (item['path'], diagnostic_error(exc)))
                continue
            checked += 1
            t = self.note_flexible_child(item['path'], t)
            if expected.get('score_t', True) and max((abs(a - b) for a, b in zip(t, item['t']))) > 0.01:
                problems.append('%s: t = (%s) mm, expected (%s)' % (item['path'], mm_list(t), mm_list(item['t'])))
            if expected.get('score_R', True) and item.get('R_scored', True):
                same = lambda m: max((abs(m[i][j] - item['R'][i][j]) for i in range(3) for j in range(3))) <= 0.0001
                if not same(rotation):
                    flipped = [[rotation[j][i] for j in range(3)] for i in range(3)]
                    problems.append('%s: R = %s, expected %s%s' % (item['path'], mm_list([v for r in rotation for v in r]), mm_list([v for r in item['R'] for v in r]), ' (it matches when read the other way round)' if same(flipped) else ''))
            try:
                problems += self.state_problems(item)
            except Exception as exc:
                problems.append('%s: cannot read its state (%s)' % (item['path'], diagnostic_error(exc)))
        if expected.get('bbox'):
            try:
                problems += self.box_problems(expected)
            except Exception as exc:
                problems.append('bbox: cannot read it (%s)' % diagnostic_error(exc))
        self.placement_report = safe_error('pass (%d instances read back, %d suppressed not read)' % (checked, skipped) if not problems else 'fail (%d of %d): %s' % (len(problems), checked, '; '.join(problems)))
        if self.folder is not None:
            log_line(self.folder, 'placement check', self.placement_report)
        return self.placement_report

    def rebuild_noted(self, model, what):
        """EditRebuild3 where False is normal (SolidWorks answers False when nothing needed rebuilding): noted, never a failure."""
        set_step('EditRebuild3', 'rebuild_noted')
        if not model.EditRebuild3():
            self.note_option('EditRebuild3 returned False after %s (nothing needed rebuilding); carrying on' % what)

    def note_option(self, text):
        if self.folder is not None:
            log_line(self.folder, 'option', text)

    def reference_configuration(self, label, config):
        """The configuration of a placed part: AddComponent5 was given its name; IComponent2.ReferencedConfiguration says which one the
        component really references. If SolidWorks ignored the argument, the property is put (component-configuration-put)."""
        component = self.components[label]
        set_step('ReferencedConfiguration', 'reference_configuration')
        got = str(component.ReferencedConfiguration)
        if got != config:
            record_mitigation('component-configuration-put', primary_failed=True, always=True)
            set_step('ReferencedConfiguration', 'reference_configuration')
            component.ReferencedConfiguration = config
            set_step('ReferencedConfiguration', 'reference_configuration')
            got = str(component.ReferencedConfiguration)
            if got != config:
                raise RuntimeError('component %s references configuration %r after AddComponent5(..., %r) and after ReferencedConfiguration = %r' % (label, got, config, config))
            mitigations['component-configuration-put']['fallback_ok'] += 1
        self.config_of[label] = config
        self.note_option('component %s references configuration %r' % (label, got))

    def set_solving(self, component, flexible):
        """Flexible or rigid solving of a subassembly instance: IComponent2.Solving (there is no SetSolving method). If the put does not
        stick, the same is asked of the selected component through IAssemblyDoc.CompConfigProperties5 (flexible-compconfig)."""
        wanted = swComponentFlexibleSolving if flexible else swComponentRigidSolving
        set_step('Solving', 'set_solving')
        component.Solving = wanted
        set_step('Solving', 'set_solving')
        got = int(component.Solving)
        if got != wanted:
            record_mitigation('flexible-compconfig', primary_failed=True, always=True)
            set_step('ClearSelection2', 'set_solving')
            self.doc.ClearSelection2(True)
            set_step('Select4', 'set_solving')
            check(component.Select4(False, None, False), 'component selection failed')
            set_step('CompConfigProperties5', 'set_solving')
            api_interface(self.doc, 'AssemblyDoc').CompConfigProperties5(swComponentFullyResolved, wanted, swComponentVisible, False, '', False, False)
            set_step('Solving', 'set_solving')
            got = int(component.Solving)
            if got != wanted:
                set_step('Name2', 'set_solving')
                raise RuntimeError('component %s: Solving is %d after Solving = %d and after CompConfigProperties5 (swComponentSolvingOption_e: 0 rigid, 1 flexible)' % (component.Name2, got, wanted))
            mitigations['flexible-compconfig']['fallback_ok'] += 1
        set_step('EditRebuild3', 'set_solving')
        check(self.doc.EditRebuild3(), 'rebuild after changing the solving option failed')
        set_step('Name2', 'set_solving')
        self.note_option('component %s solves as %s (Solving = %d)' % (component.Name2, 'flexible' if flexible else 'rigid', got))

    @staticmethod
    def box_centre(component):
        """The center of IComponent2.GetBox(False, False) (the box in the top assembly, meters) in mm, or None where it cannot be read. A pin
        modelled as a cylinder about its axis has its axis at the centre X and Y; the box is padded the same on every side."""
        try:
            set_step('GetBox', 'box_centre')
            box = [float(v) for v in component.GetBox(False, False)]
            return [(box[i] + box[i + 3]) / 2.0 * 1000.0 for i in range(3)]
        except Exception:
            return None

    def inserted_poses(self, path):
        """The pose (ArrayData, meters) each part on `path` below the top-level instance was inserted at in its own subassembly document, or None
        where one is not known."""
        labels = path.split('/')
        file, poses = (self.files.get(labels[0].partition('#')[0]), [])
        for label in labels[1:]:
            entry = self.trees.get(file, {}).get(label)
            if entry is None or len(entry) < 3 or entry[2] is None:
                return None
            poses.append(entry[2])
            file = entry[1]
        return poses

    def child_check(self, path, child, route=0):
        """(True when `child` is the part as the top assembly has it, the text for the log, its GetTotalTransform and where its instance puts it, mm). Read BEFORE the part is moved: its GetTotalTransform
        must be its instance's world transform carried onto its own Transform2 (the instance of A24 is at X=50 mm, so the pin reads X=50); that alone
        judges the handle, whatever the part's shape (a handle that is the subassembly document's own reads X=0). The box centre is logged as evidence
        only: it sits over the origin for a part symmetric about it, not for one whose origin is at a corner. every handle on the path is found by `route`."""
        set_step('ArrayData', 'child_check')
        total = pose_of(child.GetTotalTransform(True).ArrayData)[0]
        set_step('ArrayData', 'child_check')
        local = pose_of(child.Transform2.ArrayData)[0]
        labels = path.split('/')
        set_step('ArrayData', 'child_check')
        expected, rotation = pose_of(self.locate(labels[0]).GetTotalTransform(True).ArrayData)
        inserted = self.inserted_poses(path)
        for depth in range(2, len(labels) + 1):
            if inserted is not None:
                step_t, step_r = pose_of(inserted[depth - 2])
            else:
                step = child if depth == len(labels) else self.locate('/'.join(labels[:depth]), route)
                set_step('ArrayData', 'child_check')
                step_t, step_r = pose_of(step.Transform2.ArrayData)
            expected = [expected[i] + sum((rotation[i][j] * step_t[j] for j in range(3))) for i in range(3)]
            rotation = [[sum((rotation[i][m] * step_r[m][j] for m in range(3))) for j in range(3)] for i in range(3)]
        box = self.box_centre(child)
        pose_ok = max((abs(a - b) for a, b in zip(total, expected))) <= 0.05
        verdict = 'it is the part in the top assembly' if pose_ok else "the wrong handle: it reads the subassembly document's own coordinates"
        return (pose_ok, 'GetTotalTransform (%s) mm, Transform2 (%s) mm, box center (%s) mm, carried by its instance it should read (%s) mm: %s' % (mm_list(total), mm_list(local), 'unreadable' if box is None else mm_list(box), mm_list(expected), verdict), total, expected)

    def move_component(self, p):
        """Drag a part of a flexible subassembly in the top assembly (A24). The part is found through the top assembly by the routes of
        find_children in turn (SolidWorks 2021, field 2026.11.24.4: the pin handle taken from the subassembly's own tree read the local transform and
        box, so every try moved nothing in the top assembly); each handle is read BEFORE the move (child_check, logged with the route) and the first
        one that reads where the top assembly has the part is moved by the ladder of drag_component. A handle of an instance that stands at the origin
        cannot be told from the part by that reading (local and world agree), so when a ladder fails the next route is read again: where the part
        stands is where it stood (the earlier try moved nothing: it is dragged on that route) or at the wanted place (the earlier try moved it), and
        anywhere else the state is unknown and the recipe fails. A route other than the first is flexible-child-from-top-instance. Where no route reads
        right, the ladder runs on the first handle that was found all the same, and the error carries what each route found."""
        path, by = (p['component'], p['by'])
        found, notes, origin, failure = ([], [], None, None)
        for route in range(len(CHILD_ROUTES)):
            try:
                child = self.locate(path, route)
                ok, text, total, expected = self.child_check(path, child, route)
            except Exception as exc:
                text = 'found no part (%s)' % diagnostic_error(exc)
                self.note_option('locate %s: %s %s' % (path, CHILD_ROUTES[route], text))
                notes.append('%s: %s' % (CHILD_ROUTES[route], text))
                continue
            self.note_option('locate %s: %s found the part before the move: %s' % (path, CHILD_ROUTES[route], text))
            notes.append('%s: %s' % (CHILD_ROUTES[route], text))
            found.append(route)
            if origin is None:
                origin = expected
            if not ok:
                continue
            if failure is not None:
                if max((abs(a - b - v) for a, b, v in zip(total, origin, by))) <= 0.01:
                    self.child_routes[path] = route
                    self.note_option('locate %s: %s reads the part at the wanted place: the earlier try had moved it' % (path, CHILD_ROUTES[route]))
                    return self.locate(path)
                if max((abs(a - b) for a, b in zip(total, origin))) > 0.01:
                    break
            try:
                return self.drag_on_route(p, route, notes)
            except RuntimeError as exc:
                failure = failure or exc
        if failure is not None:
            raise failure
        if not found:
            raise RuntimeError('no route finds the part %s in the top assembly: %s' % (path, ' | '.join(notes)))
        return self.drag_on_route(p, found[0], notes)

    def drag_on_route(self, p, route, notes):
        """The ladder of drag_component on the part the route found; flexible-child-from-top-instance when the route is not the first."""
        if route:
            record_mitigation('flexible-child-from-top-instance', primary_failed=True, always=True)
        try:
            component = self.drag_component(p, route)
        except RuntimeError as exc:
            self.child_routes.pop(p['component'], None)
            raise RuntimeError('%s [%s: %s]' % (exc, 'handles read before the move', ' | '.join(notes))) if len(notes) > 1 else exc
        if route:
            mitigations['flexible-child-from-top-instance']['fallback_ok'] += 1
        return component

    def drag_component(self, p, route):
        """Drag a part of a flexible subassembly in the top assembly (A24). Where the part ends up is read from IComponent2.GetBox, which the
        field run showed to be the truth when GetTotalTransform disagrees (2026.11.24.3: SetTransformAndSolve2 returned True, GetTotalTransform read
        the pin's unmoved LOCAL position). The ladder: 0 the assembly's drag operator (IAssemblyDoc.GetDragOperator: AddComponent, BeginDrag, Drag with a
        translation, EndDrag; flexible-move-drag-operator; round 22, field 2026.11.24.6 on SolidWorks 2023, where SetTransformAndSolve2 answered True
        for every handle and moved nothing), 1 SetTransformAndSolve2 with the WORLD transform (GetTotalTransform moved by `by`,
        flexible-move-world-transform), 2 SetTransformAndSolve2 with the child's local transform (Transform2 moved by `by`), 3 Transform2 put and
        the assembly rebuilt (2 and 3 are flexible-move-transform2). After EVERY rung "moved" is judged from a part found again through the top
        assembly (fresh_child), never from the handle kept from before the move (it goes stale: the field read (0,0,10) on it); Transform2,
        GetTotalTransform and the box centre are logged after every try. The move is by `by` in the top assembly's axes (A24: the subassembly is
        not turned)."""
        path, by = (p['component'], p['by'])
        self.child_routes[path] = route
        child = self.locate(path)
        start = self.fresh_child(path)
        set_step('ArrayData', 'drag_component')
        before = pose_of(start.GetTotalTransform(True).ArrayData)[0]
        box_before = self.box_centre(start)
        if box_before is not None:
            self.moved[path] = (before, box_before)
        wanted = [b + v for b, v in zip(before, by)]

        def moved_by(values):
            transform = [float(v) for v in values]
            for i in range(3):
                transform[9 + i] += by[i] * MM
            set_step('CreateTransform', 'moved_by')
            return check(self.app.GetMathUtility().CreateTransform(double_array(transform)), 'component transform creation failed')
        set_step('ArrayData', 'drag_component')
        world = moved_by(start.GetTotalTransform(True).ArrayData)
        set_step('ArrayData', 'drag_component')
        local = moved_by(child.Transform2.ArrayData)

        def read(label):
            fresh = self.fresh_child(path)
            set_step('ArrayData', 'read')
            total = pose_of(fresh.GetTotalTransform(True).ArrayData)[0]
            box = self.box_centre(fresh)
            by_total = max((abs(a - b) for a, b in zip(total, wanted))) <= 0.01
            by_box = None if box is None or box_before is None else max((abs(c - b0 - v) for c, b0, v in zip(box, box_before, by))) <= 0.01
            verdict = 'the box is unreadable' if by_box is None else 'the box says moved' if by_box else 'the box says not moved'
            if by_box is not None and by_box != by_total:
                verdict += ', GetTotalTransform disagrees'
            set_step('ArrayData', 'read')
            self.note_option('move %s by %s mm, %s: Transform2 (%s), GetTotalTransform (%s), box center (%s), wanted (%s); %s' % (path, by, label, mm_list([float(v) * 1000.0 for v in fresh.Transform2.ArrayData[9:12]]), mm_list(total), mm_list(box) if box is not None else 'unreadable', mm_list(wanted), verdict))
            try:
                kept_box = self.box_centre(child)
                set_step('ArrayData', 'read')
                self.note_option('kept handle of %s after %s: Transform2 (%s), GetTotalTransform (%s), box center (%s)' % (path, label, mm_list([float(v) * 1000.0 for v in child.Transform2.ArrayData[9:12]]), mm_list(pose_of(child.GetTotalTransform(True).ArrayData)[0]), 'unreadable' if kept_box is None else mm_list(kept_box)))
            except Exception as exc:
                self.note_option('kept handle of %s after %s: unreadable (%s)' % (path, label, diagnostic_error(exc)))
            return (total, by_total if by_box is None else by_box)
        record_mitigation('flexible-move-drag-operator')
        dragged = self.drag_operator_move(start, moved_by([1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]))
        now, ok = read(dragged)
        if ok:
            return self.locate(path)
        ok, mated = self.move_by_temporary_mate(path, start, wanted, read)
        if ok:
            return self.locate(path)
        dragged += '; ' + mated
        record_mitigation('flexible-move-world-transform')
        set_step('SetTransformAndSolve2', 'drag_component')
        solved_world = child.SetTransformAndSolve2(world)
        now, ok = read('SetTransformAndSolve2 with the world transform returned %s' % solved_world)
        if ok:
            return self.locate(path)
        record_mitigation('flexible-move-transform2', primary_failed=True, always=True)
        set_step('SetTransformAndSolve2', 'drag_component')
        solved_local = self.locate(path).SetTransformAndSolve2(local)
        now, ok = read('SetTransformAndSolve2 with the local transform returned %s' % solved_local)
        if not ok:
            set_step('Transform2', 'drag_component')
            self.locate(path).Transform2 = local
            set_step('EditRebuild3', 'drag_component')
            check(self.doc.EditRebuild3(), 'rebuild after moving the component failed')
            now, ok = read('Transform2 put and the assembly rebuilt')
            if not ok:
                raise RuntimeError('the part %s did not move by %s mm: %s; SetTransformAndSolve2 returned %s with the world transform and %s with the local transform, it stayed at (%s) and after Transform2 it is at (%s), wanted (%s); is its subassembly flexible?' % (path, by, dragged, solved_world, solved_local, mm_list(before), mm_list(now), mm_list(wanted)))
        mitigations['flexible-move-transform2']['fallback_ok'] += 1
        return self.locate(path)

    def fresh_child(self, path):
        """The part found again through the top assembly (the component tree, route 3; else by the route it was found by): what a move is judged from.
        A handle kept from before the move goes stale (field 2026.11.24.6: it read the old pose after the part had moved)."""
        try:
            return self.locate(path, 3) if '/' in path else self.locate(path)
        except Exception:
            return self.locate(path)

    def drag_operator_move(self, child, translation):
        """The first rung of a drag (flexible-move-drag-operator): IAssemblyDoc.GetDragOperator, AddComponent(part, False), collision detection off,
        DragMode minimum move, TransformType translation, BeginDrag, Drag(translation) and EndDrag, on the part found through the top assembly (`start`: a handle the route found can be the subassembly document's own, which the operator would not move). The text says what every call answered (it goes
        into the log and the error); a failure of any call is not raised, the next rung is tried."""
        steps, began, operator = ([], False, None)
        self.top_handle, self.top_handle_tried = (None, False)
        try:
            set_step('GetDragOperator', 'drag_operator_move')
            operator = api_interface(self.doc, 'AssemblyDoc').GetDragOperator()
            if operator is None:
                return 'GetDragOperator returned Nothing'
            selected, selection_note = self.selected_component(child)
            set_step('Name2', 'drag_operator_move')
            self.note_option('drag handle of %s: %s' % (child.Name2, selection_note))
            self.top_handle, self.top_handle_tried = (selected, True)
            answers = []
            for label, handle in (('selected handle', selected), ('current handle', child)):
                if handle is None:
                    continue
                set_step('AddComponent', 'drag_operator_move')
                answers.append((label, operator.AddComponent(handle, False)))
                if answers[-1][1]:
                    break
            if len(answers) == 1:
                steps.append('AddComponent returned %s' % answers[0][1])
            else:
                steps.append('AddComponent returned ' + ' and '.join(('%s (%s)' % (a, l) for l, a in answers)))
            try:
                set_step('CollisionDetectionEnabled', 'drag_operator_move')
                operator.CollisionDetectionEnabled = False
                steps.append('CollisionDetectionEnabled = False')
            except Exception as exc:
                steps.append('CollisionDetectionEnabled raised (%s)' % diagnostic_error(exc))
            set_step('DragMode', 'drag_operator_move')
            operator.DragMode = swDragModeMinimumMove
            set_step('TransformType', 'drag_operator_move')
            operator.TransformType = swDragTransformTranslation
            set_step('BeginDrag', 'drag_operator_move')
            began = operator.BeginDrag()
            steps.append('BeginDrag returned %s' % began)
            if began:
                set_step('Drag', 'drag_operator_move')
                steps.append('Drag returned %s' % operator.Drag(translation))
        except Exception as exc:
            steps.append('raised (%s)' % diagnostic_error(exc))
        if began:
            try:
                set_step('EndDrag', 'drag_operator_move')
                operator.EndDrag()
                steps.append('EndDrag called')
            except Exception as exc:
                steps.append('EndDrag raised (%s)' % diagnostic_error(exc))
        return 'IDragOperator: ' + ', '.join(steps)

    def selected_component(self, component):
        """The part as the top assembly sees it: it is selected by its full component path with IModelDocExtension.SelectByID2 (the forms
        Name2@Title, the @ chain pin-1@pair2-1@Title and pin-1@Title/pair2-1, in turn) and ISelectionMgr.GetSelectedObjectsComponent4(1, -1) answers
        the component. Returns (handle or None, what happened)."""
        doc = self.doc
        set_step('GetTitle', 'selected_component')
        title = re.sub('\\.sldasm$', '', str(doc.GetTitle()), flags=re.I)
        set_step('Name2', 'selected_component')
        parts = str(component.Name2).split('/')
        set_step('Name2', 'selected_component')
        forms = [str(component.Name2) + '@' + title, '@'.join(reversed(parts)) + '@' + title]
        if len(parts) > 1:
            forms.append(parts[-1] + '@' + title + '/' + '/'.join(parts[:-1]))
        tried = []
        for full in forms:
            try:
                set_step('ClearSelection2', 'selected_component')
                doc.ClearSelection2(True)
                set_step('SelectByID2', 'selected_component')
                returned = doc.Extension.SelectByID2(full, 'COMPONENT', 0.0, 0.0, 0.0, False, 0, None, 0)
                set_step('GetSelectedObjectCount2', 'selected_component')
                count = doc.SelectionManager.GetSelectedObjectCount2(-1)
                set_step('GetSelectedObjectsComponent4', 'selected_component')
                handle = doc.SelectionManager.GetSelectedObjectsComponent4(1, -1) if count else None
            except Exception as exc:
                tried.append('%s raised (%s)' % (full, diagnostic_error(exc)))
                continue
            tried.append('%s: SelectByID2 returned %s, %d selected, GetSelectedObjectsComponent4 gave %s' % (full, returned, count, 'a component' if handle is not None else 'nothing'))
            if handle is not None:
                set_step('ClearSelection2', 'selected_component')
                doc.ClearSelection2(True)
                return (handle, 'selected as ' + tried[-1])
        set_step('ClearSelection2', 'selected_component')
        doc.ClearSelection2(True)
        return (None, 'no selection gave a component (' + ' | '.join(tried) + ')')

    def feature_names(self):
        set_step('FirstFeature', 'feature_names')
        names, feature = (set(), self.doc.FirstFeature())
        while feature is not None:
            set_step('Name', 'feature_names')
            names.add(str(feature.Name))
            set_step('GetNextFeature', 'feature_names')
            feature = feature.GetNextFeature()
        return names

    def mate_items(self):
        """The sub-features of the MateGroup (the assembly's mates), in order."""
        set_step('FirstFeature', 'mate_items')
        group, feature = (None, self.doc.FirstFeature())
        while feature is not None:
            set_step('GetTypeName2', 'mate_items')
            if feature.GetTypeName2() == 'MateGroup':
                group = feature
            set_step('GetNextFeature', 'mate_items')
            feature = feature.GetNextFeature()
        set_step('GetFirstSubFeature', 'mate_items')
        items, item = ([], group.GetFirstSubFeature() if group is not None else None)
        while item is not None:
            items.append(item)
            set_step('GetNextSubFeature', 'mate_items')
            item = item.GetNextSubFeature()
        return items

    def mate_count(self):
        return len(self.mate_items())

    def axis_through(self, origin, direction):
        """A reference axis through the point `origin` (meters) along `direction`: a construction line of a 3D sketch and IModelDoc2.InsertAxis2, as
        world_axis makes the axes through the origin. The axis must be NEW (a RefAxis that was not in the tree before InsertAxis2); the 3D sketch is
        tracked in self.sketch3d_open so an error between its two Insert3DSketch calls can close it. Returns the axis feature."""
        doc = self.doc
        axes_before = set()
        set_step('FirstFeature', 'axis_through')
        feature = doc.FirstFeature()
        while feature is not None:
            set_step('GetTypeName2', 'axis_through')
            if feature.GetTypeName2() == 'RefAxis':
                set_step('Name', 'axis_through')
                axes_before.add(str(feature.Name))
            set_step('GetNextFeature', 'axis_through')
            feature = feature.GetNextFeature()
        set_step('ClearSelection2', 'axis_through')
        doc.ClearSelection2(True)
        set_step('SketchManager', 'axis_through')
        sm = doc.SketchManager
        set_step('Insert3DSketch', 'axis_through')
        sm.Insert3DSketch(True)
        self.sketch3d_open = True
        set_step('CreateLine', 'axis_through')
        segment = check(sm.CreateLine(origin[0], origin[1], origin[2], *[o + v * 0.01 for o, v in zip(origin, direction)]), 'axis line failed')
        set_step('ConstructionGeometry', 'axis_through')
        segment.ConstructionGeometry = True
        set_step('Insert3DSketch', 'axis_through')
        sm.Insert3DSketch(True)
        self.sketch3d_open = False
        set_step('ClearSelection2', 'axis_through')
        doc.ClearSelection2(True)
        select(doc, segment, topology=False)
        set_step('InsertAxis2', 'axis_through')
        check(doc.InsertAxis2(True), 'reference axis creation failed')
        axis_feature = newest_of_type(doc, 'RefAxis')
        set_step('Name', 'axis_through')
        if axis_feature is None or str(axis_feature.Name) in axes_before:
            raise RuntimeError('InsertAxis2 made no axis (no RefAxis feature that was not in the tree before; %d older axes)' % len(axes_before))
        return axis_feature

    def delete_features(self, features):
        """Delete features one at a time (IFeature.Select2 and IModelDocExtension.DeleteSelection2), in the order given. Returns the failures."""
        failures = []
        for label, feature in features:
            set_step('ClearSelection2', 'delete_features')
            self.doc.ClearSelection2(True)
            try:
                set_step('Select2', 'delete_features')
                selected = feature.Select2(False, 0)
                set_step('DeleteSelection2', 'delete_features')
                deleted = self.doc.Extension.DeleteSelection2(0)
            except Exception as exc:
                failures.append('%s: raised (%s)' % (label, diagnostic_error(exc)))
                continue
            if not deleted:
                failures.append('%s: Select2 returned %s, DeleteSelection2 returned %s' % (label, selected, deleted))
        set_step('ClearSelection2', 'delete_features')
        self.doc.ClearSelection2(True)
        return failures

    def clean_up_temporary(self, names_before, mate_names_before):
        """Closes a 3D sketch left open, then deletes what the temporary-mate rung made: the mates that were not in the MateGroup before, the new reference
        axes, the new sketches (every feature that was not in the tree before, except the Mates folder). Safe to call again. Returns the failures."""
        failures = []
        if getattr(self, 'sketch3d_open', False):
            try:
                set_step('Insert3DSketch', 'clean_up_temporary')
                self.doc.SketchManager.Insert3DSketch(True)
            except Exception as exc:
                failures.append('closing the 3D sketch raised (%s)' % diagnostic_error(exc))
            self.sketch3d_open = False
        set_step('Name', 'clean_up_temporary')
        fresh_mates = [('mate ' + str(m.Name), m) for m in self.mate_items() if str(m.Name) not in mate_names_before]
        failures += self.delete_features(fresh_mates)
        set_step('FirstFeature', 'clean_up_temporary')
        fresh, feature = ([], self.doc.FirstFeature())
        while feature is not None:
            set_step('Name', 'clean_up_temporary')
            if str(feature.Name) not in names_before and feature.GetTypeName2() != 'MateGroup':
                fresh.append(feature)
            set_step('GetNextFeature', 'clean_up_temporary')
            feature = feature.GetNextFeature()
        set_step('Name', 'clean_up_temporary')
        failures += self.delete_features([('axis ' + str(f.Name), f) for f in fresh if f.GetTypeName2() == 'RefAxis'])
        set_step('Name', 'clean_up_temporary')
        failures += self.delete_features([('sketch ' + str(f.Name), f) for f in fresh if f.GetTypeName2() != 'RefAxis'])
        return failures

    def temporary_leftovers(self, names_before, mate_names_before):
        """What the rung left in the assembly: the mates and top-level features that were not there before it, as text ('' for nothing)."""
        set_step('Name', 'temporary_leftovers')
        mates = [str(m.Name) for m in self.mate_items() if str(m.Name) not in mate_names_before]
        set_step('Name', 'temporary_leftovers')
        gone = sorted((n for n in mate_names_before if n not in {str(m.Name) for m in self.mate_items()}))
        features = sorted((n for n in self.feature_names() if n not in names_before))
        parts = []
        if mates:
            parts.append('mates ' + ', '.join(mates))
        if gone:
            parts.append('mates missing ' + ', '.join(gone))
        if features:
            parts.append('features ' + ', '.join(features))
        return '; '.join(parts)

    def move_by_temporary_mate(self, path, start, wanted, read):
        """A24 flexible-move-temporary-mate: the part is moved by a Concentric mate (IAssemblyDoc.AddMate5, swMateCONCENTRIC) between its cylindrical face,
        taken in the top assembly's context (the selected handle of the drag operator's rung, else one selected here, else `start`;
        IComponent2.GetCorrespondingEntity), and a reference axis through the wanted place along the cylinder's axis. Read through a part found again
        (`read`); the mate, the axis and the 3D sketch are then deleted, the assembly is rebuilt and the part must STILL be at the wanted place (it is free
        in X and Y). The MateGroup's mates and the tree's features are recorded before and compared after EVERY path: whatever the rung left behind stops the
        recipe (a later rung must never run on, or the assembly be saved with, a stray mate, axis or sketch). Returns (moved, text): not moved leaves the part
        where it was and the next rung is tried; a part that goes back when the mate is deleted raises. On 2021, 2023 and 2026 SetTransformAndSolve2 never
        moved the pin (on 2026 it reset it to its subassembly-local pose), so this rung is before it."""
        import pythoncom
        from win32com.client import VARIANT
        record_mitigation('flexible-move-temporary-mate', primary_failed=True, always=True)
        doc, assembly = (self.doc, api_interface(self.doc, 'AssemblyDoc'))
        names_before = self.feature_names()
        set_step('Name', 'move_by_temporary_mate')
        mate_names_before = {str(m.Name) for m in self.mate_items()}
        mates_before, steps, problem, moved, text = (len(mate_names_before), [], None, False, '')
        now = now_after = None
        ok_after = False
        mates_during = mates_before
        self.sketch3d_open = False
        try:
            component, kind = (getattr(self, 'top_handle', None), 'the selected handle of the drag operator')
            if component is None:
                if not getattr(self, 'top_handle_tried', False):
                    component, note = self.selected_component(start)
                    set_step('Name2', 'move_by_temporary_mate')
                    self.note_option('temporary mate handle of %s: %s' % (start.Name2, note))
                    kind = 'the handle selected for the mate'
                if component is None:
                    component, kind = (start, 'the handle found by the route (no selected handle)')
            self.note_option('temporary mate: the face is mapped through %s' % kind)
            set_step('GetModelDoc2', 'move_by_temporary_mate')
            model = check(component.GetModelDoc2(), 'component model is not loaded')
            face = None
            set_step('GetBodies2', 'move_by_temporary_mate')
            for body in api_interface(model, 'PartDoc').GetBodies2(0, False) or ():
                set_step('GetFaces', 'move_by_temporary_mate')
                for candidate in body.GetFaces() or ():
                    set_step('GetSurface', 'move_by_temporary_mate')
                    surface = candidate.GetSurface()
                    set_step('IsCylinder', 'move_by_temporary_mate')
                    if surface is not None and surface.IsCylinder():
                        face = candidate
                        break
                if face is not None:
                    break
            check(face, 'the part has no cylindrical face')
            set_step('CylinderParams', 'move_by_temporary_mate')
            params = [float(v) for v in face.GetSurface().CylinderParams]
            set_step('ArrayData', 'move_by_temporary_mate')
            total = [float(v) for v in component.GetTotalTransform(True).ArrayData]
            world = lambda p: [sum((p[k] * total[3 * k + j] for k in range(3))) + total[9 + j] for j in range(3)]
            heading = [sum((params[3 + k] * total[3 * k + j] for k in range(3))) for j in range(3)]
            size = math.sqrt(sum((v * v for v in heading)))
            heading = [v / size for v in heading]
            there = [a + b * MM for a, b in zip(world(params[0:3]), [w - b for w, b in zip(wanted, pose_of(total)[0])])]
            steps.append('axis through (%s) mm along (%s)' % (mm_list([v * 1000.0 for v in there]), mm_list(heading)))
            axis_feature = self.axis_through(there, heading)
            set_step('GetCorrespondingEntity', 'move_by_temporary_mate')
            entity = check(component.GetCorrespondingEntity(face), 'the cylindrical face has no counterpart in the top assembly')
            errors, feature, tried, arguments = (None, None, [], mate_arguments({'type': 'concentric'}, True))
            for align in (swMateAlignCLOSEST, swMateAlignALIGNED, swMateAlignANTI_ALIGNED):
                set_step('ClearSelection2', 'move_by_temporary_mate')
                doc.ClearSelection2(True)
                select(doc, entity, False, 1)
                set_step('Select2', 'move_by_temporary_mate')
                check(axis_feature.Select2(True, 1), 'the reference axis could not be selected')
                errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
                set_step('AddMate5', 'move_by_temporary_mate')
                feature = assembly.AddMate5(arguments[0], align, *arguments[2:], errors)
                tried.append('Align %d answered error %s' % (align, errors.value))
                if errors.value == swAddMateError_NoError and feature is not None:
                    break
            steps.append('AddMate5 Concentric: ' + ', '.join(tried))
            check(errors.value == swAddMateError_NoError and feature is not None, 'AddMate5 Concentric made no mate (%s)' % ', '.join(tried))
            mates_during = self.mate_count()
            now, ok = read('temporary Concentric mate to the axis (%s; mates %d -> %d)' % ('; '.join(steps), mates_before, mates_during))
            if not ok:
                text = 'the temporary Concentric mate left the part at (%s)' % mm_list(now)
            else:
                moved = True
                problem_delete = self.clean_up_temporary(names_before, mate_names_before)
                set_step('EditRebuild3', 'move_by_temporary_mate')
                doc.EditRebuild3()
                now_after, ok_after = read('temporary mate, axis and 3D sketch deleted and the assembly rebuilt')
                if problem_delete:
                    steps.append('deleting: ' + ' | '.join(problem_delete))
        except Exception as exc:
            problem = diagnostic_error(exc)
        try:
            failures = self.clean_up_temporary(names_before, mate_names_before)
        except Exception as exc:
            failures = ['clean-up raised (%s)' % diagnostic_error(exc)]
        left = self.temporary_leftovers(names_before, mate_names_before)
        if left:
            raise RuntimeError('the temporary Concentric mate rung for %s left %s in the assembly (%s%s); the recipe stops here, no later rung runs on it' % (path, left, 'clean-up: ' + ' | '.join(failures) if failures else 'nothing reported failing', '; the rung failed with: ' + problem if problem else ''))
        if problem:
            return (False, 'temporary Concentric mate: %s' % problem)
        if not moved:
            return (False, text)
        if not ok_after:
            raise RuntimeError('the part %s went back when the temporary Concentric mate was deleted: it read (%s) mm with the mate and (%s) mm after the mate, its axis and its 3D sketch were deleted and the assembly rebuilt, wanted (%s) mm; the mate is not kept (the mate count would differ from the answer key)' % (path, mm_list(now), mm_list(now_after), mm_list(wanted)))
        mitigations['flexible-move-temporary-mate']['fallback_ok'] += 1
        return (True, 'temporary Concentric mate moved the part')

    def make_virtual(self, label):
        """Make Virtual on a placed part (A23b): IComponent2.MakeVirtual2; if no component is virtual afterwards, the component is selected and
        IComponent2.MakeVirtual is called (make-virtual-selected). The virtual component has a new name, so it is found again by IsVirtual."""
        assembly = api_interface(self.doc, 'AssemblyDoc')
        component = self.components[label]

        def virtual():
            set_step('GetComponents', 'virtual')
            found = [c for c in assembly.GetComponents(True) or () if c.IsVirtual]
            return found[0] if len(found) == 1 else None
        set_step('MakeVirtual2', 'make_virtual')
        component.MakeVirtual2(False)
        fresh = virtual()
        if fresh is None:
            record_mitigation('make-virtual-selected', primary_failed=True, always=True)
            set_step('ClearSelection2', 'make_virtual')
            self.doc.ClearSelection2(True)
            set_step('Select4', 'make_virtual')
            check(component.Select4(False, None, False), 'component selection failed')
            set_step('MakeVirtual', 'make_virtual')
            component.MakeVirtual()
            set_step('Name2', 'make_virtual')
            fresh = check(virtual(), 'no component is virtual after MakeVirtual2(False) and after MakeVirtual of the selected component %s' % component.Name2)
            mitigations['make-virtual-selected']['fallback_ok'] += 1
        self.components[label] = fresh
        set_step('Name2', 'make_virtual')
        self.note_option('component %s is virtual now (name %s)' % (label, fresh.Name2))
        return fresh

    def depth_dimension(self, model, wanted):
        """The depth dimension of the first extrusion of a box part (its first display dimension), which must hold the part's own height."""
        set_step('FirstFeature', 'depth_dimension')
        feature = model.FirstFeature()
        while feature is not None:
            set_step('GetTypeName2', 'depth_dimension')
            if feature.GetTypeName2() == 'Extrusion':
                set_step('GetFirstDisplayDimension', 'depth_dimension')
                display = check(feature.GetFirstDisplayDimension(), 'the extrusion has no dimension to edit')
                set_step('GetDimension2', 'depth_dimension')
                dimension = check(display.GetDimension2(0), 'extrusion depth dimension unavailable')
                set_step('SystemValue', 'depth_dimension')
                if wanted is not None and abs(float(dimension.SystemValue) - wanted) > 1e-06:
                    set_step('SystemValue', 'depth_dimension')
                    raise RuntimeError('the first dimension of the extrusion is %.6g m, not the depth %.6g m' % (float(dimension.SystemValue), wanted))
                return dimension
            set_step('GetNextFeature', 'depth_dimension')
            feature = feature.GetNextFeature()
        raise RuntimeError('the part has no Extrusion feature to edit')

    def copy_part_file(self, recipe, file):
        """Open the run's own part file silently and save it under another name beside it. The document is the copy from then on; the
        original file on disk is not written. Returns the open copy."""
        import pythoncom
        from win32com.client import VARIANT
        errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
        warnings = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
        set_step('OpenDoc6', 'copy_part_file')
        model = self.app.OpenDoc6(str(self.folder / (recipe + '.sldprt')), swDocPART, swOpenDocOptions_Silent, '', errors, warnings)
        if errors.value:
            raise RuntimeError('SolidWorks OpenDoc6 error %s opening %s to copy it' % (errors.value, recipe))
        model = check(model, 'the part to copy could not be opened')
        privacy(model)
        save(model, self.folder / (file + '.sldprt'))
        if file + '.sldprt' not in self.extra_files:
            self.extra_files.append(file + '.sldprt')
        return model

    def copy_part(self, p):
        """A23c: the block's file is a copy of P01a made for this recipe (the run's P01a.sldprt is shared with other recipes)."""
        model = self.copy_part_file(p['recipe'], p['file'])
        set_step('CloseDoc', 'copy_part')
        self.app.CloseDoc(model.GetTitle())
        self.note_option('%s.sldprt is a copy of %s.sldprt; the original file is not touched' % (p['file'], p['recipe']))
        return self.doc

    def part_readback(self, model, file, configs, depths, active):
        """What the saved part file must say when it is read again from disk (check_saved_states): its configurations, the active one, and the
        depth of the extrusion in each configuration (metres)."""
        set_step('GetTitle', 'part_readback')
        self.state_checks.append(dict(kind='part', file=file, title=str(model.GetTitle()), configs=list(configs), depths=dict(depths), active=active))

    def read_back_part(self, entry):
        """Close the part (it is not referenced any more: the assembly is closed), open the file that was saved and read the depths back."""
        import pythoncom
        from win32com.client import VARIANT
        set_step('CloseDoc', 'read_back_part')
        self.app.CloseDoc(entry['title'])
        set_step('CloseDoc', 'read_back_part')
        self.app.CloseDoc(entry['file'] + '.sldprt')
        errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
        warnings = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
        set_step('OpenDoc6', 'read_back_part')
        model = self.app.OpenDoc6(str(self.folder / (entry['file'] + '.sldprt')), swDocPART, swOpenDocOptions_Silent, '', errors, warnings)
        if errors.value:
            raise RuntimeError('SolidWorks OpenDoc6 error %s reopening %s.sldprt to read it back' % (errors.value, entry['file']))
        model = check(model, 'the saved part %s.sldprt could not be reopened to read it back' % entry['file'])
        try:
            set_step('GetConfigurationNames', 'read_back_part')
            names = sorted((str(n) for n in model.GetConfigurationNames() or ()))
            if names != sorted(entry['configs']):
                raise RuntimeError('saved part %s.sldprt has configurations %s, expected %s' % (entry['file'], names, sorted(entry['configs'])))
            set_step('Name', 'read_back_part')
            if str(model.ConfigurationManager.ActiveConfiguration.Name) != entry['active']:
                set_step('Name', 'read_back_part')
                raise RuntimeError('saved part %s.sldprt has configuration %r active, expected %r' % (entry['file'], str(model.ConfigurationManager.ActiveConfiguration.Name), entry['active']))
            report = []
            for name, wanted in entry['depths'].items():
                activate_configuration(model, name, 'the saved part configuration')
                self.rebuild_noted(model, 'activating the saved part configuration')
                got = part_geometry_depth(model)
                if abs(got - wanted) > 1e-06:
                    raise RuntimeError('saved part %s.sldprt: the depth in configuration %r reads %.6g m, expected %.6g m (the change was not saved)' % (entry['file'], name, got, wanted))
                report.append('%s=%.6g m' % (name, got))
            activate_configuration(model, entry['active'], 'the saved part configuration (reactivating)')
            return 'part %s.sldprt read back from the file: depth %s' % (entry['file'], ', '.join(report))
        finally:
            set_step('CloseDoc', 'read_back_part')
            self.app.CloseDoc(model.GetTitle())

    def configuration_depths(self, model, dimension, names):
        """{configuration: depth (m)} by the part's GEOMETRY (the arbiter: the z extent of its solid body, IPartDoc.GetBodies2 + IBody2.GetBodyBox,
        else IPartDoc.GetPartBox) after activating each configuration and a rebuild. The dimension is read two more ways and logged beside it:
        IDimension.GetSystemValue3(3, [name]) and IDimension.SystemValue (field 2026.11.24.3: a dimension handle read the last value written in
        both configurations)."""
        values = {}
        for name in names:
            activate_configuration(model, name, 'the part configuration')
            self.rebuild_noted(model, 'activating configuration %s' % name)
            geometry = part_geometry_depth(model)
            texts = ['geometry %.6g m' % geometry]
            set_step('GetSystemValue3', 'configuration_depths')
            for label, read in (('GetSystemValue3', lambda: float(dimension.GetSystemValue3(swSetValue_InSpecificConfigurations, string_array([name]))[0])), ('SystemValue', lambda: float(dimension.SystemValue))):
                try:
                    got = read()
                    texts.append('%s %.6g m%s' % (label, got, '' if abs(got - geometry) <= 1e-06 else ' (disagrees with the geometry)'))
                except Exception as exc:
                    texts.append('%s unreadable (%s)' % (label, diagnostic_error(exc)))
            self.note_option('configuration %s depth: %s' % (name, ', '.join(texts)))
            values[name] = geometry
        return values

    def set_depth(self, dimension, value, which, name=None):
        """IDimension.SetSystemValue3, its swSetValueReturnStatus_e logged."""
        if which == swSetValue_InSpecificConfigurations:
            set_step('SetSystemValue3', 'set_depth')
            status = dimension.SetSystemValue3(value, which, string_array([name]))
            self.note_option('SetSystemValue3(%.6g, InSpecificConfigurations, [%s]) returned %s' % (value, name, status))
        else:
            set_step('SetSystemValue3', 'set_depth')
            status = dimension.SetSystemValue3(value, which, None)
            self.note_option('SetSystemValue3(%.6g, InThisConfiguration) returned %s' % (value, status))
        return status

    def part_configuration(self, p):
        """A26: a copy of P01a with a second configuration whose extrusion depth is p['height'] mm. Every write is checked by the part's GEOMETRY
        (configuration_depths), not by the dimension handle. The routes, in order: 1 IDimension.SetSystemValue3 for the one configuration; 2 the
        configuration activated and SetSystemValue3 for this configuration (config-dimension-this-configuration); 3 the configuration activated, the
        dimension fetched again (a fresh handle) and SetSystemValue3 for this configuration (config-dimension-fresh-handle). When a route left the
        new depth right but changed the original configuration too, the original depth is set back for its own configuration with a fresh handle
        in it (also config-dimension-fresh-handle). Saved with p['active'] active."""
        model = self.copy_part_file(p['recipe'], p['file'])
        original = p['original'] * MM
        height = p['height'] * MM
        dimension = self.depth_dimension(model, original)
        set_step('ConfigurationManager', 'part_configuration')
        manager = check(model.ConfigurationManager, 'configuration manager unavailable')
        set_step('Name', 'part_configuration')
        default = str(check(manager.ActiveConfiguration, 'no active configuration').Name)
        name = p['name']
        geometry = part_geometry_depth(model)
        if abs(geometry - original) > 1e-06:
            raise RuntimeError('the part geometry is %.6g m along Z in configuration %r but its extrusion depth is %.6g m: the depth is not the Z extent of its box' % (geometry, default, original))
        set_step('AddConfiguration', 'part_configuration')
        check(manager.AddConfiguration(name, '', '', 0, '', ''), 'AddConfiguration returned no configuration: name=%r' % name)
        self.set_depth(dimension, height, swSetValue_InSpecificConfigurations, name)
        values = self.configuration_depths(model, dimension, [name, default])
        right = lambda v: abs(v[name] - height) <= 1e-06 and abs(v[default] - original) <= 1e-06
        entered, used = ([], None)

        def enter(mitigation):
            if mitigation not in entered:
                entered.append(mitigation)
                record_mitigation(mitigation, primary_failed=True, always=True)

        def settled(values):
            """The new depth is right and the original is not: set the original back with a fresh handle in its own configuration."""
            nonlocal used
            if abs(values[name] - height) <= 1e-06 and abs(values[default] - original) > 1e-06:
                enter('config-dimension-fresh-handle')
                activate_configuration(model, default, 'the original configuration')
                self.set_depth(self.depth_dimension(model, None), original, swSetValue_InSpecificConfigurations, default)
                used = 'config-dimension-fresh-handle'
                values = self.configuration_depths(model, dimension, [name, default])
            return values
        if not right(values):
            values = settled(values)
        for route in ('config-dimension-this-configuration', 'config-dimension-fresh-handle'):
            if right(values):
                break
            enter(route)
            activate_configuration(model, name, 'the new configuration')
            handle = dimension if route == 'config-dimension-this-configuration' else self.depth_dimension(model, None)
            self.set_depth(handle, height, swSetValue_InThisConfiguration)
            used = route
            values = settled(self.configuration_depths(model, dimension, [name, default]))
        if not right(values):
            raise RuntimeError('configuration depths read back %s m (by the geometry), wanted %r %.6g and %r %.6g, after SetSystemValue3 for the specific configuration, for this configuration, with a fresh handle, and the original set back' % (values, name, height, default, original))
        if used:
            mitigations[used]['fallback_ok'] += 1
        active = p.get('active', 'Default')
        activate_configuration(model, default if active == 'Default' else active, 'the part configuration')
        self.note_option('%s.sldprt: configurations %s depth %.6g m, %s depth %.6g m' % (p['file'], default, values[default], name, values[name]))
        privacy(model)
        save(model, self.folder / (p['file'] + '.sldprt'))
        set_step('GetSaveFlag', 'part_configuration')
        check(not model.GetSaveFlag(), '%s.sldprt still has unsaved changes after SaveAs' % p['file'])
        self.part_readback(model, p['file'], [default, name], values, default if active == 'Default' else active)
        set_step('CloseDoc', 'part_configuration')
        self.app.CloseDoc(model.GetTitle())
        return self.doc

    def source_edit(self, p):
        """A23c: change the source part to p['height'] mm high (the extrusion depth of the recipe's copy of P01a), rebuild it, go back to the
        assembly, rebuild that (the reference is updated) and read the block's top back from its box (padded about 0.44 mm)."""
        import pythoncom
        from win32com.client import VARIANT
        label = next((l for l, f in self.part_files.items() if f == p['file']))
        component = self.components[label]
        set_step('GetModelDoc2', 'source_edit')
        model = check(component.GetModelDoc2(), 'component model is not loaded')
        errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
        set_step('ActivateDoc3', 'source_edit')
        check(self.app.ActivateDoc3(model.GetTitle(), False, swRebuildActiveDoc, errors), 'part activation failed')
        dimension = self.depth_dimension(model, p['original'] * MM)
        set_step('SystemValue', 'source_edit')
        dimension.SystemValue = p['height'] * MM
        set_step('EditRebuild3', 'source_edit')
        check(model.EditRebuild3(), 'part rebuild failed')
        privacy(model)
        save(model, self.folder / (p['file'] + '.sldprt'))
        set_step('GetSaveFlag', 'source_edit')
        check(not model.GetSaveFlag(), '%s.sldprt still has unsaved changes after SaveAs' % p['file'])
        set_step('Name', 'source_edit')
        configuration = str(model.ConfigurationManager.ActiveConfiguration.Name)
        self.part_readback(model, p['file'], [configuration], {configuration: p['height'] * MM}, configuration)
        errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
        set_step('ActivateDoc3', 'source_edit')
        check(self.app.ActivateDoc3(self.doc.GetTitle(), False, swRebuildActiveDoc, errors), 'assembly activation failed')
        set_step('ForceRebuild3', 'source_edit')
        check(self.doc.ForceRebuild3(False), 'assembly rebuild failed')
        set_step('GetBox', 'source_edit')
        top = check(self.components[label].GetBox(False, False), 'component box unavailable after the update')[5] * 1000.0
        self.note_option('source %s.sldprt edited to %s mm high; the block in the assembly now reaches z = %.3f mm (box padded about 0.44)' % (p['file'], p['height'], top))
        if abs(top - p['height']) > 1.0:
            raise RuntimeError('the block is not %s mm high after the reference update: its box top is at z = %.3f mm' % (p['height'], top))
        return component

    def fillet_centre(self, component):
        """The rounded corner's fillet axis (the axis point, in meters, and its direction) of the part the component is, in the top assembly: the
        first cylindrical face of the part document's solid body (IFace2.GetSurface -> ISurface.CylinderParams: origin xyz, axis xyz, radius),
        carried by the component's world transform. Read from the part itself, so a part that was copied unmirrored shows it."""
        set_step('GetModelDoc2', 'fillet_centre')
        model = check(component.GetModelDoc2(), 'the mirrored part document is not loaded')
        set_step('GetBodies2', 'fillet_centre')
        bodies = api_interface(model, 'PartDoc').GetBodies2(swSolidBody, True) or ()
        for body in bodies:
            set_step('GetFaces', 'fillet_centre')
            for face in body.GetFaces() or ():
                set_step('GetSurface', 'fillet_centre')
                surface = check(face.GetSurface(), 'a face of the part has no surface')
                set_step('IsCylinder', 'fillet_centre')
                if surface.IsCylinder():
                    set_step('CylinderParams', 'fillet_centre')
                    values = [float(v) for v in surface.CylinderParams]
                    set_step('ArrayData', 'fillet_centre')
                    total = [float(v) for v in component.GetTotalTransform(True).ArrayData]
                    point = matrix_point(total, values[0:3])
                    direction = [sum((values[3 + i] * total[3 * i + j] for i in range(3))) for j in range(3)]
                    return (point, direction, values[6])
        set_step('Name2', 'fillet_centre')
        raise RuntimeError('the part %s has no cylindrical face to find its rounded corner by' % component.Name2)

    def mirror_geometry_problem(self, created, source, normal, offset):
        """'' when the rounded corner of the new component lies at the mirror image (about the plane normal = offset) of the source's, else what
        was found. The fillet's axis is compared except along itself; 0.5 mm."""
        axis_index = 'XYZ'.index(normal)
        before, direction, _ = self.fillet_centre(source)
        after, _, _ = self.fillet_centre(created)
        wanted = list(before)
        wanted[axis_index] = 2 * offset * MM - before[axis_index]
        size = math.sqrt(sum((v * v for v in direction)))
        unit = [v / size for v in direction]
        gap = [a - b for a, b in zip(after, wanted)]
        along = sum((g * u for g, u in zip(gap, unit)))
        across = [g - along * u for g, u in zip(gap, unit)]
        if max((abs(v) for v in across)) > 0.0005:
            set_step('Name2', 'mirror_geometry_problem')
            return 'the rounded corner of %s is at (%s) mm, the mirror image of the original is at (%s)' % (created.Name2, mm_list([v * 1000 for v in after]), mm_list([v * 1000 for v in wanted]))
        return ''

    def mirror_plane(self, plane):
        return self.reference_plane({'base': {'X': 'YZ', 'Y': 'XZ', 'Z': 'XY'}[plane['normal']], 'offset': plane['offset']})

    def last_feature_type(self):
        """GetTypeName2 of the last feature of the FeatureManager tree ('none' for an empty tree, 'unreadable' if the walk fails)."""
        try:
            set_step('FirstFeature', 'last_feature_type')
            feature, last = (self.doc.FirstFeature(), None)
            for _ in range(5000):
                if feature is None:
                    break
                set_step('GetNextFeature', 'last_feature_type')
                last, feature = (feature, feature.GetNextFeature())
            set_step('GetTypeName2', 'last_feature_type')
            return 'none' if last is None else str(last.GetTypeName2())
        except Exception:
            return 'unreadable'

    @staticmethod
    def name2_of(item):
        """(True, the instance name) of a component, or (False, the reason) when Name2 cannot be read. SolidWorks 2021 (field 2026.11.24.4): a Name2
        read ended a mirror recipe with Err 9 "Subscript out of range" and nothing in the log said which component it was. (hasattr would not do:
        it only swallows AttributeError, and a COM handle that raises raises something else.)"""
        if item is None:
            return (False, 'nothing')
        try:
            set_step('Name2', 'name2_of')
            return (True, str(item.Name2))
        except Exception as exc:
            return (False, 'unreadable (%s: %s)' % (type(exc).__name__, exc))

    def component_names(self, assembly):
        """({instance name: component} of the top-level components whose Name2 reads, the reasons of those that do not). An empty answer (None, Empty
        or an empty array) is an empty assembly, not an error."""
        names, unreadable = ({}, [])
        set_step('GetComponents', 'component_names')
        for item in assembly.GetComponents(True) or ():
            ok, text = self.name2_of(item)
            if ok:
                names[text] = item
            else:
                unreadable.append(text)
        if unreadable:
            self.note_option('%d top-level component handle(s) have no readable Name2: %s' % (len(unreadable), unreadable[0]))
        return (names, unreadable)

    def mirror_result_text(self, result):
        """What MirrorComponents3 answered: nothing, an object, or an array (its length and how many of the items are objects whose Name2 reads)."""
        if result is None:
            return 'nothing'
        if isinstance(result, (tuple, list)):
            return 'an array of %d item(s), %d object(s)' % (len(result), sum((1 for r in result if self.name2_of(r)[0])))
        return 'an object' if self.name2_of(result)[0] else 'a %s' % type(result).__name__

    def mirror_call(self, assembly, plane, p, source, path, orientation, before, kind='long', center=None):
        """MirrorComponents3, in the forms of MIRROR_FORMS in turn, starting from the one that worked last. A form succeeds only if it yields a
        component: an object in its answer, or a new top-level component after a rebuild (field 2026.11.24.3: forms 0 and 1 answered an EMPTY
        array and made nothing, which was taken for success). Nothing is undone between forms. Returns the new component. Round 25: `kind` is the
        element type of the orientation array ('long' VT_I4, 'int16' VT_I2, 'variant' VT_VARIANT) and `center` overrides OrientAboutCenterOfMass."""
        import pythoncom
        new_part = p.get('mode') == 'new_part'
        start, summaries = (self.mirror_form, [])
        for form in range(start, len(MIRROR_FORMS)):
            text, name = MIRROR_FORMS[form]
            if form > start:
                record_mitigation(name, primary_failed=True, always=True)

            def unused(kind):
                if form == 1:
                    return None
                if form == 2:
                    set_step('Empty', 'unused')
                    return pythoncom.Empty
                return {'object': object_array, 'int': int_array, 'string': string_array}[kind](())
            instance = unused('object') if new_part else object_array([source])
            mirrored = object_array([source]) if new_part else unused('object')
            names = string_array([str(path)]) if new_part else unused('string')
            orientations = unused('int') if new_part else {'long': int_array, 'int16': int16_array, 'variant': variant_array}[kind]([orientation])
            about_center, import_options = (False, 0) if form == 3 else (True, 1)
            if center is not None:
                about_center = center
            shown = 'orientation %s%s%s' % (orientation, {'long': '', 'int16': ', Integer array', 'variant': ', Variant array'}[kind], '' if center is None else ', OrientAboutCenterOfMass %s' % center)
            self.note_option('MirrorComponents3 form %d (%s, %s): calling' % (form, text, shown))
            set_step('ClearSelection2', 'mirror_call')
            self.doc.ClearSelection2(True)
            if form == 3:
                set_step('Select2', 'mirror_call')
                plane.Select2(False, 0)
            argument = plane
            if form == 4:
                set_step('GetSpecificFeature2', 'mirror_call')
                argument = plane.GetSpecificFeature2()
                if argument is None:
                    self.note_option('MirrorComponents3 form %d (%s): the plane feature gave no IRefPlane' % (form, text))
                    summaries.append('form %d: no IRefPlane' % form)
                    continue
            set_step('MirrorComponents3', 'mirror_call')
            result = assembly.MirrorComponents3(argument, instance, orientations, about_center, mirrored, False, names, swMirrorNameCustom if new_part else swMirrorNameSuffix, '', str(self.folder), import_options, False, False, False)
            made = None
            for item in list(result) if isinstance(result, (tuple, list)) else [result]:
                readable, reason = self.name2_of(item)
                if readable:
                    made = item
                    break
                if item is not None:
                    self.note_option('MirrorComponents3 answered an item whose Name2 cannot be read: ' + reason)
            if made is None:
                self.rebuild_noted(self.doc, 'MirrorComponents3')
                now, _ = self.component_names(assembly)
                made = next((c for name, c in now.items() if name not in before), None)
            summary = 'returned %s; %s; last feature %s' % (self.mirror_result_text(result), 'made %s' % self.name2_of(made)[1] if made is not None else 'no new component', self.last_feature_type())
            self.note_option('MirrorComponents3 form %d (%s, %s) %s' % (form, text, shown, summary))
            summaries.append('form %d %s' % (form, summary))
            if made is not None:
                if form > start:
                    mitigations[name]['fallback_ok'] += 1
                self.mirror_form = form
                return made
        raise RuntimeError('MirrorComponents3 made no component in %s (orientation %s): %s' % ('any of its forms' if start == 0 else 'the forms from %d on' % start, orientation, '; '.join(summaries)))

    def mirror_check(self, created, source, p, corner, wanted, normal, offset, orientation, path, new_part, label=None):
        """The corner test of one mirror try, logged: '' when the part's rounded corner (the fillet's axis, read from the part's own geometry) is at the
        mirror image of the original's, else what was found. The same test for an instance and for a new part."""
        problem = self.mirror_geometry_problem(created, source, normal, offset)
        set_step('ArrayData', 'mirror_check')
        world = pose_of(created.GetTotalTransform(True).ArrayData)
        point = [sum((world[1][r][c] * corner[c] for c in range(3))) + world[0][r] for r in range(3)]
        name = label or ('new part ' + path.name if new_part else 'mirror orientation %s' % orientation)
        if not new_part:
            self.note_option('%s puts the rounded corner at (%s) mm%s' % (name, mm_list(point), '' if max((abs(a - b) for a, b in zip(point, wanted))) <= 0.5 else ', wanted (%s)' % mm_list(wanted)))
        if not problem:
            self.note_option('%s: the rounded corner (the fillet axis read from its own geometry) is at the mirror image of the original' % name)
        else:
            self.note_option('%s: %s' % (name, problem))
        return problem

    def mirror_feature(self):
        """The newest feature of the tree that is a mirror-components feature (GetTypeName2 MirrorCompFeat), or None."""
        found = None
        set_step('FirstFeature', 'mirror_feature')
        feature = self.doc.FirstFeature()
        for _ in range(5000):
            if feature is None:
                break
            set_step('GetTypeName2', 'mirror_feature')
            if feature.GetTypeName2() == 'MirrorCompFeat':
                found = feature
            set_step('GetNextFeature', 'mirror_feature')
            feature = feature.GetNextFeature()
        return found

    def mirror_define(self, orientation):
        """mirror-orientation-definition: the orientation of the instanced component set through the feature's own definition
        (IMirrorComponentFeatureData.ComponentOrientationsAlignToComponentOrigin), then ModifyDefinition. Returns '' or why it did not work: an error
        in any step (the tree walk, GetDefinition, the set, ModifyDefinition) is that reason, so the ladder goes on to the next rung."""
        data, accessed = (None, False)
        try:
            feature = self.mirror_feature()
            if feature is None:
                return 'no MirrorCompFeat feature in the tree'
            set_step('GetDefinition', 'mirror_define')
            data = feature.GetDefinition()
            if data is None:
                set_step('Name', 'mirror_define')
                return 'GetDefinition of %s answered Nothing' % feature.Name
            set_step('AccessSelections', 'mirror_define')
            accessed = bool(data.AccessSelections(self.doc, None))
            if not accessed:
                self.note_option('IMirrorComponentFeatureData.AccessSelections answered False')
            set_step('ComponentOrientationsAlignToComponentOrigin', 'mirror_define')
            data.ComponentOrientationsAlignToComponentOrigin = int_array([orientation])
            set_step('ModifyDefinition', 'mirror_define')
            ok = feature.ModifyDefinition(data, self.doc, None)
            return '' if ok else 'ModifyDefinition answered %s' % ok
        except Exception as exc:
            return 'the definition route raised: ' + safe_error(exc)
        finally:
            if accessed:
                try:
                    set_step('ReleaseSelectionAccess', 'mirror_define')
                    data.ReleaseSelectionAccess()
                except Exception:
                    pass

    def tree_text(self):
        """The feature tree as 'type:name' items, for comparing before and after a try."""
        set_step('FirstFeature', 'tree_text')
        items, feature = ([], self.doc.FirstFeature())
        for _ in range(5000):
            if feature is None:
                break
            set_step('GetTypeName2', 'tree_text')
            items.append('%s:%s' % (feature.GetTypeName2(), feature.Name))
            set_step('GetNextFeature', 'tree_text')
            feature = feature.GetNextFeature()
        return items

    def mirror_left(self, assembly, before, tree_before):
        """What a try left in the assembly: '' when the top-level components and the feature tree are what they were before the first mirror call."""
        now, _ = self.component_names(assembly)
        left = []
        extra = [n for n in now if n not in before]
        if extra:
            left.append('%d new component(s) (%s)' % (len(extra), ', '.join(extra[:3])))
        if len(now) != len(before) and (not extra):
            left.append('%d top-level component(s) where there were %d' % (len(now), len(before)))
        tree = self.tree_text()
        if tree != tree_before:
            new = [t for t in tree if t not in tree_before]
            left.append('a changed feature tree (%s)' % (', '.join(new[:3]) or 'features missing'))
        return ', '.join(left)

    def mirror_restore(self, assembly, rung, before, tree_before):
        """Put the assembly back to what it was before the first mirror call, by diff and not by undo count (a successful ModifyDefinition adds an
        undo entry of its own, so one undo takes only that): EditUndo2 until the top-level components and the feature tree equal the snapshot, at
        most 4 times. If they still differ the rung is named and the ladder stops (no further tries on a changed assembly)."""
        for _ in range(4):
            if not self.mirror_left(assembly, before, tree_before):
                return
            set_step('EditUndo2', 'mirror_restore')
            self.doc.EditUndo2(1)
        left = self.mirror_left(assembly, before, tree_before)
        if left:
            set_step('the assembly after the try', 'mirror_restore')
            raise RuntimeError('the mirror rung %s left %s in the assembly' % (rung, left))

    def mirror_orientation_ladder(self, assembly, plane, p, source, path, before, corner, wanted, normal, offset, tries, tree_before):
        """Round 25: the rungs after the orientation loop, each logged and judged by the same corner test; stops at the first that is right.
        a. mirror-orientation-int-array: the orientations as an Integer (VT_I2) array, then as a Variant array;
        b. mirror-orientation-definition: the mirror made, then its orientation set in IMirrorComponentFeatureData and ModifyDefinition;
        c. mirror-orientation-center-of-mass-off: OrientAboutCenterOfMass False.
        The assembly is put back to its snapshot (mirror_restore) before the first try and after every try that fails, made or not.
        Returns (component, problem, one result text per try); problem is '' when a rung worked."""
        ladder = []
        rungs = (('mirror-orientation-int-array', 'Integer array', dict(kind='int16')), ('mirror-orientation-int-array', 'Variant array', dict(kind='variant')), ('mirror-orientation-definition', 'definition', dict(definition=True)), ('mirror-orientation-center-of-mass-off', 'OrientAboutCenterOfMass False', dict(center=False)))
        recorded, problem, created = (set(), 'no rung ran', None)
        self.mirror_restore(assembly, 'the orientation loop', before, tree_before)
        for name, how, options in rungs:
            if name not in recorded:
                recorded.add(name)
                record_mitigation(name, primary_failed=True, always=True)
            for orientation in tries:
                label = 'mirror rung %s (%s), orientation %s' % (name, how, orientation)
                problem = ''
                try:
                    if options.get('definition'):
                        created = self.mirror_call(assembly, plane, p, source, path, tries[0], before)
                        problem = self.mirror_define(orientation)
                        if not problem:
                            self.rebuild_noted(self.doc, 'the mirror definition')
                            now, _ = self.component_names(assembly)
                            created = next((c for n, c in now.items() if n not in before), created)
                    else:
                        created = self.mirror_call(assembly, plane, p, source, path, orientation, before, **options)
                except Exception as exc:
                    problem = safe_error(exc)
                if problem:
                    self.note_option('%s: %s' % (label, problem))
                else:
                    problem = self.mirror_check(created, source, p, corner, wanted, normal, offset, orientation, path, False, label)
                if not problem:
                    mitigations[name]['fallback_ok'] += 1
                    return (created, '', ladder)
                ladder.append('%s (%s), orientation %s: %s' % (name, how, orientation, problem))
                self.mirror_restore(assembly, name, before, tree_before)
        return (created, problem, ladder)

    def mirror(self, p):
        """A20: Mirror Components. IAssemblyDoc.MirrorComponents3 about a reference plane at the recipe's offset, once as a same-file
        instance (a/b) and once as a new part file saved beside the top file (c). For an instance the component orientation (an enum
        whose axes depend on the plane) is tried in turn until the part's rounded corner lands on the mirrored corner (mirror-orientation-next);
        a call that makes no component (an empty answer is not one) is made again in the next form of MIRROR_FORMS (mirror-empty-array-nothing,
        mirror-empty-variant, mirror-plane-selected, mirror-refplane-object); a mirrored part file that is not on disk is saved from its document
        (mirror-part-saved)."""
        assembly = api_interface(self.doc, 'AssemblyDoc')
        source = self.components[p['component']]
        normal, offset = (p['plane']['normal'], float(p['plane']['offset']))
        plane = check(self.mirror_plane(p['plane']), 'the mirror plane was not made')
        new_part = p.get('mode') == 'new_part'
        path = self.folder / (p['part'] + '.sldprt') if new_part else None
        corner = p['corner']
        axis_index = 'XYZ'.index(normal)
        wanted = list(corner)
        wanted[axis_index] = 2 * offset - corner[axis_index]
        before, _ = self.component_names(assembly)
        tree_before = self.tree_text()
        tries = [1] if new_part else list(p['orientations'])
        self.note_option('mirror %s: %s about %s = %s mm, %d top-level component(s) before, %d orientation(s) to try' % (p['name'], p['component'], normal, mm_list([offset]), len(before), len(tries)))
        created, problem = (None, '')
        for number, orientation in enumerate(tries):
            if number:
                record_mitigation('mirror-orientation-next', primary_failed=True, always=True)
                set_step('EditUndo2', 'mirror')
                self.doc.EditUndo2(1)
            created = self.mirror_call(assembly, plane, p, source, path, orientation, before)
            problem = self.mirror_check(created, source, p, corner, wanted, normal, offset, orientation, path, new_part)
            if not problem:
                if number:
                    mitigations['mirror-orientation-next']['fallback_ok'] += 1
                break
        else:
            if new_part:
                raise RuntimeError('the new mirrored part %s does not have the rounded corner at its mirror image about %s = %s mm (orientation tried: 1): %s' % (path.name, normal, offset, problem))
            created, problem, ladder = self.mirror_orientation_ladder(assembly, plane, p, source, path, before, corner, wanted, normal, offset, tries, tree_before)
            if problem:
                set_step('orientation ladder exhausted', 'mirror')
                raise RuntimeError('no component orientation of MirrorComponents3 puts the rounded corner at its mirror image about %s = %s mm (orientations tried: %s): %s; then, with the orientation given another way: %s' % (normal, offset, tries, problem, '; '.join(ladder)))
        if new_part and (not path.is_file()):
            record_mitigation('mirror-part-saved', primary_failed=True, always=True)
            set_step('GetModelDoc2', 'mirror')
            saved_model = check(created.GetModelDoc2(), 'the mirrored part document is not loaded')
            privacy(saved_model)
            save(saved_model, path)
            mitigations['mirror-part-saved']['fallback_ok'] += 1
            problem = self.mirror_geometry_problem(created, source, normal, offset)
            if problem:
                raise RuntimeError('after saving the mirrored part %s: %s' % (path.name, problem))
        if new_part and path.name not in self.extra_files:
            self.extra_files.append(path.name)
        self.components[p['name']] = created
        self.rebuild_noted(self.doc, 'the mirror')
        set_step('Name2', 'mirror')
        self.note_option('%s is %s (%s)' % (p['name'], created.Name2, 'new part ' + path.name if new_part else 'an instance of ' + str(source.Name2)))
        return created

    def pattern_expected(self, seed, pattern):
        """[(t mm, R)] of instances #2, #3, ... of a component pattern, from the seed's world pose: shifted along the axis by spacing for a linear
        pattern (dir1 first, then dir2), turned about the world axis through the origin by step = angle / count for a circular one."""
        set_step('ArrayData', 'pattern_expected')
        t0, r0 = pose_of(seed.GetTotalTransform(True).ArrayData)
        expected = []
        if 'circular' in pattern:
            circle = pattern['circular']
            direction = axis(circle['axis'])
            step = float(circle['angle']) / circle['count']
            for k in range(1, circle['count']):
                rotation = turn_matrix([{'axis': circle['axis'].lstrip('-'), 'deg': (-1 if circle['axis'].startswith('-') else 1) * step * k}])
                t = [sum((rotation[i][j] * t0[j] for j in range(3))) for i in range(3)]
                expected.append((t, [[sum((rotation[i][m] * r0[m][j] for m in range(3))) for j in range(3)] for i in range(3)]))
            return expected
        a, b = (pattern['dir1'], pattern.get('dir2', {'axis': 'Y', 'count': 1, 'spacing': 0}))
        for j in range(b['count']):
            for i in range(a['count']):
                if (i, j) != (0, 0):
                    shift = [axis(a['axis'])[c] * i * a['spacing'] + axis(b['axis'])[c] * j * b['spacing'] for c in range(3)]
                    expected.append(([t0[c] + shift[c] for c in range(3)], r0))
        return expected

    def pattern_problem(self, seed, fresh, pattern):
        """'' when instance #k is where the pattern puts it (translation 0.01 mm, rotation 1e-4), else what is wrong: the instances come out
        mirrored (the other direction) or swapped (the other way round)."""
        problems = []
        for number, (component, (t, rotation)) in enumerate(zip(fresh, self.pattern_expected(seed, pattern)), 2):
            set_step('ArrayData', 'pattern_problem')
            got_t, got_r = pose_of(component.GetTotalTransform(True).ArrayData)
            if max((abs(a - b) for a, b in zip(got_t, t))) > 0.01 or max((abs(got_r[i][j] - rotation[i][j]) for i in range(3) for j in range(3))) > 0.0001:
                set_step('Name2', 'pattern_problem')
                problems.append('instance #%d (%s) is at (%s) mm, expected (%s)' % (number, component.Name2, mm_list(got_t), mm_list(t)))
        return '; '.join(problems)

    def component_pattern(self, pattern):
        """A21 and A22: a linear or circular component pattern of one component (a part or a whole subassembly). Plans, in order:
        FeatureLinearPattern3 (linear) / FeatureCircularPattern5 with the components at mark 1 and the axis at mark 2, then the axis at mark 1
        and the components at mark 4 (circular-pattern-marks), then for the linear one the pattern feature data of the 2024 interop
        (pattern-feature-data). The instances are found as the components that were not there before (GetComponents(True)); the seed is #1.
        Where each instance ends up is read back; instances that are mirrored or swapped (the pattern went the other way) are undone and the
        pattern is made once more with the direction reversed (pattern-direction-reversed); wrong again fails the recipe."""
        doc, assembly = (self.doc, api_interface(self.doc, 'AssemblyDoc'))
        label = pattern['component']
        seed = self.components[label]
        before = set(self.component_names(assembly)[0])
        circular = 'circular' in pattern
        if circular:
            circle = pattern['circular']
            total = circle['count']
            plans = [('components mark 1, axis mark 2', (1, 2)), ('axis mark 1, components mark 4', (4, 1))]
        else:
            a, b = (pattern['dir1'], pattern.get('dir2', {'count': 1, 'spacing': 0}))
            total = a['count'] * b['count']
            plans = [('FeatureLinearPattern3', (1, 2)), ('pattern feature data', None)]
        outcomes = []
        for reverse in (False, True):
            if not outcomes:
                axes = [self.world_axis(circle['axis'])] if circular else [self.world_axis(d['axis']) for d in [pattern[k] for k in ('dir1', 'dir2') if k in pattern]]
            feature = None
            for number, (text, marks) in enumerate(plans):
                if number:
                    record_mitigation('circular-pattern-marks' if circular else 'pattern-feature-data', primary_failed=True, always=True)
                set_step('ClearSelection2', 'component_pattern')
                doc.ClearSelection2(True)
                if marks is None:
                    feature = self.pattern_from_feature_data(seed, axes, pattern, reverse)
                else:
                    set_step('CreateSelectData', 'component_pattern')
                    data = doc.SelectionManager.CreateSelectData()
                    set_step('Mark', 'component_pattern')
                    data.Mark = marks[0]
                    set_step('Select4', 'component_pattern')
                    check(seed.Select4(False, data, False), 'component pattern selection failed')
                    for i, axis_feature in enumerate(axes):
                        set_step('Select2', 'component_pattern')
                        check(axis_feature.Select2(True, marks[1] if circular else 2 if i == 0 else 4), 'component pattern axis selection failed')
                    if circular:
                        set_step('FeatureCircularPattern5', 'component_pattern')
                        feature = doc.FeatureManager.FeatureCircularPattern5(circle['count'], math.radians(circle['angle']), reverse, '', False, True, False, False, False, False, 1, 0.0, '', False)
                    else:
                        set_step('FeatureLinearPattern3', 'component_pattern')
                        feature = doc.FeatureManager.FeatureLinearPattern3(a['count'], a['spacing'] * MM, b['count'], b['spacing'] * MM, reverse, False, '', '', False, False)
                self.note_option('component pattern of %s (%s%s) returned %s' % (label, text, ', reversed' if reverse else '', 'a feature' if feature is not None else 'nothing'))
                if feature is not None:
                    if number:
                        mitigations['circular-pattern-marks' if circular else 'pattern-feature-data']['fallback_ok'] += 1
                    break
            check(feature, 'every plan of the component pattern of %s returned nothing (%s)' % (label, '; '.join((t for t, _ in plans))))
            now, _ = self.component_names(assembly)
            set_step('Name2', 'component_pattern')
            fresh = sorted((n for name, n in now.items() if name not in before), key=lambda n: int(str(n.Name2).rsplit('-', 1)[-1]))
            if len(fresh) != total - 1:
                set_step('Name2', 'component_pattern')
                raise RuntimeError('the component pattern of %s made %d new components (%s), wanted %d' % (label, len(fresh), ', '.join((str(c.Name2) for c in fresh)), total - 1))
            problem = self.pattern_problem(seed, fresh, pattern)
            outcomes.append(problem)
            if not problem:
                if reverse:
                    mitigations['pattern-direction-reversed']['fallback_ok'] += 1
                break
            self.note_option('component pattern of %s%s: %s' % (label, ' (reversed)' if reverse else '', problem))
            set_step('EditUndo2', 'component_pattern')
            doc.EditUndo2(1)
            if not reverse:
                record_mitigation('pattern-direction-reversed', primary_failed=True, always=True)
        else:
            raise RuntimeError('the component pattern of %s puts its instances in the wrong places in both directions: %s; reversed: %s' % (label, outcomes[0], outcomes[1]))
        self.patterns[label] = [seed] + fresh
        set_step('Name2', 'component_pattern')
        self.note_option('component pattern instances of %s: %s' % (label, ', '.join((str(c.Name2) for c in [seed] + fresh))))
        return feature

    def pattern_from_feature_data(self, seed, axes, pattern, reverse=False):
        """The 2024 interop's ILocalLinearPatternFeatureData (CreateDefinition(swFmLocalLPattern) then CreateFeature). Reversed: the axis made
        the other way round (the data has no flip member this builder has checked)."""
        if 'circular' in pattern:
            return None
        if reverse:
            axes = [self.world_axis(opposite_axis(pattern['dir1']['axis']))]
        set_step('FeatureManager', 'pattern_from_feature_data')
        fm = self.doc.FeatureManager
        set_step('CreateDefinition', 'pattern_from_feature_data')
        definition = check(fm.CreateDefinition(swFmLocalLPattern), 'CreateDefinition(swFmLocalLPattern) returned nothing')
        a = pattern['dir1']
        set_step('SeedComponentArray', 'pattern_from_feature_data')
        definition.SeedComponentArray = object_array([seed])
        set_step('D1Axis', 'pattern_from_feature_data')
        definition.D1Axis = axes[0]
        set_step('D1Spacing', 'pattern_from_feature_data')
        definition.D1Spacing = a['spacing'] * MM
        set_step('D1TotalInstances', 'pattern_from_feature_data')
        definition.D1TotalInstances = a['count']
        set_step('CreateFeature', 'pattern_from_feature_data')
        return fm.CreateFeature(definition)

    def suppress_in_active_configuration(self, label, config):
        """Suppress a component in the now-active new configuration.

        Round 7 (field, revision 34.4.0): SetSuppression2(0) on the component object fetched before the
        configuration switch did not return swSuppressionChangeOk. The component is fetched again
        (IAssemblyDoc.GetComponentByName by its instance name) after the switch; if that still fails the
        document is rebuilt (EditRebuild3) and the component fetched and suppressed once more. Every
        return value is kept."""
        doc = self.doc
        assembly = api_interface(doc, 'AssemblyDoc')
        set_step('Name2', 'suppress_in_active_configuration')
        instance = str(self.components[label].Name2)
        statuses = []
        for attempt in range(2):
            if attempt:
                record_mitigation('configuration-suppress-rebuild', primary_failed=True, always=True)
                set_step('EditRebuild3', 'suppress_in_active_configuration')
                rebuilt = doc.EditRebuild3()
                statuses.append('EditRebuild3 returned %s' % rebuilt)
            set_step('ClearSelection2', 'suppress_in_active_configuration')
            doc.ClearSelection2(True)
            set_step('GetComponentByName', 'suppress_in_active_configuration')
            component = check(assembly.GetComponentByName(instance), 'GetComponentByName(%r) returned nothing in configuration %r' % (instance, config))
            self.components[label] = component
            set_step('SetSuppression2', 'suppress_in_active_configuration')
            status = component.SetSuppression2(0)
            statuses.append('SetSuppression2(0) on %s in configuration %r returned %s' % (instance, config, status))
            if status == swSuppressionChangeOk:
                if attempt:
                    mitigations['configuration-suppress-rebuild']['fallback_ok'] += 1
                if self.folder is not None:
                    log_line(self.folder, 'option', 'configuration suppression: ' + '; '.join(statuses))
                return
        raise RuntimeError('component suppression failed: ' + '; '.join(statuses) + ' (swSuppressionError_e: 0 bad component, 1 bad state, 2 ok, 3 change failed)')

    def component_state(self, component, state):
        set_step('ClearSelection2', 'component_state')
        self.doc.ClearSelection2(True)
        if 'grounded' in state:
            assembly = api_interface(self.doc, 'AssemblyDoc')
            set_step('Select4', 'component_state')
            check(component.Select4(False, None, False), 'component selection failed')
            if state['grounded']:
                set_step('FixComponent', 'component_state')
                assembly.FixComponent()
            else:
                set_step('UnfixComponent', 'component_state')
                assembly.UnfixComponent()
        if 'flexible' in state:
            self.set_solving(component, bool(state['flexible']))
        if 'visible' in state:
            set_step('Visible', 'component_state')
            component.Visible = 1 if state['visible'] else 0
        if 'suppressed' in state:
            set_step('SetSuppression2', 'component_state')
            status = component.SetSuppression2(0 if state['suppressed'] else 2)
            if status != swSuppressionChangeOk:
                raise RuntimeError('component suppression failed: SetSuppression2(%d) returned %s (swSuppressionError_e: 0 bad component, 1 bad state, 3 change failed)' % (0 if state['suppressed'] else 2, status))

    def apply(self, op):
        global api_inputs, call_inputs
        api_inputs = json.dumps(op, sort_keys=True)
        call_inputs = ''
        set_step('FeatureManager', 'apply')
        doc, fm = (self.doc, self.doc.FeatureManager)
        kind = op['kind']
        if kind == 'assembly':
            feature = self.assembly(op)
        elif kind == 'drawing':
            feature = self.drawing(op)
        elif kind == 'sketch':
            feature = self.sketch(op)
        else:
            set_step('ClearSelection2', 'apply')
            doc.ClearSelection2(True)
            if kind in ('extrude', 'revolve'):
                profile = self.reference(op.get('profile', 'last'))
                set_step('Select2', 'apply')
                check(profile.Select2(False, 0), 'profile selection failed')
            if kind == 'extrude':
                depth = float(op.get('distance', 1)) * MM
                end = 1 if op.get('extent') == 'through_all' else 6 if op.get('direction') == 'sym' else 0
                reverse = op.get('direction') == '-'
                if operation(op) == 'cut':
                    set_step('FeatureCut4', 'apply')
                    feature = fm.FeatureCut4(True, False, reverse, end, 0, depth, depth, False, False, False, False, 0.0, 0.0, False, False, False, False, False, True, True, True, True, False, 0, 0.0, False, False)
                else:
                    set_step('FeatureExtrusion3', 'apply')
                    feature = fm.FeatureExtrusion3(True, False, reverse, end, 0, depth, depth, False, False, False, False, 0.0, 0.0, False, False, False, False, operation(op) != 'new', True, True, 0, 0.0, False)
            elif kind == 'revolve':
                revolution_axis = self.world_axis(op.get('axis', 'Z'))
                set_step('ClearSelection2', 'apply')
                doc.ClearSelection2(True)
                set_step('Select2', 'apply')
                check(profile.Select2(False, 0), 'revolve profile selection failed')
                set_step('Select2', 'apply')
                check(revolution_axis.Select2(True, 16), 'revolve axis selection failed')
                set_step('FeatureRevolve2', 'apply')
                feature = fm.FeatureRevolve2(True, True, False, operation(op) == 'cut', False, False, 0, 0, math.radians(op.get('angle', 360)), 0.0, False, False, 0.0, 0.0, 0, 0.0, 0.0, operation(op) != 'new', True, True)
            elif kind == 'hole':
                face = resolve(doc, op['on_face'])
                normal = axis(op['on_face']['face']['normal'])
                points = op['at'] if isinstance(op['at'][0], (list, tuple)) else [op['at']]
                for i, point in enumerate(points):
                    p = xyz(point)
                    set_step('GetClosestPointOn', 'apply')
                    if math.dist(face.GetClosestPointOn(*p)[:3], p) > TOL:
                        raise RuntimeError('hole position is not on selected support face')
                    origin = [p[j] + normal[j] * 1e-06 for j in range(3)]
                    set_step('SelectByRay', 'apply')
                    check(doc.Extension.SelectByRay(*origin, *[-v for v in normal], TOL, 2, i > 0, 0, 0), 'hole position selection failed')
                set_step('HoleWizard5', 'apply')
                feature = fm.HoleWizard5(*hole_arguments(op))
            elif kind in ('pattern_rect', 'pattern_circ'):
                seed = self.reference(op['feature'])
                directions = [op[k] for k in ('dir1', 'dir2') if k in op] if kind == 'pattern_rect' else [op]
                axes = [self.world_axis(d['axis']) for d in directions]
                set_step('ClearSelection2', 'apply')
                doc.ClearSelection2(True)
                for i, a in enumerate(axes):
                    set_step('Select2', 'apply')
                    check(a.Select2(i > 0, i + 1), 'pattern axis selection failed')
                set_step('Select2', 'apply')
                check(seed.Select2(True, 4), 'pattern seed selection failed')
                if kind == 'pattern_rect':
                    a = op['dir1']
                    b = op.get('dir2', {'count': 1, 'spacing': 0})
                    set_step('FeatureLinearPattern3', 'apply')
                    feature = fm.FeatureLinearPattern3(a['count'], a['spacing'] * MM, b['count'], b['spacing'] * MM, False, False, '', '', False, False)
                else:
                    set_step('FeatureCircularPattern4', 'apply')
                    feature = fm.FeatureCircularPattern4(op['count'], math.radians(op.get('angle', 360)), False, '', False, True, False)
            elif kind == 'fillet_variable':
                edge = resolve(doc, op['edge'])
                radii = endpoint_radii(edge, op)
                if probe_candidate in VARIABLE_FILLET_CANDIDATES:
                    feature = self.variable_fillet_candidate(probe_candidate, edge, radii, op)
                else:
                    if variable_fillet_dead:
                        raise RuntimeError('variable fillet cannot be built on this SolidWorks revision (the routes were tried for the first variable fillet of this run and are not repeated): ' + variable_fillet_dead)
                    select(doc, edge, False, 1)
                    options = 1 | 32 | (4 if op.get('transition') == 'straight' else 0)
                    set_step('FeatureFillet3', 'apply')
                    feature = fm.FeatureFillet3(options, 0, 0, 0, 1, 0, 0, radii, None, None, None, None, None, None)
                    if feature is None:
                        feature = self.variable_fillet_documented(edge, radii, op)
                    if feature is None:
                        feature = self.variable_fillet_featuredata(edge, radii, op)
            elif kind == 'app_specific':
                params = op['params']
                if op['op'] == 'parameter':
                    self.add_equation('"%s" = %smm' % (params['name'], repr(float(params['value']))))
                    self.parameters[params['name']] = float(params['value'])
                    feature = self.last or doc
                elif op['op'] == 'sketch3d':
                    feature = self.sketch(dict(params, three_d=True))
                    self.refs[params['name']] = feature
                elif op['op'] == 'helix_spiral':
                    feature = self.helix_spiral(params)
                elif op['op'] == 'plane_normal_to_curve':
                    feature = self.plane_normal_to_curve(params)
                elif op['op'] == 'configuration':
                    feature = self.configuration(params)
                elif op['op'] == 'display_state':
                    feature = self.display_state(params)
                elif op['op'] == 'work_plane':
                    feature = self.reference_plane(dict(base=params['plane'], offset=params.get('offset', 0)))
                elif op['op'] == 'appearance':
                    target = params.get('target', 'part')
                    if target == 'part':
                        target = api_interface(doc, 'PartDoc')
                    elif 'component' in target:
                        target = self.components[target['component']]
                    else:
                        target = resolve(doc, target)
                    rgb = {'red': (1, 0, 0), 'green': (0, 1, 0), 'blue': (0, 0, 1)}[params['color']]
                    set_step('MaterialPropertyValues', 'apply')
                    target.MaterialPropertyValues = double_array((*rgb, 0.3, 0.8, 0.3, 0.3, 0, 0))
                    set_step('GraphicsRedraw2', 'apply')
                    doc.GraphicsRedraw2()
                    feature = self.last or doc
                elif op['op'] == 'mirror':
                    plane = self.reference_plane(params['plane'])
                    set_step('ClearSelection2', 'apply')
                    doc.ClearSelection2(True)
                    set_step('Select2', 'apply')
                    check(plane.Select2(False, 2), 'mirror plane selection failed')
                    for name in params['features']:
                        set_step('Select2', 'apply')
                        check(self.reference(name).Select2(True, 1), 'mirror seed selection failed')
                    set_step('InsertMirrorFeature', 'apply')
                    feature = fm.InsertMirrorFeature(False, False, False, False)
            elif kind == 'fillet':
                for i, edge in enumerate(op['edges']):
                    select(doc, resolve(doc, edge), i > 0, 1)
                set_step('FeatureFillet3', 'apply')
                feature = fm.FeatureFillet3(195, op['r'] * MM, 0, 0, 0, 0, 0, None, None, None, None, None, None, None)
            elif kind == 'sheetmetal':
                feature = self.sheetmetal(op)
            elif kind == 'chamfer' and op.get('ref_face'):
                feature = self.chamfer_reference_face(op)
            elif kind == 'chamfer':
                select(doc, resolve(doc, op['edge']))
                if op.get('mode') == 'two_distances':
                    record_mitigation('chamfer-dd-both-slots')
                set_step('InsertFeatureChamfer', 'apply')
                feature = fm.InsertFeatureChamfer(*chamfer_arguments(op))
            elif kind == 'shell':
                for i, face in enumerate(op.get('remove_faces', [])):
                    select(doc, resolve(doc, face), i > 0, 1)
                set_step('InsertFeatureShell', 'apply')
                doc.InsertFeatureShell(op['thickness'] * MM, op.get('direction') == 'outside')
                feature = newest_feature(doc)
                set_step('GetTypeName2', 'apply')
                if feature is None or feature.GetTypeName2() != 'Shell':
                    raise RuntimeError('shell API created no shell feature')
            elif kind == 'loft':
                for i, name in enumerate(op['profiles']):
                    set_step('Select2', 'apply')
                    check(self.reference(name).Select2(i > 0, 1), 'loft profile selection failed')
                set_step('InsertProtrusionBlend2', 'apply')
                feature = fm.InsertProtrusionBlend2(False, True, False, 1, 0, 0, 1, 1, True, True, False, 0, 0, 0, True, True, True, 0)
            elif kind == 'sweep':
                curve_path = op['path'] in self.curves
                is_probe, _base, modifiers = plane_probe(probe_candidate)
                modifiers = modifiers if is_probe and curve_path else frozenset()
                if 'circular-profile' not in modifiers:
                    set_step('Select2', 'apply')
                    check(self.reference(op['profile']).Select2(False, 1), 'sweep profile selection failed')
                if curve_path:
                    self.select_sweep_path(self.reference(op['path']))
                else:
                    set_step('Select2', 'apply')
                    check(self.reference(op['path']).Select2(True, 4), 'sweep path selection failed')
                if 'circular-profile' in modifiers:
                    diameter = check(2 * self.circle_radius or None, 'the profile circle radius is unknown')
                    set_step('InsertProtrusionSwept4', 'apply')
                    feature = fm.InsertProtrusionSwept4(False, False, 0, False, False, 0, 0, False, 0.0, 0.0, 0, 0, True, True, True, 0.0, True, True, diameter, 0)
                elif 'featuredata' in modifiers:
                    set_step('CreateDefinition', 'apply')
                    data = check(fm.CreateDefinition(swFmSweep), 'CreateDefinition(swFmSweep) returned nothing')
                    set_step('TwistControlType', 'apply')
                    data.TwistControlType = 0
                    set_step('Merge', 'apply')
                    data.Merge = True
                    set_step('FeatureScope', 'apply')
                    data.FeatureScope = True
                    set_step('AutoSelect', 'apply')
                    data.AutoSelect = True
                    set_step('MergeSmoothFaces', 'apply')
                    data.MergeSmoothFaces = True
                    set_step('CreateFeature', 'apply')
                    feature = fm.CreateFeature(data)
                else:
                    set_step('InsertProtrusionSwept3', 'apply')
                    feature = fm.InsertProtrusionSwept3(False, False, 0, False, False, 0, 0, False, 0.0, 0.0, 0, 0, True, True, True, 0.0, True)
                if curve_path and feature is not None and is_probe:
                    self.end_faces()
                    self.probe_note = self.diagnostics_note()
            else:
                raise NotScripted(kind)
            if feature is None and kind == 'fillet_variable':
                raise RuntimeError(kind + ' API returned no feature' + selection_summary(doc) + '; ' + call_inputs)
            if feature is None and kind in ('fillet', 'chamfer'):
                raise RuntimeError(kind + ' API returned no feature' + selection_summary(doc))
        check(feature, kind + ' API returned no feature')
        if kind == 'extrude' and op.get('distance_expression'):
            set_step('GetFirstDisplayDimension', 'apply')
            display = check(feature.GetFirstDisplayDimension(), 'the extrude has no depth dimension to drive')
            set_step('GetDimension2', 'apply')
            self.drive(check(display.GetDimension2(0), 'depth dimension unavailable'), op['distance_expression'], 'extrude depth')
        self.last = feature
        self.refs[op.get('name', op.get('id', str(self.index)))] = feature
        self.index += 1
        set_step('ClearSelection2', 'apply')
        doc.ClearSelection2(True)
        return feature

def property_manager(doc, config):
    from win32com.client import Dispatch
    set_step('Extension', 'property_manager')
    extension = doc.Extension
    set_step('GetIDsOfNames', 'property_manager')
    dispatch = extension._oleobj_.GetIDsOfNames('CustomPropertyManager')
    set_step('Invoke', 'property_manager')
    return Dispatch(extension._oleobj_.Invoke(dispatch, 0, 2, True, config))

def privacy(doc):
    for field, value in ((2, NEUTRAL_VALUE), (3, ''), (4, '')):
        set_step('Invoke', 'privacy')
        doc._oleobj_.Invoke(doc._oleobj_.GetIDsOfNames('SummaryInfo'), 0, 4, 0, field, value)
    try:
        set_step('Invoke', 'privacy')
        doc._oleobj_.Invoke(doc._oleobj_.GetIDsOfNames('SummaryInfo'), 0, 4, 0, 5, NEUTRAL_VALUE)
    except Exception:
        pass
    set_step('GetConfigurationNames', 'privacy')
    for config in [''] + list(doc.GetConfigurationNames() or ()):
        manager = property_manager(doc, config)
        for name in ('Author', 'Company', 'DrawnBy', 'CheckedBy'):
            set_step('Delete2', 'privacy')
            manager.Delete2(name)
            set_step('Add3', 'privacy')
            if manager.Add3(name, 30, '', 2) != 0:
                raise RuntimeError('custom property blanking failed: ' + name)

def save(doc, path):
    import pythoncom
    from win32com.client import VARIANT
    errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
    warnings = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
    set_step('SaveAs', 'save')
    success = doc.Extension.SaveAs(str(path), 0, 1, None, errors, warnings)
    if errors.value:
        raise RuntimeError('SolidWorks SaveAs error %s' % errors.value)
    check(success, 'SaveAs returned false')
    export_guard(path)
    summary_readback(doc)

def export_guard(path):
    """Right after SolidWorks writes a DXF or a PDF the builder made: a DXF is text and is scrubbed like one; a PDF is scanned for the names
    (never rewritten). A PDF with a name in it, or either file that cannot be read, is deleted and the row fails. The .sld* files are
    compressed and are not scanned (the stamp in them is documented); a STEP file has its own guard."""
    path = pathlib.Path(path)
    suffix = path.suffix.lower()
    if suffix not in ('.dxf', '.pdf') or not path.is_file():
        return
    problem = ''
    try:
        if suffix == '.dxf':
            text, encoding = sweep_read(path)
            cleaned = scrub_text(text)
            if cleaned != text:
                sweep_write(path, cleaned, encoding)
        elif sweep_scan(path):
            problem = 'carried a personal name'
    except SweepTooLarge:
        problem = TOO_LARGE
    except Exception:
        problem = 'could not be checked'
    if problem:
        if not sweep_try(sweep_delete, path):
            sweep_try(sweep_truncate, path)
        raise RuntimeError('privacy: %s %s' % (suffix[1:], problem))

def safe_error(exc):
    if isinstance(exc, TemplateError):
        return scrub_text(str(exc))
    text = scrub_text(str(exc))
    text = re.sub('[A-Za-z]:[\\\\/][^"\\\'\\r\\n]*', '<path>', text)
    text = re.sub('\\\\\\\\[^\\s\\"\\\']+', '<path>', text)
    text = re.sub('(^|[\\s\\"\\\'(\\[=,;:])/[^\\s\\"\\\']+', '\\1<path>', text)
    return scrub_text(text)

def write_results(folder, results):
    pending = folder / 'results.json.tmp'
    pending.write_text(dump_json(results, indent=2), encoding='utf-8')
    pending.replace(folder / 'results.json')

def log_error(folder, exc):
    number = getattr(exc, 'hresult', getattr(exc, 'errno', 0)) or 0
    frames = []
    trace = exc.__traceback__
    while trace is not None:
        frames.append(trace.tb_lineno)
        trace = trace.tb_next
    entry = dict(time=time.strftime('%Y-%m-%dT%H:%M:%S%z'), builder=BUILDER_VERSION, recipe=current_identity, step=step, Erl=frames[-1] if frames else 0, **{'Err.Number': number, 'Err.Description': scrub_text(safe_error(exc))})
    with (folder / 'FixtureBuilder.log').open('a', encoding='utf-8') as stream:
        stream.write(dump_json(entry) + '\n')

def release_documents(app, folder, row, results, doc, old_feature_errors, early, builder):
    """Close, unsaved, every document a recipe attempt left open; a close that fails turns the row into a failure."""

    def failed(exc):
        log_error(folder, exc)
        row.update(status='failed', error=diagnostic_error(exc), files=[])
        write_results(folder, results)
    if doc is not None:
        try:
            try:
                if old_feature_errors is not None:
                    set_step('ShowFeatureErrorDialog', 'release_documents')
                    doc.ShowFeatureErrorDialog = old_feature_errors
            finally:
                set_step('CloseDoc', 'release_documents')
                app.CloseDoc(doc.GetTitle())
        except Exception as exc:
            failed(exc)
    for title in list(early) + list(builder.loaded if builder is not None else ()):
        try:
            set_step('CloseDoc', 'release_documents')
            app.CloseDoc(title)
        except Exception as exc:
            failed(exc)

class UserCancelled(RuntimeError):
    """Cancel at the up-front notice: nothing is built."""
notices = []

class PersonalPathError(RuntimeError):
    """The output folder or a template would put a personal path inside every assembly and drawing; nothing is built."""
USERS_EXEMPT = ('public', 'default', 'all users', 'shared')
COMMON_NAMES = ('admin', 'user', 'users', 'owner', 'public', 'default', 'test', 'cad', 'work', 'data', 'home', 'the', 'and', 'pro', 'dev', 'lab', 'app', 'sys', 'doc', 'docs', 'temp', 'office', 'pc', 'laptop', 'desktop')
NEUTRAL_VALUE = 'Fixture Builder'
USER_NAME_NOTICE = "SolidWorks writes your Windows user name into each file it saves. We keep these native files private and publish only STEP and files we've checked clean; to keep your name out of the files entirely, run SolidWorks under a neutral Windows account."

def environment_value(name):
    """The one place the twin reads the environment (the VBA reads it with WScript.Shell); tests replace it. MYDOCUMENTS is the (possibly
    redirected) Documents folder, which has no environment variable."""
    value = os.environ.get(name, '').strip()
    if name == 'MYDOCUMENTS' and (not value) and (sys.platform == 'win32'):
        try:
            import ctypes
            buffer = ctypes.create_unicode_buffer(1024)
            ctypes.windll.shell32.SHGetFolderPathW(None, 5, None, 0, buffer)
            value = buffer.value.strip()
        except Exception:
            value = ''
    return value

def _backslashes(text):
    return str(text).strip().replace('/', '\\').lower().rstrip('\\')

def name_inside_components(user):
    """A word-matched name: 3 or more characters and not a common word. It is matched wherever the characters on both sides are not ASCII
    letters or digits (the start of the text, a tab, a quote, a length byte, "-", "_" ...); any other name (and a shorter one) only as a whole
    path segment. This holds for the user name, the profile folder's own name and the computer, domain and logon-server names."""
    return len(user) >= 3 and user not in COMMON_NAMES
_NOT_ALNUM_BEFORE = '(?<![A-Za-z0-9])'
_NOT_ALNUM_AFTER = '(?![A-Za-z0-9])'

def word_in(text, needle):
    return re.search(_NOT_ALNUM_BEFORE + re.escape(needle) + _NOT_ALNUM_AFTER, text, flags=re.IGNORECASE) is not None

def segment_matches(part, needle):
    """A path segment is the needle, or (a word-matched needle) holds it with no letter or digit next to it."""
    return bool(needle) and (part == needle or (name_inside_components(needle) and word_in(part, needle)))

def leaf_of(normal):
    return normal.rsplit('\\', 1)[-1]

def identity_names():
    """The Windows user name and the profile folder's own name (jsmith.ACME is often not the user name)."""
    return [n for n in (environment_value('USERNAME'), leaf_of(_backslashes(environment_value('USERPROFILE')))) if n]

def identity_machines():
    return [m for m in (environment_value('COMPUTERNAME'), environment_value('USERDOMAIN'), environment_value('LOGONSERVER').replace('\\', '')) if m]

def identity_roots():
    return [environment_value(n) for n in ('OneDrive', 'OneDriveCommercial', 'OneDriveConsumer', 'MYDOCUMENTS') if environment_value(n)]

def default_output_root():
    public = environment_value('PUBLIC').replace('/', '\\').rstrip('\\')
    return public + '\\Documents\\FixtureBuilder' if public else 'C:\\FixtureBuilder'

def personal_path_refusal(what, why):
    return 'The ' + what + ' was refused because ' + why + '. SolidWorks stores this path inside every assembly and drawing it saves, so the files you send would show it. Choose a neutral one instead, for example ' + default_output_root() + ' for the output folder. Nothing was built.'

def under_root(p, root):
    return bool(root) and (p == root or p.startswith(root + '\\'))

def personal_why(path, identity=True):
    """Why a path is personal, or ''. Same rules and order as PersonalWhy in the VBA. With identity False (the default output root, the one folder
    the builder names itself) only the UNC and the Users\\<name> rules apply: a user called Documents, Public or FixtureBuilder is not locked out
    of the folder the builder chose."""
    p = _backslashes(path)
    profile = _backslashes(environment_value('USERPROFILE'))
    parts = p.split('\\')
    if not identity:
        return personal_why_folder(p, parts) or personal_why_drive(path)
    if under_root(p, profile):
        return 'it is inside your user profile folder'
    if any((under_root(p, _backslashes(root)) for root in identity_roots() if root != environment_value('USERPROFILE'))):
        return 'it is inside your OneDrive or redirected Documents folder'
    for name in (environment_value('USERNAME').lower(), leaf_of(profile)):
        if name and any((segment_matches(part, name) for part in parts)):
            return 'a folder in its path contains your Windows user name'
    for machine in identity_machines():
        machine = machine.lower()
        if any((segment_matches(part, machine) for part in parts)):
            return 'a folder in its path is named after this computer, its domain or its logon server'
    if any(('onedrive' in part for part in parts)):
        return 'a folder in its path is a OneDrive folder'
    return personal_why_folder(p, parts) or personal_why_drive(path)

def personal_why_folder(p, parts):
    """The folder rules that name nobody: a UNC share, a Users\\<name> folder that is not Public."""
    if p.startswith('\\\\'):
        return 'it is on a network share (a \\\\server\\share path)'
    if any((part == 'users' and following and (following not in USERS_EXEMPT) for part, following in zip(parts, parts[1:]))):
        return 'it is inside the personal folder of a Windows user (a Users\\<name> folder)'
    return ''

def drive_path_required():
    """The twin runs on Windows, where every folder is a drive path; the tests on another system force this on to check the rule."""
    return os.name == 'nt'

def personal_why_drive(path):
    """The last rule, for every folder: it must be a full path with a drive letter. "FixtureOut", "..\\x" and "%USERPROFILE%\\x" (which is not
    expanded) resolve against SolidWorks' own current folder, which may be under the profile."""
    if drive_path_required() and (not re.match('[A-Za-z]:[\\\\/]', str(path).strip())):
        return 'the folder must be a full path starting with a drive letter'
    return ''

def personal_path_reason(path):
    """'' when the output folder is neutral, else the refusal text (which never repeats the folder). The default root is checked by the folder
    rules only (see personal_why)."""
    why = personal_why(path, _backslashes(path) != _backslashes(default_output_root()))
    return personal_path_refusal('output folder', why) if why else ''

def personal_template_reason(kind, path):
    why = personal_why(path)
    if not why:
        return ''
    return 'The ' + kind + ' template SolidWorks would use was refused because ' + why + '. A SolidWorks drawing stores the path of its sheet format and template, so the files you send would show it. In SolidWorks, under Tools > Options > Default Templates, choose a ' + kind + ' template in a neutral folder (for example the SolidWorks install folder or C:\\ProgramData). Nothing was built.'
_TAIL_END = '(?=[.,;)]*(?:["\\\'\\r\\n<>|]|$))'
_USERS_HEAD = '(?i)([\\\\/]Users[\\\\/]+)(?!(?:public|default|all users|shared)(?:[\\\\/"\\\'\\r\\n<>|]|$))[^\\\\/"\\\'\\r\\n<>|:*?]+?'
_TAIL = '(?:[^"\\\'\\r\\n<>|\\\\]|\\\\\\\\|\\\\(?!["\\\']))*'
_SEP = '(?:\\\\\\\\|[\\\\/](?!["\\\']))+'
_USERS_TAIL = re.compile(_USERS_HEAD + '(' + _SEP + ')' + _TAIL)
_USERS_FOLDER = re.compile(_USERS_HEAD + _TAIL_END)
_UNC_SHARE = re.compile('(^|[^\\\\/\\w:])(?:\\\\\\\\|//){1,2}[^\\\\/\\s"\\\'<>|:*?]+' + _SEP + _TAIL)

def root_pattern(root):
    """A folder path as a pattern that also matches its doubled-backslash (JSON) and forward-slash forms."""
    return re.escape(root).replace('\\\\', '[\\\\/]+')

def scrub_needle(result, needle, replacement):
    if name_inside_components(needle.lower()):
        return re.sub('(?i)(^|[^A-Za-z0-9])' + re.escape(needle) + '(?=[^A-Za-z0-9]|$)', '\\1' + replacement, result)
    return re.sub('(?i)([\\\\/])' + re.escape(needle) + '(?=[.,;)]*(?:[\\\\/\\s"\\\'<>|:*?]|$))', '\\1' + replacement, result)

def scrub_text(text):
    """Same as PrivacyScrub in the VBA. In order: after a \\Users\\<x> head (Public, Default, All Users and Shared exactly are exempt) everything
    to the end of the line, a quote or one of < > | becomes <user>\\<path> (spaces and parentheses included); so do the profile, OneDrive and
    Documents folders; the Windows user name and the profile folder's own name become <user> (longest first), the computer, domain and
    logon-server names <host>, each as a word (3+ characters, not a common word: no letter or digit next to it) or else as a whole folder
    name; a \\\\server\\share head and everything after it on the line becomes <share>."""
    result = str(text)
    result = _USERS_TAIL.sub('\\1<user>\\2<path>', result)
    result = _USERS_FOLDER.sub('\\1<user>', result)
    for root in identity_roots() + ([environment_value('USERPROFILE')] if environment_value('USERPROFILE') else []):
        pattern = root_pattern(root)
        result = re.sub(pattern + '(' + _SEP + ')' + _TAIL, '<user>\\1<path>', result, flags=re.IGNORECASE)
        result = re.sub(pattern, '<user>', result, flags=re.IGNORECASE)
    for user in sorted(identity_names(), key=len, reverse=True):
        result = scrub_needle(result, user, '<user>')
    for machine in identity_machines():
        result = scrub_needle(result, machine, '<host>')
    return _UNC_SHARE.sub('\\1<share>', result)

def scrub_value(value):
    """Every string in a value (dict, list or text) through scrub_text: scrubbed BEFORE it is JSON, never after (the scrub then cannot eat a
    JSON escape and leave a file that does not parse)."""
    if isinstance(value, str):
        return scrub_text(value)
    if isinstance(value, dict):
        return {key: scrub_value(item) for key, item in value.items()}
    if isinstance(value, (list, tuple)):
        return [scrub_value(item) for item in value]
    return value

def dump_json(value, **options):
    """JSON text with every string scrubbed first, and non-ASCII kept as it is (a non-Latin user name stays matchable by the sweep)."""
    return json.dumps(scrub_value(value), ensure_ascii=False, **options)

def scrubbed_traceback(exc):
    import traceback
    return scrub_text(''.join(traceback.format_exception(type(exc), exc, exc.__traceback__)))
TEXT_SUFFIXES = ('.log', '.json', '.txt', '.csv', '.tsv', '.xml', '.html', '.htm', '.md', '.ini', '.cfg', '.yaml', '.yml', '.dxf')
BUILDER_SUFFIXES = ('.sldprt', '.sldasm', '.slddrw', '.step', '.pdf', '.dxf', '.zip')
TEMPORARY_SUFFIXES = ('.tmp', '.temp', '.partial')
SWEEP_CAP = 4 * 1024 * 1024

class SweepTooLarge(ValueError):
    """A file over the 4 MB cap: it cannot be checked, which is not the same as a name being in it."""
TOO_LARGE = 'too large to check (over 4 MB)'
sweep_failed = []
ansi_skipped = []

def ansi_codepage():
    return 'mbcs' if sys.platform == 'win32' else 'cp1252'

def sweep_decode(data):
    """(text, encoding) from a file's bytes: UTF-16 or UTF-8 with a byte-order mark, UTF-8 without one, else the ANSI codepage (the VBA log
    is written in it). A file over the cap, NUL bytes without a UTF-16 mark, or a decode error raises: the sweep counts that as a hit."""
    if len(data) > SWEEP_CAP:
        raise SweepTooLarge('over the sweep size cap')
    if data[:2] == b'\xff\xfe':
        return (data[2:].decode('utf-16-le'), 'utf-16-le-bom')
    if data[:2] == b'\xfe\xff':
        return (data[2:].decode('utf-16-be'), 'utf-16-be-bom')
    if data[:3] == b'\xef\xbb\xbf':
        return (data[3:].decode('utf-8'), 'utf-8-bom')
    if b'\x00' in data:
        raise ValueError('NUL bytes without a UTF-16 byte-order mark')
    try:
        return (data.decode('utf-8'), 'utf-8')
    except UnicodeDecodeError:
        return (data.decode(ansi_codepage()), 'ansi')

def sweep_encode(text, encoding):
    """The text back in the encoding it was read in."""
    return {'utf-16-le-bom': lambda: b'\xff\xfe' + text.encode('utf-16-le'), 'utf-16-be-bom': lambda: b'\xfe\xff' + text.encode('utf-16-be'), 'utf-8-bom': lambda: b'\xef\xbb\xbf' + text.encode('utf-8'), 'utf-8': lambda: text.encode('utf-8'), 'ansi': lambda: text.encode(ansi_codepage())}[encoding]()

def sweep_read(path):
    return sweep_decode(pathlib.Path(path).read_bytes())

def sweep_write(path, text, encoding):
    pathlib.Path(path).write_bytes(sweep_encode(text, encoding))

def sweep_truncate(path):
    pathlib.Path(path).write_bytes(b'')

def sweep_delete(path):
    pathlib.Path(path).unlink()

def sweep_try(action, *args, tries=3):
    """True when the action worked within a few tries."""
    for _ in range(tries):
        try:
            action(*args)
            return True
        except Exception:
            continue
    return False

def needle_words():
    return [w for w in identity_names() + identity_machines() if w]

def needle_patterns(word):
    """Byte patterns for a needle in UTF-8, UTF-16-LE and the ANSI codepage. A word-matched needle (3+ characters, not a common word) needs no
    ASCII letter or digit next to it; any other needs a path separator on both sides."""
    patterns = []
    decoded_word = name_inside_components(word.lower())
    for form, encoding in ((f, e) for f in dict.fromkeys((word, word.lower(), word.upper())) for e in ('utf-8', 'utf-16-le', ansi_codepage())):
        try:
            raw = form.encode(encoding)
        except (UnicodeEncodeError, LookupError):
            if encoding == ansi_codepage() and word not in ansi_skipped:
                ansi_skipped.append(word)
            continue
        wide = encoding == 'utf-16-le'
        if decoded_word:
            before = b'(?<![A-Za-z0-9]\\x00)' if wide else b'(?<![A-Za-z0-9])'
            after = b'(?![A-Za-z0-9]\\x00)' if wide else b'(?![A-Za-z0-9])'
        else:
            separator = b'(?:\\\\\\x00|/\\x00)' if wide else b'[\\\\/]'
            before, after = (separator, b'(?=' + separator + b')')
        patterns.append(re.compile(before + re.escape(raw) + after, re.IGNORECASE))
    return patterns

def sweep_scan(path):
    """True when a needle is in the file's bytes (UTF-8, UTF-16-LE or ANSI). A file over the cap or one that cannot be read raises."""
    data = pathlib.Path(path).read_bytes()
    if len(data) > SWEEP_CAP:
        raise SweepTooLarge('over the sweep size cap')
    return any((pattern.search(data) for word in needle_words() for pattern in needle_patterns(word)))

def sweep_file(path, expected=None):
    """Scrub one file. Returns the note to log (a file that had to be truncated or removed), else ''. Never raises. A text-like file is
    scrubbed in its own encoding; a file that is not text and is not one of the builder's own outputs (named in results.json, or, when no
    list is given, with a builder extension) is scanned for the needles in its bytes and deleted on a hit, a cap or an error."""
    name = pathlib.Path(path).name
    suffix = pathlib.Path(path).suffix.lower()
    try:
        if name.startswith('~$') or suffix in TEMPORARY_SUFFIXES:
            if sweep_try(sweep_delete, path) or not pathlib.Path(path).exists():
                return ''
            if sweep_try(sweep_truncate, path):
                return 'privacy sweep: %s truncated (could not be removed)' % name
            return 'privacy sweep: %s could not be removed' % name
        if suffix not in TEXT_SUFFIXES:
            own = name.lower() in {n.lower() for n in expected} if expected is not None else suffix in BUILDER_SUFFIXES
            if own and suffix != '.pdf':
                return ''
            try:
                hit = sweep_scan(path)
                why = 'stray file, name found'
            except SweepTooLarge:
                hit, why = (True, 'stray file, ' + TOO_LARGE)
            except Exception:
                hit, why = (True, 'stray file, unreadable')
            if not hit:
                return ''
            if sweep_try(sweep_delete, path):
                return 'privacy sweep: %s removed (%s)' % (name, why)
            if sweep_try(sweep_truncate, path):
                return 'privacy sweep: %s truncated (%s)' % (name, why)
            return 'privacy sweep: %s could not be cleaned or removed' % name
        reasons = []

        def clean():
            try:
                text, encoding = sweep_read(path)
            except SweepTooLarge:
                reasons.append(TOO_LARGE)
                raise
            cleaned = scrub_text(text)
            if cleaned != text:
                sweep_write(path, cleaned, encoding)
        if sweep_try(clean):
            return ''
        reason = TOO_LARGE if reasons else 'unreadable'
        emptied_files.append(name)
        if sweep_try(sweep_truncate, path):
            return 'privacy sweep: %s truncated (%s)' % (name, reason)
        if sweep_try(sweep_delete, path):
            return 'privacy sweep: %s removed (%s)' % (name, reason)
        return 'privacy sweep: %s could not be cleaned or removed' % name
    except Exception:
        return 'privacy sweep: %s could not be cleaned or removed' % name
run_folder = []
swept = []
run_results = []
emptied_files = []

def sweep_expected(results):
    """The files the builder itself made in this run: results.json, the log, and every file a row lists."""
    return {'results.json', 'FixtureBuilder.log'} | {name for row in results for name in row.get('files', [])}

def final_sweep():
    """On every exit of a run (done, an error, a crash part way): the output folder is swept once. The sweep before the zip counts as that
    once; a run that stopped before it is swept here, so a crash leaves no unswept text file. Never raises."""
    try:
        if run_folder and (not swept):
            swept.append(True)
            for note in privacy_sweep(run_folder[0], sweep_expected(run_results[0]) if run_results else None):
                log_line(run_folder[0], 'summary', note)
    except Exception:
        pass

def privacy_sweep(folder, expected=None):
    """Before the zip: EVERY file in the output folder, listed or not. Text files are scrubbed; a file that cannot be read or written is
    truncated, then removed; lock files and temporary files are deleted. Always finishes the list. Returns the notes."""
    notes = []
    failures = []
    try:
        paths = sweep_list(folder, failures)
    except Exception as exc:
        paths = []
        failures.append(exc)
    for failure in failures:
        sweep_failed.append(True)
        notes.append('privacy sweep: could not list ' + scrub_text(pathlib.Path(str(getattr(failure, 'filename', None) or folder)).name))
    for path in paths:
        note = sweep_file(path, expected)
        if note:
            notes.append(note)
    if ansi_skipped:
        notes.append('privacy sweep: ansi form not applicable (a name has characters the ANSI codepage cannot hold); UTF-8 and UTF-16 searched')
        ansi_skipped.clear()
    return notes

def sweep_list(folder, failures):
    """Every file under the folder. A folder that cannot be listed (access denied, a path too long) goes into failures; the rest is listed."""
    found = []
    for root, _, names in os.walk(folder, onerror=failures.append):
        found.extend((pathlib.Path(root) / name for name in names))
    if not pathlib.Path(folder).is_dir():
        failures.append(FileNotFoundError(2, 'not a folder', str(folder)))
    return sorted(found)

def ask_ok_cancel(text):
    """The up-front notice: OK or Cancel. No window for an unattended run (FIXTURE_UNATTENDED=1 or no console)."""
    if unattended():
        return None
    import ctypes
    set_step('MessageBoxW', 'ask_ok_cancel')
    return ctypes.windll.user32.MessageBoxW(0, text, 'SolidWorks fixtures', 65) == 1

def confirm_user_name_notice():
    """Once per run. Returns (go, note): note says whether it was shown and the answer; Cancel means nothing is built."""
    answer = ask_ok_cancel(USER_NAME_NOTICE)
    if answer is None:
        return (True, 'user name notice: not shown (unattended run)')
    return (bool(answer), 'user name notice: shown, answer ' + ('OK' if answer else 'Cancel'))

def check_templates(app):
    """A template under a personal path is refused before anything is built (a drawing keeps its template path)."""
    for kind in ('part', 'assembly', 'drawing'):
        try:
            path = resolve_template(app, kind)
        except Exception:
            continue
        reason = personal_template_reason(kind, path)
        if reason:
            raise PersonalPathError(reason)
STEP_ENTITY = re.compile('FILE_NAME\\s*\\((.*?)\\)\\s*;', re.S)
STEP_STRING = re.compile("'((?:[^']|'')*)'")
STEP_CAP = 50 * 1024 * 1024

def step_args(body):
    """The top-level arguments of a STEP entity (commas inside quotes or parentheses do not split)."""
    args, current, depth, quoted, i = ([], [], 0, False, 0)
    while i < len(body):
        ch = body[i]
        if quoted:
            current.append(ch)
            if ch == "'":
                if body[i + 1:i + 2] == "'":
                    current.append("'")
                    i += 1
                else:
                    quoted = False
        elif ch == "'":
            quoted = True
            current.append(ch)
        elif ch == ',' and depth == 0:
            args.append(''.join(current))
            current = []
        else:
            depth += (ch == '(') - (ch == ')')
            current.append(ch)
        i += 1
    args.append(''.join(current))
    return args

def step_header_problem(args):
    """True when FILE_NAME is not a bare name or the author or organization field holds anything but nothing or the neutral name."""
    if len(args) < 4:
        return True
    name = STEP_STRING.search(args[0])
    if name is None or '\\' in name.group(1) or '/' in name.group(1):
        return True
    return any((value not in ('', NEUTRAL_VALUE) for field in (args[2], args[3]) for value in STEP_STRING.findall(field)))

def step_header_guard(path):
    """After every STEP export: the first 4 KB must hold FILE_NAME as a bare file name with an empty (or neutral) author and organization.
    Otherwise those fields are rewritten in the file (the bytes are kept as they are: latin-1 maps one byte to one character). Returns True
    when it rewrote the header; raises when it cannot read or rewrite it, so the row fails."""
    data = pathlib.Path(path).read_bytes()
    if len(data) > STEP_CAP:
        raise RuntimeError('step header: the file is too large to check')
    text = data.decode('latin-1')
    found = STEP_ENTITY.search(text[:4096])
    if found is None:
        raise RuntimeError('step header: no FILE_NAME in the first 4 KB')
    args = step_args(found.group(1))
    if not step_header_problem(args):
        return False
    first = STEP_STRING.search(args[0]).group(1) if STEP_STRING.search(args[0]) else ''
    args[0] = "'" + re.split('[\\\\/]', first)[-1] + "'"
    for index in (2, 3):
        if len(args) > index and any((v not in ('', NEUTRAL_VALUE) for v in STEP_STRING.findall(args[index]))):
            args[index] = "('')"
    rebuilt = 'FILE_NAME(' + ','.join(args) + ');'
    fixed = text[:found.start()] + rebuilt + text[found.end():]
    pathlib.Path(path).write_bytes(fixed.encode('latin-1'))
    again = STEP_ENTITY.search(pathlib.Path(path).read_bytes().decode('latin-1')[:4096])
    if again is None or step_header_problem(step_args(again.group(1))):
        raise RuntimeError('step header: the rewrite did not take')
    return True
SUMMARY_FIELDS = ((2, 'author'), (3, 'keywords'), (4, 'comment'), (5, 'savedby'))
READBACK_RANK = {'blank': 1, NEUTRAL_VALUE: 2, 'set by SolidWorks (redacted)': 3}
readback_state = {}

def summary_readback(doc):
    """After a save: each summary field is ours (Fixture Builder), blank, or written by SolidWorks. Never a value that is not ours."""
    for field, label in SUMMARY_FIELDS:
        try:
            set_step('Invoke', 'summary_readback')
            value = doc._oleobj_.Invoke(doc._oleobj_.GetIDsOfNames('SummaryInfo'), 0, 2, 1, field)
        except Exception:
            continue
        status = 'blank' if not str(value or '').strip() else NEUTRAL_VALUE if str(value) == NEUTRAL_VALUE else 'set by SolidWorks (redacted)'
        if READBACK_RANK[status] > READBACK_RANK.get(readback_state.get(label), 0):
            readback_state[label] = status

def readback_text():
    if not readback_state:
        return 'summary info read-back: no file was saved'
    return 'summary info read-back after save: ' + ' '.join(('%s=%s' % (label, readback_state.get(label, 'not read')) for _, label in SUMMARY_FIELDS))

def run(app, output=None, run_mode='left', previous=None):
    run_folder.clear()
    swept.clear()
    run_results.clear()
    emptied_files.clear()
    sweep_failed.clear()
    ansi_skipped.clear()
    output = output or default_output_root()
    reason = personal_path_reason(output)
    if reason:
        raise PersonalPathError(reason)
    go, notice_note = confirm_user_name_notice()
    if not go:
        raise UserCancelled('Canceled at the user name notice; nothing was built.')
    readback_state.clear()
    notices[:] = [notice_note]
    set_step('GetUserPreferenceToggle', 'run')
    old_input = app.GetUserPreferenceToggle(swInputDimValOnCreate)
    try:
        set_step('SetUserPreferenceToggle', 'run')
        app.SetUserPreferenceToggle(swInputDimValOnCreate, False)
        set_step('GetUserPreferenceToggle', 'run')
        old_rebuild = app.GetUserPreferenceToggle(swShowErrorsEveryRebuild)
        try:
            set_step('SetUserPreferenceToggle', 'run')
            app.SetUserPreferenceToggle(swShowErrorsEveryRebuild, False)
            set_step('GetUserPreferenceToggle', 'run')
            old_warn = app.GetUserPreferenceToggle(swWarnSaveUpdateErrors)
            try:
                set_step('SetUserPreferenceToggle', 'run')
                app.SetUserPreferenceToggle(swWarnSaveUpdateErrors, False)
                set_step('GetUserPreferenceIntegerValue', 'run')
                old_action = app.GetUserPreferenceIntegerValue(swRebuildErrorAction)
                try:
                    set_step('SetUserPreferenceIntegerValue', 'run')
                    check(app.SetUserPreferenceIntegerValue(swRebuildErrorAction, swContinueResponse_Stop), 'cannot disable rebuild prompt')
                    try:
                        return run_quiet(app, output, run_mode, previous)
                    finally:
                        final_sweep()
                finally:
                    set_step('SetUserPreferenceIntegerValue', 'run')
                    app.SetUserPreferenceIntegerValue(swRebuildErrorAction, old_action)
            finally:
                set_step('SetUserPreferenceToggle', 'run')
                app.SetUserPreferenceToggle(swWarnSaveUpdateErrors, old_warn)
        finally:
            set_step('SetUserPreferenceToggle', 'run')
            app.SetUserPreferenceToggle(swShowErrorsEveryRebuild, old_rebuild)
    finally:
        set_step('SetUserPreferenceToggle', 'run')
        app.SetUserPreferenceToggle(swInputDimValOnCreate, old_input)

def new_output_folder(parent):
    base = 'FixtureBuilder-SolidWorks-' + BUILDER_VERSION
    parent = pathlib.Path(parent)
    parent.mkdir(parents=True, exist_ok=True)
    number = 1
    while True:
        folder = parent / (base if number == 1 else '%s-%d' % (base, number))
        try:
            folder.mkdir(exist_ok=False)
            return folder
        except FileExistsError:
            number += 1

def log_setup(folder, revision):
    entry = dict(time=time.strftime('%Y-%m-%dT%H:%M:%S%z'), builder=BUILDER_VERSION, recipe='setup', step='setup', Erl=0, **{'Err.Number': 0, 'Err.Description': 'SolidWorks revision %s; output folder %s; personal-path check: passed' % (revision, folder)})
    with (folder / 'FixtureBuilder.log').open('a', encoding='utf-8') as stream:
        stream.write(dump_json(entry) + '\n')
OUTPUT_PREFIX = 'FixtureBuilder-SolidWorks-'

def load_built(parent, exclude, version, build, previous=None):
    if previous is None:
        previous = sorted((p / 'results.json' for p in pathlib.Path(parent).iterdir() if p.is_dir() and p.name.startswith(OUTPUT_PREFIX) and (p.name != exclude)))
    built = {}
    for path in previous:
        try:
            rows = json.loads(pathlib.Path(path).read_text(encoding='utf-8-sig'))
        except (OSError, ValueError):
            continue
        for row in rows if isinstance(rows, list) else []:
            if isinstance(row, dict) and row.get('status') == 'ok' and (row.get('build') == build) and (row.get('version') == version) and row.get('id'):
                built[row['id']] = pathlib.Path(path).parent.name
    return built
MARKER = 'inprogress.txt'
CRASHED = 'crashed.txt'

class SkippedCrashed(Exception):
    pass

def process_died():
    error = sys.exc_info()[1]
    return error is not None and (not isinstance(error, Exception))

def crash_marker_write(folder, recipe, candidate, label, version, build):
    with (pathlib.Path(folder) / MARKER).open('w', encoding='utf-8') as stream:
        stream.write('\t'.join((recipe, candidate or '-', label, version, build)) + '\n')
        stream.flush()
        os.fsync(stream.fileno())

def crash_marker_clear(folder):
    try:
        (pathlib.Path(folder) / MARKER).unlink()
    except FileNotFoundError:
        pass

def scan_crashes(parent, exclude, version, build):
    crashed, notes = ({}, [])
    for folder in sorted((p for p in pathlib.Path(parent).iterdir() if p.is_dir() and p.name.startswith(OUTPUT_PREFIX) and (p.name != exclude))):
        fresh = folder / MARKER
        known = folder / CRASHED
        try:
            if fresh.is_file():
                text = fresh.read_text(encoding='utf-8-sig')
                fresh.replace(known)
                new = True
            elif known.is_file():
                text = known.read_text(encoding='utf-8-sig')
                new = False
            else:
                continue
        except OSError:
            continue
        for line in text.splitlines():
            fields = line.rstrip('\r').split('\t')
            if len(fields) < 2 or not fields[0]:
                continue
            recorded_version = fields[3] if len(fields) > 3 else ''
            recorded_build = fields[4] if len(fields) > 4 else ''
            same = (not recorded_version or recorded_version == version) and (not recorded_build or recorded_build == build)
            text = '%s %s (in %s)' % (fields[0], fields[1], folder.name)
            notes.append(('previous run crashed during ' if new else 'known crash (crashed.txt): ') + text + ('' if same else '; recorded on SolidWorks %s build %s, not this one, so not skipped' % (recorded_version, recorded_build)))
            if same:
                crashed.setdefault((fields[0], fields[1]), folder.name)
    return (crashed, notes)

def design_dependencies(design, assemblies_only=False):
    if not design.get('scripted', True):
        return []
    found = []

    def walk(ops):
        for op in ops:
            if op['kind'] == 'drawing' and (not assemblies_only):
                found.append(op['model'])
            if op['kind'] == 'assembly' and 'insert' in op and ('recipe' in op['insert']):
                found.append(op['insert']['recipe'])
            for key in ('copy_part', 'part_configuration'):
                if op['kind'] == 'assembly' and key in op:
                    found.append(op[key]['recipe'])
            if op['kind'] == 'assembly' and 'subassembly' in op:
                walk(op['subassembly']['ops'])
    walk(design['ops'])
    return found

def resolve_skips(designs, built):
    skip = {d['id']: built[d['id']] for d in designs if d['id'] in built}
    rebuilt = []
    changed = True
    while changed:
        changed = False
        for design in designs:
            if design['id'] in skip:
                continue
            for dependency in design_dependencies(design):
                if dependency in skip:
                    del skip[dependency]
                    rebuilt.append(dependency)
                    changed = True
    return (skip, rebuilt)

def run_quiet(app, output, run_mode='left', previous=None):
    global current_identity, sw_major, api_inputs, call_inputs, mitigations, probe_candidate
    api_inputs = call_inputs = ''
    set_step('RevisionNumber', 'run_quiet')
    revision = str(app.RevisionNumber())
    parts = revision.split('.')
    major = int(parts[0])
    sw_major = major
    version = str(major + 1992)
    build = '-'.join((re.sub('[^0-9A-Za-z_-]', '_', p) for p in parts[1:])) or '0'
    check_templates(app)
    folder = new_output_folder(output)
    run_folder[:] = [folder]
    swept.clear()
    log_setup(folder, revision)
    log_line(folder, 'setup', 'template path: neutral')
    for note in notices:
        log_line(folder, 'setup', note)
    results = []
    run_results[:] = [results]
    write_results(folder, results)
    current_identity = 'setup'
    crashed, crash_notes = scan_crashes(folder.parent, folder.name, version, build)
    for note in crash_notes:
        log_line(folder, 'crash guard', note)
    skip = {}
    if run_mode == 'left':
        built = load_built(folder.parent, folder.name, version, build, previous)
        skip, rebuilt = resolve_skips(DESIGNS, built)
        if not built:
            log_line(folder, 'run mode', 'run mode: left (no previous results found; building everything)')
        else:
            log_line(folder, 'run mode', 'run mode: left (%d skipped as already built on %s)' % (len(skip), build))
        for dependency in rebuilt:
            log_line(folder, 'run mode', dependency + ' was built before but is rebuilt: a recipe in this run needs it')
    else:
        log_line(folder, 'run mode', 'run mode: full')
    set_step('GetUserPreferenceIntegerValue', 'run_quiet')
    old_step = app.GetUserPreferenceIntegerValue(78)
    try:
        set_step('SetUserPreferenceIntegerValue', 'run_quiet')
        check(app.SetUserPreferenceIntegerValue(78, 214), 'cannot set STEP AP214')
        for design in DESIGNS:
            if design['id'] in skip:
                current_identity = design['id']
                results.append(dict(id=design['id'], status='skipped_built', error='', built_in=skip[design['id']], files=[], app='SolidWorks', version=version, build=build, seconds=0, mitigations={}))
                write_results(folder, results)
                log_line(folder, 'skipped', 'built in ' + skip[design['id']])
                continue
            api_inputs = call_inputs = ''
            mitigations = {}
            current_identity = design['id']
            set_step('preflight')
            start = time.perf_counter()
            row = dict(id=design['id'], status='failed', error='', files=[], app='SolidWorks', version=version, build=build, seconds=0, mitigations=mitigations)
            doc = None
            builder = None
            old_feature_errors = None
            early = []
            try:
                if major < 26:
                    raise NotScripted('needs SolidWorks 2018+')
                preflight(design)
                gate = version_gate(design)
                if gate and major < gate[0]:
                    raise NotScripted(gate[1] + str(major))
                is_assembly = any((o['kind'] == 'assembly' for o in design['ops']))
                drawing_op = next((o for o in design['ops'] if o['kind'] == 'drawing'), None)
                is_drawing = drawing_op is not None
                for dependency in design_dependencies(design, True):
                    if not any((r['id'] == dependency and r['status'] == 'ok' for r in results)):
                        raise NotScripted('assembly insert: component ' + dependency + ' was not built successfully')
                if is_drawing and (not any((r['id'] == drawing_op['model'] and r['status'] == 'ok' for r in results))):
                    raise NotScripted('drawing: the model ' + drawing_op['model'] + ' was not built successfully')
                template = resolve_template(app, 'drawing' if is_drawing else 'assembly' if is_assembly else 'part')
                if is_drawing:
                    set_step('model open')
                    import pythoncom
                    from win32com.client import VARIANT
                    errors = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
                    warnings = VARIANT(pythoncom.VT_BYREF | pythoncom.VT_I4, 0)
                    set_step('OpenDoc6', 'run_quiet')
                    model = app.OpenDoc6(str(folder / (drawing_op['model'] + '.sldprt')), swDocPART, swOpenDocOptions_Silent, '', errors, warnings)
                    if errors.value:
                        raise RuntimeError('SolidWorks OpenDoc6 error %s opening the drawing model' % errors.value)
                    set_step('GetTitle', 'run_quiet')
                    early.append(check(model, 'the drawing model could not be opened').GetTitle())
                names = probe_candidates(design)
                probing = bool(names)
                if not probing and (design['id'], '-') in crashed:
                    raise SkippedCrashed('crashed SolidWorks in %s; skipped' % crashed[design['id'], '-'])
                if probing:
                    row['probes'], row['probe_kept'] = ([], None)
                outcomes = row.get('probes')
                full_errors = []
                for number, candidate in enumerate(names or [''], 1):
                    if probing and row['probe_kept'] is not None and (time.perf_counter() - start > PROBE_SECONDS):
                        reason = 'skipped: the recipe had already used %d s (limit %d s for probes after the first success)' % (time.perf_counter() - start, PROBE_SECONDS)
                        outcomes.append(probe_entry(candidate, False, reason))
                        log_line(folder, 'probe', 'probe %s candidate %d %s: %s' % (design['id'], number, candidate, reason))
                        continue
                    if probing and (design['id'], candidate) in crashed:
                        reason = 'crashed SolidWorks in %s (skipped)' % crashed[design['id'], candidate]
                        outcomes.append(probe_entry(candidate, False, reason))
                        full_errors.append('%s: %s' % (candidate, reason))
                        log_line(folder, 'probe', 'probe %s candidate %d %s: %s' % (design['id'], number, candidate, reason))
                        continue
                    probe_candidate = candidate
                    builder = None
                    if probing and number > 1:
                        mitigations.clear()
                    try:
                        crash_marker_write(folder, design['id'], candidate, 'attempt', version, build)
                        log_line(folder, 'start', 'start %s candidate %s' % (design['id'], candidate or '-'))
                        set_step('NewDocument', 'run_quiet')
                        doc = app.NewDocument(template, 0, 0.0, 0.0)
                        if doc is None:
                            raise TemplateError('Template could not be opened. Paths tried: ' + template)
                        if is_drawing:
                            log_line(folder, 'option', 'drawing template: ' + pathlib.Path(template).name)
                        set_step('ShowFeatureErrorDialog', 'run_quiet')
                        old_feature_errors = doc.ShowFeatureErrorDialog
                        set_step('ShowFeatureErrorDialog', 'run_quiet')
                        doc.ShowFeatureErrorDialog = False
                        builder = Builder(app, doc, folder)
                        builder.wanted_mates = {o['mate'] for o in design['ops'] if o['kind'] == 'assembly' and 'mate' in o}
                        builder.expected, builder.final_mates = (expected_poses(design), final_mates(design['ops']))
                        for op in design['ops']:
                            try:
                                builder.apply(op)
                            except Exception as exc:
                                if builder.k_failure is None:
                                    raise
                                log_error(folder, exc)
                                raise KFactorFailed(builder.k_failure + '; ' + diagnostic_error(exc))
                        try:
                            if not is_drawing:
                                set_step('EditRebuild3', 'run_quiet')
                                check(doc.EditRebuild3(), 'rebuild failed')
                        except Exception as exc:
                            if builder.k_failure is None:
                                raise
                            raise KFactorFailed(builder.k_failure + '; ' + diagnostic_error(exc))
                        if builder.k_failure is not None:
                            raise KFactorFailed(builder.k_failure + '; the later features then built without error; nothing was saved')
                        builder.verify_equations()
                        if design.get('placements'):
                            set_step('placement check')
                            builder.check_placements(design['placements'])
                        if not is_assembly and (not is_drawing) and design.get('expect'):
                            set_step('expect check')
                            try:
                                report = verify_expect(doc, design['expect'])
                            finally:
                                if volume_log_text():
                                    log_line(folder, 'volume', volume_log_text())
                            log_line(folder, 'expect check', report)
                        if not probing or row['probe_kept'] is None:
                            native = design['id'] + ('.slddrw' if is_drawing else '.sldasm' if is_assembly else '.sldprt')
                            step_file = design['id'] + ('.dxf' if is_drawing else '.step')
                            privacy(doc)
                            save(doc, folder / native)
                            if is_drawing:
                                set_step('dxf export')
                                builder.export_drawing(folder / step_file)
                            else:
                                privacy(doc)
                                save(doc, folder / step_file)
                                set_step('step header')
                                if step_header_guard(folder / step_file):
                                    log_line(folder, 'step header', 'step header: rewritten')
                            if builder.state_checks:
                                set_step('saved-file check')
                                closing, doc = (doc, None)
                                set_step('CloseDoc', 'run_quiet')
                                app.CloseDoc(closing.GetTitle())
                                log_line(folder, 'saved-file check', builder.check_saved_states(folder / native))
                            row.update(status='ok', files=[native, step_file] + builder.extra_files)
                            if builder.placement_report:
                                row['placements'] = safe_error(builder.placement_report)
                                if builder.placement_report.startswith('fail'):
                                    row.update(status='failed', error='placement check: ' + safe_error(builder.placement_report))
                            if builder.limit_notes:
                                row['limits'] = safe_error('; '.join(builder.limit_notes))
                            if builder.limit_degraded:
                                row['degraded'] = True
                            if probing:
                                row['probe_kept'] = candidate[:60]
                                kept_mitigations = json.loads(json.dumps(mitigations))
                        if probing:
                            outcomes.append(probe_entry(candidate, True, '', builder.probe_note))
                            log_line(folder, 'probe', 'probe %s candidate %d %s: ok' % (design['id'], number, candidate))
                    except NotScripted:
                        raise
                    except Exception as exc:
                        if not probing:
                            raise
                        log_error(folder, exc)
                        outcomes.append(probe_entry(candidate, False, diagnostic_error(exc), builder.probe_note if builder is not None else ''))
                        full_errors.append('%s: %s' % (candidate, diagnostic_error(exc)))
                        log_line(folder, 'probe', 'probe %s candidate %d %s: failed %s' % (design['id'], number, candidate, diagnostic_error(exc)))
                        for extension in ('.sldprt', '.sldasm', '.slddrw', '.dxf', '.step'):
                            if row['probe_kept'] is None:
                                (folder / (design['id'] + extension)).unlink(missing_ok=True)
                    finally:
                        if not process_died():
                            crash_marker_clear(folder)
                            probe_candidate = ''
                            if probing:
                                release_documents(app, folder, row, results, doc, old_feature_errors, [], builder)
                                doc = builder = old_feature_errors = None
                if probing and row['probe_kept'] is not None:
                    mitigations.clear()
                    mitigations.update(kept_mitigations)
                if probing and row['probe_kept'] is None:
                    raise RuntimeError('every candidate failed: ' + ' | '.join(full_errors))
            except NotScripted as exc:
                row.update(status='not_scripted', error=safe_error(exc))
            except SkippedCrashed as exc:
                log_line(folder, 'crash guard', 'skipped %s: %s' % (design['id'], exc))
                row.update(status='failed', error=str(exc))
            except Exception as exc:
                log_error(folder, exc)
                row.update(status='failed', error=diagnostic_error(exc))
            finally:
                if not process_died():
                    row['seconds'] = round(time.perf_counter() - start, 4)
                    results.append(row)
                    write_results(folder, results)
                    release_documents(app, folder, row, results, doc, old_feature_errors, early, builder)
                    if row['status'] != 'ok' and (not row.get('files')):
                        for extension in ('.sldprt', '.sldasm', '.slddrw', '.dxf', '.step'):
                            try:
                                (folder / (design['id'] + extension)).unlink(missing_ok=True)
                            except Exception as exc:
                                log_error(folder, exc)
                                row.update(status='failed', error=diagnostic_error(exc), files=[])
                                write_results(folder, results)
                    row['seconds'] = round(time.perf_counter() - start, 4)
                    write_results(folder, results)
                    log_mitigations(folder)
        counts = {}
        for r in results:
            counts[r['status']] = counts.get(r['status'], 0) + 1
        current_identity = 'setup'
        log_line(folder, 'summary', 'summary: ' + ' '.join(('%s=%d' % (k, counts.get(k, 0)) for k in ('ok', 'failed', 'not_scripted', 'skipped_built'))))
        degraded = [r['id'] for r in results if r.get('degraded')]
        if degraded:
            log_line(folder, 'summary', 'degraded (limits not stored, the motion is free): %d recipe%s: %s' % (len(degraded), '' if len(degraded) == 1 else 's', ' '.join(degraded)))
        checked = [r['placements'] for r in results if r.get('placements')]
        if checked:
            log_line(folder, 'summary', 'placement checks (A11 and up, read back from SolidWorks): pass=%d fail=%d' % (sum((p.startswith('pass') for p in checked)), sum((p.startswith('fail') for p in checked))))
        log_line(folder, 'summary', readback_text())
        log_line(folder, 'summary', 'SolidWorks stamps the saving user in each file: not removable by the API')
        log_line(folder, 'summary', "SolidWorks also records its Windows temp folder (under your user profile) in each native file; we keep native files private and publish only STEP and files we've checked clean.")
        swept[:] = [True]
        for note in privacy_sweep(folder, sweep_expected(results)):
            log_line(folder, 'summary', note)
        archive = folder.parent / (folder.name + '.zip')
        zip_made = False if sweep_failed else make_zip(app, folder, results, archive)
        zip_error = folder.parent / (folder.name + '-zip-error.txt')
        if zip_error.exists():
            sweep_file(zip_error)
        LAST_ZIP[:] = [archive] if zip_made else []
        LAST_FOLDER[:] = [folder]
        LAST_FINISH[:] = [finish_message(results, archive, zip_made, folder)]
        log_line(folder, 'summary', LAST_FINISH[0])
    except Exception as exc:
        swept.clear()
        log_error(folder, exc)
        raise
    finally:
        set_step('SetUserPreferenceIntegerValue', 'run_quiet')
        app.SetUserPreferenceIntegerValue(78, old_step)
    return results
if __name__ == '__main__':
    import win32com.client
    set_step('Dispatch')
    application = win32com.client.Dispatch('SldWorks.Application')
    set_step('Visible')
    application.Visible = True
    try:
        outcome = run(application, sys.argv[1] if len(sys.argv) > 1 else None)
    except Exception as exc:
        print(scrubbed_traceback(exc), file=sys.stderr)
        raise SystemExit(1)
    if LAST_FINISH:
        print(LAST_FINISH[0])
        if not unattended():
            reveal_file(LAST_ZIP[0] if LAST_ZIP else LAST_FOLDER[0])
