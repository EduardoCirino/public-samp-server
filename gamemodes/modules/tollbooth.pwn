/*

Tollbooth system
Sistema de pedágio.
Autor: Eduardo
Release: 07/12/2018

*/

/* • - • Main • - • */
#define MAX_TOLLBOOTH	(3)

enum tollboothData
{
	bool:tollExpressWay,
	tollFee,
	tollName[64],
	Float:tollPayLeftX,
	Float:tollPayLeftY,
	Float:tollPayLeftZ,
	Float:tollPayRightX,
	Float:tollPayRightY,
	Float:tollPayRightZ,
	bool:tollWorking,	
	tollPayments,		
	tollLeftOpen,
	tollRightOpen,
	tollEmergencyTimer,
	tollClosedTime
}

static const TollBoothData[MAX_TOLLBOOTH][tollboothData] = {
	{true, 10, "Constitution Bridge", 501.0674, 493.7418, 18.9220, 502.0744, 504.7376, 18.9220, true, 0, 0, 0},
	{true, 10, "The Gateway Bridge", -178.0641, 341.0269, 11.8052, -169.6452, 347.9099, 11.8052, true, 0, 0, 0},
	{false, 10, "Taylor Bridge", -97.6164, -929.7829, 19.7298, -42.9229, -834.4197, 12.3356, true, 0, 0, 0}
	
};

/* Areas ID */

//Consititution Bridge
new Float:ConstitutionAreaRight[] = {
	502.4367, 508.1015, 498.7672, 505.0590, 507.5501, 492.6976, 511.1657, 495.4467, 502.4367, 508.1015
};
new Float:ConstitutionAreaLeft[] = {
	500.9455, 490.9360, 504.8068, 494.0284, 495.7984, 506.2549, 492.1161, 503.6390, 500.9455, 490.9360
};
new ConstitutionRight, ConstitutionLeft;
//The Gateway Bridge
new Float:GatewayAreaRight[] = {
	-175.8145, 334.5483, -171.4556, 350.2504, -167.3425, 349.5815, -171.2886, 334.0839, -175.8145, 334.5483
};
new Float:GatewayAreaLeft[] = {
	-172.6882, 354.2172, -176.5537, 338.6577, -180.2926, 339.4183, -176.5555, 354.9942, -172.6882, 354.2172
};
new GatewayRight, GatewayLeft;

//The Gateway Bridge
new Float:TaylorAreaRight[] = {
	-40.4209, -833.5529, -44.9279, -831.5198, -48.0759, -837.7552, -43.6496, -839.6100, -40.4209,-833.5529
};
new Float:TaylorAreaLeft[] = {
	-100.1241, -930.5603, -95.7477, -932.6852, -91.6754, -924.5946, -95.9568, -922.5988, -100.1241, -930.5603
};
new TaylorRight, TaylorLeft;

/* Ongamemodeinit */
TollBooth_CreateAreas()
{
	ConstitutionRight = CreateDynamicPolygon(ConstitutionAreaRight);
	ConstitutionLeft = CreateDynamicPolygon(ConstitutionAreaLeft);

	GatewayRight = CreateDynamicPolygon(GatewayAreaRight);
	GatewayLeft = CreateDynamicPolygon(GatewayAreaLeft);

	TaylorRight = CreateDynamicPolygon(TaylorAreaRight);
	TaylorLeft = CreateDynamicPolygon(TaylorAreaLeft);

	//Mapas estáticos (placas, informativos de rodovias)
	static tollbooth_static_obj;
	tollbooth_static_obj = CreateDynamicObject(19482, -196.139389, 249.874176, 18.319778, 0.000000, 0.000000, -105.099967, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "TOLLBOOTH\nThe Gateway Bridge\n\nCASH AND\nEXPRESS WAY", 130, "Quartz MS", 37, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -197.713455, 250.300704, 17.299739, 0.000000, 0.000000, 74.799964, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ê", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -201.692550, 251.941604, 19.089757, 0.000000, 0.000000, 74.799964, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "çè", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -201.702224, 251.944213, 18.509756, 0.000000, 0.000000, 74.799964, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ROUTE", 90, "Ariel", 24, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -201.663650, 251.933715, 17.779741, 0.000000, 0.000000, 74.799964, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "46", 80, "Ariel", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -201.711868, 251.946838, 17.169742, 0.000000, 0.000000, 74.799964, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "EAST-WEST", 130, "Ariel", 28, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -199.888122, 251.451309, 19.189760, 0.000000, 0.000000, 74.799964, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "é", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -199.859039, 251.443557, 18.509756, 0.000000, 0.000000, 74.799964, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ROAD", 90, "Ariel", 24, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -199.839813, 251.438201, 17.779741, 0.000000, 0.000000, 74.799964, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "13", 80, "Ariel", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -199.830062, 251.435638, 17.179737, 0.000000, 0.000000, 74.799964, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "SOUTH", 130, "Ariel", 28, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -194.663986, 249.472320, 17.299739, 0.000000, 0.000000, 74.799964, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ê", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -140.348876, 482.535675, 18.369781, 0.000037, 0.000006, 75.500038, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "TOLLBOOTH\nThe Gateway Bridge\n\nCASH AND\nEXPRESS WAY", 130, "Quartz MS", 37, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -138.770462, 482.125671, 17.349742, -0.000037, -0.000006, -104.599716, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ê", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -134.774398, 480.526550, 19.139759, -0.000037, -0.000006, -104.599716, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ì", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -134.764694, 480.524047, 18.559761, -0.000037, -0.000006, -104.599716, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "INTERSTATE", 90, "Ariel", 20, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -134.803390, 480.534118, 17.829744, -0.000037, -0.000006, -104.599716, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "26", 80, "Ariel", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -134.755035, 480.521484, 17.219745, -0.000037, -0.000006, -104.599716, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "NORTH-EAST", 130, "Ariel", 28, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -136.583847, 480.997924, 19.239763, -0.000037, -0.000006, -104.599716, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "é", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -136.613021, 481.005310, 18.559761, -0.000037, -0.000006, -104.599716, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ROAD", 90, "Ariel", 24, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -136.632293, 481.010498, 17.829744, -0.000037, -0.000006, -104.599716, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "13", 80, "Ariel", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -136.642074, 481.012969, 17.229742, -0.000037, -0.000006, -104.599716, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "NORTH", 130, "Ariel", 28, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -141.828445, 482.922058, 17.349742, -0.000037, -0.000006, -104.599716, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ê", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 426.281036, 602.704467, 25.519783, 0.000128, 0.000006, 124.999916, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "TOLLBOOTH\nConstitution Bridge\n\nCASH AND\nEXPRESS WAY", 130, "Quartz MS", 37, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 427.617889, 603.638488, 24.449743, -0.000128, -0.000007, -55.099502, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ê", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 431.429107, 605.638549, 26.239761, -0.000128, -0.000007, -55.099502, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ì", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 431.437316, 605.644287, 25.659761, -0.000128, -0.000007, -55.099502, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "INTERSTATE", 90, "Ariel", 20, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 431.404510, 605.621398, 24.929744, -0.000128, -0.000007, -55.099502, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "26", 80, "Ariel", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 431.445526, 605.650024, 24.319746, -0.000128, -0.000007, -55.099502, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "EAST", 130, "Ariel", 28, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 429.895538, 604.568664, 26.339763, -0.000128, -0.000007, -55.099502, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "é", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 429.870971, 604.551391, 25.659761, -0.000128, -0.000007, -55.099502, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ROAD", 90, "Ariel", 24, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 429.854461, 604.540100, 24.929744, -0.000128, -0.000007, -55.099502, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "7", 80, "Ariel", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 429.846221, 604.534240, 24.329742, -0.000128, -0.000007, -55.099502, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "NORTH", 130, "Ariel", 28, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 425.026306, 601.830322, 24.449743, -0.000128, -0.000007, -55.099502, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ê", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 614.085021, 343.557922, 25.121095, -0.229318, -0.327738, -55.200740, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "TOLLBOOTH\nConstitution Bridge\n\nCASH AND\nEXPRESS WAY", 130, "Quartz MS", 37, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 612.744934, 342.621154, 24.057603, 0.228750, 0.328134, 124.699905, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ê", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 609.600280, 341.113739, 25.858257, 0.228750, 0.328134, 124.699905, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "çè", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 609.592590, 341.104064, 25.278312, 0.228750, 0.328134, 124.699905, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ROUTE", 90, "Ariel", 20, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 609.592590, 341.099029, 24.548313, 0.228750, 0.328134, 124.699905, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "46", 80, "Ariel", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 609.616882, 341.111846, 23.938207, 0.228750, 0.328134, 124.699905, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "EAST-WEST", 130, "Ariel", 28, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 0.826351, -722.704833, 13.213438, 0.000000, 0.000000, 68.299919, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "TOLLBOOTH\nTaylor Bridge\n\nCASH ONLY", 130, "Quartz MS", 37, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 0.278163, -722.487060, 11.013411, 0.000000, 0.000000, 68.299919, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ê   ê", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 0);
	tollbooth_static_obj = CreateDynamicObject(19482, 4.384078, -724.689575, 13.723445, 0.000000, 0.000000, -111.700057, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "é", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 615.342773, 344.420257, 24.044981, 0.228750, 0.328134, 124.699905, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ê", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 4.393376, -724.693237, 13.033436, 0.000000, 0.000000, -111.600059, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ROAD", 90, "Quartz MS", 24, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 4.411972, -724.700500, 12.343449, 0.000000, 0.000000, -111.600059, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "13", 80, "Quartz MS", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 4.411972, -724.700500, 11.793454, 0.000000, 0.000000, -111.600059, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "NORTH", 130, "Quartz MS", 28, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 6.114087, -725.378906, 13.723445, -0.000007, -0.000002, -111.700035, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "è", 90, "Wingdings", 45, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 6.123384, -725.382568, 13.033436, -0.000007, -0.000002, -111.600036, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "ROAD", 90, "Quartz MS", 24, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 6.141980, -725.389831, 12.343449, -0.000007, -0.000002, -111.600036, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "4", 80, "Quartz MS", 35, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, 6.141980, -725.389831, 11.793454, -0.000007, -0.000002, -111.600036, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tollbooth_static_obj, 0, "EAST", 130, "Quartz MS", 28, 1, 0xFFFFFFFF, 0x00000000, 1);
	tollbooth_static_obj = CreateDynamicObject(19482, -118.031379, -992.196350, 31.103464, -0.000054, -0.000014, -42.499786, -1, -1, -1, 300.00, 300.00);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tollbooth_static_obj = CreateDynamicObject(3514, -206.778213, 253.094543, 15.351842, 0.000000, 0.000000, -15.100015, -1, -1, -1, 300.00, 300.00);
	tollbooth_static_obj = CreateDynamicObject(3514, -129.676925, 479.426940, 15.401845, 0.000006, -0.000037, 165.499832, -1, -1, -1, 300.00, 300.00);
	tollbooth_static_obj = CreateDynamicObject(3514, 435.575805, 608.800537, 22.501848, 0.000006, -0.000128, -145.000518, -1, -1, -1, 300.00, 300.00);
	tollbooth_static_obj = CreateDynamicObject(3514, 604.768981, 337.473419, 22.145793, -0.327737, 0.229320, 34.800209, -1, -1, -1, 300.00, 300.00);
	tollbooth_static_obj = CreateDynamicObject(3514, -4.873753, -720.671691, 9.978132, 0.000000, 0.000000, -21.599990, -1, -1, -1, 300.00, 300.00);

	return 1;
}


/* • - • Commands • - • */

CMD:pagarpedagio(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendWarningMessage(playerid, "Você não está dentro de um veículo.");

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendWarningMessage(playerid, "Você precisa ser o motorista do veículo para poder pagar o pedágio.");

	if(!TollBooth_Nearest(playerid, 1))
	{
		SendWarningMessage(playerid, "Você não está próximo de uma cabine de pedágio.");
	}

	return 1;
}

CMD:pedagios(playerid)
{
	if(GetFactionType(playerid) != FACTION_POLICE)
	{
		SendClientMessageEx(playerid, COLOR_LIGHTPINK, "Existem %d pedágios espalhados por toda San Andreas.", sizeof(TollBoothData));
	}
	else
	{
		if(!PlayerData[playerid][pOnDuty])
			return SendWarningMessage(playerid, "Você não está em serviço.");

		new count, payments, timeclosed;

		sz_MiscString[0] = 0;

		for(new i = 0; i < sizeof(TollBoothData); i++)
		{
			if(!TollBoothData[i][tollWorking])
				count++;

			payments += TollBoothData[i][tollPayments];

			timeclosed += TollBoothData[i][tollClosedTime];
		}		

		format(sz_MiscString, sizeof(sz_MiscString), "{FFFFFF}A partir deste menu você poderá gerenciar os pedágios espalhados por toda San Andreas\nalém de visualizar as suas informações.\n\n");
		strcat(sz_MiscString, "Esta tela irá exibir as informações financeiras e estatísticas de todos os pedágios,\nsendo o total de visitas e pagamentos realizados nos últimos 60 minutos.\n");
		format(sz_MiscString, sizeof(sz_MiscString), "%s\n{6e9b69}Estatísticas:\n{FFFFFF}Pedágios fechados: %d/%d\tPagamentos: %s\tTempo fechado: %d minutos", sz_MiscString, count, sizeof(TollBoothData), FormatNumber(payments), timeclosed / 60);

		Dialog_Show(playerid, TollBooth_Overview, DIALOG_STYLE_MSGBOX, "Gerenciamento dos pedágios", sz_MiscString, "Prosseguir", "Sair");
	}		

	return 1;
}

//Administrativo
CMD:editarpedagios(playerid)
{
	sz_MiscString[0] = 0;

	for(new i = 0; i < sizeof(TollBoothData); i++)
	{
		format(sz_MiscString, sizeof(sz_MiscString), "%s%s\n", sz_MiscString, TollBoothData[i][tollName]);
	}

	Dialog_Show(playerid, Admin_Tollbooth, DIALOG_STYLE_LIST, "Gerenciamento administrativo dos pedágios", sz_MiscString, "Selecionar", "Cancelar");

	return 1;
}

/* • - • Dialogs • - • */

Dialog:TollBooth_Overview(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new size = sizeof(TollBoothData);

		sz_MiscString[0] = 0;

		format(sz_MiscString, sizeof(sz_MiscString), "Pédagio\tSituação\n");

		for(new i = 0; i < size; i++)
		{
			format(sz_MiscString, sizeof(sz_MiscString), "%s%s\t%s\n", sz_MiscString, TollBoothData[i][tollName], (TollBoothData[i][tollWorking]) ? ("{789e4d}Operacional") : ("{cc7463}Trancado"));
		}

		Dialog_Show(playerid, TollBooth_Manage, DIALOG_STYLE_TABLIST_HEADERS, "Gerenciamento dos pedágios", "%s\n \n{adadad}Trancar todos os pedágios\n{adadad}Destrancar todos os pedágios", "Selecionar", "<<", sz_MiscString);
	}
	return 1;
}

Dialog:TollBooth_Manage(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new index = sizeof(TollBoothData);
		if(listitem < index)
		{
			if(TollBoothData[listitem][tollWorking])
			{
				KillTimer(TollBoothData[listitem][tollEmergencyTimer]);
				TollBoothData[listitem][tollEmergencyTimer] = SetTimerEx("RestoreTollBooth", 45000, false, "d", listitem);
				TollBoothData[listitem][tollWorking] = false;
				SendFactionMessageEx(FACTION_POLICE, FactionData[PlayerData[playerid][pFaction]][factionColor], "** O pedágio localizado em %s foi trancado pelo %s %s.", TollBoothData[listitem][tollName], Faction_GetRank(playerid), ReturnName(playerid, 0));
				TollBooth_RefreshLED(listitem);
			}
			else
			{
				KillTimer(TollBoothData[listitem][tollEmergencyTimer]);
				TollBoothData[listitem][tollWorking] = true;
				SendFactionMessageEx(FACTION_POLICE, FactionData[PlayerData[playerid][pFaction]][factionColor], "** O pedágio localizado em %s foi destrancado pelo %s %s.", TollBoothData[listitem][tollName], Faction_GetRank(playerid), ReturnName(playerid, 0));
				TollBooth_RefreshLED(listitem);
			}
		}
		else if(listitem == index + 1)//tranc
		{
			for(new i = 0; i < index; i++)
			{
				KillTimer(TollBoothData[i][tollEmergencyTimer]);
				TollBoothData[i][tollEmergencyTimer] = SetTimerEx("RestoreTollBooth", 45000, false, "d", i);
				TollBoothData[i][tollWorking] = false;
				TollBooth_RefreshLED(i);
			}
			SendFactionMessageEx(FACTION_POLICE, FactionData[PlayerData[playerid][pFaction]][factionColor], "** Todos os pedágios foram trancados pelo %s %s.", Faction_GetRank(playerid), ReturnName(playerid, 0));
		}
		else if(listitem == index + 2)//dest
		{
			for(new i = 0; i < index; i++)
			{
				KillTimer(TollBoothData[i][tollEmergencyTimer]);
				TollBoothData[i][tollWorking] = true;
				TollBooth_RefreshLED(i);
			}

			SendFactionMessageEx(FACTION_POLICE, FactionData[PlayerData[playerid][pFaction]][factionColor], "** Todos os pedágios foram destrancados pelo %s %s.", Faction_GetRank(playerid), ReturnName(playerid, 0));
		}
	}
	else
	{
		callcmd::pedagios(playerid);
	}
	return 1;
}

Dialog:Admin_Tollbooth(playerid, response, listitem, inputtext[])
{
	if(response)
	{	
		PlayerData[playerid][pSelectedSlot] = listitem;

		Dialog_Show(playerid, Admin_Manage_Tollbooth, DIALOG_STYLE_LIST, sprintf("Gerenciar pedágio: %s", TollBoothData[listitem][tollName]), "Alterar valor\n%s ExpressWay", "Selecionar", "<<", TollBoothData[listitem][tollExpressWay] ? ("Desativar") : ("Ativar"));
	}

	return 1;
}

Dialog:Admin_Manage_Tollbooth(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new id = PlayerData[playerid][pSelectedSlot];
		switch(listitem)
		{
			case 0: //alterar valor
			{
				Dialog_Show(playerid, Admin_Manage_Toll_Price, DIALOG_STYLE_INPUT, sprintf("Pedágio: %s", TollBoothData[id][tollName]), "Preço atual: %s\n\nDigite abaixo o novo preço para esse pedágio:", "Setar", "<<", FormatNumber(TollBoothData[id][tollFee]));
			}
			case 1:
			{
				TollBoothData[id][tollExpressWay] = TollBoothData[id][tollExpressWay] ? false : true;
				TollBooth_RefreshLED(id); //atualizar o 'LED' do pedágio selecionado

				SendGreenMessage(playerid, "Você %s o Express Way do pedágio %s.", TollBoothData[id][tollExpressWay] ? ("ativou") : ("desativou"), TollBoothData[id][tollName]);
			}
		}
	}
	else
	{
		callcmd::editarpedagios(playerid);
	}

	return 1;
}

Dialog:Admin_Manage_Toll_Price(playerid, response, listitem, inputtext[])
{
	new id = PlayerData[playerid][pSelectedSlot];

	if(response)
	{
		new price;

		if(sscanf(inputtext, "d", price))
			return Dialog_Show(playerid, Admin_Manage_Toll_Price, DIALOG_STYLE_INPUT, sprintf("Pedágio: %s", TollBoothData[id][tollName]), "Valor inválido!\n\nPreço atual: %s\n\nDigite abaixo o novo preço para esse pedágio:", "Setar", "<<", FormatNumber(TollBoothData[id][tollFee]));
	
		if(price > 100)
			return Dialog_Show(playerid, Admin_Manage_Toll_Price, DIALOG_STYLE_INPUT, sprintf("Pedágio: %s", TollBoothData[id][tollName]), "Não ultrapasse o valor de $100.\n\nPreço atual: %s\n\nDigite abaixo o novo preço para esse pedágio:", "Setar", "<<", FormatNumber(TollBoothData[id][tollFee]));
	
		TollBoothData[id][tollFee] = price;
		TollBooth_RefreshLED(id); //atualizar o 'LED' do pedágio selecionado

		SendGreenMessage(playerid, "Você alterou o preço do pedágio %s para %s.", TollBoothData[id][tollName], FormatNumber(price));
	}
	else
	{
		Dialog_Show(playerid, Admin_Manage_Tollbooth, DIALOG_STYLE_LIST, sprintf("Gerenciar pedágio: %s", TollBoothData[id][tollName]), "Alterar valor\n%s ExpressWay", "Selecionar", "<<", TollBoothData[id][tollExpressWay] ? ("Desativar") : ("Ativar"));
	}

	return 1;
}

/* • - • Stocks • - • */

TollBooth_Nearest(playerid, pay = 0)
{
	for(new i = 0; i < sizeof(TollBoothData); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.8, TollBoothData[i][tollPayLeftX], TollBoothData[i][tollPayLeftY], TollBoothData[i][tollPayLeftZ]))
		{
			new object;

			switch(i)
			{
				case 0: object = Object_GetID(5596); //Constitution Bridge Object ID: 5596
				case 1: object = Object_GetID(5641); //The Gateway Bridge Object ID: 5641
				case 2: object = Object_GetID(5735); //Taylor Bridge Object ID: 5735
			}

			if(pay)
				TollBooth_Pay(playerid, 1, object, i);
			else
				TollBooth_Pay(playerid, 1, object, i, 1);
			
			return 1;
		}
		
		else if(IsPlayerInRangeOfPoint(playerid, 1.8, TollBoothData[i][tollPayRightX], TollBoothData[i][tollPayRightY], TollBoothData[i][tollPayRightZ]))
		{
			new object;

			switch(i)
			{
				case 0: object = Object_GetID(5595); //Constitution Bridge Object ID: 5595
				case 1: object = Object_GetID(5640); //The Gateway Bridge Object ID: 5640
				case 2: object = Object_GetID(5734); //Taylor Bridge Object ID: 5734
			}

			if(pay)
				TollBooth_Pay(playerid, 0, object, i);
			else
				TollBooth_Pay(playerid, 0, object, i, 1);

			return 1;
		}
	}

	return 0;
}

TollBooth_Pay(playerid, left, object, tollbooth, policecar = 0)
{
	if(object == -1 || !ObjectData[object][objectExists])
		return 0;

	if(!policecar)
	{
		if(GetScriptedMoney(playerid) < TollBoothData[tollbooth][tollFee])
			return SendWarningMessage(playerid, "Você não tem %s para poder pagar o pedágio.", FormatNumber(TollBoothData[tollbooth][tollFee]));

		if(!TollBoothData[tollbooth][tollWorking])
			return SendWarningMessage(playerid, "O pedágio está trancado por alguma emergência policial, por favor aguarde.");

		SendGreenMessage(playerid, "Você pagou %s para o atendente, boa viagem.", FormatNumber(TollBoothData[tollbooth][tollFee]));
		
		GiveScriptedMoney(playerid, -TollBoothData[tollbooth][tollFee]);
		TollBoothData[tollbooth][tollPayments] += TollBoothData[tollbooth][tollFee];
		Tax_AddMoney(TollBoothData[tollbooth][tollFee]);

		TollBooth_Operate(tollbooth, object, left);
	}
	else
	{
		TollBooth_Operate(tollbooth, object, left);
		GameTextForPlayer(playerid, "~y~Passagem~n~~g~liberada", 2500, 6);
	}

	return 1;
}

TollBooth_Operate(tollbooth, object, left)
{
	if(object == -1 || !ObjectData[object][objectExists])
	{
		SendAdminMessage(COLOR_WARNING, "AdminAlert: Erro ao operar cancela no pedágio de %s. (001)", TollBoothData[tollbooth][tollName]);
		return 0;
	}

	if(!left)
	{
		if(TollBoothData[tollbooth][tollRightOpen])
			return 0;

		TollBoothData[tollbooth][tollRightOpen] = true;
	}
	else
	{
		if(TollBoothData[tollbooth][tollLeftOpen])
			return 0;

		TollBoothData[tollbooth][tollLeftOpen] = true;
	}

	//moveobject
	MoveDynamicObject(ObjectData[object][objectObject], ObjectData[object][objectPos][0], ObjectData[object][objectPos][1], ObjectData[object][objectPos][2] + 0.05, 0.05, ObjectData[object][objectRPos][0], ObjectData[object][objectRPos][1] - 90.0, ObjectData[object][objectRPos][2]);

	SetTimerEx("CloseTollBooth", 6500, false, "ddd", tollbooth, object, left);

	return 1;
}

TollBooth_ResetEst()
{
	for(new i = 0; i < sizeof(TollBoothData); i++)
	{
 		TollBoothData[i][tollPayments] = 0;
 		TollBoothData[i][tollClosedTime] = 0;
	}
	return 1;
}

TollBooth_Timer()
{
	for(new i = 0; i < sizeof(TollBoothData); i++)
	{
		if(!TollBoothData[i][tollWorking])
			TollBoothData[i][tollClosedTime]++;
	}

	return 1;
}

TollBooth_LoadLEDs()
{
	for(new i = 0; i < sizeof(TollBoothData); i++)
	{
 		TollBooth_RefreshLED(i);
	}
	return 1;
}

TollBooth_RefreshLED(tollbooth)
{
	new led1, led2;

	switch(tollbooth)
	{
		case 0: //constitution bridge
		{
			led1 = Object_GetID(5604);
			led2 = Object_GetID(5605);
		}
		case 1: //the gateway bridge
		{
			led1 = Object_GetID(5642);
			led2 = Object_GetID(5643);
		}
		case 2: //taylor bridge
		{
			led1 = Object_GetID(5730);
			led2 = Object_GetID(5733);
		}
	}

	if(TollBoothData[tollbooth][tollWorking])
	{
		new string[55];
		format(string, sizeof(string), "Toll Booth\nAll Vehicles\nUS$ %d.00%s", TollBoothData[tollbooth][tollFee], TollBoothData[tollbooth][tollExpressWay] ? ("\nExpress Way") : (""));
		SetDynamicObjectMaterialText(ObjectData[led1][objectObject], 0, string, OBJECT_MATERIAL_SIZE_512x256, "Microsoft Yi Baiti", 35, 1, 0xFFADA87B, 0, 1);
		SetDynamicObjectMaterialText(ObjectData[led2][objectObject], 0, string, OBJECT_MATERIAL_SIZE_512x256, "Microsoft Yi Baiti", 35, 1, 0xFFADA87B, 0, 1);
	}
	else
	{
		SetDynamicObjectMaterialText(ObjectData[led1][objectObject], 0, "Toll Booth\nClosed for\nEmergency", OBJECT_MATERIAL_SIZE_512x256, "Microsoft Yi Baiti", 40, 1, 0xFFFF0000, 0, 1);
		SetDynamicObjectMaterialText(ObjectData[led2][objectObject], 0, "Toll Booth\nClosed for\nEmergency", OBJECT_MATERIAL_SIZE_512x256, "Microsoft Yi Baiti", 40, 1, 0xFFFF0000, 0, 1);
	}

	return 1;
}

TollBooth_Emergency(playerid)
{
	return TollBooth_Nearest(playerid);
}

TollBooth_ExpressWay(playerid, areaid)
{
	if(!IsPlayerInAnyVehicle(playerid))
		return 0;

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerVirtualWorld(playerid) != 0 && GetPlayerInterior(playerid) != 0)
		return 0;

	new vehicle = GetPlayerVehicleID(playerid);

	if(VehicleData[vehicle][vehicleExpressWay])
	{
		new string[32], Float:pos[3];
		GetVehiclePos(GetPlayerVehicleID(playerid), pos[0], pos[1], pos[2]);
	
		//Constitution Bridge
		if(areaid == ConstitutionRight)
		{
			if(!(18.0 <= pos[2] <= 19.0) || !TollBoothData[0][tollExpressWay])
				return 0;

			if(VehicleData[vehicle][vehicleExpressMoney] < TollBoothData[0][tollFee])
				return SendWarningMessage(playerid, "Seu ExpressWay não possui %s de crédito para pagar o pedágio.", FormatNumber(TollBoothData[0][tollFee]));

			if(!TollBoothData[0][tollWorking])
				return SendWarningMessage(playerid, "O pedágio está trancado por alguma emergência policial, por favor aguarde.");

			VehicleData[vehicle][vehicleExpressMoney] -= TollBoothData[0][tollFee];
			TollBoothData[0][tollPayments] += TollBoothData[0][tollFee];
			Tax_AddMoney(TollBoothData[0][tollFee]);

			format(string, sizeof(string), "~y~ExpressWay~n~~r~-$%d", TollBoothData[0][tollFee]);
			GameTextForPlayer(playerid, string, 2500, 6);
			PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);

			TollBooth_Operate(0, Object_GetID(5595), 0);
			Vehicle_Save(vehicle);
		}
		else if(areaid == ConstitutionLeft)
		{
			if(!(18.0 <= pos[2] <= 19.0) || !TollBoothData[0][tollExpressWay])
				return 0;

			if(VehicleData[vehicle][vehicleExpressMoney] < TollBoothData[0][tollFee])
				return SendWarningMessage(playerid, "Seu ExpressWay não possui %s de crédito para pagar o pedágio.", FormatNumber(TollBoothData[0][tollFee]));

			if(!TollBoothData[0][tollWorking])
				return SendWarningMessage(playerid, "O pedágio está trancado por alguma emergência policial, por favor aguarde.");

			VehicleData[vehicle][vehicleExpressMoney] -= TollBoothData[0][tollFee];
			TollBoothData[0][tollPayments] += TollBoothData[0][tollFee];
			Tax_AddMoney(TollBoothData[0][tollFee]);

			format(string, sizeof(string), "~y~ExpressWay~n~~r~-$%d", TollBoothData[0][tollFee]);
			GameTextForPlayer(playerid, string, 2500, 6);
			PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);

			TollBooth_Operate(0, Object_GetID(5596), 1);
			Vehicle_Save(vehicle);
		}
		//The Gateway Bridge
		else if(areaid == GatewayRight)
		{
			if(!(11.0 <= pos[2] <= 12.8) || !TollBoothData[1][tollExpressWay])
				return 0;

			if(VehicleData[vehicle][vehicleExpressMoney] < TollBoothData[1][tollFee])
				return SendWarningMessage(playerid, "Seu ExpressWay não possui %s de crédito para pagar o pedágio.", FormatNumber(TollBoothData[1][tollFee]));

			if(!TollBoothData[1][tollWorking])
				return SendWarningMessage(playerid, "O pedágio está trancado por alguma emergência policial, por favor aguarde.");

			VehicleData[vehicle][vehicleExpressMoney] -= TollBoothData[1][tollFee];
			TollBoothData[1][tollPayments] += TollBoothData[1][tollFee];
			Tax_AddMoney(TollBoothData[1][tollFee]);

			format(string, sizeof(string), "~y~ExpressWay~n~~r~-$%d", TollBoothData[1][tollFee]);
			GameTextForPlayer(playerid, string, 2500, 6);
			PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);

			TollBooth_Operate(1, Object_GetID(5640), 0);
			Vehicle_Save(vehicle);
		}
		else if(areaid == GatewayLeft)
		{
			if(!(11.0 <= pos[2] <= 12.8) || !TollBoothData[1][tollExpressWay])
				return 0;

			if(VehicleData[vehicle][vehicleExpressMoney] < TollBoothData[1][tollFee])
				return SendWarningMessage(playerid, "Seu ExpressWay não possui %s de crédito para pagar o pedágio.", FormatNumber(TollBoothData[1][tollFee]));

			if(!TollBoothData[1][tollWorking])
				return SendWarningMessage(playerid, "O pedágio está trancado por alguma emergência policial, por favor aguarde.");

			VehicleData[vehicle][vehicleExpressMoney] -= TollBoothData[1][tollFee];
			TollBoothData[1][tollPayments] += TollBoothData[1][tollFee];
			Tax_AddMoney(TollBoothData[1][tollFee]);

			format(string, sizeof(string), "~y~ExpressWay~n~~r~-$%d", TollBoothData[1][tollFee]);
			GameTextForPlayer(playerid, string, 2500, 6);
			PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);

			TollBooth_Operate(1, Object_GetID(5641), 1);
			Vehicle_Save(vehicle);
		}		
		//Taylor Bridge
		else if(areaid == TaylorRight)
		{
			if(!(12.2432 <= pos[2] <= 12.6087) || !TollBoothData[2][tollExpressWay])
				return 0;

			if(VehicleData[vehicle][vehicleExpressMoney] < TollBoothData[2][tollFee])
				return SendWarningMessage(playerid, "Seu ExpressWay não possui %s de crédito para pagar o pedágio.", FormatNumber(TollBoothData[2][tollFee]));

			if(!TollBoothData[2][tollWorking])
				return SendWarningMessage(playerid, "O pedágio está trancado por alguma emergência policial, por favor aguarde.");

			VehicleData[vehicle][vehicleExpressMoney] -= TollBoothData[2][tollFee];
			TollBoothData[2][tollPayments] += TollBoothData[2][tollFee];
			Tax_AddMoney(TollBoothData[2][tollFee]);

			format(string, sizeof(string), "~y~ExpressWay~n~~r~-$%d", TollBoothData[2][tollFee]);
			GameTextForPlayer(playerid, string, 2500, 6);
			PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);

			TollBooth_Operate(2, Object_GetID(5734), 0);
			Vehicle_Save(vehicle);
		}
		else if(areaid == TaylorLeft)
		{
			if(!(18.9431 <= pos[2] <= 19.9817) || !TollBoothData[2][tollExpressWay])
				return 0;

			if(VehicleData[vehicle][vehicleExpressMoney] < TollBoothData[2][tollFee])
				return SendWarningMessage(playerid, "Seu ExpressWay não possui %s de crédito para pagar o pedágio.", FormatNumber(TollBoothData[2][tollFee]));

			if(!TollBoothData[2][tollWorking])
				return SendWarningMessage(playerid, "O pedágio está trancado por alguma emergência policial, por favor aguarde.");

			VehicleData[vehicle][vehicleExpressMoney] -= TollBoothData[2][tollFee];
			TollBoothData[2][tollPayments] += TollBoothData[2][tollFee];
			Tax_AddMoney(TollBoothData[2][tollFee]);

			format(string, sizeof(string), "~y~ExpressWay~n~~r~-$%d", TollBoothData[2][tollFee]);
			GameTextForPlayer(playerid, string, 2500, 6);
			PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);

			TollBooth_Operate(2, Object_GetID(5735), 1);
			Vehicle_Save(vehicle);
		}
		// ..
	}

	return 1;
}

/* • - • Publics • - • */
this::CloseTollBooth(tollbooth, object, left)
{
	if(object == -1 || !ObjectData[object][objectExists])
	{
		SendAdminMessage(COLOR_WARNING, "AdminAlert: Erro ao operar cancela no pedágio de %s. (002)", TollBoothData[tollbooth][tollName]);
		return 0;
	}

	if(!left)
	{
		if(!TollBoothData[tollbooth][tollRightOpen])
			return 0;

		TollBoothData[tollbooth][tollRightOpen] = false;
	}
	else
	{
		if(!TollBoothData[tollbooth][tollLeftOpen])
			return 0;

		TollBoothData[tollbooth][tollLeftOpen] = false;
	}

	//moveobject
	MoveDynamicObject(ObjectData[object][objectObject], ObjectData[object][objectPos][0], ObjectData[object][objectPos][1], ObjectData[object][objectPos][2], 0.05, ObjectData[object][objectRPos][0], ObjectData[object][objectRPos][1], ObjectData[object][objectRPos][2]);
	return 1;
}

this::RestoreTollBooth(tollbooth)
{
	if(TollBoothData[tollbooth][tollWorking])
		return 0;

	foreach(new i : Player) if(PlayerData[i][pLogged])
	{
		if(IsPlayerInRangeOfPoint(i, 1.8, TollBoothData[tollbooth][tollPayRightX], TollBoothData[tollbooth][tollPayRightY], TollBoothData[tollbooth][tollPayRightZ]) || IsPlayerInRangeOfPoint(i, 1.8, TollBoothData[tollbooth][tollPayLeftX], TollBoothData[tollbooth][tollPayLeftY], TollBoothData[tollbooth][tollPayLeftZ]))
		{
			if(IsPlayerInAnyVehicle(i) && GetPlayerState(i) == PLAYER_STATE_DRIVER)
				SendGreenMessage(i, "Pedágio '%s' liberado, você já pode realizar o pagamento da passagem (/pagarpedagio).",  TollBoothData[tollbooth][tollName]);
		}
	}

	TollBoothData[tollbooth][tollWorking] = true;
	TollBooth_RefreshLED(tollbooth);

	return 1;
}